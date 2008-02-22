color torte
set guifont=ter-112n:h9
set nobackup
set viminfo='20,<50,s10,h,rA:,rB:,n~/.vim/.viminfo
set tabstop=4
set noexpandtab

if has("gui_running")
	set lines=50 columns=150
endif

augroup filetypedetect
	au BufNewFile,BufRead .wimrc setf vim
augroup END
