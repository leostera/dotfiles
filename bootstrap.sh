#!/bin/sh

echo "Bootstrapping will require sudo! Temporarily authenticating you now..."
sudo -v

# Install time!
source ./install/symlink.sh
source ./install/prepare.sh
source ./install/zsh.sh
source ./install/vundle.sh

# macOS
if [[ `uname` == "Darwin" ]]; then
  source ./install/brew.sh
  source ./install/brew-cask.sh
  source ./macOS/defaults.sh
fi

source ./misc/gpg.sh
source ./misc/ssh-keygen.sh
source ./install/opam.sh

echo "Open a new tab and run `pwd`/post-install.sh"
