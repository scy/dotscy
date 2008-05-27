" FlexSize: Automatically resize windows when switching between them.
" Maintainer: Tim Weber <scy-vim@scytale.name>
" Version: 0.1
" Known Bugs:
"  - Using the mouse, the cursor won't end up where you clicked.
"  - These header lines may not be standard.
"  - Trying hard to adapt to different status line and cmdline height
"    settings, but no guarantee that everything works...

function! FlexSizeResize()
	let current = winnr()
	let numwins = winnr('$')
	" Lines eaten by the command line are not available, of course.
	let avail = &lines - &cmdheight
	" If the last window doesn't have a status bar, that's one more line.
	if &laststatus == 0 || (&laststatus == 1 && numwins == 1)
		let avail += 1
	endif
	" Divide the available nums equally between windows. Note that "numwins+1" 
	" is used: That leads to the current window having twice as much space.
	let each = (avail / (numwins + 1) )
	" The current window receives everything not used by the other ones.
	let more = avail - ((numwins - 1) * each)
	let each -= 1
	let more -= 1
	" Iterate over all windows, resizing all non-current ones.
	let i = 1
	while i <= numwins
		execute i . "wincmd w"
		if i != current
			execute "resize " each
			normal zz
		endif
		let i += 1
	endwhile
	execute current . "wincmd w"
	execute "resize " more
endfunction

command! FlexSize call FlexSizeResize()

augroup flexsize
	au WinEnter,VimResized * FlexSize
augroup end
