set nocompatible
filetype off

function! Install ()
  :source ~/.vimrc
  :PlugUpgrade
  :PlugInstall
  :PlugClean
endfunction

autocmd! BufWritePost plugins.vim :call Install()

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')

" Icons
" Plug 'ryanoasis/vim-devicons'

" Search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Tmux
" Plug 'benmills/vimux'
" Plug 'tmux-plugins/vim-tmux'

" Status line
Plug 'itchyny/lightline.vim'

" Zen mode
Plug 'junegunn/goyo.vim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Syntax checker
" Plug 'w0rp/ale'

" Reformattter
" Plug 'Chiel92/vim-autoformat'

" Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}
" Plug 'lifepillar/vim-mucomplete'

Plug 'neovim/nvim-lsp'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'nvim-lua/completion-nvim'

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
  Plug 'simrat39/rust-tools.nvim'

  " Lisps
  Plug 'wlangstroth/vim-racket'
  Plug 'fasiha/pollen.vim'

  " JS
  Plug 'mxw/vim-jsx'
  Plug 'pangloss/vim-javascript'

  " JS Dialects
  Plug 'leafgarland/typescript-vim'
  Plug 'kchmck/vim-coffee-script'

  " Erlang
  Plug 'vim-erlang/vim-erlang-tags'
  Plug 'vim-erlang/vim-erlang-runtime'
  Plug 'vim-erlang/vim-erlang-omnicomplete'
  Plug 'vim-erlang/vim-erlang-compiler'

  " Elixir
  Plug 'elixir-editors/vim-elixir'
  Plug 'slashmili/alchemist.vim'

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

  " LaTeX
  Plug 'lervag/vimtex'

  " Nix
  Plug 'LnL7/vim-nix'

  " RDF/N3/Turtle
  Plug 'vim-scripts/n3.vim'

  " Alloy
  Plug 'whybin/alloy.vim'

  " EBNF
  Plug 'vim-scripts/ebnf.vim'

  " WASM
  Plug 'rhysd/vim-wasm'

  " Flutter
  Plug 'dart-lang/dart-vim-plugin'
  Plug 'thosakwe/vim-flutter'

  " CSV
  Plug 'chrisbra/csv.vim'

  " SPARQL
  Plug 'rvesse/vim-sparql'

  " GLSL
  Plug 'tikhomirov/vim-glsl'

  " LSP
  Plug 'prabirshrestha/vim-lsp'

  Plug 'rescript-lang/vim-rescript'

  " Gleam
  Plug 'gleam-lang/gleam.vim'

" }

" Editing
" Plug 'Raimondi/delimitMate'
" Plug 'ntpeters/vim-better-whitespace'
" Plug 'kien/rainbow_parentheses.vim'
Plug 'tpope/vim-surround'

" Theme
Plug 'flazz/vim-colorschemes'
Plug 'felixhummel/setcolors.vim'

call plug#end()

filetype plugin indent on
