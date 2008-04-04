colorscheme dunkel
set nobackup
set nocompatible
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
set autoindent
set modeline
set statusline=%!ScyStatus()

highlight User1 term=bold,inverse cterm=bold ctermfg=Red ctermbg=DarkBlue gui=bold guifg=Red guibg=DarkBlue
let s  = ""
let s .= "%<"                                 | " truncate at the start
let s .= "%f "                                | " file name
let s .= "%y"                                 | " file type
let s .= "[%{&ff}]"                           | " file format (line endings)
let s .= "[%{&fenc!=\"\"?&fenc:&enc.\"?\"}]"  | " file encoding (charset)
let s .= "%r"                                 | " readonly flag
let s .= "%{&bomb?\"[BOM]\":\"\"}"            | " byte-order mark flag
let s .= "%="                                 | " right-justify after here
let s .= "%1*%m%* "                           | " modified flag
let s .= "0x%02.2B "                          | " hex value of current byte
let s .= "%l"                                 | " current line
let s .= ":%c%V"                              | " column number, virtual column (if different)
let s .= " %P"                                | " percentage
let s .= "/%LL"                               | " number of lines
set statusline=%!s
set laststatus=2

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
" TODO: This is hackish.
if glob("$HOME/.vim/spell/de.utf-8.add.spl") == "" || getftime("$HOME/.vim/spell/de.utf-8.add") > getftime("$HOME/.vim/spell/de.utf-8.spl")
	silent mkspell! $HOME/.vim/spell/de.utf-8.add
	echomsg "Updated local dictionary."
endif

set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after

" meta-keys generate <esc>a .. <esc>z for me
set timeout
set nottimeout
set timeoutlen=100
exec "imap \eOD <Left>"
exec "imap \eOC <Right>"
exec "imap \eOA <Up>"
exec "imap \eOB <Down>"
exec "map \eOD <Left>"
exec "map \eOC <Right>"
exec "map \eOA <Up>"
exec "map \eOB <Down>"
exec "imap \eOd <C-Left>"
exec "imap \eOc <C-Right>"
exec "imap \eOa <C-Up>"
exec "imap \eOb <C-Down>"
exec "map \eOd <C-Left>"
exec "map \eOc <C-Right>"
exec "map \eOa <C-Up>"
exec "map \eOb <C-Down>"
let c='a'
while c != 'z'
	let C=toupper(c)
	exec "map \e".c." <M-".c.">"
	exec "map \e".C." <M-".C.">"
	exec "imap \e".c." <M-".c.">"
	exec "imap \e".C." <M-".C.">"
	exec "set <M-".c.">=\e".c
	exec "set <M-".C.">=\e".C
	let c = nr2char(1+char2nr(c))
endwhile

source ~/.vim/abbrev.vim
source ~/.vim/mappings.vim
source ~/.vim/gui.vim

function! ScyChangeCase()
	" Mark F, move to beginning of _current_ word, change case, move to F.
	" TODO: This does not work on the last word in the file.
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
	" When diffing, use a maximized window for maximized uberblick.
	autocmd GUIEnter * if &diff | simalt ~x | endif
augroup end

augroup ScyFTDetect
	au BufNewFile,BufRead .wimrc set filetype=vim
	au BufNewFile,BufRead *.mediawiki set filetype=mediawiki
augroup end
