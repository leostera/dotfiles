---
name: leo-code-legacy
description: Prefer clean implementation cutovers over unnecessary legacy compatibility layers when refactoring or replacing code, while preserving required external behavior and contracts.
---

# Leo Code: Legacy Compatibility and Clean Cutovers

Use this skill when replacing, refactoring, or migrating an implementation, module, or subsystem.

## Core principle

Preserve the behavior and contracts the software needs to provide; do not preserve the old implementation merely because it existed. Backwards compatibility of the final product's behavior can be important. Compatibility with an obsolete internal implementation usually is not.

The default is a clean cutover: build the replacement, move callers to it, test it, and remove the old implementation and transition scaffolding. Do not leave interstitial tissue—wrappers, aliases, forwarding layers, duplicate paths, or "temporary" compatibility code—without a concrete requirement for it.

## Default: clean cutover

When a module or implementation is being replaced:

1. Identify the behavior and external contracts that must remain true. Distinguish those from internal names, file boundaries, and implementation details that may change.
2. Build the replacement around the interface the code actually needs. Keep that interface as small and direct as practical.
3. Test the replacement against the required behavior.
4. Point callers, configuration, and tests at the replacement.
5. Remove the obsolete implementation and any transition-only scaffolding in the same change when practical. Search for remaining references so the old path is not accidentally kept alive.

Prefer creating a clear new module B and moving the relevant callers to B over gradually mutating module A into B while retaining A's legacy shape. Do not keep unused old APIs, re-export aliases, delegating wrappers, duplicate implementations, or fallback paths just in case. Avoid leaving cleanup as an unspecified future task.

## Use branch by abstraction only for a real coexistence requirement

A thin abstraction is appropriate when both implementations genuinely need to operate at once—for example, while migrating persisted data, gradually rolling out a replacement, supporting a deployment transition, or switching implementations at runtime. In that case:

- Keep the abstraction thin and focused on the behavior both implementations share.
- Make the reason for coexistence explicit.
- Define how callers select or transition between implementations.
- State what condition allows the old implementation and abstraction to be removed, and remove them when that condition is met.

Do not add an abstraction solely to make a refactor feel safer or to preserve a legacy implementation that can be replaced directly.

## Compatibility boundaries

Do preserve documented or relied-upon public APIs, persisted data formats, and user-visible behavior when the project requires them. If an external contract needs a compatibility adapter, keep it at that boundary and make the supported compatibility scope explicit; do not let it spread through internal code. A required data migration or compatibility adapter is a concrete reason for temporary coexistence, not a reason to retain unrelated old internals.

If it is unclear whether a symbol or behavior is externally relied upon, inspect the repository's contracts and call sites, then ask rather than keeping internal compatibility speculatively.

## Review checklist

- Which behaviors and contracts must remain, and which legacy details are merely implementation history?
- Is coexistence required for a concrete migration, rollout, deployment, or public-API reason?
- Can callers move directly to the replacement without a wrapper, alias, duplicate path, or fallback?
- If an abstraction is needed, is its scope thin and is there an explicit removal condition?
- Have callers and tests been moved to the new implementation?
- Are obsolete modules, shims, flags, and references removed once no longer required?
- Do tests verify required observable behavior rather than legacy implementation structure?
