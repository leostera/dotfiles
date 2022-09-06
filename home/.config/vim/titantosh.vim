colorscheme molokai

" Status line config
let g:lightline = {
  \ 'colorscheme': 'molokai',
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
