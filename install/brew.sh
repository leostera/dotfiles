#!/bin/sh

# Tap 'em!
brew tap tldr-pages/tldr

# Brewable installs!

brew install \
  bazel \
  coreutils \
  fzf \
  gettext \
  gist \
  git \
  git-extras \
  gnu-sed --default-names \
  gnu-tar --default-names \
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

/usr/local/Cellar/fzf/install
