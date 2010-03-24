" Vim scripts from the website.
autocmd BufRead http://www.vim.org/scripts/download_script.php\?src_id=* setfiletype vim

" Fall back to DokuWiki if the URL contains /wiki/.
autocmd BufRead * if $VIMPERATOR_URL =~ '/wiki/' | setfiletype dokuwiki | endif
