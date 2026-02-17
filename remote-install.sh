#!/usr/bin/env sh
set -e

BRANCH=main
OWNER=leostera
REPO=dotfiles
DOTFILES=~/Developer/github.com/${OWNER}/${REPO}

echo "Creating dotfiles path..."
mkdir -p ${DOTFILES}
cd ${DOTFILES}

echo "Downloading dotfiles..."
curl -fsSL https://codeload.github.com/${OWNER}/${REPO}/tar.gz/${BRANCH} > ${BRANCH}.tar.gz

echo "Extracting..."
tar -xf ${BRANCH}.tar.gz
mv ${REPO}-${BRANCH}/* .

echo "Bootstrapping..."
./bootstrap.sh

echo "Cleaning..."
rm -rf ${REPO}-${BRANCH} ${BRANCH}.tar.gz
