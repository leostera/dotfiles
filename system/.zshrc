function sourcelink {
	p=eval "readlink ${1}";
  source $p;
}

for dotfile in 'env' 'path' 'alias' 'prompt'; do
  . "${HOME}/.${dotfile}";
done

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export PATH="$PATH:/usr/local/sbin"
export PATH="$PATH:$HOME/repos/gitrdun/bin"
export PATH="$PATH:$HOME/repos/gitrdun/bin" # klarna git utils
export PATH="$PATH:/usr/local/opt/coreutils/libexec/gnubin" # gnu flavoured utils
export PATH="$PATH:$HOME/repos/naked-chef" # naked path 

export NVM_DIR=~/.nvm
export NODE_PATH=./lib/:./modules/
export NODE_ENV=LOCAL

fpath=(/usr/local/share/zsh-completions $fpath)
autoload -U compinit; compinit

. /usr/local/etc/profile.d/z.sh
source ~/.zsh/zsh-syntax-highlightning/zsh-syntax-highlighting.zsh
