function! FlexSizeResize()
	let nr = winnr()
	let max = winnr('$')
	let cur = 1
	while cur <= max
		execute cur . "wincmd w"
		if cur != nr
			resize 3
		endif
		let cur += 1
	endwhile
	execute nr . "wincmd w"
	resize 20
endfunction

command FlexSize call FlexSizeResize()

augroup flexsize
	au WinEnter * FlexSize
augroup end
