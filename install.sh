#!/bin/sh

function symlink {
    ln -sfv "`pwd`/$1" $HOME
}

# Symlinking all dotfiles!
for dotfile in ./*/.*; do
  symlink $dotfile;
done

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
