" Automatically set indent-relevant parameters.
function! IndentGuess()
	" Measure the complete file or the first 500 lines.
	let numlines = max([line('$'), 500])
	let i = 1         " Counter.
	let last = 0      " Indentation of previous line.
	let d = {'t': 0}  " Stores indentation depth difference counts.
	" Measure indentation difference between all lines.
	while i <= numlines
		" Find the first non-space, everything before is a space.
		let m = matchend(getline(i), '^ *')
		" If there was no match, check whether tabs are used.
		if m == 0 && matchend(getline(i), '^	*') > 0
			" Count this line as using tabs, be done.
			let d['t'] += 1
		else
			" Calculate difference to previous line.
			let diff = abs(m - last)
			" Ignore differences which are zero or insane.
			if diff > 0 && diff <= 16
				" Initialize missing dictionary keys.
				if !has_key(d, diff)
					let d[diff] = 0
				endif
				" Count this line.
				let d[diff] += 1
			endif
		endif
		" This line will soon be the previous one.
		let last = m
		let i += 1
	endwhile
	" Now, find the difference that appeared most often.
	let max = 0
	let d[0] = 0
	for key in keys(d)
		" Skip tab count.
		if key == 't'
			continue
		endif
		" If there is more than one max, take the lowest.
		if d[key] > d[max]
			let max = key
		endif
	endfor
	" If more lines are tabbed than spaced, assume tabs are used.
	if d['t'] > d[max]
		" Leave 'tabstop' untouched (i.e. fall back to user default).
		setlocal noexpandtab
	else
		" Set tabstops to match the winner difference.
		execute 'setlocal expandtab tabstop=' . max
	endif
endfunction

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

" Automatically run IndentGuess() after loading a file.
augroup IndentGuess
	autocmd BufRead * call IndentGuess()
augroup end
