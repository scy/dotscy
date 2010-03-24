" Fall back to DokuWiki if the URL contains /wiki/.
autocmd BufRead * if $VIMPERATOR_URL =~ '/wiki/' | setfiletype dokuwiki | endif
