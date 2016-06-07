#!/bin/sh

backlightFile='/sys/class/backlight/nv_backlight/brightness'

msg() {
	echo "$@"
}

if [ -f "$backlightFile" ]; then
	if [ -w "$backlightFile" ]; then
		msg 'backlight control file is writable.'
	else
		msg 'fixing non-writable backlight file…'
		sudo chown root:video "$backlightFile"
		sudo chmod 0664 "$backlightFile"
	fi
fi
