#!/bin/sh

if xrandr | grep -q '^VGA1 connected '; then
	if lsusb | grep -q ' ID 046a:0004 '; then
		# Docked.
		xrandr --output VGA1 --mode 1280x1024 --pos 1024x0 --output LVDS1 --pos 0x460
	else
		# Undocked with external display (projector etc).
		xrandr --output VGA1 --mode 1024x768 --pos 1024x0 --output LVDS1 --pos 0x0
	fi
elif xrandr | grep -q '^DVI-0 connected '; then
	# Work machine.
	xrandr --output DVI-0 --left-of VGA-0
else
	# No external display. Currently, do nothing.
	:
fi
