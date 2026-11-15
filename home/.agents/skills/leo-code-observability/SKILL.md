---
name: leo-code-observability
description: Design, implement, or review application observability using structured logs and correlated traces/spans, following the frameworks and conventions already present in the codebase.
---

# Leo Code: Observability

Make important application behavior explainable in production. Prefer structured, queryable logs and distributed traces made with the observability framework the project already uses. Instrument meaningful work across application boundaries so a single operation can be followed from its entry point through the services, storage, and external calls it invokes.

For a request specifically to add or bootstrap observability, follow the dedicated [Setup Observability subskill](../setup-observability/SKILL.md). For ordinary feature work, apply the practices below without turning every task into an observability-platform setup.

## Start with the existing system

- Inspect project instructions, dependencies, application startup, logging utilities, telemetry initialization, exporters, environment configuration, and representative code paths before changing anything.
- Follow the framework already established in the codebase (for example, its logging facade, tracing SDK, context propagation, and exporter). Do not introduce a parallel logging or tracing stack when a suitable one is already configured.
- If only part of the stack exists, extend it compatibly. Propose a dependency or platform change only when the current system cannot meet the stated need; explain the gap and keep the migration bounded.
- Use the framework's public APIs and project conventions. Keep instrumentation at the layer that owns the operation rather than burying it in unrelated global hooks.

## Structured logs

- Emit stable event names and typed fields, not sentences that must be parsed later. Keep field names and value types consistent across call sites.
- Include useful operational context: operation, outcome, duration when useful, stable resource identifiers, and trace/span correlation when supported.
- Choose levels deliberately. Expected user mistakes and routine control flow are not errors; reserve error severity for failures requiring investigation or action.
- Log failures at the layer that can add useful context. Preserve the underlying error and avoid repeated stack traces or duplicate error events as failures bubble through layers.
- Keep log volume bounded. Avoid logging on hot paths per item, retry loops without limits, or both sides of every ordinary call.

## Traces and spans

- Add spans around meaningful operations and boundaries, not every helper or line of code. Prefer a useful end-to-end operation span with child spans for significant work such as database, RPC, filesystem, queue, or provider calls.
- Propagate the active trace context across async tasks, threads, process/RPC boundaries, and message queues using the existing framework's supported mechanisms. Verify propagation rather than assuming it.
- Name spans and operations consistently. Add bounded, appropriately typed attributes that help answer operational questions; record status and exceptions according to framework conventions.
- Keep span lifetimes accurate, including cancellation and failure paths. Do not detach background work from its parent context unintentionally.
- Avoid high-cardinality or sensitive attributes (raw user input, prompts, message bodies, tokens, secrets, arbitrary paths, or unbounded IDs). Use stable, bounded dimensions and approved redaction/hashing where identity is truly needed.

## Privacy, safety, and cost

- Treat logs, spans, metrics, baggage, and exception messages as data leaving the code path. Never emit credentials, tokens, private content, or other sensitive values. Prefer allowlisted fields over broad object serialization.
- Avoid high-cardinality metric labels and span/log dimensions that can explode storage or cost. Do not create a metric for an individual identifier.
- Respect sampling, retention, export, and consent/privacy choices already configured by the application. Do not silently enable external export or send telemetry to a new endpoint.
- Instrumentation must not change business behavior or make successful work fail when telemetry is unavailable. Follow the framework's failure mode and avoid blocking critical paths on export.

## Tests and review

- Test observable behavior at the appropriate seam: log event/fields, span creation and parentage, context propagation, failure/cancellation status, and safe handling when telemetry is disabled or unavailable.
- Prefer in-memory/test exporters and injected sinks over assertions against console text, wall-clock sleeps, or live telemetry backends.
- Validate privacy-sensitive fields and bounded dimensions where relevant. Avoid brittle tests of SDK internals or exact timestamp/ID values.
- Review instrumentation for duplicate events, excessive cardinality/volume, missing context across async boundaries, and accidental changes to application behavior.

## Checklist

- Did I reuse the project's established logging/tracing framework?
- Can an operator follow an important operation across its boundaries using its trace context?
- Are log events structured, stable, and useful without parsing prose?
- Are errors recorded once with appropriate context and status?
- Are sensitive data and unbounded/high-cardinality values excluded?
- Is telemetry bounded, non-blocking where needed, and behaviorally safe?
- Are the important guarantees tested with local/in-memory instrumentation?
