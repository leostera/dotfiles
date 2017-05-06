#!/bin/sh

# Tap 'em!
brew tap tldr-pages/tldr

# Brewable installs!

brew install \
  aircrack-ng \
  coreutils \
  ctags \
  dockutil \
  fzf \
  gettext \
  gist \
  git \
  git-extras \
  gnu-sed --default-names \
  htop \
  hub \
  nmap \
  node \
  python \
  ripgrep \
  ruby \
  tldr \
  tmux \
  tree \
  vim \
  wget \
  yarn

brew install --HEAD universal-ctags/universal-ctags/universal-ctags

pip install --upgrade setuptools
pip install --upgrade pip
