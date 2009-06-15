#!/bin/sh
xmodmap "$HOME/.scy/res/neo_de.xmodmap"
xscreensaver &
xset b 10 900 80
"$HOME/bin/mplayer-nosaver.sh" &
"$HOME/bin/term.sh" &
"$HOME/bin/gpg-agent.sh"
[ "$HOSTNAME" = 'box' ] && synergys
exec awesome
