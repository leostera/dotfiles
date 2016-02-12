" General

set nocompatible
set number         "Line numbers me likey
set backspace=2    "Make backspace work like most other apps
set history=10000  "Shit load of history for :cmdline
set showcmd        "Show me incomplete commands down bottom
set visualbell     "Please, no sounds
set autoread       "Reload files changed outside vim
set wmh=0          "Set minimum window height to 0, helps when stacking splits

" Spell checking
set nospell

" Key mappings

let mapleader=","

inoremap jk <esc><esc>
nnoremap Q :q!<cr>
nnoremap W :wq!<cr>

"allow for command repetition in visual mode
vnoremap . :norm.<cr>

nnoremap <leader>s :set spell!<cr>

",<space> clears search highlightning
nnoremap <leader><space> :noh<cr>

nnoremap <tab> :bnext<cr>          "Next buffer with TAB
nnoremap <s-tab> :bprevious<cr>    "Previous buffer with Shift+TAB
nnoremap <leader><leader> <C-^>    "Toggle last two buffers

nnoremap <leader>v :vsp<cr>   ",v splits vertically
nnoremap <leader>h :sp<cr>    ",h splits horizontally

" Load Plugins

if filereadable(expand("$HOME/.vim/vundle.vim"))
  source $HOME/.vim/vundle.vim
endif

" control+{h,j,k,l} to navigate between splits
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C--> <C-W><S-->
nnoremap <C-=> <C-W>=

" double T makes a new tab
nnoremap tt :tabnew<cr>
" navigate tabs with H and L
nnoremap th :tabp<cr>
nnoremap tl :tabn<cr>

" Indentation

set autoindent
set smartindent
set smarttab
set tabstop=2
set expandtab
set shiftwidth=2
set softtabstop=2

filetype plugin indent on

set wrap

nnoremap <leader>f gggqG<cr>   "auto break lines

" Searching

set hlsearch
set incsearch
set ignorecase
set showmatch
set smartcase

" Colors

highlight OverLength ctermbg=red ctermfg=white
match OverLength /\%81v.\+/

syntax on
set cursorline
let g:solarized_termcolors=256
colorscheme peachpuff
let g:jsx_ext_required = 0

set rtp+=/usr/local/opt/fzf
map <leader><tab> :FZF -x<cr>

" Ctrl-P config

let g:ctrlp_show_hidden=0
let g:ctrlp_max_files = 6000
" let g:ctrlp_max_depth = 6
let g:ctrlp_custom_ignore = {
  \ 'dir':    '\v[\/](\.git|\.hg|\.svn|build|node_modules|)$',
  \ 'file':   '\v[\/]\.(swo|beam|swp|bk|fas|lib|dll)$',
  \ }

" Syntastic config

let g:syntastic_html_tidy_ignore_errors=[' propietary attribute "ng- "v-']

" Airline config

let g:airline_theme='luna'
