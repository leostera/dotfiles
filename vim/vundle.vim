set nocompatible
filetype off

autocmd BufWritePost vundle.vim :PluginInstall

set rtp+=~/.vim/bundle/vundle
call vundle#begin()

" Generic
Plugin 'junegunn/fzf.vim'

" Tmux
Plugin 'benmills/vimux'
Plugin 'tmux-plugins/vim-tmux'

" Status line
Plugin 'itchyny/lightline.vim'

" Git
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'

" Languages
Plugin 'digitaltoad/vim-jade'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'elixir-lang/vim-elixir'
Plugin 'kchmck/vim-coffee-script'
Plugin 'leafgarland/typescript-vim'
Plugin 'mxw/vim-jsx'
Plugin 'othree/html5.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-markdown'
Plugin 'wlangstroth/vim-racket'

  " JS
  Plugin 'flowtype/vim-flow'

  " HTML
  Plugin 'mattn/emmet-vim'

" Editing
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'craigemery/vim-autotag'

" Theme
Plugin 'flazz/vim-colorschemes'

call vundle#end()

filetype plugin indent on
