if did_filetype()
	finish
endif

" Get first non-empty line.
let s:oldrow = line(".")
let s:oldcol = col(".")
call cursor(1, 1)
let s:firstline = search("\\S", "nW")

if search("<!DOCTYPE\\s\\+html\\s", "nW", s:firstline) != 0
	setfiletype html
endif

" Move back to where we came from.
call cursor(s:oldrow, s:oldcol)
