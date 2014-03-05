#!/bin/bash

# We're called from xbindkeys and might not have $HOME/bin in the $PATH.
export PATH="$HOME/bin:$PATH"

xvkbdtext () {
	xvkbd -text "$@" >/dev/null 2>&1
}

action="$1"

activewindow="$(active-window)"

case "$activewindow" in
	x-www-browser|X-www-browser|google-chrome|Google-chrome)
		case "$action" in
			thumb)
				# Close tab.
				xvkbdtext '\C\[F4]'
				;;
			shift-thumb)
				# Reopen last tab.
				xvkbdtext '\CT'
				;;
		esac
		;;
esac
