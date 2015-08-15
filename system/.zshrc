function sourcelink {
    source `readlink $1`
}

sourcelink $HOME/.env
sourcelink $HOME/.path
sourcelink $HOME/.alias
sourcelink $HOME/.prompt

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

export NODE_PATH=./lib/:./modules/
export NODE_ENV=LOCAL

$(boot2docker shellinit)
