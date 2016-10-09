#!/bin/sh

# Install Vundle
mkdir -p ~/.vim/bundle && git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

vim +PluginInstall +PluginUpdate +qall
