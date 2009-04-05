#!/bin/sh
xmodmap "$HOME/.scy/res/neo_de.xmodmap"
xscreensaver &
xset b 10 900 80
"$HOME/bin/mplayer-nosaver.sh" &
urxvtd -q -o -f
urxvtc &
exec awesome
