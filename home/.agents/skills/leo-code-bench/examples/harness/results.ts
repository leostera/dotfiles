/**
 * The results file: one JSON document per run, rewritten after every point, so an interrupted run
 * still leaves usable data. Bump SCHEMA_VERSION when the shape changes, and teach plot.ts to read
 * (or migrate) the old versions.
 */
import { spawnSync } from "node:child_process";
import { mkdirSync, renameSync, writeFileSync } from "node:fs";
import { dirname } from "node:path";

export const SCHEMA_VERSION = 1;

export interface Latency {
  readonly p50: number;
  readonly p95: number;
  readonly p99: number;
  readonly max: number;
}

/** One measured point: one target, one operation and distribution, one concurrency level. */
export interface Point {
  /** The system under test, by the label given on the command line, such as "baseline" or "candidate". */
  readonly target: string;
  readonly operation: string;
  readonly distribution: string;
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
  /** Set when this point broke the system (error rate over the threshold): the ramp stopped here. */
  readonly broke: boolean;
}

export interface Provenance {
  /** Commit of the repository the harness runs from, and whether its tree had uncommitted changes. */
  readonly commit: string;
  readonly dirty: boolean;
  /** What each target label was: an origin plus whatever identifies the deployed version. */
  readonly targets: Readonly<Record<string, { readonly origin: string; readonly version: string | null }>>;
  readonly loadgen: string;
  /** Where the harness ran. Deliberately not the hostname, which can identify a person's machine. */
  readonly runner: { readonly platform: string; readonly arch: string; readonly runtime: string };
}

export interface RunFile {
  readonly schemaVersion: typeof SCHEMA_VERSION;
  readonly run: string;
  readonly generatedAt: string;
  readonly provenance: Provenance;
  /** Every parameter that shaped the run, so it can be repeated exactly. */
  readonly config: Readonly<Record<string, unknown>>;
  /** How the numbers were produced, in sentences a reader of the results can check. */
  readonly notes: readonly string[];
  readonly points: readonly Point[];
}

export function gitProvenance(): { commit: string; dirty: boolean } {
  const git = (...args: string[]) => spawnSync("git", args, { encoding: "utf8" });
  const head = git("rev-parse", "HEAD");
  const status = git("status", "--porcelain");
  return { commit: head.status === 0 ? head.stdout.trim() : "unknown", dirty: status.status !== 0 || status.stdout.trim() !== "" };
}

/** Writes atomically: a crash mid-write never leaves a truncated results file. */
export function saveRun(path: string, run: RunFile): void {
  mkdirSync(dirname(path), { recursive: true });
  const temporary = `${path}.tmp`;
  writeFileSync(temporary, `${JSON.stringify(run, null, 2)}\n`);
  renameSync(temporary, path);
}
