#!/bin/sh

# Logs a single line of text with a timestamp to this file:
TARGET="$HOME/dia.log"

# This is (currently) an OS X tool.

# How I use it:
#  1) Get FastScripts from http://www.red-sweater.com/fastscripts/
#  2) Install it and stuff
#  3) Copy this file to ~/Library/Scripts to use with FastScripts
#     (I've already contacted Red Sweater, asking them to support symlinks)
#  4) In FastScripts, Preferences, Script Shortcuts, find dia-log.sh and bind
#     a cool shortcut to it
#  5) Whenever you press the shortcut, a dialog will open, asking you for a
#     line of text. That line will be logged to $TARGET (or not, if you hit
#     Cancel) in a pipe-separated line containing epoch, human readable
#     timestamp and your awesome text

# TODO:
#  - Make some things smoother, maybe?
#  - Whatever else.

# Made by Tim "Scytale" Weber, @Scytale on Twitter. WTFPL.

# This is where the code starts. No need to read any further.



# Parse options.
text=''
while getopts o:t: opt; do
	case "$opt" in
		o)
			TARGET="$OPTARG"
			;;
		t)
			text="$OPTARG"
			;;
	esac
done

if [ -z "$text" ]; then
	# Read the text, output it prefixed with "OK:" or output nothing at all.
	text="$(osascript -e 'tell application "System Events"' -e 'activate' -e 'display dialog "Status:" default answer ""' -e 'end tell' | sed -n -e 's/^text returned:\(.*\), button returned:OK$/OK:\1/p')"
fi

# If there is text, log it.
if [ -n "$text" ]; then
	echo "$(date "+%s|%Y-%m-%d %H:%M:%S %z|")$(echo "$text" | cut -d : -f 2-)" >> "$TARGET"
fi
