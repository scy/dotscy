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
	" Remove everything below and move to the greeting line for editing.
	normal dG2k0
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
