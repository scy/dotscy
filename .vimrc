color torte
set guifont=ter-112n:h9
set guioptions-=m
set nobackup
set viminfo+=n~/.vim/.viminfo
set tabstop=4
set shiftwidth=4
set noexpandtab
set nowrap
set scrolloff=5
set formatoptions+=wc
set mouse=a
set listchars=tab:\|.,trail:_,extends:>,precedes:<,nbsp:_
set list
set nojoinspaces
set keymodel=startsel

if has("multi_byte")
	" A must-have for being able to convert everything into everything
	" To be able to use this under Windows, see "newer intl library" at
	" http://vim.sourceforge.net/download.php#pc
	set encoding=utf-8
	" Try to recognize the file encoding in a sophisticated way.
	set fileencodings=ucs-bom,utf-8,default,latin1
	" Default to writing utf-8 files.
	setglobal fileencoding=utf-8
else
	echoerr "Dear God, we don't have multi_byte support!"
endif

set spelllang=de_20,en

set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after

source ~/.vim/abbrev.vim

" ^K will cut the current line, ^U paste it (nano-like behaviour)
inoremap <C-K> <C-O>dd
inoremap <C-U> <C-O>P

" <M-a> will select the whole file.
imap <M-a> <C-O><M-a>
map <M-a> :call ScySelectAll()<CR>

" <M-f> will change case of the first letter of the preceding word.
imap <M-f> <C-O><M-f>
map <M-f> :call ScyChangeCase()<CR>

" <M-m> will toggle the menu.
imap <M-m> <C-O><M-m>
map <M-m> :call ScyToggleMenu()<CR>

" <M-n> will toggle number-and-wrap mode.
imap <M-n> <C-O><M-n>
map <M-n> :call ScyToggleNumbers()<CR>

" <M-s> will start the current sentence from scratch.
imap <M-s> <C-O><M-s>
map <M-s> :call ScyScrapSentence()<CR>

" <M-w> will write the file contents.
imap <M-w> <C-O><M-w>
map <M-w> :w<CR>

if has("gui_running")
	set lines=50 columns=150
endif

function! ScyChangeCase()
	" Mark F, move to beginning of _current_ word, change case, move to F.
	normal mFwb~`F
endfunction

function! ScyScrapSentence()
	" Delete inner sentence.
	normal dis
endfunction

function! ScySelectAll()
	" Move to first line, start linewise visual mode, move to last line.
	normal ggVG
endfunction

function! ScyToggleMenu()
	if &guioptions=~'m'
		set guioptions-=m
	else
		set guioptions+=m
	endif
endfunction

function! ScyToggleNumbers()
	if &number
		set nonumber
		set nowrap
	else
		set number
		set wrap
	endif
endfunction

augroup ScyFixes
	autocmd BufRead */.git/COMMIT_EDITMSG goto 1 | startinsert
	autocmd BufRead */.git/TAG_EDITMSG goto 1 | startinsert
	autocmd BufRead * if &bomb | echo "This file contains a BOMB! ;P" | endif
augroup end

augroup ScyFTDetect
	au BufNewFile,BufRead .wimrc set filetype=vim
	au BufNewFile,BufRead *.mediawiki set filetype=mediawiki
augroup end
