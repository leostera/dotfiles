---
name: leo-code-review-invariants
description: Make program invariants explicit and preserve them with the strongest practical combination of types, runtime checks, tests, and concise comments; use when writing, changing, or reviewing code for correctness at boundaries and across call graphs.
---

# Leo Code Review: Invariants

Treat every piece of code as having properties that must remain true for it to be correct. Make those invariants visible and enforce them with the strongest practical mechanism available in the language and at the relevant boundary.

## Core principle

For each important invariant, ask:

1. **What must be true?** State the property precisely, including relevant ranges, assumptions, and failure behavior.
2. **What is the strongest practical way to enforce it here?** Prefer compile-time guarantees when they are clear and maintainable; otherwise validate at runtime. Add tests for behavior the type system and assertions cannot establish or for which regression protection is needed.
3. **Where can it first be established?** Establish it as early as possible after data enters the program, and preserve it as it moves through the call graph.

A useful preference order is:

1. **Types and compile-time checks** that make invalid states unrepresentable or cause invalid programs not to compile.
2. **Runtime validation and assertions** at the earliest boundary that has enough information to enforce the invariant.
3. **Tests** for invariants that cannot be adequately encoded in types or assertions, and for important validation and behavior that could regress.
4. **Comments** to explain the invariant, assumptions, constraints, or worst-case failure behavior that code alone cannot communicate.

These mechanisms complement one another. A comment is not enforcement; a test does not make invalid input safe in production; and a type guarantee is only as strong as the language's soundness and the code's use of escape hatches. Do not add ceremony merely to use a stronger mechanism: choose the clearest practical guarantee for the codebase.

## Apply the principle

### 1. Identify invariants and failure modes

Look for assumptions about values, state, ordering, ownership, resources, and interactions between components. Examples include:

- A port must fit in the representable network-port range.
- A sidecar only accepts ports in its own supported range.
- Parsed configuration contains a required field, is non-empty, or has a valid format.
- A state transition is legal only from certain prior states.
- A resource must be closed, a collection must remain unique, or an operation must happen before another.

For each relevant invariant, make the expected property and what happens when it is violated explicit. Include the worst-case consequence when it is not obvious (for example, rejected input, a failed operation, corrupted state, or a security boundary being bypassed).

### 2. Match enforcement to the language and boundary

Understand the actual guarantees available in the language: static versus dynamic typing, structural versus nominal types, type-system soundness, runtime checks, and escape hatches such as casts, `any`, unsafe blocks, reflection, or unchecked deserialization. Do not assume a type annotation proves more than it does.

Prefer a compile-time representation when it meaningfully prevents invalid use and remains understandable. If the language cannot express the invariant, or the value comes from an untrusted or dynamically typed source, validate it at runtime. Keep checks close to the point where the program first has enough information to perform them.

Do not rely on a distant consumer to catch malformed input that could have been rejected when parsed. Also do not validate a constraint before the owning layer can define it: validate general properties at the input boundary, then enforce component-specific constraints at the component boundary.

### 3. Establish invariants early and preserve them

Validate user input, configuration, deserialized data, and other external values immediately after parsing or receipt. Convert raw values into a validated representation where that makes the guarantee clear. Pass that validated value onward rather than repeatedly passing unchecked primitives.

Different layers may own different invariants. For example, a configuration reader can ensure a supplied port is an integer in the representable port range. A sidecar, which knows its own supported range, can then reject a port outside that range. Enforce each invariant at the earliest point where its requirements are known, and make the failure mode explicit.

Do not defer checks to a deep call site when an earlier boundary can reject invalid data safely. Conversely, do not claim an earlier layer guarantees a constraint it cannot know.

### 4. Test what cannot be guaranteed directly

Add tests that demonstrate important invariants are preserved, especially when they cannot be expressed as types or reliably guarded by assertions. Test boundary values and invalid cases, not only ordinary happy paths. For runtime validation, verify both that valid values pass and invalid values fail in the expected way.

Keep tests focused on observable guarantees rather than duplicating implementation details. Tests are especially important around parsing, state transitions, cross-layer assumptions, and behavior that depends on runtime or external data.

### 5. Document residual assumptions

Add concise comments when a non-obvious invariant, external assumption, limitation, or worst-case failure is not clear from the types and code. Say what must remain true and why it matters. Avoid comments that merely restate an assertion or type declaration; update comments when the guarantee changes.

## Review checklist

- What are the important invariants and what is the consequence if each is broken?
- Are external values checked as soon as they are parsed or received?
- Are constraints enforced at the earliest layer that has enough information, with layer-specific rules kept at the right boundary?
- Could a type or compile-time check prevent invalid states more clearly than a runtime check?
- Are runtime checks needed because of dynamic input, an unsound boundary, or type-system escape hatches?
- Are important guarantees covered by tests, including invalid and boundary cases?
- Do comments explain residual assumptions or worst-case behavior without pretending to enforce it?
- Are the checks proportionate and maintainable, rather than excessive type machinery or duplicated validation?
