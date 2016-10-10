function sourcelink {
	p=eval "readlink ${1}";
  source $p;
}

for dotfile in 'env' 'path' 'alias' 'prompt'; do
  . "${HOME}/.${dotfile}";
done

source /usr/local/opt/nvm/nvm.sh

fpath=(/usr/local/share/zsh-completions $fpath)
autoload -U compinit; compinit

. /usr/local/etc/profile.d/z.sh
. $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# added by travis gem
[ -f /Users/leostera/.travis/travis.sh ] && source /Users/leostera/.travis/travis.sh
