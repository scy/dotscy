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
" Search caseless only if the query contains only lowercase characters.
set ignorecase smartcase
set keymodel=startsel
set autoindent
set visualbell
set modeline
set statusline=%!ScyStatus()

source ~/.vim/language.vim
source ~/.vim/abbrev.vim
source ~/.vim/mappings.vim
source ~/.vim/gui.vim

highlight User1 term=bold,inverse cterm=bold ctermfg=Red ctermbg=DarkBlue gui=bold guifg=Red guibg=DarkBlue
let s  = ""
let s .= "%<"                                 | " truncate at the start
let s .= "%f "                                | " file name
let s .= "%y"                                 | " file type
let s .= "[%{&ff}]"                           | " file format (line endings)
" TODO: Doesn't change to "without question mark" after saving a new file.
let s .= "[%{&fenc!=\"\"?&fenc:&enc.\"?\"}]"  | " file encoding (charset)
let s .= "%r"                                 | " readonly flag
let s .= "%{&bomb?\"[BOM]\":\"\"}"            | " byte-order mark flag
let s .= "%="                                 | " right-justify after here
let s .= "%1*%m%* "                           | " modified flag
let s .= "0x%B "                              | " hex value of current byte
let s .= "%l"                                 | " current line
let s .= ":%c%V"                              | " column number, virtual column (if different)
let s .= " %P"                                | " percentage
let s .= "/%LL"                               | " number of lines
set statusline=%!s
set laststatus=2

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

function! ScyChangeCase()
	" Disable error beeps while doing this.
	let vb = &vb
	let t_vb = &t_vb
	set vb t_vb=
	" Store the cursor position.
	let cursor = getpos(".")
	" Move to beginning of _current_ word, change case.
	" Split into two commands because "w" will fail at the end of file, 
	" causing the command to abort, which is not what we want.
	" See: http://groups.google.com/group/vim_use/msg/edffa70bd1e17054
	normal w
	normal b~
	" Restore the cursor position.
	call setpos('.', cursor)
	" Re-enable previous settings.
	if !vb
		set novb
	endif
	execute "set t_vb=" . t_vb
endfunction

function! ScyJoinQuoteLines()
	" Remove all quote characters and spaces from the beginning of this line.
	s/\v^[|> ]+//
	" One line up, join with next, format the line, one line down.
	normal kJgqqj
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
	au BufRead *.exe.log if getline("1") =~ ' \[DEBUG\] Die Anwendung wurde gestartet\.$' | set filetype=acrawl | endif
augroup end
