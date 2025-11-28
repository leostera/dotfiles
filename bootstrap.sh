#!/bin/bash -e

if [[ ! `which brew` ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
brew bundle

kb-remap --map capslock:lcontrol

./tools/symlink

echo "Starting new shell..."
exec zsh

./tools/setup-upstream
