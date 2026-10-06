# Agent notes

This repository contains portable macOS and Ubuntu/Debian dotfiles. Keep the
setup simple: shell scripts, Homebrew Bundle files, and symlinks. Shared files
must not require work accounts, internal services, personal credentials, or
machine-specific absolute paths.

## Layout

- `home/.bin/` — user scripts
- `home/.config/` — XDG application configuration
- `home/.agents/skills/` — reusable agent skills
- `home/.pi/` — Pi support files; runtime state is local and ignored
- `Brewfile` — shared macOS packages
- `Brewfile.linux` — shared Linux packages
- `tools/symlink` — installs configuration symlinks
- `tools/audit-public.sh` — checks staged files or reachable history

## Making changes

- Inspect `git status` before editing; preserve unrelated local files and changes.
- Edit the source under this repository, not the installed symlink target.
- Keep account and machine-specific values in ignored local override files.
- Never add credentials, private keys, SSH `known_hosts`, or generated runtime
  state to tracked files.
- Do not add work-specific package bundles or service configuration to the
  shared baseline.
- Keep bootstrap behavior explicit for each supported platform.
- Prefer small shell and Lua changes over adding a configuration framework.

## Validation

Before committing, inspect `git diff` and run:

```sh
git diff --check
bash -n bootstrap.sh bootstrap.macos.sh bootstrap.linux.sh tools/symlink
zsh -n home/.config/zsh/zshrc home/.config/zsh/alias home/.bin/github-clone
./tools/audit-public.sh --staged
```

For Neovim changes, run a headless startup check when Neovim is available.
Do not stage all files blindly: local ignored and untracked configuration may be
present beside the shared dotfiles.
