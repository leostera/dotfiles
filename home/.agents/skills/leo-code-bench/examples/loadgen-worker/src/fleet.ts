import { DurableObject } from "cloudflare:workers";
import type { DriverConfig, DriverResult } from "./driver.ts";
import { Histogram } from "./histogram.ts";
import type { Env } from "./index.ts";

/** Regions drivers are spread over. locationHint is advisory: placement is not guaranteed. */
const LOCATIONS = ["wnam", "enam", "weur", "eeur", "apac"] as const;

export interface FleetResult extends DriverResult {
  /** Drivers that failed outright (as opposed to counting their failed calls). */
  readonly failedDrivers: number;
}

/**
 * Starts and gathers a group of drivers, so one measurement can use thousands of them without the
 * entry Worker fanning out to all of them itself: the Worker starts fleets, each fleet its drivers.
 */
export class BenchFleet extends DurableObject<Env> {
  async prepare(runName: string, configs: readonly Omit<DriverConfig, "startAt">[]): Promise<number> {
    const seeded = await Promise.all(configs.map((config) => driverFor(this.env, runName, config.driverIndex).prepare(config)));
    return seeded.reduce((sum, n) => sum + n, 0);
  }

  async measure(runName: string, configs: readonly DriverConfig[]): Promise<FleetResult> {
    const settled = await Promise.allSettled(configs.map((config) => driverFor(this.env, runName, config.driverIndex).measure(config)));
    const results = settled.flatMap((s) => (s.status === "fulfilled" ? [s.value] : []));
    const failures = settled.flatMap((s) => (s.status === "rejected" ? [`driver failed: ${String(s.reason).slice(0, 200)}`] : []));
    return mergeResults(results, failures);
  }
}

function driverFor(env: Env, runName: string, driverIndex: number) {
  // Fresh names per run: the location hint only applies when the object is first created.
  const id = env.BENCH_DRIVERS.idFromName(`${runName}-driver-${driverIndex}`);
  return env.BENCH_DRIVERS.get(id, { locationHint: LOCATIONS[driverIndex % LOCATIONS.length]! });
}

export function mergeResults(results: readonly DriverResult[], failures: readonly string[]): FleetResult {
  const latency = new Histogram();
  const errorsByMessage: Record<string, number> = {};
  let successes = 0;
  let errors = 0;
  let bytes = 0;
  let elapsedMs = 0;
  let failedDrivers = failures.length;
  for (const result of results) {
    successes += result.successes;
    errors += result.errors;
    bytes += result.bytes;
    elapsedMs = Math.max(elapsedMs, result.elapsedMs);
    latency.merge(result.latency);
    for (const [message, count] of Object.entries(result.errorsByMessage)) errorsByMessage[message] = (errorsByMessage[message] ?? 0) + count;
    if ("failedDrivers" in result) failedDrivers += (result as FleetResult).failedDrivers;
  }
  for (const message of failures) errorsByMessage[message] = (errorsByMessage[message] ?? 0) + 1;
  return { successes, errors, bytes, elapsedMs, latency: latency.toData(), errorsByMessage, failedDrivers };
}
