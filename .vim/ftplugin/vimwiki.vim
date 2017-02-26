" Syntax highlighting for checklists.
let g:vimwiki_hl_cb_checked = 1

" Progress barish indication of sublist completion.
let g:vimwiki_listsyms = ' ▁▂▃▄▅▆▇X'

" Use folding, but expand top-level content by default.
let g:vimwiki_folding = 'expr'
setlocal foldlevel=1

" At some point in the future, I want to be able to press <Tab> at the
" beginning of a line and have Vim insert a tab character, but when using
" <C-T> or >> on lists, insert only two spaces. I'm sure it's possible, but I
" haven't figured out how. For the time being, use expandtab.
setlocal tabstop=4 softtabstop=4 shiftwidth=2 expandtab copyindent
