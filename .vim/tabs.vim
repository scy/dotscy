" Philosophy:
"  1) Code should be indented using tabs.
"  2) Aligning content in multiple lines should be done with spaces, while the
"     lines themselves should still be indented with tabs. In other words,
"     tabs are only valid at the beginning of a line. As soon as there has
"     been a non-tab character, no other tabs may follow. This keeps tab width
"     variable.
"  3) There are people who have a different philosophy. Do not make it hard to
"     work with them.
"  4) Vim's default of indenting with as many tabs as possible, then
"     continuing with spaces sucks. If my tabwidth is 4 and I indent a line
"     with a tab and 10 spaces, the next line should not be indented with 3
"     tabs and 2 spaces. Don't try to be smarter than you are.
"  5) Spamming files with modelines sucks as well. Indentation style of files
"     can be guessed by simple algorithms most of the time.

" Automatically set indent-relevant parameters based on the file's content.
" What it basically does is to calculate the indentation level difference
" between consecutive lines and use the one found most often as the file's
" tabwidth.
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
		" Completely ignore (really) empty lines. These often occur as
		" empty lines between two indented ones, biasing towards those
		" lines' indent level, which is not what we want.
		elseif getline(i) != ''
			" Calculate difference to previous line.
			let diff = abs(m - last)
			" Ignore differences which are zero or insane.
			if diff > 0 && diff <= 16
				" Initialize missing dictionary keys.
				if !has_key(d, diff)
					let d[diff] = 1
				else
					" Count this line.
					let d[diff] += 1
				endif
			endif
			" This line will soon be the previous one.
			let last = m
		endif
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
	" If the lines are not indented at all, do nothing.
	if max == 0
		return
	endif
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
" Note: This currently doesn't work well with auto-insertion of comment
" leaders in insert mode ('formatoptions' containing "r").
function! MightyIndent(offset, ateol)
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
	" If the cursor should be positioned at the end of line (e.g. after the
	" "o" command, do it.
	if a:ateol
		let pos[2] = strlen(getline(pos[1]))
	else
		" Position the cursor after the inserted whitespace.
		let pos[2] = prefixlen + 1
	endif
	" Position the cursor.
	call setpos('.', pos)
endfunction

" If there are only spaces left of the cursor and expandtab is set, remove as
" many spaces as needed to reduce the indent depth by one. If the number of
" spaces is not a multiple of 'tabstop', remove until reaching the first
" possible multiple.
function! MightyBackspace()
	let bs = "\<BS>"
	if !&expandtab
		return bs
	endif
	let numspaces = matchend(getline('.'), '^ *\%' . col('.') . 'c')
	if numspaces < 2
		return bs
	endif
	let numdel = numspaces % &tabstop
	if numdel == 0
		let numdel = &tabstop
	endif
	return repeat(bs, numdel)
endfunction

" Use MightyIndent.
set noautoindent nocindent nosmartindent
noremap  <silent>        o    o<C-O>:call MightyIndent(-1, 1)<CR>
noremap  <silent>        O    O<C-O>:call MightyIndent(+1, 1)<CR>
inoremap <silent>        <CR> <CR><C-O>:call MightyIndent(-1, 0)<CR>
inoremap <silent> <expr> <BS> MightyBackspace()

" If given an argument, use n spaces to indent. Else, use a tab.
function! TabWiz(...)
	if a:0 == 0
		execute 'set noexpandtab softtabstop=0 tabstop=' . g:tabwiz_default_ts . ' shiftwidth=' . g:tabwiz_default_ts
	else
		execute 'set expandtab softtabstop=0 tabstop=' . a:1 . ' shiftwidth=' . a:1
	endif
endfunction

" Define :T for fast access to TabWiz.
command! -nargs=? T :call TabWiz(<args>)
" Set TabWiz defaults. You might want to change this.
let g:tabwiz_default_ts = 4
" Initialize.
T

" Automatically run IndentGuess() after loading a file.
augroup IndentGuess
	autocmd BufRead * call IndentGuess()
augroup end
