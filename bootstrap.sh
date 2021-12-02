#!/bin/bash -e

if [[ ! `which nix-env` ]]; then
  sh <(curl -L https://nixos.org/nix/install) --daemon
fi

if [[ `uname` == "Darwin" ]]; then
  nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
  ./result/bin/darwin-installer
  rm -rf ./result
fi

sudo nix-channel --add https://nixos.org/channels/nixpkgs-unstable unstable
sudo nix-channel --update

exec zsh

./tools/setup-upstream
./tools/symlink
