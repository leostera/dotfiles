#!/bin/sh

# Tap 'em!
brew tap tldr-pages/tldr

# Brewable installs!

brew install \
  ack \
  aircrack-ng \
  asciinema \
  coreutils \
  ctags \
  dockutil \
  fzf \
  git git-extras \
  gnu-sed --default-names \
  go \
  grep --default-names \
  nmap \
  npm \
  python python3 \
  ruby \
  tldr \
  tmux \
  tree \
  vim \
  wget

pip install --upgrade setuptools
pip install --upgrade pip
