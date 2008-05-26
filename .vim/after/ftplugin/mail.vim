" Wrap earlier to help people who can't quote.
setlocal textwidth=70

" Better tab width, and don't use tabs in the mail!
setlocal tabstop=5
setlocal expandtab

" Activate spell checking.
setlocal spell

" Auto-format will be used (except in the header), so remove "c" flag to 
" format everything and not only comments.
setlocal formatoptions-=c

" Change window width.
" TODO: only if this is the only buffer.
if has("gui_running")
	set columns=72
endif

" Replace Outlook's crappy message headers.
let cursor = getpos('.')
let wasmodified = &modified
normal gg
silent! s/\v%^(\n*)[> ]*-{5}%(Original Message|Ursprüngliche Nachricht)-{5}\n[> ]*%(From|Von): (.+)\n[> ]*%(Sent|Gesendet): (.+)\n%([> ]*.*\n){-}[> ]*$/\1\3, \2:/
call setpos('.', cursor)
silent! s/\v%^(\n*)(.+)\[mailto:([a-zA-Z0-9._@-]+)\]:$/\1\2<\3>:/
if wasmodified
	set modified
else
	set nomodified
endif
call setpos('.', cursor)

function! ScyAutoAutoFormatToggle()
	" If the filetype is wrong, unbind.
	if &filetype != "mail"
		autocmd! ScyFTMail
		return
	endif
	" If the line number has not changed, do nothing.
	" TODO: Maybe this is not perfect, do performance checks.
	" TODO: Will misbehave if you start writing a header in line 1 yourself.
	if exists("s:line") && line(".") == s:line
		return
	endif
	" Store the current line.
	let s:line = line(".")
	" If there's no empty line before the current cursor position
	" and if the first line looks like an e-mail header...
	if search("^$", "bnW") == 0 && getline("1") =~ "^[a-zA-Z0-9-]\\+:\\s"
		" ... we're in the header, don't use auto-format.
		setlocal formatoptions-=a
		setlocal formatoptions-=t
	else
		" ... we're past the header, use auto-format.
		setlocal formatoptions+=a
		setlocal formatoptions+=t
	endif
endfunction

augroup ScyFTMail
	autocmd CursorMoved,CursorMovedI <buffer> call ScyAutoAutoFormatToggle()
augroup end

" Initialize the options.
call ScyAutoAutoFormatToggle()
