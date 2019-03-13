#!/bin/sh

# Tap 'em!
brew tap tldr-pages/tldr

# Brewable installs!

brew install \
  coreutils \
  fzf \
  gettext \
  gist \
  git \
  git-extras \
  gnu-sed \
  gnu-tar \
  gpg \
  htop \
  rg \
  tldr \
  tmux \
  tree \
  vim \
  wget

brew install \
  universal-ctags/universal-ctags/universal-ctags --HEAD
  
FZF_VERSION=$(fzf --version | awk -F' ' '{ print $1 }')
/usr/local/Cellar/fzf/${FZF_VERSION}/install
