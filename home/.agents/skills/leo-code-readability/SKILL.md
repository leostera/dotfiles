---
name: leo-code-readability
description: Apply Leo's human-centric code readability principles when writing, refactoring, or reviewing code, especially when simplifying long functions, deeply nested branches, or implicit dependencies.
---

# Crafting Quality, Human-Centric Code

Treat code as communication between the author, teammates, and future maintainers. Optimize for clarity and respect for the next person who has to understand or change it.

## Core philosophy

- **Software is social.** Code is a conversation; clarity is a form of respect.
- **Prefer empathy over cleverness.** Antisocial code is excessively verbose, opaque, or hides side effects. Social code is clear, honest, and makes intent visible.
- **Optimize for obviousness.** A reader should be able to understand the flow quickly, then inspect a focused function body only when they need implementation details.

## Techniques

### 1. Decompose walls of code

If a block feels intimidating or does several things, identify the responsibility it represents and extract it into a small, focused function with a descriptive name. Prefer a short sequence of named operations over one sprawling implementation.

### 2. Replace complex branches with named functions

When an `if`/`else` or `switch` branch contains substantial logic, move that branch into a named function. Keep the surrounding code focused on the decision and its high-level flow. Function names and explicit arguments should make the branch's intent and dependencies apparent.

### 3. Make context explicit

Pass required data as function arguments instead of reaching into wide-scope variables or relying on ambient context. Explicit inputs make behavior easier to understand, isolate, and test.

### 4. Keep functions focused and short

Each function should do one coherent job. Choose names that describe what is being done; put the details in the function body so readers can inspect them only when needed. Avoid both opaque abbreviations and needless fragmentation—extract a function when its name improves the map of the code.

## Readability checklist

- Is this function focused on one coherent responsibility?
- Can a reader follow the high-level flow without first reading every implementation detail?
- Would a descriptive helper name make a substantial branch or sequence easier to understand?
- Are the function's dependencies explicit in its arguments?
- Could I revisit this on a busy Monday morning and immediately understand the intent?
- Is the code obvious enough to support targeted changes and confident debugging?
