#!/usr/bin/env sh

DOTFILES=~/repos/github.com/ostera/dotfiles

git clone https://github.com/ostera/dotfiles ${DOTFILES}
cd ${DOTFILES}
[ -f "bootstrap.sh" ] && ./bootstrap.sh
