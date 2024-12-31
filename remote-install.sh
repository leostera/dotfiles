#!/usr/bin/env sh

BRANCH=main
DOTFILES=~/repos/github.com/leostera/dotfiles

echo "Creating dotfiles path..."
mkdir -p ${DOTFILES}
cd ${DOTFILES}

echo "Downloading dotfiles..."
curl https://codeload.github.com/leostera/dotfiles/tar.gz/${BRANCH} > ${BRANCH}.tar.gz

echo "Extracting..."
tar -xf ${BRANCH}.tar.gz
mv dotfiles-${BRANCH}/* .

echo "Bootstrapping..."
./bootstrap.sh

echo "Cleaning..."
rm -rf dotfiles-${BRANCH} ${BRANCH}.tar.gz

