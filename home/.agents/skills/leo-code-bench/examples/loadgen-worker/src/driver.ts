import { DurableObject } from "cloudflare:workers";
import { Histogram, type HistogramData } from "./histogram.ts";
import { keyFor, operation, seedKeys, type Distribution, type OperationName, type TargetRequest } from "./operations.ts";

export interface DriverConfig {
  readonly target: TargetRequest;
  readonly operation: OperationName;
  readonly distribution: Distribution;
  readonly keyCount: number;
  readonly payloadBytes: number;
  readonly driverIndex: number;
  readonly driverCount: number;
  /** Calls this driver keeps in flight. Capped, so the driver is never what gets measured. */
  readonly inFlight: number;
  readonly durationMs: number;
  /** Wall-clock start shared by every driver, so they all measure the same window. */
  readonly startAt: number;
}

export interface DriverResult {
  readonly successes: number;
  readonly errors: number;
  readonly bytes: number;
  readonly elapsedMs: number;
  /** Latency of successful calls only; failures are counted by message instead. */
  readonly latency: HistogramData;
  /** Failure counts by message, for up to MAX_ERROR_KINDS distinct messages. */
  readonly errorsByMessage: Readonly<Record<string, number>>;
}

const MAX_ERROR_KINDS = 10;

/**
 * A closed-loop load generator: `inFlight` workers each issue one call, wait for it, and issue the
 * next, until the window ends. Drivers are created with a locationHint, so load comes from several
 * regions. A hint applies only when a Durable Object is first created, so every run uses fresh
 * driver names.
 *
 * Clock note: inside Workers, time only advances across I/O. Each latency spans an awaited fetch,
 * so it is meaningful; CPU-only work between calls doesn't show up in Date.now().
 */
export class BenchDriver extends DurableObject {
  /**
   * Before a read is measured, writes this driver's stripe of the keys the workload will read, with
   * the same number of calls in flight, retrying each with backoff. Throws if seeding fails, so a
   * point is never measured against missing data.
   */
  async prepare(config: Omit<DriverConfig, "startAt">): Promise<number> {
    if (config.operation !== "read") return 0;
    const write = operation("write");
    const payload = "x".repeat(config.payloadBytes);
    const keys = seedKeys(config.distribution, config.keyCount, config.driverIndex, config.driverCount);
    let seeded = 0;
    const worker = async (): Promise<void> => {
      for (let next = keys.next(); !next.done; next = keys.next()) {
        for (let attempt = 0; ; attempt++) {
          try {
            await write(config.target, next.value, payload);
            seeded++;
            break;
          } catch (error) {
            if (attempt >= 5) throw error;
            await new Promise((resolve) => setTimeout(resolve, 100 * 2 ** attempt));
          }
        }
      }
    };
    await Promise.all(Array.from({ length: config.inFlight }, worker));
    return seeded;
  }

  async measure(config: DriverConfig): Promise<DriverResult> {
    const waitMs = config.startAt - Date.now();
    if (waitMs > 0) await new Promise((resolve) => setTimeout(resolve, waitMs));

    const run = operation(config.operation);
    const payload = "x".repeat(config.payloadBytes);
    const latency = new Histogram();
    const errorsByMessage = new Map<string, number>();
    let successes = 0;
    let errors = 0;
    let bytes = 0;
    let sequence = config.driverIndex * 1_000_003;

    const startedAt = Date.now();
    const stopAt = startedAt + config.durationMs;
    const worker = async (): Promise<void> => {
      while (Date.now() < stopAt) {
        const key = keyFor(config.distribution, config.keyCount, sequence++);
        const before = performance.now();
        try {
          bytes += await run(config.target, key, payload);
          latency.record(performance.now() - before);
          successes++;
        } catch (error) {
          errors++;
          const message = (error instanceof Error ? error.message : String(error)).slice(0, 200);
          if (errorsByMessage.has(message) || errorsByMessage.size < MAX_ERROR_KINDS) errorsByMessage.set(message, (errorsByMessage.get(message) ?? 0) + 1);
        }
      }
    };
    await Promise.all(Array.from({ length: config.inFlight }, worker));

    return {
      successes,
      errors,
      bytes,
      elapsedMs: Date.now() - startedAt,
      latency: latency.toData(),
      errorsByMessage: Object.fromEntries(errorsByMessage),
    };
  }
}
