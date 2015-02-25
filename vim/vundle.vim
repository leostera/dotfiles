set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle
call vundle#begin()

" Generic
Plugin 'kien/ctrlp.vim'

" Git
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'

" Syntax
Plugin 'scrooloose/syntastic'
Plugin 'altercation/vim-colors-solarized'

" Other
Plugin 'tpope/vim-markdown'
Plugin 'mattn/emmet-vim'

call vundle#end()

filetype plugin indent on
