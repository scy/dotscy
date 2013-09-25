#!/bin/bash

xvkbdtext () {
	xvkbd -text "$@" >/dev/null 2>&1
}

shift=n

while getopts ':s' opt; do
	case "$opt" in
		s)
			shift=y
			;;
		\?)
			echo "Invalid option: -$OPTARG" >&2
			exit 1
			;;
	esac
done

case "$(active-window)" in
	x-www-browser)
		if [ "$shift" = n ]; then
			xvkbdtext '\Cw'
		else
			xvkbdtext '\CT'
		fi
		;;
esac
