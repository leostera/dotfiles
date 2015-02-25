#!/bin/sh

# Install homebrew & brew-cask

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew tap caskroom/cask
brew install brew-cask
brew tap caskroom/versions

brew update
brew upgrade
brew doctor
