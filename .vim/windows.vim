" Use ~/.vim instead of ~/_vimfiles. Basically, this is the Unix 'runtimepath' setting.
set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after

" If unset, this is taken from $LANG or set to latin1, neither of which are helpful.
set encoding=unicode

" Else, it would default to "dos".
set fileformat=unix
