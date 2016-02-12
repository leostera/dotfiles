function sourcelink {
	p=eval "readlink ${1}";
  source $p;
}

for dotfile in 'env' 'path' 'alias' 'prompt'; do
  . "${HOME}/.${dotfile}";
done

export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH" # gnu flavoured utils
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export PATH="$PATH:/usr/local/sbin"

export NVM_DIR=~/.nvm
export PATH="$PATH:$HOME/repos/gitrdun/bin" # klarna git utils
export PATH="$HOME/repos/naked-chef:$PATH" # naked path 

export NODE_PATH=./lib/:./modules/
export NODE_ENV=LOCAL
source /usr/local/opt/nvm/nvm.sh

export RBENV_ROOT=/usr/local/var/rbenv

export HISTSIZE=1000000
export SAVEHIST=1000000
export HISTFILE=~/.zhistory

fpath=(/usr/local/share/zsh-completions $fpath)
autoload -U compinit; compinit

. /usr/local/etc/profile.d/z.sh
. $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

r16
