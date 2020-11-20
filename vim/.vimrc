" General
set nocompatible

set encoding=UTF-8
set t_Co=256
set number         "Line numbers me likey
set backspace=2    "Make backspace work like most other apps
set history=10000  "Shit load of history for :cmdline
set showcmd        "Show me incomplete commands down bottom
set visualbell     "Please, no sounds
set wmh=0          "Set minimum window height to 0, helps when stacking splits
set laststatus=2   "Always show the bar

set autoread       "Reload files changed outside vim

autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
  \ if mode() != 'c' | checktime | endif
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

set undofile "automatically save and restore undo history
set undodir=~/.vim/undos

set tags^=~/.vim/tags

set path+=**
set wildmenu

" Spell checking
set nospell

" Key mappings

let mapleader=","

inoremap jk <esc><esc>:w<cr>

" never go into Ex mode
noremap Q <Nop>

" easy switch paste modes
noremap <leader>x :set paste!<cr>

" Git bindings
nnoremap <leader>gc :Gcommit -S<cr>
nnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gw :Gw<cr>

"allow for command repetition in visual mode
vnoremap . :norm.<cr>

" Toggle spelling
nnoremap <leader>s :set spell!<cr>

" Toggle numbers
nnoremap <leader>1 :set number!<cr>

",<space> clears search highlightning
nnoremap <leader><space> :noh<cr>

"Next buffer with TAB
nnoremap <tab> :bnext<cr>

"Previous buffer with Shift+TAB
nnoremap <s-tab> :bprevious<cr>

"Toggle last two buffers
nnoremap <leader><leader> <C-^>

",v splits vertically
nnoremap <leader>v :vsp<cr>

",h splits horizontally
nnoremap <leader>h :split<cr>

nnoremap <leader>z :Goyo<cr>

" Load Plugins

if filereadable(expand("$HOME/.vim/plugins.vim"))
  source $HOME/.vim/plugins.vim
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

nnoremap t1 1gt
nnoremap t2 2gt
nnoremap t3 3gt
nnoremap t4 4gt
nnoremap t5 5gt
nnoremap t6 6gt
nnoremap t7 7gt
nnoremap t8 8gt
nnoremap t9 9gt
nnoremap t0 :tablast<cr>

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

" Searching

set hlsearch
set incsearch
set ignorecase
set showmatch
set smartcase

" Colors

set termguicolors
syntax on
colorscheme molokai
set cursorline
set background=dark


set rtp+=/home/ostera/repos/github.com/junegunn/fzf
map <leader>B :Buffers<cr>
map <leader><tab> :FZF -x<cr>
map <leader>f :Find<cr>
map <leader>* :Find <C-r><C-w><cr>
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --glob "!*cache/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)

set colorcolumn=81
highlight OverLength ctermbg=red ctermfg=white
match OverLength /\%81v.\+/

" Status line config
let g:lightline = {
  \ 'colorscheme': 'wombat',
  \ 'component': {
  \   'readonly': '%{&readonly?"RO":""}',
  \ },
  \ 'component_function': {
  \   'wordcount': 'WordCount'
  \ },
  \ 'active': {
  \   'right': [
  \      [ 'lineinfo' ],
  \      [ 'fileformat', 'fileencoding', 'filetype' ],
  \      [ 'percent' ]
  \   ]
  \ }
  \ }

" LSP Config
set hidden

let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ }

set exrc
set secure

let _hostname = substitute(hostname(), ".lan", "", "")
let _hostfile = expand("$HOME/.vim/"._hostname.".vim")

if filereadable(_hostfile)
  exec "source "._hostfile
endif

set hidden
