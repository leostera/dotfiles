#!/bin/sh

# Install homebrew & brew-cask

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew tap caskroom/cask
brew install brew-cask
brew tap caskroom/versions
brew install homebrew/completions/brew-cask-completion

brew update
brew doctor
