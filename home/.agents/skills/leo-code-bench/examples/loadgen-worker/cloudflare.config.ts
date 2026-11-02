import { bindings, defineConfig, exports } from "cf/config";
import * as entrypoint from "./src/index.ts" with { type: "cf-worker" };

const NAME = process.env.BENCH_WORKER_NAME ?? "loadgen";
/** A custom domain covered by a Cloudflare Access application. */
const HOSTNAME = process.env.BENCH_HOSTNAME;
if (!HOSTNAME) throw new Error("Set BENCH_HOSTNAME to a hostname protected by Cloudflare Access.");

export default defineConfig(() => ({
  worker: {
    name: NAME,
    // Only the Access-protected hostname: workers.dev and preview URLs would bypass Access.
    domains: [HOSTNAME],
    workersDev: false,
    previewUrls: false,
    compatibilityDate: "2026-10-29",
    entrypoint,
    env: {
      BENCH_DRIVERS: bindings.durableObject({ worker: NAME, exportName: "BenchDriver" }),
      BENCH_FLEETS: bindings.durableObject({ worker: NAME, exportName: "BenchFleet" }),
      // From .dev.vars locally, and from --secrets-file on deploy. Never committed.
      BENCH_TOKEN: bindings.secret(),
    },
    exports: {
      BenchDriver: exports.durableObject({ storage: "sqlite" }),
      BenchFleet: exports.durableObject({ storage: "sqlite" }),
    },
    observability: { enabled: true },
  },
}));
