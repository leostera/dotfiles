function sourcelink {
    source `readlink $1`
}

for dotfile in 'env' 'path' 'alias' 'prompt'; do
  sourcelink "${HOME}/.${dotfile}";
done

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/repos/gitrdun/bin:$PATH"
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

export NVM_DIR=~/.nvm
export NODE_PATH=./lib/:./modules/
export NODE_ENV=LOCAL

export HISTSIZE=1000000
export SAVEHIST=1000000
export HISTFILE=~/.zhistory

fpath=(/usr/local/share/zsh-completions $fpath)
autoload -U compinit; compinit

. /usr/local/etc/profile.d/z.sh
. ${HOME}/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
