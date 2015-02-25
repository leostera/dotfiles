#!/bin/sh

brew install zsh zsh-completions

ZSH = `which zsh`

echo "$ZSH" | sudo tee -a /etc/shells

chsh -s $ZSH
