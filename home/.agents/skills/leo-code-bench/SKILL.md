---
name: leo-code-bench
description: Benchmark, load-test, and profile systems so the numbers can be trusted. Measure real user operations against a named baseline, ramp load until something breaks without measuring the load generator, store every run as versioned raw data with provenance, and report absolute numbers in charts generated from that data. Use when writing benchmarks, load tests, or profiling runs, or when publishing or comparing performance results.
---

# Leo Code: Benchmarks

Use this skill to benchmark the way @leostera does. A benchmark exists to answer a question and inform a decision. Its numbers are only worth publishing if someone else can rerun them and get the same picture.

## 1. Start from the question

- **Write down the question and the decision it informs** before writing code: "Does the candidate sustain 7,000 writes/s per tenant?", "Which packfile implementation is faster on customer-sized repositories?"
- **Name the baseline:** the stock implementation, the current main, or the incumbent product, identified exactly, such as "service-a, implementation js-v2, at commit abc123", not "the old service". If there are several incumbents, benchmark all of them.
- **State the targets as numbers,** with headroom: meet the published limit at about 25% of capacity, assume reads are 10× writes unless measured, and keep each stateful unit at its per-unit budget (for example, a few hundred requests per second per stateful unit).
- **Establish the baseline measurement first,** then change things.
- **Check the data before optimizing.** If production data and the baseline show there is no performance problem, say so. The real problem may be correctness or maintainability.

## 2. Measure what users do

- **Benchmark real operations,** the ones users run, through the real client: `git push`, `clone`, and `fetch`, not the internal RPCs behind them. Microbenchmarks of internals are for profiling, not for claims.
- **Cover both paths.** Measure reads as well as writes, and each operation on its own as well as mixed workloads. A system can be great at writing and bad at reading.
- **Measure single-operation latency and throughput.** What one user feels matters as much as the peak.
- **Record, for every point:**
  - operations per second and bytes per second;
  - latency as p50, p95, p99, and max, in absolute milliseconds;
  - errors, counted by status or message, with samples;
  - correctness counters, such as acknowledged writes that were lost, or data that didn't verify afterwards;
  - resource counts, such as shards, objects, or connections;
  - cost, when it can be computed.
- **Treat correctness as part of the result.** After a run, verify the data. Any lost acknowledged write or unexplained error is a finding that blocks the performance conclusion.

## 3. Choose workloads that represent reality

- **Use representative sizes.** Pull the sizes that real customers struggle with from observability data, and include the largest realistic case, such as the largest public repository or the biggest tenant.
- **Use realistic distributions:** uniform keys, one hot key, a handful of keys (the control-plane case), and skewed real traffic. Only test key formats separately if the system doesn't hash keys.
- **Use realistic contention.** Writers on their own branches are the easy case; everyone writing to `main` is the hard one.
- **Ramp concurrency in steps,** such as 1, 16, 64, 256, and 1,024 in flight, and keep going until either side fails. Report where it failed and why.
- **Warm up, then measure.** Run each level once unmeasured so caches fill and splits settle, then measure for a fixed window. Use fresh object names or wipe data between runs, so runs don't contaminate each other.
- **Fix every parameter in config:** sizes, counts, durations, seeds, and concurrency levels. Put them all in the results.

## 4. Don't measure the load generator

- **Check whether the generator is saturated.** If adding generators raises the numbers, you were measuring the generator. Cap the calls in flight per generator, and add generators until the target, not the driver, is the limit.
- **Generate load from where users are:** several regions or locations, close to production, and from a local machine when that's how users connect. Note that placement hints are advisory.
- **Know your clocks.** Timers inside some runtimes don't advance during execution. Measure latency where the clock is meaningful, and say which clock was used.
- **Push the target hard, and watch headroom.** The aim is to run at the target load with each unit still well under its budget. The generator is a tool, not the subject.
- **Count scaling as the main signal.** A system that keeps scaling with more clients is healthy. A curve that flattens shows where the next bottleneck is.

## 5. Run in the right places

