#!/usr/bin/env node
import { spawnSync } from "node:child_process";
import { resolve } from "node:path";

const [inputArgument, ...options] = process.argv.slice(2);
if (!inputArgument) {
  throw new Error("Usage: node check-video.mjs <video-file> [--expect-duration seconds] [--require-audio]");
}

let expectedSeconds;
let requireAudio = false;
for (let index = 0; index < options.length; index += 1) {
  if (options[index] === "--require-audio") {
    requireAudio = true;
  } else if (options[index] === "--expect-duration") {
    expectedSeconds = Number(options[index + 1]);
    index += 1;
    if (!Number.isFinite(expectedSeconds) || expectedSeconds <= 0) {
      throw new Error("--expect-duration must be followed by a positive number of seconds.");
    }
  } else {
    throw new Error(`Unknown option: ${options[index]}`);
  }
}

const inputPath = resolve(process.cwd(), inputArgument);
const probe = spawnSync("ffprobe", [
  "-v", "error", "-show_streams", "-show_format", "-of", "json", inputPath,
], { encoding: "utf8" });
if (probe.error) throw probe.error;
if (probe.status !== 0) throw new Error(probe.stderr.trim() || `ffprobe exited with status ${probe.status}`);

const media = JSON.parse(probe.stdout);
const video = media.streams?.find((stream) => stream.codec_type === "video" && !stream.disposition?.attached_pic);
const audio = media.streams?.filter((stream) => stream.codec_type === "audio") ?? [];
if (!video) throw new Error("No video stream found.");
if (requireAudio && audio.length === 0) throw new Error("No audio stream found, but --require-audio was set.");

const fraction = (value) => {
  const [numerator, denominator] = String(value ?? "0/1").split("/").map(Number);
  return denominator ? numerator / denominator : 0;
};
const frameRate = fraction(video.avg_frame_rate) || fraction(video.r_frame_rate);
const videoSeconds = Number(video.duration ?? media.format?.duration);
if (!Number.isFinite(videoSeconds) || videoSeconds <= 0) throw new Error("Could not read a valid video duration.");

if (expectedSeconds !== undefined) {
  const tolerance = Math.max(0.5, frameRate > 0 ? 2 / frameRate : 0.5);
  if (Math.abs(videoSeconds - expectedSeconds) > tolerance) {
    throw new Error(`Video duration ${videoSeconds.toFixed(3)}s differs from expected ${expectedSeconds.toFixed(3)}s by more than ${tolerance.toFixed(3)}s.`);
  }
}

const formatTime = (value) => `${value.toFixed(3)}s`;
console.log(`Video: ${video.codec_name}, ${video.width}x${video.height}, ${frameRate.toFixed(3)} fps, ${formatTime(videoSeconds)}`);
for (const [index, stream] of audio.entries()) {
  const seconds = Number(stream.duration ?? media.format?.duration);
  const channels = stream.channels ? `${stream.channels}ch` : "channels unknown";
  const sampleRate = stream.sample_rate ? `${stream.sample_rate}Hz` : "sample rate unknown";
  console.log(`Audio ${index + 1}: ${stream.codec_name}, ${sampleRate}, ${channels}, ${Number.isFinite(seconds) ? formatTime(seconds) : "duration unknown"}`);
}
console.log(`Container: ${media.format?.format_name ?? "unknown"}, ${media.format?.size ?? "size unknown"} bytes`);
