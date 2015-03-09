set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle
call vundle#begin()

" Generic
Plugin 'kien/ctrlp.vim'
Plugin 'terryma/vim-multiple-cursors'

" Git
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'

" Syntax
Plugin 'scrooloose/syntastic'
Plugin 'altercation/vim-colors-solarized'
Plugin 'tpope/vim-markdown'
Plugin 'othree/html5.vim'
Plugin 'digitaltoad/vim-jade'

" Other
Plugin 'mattn/emmet-vim'

call vundle#end()

filetype plugin indent on
