#!/bin/sh


# THIS IS NOT WORKING YET.


HIST="$HOME/.uzbl/history.txt"
url="$6"
title="$7"
now="$(date +%s)"

removefromhistory() {
	local num="$(
	grep -nF "$1 " "$HIST" | while read line; do
		if [ "$(echo "$line" | sed 's/^[0-9]\+:\([^ ]\+\) .\+/\1/')" = "$1" ]; then
			num="$(echo -n "$line" | cut -d : -f 1)"
			break
		fi
	done)"
	if [ -z "$num" ]; then
		return 1
	fi
	sed -i -e "${num}d"
}

removefromhistory "$url"
echo "$6 $(date +%s) $7" >> "$HOME/.uzbl/history.txt"
