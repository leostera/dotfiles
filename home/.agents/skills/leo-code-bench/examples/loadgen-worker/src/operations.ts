/**
 * The operations under test. Replace these with what your users actually do, through the same
 * public interface they use (HTTP requests here). Internal RPCs are for profiling, not for claims.
 *
 * Each operation returns the bytes it moved, and throws on failure with a message that names the
 * status, so errors can be counted by cause.
 */
export const OPERATIONS = ["read", "write"] as const;
export type OperationName = (typeof OPERATIONS)[number];

export const DISTRIBUTIONS = ["uniform", "hot", "few-keys"] as const;
export type Distribution = (typeof DISTRIBUTIONS)[number];

export interface TargetRequest {
  /** Origin of the system under test, such as https://candidate.example.com. */
  readonly origin: string;
  /** Optional credential for the target, sent as a bearer token. Never written to results. */
  readonly token: string | null;
}

type Operation = (target: TargetRequest, key: string, payload: string) => Promise<number>;

const operations: Record<OperationName, Operation> = {
  async read(target, key) {
    const response = await fetch(`${target.origin}/items/${encodeURIComponent(key)}`, { headers: headersFor(target) });
    const body = await response.arrayBuffer();
    if (!response.ok) throw new Error(`read: HTTP ${response.status}`);
    return body.byteLength;
  },
  async write(target, key, payload) {
    const response = await fetch(`${target.origin}/items/${encodeURIComponent(key)}`, { method: "PUT", headers: headersFor(target), body: payload });
    await response.arrayBuffer();
    if (!response.ok) throw new Error(`write: HTTP ${response.status}`);
    return payload.length;
  },
};

export function operation(name: OperationName): Operation {
  return operations[name];
}

function headersFor(target: TargetRequest): HeadersInit {
  return target.token ? { authorization: `Bearer ${target.token}` } : {};
}

/**
 * The key for the n-th call. Uniform spreads over keyCount keys, hot sends everything to one key,
 * and few-keys models a control plane that reads and writes a handful of records.
 */
export function keyFor(distribution: Distribution, keyCount: number, n: number): string {
  switch (distribution) {
    case "uniform":
      return `key-${mix(n) % keyCount}`;
    case "hot":
      return "hot-key";
    case "few-keys":
      return `config-${n % 8}`;
  }
}

/**
 * Every key a distribution can produce, striped over drivers: driver i of n yields every n-th key.
 * A read benchmark seeds these first, so it measures reads of data that exists, not misses.
 */
export function* seedKeys(distribution: Distribution, keyCount: number, driverIndex: number, driverCount: number): Generator<string> {
  const total = distribution === "uniform" ? keyCount : distribution === "few-keys" ? 8 : 1;
  for (let i = driverIndex; i < total; i += driverCount) yield distribution === "uniform" ? `key-${i}` : distribution === "few-keys" ? `config-${i}` : "hot-key";
}

/** A cheap integer hash, so consecutive calls don't walk the keyspace in order. */
function mix(n: number): number {
  let x = n | 0;
  x = Math.imul(x ^ (x >>> 16), 0x45d9f3b);
  x = Math.imul(x ^ (x >>> 16), 0x45d9f3b);
  return (x ^ (x >>> 16)) >>> 0;
}
