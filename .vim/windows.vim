" Use ~/.vim instead of ~/_vimfiles. Basically, it's the Unix 'rtp' setting.
set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after

" The default is taken from $LANG, which isn’t helpful under Windows.
set encoding=unicode

" Else, it would default to "dos".
set fileformat=unix
