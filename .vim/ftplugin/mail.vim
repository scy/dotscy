" Automatic wrapping for mails.
set formatoptions+=w
set textwidth=70

function! ScyAutoAutoFormatToggle()
	" If the filetype is wrong, unbind.
	if &filetype != "mail"
		autocmd! ScyFTMail
		return
	endif
	" If the line number has not changed, do nothing.
	" TODO: Maybe this is not perfect, do performance checks.
	if exists("s:line") && line(".") == s:line
		return
	endif
	" Store the current line.
	let s:line = line(".")
	" If there's no empty line before the current cursor position...
	if search("^$", "bnW") == 0
		" ... we're in the header, don't use auto-format.
		set formatoptions-=a
	else
		" ... we're past the header, use auto-format.
		set formatoptions+=a
	endif
endfunction

augroup ScyFTMail
	autocmd CursorMoved,CursorMovedI <buffer> call ScyAutoAutoFormatToggle()
augroup end
