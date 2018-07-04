set shiftwidth=2
set tabstop=2
set expandtab

let g:formatters_bzl = ['yapf']
let g:formatter_yapf_style = 'google'

autocmd FileType bzl let b:autoformat_autoindent=0
