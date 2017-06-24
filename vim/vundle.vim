set nocompatible
filetype off

function! InstallVundlePlugins ()
  :source ~/.vimrc
  :PluginInstall
endfunction

autocmd! BufWritePost vundle.vim :call InstallVundlePlugins()

set rtp+=~/.vim/bundle/vundle
call vundle#begin()

" Search
Plugin 'junegunn/fzf.vim'

" Tmux
Plugin 'benmills/vimux'
Plugin 'tmux-plugins/vim-tmux'

" Status line
Plugin 'itchyny/lightline.vim'

" Zen mode
Plugin 'junegunn/goyo.vim'

" Git
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'

" Syntax checker
Plugin 'w0rp/ale'

" Languages {

  Plugin 'vim-scripts/applescript.vim'
  Plugin 'ekalinin/Dockerfile.vim'
  Plugin 'keith/swift.vim'
  Plugin 'tpope/vim-markdown'

  " Rust
  Plugin 'rust-lang/rust.vim'
  Plugin 'racer-rust/vim-racer'

  " Lisps
  Plugin 'wlangstroth/vim-racket'
  Plugin 'fasiha/pollen.vim'

  " JS
  Plugin 'mxw/vim-jsx'
  Plugin 'pangloss/vim-javascript'

  " JS Dialects
  Plugin 'leafgarland/typescript-vim'
  Plugin 'kchmck/vim-coffee-script'

  " HTML
  Plugin 'hail2u/vim-css3-syntax'
  Plugin 'othree/html5.vim'
  Plugin 'mattn/emmet-vim'
  Plugin 'digitaltoad/vim-jade'

  " Erlang
  Plugin 'vim-erlang/vim-erlang-tags'

  " Elixir
  Plugin 'elixir-lang/vim-elixir'

  " Idris
  Plugin 'idris-hackers/idris-vim'

  " Scala
  Plugin 'derekwyatt/vim-scala'

  " Java
  Plugin 'artur-shaik/vim-javacomplete2'

" }

" Editing
Plugin 'Raimondi/delimitMate'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'ludovicchabant/vim-gutentags'
Plugin 'tpope/vim-surround'

" Theme
Plugin 'flazz/vim-colorschemes'

call vundle#end()

filetype plugin indent on
