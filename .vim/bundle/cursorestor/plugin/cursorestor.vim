" Automatically restore cursor position when loading a file.
" By Tim Weber (http://scytale.name/), 2010. Public domain.

function! s:cursorestor()
	" Check whether the '" mark is defined.
	if line("'\"") > 0
		" Check whether the file contains a line with that number.
		if line("'\"") <= line("$")
			" Go there.
			execute "normal! g`\""
		else
			" Go to the last line.
			execute "normal! G"
		endif
	endif
endfunction

augroup CursoRestoR
	autocmd BufReadPost * call s:cursorestor()
augroup end
