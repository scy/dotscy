# Editor.  Choose the best one available on this machine.
# ("scy-editor" lives in .scy/bin)
export EDITOR=scy-editor
export VISUAL="$EDITOR"
alias E="$EDITOR"

# Browser.  Currently I'm still using firefox.
export BROWSER="firefox '%s' &"

# German man pages suck, they're outdated and crappy.
alias man='LC_ALL=C man'
# Default settings for cal.
alias cal='cal -m -3'

# Work on dotfiles.
alias .scy='cd "$HOME/.scy" && git status'

# Screen.  "SS" stands for "Screen Session", just in case you wonder.
alias S='screen'
alias SS='S -D -R -c .screen-$HOSTNAME'

# Bash configuration stuff.
alias Brh='. ~/.bashrc'
alias Bal='E ~/.bash_aliases && Brh'
alias Brc='E ~/.bashrc && Brh'

# Git things.
alias G='git'
eval alias $( \
	git config --global --get-regexp '^alias\.' | \
	sed -e 's/^alias\.\([^ ]\+\) .\+$/G\1="G \1"/' | \
	tr '\n' ' ' \
)

# ls shortcuts.
alias ll='ls -lh'
alias la='ls -a'

# Calendar stuff.
alias rem='rem -m -b1'
alias remind='remind -m -b1'
alias bday='E ~/doc/pim/cal/birthdays && ~/doc/pim/cal/generate.sh'

# Music stuff.
alias M='mpc'
alias Mrandom='mpc clear; mpc add / >/dev/null; mpc shuffle; mpc play'
alias Mn='mpc next'

# scp should preserve modification times and display a progress bar.
alias scp='scp -qp'

# Oh, and the same is true for "normal" cp.
alias cp='cp -av'

# exiftool defaults: Overwrite, use float GPS output
alias exif='exiftool -overwrite_original -c %.6f'

# Locations.
alias GPSF3='exiftool -overwrite_original -GPSLatitude=49.489682 -GPSLatitudeRef=North -GPSLongitude=8.464796 -GPSLongitudeRef=East'



# On Windows/Cygwin, do some special things.
[ "$OSTYPE" = 'cygwin' ] && . "$HOME/.bash_windows"



# Add local bash config, if any.
[[ -r "$HOME/.bash_local" ]] && . "$HOME/.bash_local"
