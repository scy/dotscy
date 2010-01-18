#!/bin/sh

what="$8"
where="$9"

case "$what" in
	url)
		cont="$6"
		;;
	title)
		cont="$7"
		;;
	*)
		exit 1
		;;
esac

echo -n "$cont" | xclip -selection "$where" -i
