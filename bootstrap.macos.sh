#!/usr/bin/env bash
set -euo pipefail

if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew bundle

if command -v kb-remap >/dev/null 2>&1; then
  kb-remap --map capslock:lcontrol
fi

./tools/symlink
./tools/setup-upstream

if command -v zsh >/dev/null 2>&1; then
  echo "Starting new shell..."
  exec zsh
fi
