color torte
set guifont=ter-112n:h9
set nobackup
set viminfo+=n~/.vim/.viminfo
set tabstop=4
set noexpandtab
set nowrap
set scrolloff=10
set formatoptions+=wc

set listchars=tab:\|.,trail:_,extends:>,precedes:<,nbsp:_
set list

" ^K will cut the current line, ^U paste it (nano-like behaviour)
inoremap <C-K> <C-O>dd
inoremap <C-U> <C-O>P

if has("gui_running")
	set lines=50 columns=150
endif

augroup ScyFixes
	autocmd BufRead .git?COMMIT_EDITMSG goto 1
augroup end

augroup ScyFTDetect
	au BufNewFile,BufRead .wimrc setf vim
augroup end
