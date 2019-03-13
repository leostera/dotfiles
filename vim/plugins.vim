set nocompatible
filetype off

function! Install ()
  :source ~/.vimrc
  :PlugInstall
endfunction

autocmd! BufWritePost plugins.vim :call Install()

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')

" Search
Plug 'junegunn/fzf.vim'

" Tmux
Plug 'benmills/vimux'
Plug 'tmux-plugins/vim-tmux'

" Status line
Plug 'itchyny/lightline.vim'

" Zen mode
Plug 'junegunn/goyo.vim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Syntax checker
Plug 'w0rp/ale'

" Reformattter
Plug 'Chiel92/vim-autoformat'

" Languages {

  Plug 'vim-scripts/applescript.vim'
  Plug 'ekalinin/Dockerfile.vim'
  Plug 'keith/swift.vim'
  Plug 'tpope/vim-markdown'

  " Bazel
  Plug 'bazelbuild/vim-ft-bzl'
  Plug 'durandj/bazel.vim'

  " Rust
  Plug 'rust-lang/rust.vim'
  Plug 'racer-rust/vim-racer'

  " Lisps
  Plug 'wlangstroth/vim-racket'
  Plug 'fasiha/pollen.vim'

  " JS
  Plug 'mxw/vim-jsx'
  Plug 'pangloss/vim-javascript'

  " JS Dialects
  Plug 'leafgarland/typescript-vim'
  Plug 'kchmck/vim-coffee-script'

  " ReasonML
  Plug 'jordwalke/vim-reasonml'

  " Erlang
  Plug 'vim-erlang/vim-erlang-tags'

  " Elixir
  Plug 'elixir-lang/vim-elixir'

  " Idris
  Plug 'idris-hackers/idris-vim'

  " Scala
  Plug 'derekwyatt/vim-scala'

  " GraphQL
  Plug 'jparise/vim-graphql'

  " TOML
  Plug 'cespare/vim-toml'
  
  " TLA+
  Plug 'hwayne/tla.vim'

  " WASM
  Plug 'rhysd/vim-wasm'
  
  " Terraform
  Plug 'hashivim/vim-terraform'

  " Jenkinsfile
  Plug 'martinda/Jenkinsfile-vim-syntax'

" }

" Editing
Plug 'Raimondi/delimitMate'
Plug 'ntpeters/vim-better-whitespace'
Plug 'kien/rainbow_parentheses.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'tpope/vim-surround'

" Theme
Plug 'flazz/vim-colorschemes'
Plug 'felixhummel/setcolors.vim'

call plug#end()

filetype plugin indent on
