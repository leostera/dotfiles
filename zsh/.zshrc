function sourcelink {
	p=eval "readlink ${1}";
  source $p;
}

for dotfile in 'env' 'path' 'alias' 'prompt'; do
  . "${HOME}/.${dotfile}";
done

. /usr/local/etc/profile.d/z.sh
. /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
. /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

if [[ -z $TMUX ]]; then
  pgrep tmux && tma || tmux
fi

bindkey -e
bindkey '^ ' autosuggest-accept

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.nix-profile/etc/profile.d/nix.sh ] && source /Users/ostera/.nix-profile/etc/profile.d/nix.sh

# Add all keys to keychain silently
ssh-add -q -K -A 2>/dev/null

# opam configuration
test -r /Users/ostera/.opam/opam-init/init.zsh && . /Users/ostera/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
