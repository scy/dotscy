set background=dark
highlight clear
let g:colors_name = "dunkel"

function s:H(group, fore, back)
    exec "highlight " . a:group . " ctermfg=" . a:fore . " ctermbg=" . a:back . " guifg=" . a:fore . " guibg=" . a:back
endfunction

function s:HF(group, fore)
    exec "highlight " . a:group . " ctermfg=" . a:fore . " guifg=" . a:fore
endfunction

function s:HB(group, back)
    exec "highlight " . a:group . " ctermbg=" . a:back . " guibg=" . a:back
endfunction

" Normal text is gray on black.
call s:H(	"Normal",	"LightGray",	"Black")

" Diff formatting.
call s:H(	"DiffDelete",	"DarkGray",	"DarkRed")
call s:HB(	"DiffAdd",	"DarkGreen")
call s:HB(	"DiffChange",	"DarkGray")
call s:HB(	"DiffText",	"Red")

" Folded lines.
call s:H(	"Folded",	"DarkBlue",	"DarkYellow")

" Application items.
call s:HF(	"LineNr",	"DarkGray")
call s:HF(	"SpecialKey",	"DarkGray")

" Green cursor.
highlight Cursor guifg=bg guibg=Green

" Don't invert the status line, except on a monochrome display.
highlight StatusLine term=reverse,bold cterm=bold gui=bold
highlight StatusLineNC term=reverse cterm=none gui=none
call s:H(	"StatusLine",	"Yellow",	"Blue")
call s:H(	"StatusLineNC",	"LightGray",	"Blue")
" Take User9 for red status bar items, if it's not already set to something different.
highlight default User9 term=bold cterm=bold ctermfg=Red ctermbg=Blue gui=bold guifg=Red guibg=Blue
" Take User8 for gray status bar items, if it's not already set to something different.
highlight default User8 term=bold cterm=bold ctermfg=Gray ctermbg=Blue gui=bold guifg=Gray guibg=Blue

delfunction s:H
delfunction s:HF
delfunction s:HB

" vim: set ts=25 tw=0:
