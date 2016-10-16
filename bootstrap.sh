#!/bin/sh

function symlink {
    ln -sfv "`pwd`/$1" $HOME
}

# Symlinking all dotfiles!
for dotfile in */.*; do
  symlink $dotfile;
done

ln -sfv `pwd`/vim $HOME/.vim
ln -sfv `pwd`/tmux/scripts $HOME/.tmux/scripts

# Install time!
#source ./install/prepare.sh
source ./install/zsh.sh
source ./install/vundle.sh
#source ./install/npm.sh

# macOS
#if [[ `uname` == "Darwin" ]]; then
  #source ./install/brew.sh
  #source ./install/brew-cask.sh
  #source ./macOS/defaults.sh
#fi

#source $HOME/.zshrc
