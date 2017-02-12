#!/bin/zsh

readonly FROM=$1

git rebase -i $FROM

while [ `git status | rg "interactive rebase in progress" | wc -l` -gt 0 ]; do
  git commit -S --amend --no-edit
  git rc
done

git l
echo "Congratulations!"
