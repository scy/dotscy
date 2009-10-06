#!/bin/sh

contains() {
	sub="$1"
	shift
	for str in "$@"; do
		if echo "$str" | grep -qF "$sub"; then
			return 0
		fi
	done
	return 1
}

flags="$8"
fifo="$4"

goto="$(cut -f 1,3- "$HOME/.uzbl/bookmarks.txt" | fmenu -i -l 5 | cut -f 1)"
if [ -z "$goto" ]; then
	exit 0
fi
goto="$(echo "$goto" | sed -r \
	-e 's#^g(| +(.*))$#http://google.de/search?q=\2#' \
	-e 's#^gp +(.*)$#http://gentoo-portage.com/Search?search=\1#' \
	-e 's#^w(| +.*)$#wde\1#' \
	-e 's#^w([a-z]+)$#http://\1.wikipedia.org/#' \
	-e 's#^w([a-z]+) +(.*)$#http://\1.wikipedia.org/w/index.php?title=Special%3ASearch\&search=\2#' \
	-e 's# #%20#g' \
)"
if [ -z "$fifo" ] || contains t "$flags"; then
	exec scy-browser "$goto"
else
	echo "set uri = $goto" > "$fifo"
fi
