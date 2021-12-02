#!/bin/zsh

gpg --list-keys >/dev/null

if [[ `gpg --list-keys | wc -l` -eq "0" ]]; then
  echo "No GPG Keys! Don't even sweat it dawg, let's make a pair..."
  gpg --gen-key
else
  echo "Found GPG Keys!"
  gpg --list-keys
fi
