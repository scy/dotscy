" Use the mouse, Luke.
set mouse=a

" Use this after creating a new line.
" All tabs and spaces at the beginning of the current line (if any) will be
" replaced by exactly the same whitespace string as on the line above (or below,
" determined by the "offset" argument). This fixes Vim's behavior of filling up
" with as many tabs as possible.
function! MightyIndent(offset)
	" Retrieve position of the new line.
	let pos = getpos('.')
	" The "template" line is the one containing the whitespace to be copied.
	let templine = pos[1] + a:offset
	let template = getline(templine)
	let prefixlen = match(template, '\S')
	" If no non-whitespace was found, copy the whole line.
	if prefixlen == -1
		let prefixlen = strlen(template)
	endif
	" If the template line is not indented, do nothing.
	if prefixlen == 0
		return
	endif
	" Retrieve everything after the initial whitespace on the current line.
	let thisline = getline(pos[1])
	let suffixpos = match(thisline, '\S')
	" If non-whitespace was found, copy everything after it into "thistext".
	if suffixpos != -1
		let thistext = thisline[suffixpos : ]
	else
		let thistext = ""
	endif
	" Change the line.
	call setline(pos[1], template[0 : prefixlen - 1] . thistext)
	" Position the cursor after the whitespace.
	let pos[2] = prefixlen + 1
	call setpos('.', pos)
endfunction

" Use MightyIndent.
set noautoindent nocindent nosmartindent
noremap  o    o<C-O>:call MightyIndent(-1)<CR>
noremap  O    O<C-O>:call MightyIndent(+1)<CR>
inoremap <CR> <CR><C-O>:call MightyIndent(-1)<CR>

" Do not timeout on mappings, but on keycodes.
set notimeout ttimeout timeoutlen=50

" If given an argument, use n spaces to indent. Else, use a tab.
function! TabWiz(...)
	if a:0 == 0
		set noexpandtab tabstop=8
	else
		execute "set expandtab tabstop=" . a:1
	endif
endfunction

" Define :T for fast access to TabWiz.
command! -nargs=? T :call TabWiz(<args>)
" Initialize.
T
