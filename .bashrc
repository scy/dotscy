# My favorite time formats.
TIME_LONG='%a %d %b %y %H:%M:%S'
TIME_DEFAULT="$TIME_LONG"



# SCM status information in the prompt.
unset PSGIT
PSGITCMD=':'
which git >/dev/null && PSGITCMD='gitprompt'
gitprompt() {
	local branch="$(git symbolic-ref HEAD 2>/dev/null)"
	if [ -n "$branch" ]; then
		echo -n "${branch#refs/heads/} "
		local flags="$(git status 2>/dev/null | sed -n -e 's/^# Your branch is ahead of .\+ by \([0-9]\+\) commits\?.$/\1/p' -e 's/^# Changes to be committed:$/+/p' -e 's/^# Changed but not updated:$/~/p' -e 's/^# Untracked files:$/?/p' | tr -d \\n)"
		[ -n "$flags" ] && echo -n "$flags "
	fi
}



scyprompt() {
	local r="$?"
	# Refresh the Git prompt, if we have Git.
	PSGIT="$($PSGITCMD)"
	# Refresh the load average.
	PSLOAD="$(cut -d ' ' -f 1 /proc/loadavg 2>/dev/null)"
	# Refresh the jobs count.
	local runningjobs="$(jobs -r | wc -l)"
	local stoppedjobs="$(jobs -s | wc -l)"
	PSJOBS="$([[ "$runningjobs" -gt 0 ]] && echo -n "${runningjobs}r")$([[ "$runningjobs" -gt 0 && "$stoppedjobs" -gt 0 ]] && echo -n '/')$([[ "$stoppedjobs" -gt 0 ]] && echo -n "${stoppedjobs}s")"
	[ -n "$PSJOBS" ] && PSJOBS="$PSJOBS "
	# End of refreshments. Start working.
	PS1="$PSFIX"
	# Git info.
	PS1="$PS1\\[\\e[0;36m\\]$PSGIT"
	# Load average.
	PS1="$PS1\\[\\e[1;30m\\]$PSLOAD"
	# Current time.
	PS1="$PS1\\[\\e[0;37m\\] \\A "
	# Number of jobs.
	PS1="$PS1\\[\\e[0;33m\\]$PSJOBS"
	# Prompt character (red when last command failed, else green).
	PS1="$PS1\\[\\e[1;3$(($r > 0 ? 1 : 2))m\\]\\$"
	# Back to normal.
	PS1="$PS1\\[\\e[0m\\] "
}



# Define the prompt.

PSUSERCOLOR=32                             # green by default
[[ "$USER" != 'scy' ]] && PSUSERCOLOR=33   # yellow if not "scy"
[[ "$UID" -eq 0 ]] && PSUSERCOLOR=31       # red if root

case "$HOSTNAME" in
	bijaz)
		PSHOSTCOLOR=32;;   # green for the default, bijaz.
	chani)
		PSHOSTCOLOR=33;;   # yellow for chani
	*)
		PSHOSTCOLOR=37;;   # white by default
esac

# Use window titles only in known X terminals.
case "$TERM" in
	xterm*|rxvt*|Eterm|aterm|kterm|gnome|screen)
		PSTITLE='\[\e]0;\u@\h:\w\a\]';;
	*)
		unset PSTITLE;;
esac

# Window title, if in a supported terminal.
PSFIX="$PSTITLE"
# User name, colored accordingly.
PSFIX="$PSFIX\\[\\e[1;${PSUSERCOLOR}m\\]\\u"
# @ character.
PSFIX="$PSFIX\\[\\e[0;32m\\]@"
# Host name, colored accordingly.
PSFIX="$PSFIX\\[\\e[1;${PSHOSTCOLOR}m\\]\\h"
# Working directory.
PSFIX="$PSFIX\\[\\e[1;34m\\] \\w "

PROMPT_COMMAND='scyprompt'



# Quick hack for symlink ugliness.
[[ "$PWD" == '/mnt/crypt/home/scy' ]] && cd



# Set colors for ls.
for file in /etc/DIR_COLORS "$HOME/.dir_colors"; do
	[[ -r "$file" ]] && eval $(dircolors -b "$file")
done



# Load aliases.
[[ -f "$HOME/.bash_aliases" ]] && . "$HOME/.bash_aliases"



# More into the PATH, but don't recursively bloat when reloading .bashrc.
[[ -z "$MASTERPATH" ]] && export MASTERPATH="$PATH"
export PATH="$HOME/bin:$HOME/doc/trackdb:$HOME/proj/bashnag:$MASTERPATH:/usr/sbin:/sbin"



# Set locale.
export LC_ALL='en_US.UTF-8'

# On bijaz, use German instead.
[[ "$HOSTNAME" == 'bijaz' ]] && export LC_ALL='de_DE.UTF-8'



# Disable "!"-style history expansion, sucks for literal "!"s.
set +H



# Meta-keys should produce escape sequences, 8th bit is crap for UTF-8.
setmetamode esc &>/dev/null



# History groovyness.
HISTCONTROL='ignorespace'
HISTSIZE=10000
HISTFILESIZE=$HISTSIZE
HISTTIMEFORMAT="$TIME_DEFAULT  "



# Set up GPG agent.
eval "$(gpg-agent.sh 2>/dev/null)"



# Regenerate .less, if required.
[ -r "$HOME/.lesskey" -a "$HOME/.lesskey" -nt "$HOME/.less" ] && lesskey



# Don't return false.
true
