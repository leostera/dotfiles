---
name: leo-research
description: Conduct and persist research for any project in the user's private ai-research repository; use whenever the user asks for research, investigation, comparison, evidence gathering, or a durable answer to revisit later.
---

# Leo Research Protocol

Use this workflow for research across personal and work projects. Research should be useful later, traceable to its evidence, and saved in one place rather than left only in chat or scattered across project repositories.

## Repository and organization

The research repository is the existing private Git repository at:

```text
~/Developer/github.com/leostera/ai-research
```

Its remote is `git@github.com:leostera/ai-research.git`. Use this one repository for now; do not create a separate research repository per project.

Follow the repository's existing folder convention:

```text
personal/<project>/<topic>/
work/<company>/<project>/<topic>/
```

Use a short, descriptive kebab-case topic name. Check the existing folders and Git history first; reuse or extend an existing topic when appropriate, and do not overwrite previous research. If it's unclear whether work belongs under `personal/` or `work/<company>/`, ask rather than guess. The existing `work/cloudflare/` folder is one example, not the only permitted work area.

Default to the repository's `main` branch and a new topic folder. Do not create a branch for every small investigation. Use a separate `research/<topic>` branch when the user asks, or when the work is substantial, collaborative, or benefits from review before merging.

If the repository is not at the expected path, check for an existing clone before creating one. If none exists, clone the private remote to the expected path; do not make another repository or store credentials in the skill. If access fails, report that instead of falling back to a public or per-project location.

## Research workflow

### 1. Frame the question

Clarify the question, decision it should inform, scope, relevant date/version, and any constraints. Ask only for missing information that materially changes the research. For a small, well-scoped question, state reasonable assumptions and proceed.

Before researching, inspect the repository status and its `README.md`; look for an existing topic and any repository guidance. Preserve unrelated local changes. Do not pull, reset, clean, or switch branches over user work.

### 2. Gather and evaluate evidence

- Prefer primary sources: specifications, official documentation, original papers, source code, product announcements, and first-party data.
- Use secondary sources to add context or challenge an interpretation, not as a substitute for primary evidence when primary evidence is available.
- Check publication/update dates and version applicability. Record when each source was accessed.
- Support consequential factual claims with source references. Do not invent sources, dates, quotations, or certainty.
- Separate verified facts from interpretation, recommendations, assumptions, and unanswered questions. Note meaningful disagreement or uncertainty.
- Quote sparingly. Save links and concise notes in your own words; do not copy whole articles, books, papers, private documents, or other copyrighted material into the repository.
- If sources cannot be accessed or verified, say so and limit the conclusion accordingly.

### 3. Write a durable research note

Create one folder per research topic under the appropriate `personal/` or `work/<company>/` path. Keep the record concise but complete enough that a future reader can understand the question and retrace the evidence without this chat.

Use this structure:

```text
<topic>/
  README.md       # question, scope, findings, conclusion, open questions
  sources.md     # source list and claim-to-source notes
  notes/         # optional working notes, only when useful
  artifacts/     # optional small, reproducible scripts or generated material
```

`README.md` should include:

- research question and the decision or use case it informs;
- status (`in progress` or `complete`), created/updated date, and scope;
- a short answer or executive summary;
- key findings and their evidence links (for example, `[S1]`);
- analysis, tradeoffs, and recommendation, clearly distinguished from source facts;
- assumptions, confidence, limitations, and open questions.

`sources.md` should give each source a stable ID (`S1`, `S2`, ...), title, author or organization when known, publication/update date when known, URL, access date, and the claims or sections it supports. Prefer direct links to the relevant page or section.

Add extra files only when they make the research more useful or reproducible. Keep file names and links relative to the topic folder; avoid machine-specific absolute paths and dependencies on files outside the research repository.

### 4. Protect sensitive information

The repository is private, but it is still a remote repository and not a secrets vault. Never commit passwords, tokens, private keys, credentials, session data, or customer-identifying data. Do not copy restricted internal documents or proprietary source code into the repository unless the user has confirmed that storing them there is allowed. If the classification or permission is unclear, ask before recording the material; a high-level summary with approved citations may be safer.

Review generated outputs, logs, notebooks, and copied snippets for secrets and sensitive data before staging. Keep research in the correct personal/work subtree; do not move work details into `personal/` to bypass restrictions.

### 5. Commit the research locally

The purpose of this repository is to preserve research, so create a local commit by default once the note is coherent. Before committing:

1. Check `git status` and inspect the new topic folder.
2. Run `git diff --check` and review the staged diff for accidental secrets, unsupported claims, broken links, and machine-specific paths.
3. Stage only the research topic's files. Never use `git add -A` when unrelated changes are present.
4. Commit with a clear message, such as `research: <topic>`.

Do not push unless the user explicitly asks. If the repository has unrelated changes, preserve them and commit only the research folder. If the branch has diverged or a conflict would require altering user work, stop and report the issue rather than resetting or force-pushing.

## Report back

Give the user the short answer, the research folder path, the local commit hash, the most important sources, and any material uncertainty or follow-up question. Make clear whether anything was committed or pushed.
