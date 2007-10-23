# Editor.  Currently I'm still using nano.
# ("nanow" lives in .scy/bin)
export EDITOR=nanow
export VISUAL="$EDITOR"
alias E="$EDITOR"

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

# ls shortcuts.
alias ll='ls -lh'
alias la='ls -a'



# Music stuff.
alias Mcollect='mpc clear; mpc listall | grep "^Archiv/Music" | while read track; do mpc add "$track"; done; mpc save LIBRARY'
alias Mrandom='mpc clear; mpc load LIBRARY; mpc shuffle; mpc play'
alias Mn='mpc next'



# Add local bash config, if any.
[[ -r "$HOME/.bash_local" ]] && . "$HOME/.bash_local"
