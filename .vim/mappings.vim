" ^K will cut the current line, ^U paste it (nano-like behaviour)
inoremap <C-K> <C-O>dd
inoremap <C-U> <C-O>P

" <M-a> will select the whole file.
imap <M-a> <C-O><M-a>
map <M-a> :call ScySelectAll()<CR>

" <M-f> will change case of the first letter of the preceding word.
imap <M-f> <C-O><M-f>
map <M-f> :call ScyChangeCase()<CR>

" <M-h> will toggle hlsearch.
imap <M-h> <C-O><M-h>
map <M-h> :set invhlsearch

" <M-n> will toggle number-and-wrap mode.
imap <M-n> <C-O><M-n>
map <M-n> :call ScyToggleNumbers()<CR>

" <M-s> will start the current sentence from scratch.
imap <M-s> <C-O><M-s>
map <M-s> :call ScyScrapSentence()<CR>

" <M-w> will write the file contents.
imap <M-w> <C-O><M-w>
map <M-w> :w<CR>
