#!/usr/bin/env sh
set -eu

DOTFILES_URL="${DOTFILES_URL:-https://github.com/ostera/dotfiles.git}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/Developer/dotfiles}"

if [ -e "$DOTFILES_DIR" ]; then
  echo "Refusing to overwrite existing directory: $DOTFILES_DIR" >&2
  exit 1
fi

echo "Cloning dotfiles..."
git clone "$DOTFILES_URL" "$DOTFILES_DIR"
cd "$DOTFILES_DIR"
./bootstrap.sh
