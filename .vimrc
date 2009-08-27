set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after

if $OS =~ "^Windows"
	set lm=en
	set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after
	
	" The default encoding is most likely not Latin1 but (on German systems) 
	" Windows-1252. Change that, and the collation as well.
	set fileencodings-=latin1
	set fileencodings-=default
	set fileencodings+=cp1252
	language ctype German_Germany.1252
	
	set diffexpr=MyDiff()
	function MyDiff()
	  let opt = '-a --binary '
	  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
	  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
	  let arg1 = v:fname_in
	  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
	  let arg2 = v:fname_new
	  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
	  let arg3 = v:fname_out
	  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
	  let eq = ''
	  if $VIMRUNTIME =~ ' '
	    if &sh =~ '\<cmd'
	      let cmd = '""' . $VIMRUNTIME . '\diff"'
	      let eq = '"'
	    else
	      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
	    endif
	  else
	    let cmd = $VIMRUNTIME . '\diff'
	  endif
	  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
	endfunction
endif

filetype on
syntax on
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
set backspace=indent,eol,start
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

" Let's see whether I can live without Esc-keycodes.
set notimeout nottimeout

augroup ScyFixes
	autocmd BufRead */.git/COMMIT_EDITMSG goto 1 | startinsert
	autocmd BufRead */.git/TAG_EDITMSG goto 1 | startinsert
	" When diffing, use a maximized window for maximized uberblick.
	autocmd GUIEnter * if &diff | simalt ~x | endif
	" TODO: When the file starts with
	" # This is a combination of
	" then don't go into insert mode.
augroup end
