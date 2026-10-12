---
name: leo-git
description: Follow Leo's Git preferences, especially for organizing and safely managing Git worktrees alongside the main clone.
---

# Leo Git Preferences

Use this skill when creating, locating, or removing Git worktrees.

## Worktree layout

Keep linked worktrees outside the main clone, in a sibling directory named after the repository with `-worktrees` appended:

```text
parent/
├── repo-name/                       # main clone
└── repo-name-worktrees/
    └── branch-name-here/            # linked worktree
```

The worktree directory is a sibling of the main clone, not a directory inside it. Use the main clone's parent directory and repository directory name to derive the location. If the current directory is already a linked worktree, locate the main clone first (for example, with `git worktree list`) rather than anchoring a new worktree beside the current one. Preserve slashes in branch names as nested directory components.

## Creating worktrees

Before creating one, check `git worktree list` and inspect the target path. Reuse an existing worktree for that branch when appropriate; do not overwrite or delete a non-empty path. Create the sibling worktree directory as needed.

For an existing local branch:

```sh
git worktree add ../repo-name-worktrees/branch-name branch-name
```

For a new branch:

```sh
git worktree add -b branch-name ../repo-name-worktrees/branch-name
```

Replace the example paths with the derived absolute or relative paths. If the branch exists only on a remote, base the new local branch on the appropriate remote ref instead of creating an unrelated branch.

After creation, verify the path and branch with `git worktree list` and `git -C <worktree-path> status --short --branch`.

## Commit style and cadence

Prefer Conventional Commits (for example, `feat: add worktree support` or `fix: preserve branch names`) unless the repository documents or consistently uses a different convention. Check the repository's contribution guidance and recent commit history, and follow its established style when it differs.

Commit often in small, focused increments. Keep each commit to one coherent, reviewable change rather than accumulating a large mixed diff; avoid including unrelated changes or user work. Before committing, review the staged diff and ensure it contains only the intended increment.

## Preservation-first Git safety

Prefer additive or reversible approaches that preserve the original state; when undoing a change, prefer a compensating change or commit over erasing history or data. Do not use destructive operations such as `git restore`, `git reset`, `git checkout --`, `git clean`, force-pushes, or branch/worktree deletion as a shortcut for a dirty or confusing state.

Always get explicit confirmation from Leo before performing any destructive operation—even when it appears safe, such as deleting a clean worktree whose branch has been merged. Before asking, explain what will be affected and check whether a non-destructive alternative will work. If approved, inspect the affected worktree, branch, and commits first; preserve anything uncertain and proceed only with the confirmed scope. Never treat a clean status or merged branch as permission by itself. It is easier to remove unneeded code later than to recover code that was deleted.

## Safety

- Do not move, rename, or repurpose the main clone to create a worktree.
- Check for uncommitted changes before any operation that could affect a checkout; preserve user changes.
- Before removing a worktree or branch, get explicit confirmation from Leo, then verify it is clean and its work is safely integrated or otherwise preserved. Never force-remove it or delete its directory blindly.
- Follow repository-specific instructions when they define a different layout or workflow.
