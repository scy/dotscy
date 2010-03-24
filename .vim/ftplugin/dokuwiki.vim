" Two spaces are used for blocks, bullets etc.
" Modelines are forbidden.
setlocal expandtab tabstop=2 nomodeline

" <Leader>hN will make the current line a level-N heading.
noremap <buffer> <Leader>h1 :smagic/^ *=* *\(.\{-}\) *=* *$/====== \1 ======/<CR>:nohlsearch<CR>8\|
noremap <buffer> <Leader>h2 :smagic/^ *=* *\(.\{-}\) *=* *$/===== \1 =====/<CR>:nohlsearch<CR>7\|
noremap <buffer> <Leader>h3 :smagic/^ *=* *\(.\{-}\) *=* *$/==== \1 ====/<CR>:nohlsearch<CR>6\|
noremap <buffer> <Leader>h4 :smagic/^ *=* *\(.\{-}\) *=* *$/=== \1 ===/<CR>:nohlsearch<CR>5\|
noremap <buffer> <Leader>h5 :smagic/^ *=* *\(.\{-}\) *=* *$/== \1 ==/<CR>:nohlsearch<CR>4\|
noremap <buffer> <Leader>h6 :smagic/^ *=* *\(.\{-}\) *=* *$/= \1 =/<CR>:nohlsearch<CR>3\|
