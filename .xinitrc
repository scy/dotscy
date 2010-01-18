#!/bin/sh

# Needed for crappily configured xdms which keep an xconsole open.
# (I'm looking at you, Gentoo!)
killall xconsole

# More recent X servers don't terminate on C-A-Backspace anymore.
# This enables it again.
setxkbmap -option terminate:ctrl_alt_bksp

# Load my favorite keyboard layout.
xmodmap "$HOME/.res/neo_de.xmodmap"

# Start the right window manager etc. depending on the host.
case "$HOSTNAME" in
	bijaz)
		WM='i3'
		;;
	*)
		WM='false'
		;;
esac
exec "$WM"
