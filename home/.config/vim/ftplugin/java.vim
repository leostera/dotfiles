setlocal omnifunc=javacomplete#Complete
let g:JavaComplete_Home = $HOME . '/.vim/bundle/vim-javacomplete2'
let $CLASSPATH .= '.:' . $HOME . '/.vim/bundle/vim-javacomplete2/lib/javavi/target/classes'
