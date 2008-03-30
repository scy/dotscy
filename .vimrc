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

set fileencodings=ucs-bom,utf-8,default,latin1
set fileencoding=utf-8
set spelllang=de_20,en

set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after

source ~/.vim/abbrev.vim

" ^K will cut the current line, ^U paste it (nano-like behaviour)
inoremap <C-K> <C-O>dd
inoremap <C-U> <C-O>P

" <A-a> will select the whole file.
imap <A-a> <C-O><A-a>
map <A-a> :call ScySelectAll()<CR>

" <A-f> will change case of the first letter of the preceding word.
imap <A-f> <C-O><A-f>
map <A-f> :call ScyChangeCase()<CR>

" <A-m> will toggle the menu.
imap <A-m> <C-O><A-m>
map <A-m> :call ScyToggleMenu()<CR>

" <A-s> will start the current sentence from scratch.
imap <A-s> <C-O><A-s>
map <A-s> :call ScyScrapSentence()<CR>

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

augroup ScyFixes
	autocmd BufRead */.git/COMMIT_EDITMSG goto 1 | startinsert
	autocmd BufRead */.git/TAG_EDITMSG goto 1 | startinsert
augroup end

augroup ScyFTDetect
	au BufNewFile,BufRead .wimrc set filetype=vim
	au BufNewFile,BufRead *.mediawiki set filetype=mediawiki
augroup end
