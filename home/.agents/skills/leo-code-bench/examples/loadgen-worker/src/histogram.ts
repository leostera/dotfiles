/**
 * Latency histogram with 1 ms buckets. Stored sparsely (only non-empty buckets), so the results of
 * thousands of drivers stay small enough to gather and merge.
 */
export const MAX_BUCKET_MS = 120_000;

export interface HistogramData {
  /**
   * Pairs of [bucket in whole milliseconds, count], sorted by bucket; the last bucket holds 120 s
   * and above. Typed as plain arrays because RPC serialization doesn't preserve tuple types.
   */
  readonly buckets: readonly (readonly number[])[];
  /** The largest latency observed, unbucketed. */
  readonly maxMs: number;
}

export interface Latency {
  readonly p50: number;
  readonly p95: number;
  readonly p99: number;
  readonly max: number;
}

export class Histogram {
  private readonly counts = new Map<number, number>();
  private maxMs = 0;

  record(ms: number): void {
    const bucket = Math.min(MAX_BUCKET_MS, Math.max(0, Math.floor(ms)));
    this.counts.set(bucket, (this.counts.get(bucket) ?? 0) + 1);
    if (ms > this.maxMs) this.maxMs = ms;
  }

  merge(other: HistogramData): void {
    for (const [bucket = 0, count = 0] of other.buckets) this.counts.set(bucket, (this.counts.get(bucket) ?? 0) + count);
    if (other.maxMs > this.maxMs) this.maxMs = other.maxMs;
  }

  toData(): HistogramData {
    return { buckets: [...this.counts].sort((a, b) => a[0] - b[0]), maxMs: this.maxMs };
  }
}

/** Percentiles are bucket estimates (1 ms resolution); max is exact. Zero samples gives zeros. */
export function latencyOf(data: HistogramData): Latency {
  const total = data.buckets.reduce((sum, [, count = 0]) => sum + count, 0);
  const at = (p: number): number => {
    if (total === 0) return 0;
    const rank = Math.ceil(p * total);
    let seen = 0;
    for (const [bucket = 0, count = 0] of data.buckets) {
      seen += count;
      if (seen >= rank) return bucket;
    }
    return data.buckets.at(-1)?.[0] ?? 0;
  };
  return { p50: at(0.5), p95: at(0.95), p99: at(0.99), max: Math.round(data.maxMs * 100) / 100 };
}
