let g:markdown_fenced_languages = ['js=javascript', 'ml=ocaml', 'ocaml=ocaml', 'ttl=n3', 'sparql=sparql', 'haskell=haskell', 'rust=rust', 'erlang=erlang', 'elixir=elixir']

let g:word_count="<unknown>"
function WordCount()
  return g:word_count . "W/" . (g:word_count / 300) . "min"
endfunction
function UpdateWordCount()
  let lnum = 1
  let n = 0
  while lnum <= line('$')
    let n = n + len(split(getline(lnum)))
    let lnum = lnum + 1
  endwhile
  let g:word_count = n
endfunction
" Update the count when cursor is idle in command or insert mode.
" Update when idle for 1000 msec (default is 4000 msec).
set updatetime=1000
augroup WordCounter
  au! CursorHold,CursorHoldI * call UpdateWordCount()
  au BufEnter * call UpdateWordCount()
augroup END

" Update Status line config with wordcount
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
  \      [ 'wordcount', 'percent' ]
  \   ]
  \ }
  \ }
