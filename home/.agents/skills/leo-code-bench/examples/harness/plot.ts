/**
 * Draws charts from results files, with no dependencies: for every operation and distribution,
 * throughput and p99 latency against concurrency, one line per target.
 *
 *   bun run harness/plot.ts bench/results/run-a.json [more.json…] --out docs/bench
 *
 * Charts use absolute values on linear axes starting at zero. Concurrency levels are spaced evenly
 * (1, 16, 64, …), which keeps every level readable without a log scale. Never edit the SVGs by
 * hand: change the results or this script, and redraw.
 */
import { mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { join } from "node:path";
import { parseArgs } from "node:util";
import { SCHEMA_VERSION, type Point, type RunFile } from "./results.ts";

const { values, positionals } = parseArgs({ allowPositionals: true, options: { out: { type: "string", default: "docs/bench" } } });
if (positionals.length === 0) throw new Error("Pass one or more results files.");

const points = positionals.flatMap((path) => readRun(path).points);
mkdirSync(values.out, { recursive: true });

const series = groupBy(points, (p) => `${p.operation}-${p.distribution}`);
for (const [name, group] of series) {
  const levels = [...new Set(group.map((p) => p.concurrency))].sort((a, b) => a - b);
  const byTarget = groupBy(group, (p) => p.target);
  writeFileSync(join(values.out, `${name}-throughput.svg`), chart(`${name}: throughput`, "operations per second", levels, byTarget, (p) => p.operationsPerSecond));
  writeFileSync(join(values.out, `${name}-p99.svg`), chart(`${name}: p99 latency`, "milliseconds", levels, byTarget, (p) => p.latencyMs.p99));
  console.log(`✓ ${name}: ${byTarget.size} targets × ${levels.length} levels`);
}

function readRun(path: string): RunFile {
  const run = JSON.parse(readFileSync(path, "utf8")) as RunFile;
  // Migrate older schema versions here when SCHEMA_VERSION changes.
  if (run.schemaVersion !== SCHEMA_VERSION) throw new Error(`${path}: schemaVersion ${run.schemaVersion}, expected ${SCHEMA_VERSION}`);
  return run;
}

function chart(title: string, unit: string, levels: readonly number[], byTarget: ReadonlyMap<string, readonly Point[]>, value: (p: Point) => number): string {
  const width = 720;
  const height = 400;
  const pad = { left: 80, right: 140, top: 40, bottom: 50 };
  const plotW = width - pad.left - pad.right;
  const plotH = height - pad.top - pad.bottom;
  const all = [...byTarget.values()].flat().map(value);
  const yMax = niceCeiling(Math.max(1, ...all));
  const x = (level: number) => pad.left + (levels.length === 1 ? plotW / 2 : (levels.indexOf(level) / (levels.length - 1)) * plotW);
  const y = (v: number) => pad.top + plotH - (v / yMax) * plotH;
  const colors = ["#2563eb", "#f97316", "#16a34a", "#9333ea", "#dc2626", "#0891b2"];
  const n = (v: number) => Math.round(v).toLocaleString("en-US");

  const parts: string[] = [
    `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${width} ${height}" font-family="system-ui, sans-serif" font-size="12">`,
    `<rect width="100%" height="100%" fill="white"/>`,
    `<text x="${pad.left}" y="24" font-size="15" font-weight="600">${escape(title)}</text>`,
  ];
  for (let i = 0; i <= 4; i++) {
    const v = (yMax / 4) * i;
    parts.push(`<line x1="${pad.left}" x2="${pad.left + plotW}" y1="${y(v)}" y2="${y(v)}" stroke="#e5e7eb"/>`);
    parts.push(`<text x="${pad.left - 8}" y="${y(v) + 4}" text-anchor="end" fill="#4b5563">${n(v)}</text>`);
  }
  parts.push(`<text transform="translate(18 ${pad.top + plotH / 2}) rotate(-90)" text-anchor="middle" fill="#4b5563">${escape(unit)}</text>`);
  for (const level of levels) parts.push(`<text x="${x(level)}" y="${pad.top + plotH + 20}" text-anchor="middle" fill="#4b5563">${n(level)}</text>`);
  parts.push(`<text x="${pad.left + plotW / 2}" y="${height - 10}" text-anchor="middle" fill="#4b5563">calls in flight</text>`);

  [...byTarget].forEach(([target, targetPoints], i) => {
    const color = colors[i % colors.length]!;
    const sorted = [...targetPoints].sort((a, b) => a.concurrency - b.concurrency);
    parts.push(`<polyline fill="none" stroke="${color}" stroke-width="2.5" points="${sorted.map((p) => `${x(p.concurrency)},${y(value(p))}`).join(" ")}"/>`);
    for (const p of sorted) {
      // A point where the system broke is drawn hollow, so the failure is visible on the chart.
      parts.push(`<circle cx="${x(p.concurrency)}" cy="${y(value(p))}" r="4" fill="${p.broke ? "white" : color}" stroke="${color}" stroke-width="2"><title>${escape(`${target} c=${p.concurrency}: ${n(value(p))} ${unit}${p.broke ? " (broke)" : ""}`)}</title></circle>`);
    }
    parts.push(`<text x="${pad.left + plotW + 12}" y="${pad.top + 16 + i * 18}" fill="${color}" font-weight="600">${escape(target)}</text>`);
  });
  parts.push("</svg>");
  return `${parts.join("\n")}\n`;
}

function niceCeiling(v: number): number {
  const magnitude = 10 ** Math.floor(Math.log10(v));
  const step = [1, 2, 2.5, 5, 10].find((s) => s * magnitude >= v)!;
  return step * magnitude;
}

function groupBy<T>(items: readonly T[], key: (item: T) => string): Map<string, T[]> {
  const groups = new Map<string, T[]>();
  for (const item of items) groups.set(key(item), [...(groups.get(key(item)) ?? []), item]);
  return groups;
}

function escape(text: string): string {
  return text.replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;");
}
