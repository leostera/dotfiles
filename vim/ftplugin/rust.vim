set hidden
let g:rustfmt_autosave = 1
let g:racer_cmd = "/Users/ostera/.cargo/bin/racer"
set tags+=~/.cargo/registry/src/tags

nnoremap <leader>m :call LanguageClient_contextMenu()<CR>
nnoremap <leader>t :call LanguageClient#textDocument_hover()<CR>
