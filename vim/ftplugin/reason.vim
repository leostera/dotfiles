let g:LanguageClient_serverCommands = {
    \ 'reason': [':ocaml-language-server', '--stdio'],
    \ 'ocaml': ['ocaml-language-server', '--stdio'],
    \ }

let g:merlin = {
      \ 'merlin_home': getcwd() . '/node_modules/.bin/ocamlmerlin'
      \ }

execute "set omnifunc=merlin#Complete"

nnoremap <leader>c :MerlinDestruct<cr>

" reformat on file save
autocmd BufWritePre *.re call DoReasonPrettyPrint()
