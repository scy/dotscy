" Define my Vimwikis. There's more configuration in .vim/ftplugin/vimwiki.vim
" that will be loaded on demand when a Vimwiki file is opened.
let g:vimwiki_list = [{'path': '~/wiki/Personal/', 'syntax': 'markdown', 'ext': '.md', 'auto_tags': 1}]

nnoremap <Leader>wl :edit $HOME/wiki/Personal/todo.md<CR>
