if has("multi_byte")
	" A must-have for being able to convert everything into everything
	" To be able to use this under Windows, see "newer intl library" at
	" http://vim.sourceforge.net/download.php#pc
	set encoding=utf-8
	" Try to recognize the file encoding in a sophisticated way.
	set fileencodings=ucs-bom,utf-8,default,latin1
	" Default to writing utf-8 files.
	setglobal fileencoding=utf-8
else
	echoerr "Dear God, we don't have multi_byte support!"
endif

" Set messages language to English (German translations are a bit crappy).
" TODO: Check whether this works on Windows.
language messages C

" Spell checking in German Neusprech and English.
set spelllang=de_20,en

" Automatically generate the local dictionary from a wordlist in Git.
" TODO: This is hackish.
if glob("$HOME/.vim/spell/de.utf-8.add") != "" && ( glob("$HOME/.vim/spell/de.utf-8.add.spl") == "" || getftime("$HOME/.vim/spell/de.utf-8.add") > getftime("$HOME/.vim/spell/de.utf-8.spl") )
	silent mkspell! $HOME/.vim/spell/de.utf-8.add
	echomsg "Updated local dictionary."
endif