- **Locally,** for libraries and tight loops: microbenchmarks, memory profiles, and flame graphs. Local emulators are for checking correctness, not for claims about production performance.
- **Close to production,** for system claims: deploy the candidate and the baseline to the same test account and region, under the same conditions, and run the same harness against both.
- **Compare on the same commit.** For before-and-after comparisons, change one thing at a time, and benchmark after each optimization to attribute the improvement.
- **Run more than once.** Results vary with placement, load, runtime version, and the day. Repeat before drawing conclusions, and report the spread.
- **Clean up.** Tear down benchmark deployments and data when done, and say what's left behind if anything is.
- **Keep secrets out.** Tokens go in headers or local env files, never in results, logs, or commits.

## 6. Write harnesses as code

- **Write the harness as a program,** in the project's language, typically TypeScript, not shell scripts. It should be readable, typed, and testable.
- **Make suites selectable.** Let flags or environment variables choose suites, targets, operations, distributions, and concurrency, so a run can be staged and repeated in parts.
- **Show progress as it runs:** each stage and point with a status, a count, and timing, so the user can watch results arrive.
- **Write results after every point,** so a failed or interrupted run still leaves usable data.
- **Run long jobs in the background.** For jobs that outlast a request, such as a large split, start them as background work on the server and poll for completion.
- **Document it in a `bench/README.md`:** what each target is, what a run measures, how to run it on your own account, and the caveats.

## 7. Store results as data

- **One JSON file per run,** named by timestamp or by a run name, under `bench/results/`. Keep the raw points, not only the aggregates.
- **Record provenance with every run:**
  - `schemaVersion`;
  - `generatedAt`;
  - the commit SHA and whether the tree was dirty;
  - the deployed version and environment (account, region, runtime and compatibility date);
  - the full configuration;
  - `notes` that describe the method, such as how latency was estimated or where generators ran.
- **Version the schema.** When the format changes, bump `schemaVersion` and make the plotting code read the old versions or migrate them.
- **Commit the results that back published claims,** next to the script that produced them. Store large raw data in object storage and keep a pointer.
- **Data, not prose.** Never write markdown files that say what a benchmark showed. The results file, the plot, the commit, and the RFD are the record.

## 8. Report from the data

- **Generate every chart and table from the results files** with a plot script, and regenerate them whenever the results change. Never edit published numbers by hand.
- **Use absolute values.** Write "100 rps vs 100,000 rps" and "12 ms", not multipliers alone. If a ratio helps, put it in a separate column next to the absolute values.
- **Choose readable scales.** Use linear scales unless the range really needs a log scale, and never leave half a chart flat and empty.
- **Make the case visually.** Draw the baseline and the candidate on the same chart: throughput against concurrency, latency percentiles, and cost. Lead the README with the chart that answers the main question.
- **Write the methodology like a short paper:** setup, workloads, what was measured and how, and limitations. Keep measured facts apart from inferences.
- **Put conclusions in the RFD,** together with the benchmark data and the relevant observability data, keeping private production data out of anything public.

## 9. Profile to find the next bottleneck

- Use flame graphs and CPU profiles to see where time goes, and memory profiles to find leaks. Check that memory stays constant when streaming large inputs.
- Look at production observability too (request counts, CPU time, queueing, overload errors) to find where the system actually spends its time.
- Fuzz alongside benchmarking. The inputs that stress performance often expose correctness gaps too.
- When you find the bottleneck, write the change down (an RFD if it's a design change), make one change, measure it, and repeat.

## Checklist

- Is the question written down, with numeric targets and an exactly named baseline?
- Are real user operations measured, on both read and write paths, with absolute p50/p95/p99/max, errors, and correctness counters?
- Are workload sizes, distributions, and contention representative, including the largest realistic case?
- Does load ramp until failure, with warm-up, fresh state, and a generator that isn't the bottleneck?
- Were the candidate and baseline run in the same place, more than once, and cleaned up afterwards?
- Is the harness a selectable, progress-reporting program that writes results after every point?
- Does every results file carry a schema version, commit, environment, configuration, and method notes?
- Are charts and tables generated from the data, in absolute values on readable scales?
- Are conclusions in an RFD with the data, and were anomalies resolved before claiming wins?
