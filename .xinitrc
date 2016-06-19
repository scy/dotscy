#!/bin/sh

# Append $HOME/bin to the $PATH.
# Supports my $MASTERPATH construct (see .sh/environment).
[ -z "$MASTERPATH" ] && export MASTERPATH="$PATH"
export PATH="$HOME/bin:$MASTERPATH"

# If this is a mac, do nothing at all.
if [ "$(uname 2>/dev/null)" = 'Darwin' ]; then
	exec quartz-wm "$@"
fi

# Needed for crappily configured xdms which keep an xconsole open.
# (I'm looking at you, Gentoo!)
which killall >/dev/null 2>&1 && killall xconsole

# Don't beep.
xset b off

# Enable numlock if we have numlockx.
which numlockx >/dev/null 2>&1 && numlockx on

# Currently, I don't use Neo. Have totally unlearned it.
# xmodmap "$HOME/res/neo_de.xmodmap"

# Enable tapping on the trackpad (instead of clicking) and invert scroll direction.
which synclient >/dev/null 2>&1 && synclient TapButton1=1 TapButton2=2 TapButton3=3 VertScrollDelta=-200 HorizScrollDelta=-200

# Configure peripherals.
"$HOME/bin/x-peripherals.sh"

# If available, load private configuration data.
[ -e "$HOME/.sh/private" ] && . "$HOME/.sh/private"

# Start Dropbox, if installed.
which dropbox >/dev/null 2>&1 && dropbox start -i &

# Start xbindkeys, if installed.
which xbindkeys >/dev/null 2>&1 && xbindkeys

# Start urxvtd, if installed.
if which urxvtd >/dev/null 2>&1; then
	mkdir -p "$HOME/.urxvt" && rm -f "$HOME/.urxvt/"urxvtd-*
	export RXVT_SOCKET="$HOME/.urxvt/urxvtd-$(hostname)-$$"
	urxvtd -f -o -q
fi

# Start smbnetfs, if installed and configured.
[ -r "$HOME/.smb/smbnetfs.conf" -a -d '/mnt/smb' ] && which smbnetfs >/dev/null 2>&1 && smbnetfs -o allow_root /mnt/smb >/dev/null 2>&1

# Start the right window manager etc. depending on the host.
case "$(hostname)" in
	*)
		WM='i3 --shmlog-size=26214400'
		;;
esac
exec $WM >/dev/null
