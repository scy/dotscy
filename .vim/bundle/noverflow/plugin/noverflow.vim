function! Noverflow()
	let maxlen=80
	execute "match ErrorMsg '\\%<" . (maxlen + 2) . "v.\\%>" . (maxlen + 1) . "v'"
endfunction

augroup Noverflow
	autocmd!
	autocmd VimEnter * autocmd Noverflow WinEnter * let w:Noverflow_ran=1
	autocmd VimEnter * call Noverflow() | let w:Noverflow_ran=1
	autocmd WinEnter * if !exists('w:Noverflow_ran') | call Noverflow() | endif
augroup END
