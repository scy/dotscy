" Use the mouse, Luke.
set mouse=a

" Use this after creating a new line.
" All tabs and spaces which are present at the beginning of the previous (above)
" line will be inserted at the beginning of this line as well, if it is empty.
function! MightyIndent()
	let pos = getpos('.')
	" If current line is the first or it's not empty, do nothing.
	if pos[1] == 1 || getline('.') != ''
		return
	endif
	let prevline = getline(pos[1] - 1)
	let prefixlen = match(prevline, '\S')
	" If no non-whitespace was found, copy the whole line.
	if prefixlen == -1
		let prefixlen = strlen(prevline)
	endif
	" If the previous line is not indented, do nothing.
	if prefixlen == 0
		return
	endif
	" Insert the whitespace.
	call setline(pos[1], prevline[0:prefixlen - 1])
	" Position the cursor after the whitespace.
	let pos[2] = prefixlen
	call setpos('.', pos)
endfunction

" Use MightyIndent.
set noautoindent nocindent nosmartindent
noremap  o    o<C-O>:call MightyIndent()<CR>
noremap  O    O<C-O>:call MightyIndent()<CR>
inoremap <CR> <CR><C-O>:call MightyIndent()<CR>
