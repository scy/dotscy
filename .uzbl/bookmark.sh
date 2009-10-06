#!/bin/sh

FILE="$HOME/.uzbl/bookmarks.txt"

url="$6"
title="$7"
tags="$8"
now="$(date +%s)"

while true; do
	tag="$(cut -f 3 "$FILE" | tr ',' '\n' | sort | uniq | fmenu -i)"
	if [ -z "$tag" ]; then
		break
	fi
	if [ "$tag" = '!' ]; then
		exit
	fi
	tags="$tags,$tag"
done

tags="$(echo "$tags" | cut -b 2-)"

echo -e "$url\\t$now\\t$tags\\t$title" >> "$FILE"
