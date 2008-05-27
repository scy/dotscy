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
source ~/.vim/functions.vim

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

augroup ScyFixes
	autocmd BufRead */.git/COMMIT_EDITMSG goto 1 | startinsert
	autocmd BufRead */.git/TAG_EDITMSG goto 1 | startinsert
	" When diffing, use a maximized window for maximized uberblick.
	autocmd GUIEnter * if &diff | simalt ~x | endif
augroup end
