#!/usr/bin/env bash
set -euo pipefail

if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew bundle
./tools/symlink
./tools/install-hooks

if command -v zsh >/dev/null 2>&1; then
  echo "Starting new shell..."
  exec zsh
fi
