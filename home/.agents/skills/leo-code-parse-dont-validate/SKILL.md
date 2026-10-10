---
name: leo-code-parse-dont-validate
description: Design boundaries that transform untrusted or weakly structured external data into precise trusted values, then preserve those guarantees through the program; use for JSON, configuration, CLI, database, network, and other input parsing.
---

# Leo Code: Parse, Don’t Validate

Use this skill when data crosses a trust or representation boundary: JSON, configuration, command-line arguments, database rows, network messages, files, or user input. The core idea, following Alexis King’s [“Parse, don’t validate”](https://lexi-lambda.github.io/blog/2019/11/05/parse-don-t-validate/), is to turn checks into a transformation that returns a more precise value. Do not merely check a fact and throw away the evidence.

## Make the boundary produce evidence

A validator such as `checkNonEmpty(items) -> void` may reject bad input, but on success it leaves the caller holding the same broad `List<T>` as before. The check can be forgotten, repeated, or become stale while downstream code still accepts empty lists. Prefer a parser/refinement such as `parseNonEmpty(items) -> Result<NonEmptyList<T>, ParseError>`: failure is reported at the boundary, and success returns a value whose representation carries the fact that the list is non-empty.

Parsing is broader than text-to-syntax. It means converting less-structured or less-trusted input into a representation with stronger guarantees. A smart constructor for a value constrained by a runtime rule (such as an integer range) is a practical parser too. Make the trusted type's unchecked constructors private or otherwise restrict them when callers must not bypass the invariant.

Be exact about what the result guarantees. A static annotation, alias, or brand does not validate JSON at runtime. Parse the external value first, then treat it as the trusted domain type. Keep malformed-input errors useful and explicit; do not replace them with unsafe casts or claims the type system cannot uphold.

## Design consumers around the trusted representation

Design functions against the strongest useful representation, not necessarily the shape of the data they first receive. If a function requires a non-empty collection, accept a `NonEmptyList<T>` and give it a total implementation rather than accepting `List<T>` and checking (or crashing) internally. If duplicate keys are forbidden, consider a map or a validated unique-key collection rather than passing around a list plus a separate “no duplicates” assertion.

Work outward from that desired representation: update callers and producers to use it until reaching the point where the weaker form is created or is genuinely needed. Put the conversion there. Let type errors reveal every call site that needs to participate in the invariant. This makes the successful parse result necessary for the program to proceed, instead of an optional check that can be omitted.

Choose conversions carefully. A map may enforce key uniqueness, but converting a list to a map can silently discard duplicate entries. Define whether duplicates are rejected, first-wins, last-wins, or meaningful before choosing a representation; do not lose distinctions the program still needs. When a built-in type cannot reasonably encode a rule, use an abstract domain type and validating constructor rather than elaborate type machinery.

Let domain types shape the implementation. Do not add a boolean or ad-hoc status flag just to satisfy one branch if a sum type, distinct representation, or refined value better captures the real states. Refactor the types as understanding improves; the point is to make the invariant an ordinary part of the data flow, not to freeze the first design.

## Separate parsing from effects

Parse enough of an input before performing meaningful actions based on it. Scattering checks through processing (“shotgun parsing”) risks acting on part of malformed input before a later error is discovered, leaving state that is difficult to predict or roll back. A boundary parse creates a clear phase: reject malformed input first, then execute with trusted values and fewer input-related failure cases.

This does not require a single pass. Parsing can be multi-pass or context-sensitive: parsed fields may determine how other fields should be interpreted. Finish the necessary parsing before acting on the input. A narrow authorization or resource check may appropriately happen first to protect parsing from abuse, but avoid meaningful state changes before the relevant input has been parsed.

Avoid duplicated, denormalized state—especially mutable copies that can drift out of sync. Prefer a single source of truth. If duplication is necessary for performance or another real reason, keep it behind an abstraction that owns and maintains consistency.

## Make failure cases honest and proportionate

A function whose primary purpose is raising an error but returns only `void`/`()`, a boolean, or the unchanged input deserves scrutiny: could it return the refined value its callers need? Effect-only functions are still appropriate when the effect itself is the purpose; the concern is checks whose useful result is discarded.

Do not eliminate legitimate failure cases from an API. A total operation over a refined input can return an ordinary result, while parsing the weaker input remains fallible. If empty input is valid, an optional or explicit error result may be the honest contract. If a supposedly impossible branch remains, consider its risk, document the invariant, and keep any bottom/panic localized rather than pretending it is impossible by convention.

Apply the strongest practical design, not maximal type machinery. It is not worth a whole-program redesign or advanced type-level proof for every tiny check. A smart constructor, runtime validation, focused tests, and a clear residual assumption can be the right answer when they are safer and easier to maintain.

## Review checklist

- What external or weakly structured representation enters here, and where does it become trusted?
- Does the boundary return a refined/domain value, or merely report that a check passed?
- Can downstream code rely on that value without repeating the check or handling a case already ruled out?
- Are failures handled at the parsing boundary before meaningful side effects, with authorization/DoS constraints considered?
- Does the chosen type or data structure actually enforce the intended invariant without silently discarding meaningful input?
- Have the trusted type’s constructors and escape hatches been considered, especially around deserialization and casts?
- Are transformations total over their declared input types, and do APIs still represent genuine failure cases honestly?
- Is there duplicated mutable state that could drift, and if so, is it encapsulated behind one owner?
- Is the solution proportionate to the invariant and language guarantees?

## Source

Alexis King, [“Parse, don’t validate”](https://lexi-lambda.github.io/blog/2019/11/05/parse-don-t-validate/), published 2019-11-05. The skill restates the article’s design guidance in language-neutral terms; use language- and domain-appropriate representations rather than copying its Haskell examples literally.
