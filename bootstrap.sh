#!/bin/bash -e

if [[ ! `which nix-env` ]]; then
  sh <(curl -L https://nixos.org/nix/install) --daemon
fi

if [[ ! `which brew` ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

./tools/symlink

echo "Starting new shell..."
exec zsh

sudo nix-channel --add https://nixos.org/channels/nixpkgs-unstable unstable
sudo nix-channel --update

if [[ `uname` == "Darwin" ]]; then
  ./tools/setup-nix-darwin
fi

./tools/setup-upstream
