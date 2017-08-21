#!/bin/sh

function symlink {
  ln -sfv "`pwd`/$1" $HOME
}

# Symlinking all dotfiles!
for dotfile in */.*; do
  symlink $dotfile;
done

ln -sfv `pwd`/vim   $HOME/.vim
ln -sfv `pwd`/tmux  $HOME/.tmux
ln -sfv `pwd`/stack $HOME/.stack
