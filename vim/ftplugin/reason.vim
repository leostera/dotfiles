execute "set omnifunc=merlin#Complete"

nnoremap <leader>c :MerlinDestruct<cr>

" reformat on file save
autocmd BufWritePre *.re,*.rei call DoReasonPrettyPrint()
