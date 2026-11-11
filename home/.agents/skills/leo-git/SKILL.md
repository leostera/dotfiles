---
name: leo-git
description: Follow Leo's Git preferences for the <repo>/main + sibling worktree layout, keeping worktrees rebased, worktree purpose (concurrency vs experiment), commits, safe history, and deploying only integrated code; use when cloning, creating or working in worktrees, committing, integrating branches, or deploying from a Git checkout.
---

# Leo Git Preferences

Use this skill when creating, locating, using, deploying from, or removing Git worktrees.

## Pick the worktree's purpose first

Every worktree has exactly one of two purposes. Decide which before creating it and state it to Leo. If unsure, ask.

| | Concurrency worktree | Experiment worktree |
|---|---|---|
| Why | Avoid stepping on other agents in the same checkout | Fool around, prototype, benchmark |
| Branch name | normal (`fix/...`, `feat/...`) | `exp/<topic>` |
| Lifetime | Short: minutes to hours | As long as the experiment |
| Base | Fresh `origin/<default>` | Fresh `origin/<default>` (or whatever the experiment needs) |
| Deploys | **Never** | Only isolated, throwaway resources (see below) |
| Ends with | Rebased and integrated into the default branch ASAP | Results reported; code promoted only via a new concurrency branch |

The `exp/` prefix is how anyone (including a later agent) tells the two apart. Never treat a non-`exp/` worktree as a place to deploy from.

### Concurrency worktrees: integrate ASAP

A concurrency worktree exists only so parallel agents don't collide. It is not a place for work to live.

- Keep the change small and focused, and commit as you go.
- Keep it rebased on the latest default branch at all times (see Keeping worktrees rebased).
- What "integrate ASAP" means depends on who owns the default branch. Determine the mode before starting (see below).

#### Mode A: PR process (shared repos, e.g. work with Forbes or other collaborators)

The default branch is protected by review; we don't merge into it ourselves.

- Push the branch and open a **draft** PR/MR early, right after the first meaningful commit, not when the work is "done". Keep pushing small commits to it.
- Rebase onto `origin/<default>` often so the PR never drifts. Updating our own PR branch after a rebase uses `git push --force-with-lease` on that branch only; never plain `--force`, and never on a branch someone else also pushes to.
- Mark it ready for review as soon as checks pass, and follow the repo's review flow (see the merge-request-review-loop skill). Do not merge it yourself unless Leo says so.

#### Mode B: we control the default branch

Integration means landing on the default branch, not opening a PR and parking work.

- Land each coherent, tested increment on the default branch as soon as it's ready, rather than batching the whole task at the end.
- Rebase onto the latest default branch, run the checks, then fast-forward: `git -C <main-clone> merge --ff-only <branch>` while the main clone is on the default branch, and push the default branch if the repo has a remote. If fast-forward fails because the default branch moved, rebase and retry. No merge commits, no force-pushing the default branch.
- Keep the worktree branch right behind the default branch, and start the next increment from there.

#### Picking the mode

Check, in order: the repo's `AGENTS.md`/`CONTRIBUTING`/README instructions; whether the default branch is protected or the remote belongs to someone else; recent history (merge commits from PRs vs. direct commits). If it's still unclear, ask Leo, and suggest recording the answer in the repo's `AGENTS.md` (for example, `Integration: PR` or `Integration: direct to main`) so it's never guessed again.

#### Both modes

- Do not deploy from it, ever, not even "just to test". Deploys happen from the default branch after integration (see Deploying).
- After integrating, tell Leo the worktree can be removed; removal still needs his confirmation.

### Experiment worktrees: deploy only isolated resources

Experiments may deploy, but only things that cannot be mistaken for, or replace, real resources:

- Use unique, clearly-labelled names (for example, suffix `-exp-<topic>` on Worker names, queues, buckets, databases). Never reuse a production, staging, or shared resource name, environment, route, custom domain, or binding target.
- Do not deploy to the default/prod environment of the repo's config. If the config only has a prod target, create a separate one-off config or override names explicitly, and show Leo what will be deployed before the first deploy.
- Keep a list of every resource created, and offer to tear them down when the experiment ends (teardown is destructive, so confirm first).
- Never merge an `exp/` branch into the default branch directly. To keep results, cherry-pick or rewrite them onto a fresh concurrency branch and integrate that normally.

## Deploying

Shared resources (production, staging, anything other people or services depend on) are deployed only from the default branch, with code that is integrated upstream.

- If the repo deploys through CI/Builds, don't deploy by hand: integrate and let the pipeline ship it.
- Otherwise, deploy only from the main clone, after checking all of the following. If any check fails, stop and tell Leo; do not work around it.
  - `git fetch` succeeded.
  - The current directory is the main clone, not a linked worktree (`git rev-parse --git-dir` equals `git rev-parse --git-common-dir`).
  - The current branch is the default branch.
  - `git status --porcelain` is empty.
  - `HEAD` equals `origin/<default>` (nothing unpushed, nothing missing).
