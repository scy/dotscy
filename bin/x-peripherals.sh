#!/bin/sh

if [ "$(hostname)" = 'coco-nb-434' ]; then      # Work machine.
	if lsusb | grep -q ' ID 17ef:100a '; then   # Docked.
		xrandr --output LVDS1 --auto --primary --pos 0x300 --output HDMI3 --auto --pos 1600x0
	else                                        # Not docked.
		xrandr --output LVDS1 --auto --primary --output HDMI3 --off
	fi
fi # If not work machine, do nothing.

# If we have xinput, swap the scroll direction. (I'm OS X influenced.)
if which xinput >/dev/null 2>&1; then
	for dev in \
	'Logitech USB Optical Mouse' \
	'SynPS/2 Synaptics TouchPad' \
	; do
		xinput set-button-map "$dev" 1 2 3 5 4 6 7
	done
fi
