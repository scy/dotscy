" Use , as mapleader, keep the useful ',' command available as '_'.
let mapleader = ","
noremap _ ,
noremap ,, ,

" Enable Neo-like Unicode quotes (Neo is not always available).
command! Chars lmap <M-7> „|lmap <M-8> “|lmap <M-9> ”|set iminsert=1|set imsearch=-1|set imcmdline

" a: select the whole file.
map <Leader>a ggVG

" f: change case of the first letter of the preceding word.
" This is so important that I bind it on M-f as well.
imap <M-f> <C-O><Leader>f
map <Leader>f :call ScyChangeCase()<CR>
map <M-f> <Leader>f

" g: insert an informal greeting.
map <Leader>g :call ScyMailEnd("Gruß,", "Tim.")<CR>

" G: insert an informal greeting in English.
map <Leader>G :call ScyMailEnd("Regards,", "Tim.")<CR>

" h: toggle hlsearch.
map <Leader>h :set invhlsearch<CR>

" <M-j> will join this quoted line (in mails) with the previous one.
imap <M-j> <C-O><M-j>
map <M-j> :call ScyQuoteJoin()<CR>

" m: insert a formal greeting ("MfG").
map <Leader>m :call ScyMailEnd("Beste Grüße,", "Tim Weber.")<CR>

" M: insert a formal greeting in English.
map <Leader>m :call ScyMailEnd("Kind regards,", "Tim Weber.")<CR>

" n: toggle number-and-wrap mode.
map <Leader>n :Numbers<CR>

" s: split this quoted line here to reply to it.
map <Leader>s :call ScyQuoteSplit()<CR>i

" S: start the current sentence from scratch.
map <Leader>S :call ScyScrapSentence()<CR>

" w: write the file contents.
" Since this is important, it bound to ^S as well.
map <Leader>w :w<CR>
map <C-S> <Leader>w
imap <C-S> <C-O><Leader>w

" <M-W> will write all files and run ctags.
" TODO: :!start looks like it's Windows-only...
imap <M-W> <C-O><M-W>
map <M-W> :wa<CR>:!start ctags -R<CR>

" x: maximize a Windows GUI window.
map <Leader>x :simalt ~x<CR>

" Make <C-Space> equivalent to <Esc>, since it can be reached more easily.
imap <C-Space> <Esc>

" <C-Down> will jump to the current tag (<C-]> is too hard on German keyboards).
imap <C-Down> <C-O><C-Down>
map <C-Down> <C-]>

" <C-Up> will jump back again.
imap <C-Up> <C-O><C-Up>
map <C-Up> <C-T>

" <C-RightMouse> will jump back as well (inverting <C-LeftMouse>).
imap <C-RightMouse> <C-Up>
nmap <C-RightMouse> <C-Up>
