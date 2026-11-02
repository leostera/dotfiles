/**
 * Runs a staged benchmark against one or more targets through the load generator, and writes
 * results after every point.
 *
 *   bun run harness/run.ts \
 *     --loadgen https://loadgen.example.com \
 *     --target baseline=https://baseline.example.com \
 *     --target candidate=https://candidate.example.com \
 *     --operations write,read --distributions uniform,hot \
 *     --concurrency 1,16,64,256,1024 --duration-ms 10000
 *
 * Environment: BENCH_TOKEN (the load generator's token) and, behind Cloudflare Access,
 * BENCH_ACCESS_TOKEN (from `cloudflared access token -app=<loadgen>`). Neither is ever written to
 * results. Every flag is optional except --loadgen and --target. Run it from the repository root:
 * results go to bench/results/<run>.json unless --out says otherwise.
 */
import { join } from "node:path";
import { parseArgs } from "node:util";
import { SCHEMA_VERSION, gitProvenance, saveRun, type Point, type RunFile } from "./results.ts";

const { values } = parseArgs({
  options: {
    loadgen: { type: "string" },
    target: { type: "string", multiple: true },
    "target-version": { type: "string", multiple: true },
    run: { type: "string" },
    operations: { type: "string", default: "write,read" },
    distributions: { type: "string", default: "uniform,hot" },
    concurrency: { type: "string", default: "1,16,64,256,1024" },
    "duration-ms": { type: "string", default: "10000" },
    "key-count": { type: "string", default: "10000" },
    "payload-bytes": { type: "string", default: "1024" },
    warmup: { type: "boolean", default: true },
    "no-warmup": { type: "boolean", default: false },
    "break-error-rate": { type: "string", default: "0.5" },
    out: { type: "string", default: join("bench", "results") },
  },
});

const loadgen = required(values.loadgen, "--loadgen").replace(/\/$/, "");
const targets = new Map((values.target ?? []).map((spec) => splitPair(spec, "--target")));
if (targets.size === 0) throw new Error("Pass at least one --target label=https://origin");
const versions = new Map((values["target-version"] ?? []).map((spec) => splitPair(spec, "--target-version")));
const token = required(process.env.BENCH_TOKEN, "BENCH_TOKEN");
const accessToken = process.env.BENCH_ACCESS_TOKEN;

const config = {
  operations: list(values.operations),
  distributions: list(values.distributions),
  concurrency: list(values.concurrency).map(Number),
  durationMs: Number(values["duration-ms"]),
  keyCount: Number(values["key-count"]),
  payloadBytes: Number(values["payload-bytes"]),
  warmup: values.warmup && !values["no-warmup"],
  breakErrorRate: Number(values["break-error-rate"]),
};
const run = values.run ?? `run-${new Date().toISOString().replaceAll(/[:.]/g, "-")}`;
const resultsPath = join(values.out, `${run}.json`);
const points: Point[] = [];
const { commit, dirty } = gitProvenance();

const notes = [
  "One call is one user-level request to the target, issued by closed-loop driver Durable Objects with at most 16 calls in flight each.",
  "Drivers are spread over several regions with locationHint, which is advisory, not a placement guarantee.",
  "Before a read is measured, every key the distribution can read is written once, outside the measured window (seededKeys).",
  "Each level runs once unmeasured first (unless --no-warmup), then is measured for durationMs; the ramp for a series stops at the first level whose error rate reaches breakErrorRate.",
  "Latency percentiles are 1 ms histogram estimates over successful calls; max is exact. Failed calls are counted by message in errorsByMessage.",
];

function save(): void {
  const file: RunFile = {
    schemaVersion: SCHEMA_VERSION,
    run,
    generatedAt: new Date().toISOString(),
    provenance: {
      commit,
      dirty,
      targets: Object.fromEntries([...targets].map(([label, origin]) => [label, { origin, version: versions.get(label) ?? null }])),
      loadgen,
      runner: { platform: process.platform, arch: process.arch, runtime: process.versions.bun ? `bun ${process.versions.bun}` : `node ${process.version}` },
    },
    config,
    notes,
    points,
  };
  saveRun(resultsPath, file);
}

