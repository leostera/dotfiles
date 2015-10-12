#!/bin/sh

brew install zsh zsh-completions z

mkdir -p ~/.zsh

git clone git://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlightning

ZSH = `which zsh`

echo "$ZSH" | sudo tee -a /etc/shells

chsh -s $ZSH
