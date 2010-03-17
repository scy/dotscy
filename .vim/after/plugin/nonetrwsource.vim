" Remove autocommands that modify sourcing a script.
" Especially don't allow netrw.
autocmd! SourceCmd
augroup  Network
autocmd! SourceCmd
augroup  end
