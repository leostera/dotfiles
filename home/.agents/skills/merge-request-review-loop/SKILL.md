---
name: merge-request-review-loop
description: Manage a merge request through automated CI and review feedback. Use after opening or updating an MR to wait for all automated jobs, collect all findings, batch the requested fixes, push once, and repeat until checks and review feedback are clean.
---

# Merge Request Review Loop

Use this workflow when preparing an existing merge request for merge. The goal is to avoid reacting to checks one at a time and avoid repeatedly pushing partial fixes.

## Core loop

1. **Identify the MR and current head SHA**
   - Record project, MR IID, source branch, target branch, and current head SHA.
   - Work from a clean, dedicated worktree.
   - Confirm the branch used for pushes is the MR source branch.
   - Never push unrelated local changes.

2. **Wait for automated feedback**
   - Discover all pipelines associated with the current MR head.
   - Include MR pipelines, source-branch pipelines, review jobs, lint/format/typecheck jobs, unit/integration/E2E jobs, security scans, preview-generation jobs, and report aggregation jobs.
   - Treat preview-generation jobs as long-lived when they own a running preview environment; their `running` state does not necessarily mean deployment is incomplete.
   - Poll until every relevant finite job reaches a terminal state. Do not start fixing while known automated reviewers are still processing unless the user explicitly asks for an early pass.

3. **Collect feedback as one batch**
   - Fetch all MR discussions, standalone notes, review summaries, job logs, code-quality reports, security reports, and test failures.
   - Separate findings into:
     - blocking failures
     - warnings/requested changes
     - suggestions/nits
     - accepted/deferred findings
     - infrastructure/transient failures
   - Deduplicate repeated findings across bots, retries, and review rounds.
   - Match every finding to the current head SHA. Ignore stale findings from earlier commits unless they remain applicable.
   - Do not treat an accepted or explicitly deferred finding as required work without user approval.

4. **Make one batched fix pass**
   - Address all applicable findings in one working-tree pass.
   - Prefer the smallest coherent change set.
   - Add or update tests for behavioral fixes.
   - Do not make speculative changes solely to satisfy a vague suggestion; record the rationale and ask when scope is ambiguous.
   - Run relevant local format, lint, typecheck, and test commands before pushing.
   - Inspect `git diff`, `git diff --check`, and `git status` before committing.

5. **Push once and repeat**
   - Commit all fixes together using the repository's commit convention.
   - Push the MR source branch once.
   - Record the new SHA and discard all findings tied only to the old SHA.
   - Return to step 2. Never assume a previous green job applies to the new commit.

## Waiting and polling rules

- Prefer GitLab API/MCP tools for MR metadata, pipelines, jobs, discussions, notes, and job logs.
- Use exact project path and MR IID; do not infer the project from a similarly named checkout.
- Poll with bounded intervals and report progress periodically.
- If a job is manual, skipped, allowed-to-fail, or intentionally long-lived, classify it explicitly rather than silently treating it as a failure.
- If a pipeline is blocked by an external approval, protected environment, missing secret, or policy gate, report the blocker instead of retrying indefinitely.
- Retry a failed job or pipeline only when the failure is clearly transient or the user explicitly asks to rerun validation.
- Do not retry a job whose failure indicates a source-code problem before collecting its log.

## Review interpretation

- A blocking/request-changes finding requires a fix or an explicit user-approved deferral.
- A warning should normally be fixed when it is local, low-risk, and clearly applicable.
- Suggestions should be batched when they improve correctness, consistency, accessibility, performance, or repository compliance without expanding scope.
- Accepted/deferred findings should be recorded as deferred, not repeatedly reimplemented.
- Infrastructure failures (runner setup, registry outages, corrupted dependency installs, flaky external services) should be separated from code findings and retried only when appropriate.

## Safety rules

- Do not expose tokens, cookies, Access URLs containing credentials, service tokens, or unredacted customer data in reports or commits.
- Do not apply production access, gate, permission, or infrastructure changes as part of an MR review loop without explicit approval.
- Do not delete or mutate shared customer/test-account resources without a dedicated fixture and cleanup plan.
- Do not force-push or rewrite MR history unless explicitly requested.
- Do not mark a pipeline green based only on a stale merge-result pipeline when the source head has changed.

## Completion criteria

Stop only when:

- The latest MR head has no unresolved blocking review findings.
- All required finite CI jobs are green or explicitly accepted by repository policy.
- Preview/deployment jobs are available when manual verification is required.
- Local validation relevant to the change has passed, or known environment limitations are documented.
- The worktree is clean and the final pushed SHA is recorded.

Final status should include:

- final commit SHA
- pipeline URL and status
- tests/checks run
- remaining accepted/deferred findings
- any infrastructure or environment limitations
- manual verification links and instructions, if applicable