- From an `exp/` worktree, only the isolated deploys described above are allowed. From any other worktree or branch, no deploys at all.

## Worktree layout

Every repository gets its own directory. The main clone always lives in `main/` inside it, and every linked worktree is a sibling of `main/`:

```text
~/Developer/<host>/<owner>/
└── <repo-name>/                 # plain directory, not a Git checkout
    ├── main/                    # main clone, always on the default branch
    ├── fix-login-redirect/      # worktree for branch fix/login-redirect
    └── exp-sqlite-cache/        # worktree for branch exp/sqlite-cache
```

- `main/` is the main clone even when the default branch is called something else (`master`, `trunk`). Keep it on the default branch; do not do feature work in it.
- The worktree directory name is the branch name with `/` replaced by `-` (`feat/x` → `feat-x`), so every worktree is a direct sibling of `main/`. Never name a worktree `main`.
- Derive paths from the main clone: `<repo-dir>` is `$(dirname <main-clone>)` and a worktree goes at `<repo-dir>/<worktree-name>`. If the current directory is a linked worktree, find the main clone first with `git worktree list` (its first entry).
- `repo <owner>/<repo>` (from Leo's dotfiles) clones into `<repo>/main` and `repo <owner>/<repo> --worktree <branch>` creates or reuses a worktree beside it. Prefer it when available.

Legacy layouts (a clone directly at `<owner>/<repo>/` with worktrees in `<repo>-worktrees/`) still exist. Do not move or re-clone them on your own; offer to migrate, and follow the existing layout for that repo until Leo agrees.

## Creating worktrees

Before creating one, check `git worktree list` and inspect the target path. Reuse an existing worktree for that branch when appropriate; do not overwrite or delete a non-empty path.

From the repo directory (the parent of `main/`), for a new branch, fetch first and base it on the fresh remote default branch, not a possibly stale local one:

```sh
git -C main fetch origin
git -C main worktree add --no-track -b feat/x ../feat-x origin/main
```

For an existing local branch:

```sh
git -C main worktree add ../feat-x feat/x
```

Note that `git -C main worktree add` resolves the path relative to `main/`, so `../feat-x` lands beside it. If the branch exists only on a remote, base the new local branch on that remote ref (`-b feat/x ../feat-x origin/feat/x`) instead of creating an unrelated branch. Then rebase it onto the default branch as below.

After creation, verify with `git -C main worktree list` and `git -C <worktree-path> status --short --branch`.

## Keeping worktrees rebased

A worktree branch must always sit on top of the latest default branch. Rebase it:

- right after creating it, if it wasn't just based on a fresh `origin/<default>`;
- before starting each work session or task in it;
- whenever the default branch moves (another worktree landed, someone pushed);
- before every push, PR update, or integration.

```sh
git -C <worktree> fetch origin
git -C <worktree> rebase origin/<default>
```

Also keep `main/` itself current with `git -C main pull --ff-only` when it is clean and on the default branch; if it cannot fast-forward, stop and tell Leo rather than resetting it.

Rebase in the worktree, never in `main/`. Commit or stash (`git stash push -m ...`, never dropped without asking) before rebasing so nothing is lost. If conflicts appear, resolve them in the worktree; if a resolution is unclear, `git rebase --abort` (restores the pre-rebase state) and ask Leo. Never merge the default branch into a worktree branch; always rebase.

## Commit style and cadence

Prefer Conventional Commits (for example, `feat: add worktree support` or `fix: preserve branch names`) unless the repository documents or consistently uses a different convention. Check the repository's contribution guidance and recent commit history, and follow its established style when it differs.

Commit often in small, focused increments. Keep each commit to one coherent, reviewable change rather than accumulating a large mixed diff; avoid including unrelated changes or user work. Before committing, review the staged diff and ensure it contains only the intended increment.

## Preservation-first Git safety

Prefer additive or reversible approaches that preserve the original state; when undoing a change, prefer a compensating change or commit over erasing history or data. Do not use destructive operations such as `git restore`, `git reset`, `git checkout --`, `git clean`, force-pushes, or branch/worktree deletion as a shortcut for a dirty or confusing state. The one standing exception: `git push --force-with-lease` to update our own PR branch after a rebase (Mode A above).

Always get explicit confirmation from Leo before performing any destructive operation—even when it appears safe, such as deleting a clean worktree whose branch has been merged. Before asking, explain what will be affected and check whether a non-destructive alternative will work. If approved, inspect the affected worktree, branch, and commits first; preserve anything uncertain and proceed only with the confirmed scope. Never treat a clean status or merged branch as permission by itself. It is easier to remove unneeded code later than to recover code that was deleted.

## Safety

- Do not move, rename, or repurpose the main clone to create a worktree.
- Check for uncommitted changes before any operation that could affect a checkout; preserve user changes.
- Before removing a worktree or branch, get explicit confirmation from Leo, then verify it is clean and its work is safely integrated or otherwise preserved. Never force-remove it or delete its directory blindly.
- Follow repository-specific instructions when they define a different layout or workflow.
