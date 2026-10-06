---
name: rfds
description: Create, review, and maintain numbered Request for Discussion (RFD) documents for software projects. Use when proposing architecture or policy changes, recording system-design snapshots, allocating an RFD number, adapting an RFD template to a repository, or turning an accepted RFD into an implementation checklist.
---

# RFDs

Use RFDs to make consequential technical or policy decisions reviewable before—or, for snapshot RFDs, accurately documented after—implementation. An RFD should explain the problem, teach the proposed mental model, specify the technical contract, and honestly examine drawbacks and alternatives.

The bundled starting point is [`assets/RFD0000-template.md`](assets/RFD0000-template.md).

## First: discover the project's convention

Never impose this skill's template blindly on an established repository.

1. Read repository instructions such as `AGENTS.md` and `CONTRIBUTING.md`.
2. Search for `docs/rfds/`, `rfds/`, `RFD0000-template.md`, ADRs, design docs, and an RFD index.
3. Read the local template completely.
4. Read at least two relevant RFDs: one recent document and one close to the proposal's domain. Prefer accepted or implemented documents when status is recorded.
5. Preserve the repository's naming, metadata, section capitalization, link style, status vocabulary, and numbering process.
6. Use the bundled template only when no stronger local convention exists.

Do not treat a large issue, product brief, or implementation checklist as an RFD without checking the project's terminology.

## Decide whether an RFD is appropriate

Write an RFD for changes that affect architecture, public contracts, security boundaries, data models, operations, contributor mental models, or multiple subsystems. A small local refactor or obvious bug fix usually does not need one.

Choose the document mode explicitly:

- **Proposal RFD:** recommends a future decision and invites discussion.
- **Snapshot RFD:** records the current implemented contract; say clearly that it is descriptive, not a redesign.
- **Policy RFD:** defines rules and explains their concrete effect on contributors or operators.

If the design is not yet understood well enough to compare alternatives, begin with an issue or exploration note rather than disguising uncertainty as a complete design.

## Allocate the document

When the repository has no explicit allocation process:

1. List files matching `RFD[0-9][0-9][0-9][0-9]-*.md`.
2. Ignore templates and companion files such as `RFD####-implementation-checklist.md` when finding the highest assigned RFD ID.
3. Select the next integer and zero-pad it to four digits.
4. Check the working tree, open branches, issues, or PRs when available to avoid concurrent allocation conflicts.
5. Use `RFD####-lowercase-hyphenated-title.md`.
6. Never renumber an existing RFD merely to fill a gap.

If allocation is centralized in an issue tracker or maintainers assign numbers, follow that process instead.

## Research before drafting

Inspect the code and documentation that the proposal changes. Record current behavior accurately and cite repository-relative paths where useful. Identify:

- the user, operator, or contributor problem;
- affected subsystems and existing contracts;
- invariants that must remain true;
- compatibility, migration, rollout, security, privacy, and observability concerns;
- the smallest viable scope and explicit non-goals;
- at least one simpler alternative and the impact of doing nothing;
- relevant prior art, including failed or superseded approaches in the same project.

Do not invent APIs, current behavior, benchmark results, or implementation status. Label assumptions and unknowns.

## Write the RFD

Start from the local template, or copy `assets/RFD0000-template.md` when the project has none. Replace every placeholder and remove instructional comments before finalizing.

The core narrative should have two levels:

### Guide-level explanation

Teach the design as if it already existed. Introduce the mental model and show realistic user, operator, or contributor flows. Prefer concrete API, CLI, data, error, or migration examples over abstract claims. Explain how the proposal changes the way people understand and maintain the system.

### Reference-level explanation

Specify enough detail for implementation and review. Cover component boundaries, data flow, lifecycle, ownership, failure semantics, invariants, edge cases, compatibility, and rollout. Return to the guide-level examples and show why they work under the detailed design.

Add optional sections only when they improve the decision:

- Goals and Non-goals
- Requirements or Invariants
- Security and Privacy
- Observability
- Data Migration and Compatibility
- Rollout Plan
- Testing or Validation Plan
- Acceptance Criteria
- Implementation Plan

An RFD may include implementation phases, but avoid turning the decision document into a mutable task tracker.

## Keep implementation tracking separate

When detailed execution tracking is useful, create a companion file named:

```text
RFD####-implementation-checklist.md
```

Link it to the authoritative RFD. Use it for milestones, current status, pull-request sequencing, acceptance checks, and validation commands. Keep design rationale and contract changes in the RFD itself. If implementation changes the agreed contract, update the RFD—not only the checklist.

Do not create a checklist unless requested or consistent with the repository's practice.

## Review standard

Before finishing, verify:

- The summary states the decision or proposal in one clear paragraph.
- Motivation describes a real problem and concrete use cases, not merely a desired implementation.
- Scope and non-goals prevent accidental expansion.
- Guide-level and reference-level sections agree.
- Named concepts are consistent throughout the document.
- Invariants, edge cases, and failure behavior are explicit.
- Drawbacks are genuine costs, not token objections.
- Alternatives explain why they were rejected; include doing nothing and a simpler local solution where applicable.
- Prior art extracts lessons instead of relying on precedent as proof.
- Unresolved questions are answerable and divided between pre-acceptance, implementation-time, and out-of-scope questions when useful.
- Future possibilities are clearly non-binding.
- Claims about existing code are verified.
- Repository links and paths are relative unless the link intentionally points to an external site.
- Metadata, status, number, filename, and links follow local convention.
- No placeholders, stale product names, fake issue numbers presented as real, or accidental secrets remain.

Run the repository's Markdown formatter or linter if one exists, inspect the diff, and report the created path plus any unresolved decisions. Do not implement the proposal unless the user also asks for implementation.
