autocmd BufRead *.log if getline("1") =~ ' \[DEBUG\] Die Anwendung wurde gestartet\.$' | setfiletype acrawl | endif
