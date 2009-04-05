#!/bin/sh

if which urxvtc &>/dev/null; then
	urxvtc "$@"
	if [ "$?" -eq 2 ]; then
		urxvtd -q -o -f
		urxvtc "$@"
	fi
else
	xterm "$@"
fi
