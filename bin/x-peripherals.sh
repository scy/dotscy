#!/bin/sh

# Checks whether we have xinput.
have_xinput () {
	which xinput >/dev/null 2>&1
}



# Screen setup, based on which machine this is and whether it's docked.

if [ "$(hostname)" = 'coco-nb-434' ]; then      # Work machine.
	if lsusb | grep -q ' ID 17ef:100a '; then   # Docked.
		xrandr --output LVDS1 --auto --primary --pos 0x180 --output HDMI3 --auto --pos 1600x0
	else                                        # Not docked.
		xrandr --output LVDS1 --auto --primary --output HDMI3 --off
	fi
fi # If not work machine, do nothing.



# If we have xinput, swap the mouse scroll direction. (I'm OS X influenced.)

if have_xinput; then
	xinput list --name-only | grep -F "$(printf "\
Logitech USB Optical Mouse\n\
SynPS/2 Synaptics TouchPad\
")" | while read -r dev; do
		xinput set-button-map "$dev" 1 2 3 5 4 6 7
	done
fi
