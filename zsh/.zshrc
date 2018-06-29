function sourcelink {
	p=eval "readlink ${1}";
  source $p;
}

for dotfile in 'env' 'path' 'alias' 'prompt'; do
  . "${HOME}/.${dotfile}";
done

fpath=(/usr/local/share/zsh-completions $fpath)
autoload -U compinit; compinit

. /usr/local/etc/profile.d/z.sh
. /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
. /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

if [[ -z $TMUX ]]; then
  pgrep tmux && tma || tm
fi

bindkey -e
bindkey '^ ' autosuggest-accept

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
