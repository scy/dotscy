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
		xinput set-button-map "$dev" 1 2 3 5 4 7 6
	done
fi



# Funky keyboard setup. I'm currently using a ThinkPad with an Apple USB
# keyboard connected and want to have the best of both worlds.

# You also need this line in /etc/modprobe.d/hid_apple.conf in order to no
# longer having to press Fn for the normal F keys and to swap <> and ^° again
# (because the Apple keyboard swaps those when being used without config):
#     options hid_apple fnmode=2 iso_layout=0
# If the module is loaded in the initramfs (no idea how that's decided, but for
# me it's the case because I'm using whole disk encryption), you need that line
# instead in /etc/modules (on Debian, ymmv on other distributions):
#     hid_apple fnmode=2 iso_layout=0

# Note that this configuration will leave you with only a single "Super" key,
# which is the left Cmd (or Win) key. You won't have a right Super key anymore.

# Depending on your needs, you might want to also have a look at the Xkb option
# "apple:alupckeys". However, I chose to do that manually.

# First, enable compose on caps lock. Because who needs caps lock anyway. Also,
# disable all other options and allow Ctrl+Alt+Backspace to zap the X server.
setxkbmap -option '' -option compose:caps -option terminate:ctrl_alt_bksp

# Next, do the Apple keyboard specific fixes. We need xinput to find out what
# the ID of the keyboard(s) is.

if have_xinput; then
	# For each connected Apple keyboard...
	for id in $(xinput | awk '/Apple Inc\. Apple Keyboard/ { sub(/^.*id=/, ""); sub(/[^0-9].*$/, ""); print; };'); do
		# Set right Cmd to Alt Gr, not Super.
		# Set right Alt to Alt, not Alt Gr.
		setxkbmap -device "$id" \
			-option lv3:rwin_switch -option lv3:ralt_alt
	done
fi

# Lastly, there's my xmodmap file, which sets F13 to Print and F15 to Insert.
xmodmap "$HOME/res/scy.xmodmap"
