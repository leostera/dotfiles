#!/bin/sh

function symlink {
    ln -sfv "`pwd`/$1" $HOME
}

# Symlinking all dotfiles!
for dotfile in */.*; do
  symlink $dotfile;
done

mkdir -p $HOME/.vim
ln -sfv "`pwd`/vim/vundle.vim" $HOME/.vim

# Install time!
#source ./install/prepare.sh
#source ./install/zsh.sh
#source ./install/npm.sh
#source ./install/vundle.sh

# macOS
#if [[ `uname` == "Darwin" ]]; then
  #source ./install/brew.sh
  #source ./install/brew-cask.sh
  #source ./macOS/defaults.sh
#fi

#source $HOME/.zshrc
