#!/usr/bin/env node
import { mkdir, rename, rm } from "node:fs/promises";
import { dirname, extname, resolve } from "node:path";
import { spawnSync } from "node:child_process";

const [inputArgument, outputArgument, targetArgument, maxRatioArgument = "1.25"] = process.argv.slice(2);
if (!inputArgument || !outputArgument || !targetArgument) {
  throw new Error("Usage: node fit-audio-duration.mjs <input-audio> <output.wav> <target-seconds> [max-tempo-ratio=1.25]");
}

const inputPath = resolve(process.cwd(), inputArgument);
const outputPath = resolve(process.cwd(), outputArgument);
const targetSeconds = Number(targetArgument);
const maxTempoRatio = Number(maxRatioArgument);
if (!Number.isFinite(targetSeconds) || targetSeconds <= 0) throw new Error("Target duration must be positive.");
if (!Number.isFinite(maxTempoRatio) || maxTempoRatio <= 1) throw new Error("Maximum tempo ratio must be greater than 1.");
if (extname(outputPath).toLowerCase() !== ".wav") throw new Error("Output must use a .wav extension.");

function run(command, args) {
  const result = spawnSync(command, args, { encoding: "utf8" });
  if (result.error) throw result.error;
  if (result.status !== 0) throw new Error(result.stderr.trim() || `${command} exited with status ${result.status}`);
  return result.stdout.trim();
}

function durationOf(path) {
  const value = Number(run("ffprobe", [
    "-v", "error", "-show_entries", "format=duration", "-of", "csv=p=0", path,
  ]));
  if (!Number.isFinite(value) || value <= 0) throw new Error(`Could not read a valid audio duration from ${path}.`);
  return value;
}

const sourceSeconds = durationOf(inputPath);
const tempo = sourceSeconds / targetSeconds;
if (tempo < 1 / maxTempoRatio || tempo > maxTempoRatio) {
  throw new Error(
    `Fitting ${sourceSeconds.toFixed(2)}s to ${targetSeconds.toFixed(2)}s needs atempo=${tempo.toFixed(3)}, ` +
    `outside the safe range ${(1 / maxTempoRatio).toFixed(3)}–${maxTempoRatio.toFixed(3)}. Revise narration or timing instead.`,
  );
}

await mkdir(dirname(outputPath), { recursive: true });
const temporaryPath = outputPath.replace(/\.wav$/i, `.partial-${process.pid}.wav`);
try {
  const filter = `atempo=${tempo.toFixed(8)},apad=whole_dur=${targetSeconds},atrim=duration=${targetSeconds}`;
  run("ffmpeg", [
    "-hide_banner", "-loglevel", "error", "-y", "-i", inputPath,
    "-map", "0:a:0", "-vn", "-af", filter, "-c:a", "pcm_s16le", temporaryPath,
  ]);
  const fittedSeconds = durationOf(temporaryPath);
  if (Math.abs(fittedSeconds - targetSeconds) > 0.1) {
    throw new Error(`Fitted audio is ${fittedSeconds.toFixed(2)}s, not the requested ${targetSeconds.toFixed(2)}s.`);
  }
  await rename(temporaryPath, outputPath);
} finally {
  await rm(temporaryPath, { force: true });
}

console.log(`Fitted ${sourceSeconds.toFixed(2)}s to ${targetSeconds.toFixed(2)}s (atempo=${tempo.toFixed(3)}): ${outputPath}`);
