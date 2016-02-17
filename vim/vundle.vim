set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle
call vundle#begin()

" Generic
Plugin 'junegunn/fzf.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'terryma/vim-multiple-cursors'

Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" Git
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'

" Syntax
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-markdown'
Plugin 'othree/html5.vim'
Plugin 'digitaltoad/vim-jade'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'mattn/emmet-vim'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'elixir-lang/vim-elixir'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'leafgarland/typescript-vim'

" Theme
Plugin 'flazz/vim-colorschemes'

" Tmux
Plugin 'tmux-plugins/vim-tmux'

call vundle#end()

filetype plugin indent on
