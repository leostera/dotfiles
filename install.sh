#!/bin/sh

function symlink {
    ln -sfv "`pwd`/$1" $HOME
}

# Symlinking time!
symlink git/.gitconfig
symlink git/.gitignore_global
symlink system/.alias
symlink system/.env
symlink system/.path
symlink system/.prompt
symlink system/.zshrc
symlink system/.sbclrc
symlink system/.tmux.conf

mkdir -p $HOME/.vim
ln -sfv "`pwd`/vim/vundle.vim" $HOME/.vim
symlink vim/.vimrc

# Install time!
source ./install/prepare.sh
source ./install/zsh.sh
source ./install/brew.sh
source ./install/npm.sh
source ./install/vundle.sh

# OS X 
#source ./install/brew-cask.sh
#source ./osx/defaults.sh

source $HOME/.zshrc
