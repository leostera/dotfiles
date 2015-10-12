function sourcelink {
    source `readlink $1`
}

for dotfile in 'env' 'path' 'alias' 'prompt'; do
  sourcelink "${HOME}/.${dotfile}";
done

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export NVM_DIR=~/.nvm
export NODE_PATH=./lib/:./modules/
export NODE_ENV=LOCAL

fpath="${HOMEBREW_PREFIX}/share/zsh-completions $fpath"
