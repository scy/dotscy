" Did I mention I love Terminus? This is the Windows font, I'm not using gvim 
" under X at the moment.
set guifont=ter-112n:h9,Consolas:h9:cANSI

" Disable the toolbar. Once I disabled the menu here, but the reason for that 
" went away after discovering the 'winaltkeys' option.
set guioptions-=T

" <Alt>+<Letter> is not eaten by the menu. This is a good thing since all my 
" bindings use Alt.
set winaltkeys=no

if !exists("s:initialized")
	let s:initialized = "yes"

	" Initialize a decent window size.
	if has("gui_running")
		set lines=50 columns=150
	endif
endif
