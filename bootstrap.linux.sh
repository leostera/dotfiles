#!/usr/bin/env bash
set -euo pipefail

if ! command -v apt-get >/dev/null 2>&1; then
  echo "Unsupported Linux distro: apt-get not found." >&2
  exit 1
fi

if [ "$(id -u)" -eq 0 ]; then
  SUDO=()
else
  SUDO=(sudo)
fi

if ! command -v git >/dev/null 2>&1 || ! command -v curl >/dev/null 2>&1; then
  "${SUDO[@]}" apt-get update
  "${SUDO[@]}" apt-get install -y git curl
fi

if [ ! -x /home/linuxbrew/.linuxbrew/bin/brew ] && [ ! -x "$HOME/.linuxbrew/bin/brew" ]; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
  BREW_BIN=/home/linuxbrew/.linuxbrew/bin/brew
elif [ -x "$HOME/.linuxbrew/bin/brew" ]; then
  BREW_BIN="$HOME/.linuxbrew/bin/brew"
else
  echo "Homebrew installation failed: brew binary not found." >&2
  exit 1
fi

eval "$("$BREW_BIN" shellenv)"
"$BREW_BIN" bundle --file=./Brewfile.linux
./tools/symlink
./tools/install-hooks

if command -v zsh >/dev/null 2>&1; then
  echo "Starting new shell..."
  exec zsh
fi
