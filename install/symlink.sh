#!/bin/sh

function symlink {
  ln -sfv "`pwd`/$1" $HOME
}

# Symlinking all dotfiles!
for dotfile in */.*; do
  if [[ -f $dotfile ]]; then
    symlink $dotfile;
  fi
done

ln -sfv `pwd`/kitty $HOME/.config/kitty
ln -sfv `pwd`/vim   $HOME/.vim
ln -sfv `pwd`/tmux  $HOME/.tmux

for configF in ./config/*; do
  ln -sfv "`pwd`/$configF" $HOME/.config/
done

