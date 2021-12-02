#!/usr/bin/env sh

DOTFILES=~/repos/github.com/ostera/dotfiles

echo "Creating dotfiles path..."
mkdir -p ${DOTFILES}
cd ${DOTFILES}

echo "Downloading dotfiles..."
curl https://codeload.github.com/ostera/dotfiles/tar.gz/main > main.tar.gz

echo "Extracting..."
tar -xf main.tar.gz
mv dotfiles-main/* .

echo "Bootstrapping..."
./bootstrap.sh

echo "Cleaning..."
rm -rf dotfiles-main main.tar.gz

