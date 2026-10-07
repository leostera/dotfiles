---
name: leo-code-thinking-with-types
description: Design domain types that express meaning and valid choices instead of defaulting to vague primitives or positional tuples; use when modeling data, APIs, state, configuration, or constructors in any language.
---

# Leo Code: Thinking with Types

Use types to describe the concepts in the problem, not only the machine representation that happens to store them. A `string`, `bool`, or `int` may be easy to pass around, but often it says less than the domain already knows.

The goal is not to maximize type machinery. Use a richer type when it makes meaning clearer, prevents a real class of mistakes, or gives invalid states a well-defined boundary. Keep a primitive when it is already the clearest representation.

## Start with the domain concept

When you see a primitive, ask what it means here:

- Is this `int` a count, an index, a year, a port, a duration, or an identifier?
- Is this `bool` genuinely an on/off fact, or does it mean required/optional, allowed/denied, or one of several states?
- Is this `string` a name, a URL, a user ID, a status, or a value from a fixed vocabulary?
- Is this tuple a meaningful record whose fields deserve names?

Choose names that make the domain distinction visible. A type named `Requirement`, `Cardinality`, `UserId`, or `Month` communicates more than a primitive alias named `Value`.

## Prefer explicit choices for domain alternatives

Use an enum, variant, tagged union, or equivalent when the value represents a choice with domain-specific cases. This is especially useful when a boolean hides the meaning of its two values or when the number of states may grow.

```rust
enum Requirement {
    Mandatory,
    Optional,
}

enum Cardinality {
    None,
    One,
    Many,
}
```

These names make the domain vocabulary explicit. But `Cardinality` is a coarse classification: use it only when the program needs to distinguish zero, one, and many. If the exact quantity matters, represent a count instead—possibly with a validated `NonNegativeCount` newtype.

A plain boolean is still right for a genuinely binary property with clear names, such as `is_enabled` or `has_access`. Do not replace every boolean with a two-case enum just to make the type look richer. In particular, distinguish a policy such as `Requirement` from the value's presence, such as `Option<T>`: whether a field must be supplied and whether it currently has a value are different facts.

For multiple correlated states, model the states directly rather than using unrelated booleans whose combinations may not make sense:

```rust
enum ConnectionState {
    Disconnected,
    Connecting,
    Connected { since: Instant },
    Failed { reason: String },
}
```

## Name the parts of records

Prefer a record or struct when fields have distinct meanings, when call sites benefit from names, or when the value will be passed around as a concept. A tuple is fine for a short-lived grouping where position is obvious; it is a poor substitute for a named domain record.

For example, a date should not casually become `(int, int, int)`. A record makes the roles visible:

```rust
struct DateParts {
    year: i32,
    month: Month,
    day: u8,
}
```

Use stronger component types when they add useful guarantees. A `Month` enum can make month values explicit; the year and day may need validated newtypes, or may remain primitives inside a constructor's input record. Pick the representation that makes actual call sites safer and easier to understand.

## Separate raw input from validated domain values

A type often cannot express every value-level rule—especially when validity depends on runtime data or on another field. Make construction the validation boundary:

```rust
struct Date {
    year: i32,
    month: Month,
    day: u8,
}

fn create_date(parts: DateParts) -> Result<Date, DateError> {
    // Check the day against this month and year, including leap years.
}
```

Keep `Date`'s fields private (or otherwise restrict unchecked construction) when callers must only receive valid dates. Parse external data into a raw representation, validate it once in the owning constructor, and return either a domain value or a useful error. Do not claim that a `DateParts` record alone proves the calendar date is valid: February's valid range depends on the year.

This is the type-design companion to `leo-code-review-invariants`: use a type guarantee when it is real and maintainable; otherwise establish the invariant with a constructor/runtime check and test it.

## Match the type to the language's guarantees

Adapt the design to the type system in use:

- In a nominal system, a newtype or private constructor can distinguish concepts that share the same representation.
- In a structural system, named records clarify shape, but two aliases of `string` or `number` may still be interchangeable.
- In a system with expressive refinement or dependent types, encode useful constraints there when the proof remains understandable.
- In TypeScript and other systems with escape hatches, remember that annotations and branded types do not validate JSON or user input at runtime. Validate external values before treating them as trusted domain values.
- If the type system cannot state the full invariant, do not simulate a proof with an unsafe cast. Use the simplest practical type plus a validating constructor, tests, and a concise explanation of residual assumptions.

A type alias, a brand, a wrapper, a runtime-validated object, and a dependent type provide different strengths of guarantee. Be precise about which guarantee the code actually has.

## Keep type design proportionate

Do not wrap every primitive automatically. Prefer the domain type when it improves correctness or communication; retain a primitive where the distinction is trivial, local, or would add friction without protecting anything important.

In particular:

- Avoid enums that throw away information needed by the program. `Zero | One | Many` is not a replacement for an exact count if downstream logic needs that count.
- Avoid deeply nested generics or elaborate type-level encodings when a clear record and constructor are easier to maintain.
- Do not force a static type to prove a property that is only known after runtime input arrives.
- Keep serialization and public API shapes in mind; introduce a richer internal type without needlessly changing an external contract.
- Use established standard-library domain types when they already model the concept well.

## Review checklist

- What domain concept does each important primitive represent?
- Would a named enum or variant explain a choice better than a boolean or string?
- Would a record clarify fields currently passed as a positional tuple?
- Does a proposed abstraction preserve all information callers need?
- Which constraints are guaranteed by the type system, and which still require runtime validation?
- Are raw input and validated domain values distinguishable at the right boundary?
- Are constructors the clear way to create valid values, with useful errors for invalid input?
- Are tests covering runtime-dependent rules and important edge cases?
- Is the stronger type worth its complexity in this language and codebase?
