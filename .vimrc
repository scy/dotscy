color torte
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
source ~/.vim/mappings.vim
source ~/.vim/gui.vim

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
