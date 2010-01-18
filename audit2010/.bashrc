# My favorite time formats.
TIME_LONG='%a %d %b %y %H:%M:%S'
TIME_DEFAULT="$TIME_LONG"



# More into the PATH, but don't recursively bloat when reloading .bashrc.
[[ -z "$MASTERPATH" ]] && export MASTERPATH="$PATH"
export PATH="$HOME/bin:$HOME/doc/trackdb:$MASTERPATH:/usr/sbin:/sbin:/opt/local/bin"



# SCM status information in the prompt.
unset PSGIT
PSGITCMD=':'
which git >/dev/null && PSGITCMD='gitprompt'
gitprompt() {
	local branch="$(git symbolic-ref HEAD 2>/dev/null)"
	local flags=''
	if [ -n "$branch" ]; then
		echo -n "${branch#refs/heads/} "
		# If this is a git-svn repository, ahead calc works different.
		if [ -d "$(git rev-parse --git-dir 2>/dev/null)/svn" ]; then
			flags="$(git rev-list "$(git log --pretty=format:'%b%n%H' | grep -m 1 -A 2 '^git-svn-id: ' | grep -v '^$' | tail -n 1)..HEAD" | wc -l | grep -v '^0$')s"
		fi
		flags="$flags$(git status 2>/dev/null | sed -n -e 's/^# Your branch is ahead of .\+ by \([0-9]\+\) commits\?.$/\1/p' -e 's/^# Changes to be committed:$/+/p' -e 's/^# Changed but not updated:$/~/p' -e 's/^# Untracked files:$/?/p' | tr -d \\n)"
		[ -n "$flags" ] && echo -n "$flags "
	fi
}



# Load status in the prompt.
# If we have /proc/loadavg, use it.
if [ -r '/proc/loadavg' ]; then
	PSLOADCMD='loadprompt'
else
	# Simply display nothing.
	PSLOADCMD=':'
fi
loadprompt() {
	echo "$(cut -d ' ' -f 1 /proc/loadavg 2>/dev/null) "
}



scyprompt() {
	local r="$?"
	# Refresh the Git prompt, if we have Git.
	PSGIT="$($PSGITCMD)"
	# Refresh the load average.
	PSLOAD="$($PSLOADCMD)"
	# Refresh the jobs count.
	local runningjobs="$(jobs -r | wc -l | tr -cd 0-9)"
	local stoppedjobs="$(jobs -s | wc -l | tr -cd 0-9)"
	PSJOBS="$([[ "$runningjobs" -gt 0 ]] && echo -n "${runningjobs}r")$([[ "$runningjobs" -gt 0 && "$stoppedjobs" -gt 0 ]] && echo -n '/')$([[ "$stoppedjobs" -gt 0 ]] && echo -n "${stoppedjobs}s")"
	[ -n "$PSJOBS" ] && PSJOBS="$PSJOBS "
	# End of refreshments. Start working.
	PS1="$PSFIX"
	# Git info.
	PS1="$PS1\\[\\e[0;36m\\]$PSGIT"
	# Load average.
	PS1="$PS1\\[\\e[1;30m\\]$PSLOAD"
	# Current time.
	PS1="$PS1\\[\\e[0;37m\\]\\A "
	# Number of jobs.
	PS1="$PS1\\[\\e[0;33m\\]$PSJOBS"
	# Prompt character. Red (and showing return value) on error.
	if [[ "$r" -gt 0 ]]; then
		PS1="$PS1\\[\\e[1;31m\\]$r\\$"
	else
		PS1="$PS1\\[\\e[1;32m\\]\\$"
	fi
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
	malus)
		PSHOSTCOLOR=35;;   # magenta for malus
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
# And enable colors in OS X terminals.
export CLICOLOR=1



# Load aliases.
[[ -f "$HOME/.bash_aliases" ]] && . "$HOME/.bash_aliases"



# Set locale.
export LANG='en_US.UTF-8'



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



# If .less does not exist, we have to do something.
if [ -r "$HOME/.lesskey" -a "$HOME/.lesskey" -nt "$HOME/.less" ]; then
	# If we have lesskey, use it.
	if which lesskey 1>/dev/null 2>&1; then
		lesskey
	else
		# Ugly workaround: Set $LESS.
		eval export LESS=\'"$(sed -n -e 's/^LESS=\(.*\)$/\1/p' "$HOME/.lesskey")"\'
	fi
fi



export IPOD_MOUNTPOINT='/mnt/kermit'
export ECHANGELOG_USER="Tim Weber (Scytale) scy-gentoo$(echo -n '@')scytale.name"



# Don't return false.
true
