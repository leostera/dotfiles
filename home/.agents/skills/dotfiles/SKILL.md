---
name: dotfiles
description: Maintain and use this cross-platform dotfiles repository safely, including shared configuration, installation, symlinks, and local overrides.
---

# Dotfiles

Use this skill when changing, installing, auditing, or troubleshooting this
repository's macOS and Ubuntu/Debian dotfiles.

## Repository

This setup uses shell scripts, Homebrew Bundle files, and symlinks rather than a
configuration framework. The checkout can live anywhere; installed files are
linked into `$HOME`.

Important paths:

- `home/.config/` — XDG application configuration
- `home/.bin/` — user scripts
- `home/.agents/skills/` — reusable agent skills
- `home/.pi/` — Pi support files; runtime state stays local and ignored
- `Brewfile` — macOS package baseline
- `Brewfile.linux` — Linux package baseline
- `bootstrap.sh` — platform dispatcher
- `tools/symlink` — configuration symlink manager
- `tools/audit-public.sh` — staged and historical public-safety audit
- `.githooks/pre-commit` — staged-change audit

## Editing and installation

- Inspect `git status` before editing and preserve unrelated local files.
- Edit repository source, not symlinked files in `$HOME`.
- Keep shared files portable; use `$HOME`, platform checks, and ignored local
overrides rather than machine-specific absolute paths.
- Never commit credentials, private keys, SSH host databases, tokens, or
account-specific settings.

Run the installer from the repository root:

```sh
./bootstrap.sh
```

It installs the shared package baseline, creates configuration symlinks,
configures the repository's pre-commit hook, and starts Zsh when available. SSH
keys and SSH configuration remain local under `~/.ssh`; this repository does
not symlink or manage them.

## Local overrides

Keep machine- and account-specific settings in ignored local files, including:

```text
~/.env.local
~/.config/zsh/env.local
~/.config/git/config.local
~/.config/direnv/*.local
```

`home/.config/git/config` includes `~/.config/git/config.local` for user
identity and other per-user Git settings. Do not commit the local override.

`home/.bin/github-clone` defaults to GitHub. Set `GITHUB_CLONE_HOST` in
`~/.config/zsh/env.local` to change the default host; the explicit `gh:` form
always targets GitHub.

## Public-safety checks

Ignoring a file does not remove it if it was already tracked. Before committing,
run:

```sh
./tools/audit-public.sh --staged
```

The pre-commit hook runs this check when installed. Configure it manually with:

```sh
./tools/install-hooks
```

Before publishing a repository or mirror, also review history:

```sh
./tools/audit-public.sh --history
```

The scanner is defense in depth, not a guarantee. Review suspicious findings
manually and never publish secrets or private configuration.

## Validation

Run `git diff --check`, `bash -n` for changed Bash scripts, and `zsh -n` for
changed Zsh files. For shell startup changes, test a fresh shell and distinguish
startup errors from failures caused by interactive widgets running without a
TTY.
