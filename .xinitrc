#!/bin/sh

# If this is a mac, do nothing at all.
if [ "$(uname 2>/dev/null)" = 'Darwin' ]; then
	exec quartz-wm "$@"
fi

# Needed for crappily configured xdms which keep an xconsole open.
# (I'm looking at you, Gentoo!)
which killall >/dev/null 2>&1 && killall xconsole

# More recent X servers don't terminate on C-A-Backspace anymore.
# This enables it again.
setxkbmap -option terminate:ctrl_alt_bksp

# Don't beep.
xset b off

# Enable numlock if we have numlockx.
which numlockx >/dev/null 2>&1 && numlockx on

# Currently, I don't use Neo. Have totally unlearned it.
# xmodmap "$HOME/res/neo_de.xmodmap"

# Configure peripherals.
"$HOME/bin/x-peripherals.sh"

# If available, load private configuration data.
[ -e "$HOME/.sh/private" ] && . "$HOME/.sh/private"

# Start Dropbox, if installed.
which dropbox >/dev/null 2>&1 && dropbox start -i &

# Start the right window manager etc. depending on the host.
case "$(hostname)" in
	*)
		WM='i3'
		;;
esac
exec "$WM" >/dev/null
