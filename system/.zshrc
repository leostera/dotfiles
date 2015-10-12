function sourcelink {
    source `readlink $1`
}

for dotfile in 'env' 'path' 'alias' 'prompt'; do
  sourcelink "${HOME}/.${dotfile}";
done

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export PATH="/usr/local/sbin:$PATH"

export NVM_DIR=~/.nvm
export NODE_PATH=./lib/:./modules/
export NODE_ENV=LOCAL

fpath=(/usr/local/share/zsh-completions $fpath)
autoload -U compinit; compinit

. /usr/local/etc/profile.d/z.sh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
