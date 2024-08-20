#!/bin/bash

sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
nix run nix-darwin --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake .
sudo mv /etc/bashrc.before-nix-darwin /etc/bashrc 
sudo cp /etc/nix/nix.conf.before-nix-darwin /etc/nix/nix.conf
