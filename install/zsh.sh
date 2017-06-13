#!/bin/sh

brew install \
  z \
  zsh \
  zsh-completions \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  zsh-history-substring-search

mkdir -p ~/.zsh

readonly ZSH=`which zsh`

echo "$ZSH" | sudo tee -a /etc/shells

$ZSH -c "compaudit | xargs chmod x-g"

chsh -s $ZSH
