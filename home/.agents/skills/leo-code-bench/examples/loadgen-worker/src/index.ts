/**
 * A distributed load generator on Durable Objects.
 *
 *   POST /measure   one measured point: a target, an operation, a distribution, a concurrency
 *
 * The entry Worker splits the requested concurrency over drivers (at most IN_FLIGHT_PER_DRIVER
 * calls in flight each), groups drivers into fleets, gives every driver the same start time, and
 * merges their histograms into one point. The harness (../harness/run.ts) calls it once per point.
 */
import { BenchDriver, type DriverConfig } from "./driver.ts";
import { BenchFleet, mergeResults, type FleetResult } from "./fleet.ts";
import { latencyOf, type Latency } from "./histogram.ts";
import { DISTRIBUTIONS, OPERATIONS, type Distribution, type OperationName } from "./operations.ts";

export { BenchDriver, BenchFleet };

export interface Env {
  BENCH_DRIVERS: DurableObjectNamespace<BenchDriver>;
  BENCH_FLEETS: DurableObjectNamespace<BenchFleet>;
  /** Guards the endpoints in addition to Access. Set as a secret, never committed. */
  BENCH_TOKEN: string;
  /** Optional credential for the systems under test. */
  TARGET_TOKEN?: string;
}

/**
 * One driver completes only so many calls per second. Keeping each driver's in-flight calls low
 * and adding drivers instead means the target, not the generator, is what saturates.
 */
const IN_FLIGHT_PER_DRIVER = 16;
const DRIVERS_PER_FLEET = 64;
const MAX_DRIVERS = 4_096;

interface MeasureRequest {
  readonly run: string;
  readonly targetOrigin: string;
  readonly operation: OperationName;
  readonly distribution: Distribution;
  readonly concurrency: number;
  readonly durationMs: number;
  readonly keyCount: number;
  readonly payloadBytes: number;
}

export interface MeasuredPoint {
  readonly operation: OperationName;
  readonly distribution: Distribution;
  readonly concurrency: number;
  readonly driverCount: number;
  /** Keys written before the window so reads find data; 0 for writes. */
  readonly seededKeys: number;
  readonly failedDrivers: number;
  readonly successes: number;
  readonly errors: number;
  readonly elapsedMs: number;
  readonly operationsPerSecond: number;
  readonly mebibytesPerSecond: number;
  readonly latencyMs: Latency;
  readonly errorsByMessage: Readonly<Record<string, number>>;
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    if (request.headers.get("authorization") !== `Bearer ${env.BENCH_TOKEN}`) return new Response("Unauthorized", { status: 401 });
    const url = new URL(request.url);
    if (request.method !== "POST" || url.pathname !== "/measure") return new Response("Not found", { status: 404 });
    let input: MeasureRequest;
    try {
      input = parseMeasureRequest(await request.json());
    } catch (error) {
      return Response.json({ error: error instanceof Error ? error.message : "invalid request" }, { status: 400 });
    }
    return Response.json(await measure(env, input));
  },
} satisfies ExportedHandler<Env>;

async function measure(env: Env, input: MeasureRequest): Promise<MeasuredPoint> {
  const driverCount = Math.min(MAX_DRIVERS, Math.ceil(input.concurrency / IN_FLIGHT_PER_DRIVER));
  const inFlight = Math.ceil(input.concurrency / driverCount);
  const fleetCount = Math.ceil(driverCount / DRIVERS_PER_FLEET);
  const target = { origin: input.targetOrigin, token: env.TARGET_TOKEN ?? null };
  const configs: Omit<DriverConfig, "startAt">[] = Array.from({ length: driverCount }, (_, driverIndex) => ({
    target,
    operation: input.operation,
    distribution: input.distribution,
    keyCount: input.keyCount,
    payloadBytes: input.payloadBytes,
    driverIndex,
    driverCount,
    inFlight,
    durationMs: input.durationMs,
  }));
  const fleets = Array.from({ length: fleetCount }, (_, i) => ({
    stub: env.BENCH_FLEETS.get(env.BENCH_FLEETS.idFromName(`${input.run}-fleet-${i}`)),
    configs: configs.slice(i * DRIVERS_PER_FLEET, (i + 1) * DRIVERS_PER_FLEET),
  }));

  // Seed first (reads only), outside the measured window. A seeding failure fails the point.
  const seededKeys = (await Promise.all(fleets.map((fleet) => fleet.stub.prepare(input.run, fleet.configs)))).reduce((sum, n) => sum + n, 0);
  // Later with more fleets: every driver must receive the start time before it comes.
  const startAt = Date.now() + 1_000 + 250 * fleetCount;
  const settled = await Promise.allSettled(fleets.map((fleet) => fleet.stub.measure(input.run, fleet.configs.map((config) => ({ ...config, startAt })))));
  const results = settled.flatMap((s) => (s.status === "fulfilled" ? [s.value as FleetResult] : []));
  const failures = settled.flatMap((s) => (s.status === "rejected" ? [`fleet failed: ${String(s.reason).slice(0, 200)}`] : []));
  const merged = mergeResults(results, failures);
  const seconds = Math.max(merged.elapsedMs, 1) / 1000;

  return {
    operation: input.operation,
    distribution: input.distribution,
    concurrency: inFlight * driverCount,
    driverCount,
    seededKeys,
    failedDrivers: merged.failedDrivers,
    successes: merged.successes,
    errors: merged.errors,
    elapsedMs: merged.elapsedMs,
    operationsPerSecond: merged.successes / seconds,
    mebibytesPerSecond: merged.bytes / (1024 * 1024) / seconds,
    latencyMs: latencyOf(merged.latency),
    errorsByMessage: merged.errorsByMessage,
  };
}

/** Parses the request body into a trusted MeasureRequest, or throws saying what is wrong. */
function parseMeasureRequest(body: unknown): MeasureRequest {
  if (typeof body !== "object" || body === null) throw new Error("body must be a JSON object");
  const b = body as Record<string, unknown>;
  const text = (name: string, pattern: RegExp): string => {
    const value = b[name];
    if (typeof value !== "string" || !pattern.test(value)) throw new Error(`${name} must match ${pattern}`);
    return value;
  };
  const integer = (name: string, min: number, max: number): number => {
    const value = b[name];
    if (typeof value !== "number" || !Number.isInteger(value) || value < min || value > max) throw new Error(`${name} must be an integer in [${min}, ${max}]`);
    return value;
  };
  const oneOf = <T extends string>(name: string, options: readonly T[]): T => {
    const value = b[name];
    if (!options.includes(value as T)) throw new Error(`${name} must be one of ${options.join(", ")}`);
    return value as T;
  };
  return {
    run: text("run", /^[a-zA-Z0-9_-]{1,80}$/),
    // http is allowed so the generator can be tried locally against a local target.
    targetOrigin: text("targetOrigin", /^https?:\/\/[^/\s]+$/),
    operation: oneOf("operation", OPERATIONS),
    distribution: oneOf("distribution", DISTRIBUTIONS),
    concurrency: integer("concurrency", 1, MAX_DRIVERS * IN_FLIGHT_PER_DRIVER),
    durationMs: integer("durationMs", 1_000, 300_000),
    keyCount: integer("keyCount", 1, 100_000_000),
    payloadBytes: integer("payloadBytes", 0, 32 * 1024 * 1024),
  };
}
