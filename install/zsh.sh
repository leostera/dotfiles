#!/bin/sh

brew install zsh zsh-completions z zsh-history-substring-search

mkdir -p ~/.zsh

cd ~/.zsh && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git

ZSH = `which zsh`

echo "$ZSH" | sudo tee -a /etc/shells

chsh -s $ZSH
