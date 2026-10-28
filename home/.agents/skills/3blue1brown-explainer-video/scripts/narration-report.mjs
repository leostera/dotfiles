#!/usr/bin/env node
import { readFile } from "node:fs/promises";
import { resolve } from "node:path";

const [inputPath, wpmArgument = "135"] = process.argv.slice(2);
if (!inputPath) {
  throw new Error("Usage: node narration-report.mjs <script.json> [words-per-minute]");
}

const wordsPerMinute = Number(wpmArgument);
if (!Number.isFinite(wordsPerMinute) || wordsPerMinute < 30 || wordsPerMinute > 300) {
  throw new Error("Words per minute must be a number between 30 and 300.");
}

const script = JSON.parse(await readFile(resolve(process.cwd(), inputPath), "utf8"));
if (!Array.isArray(script.scenes) || script.scenes.length === 0) {
  throw new Error("Script must contain a non-empty scenes array.");
}

const wordCount = (text) => (text.match(/[\p{L}\p{N}]+(?:[’'][\p{L}\p{N}]+)*/gu) ?? []).length;
const sceneRows = script.scenes.map((scene, index) => {
  if (typeof scene.narration !== "string") {
    throw new Error(`Scene ${scene.id ?? index + 1} has no narration string.`);
  }
  const words = wordCount(scene.narration);
  return {
    label: scene.id ?? scene.title ?? `Scene ${index + 1}`,
    words,
    seconds: words / wordsPerMinute * 60,
  };
});

const totalWords = sceneRows.reduce((sum, scene) => sum + scene.words, 0);
const estimatedSeconds = totalWords / wordsPerMinute * 60;
const targetSeconds = Number(script.durationSeconds);
const formatTime = (seconds) => `${Math.floor(seconds / 60)}:${String(Math.round(seconds % 60)).padStart(2, "0")}`;

console.log(`Narration estimate at ${wordsPerMinute} words/minute`);
for (const scene of sceneRows) {
  console.log(`${String(scene.words).padStart(4)} words  ${formatTime(scene.seconds)}  ${scene.label}`);
}
console.log(`Total: ${totalWords} words, about ${formatTime(estimatedSeconds)} spoken`);

if (Number.isFinite(targetSeconds) && targetSeconds > 0) {
  const targetRate = totalWords / targetSeconds * 60;
  const delta = estimatedSeconds - targetSeconds;
  console.log(`Composition: ${formatTime(targetSeconds)}; implied pace if fully narrated: ${Math.round(targetRate)} words/minute`);
  if (Math.abs(delta) > 10) {
    console.warn(`Estimate differs from composition by ${delta > 0 ? "+" : ""}${Math.round(delta)}s; plan pauses, revise narration, or adjust scene timing.`);
  }
}
