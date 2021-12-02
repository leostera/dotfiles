#!/bin/sh

curl -L https://nixos.org/nix/install | sh -- --daemon
./tools/symlink
