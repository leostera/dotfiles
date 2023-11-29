#!/bin/bash

sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
darwin-rebuild switch --flake .
sudo mv /etc/bashrc.before-nix-darwin /etc/bashrc 
