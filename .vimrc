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
" When right-clicking, set the cursor position to where you clicked.
set mousemodel=popup_setpos
set autoindent
set visualbell
set modeline
set statusline=%!ScyStatus()
" Complete shell-like.
set wildmode=longest,list
" Set session options.
for o in ['curdir', 'globals', 'options']
	execute 'set sessionoptions-=' . o
endfor
for o in ['blank', 'buffers', 'help', 'resize', 'sesdir', 'winpos', 'winsize', 'tabpages']
	execute 'set sessionoptions+=' . o
endfor

source ~/.vim/language.vim
source ~/.vim/abbrev.vim
source ~/.vim/mappings.vim
source ~/.vim/gui.vim

let s  = ""
let s .= "%<"                                 | " truncate at the start
let s .= "%f%8* | "                           | " file name
let s .= '%{&ft==""?"?":&ft} '                | " file type
let s .= "%{toupper(&ff[0:0])} "              | " file format (line endings)
" TODO: Doesn't change to "without question mark" after saving a new file.
let s .= "%{ScyShortFEnc()}"                  | " file encoding (charset)
let s .= '%{&bomb?"!":""} '                   | " byte-order mark flag
let s .= "%r"                                 | " readonly flag
let s .= "%*%="                               | " right-justify after here
let s .= "%9*%m%* "                           | " modified flag
let s .= "0x%02B "                            | " hex value of current byte
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

function! ScyMailEnd(greeting, name)
	" If we're not in an empty line, assume that this is the last content line 
	" and that we should insert the greeting below.
	if getline('.') !~ "^ *$"
		let start = "o\n"
	" Else, if the line above the current one is non-empty, insert an empty 
	" line before the greeting.
	elseif getline(line('.') - 1) !~ "^ *$"
		let start = "o"
	" Else insert the greeting right here.
	else
		let start = "i"
	endif
	" Insert the greeting.
	execute "normal " . start . a:greeting . "\n\n\t" . a:name . "\n\e"
	" Remove everything below.
	normal dG
endfunction

function! ScyQuoteJoin()
	" Remove all quote characters and spaces from the beginning of this line.
	s/\v^[|> ]+//
	" One line up, join with next, format the line, one line down.
	normal kJgqqj
endfunction

function! ScyQuoteSplit()
	" If we are in column 1, just insert three lines and move to the middle.
	if col(".") == 1
		execute "normal O\n\n\e"
		normal k
		return
	endif
	" Save formatoptions.
	let oldfo = &formatoptions
	" Temporarily enable comment leader inserting, insert a break, restore fo.
	set formatoptions+=r
	execute "normal i\n\e"
	execute "set formatoptions=" . oldfo
	" Insert three empty lines and move to the middle one.
	execute "normal O\n\n\e"
	normal k
endfunction

function! ScyScrapSentence()
	" Delete inner sentence.
	normal dis
endfunction

function! ScySelectAll()
	" Move to first line, start linewise visual mode, move to last line.
	normal ggVG
endfunction

function! ScyShortFEnc()
	" If no file encoding is set, use the system encoding.
	let e = (&fileencoding == "") ? &enc : &fenc
	if e[0:3] == "utf-"
		" Just return the number for UTF encodings.
		let r = e[4:]
	elseif e == "latin1"
		" That's actually ISO-8859-1.
		let r = "-1"
	elseif e[0:8] == "iso-8859-"
		" Return a dash and the number for ISO-8859 encodings.
		let r = e[8:]
	elseif e[0:1] == "cp"
		" Just return the number for Windows code pages (at least 3 digits)
		let r = e[2:]
	else
		" Okay, no short version. Return the full name.
		let r = e
	endif
	" Add a question mark if fenc is not set.
	if &fileencoding == "" | let r .= "?" | endif
	return r
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
