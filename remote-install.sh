#!/usr/bin/env sh

DOTFILES=~/repos/github.com/ostera/dotfiles

echo "Creating dotfiles path..."
mkdir -p ${DOTFILES}
cd ${DOTFILES}

echo "Downloading dotfiles..."
curl https://github.com/ostera/dotfiles/archive/master.tar.gz

echo "Extracting..."
tar -xf -C .
rm master.tar.gz

./bootstrap.sh
