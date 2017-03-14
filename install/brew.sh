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
  gist \
  git \
  git-extras \
  gnu-sed --default-names \
  go \
  htop \
  hub \
  nmap \
  node \
  python python3 \
  ripgrep \
  ruby \
  tldr \
  tmux \
  tree \
  vim \
  wget
  yarn \

brew install --HEAD universal-ctags/universal-ctags/universal-ctags

pip install --upgrade setuptools
pip install --upgrade pip
