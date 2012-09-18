" Show tabs and other things by default.
set list
set listchars=tab:\|.,trail:_,extends:>,precedes:<,nbsp:_

" Activate syntax highlighting by default.
syntax on

" Use Smyck as my colorscheme.
set background=dark
colorscheme smyck

" A function to shorten the current encoding as much as possible.
function! ShortFEnc()
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

" Status line.
let s = ""
let s .= "%<"                          | " truncate at the start
let s .= "%f %8* "                     | " file name
let s .= '%{&ft==""?"?":&ft} '         | " file type
let s .= "%{toupper(&ff[0:0])} "       | " file format (line endings)
let s .= "%{ShortFEnc()}"              | " short file encoding
let s .= '%{&bomb?"!":""} '            | " byte-order mark flag
let s .= '%{&et?")".&ts."(":&ts} '     | " tab width, in )( if expandtabs is set
let s .= "%r"                          | " readonly flag
let s .= "%*%="                        | " right-justify after here
let s .= "%9*%m%* "                    | " modified flag
let s .= "0x%02B "                     | " hex value of current byte
let s .= "%l"                          | " current line
let s .= ":%c%V"                       | " column number, virtual column (if different)
let s .= " %P"                         | " percentage
let s .= "/%LL"                        | " number of lines
set statusline=%!s
" Always show a status line.
set laststatus=2

" Show partial normal mode commands and mappings in the command line.
set showcmd

" GUI options.
set guioptions+=cfegmtr
set guioptions-=T
set guifont=-misc-fixed-medium-r-semicondensed-*-13-*-*-*-*-*-iso10646-*

" Make MacVim look pimpy.
if has("gui_macvim")
	" Currently, transparency seems to work only if you enable the
	" "experimental renderer".
	set transparency=1
	set fuoptions=maxvert,maxhorz
	set guifont=Inconsolata-dz:h13
	set listchars=tab:▸⋅,trail:␣,extends:→,precedes:←,nbsp:‗
endif

" Initialize to a decent window size.
if !exists("s:initialized")
	let s:initialized = "yes"
	if has("gui_running")
		set lines=40 columns=120
	endif
endif
