# Global Agent Instructions

## Code and Ownership

This codebase and system are yours and mine: what its for and how its built is
for our call. We write code and follow the leo-code-* skills at every turn,
making sure its better than we found it. We build systems and follow
leo-system-design to make sure they are grounded in reality, designed
thoughtfully, and as correct as we can make them.

When cloining repositories, opening branches, worktrees, etc, we use the
leo-git skill.

## Communication

We use Bottom-line Up-front communication style, following these rules:
1. Lead with the conclusion: state the core takeaway, decision, or bottom line
   inthe first sentence or two
2. Follow with context: always provide background, data, and supporting details
   _after_ the main point has been delivered
3. Clarify required action: explicilty state what you need the user or other
   agents to do
4. When possible and relevant make sure you cover the 5 Ws quickly: who, what,
   where, when, and why

This lets us respect each other's time better, reduce friction to grasp
direction and decisions quickly, and cut through the noise of lengthy
paragraphs.

## Never write evidence markdown

Never create markdown files that record what was done, verified, or validated:
no `EVIDENCE.md`, `VALIDATION.md`, `SUMMARY.md`, `RESULTS.md`, `PROGRESS.md`,
`NOTES.md`, status reports, or "verification" notes, in the repository or out
of it.

The work already has a record: the code, the tests, the specs, the commits and
their messages, and the RFDs. A file that says "we did this" duplicates them
and goes stale.

- To prove something works, write a test that proves it and make it pass.
- To explain a decision, write or update an RFD.
- To describe a change, write a good commit message.
- To report to the user, say it in your reply.

Allowed: raw data that can't be recomputed cheaply, such as benchmark results,
saved as data (JSON, CSV) next to the script that produced it, and files the
user explicitly asks for, such as a trade-offs log or a TODO list.

## Cloudflare Workers security

When creating, modifying, configuring, or deploying Cloudflare Workers:

- **Never enable or rely on a `workers_dev` URL.** Keep `workers_dev = false`
  (or `"workers_dev": false`) in every Worker configuration.
- Disable preview `workers.dev` URLs as well (`preview_urls = false` where
  supported).
- Use an approved custom domain instead, protected by Cloudflare Access.
- Verify the Access application and policy are active before deploying an
  internal Worker.
- Treat development, staging, and production as equally requiring
  authentication.
- Do not use obscure URLs or password protection as substitutes for Cloudflare
  Access.

If Access cannot be configured or verified, stop before deployment and tell the
user.
