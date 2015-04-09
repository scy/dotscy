" Do not be compatible.
set nocompatible

" Use filetype plugins, but switch them off first to force using pathogen for
" ftdetect files. See <http://www.vim.org/scripts/script.php?script_id=2332>
filetype off
filetype plugin on

" Check for modelines.
set modeline modelines=10

" Incremental smart-case search with highlighting.
set incsearch hlsearch ignorecase smartcase

" Allow backspacing over _everything_.
set backspace=eol,indent,start
