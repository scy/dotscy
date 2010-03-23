function! IndentGuess()
	" Measure the complete file or the first 500 lines.
	let numlines = max([line('$'), 500])
	let i = 1     " Counter.
	let last = 0  " Indentation of previous line.
	let d = {}    " Stores indentation depth difference counts.
	" Measure indentation difference between all lines.
	while i <= numlines
		" Find the first non-space, everything before is a space.
		let m = match(getline(i), '[^ ]')
		" If there was no match, treat it as 0.
		if m < 0
			let m = 0
		endif
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
		" This line will soon be the previous one.
		let last = m
		let i += 1
	endwhile
	" Now, find the difference that appeared most often.
	let max = 0
	let d[0] = 0
	for key in keys(d)
		" If there is more than one max, take the lowest.
		if d[key] > d[max]
			let max = key
		endif
	endfor
	echo max
endfunction
