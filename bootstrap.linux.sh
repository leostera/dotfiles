#!/usr/bin/env bash
set -euo pipefail

install_prereqs() {
  if command -v apt-get >/dev/null 2>&1; then
    local sudo_cmd=""
    if [ "$(id -u)" -ne 0 ]; then
      sudo_cmd="sudo"
    fi

    ${sudo_cmd} apt-get update
    ${sudo_cmd} apt-get install -y build-essential curl file git procps
  fi
}

install_homebrew() {
  if command -v curl >/dev/null 2>&1; then
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    return
  fi

  if command -v wget >/dev/null 2>&1; then
    NONINTERACTIVE=1 /bin/bash -c "$(wget -qO- https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    return
  fi

  install_prereqs
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

if ! command -v brew >/dev/null 2>&1; then
  install_homebrew
fi

BREW_BIN=""
if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
  BREW_BIN=/home/linuxbrew/.linuxbrew/bin/brew
elif [ -x "$HOME/.linuxbrew/bin/brew" ]; then
  BREW_BIN="$HOME/.linuxbrew/bin/brew"
fi

if [ -n "${BREW_BIN}" ]; then
  eval "$("${BREW_BIN}" shellenv)"
else
  echo "Homebrew installation failed: brew binary not found."
  exit 1
fi

"${BREW_BIN}" bundle --file=./Brewfile.linux
./tools/symlink
./tools/setup-upstream

if command -v zsh >/dev/null 2>&1; then
  echo "Starting new shell..."
  exec zsh
fi