async function measure(label: string, origin: string, operation: string, distribution: string, concurrency: number): Promise<Omit<Point, "target" | "broke">> {
  const body = JSON.stringify({ run: `${run}-${label}-${operation}-${distribution}-${concurrency}`.slice(0, 80), targetOrigin: origin, operation, distribution, concurrency, durationMs: config.durationMs, keyCount: config.keyCount, payloadBytes: config.payloadBytes });
  const headers = { authorization: `Bearer ${token}`, "content-type": "application/json", ...(accessToken ? { "cf-access-token": accessToken } : {}) };
  // One retry: a failed measurement request is the harness's problem, not a data point.
  for (let attempt = 1; ; attempt++) {
    try {
      const response = await fetch(`${loadgen}/measure`, { method: "POST", headers, body, signal: AbortSignal.timeout(config.durationMs + 120_000) });
      const text = await response.text();
      if (!response.ok) throw new Error(`loadgen answered ${response.status}: ${text.slice(0, 200)}`);
      return JSON.parse(text) as Omit<Point, "target" | "broke">;
    } catch (error) {
      if (attempt >= 2) throw error;
      console.error(`  ↻ retrying ${label} ${operation} ${distribution} c=${concurrency}: ${String(error).slice(0, 200)}`);
    }
  }
}

const started = performance.now();
console.log(`Run ${run} · commit ${commit.slice(0, 12)}${dirty ? "+dirty" : ""} · results ${resultsPath}`);
for (const [label, origin] of targets) {
  for (const operation of config.operations) {
    for (const distribution of config.distributions) {
      for (const concurrency of config.concurrency) {
        const tag = `${label} ${operation} ${distribution} c=${concurrency}`;
        let measured: Omit<Point, "target" | "broke">;
        try {
          if (config.warmup) await measure(label, origin, operation, distribution, concurrency);
          measured = await measure(label, origin, operation, distribution, concurrency);
        } catch (error) {
          // Logged and left out: the rest of the suite still runs.
          console.error(`✗ ${tag}: ${String(error).slice(0, 200)}`);
          continue;
        }
        const total = measured.successes + measured.errors;
        const broke = total === 0 || measured.errors / total >= config.breakErrorRate;
        points.push({ target: label, ...measured, broke });
        save();
        console.log(progressLine(broke ? "✗" : "✓", tag, measured));
        if (broke) {
          console.log(`  ↳ ${tag} broke: ${topErrors(measured.errorsByMessage)}. Stopping this ramp.`);
          break;
        }
      }
    }
  }
}
save();
console.log(`Saved ${points.length} points in ${((performance.now() - started) / 1000).toFixed(1)} s → ${resultsPath}`);

function progressLine(mark: string, tag: string, p: Omit<Point, "target" | "broke">): string {
  const n = (x: number) => Math.round(x).toLocaleString("en-US");
  return `${mark} ${tag.padEnd(40)} ${n(p.operationsPerSecond).padStart(9)} ops/s  p50 ${n(p.latencyMs.p50)} ms  p99 ${n(p.latencyMs.p99)} ms  max ${n(p.latencyMs.max)} ms  errors ${n(p.errors)}  drivers ${p.driverCount}`;
}

function topErrors(errors: Readonly<Record<string, number>>): string {
  const sorted = Object.entries(errors).sort((a, b) => b[1] - a[1]).slice(0, 3);
  return sorted.length ? sorted.map(([message, count]) => `${count}× ${message}`).join("; ") : "no successful calls";
}

function splitPair(spec: string, flag: string): [string, string] {
  const at = spec.indexOf("=");
  if (at <= 0) throw new Error(`${flag} must look like label=value, got "${spec}"`);
  return [spec.slice(0, at), spec.slice(at + 1).replace(/\/$/, "")];
}

function list(value: string): string[] {
  return value.split(",").map((s) => s.trim()).filter(Boolean);
}

function required(value: string | undefined, name: string): string {
  if (!value) throw new Error(`Set ${name}.`);
  return value;
}
