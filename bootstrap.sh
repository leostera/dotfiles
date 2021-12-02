#!/bin/bash -e

sh <(curl -L https://nixos.org/nix/install) --daemon

if [[ `uname` == "Darwin" ]]; then
  nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
  ./result/bin/darwin-installer
  rm -rf ./result
fi

./tools/setup-upstream
./tools/symlink
