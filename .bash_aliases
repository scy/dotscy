# Editor.  Currently I'm still using nano.
# ("nanow" lives in .scy/bin)
export EDITOR=nanow
export VISUAL="$EDITOR"
alias E="$EDITOR"

# German man pages suck, they're outdated and crappy.
alias man='LC_ALL=C man'

# Work on dotfiles.
alias .scy='cd "$HOME/.scy" && git status'

# Screen.  "SS" stands for "Screen Session", just in case you wonder.
alias S='screen'
alias SS='S -D -R -c .screen-$HOSTNAME'
