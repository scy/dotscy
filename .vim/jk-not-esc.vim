" Inspired by <http://learnvimscriptthehardway.stevelosh.com/chapters/10.html>.

" Use "jk" in insert mode to exit insert mode. This is a lot easier to reach
" than Esc. In case you really need to type "jk" in the text, type "jjkak"
" instead or wait 'timeoutlen' milliseconds.
inoremap jk <Esc>

" In order to get used to this, you can also disable <Esc> altogether.
inoremap <Esc> <Nop>
