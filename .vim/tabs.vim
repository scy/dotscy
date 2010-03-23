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
		set noexpandtab
	else
		" Set tabstops to match the winner difference.
		execute 'set expandtab tabstop=' . max
	endif
endfunction
