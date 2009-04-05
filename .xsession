#!/bin/sh
xscreensaver &
xset b 10 900 80
"$HOME/bin/mplayer-nosaver.sh" &
urxvtd -q -o -f
urxvtc &
exec awesome
