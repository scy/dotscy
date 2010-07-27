" Prefer storing swap files in a dedicated directory.
set directory^=~/.vim/swap

" .viminfo settings: Store marks, unlimited register contents. Also, do not
" store .viminfo directly in $HOME. Search and command line history are
" managed using 'history'.
set viminfo='100,h,f1,n~/.vim/viminfo
set history=50
