" General

set nocompatible
set number		    "Line numbers me likey
set backspace=2     "Make backspace work like most other apps
set history=10000	"Shitload of history for :cmdline
set showcmd		    "Show me incomplete commands down bottom
set visualbell		"Please, no sounds
set autoread		"Reload files changed outside vim
set wmh=0		    "Set minimum window height to 0, helps when stacking splits

" Key mappings

let mapleader=","
nnoremap <leader><space> :noh<cr>	",<space> clears search highlightning
nnoremap <tab> :bnext<cr>		"Next buffer with TAB
nnoremap <s-tab> :bprevious<cr>		"Previous buffer with Shift+TAB
nnoremap <leader><leader> <C-^>		"Toggle last two buffers

nnoremap <leader>v :vsplit<cr>	",v splits vertically
nnoremap <leader>h :split<cr>		",h splits horizontally

" Load Plugins

if filereadable(expand("$HOME/.vim/vundle.vim"))
	source $HOME/.vim/vundle.vim
endif

" control+{h,j,k,l} to navigate between splits
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l

nnoremap tt :tabn<cr>			"double T makes a new tab
nnoremap th :tabp<cr>			"navigate tabs with H and L 
nnoremap tl :tabn<cr>       	"navigate tabs with H and L 

" Indentation

set autoindent
set smartindent
set smarttab
set tabstop=4
set expandtab
set shiftwidth=4
set softtabstop=4

filetype plugin indent on

set nowrap

" Searching

set hlsearch
set incsearch
set ignorecase
set showmatch
set smartcase

" Colors 

syntax on
set cursorline
let g:solarized_termcolors=256

" Ctrl-P config

let g:ctrlp_show_hidden=0
let g:ctrl_max_files = 600
let g:ctrl_max_depth = 6
