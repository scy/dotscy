#!/bin/sh

if [ "$(hostname)" = 'coco-nb-434' ]; then      # Work machine.
	if lsusb | grep -q ' ID 17ef:100a '; then   # Docked.
		xrandr --output LVDS1 --auto --primary --pos 0x300 --output HDMI3 --auto --pos 1600x0
	else                                        # Not docked.
		xrandr --output LVDS1 --auto --primary --output HDMI3 --off
	fi
fi # If not work machine, do nothing.
