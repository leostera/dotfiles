---
name: leo-system-design
description: Design distributed systems with Leo the way he works best, from first principles and concrete examples to numeric requirements, the simplest correct design, RFDs, specs, and benchmarks of real operations, while guarding against moving targets, unchecked arithmetic, and unreviewed trade-offs. Use when designing, scaling, or re-architecting a service, storage system, or protocol implementation.
---

# Leo System Design

Use this skill when designing or re-architecting a system with Leo, or when pushing an existing design to a new scale. It covers how to run the design conversation, how to make decisions durable, and how to prove the design works.

Leo thinks out loud, often by voice transcription, and his intuition about systems is usually right. Your job is to turn that intuition into a precise design, check its numbers, and keep him in control of the decisions.

## 1. Understand before designing

- Start from how the existing system works internally. When the topic is prior art, explain what is actually new in each approach.
- Make it concrete. When Leo says "I need an example", show a minimal case end to end: the bytes on the wire, what the server receives, what it stores, and what the client gets back.
- When he restates a design in his own words, confirm or correct it explicitly before building on it. Restate the design in one short paragraph when his message is long or transcribed.
- Don't bring in concepts he hasn't raised (compaction, multi-pack indexes, and so on) without saying why they matter now.
- Read the reference implementation's source when behaviour matters. Use leo-research for anything worth keeping.

## 2. Pin requirements as numbers

Before designing for scale, write down:

- **The requirement:** what the product promises, such as published limits or contracts.
- **Headroom:** the fraction of capacity the requirement may use. Leo's default is to meet limits comfortably at about 25% of capacity.
- **Read:write ratio:** assume reads are about 10× writes unless told otherwise, and design both paths.
- **Per-unit budget:** how much load one unit (a Durable Object, a shard) may carry, such as about 300 rps. Scale is then a count of units, not a hope.
- **Stretch goals,** labelled as such.

When a target changes, say so, record the old and new numbers and the reason, and check which earlier decisions depended on the old one. Never let a stretch goal silently replace the requirement.

## 3. Check the arithmetic, bluntly

Do the back-of-envelope math for storage, row counts, request sizes, CPU, memory, and calls per operation before deciding anything. When Leo's estimate is off, correct it plainly with the numbers ("10 GB ÷ ~100 B per row ≈ 100M rows, not a trillion"). Check platform limits in the docs and distinguish similar limits, such as an HTTP body limit versus an RPC message limit. Don't guess.

## 4. Design the dumbest correct thing first

- Choose the simplest design that is correct and performs reasonably, and defer internal optimizations: precomputation, compaction, caches, inlining.
- Keep external contracts fixed. Internal storage can change later; the protocol can't. When the goal is a drop-in replacement, behave like the reference server.
- Use the platform. Don't rebuild anything the runtime already provides.
- Prefer immutable, content-addressed data that can be cached forever, and keep the mutable, serialized part as small as possible.
- Keep the consistency semantics explicit: what a client observes after an acknowledged write, and what may be stale and for how long.
- Isolate tenants by default: separate deployments, storage, or namespaces per owner when it is cheap.
- When load concentrates on one key (a hot ref, a hot `main`), design for it explicitly. Sharding by key doesn't help it.

## 5. Decide interactively, then record

- When there are open questions, ask them one at a time: present one, discuss it, record the answer, then the next. Give options labelled a, b, c with a recommendation.
- Record designs in RFDs (use the rfds skill). An accepted RFD is never edited; a change gets a new RFD that explains the move from A to B and why.
- Model the important flows as specs with properties, such as Feynman specs. Base tests on what the reference implementation's own tests check.

## 6. Build in passes

1. Prototype the whole system end to end.
2. Tighten correctness end to end: tests against the reference implementation, local emulators, property and fuzz tests, deterministic simulation.
3. Measure, profile, and rewrite for performance end to end.

Keep memory far below runtime limits. Stream large inputs, preallocate buffers, and avoid per-item allocations on hot paths.

## 7. Benchmark what users do

- Only real operations count, such as `git push`, `fetch`, `clone`, and `pull`, not internal RPCs.
- Measure both read and write paths, and single-operation latency as well as throughput.
- Benchmark against the right baseline, on the same account and region, and name it exactly. Run against every relevant baseline implementation.
- Ramp load until either side fails, and report where and why. A system that scales with more clients is the main signal.
- Report results as JavaScript-driven staged runs with a written report, not ad-hoc shell scripts.

## 8. Correctness gates performance

Any lost acknowledged write, data corruption, or unexplained anomaly stops performance work. Report it prominently, reproduce it, explain it, and fix it or document it as a known failure before the next benchmark or demo. Never bury it in an RFD as "unexplained".

## 9. Work autonomously, keep Leo in the loop

- When Leo hands over ("make your own trade-offs and continue"), keep going, and log every trade-off where he asked (often `.pi/tradeoffs.md`): the decision, the alternatives, and what would change it.
- On his return, summarize what was decided without him and which decisions need his review, most consequential first.
- Steelman the case against the design when asked, and offer it unprompted before a major commitment. Answer the strongest objection with requirements, not enthusiasm.

## Checklist

- Are the requirement, headroom, read:write ratio, and per-unit budget written down as numbers?
- Have targets changed? Is the change recorded, with its effects on earlier decisions?
- Has every estimate been checked against arithmetic and current platform limits?
- Is this the simplest correct design, with optimizations deferred and external contracts fixed?
- Are consistency semantics and hot-key behaviour explicit?
- Is the decision in an RFD, and does any change supersede rather than edit an accepted one?
- Do benchmarks use real operations on both paths, against named, fair baselines?
- Are there unexplained correctness anomalies? If so, stop and resolve them first.
- Does Leo know which trade-offs were made without him?
