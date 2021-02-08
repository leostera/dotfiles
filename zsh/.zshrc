. "${HOME}/.env"
. "${HOME}/.path"
. "${HOME}/.alias"
. "${HOME}/.prompt"
. "${HOME}/.fzf.zsh"

export WASMTIME_HOME="$HOME/.wasmtime"

export PATH="$WASMTIME_HOME/bin:$PATH"
# Wasmer
export WASMER_DIR="/home/ostera/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
