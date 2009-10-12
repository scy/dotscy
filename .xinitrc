#!/bin/sh
xmodmap "$HOME/.scy/res/neo_de.xmodmap"
xscreensaver &
xset b 10 900 80 r rate 250 25
"$HOME/bin/mplayer-nosaver.sh" &
"$HOME/bin/term.sh" &
"$HOME/bin/gpg-agent.sh"
case "$HOSTNAME" in
	box)
		synergys
		WM='awesome'
		;;
	bijaz)
		# xrandr --output VGA1 --preferred --pos 1024x0 --output LVDS1 --pos 0x256
		WM="$HOME/proj/i3/i3"
		;;
	*)
		WM='false'
		;;
esac
exec "$WM"
