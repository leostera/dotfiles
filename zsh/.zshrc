for dotfile in 'env' 'path' 'alias' 'prompt'; do
  . "${HOME}/.${dotfile}";
done

bindkey -e
bindkey '^ ' autosuggest-accept

setxkbmap -option caps:ctrl_modifier || true

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Add all keys to keychain silently
ssh-add -q -K -A 2>/dev/null
