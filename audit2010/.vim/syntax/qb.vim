syntax clear

" We embed into the normal HTML syntax file.
runtime! syntax/html.vim
syn cluster htmlPreproc add=qbHeaderLine,qbBodyTag

" Case matters for the "qb:" prefix in body tags.
syn case match

" Case doesn't matter for everything else.
syn case ignore

syn match qbHeaderLine "\%1l" contains=qbHeaderNonItem,qbHeaderItem
syn match qbHeaderNonItem contained "[^ ]"
syn match qbHeaderItem contained "<.\{-1,}>" contains=qbHeaderArg,qbHeaderKey
syn match qbHeaderKey contained "<\@<=[a-z0-9]*:"
syn region qbHeaderArg contained start=":\@<=" end=">"he=e-1

highlight link qbHeaderItem Function
" Everything that isn't a meta tag in the header line is an error by default.
highlight link qbHeaderNonItem Error

hi link qbHeaderKey Statement
hi link qbHeaderArg String

