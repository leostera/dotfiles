#!/usr/bin/env sh

DOTFILES=~/repos/github.com/ostera/dotfiles

echo "Creating dotfiles path..."
mkdir -p ${DOTFILES}
cd ${DOTFILES}

echo "Downloading dotfiles..."
curl https://codeload.github.com/ostera/dotfiles/tar.gz/master > master.tar.gz

echo "Extracting..."
tar -xf -C .

./bootstrap.sh
