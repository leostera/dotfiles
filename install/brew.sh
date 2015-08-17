#!/bin/sh

# Tap 'em!
brew tap tldr-pages/tldr

# Brewable installs! 

brew install ack
brew install aircrack-ng
brew install asciinema
brew install coreutils
brew install dockutil
brew install erlang rebar
brew install git git-extras
brew install gnu-sed --default-names
brew install grep --default-names
brew install nmap
brew install npm
brew install python python3
brew install ruby
brew install sbcl 			# Steel Bank Common Lisp
brew install tldr
brew install tmux
brew install tree
brew install vim
brew install visionmedia-watch
brew install wget

pip install --upgrade setuptools
pip install --upgrade pip

# what the fuck is this doing here, put it somewhere else
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
