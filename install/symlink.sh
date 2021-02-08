#!/bin/zsh

function symlink() {
  ln -sfv "`pwd`/$1" $2
}

# Symlinking all dotfiles!
for dotfile in */.*; do
  if [[ -f $dotfile ]]; then
    symlink $dotfile $HOME;
  fi
done

# Symlinking all binaries!
for binary in bin/*; do
  if [[ -f $binary ]]; then
    symlink $binary $HOME/.bin/;
  fi
done

ln -sfv `pwd`/kitty $HOME/.config/kitty
ln -sfv `pwd`/vim   $HOME/.vim
ln -sfv `pwd`/tmux  $HOME/.tmux

for configF in ./config/*; do
  ln -sfv "`pwd`/$configF" $HOME/.config/
done

