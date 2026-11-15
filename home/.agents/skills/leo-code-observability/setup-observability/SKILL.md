---
name: setup-observability
description: Bootstrap or complete application observability by inspecting the repository and configuring its existing structured-logging and tracing framework, then instrumenting and validating representative end-to-end paths.
---

# Setup Observability

Use this subskill when asked to set up, wire, bootstrap, or complete observability in an application. Follow the parent [Leo Code: Observability](../SKILL.md) skill for ongoing instrumentation principles. The goal is working, safe observability using the framework already in the project—not installing a fashionable stack by default.

## 1. Discover before editing

Inspect the repository's instructions and determine:

- Application entry points, runtime/deployment model, and major request or job flows.
- Existing logging API, structured log format, tracing SDK/API, context propagation, exporters, and any metrics system.
- Dependency and configuration conventions, environment-variable handling, secrets management, and test setup.
- Existing initialization order and lifecycle (startup, shutdown, background workers).
- What telemetry is currently missing, and what operational question the requested setup should answer.

Search dependencies and code, not only documentation: a transitive dependency or platform facility may already provide the needed capability. Identify the actual framework and version before choosing APIs.

## 2. Choose the narrowest compatible setup

- Reuse and complete the existing logger/tracer/export path. Do not add a competing SDK, duplicate global provider, or second logging facade.
- If logs exist but are unstructured, add fields through the existing logger. If tracing is present but disconnected, wire the existing provider/exporter and context propagation.
- If the project has no observability stack, use the ecosystem's established framework only after confirming project compatibility and deployment constraints. Keep dependencies minimal and state the reason for any new package or service.
- Do not assume a vendor, collector, endpoint, sampling rate, or telemetry destination. Use existing configuration where present; if a destination or policy needs a decision, expose a safe configurable boundary and ask rather than enabling external export by assumption.

## 3. Configure lifecycle and defaults

Set up one clear initialization point before instrumented work begins. Configure only what the chosen framework needs, such as:

- A stable service/application name and version, plus deployment environment when safely available.
- A structured logger with stable fields and timestamp/severity representation consistent with the runtime.
- A tracer provider, resource metadata, processor/exporter, and propagators as supported by the project's deployment.
- Explicit sampling and export configuration. Preserve existing privacy, consent, retention, and cost policy. Make local development/testing usable without requiring a live backend.
- Graceful shutdown/flush within the application's existing lifecycle and bounded timeout. Telemetry failure or exporter unavailability must not prevent useful application work unless the project explicitly defines otherwise.

Keep secrets out of source, logs, spans, and checked-in environment examples. Do not add a production endpoint or credentials in code. Avoid blocking startup on a remote collector unless the app's reliability contract explicitly requires it.

## 4. Instrument an end-to-end slice

Once setup is in place, show it works by instrumenting a small but representative operation from entry point through important boundaries:

1. Create or continue a span at the inbound request/job/event boundary.
2. Propagate context through async and cross-process/client calls using the framework's supported propagation.
3. Add child spans for important dependency work (for example, database, RPC, queue, filesystem, or provider calls), not every helper.
4. Emit structured lifecycle/outcome events at meaningful transitions, with trace correlation supplied by the framework where possible.
5. Record outcome, failure, cancellation, and duration using standard SDK conventions.

Use stable operation names and bounded attributes. Never capture request bodies, prompts, tokens, secrets, full exception payloads, arbitrary user-provided strings, or unbounded identifiers by default. Avoid duplicate error logs at every call boundary. Instrument enough of the path to demonstrate correlation, but do not blanket-instrument the entire codebase without an explicit scope.

## 5. Verify and document operation

- Add focused tests using an in-memory exporter/logger or injected test sink. Assert initialization, representative span/log fields, parent-child or propagated context, failure status, and disabled/no-export behavior as appropriate.
- Run the project's relevant formatting, lint, typecheck, and test commands. Do not claim a live-backend delivery test unless one was actually performed.
- Confirm the app still starts and shuts down without a telemetry service available, where the architecture allows that check.
- Document required configuration keys and safe defaults, how to run locally without external export, where traces/logs are sent when configured, and how to disable/flush telemetry. Do not document secret values.
- Summarize what is configured, what path is instrumented, validation performed, and any operator decision still needed (such as exporter endpoint, credentials, retention, or sampling policy).

## Setup checklist

- [ ] Existing packages, APIs, and lifecycle were inspected before selecting a framework.
- [ ] There is one coherent logger/tracer initialization path, using existing dependencies where possible.
- [ ] Export destinations and privacy/cost policy are explicit; external export was not silently enabled.
- [ ] Context survives the representative async/cross-boundary flow.
- [ ] Structured events and spans expose useful bounded fields without sensitive payloads.
- [ ] Failure, cancellation, exporter-offline, and shutdown behavior are safe and tested where relevant.
- [ ] Local development and tests do not require a live telemetry backend.
- [ ] Configuration and operation are documented without embedding secrets.
