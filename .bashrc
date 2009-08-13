# My favorite time formats.
TIME_LONG='%a %d %b %y %H:%M:%S'
TIME_DEFAULT="$TIME_LONG"



# Not needed, but sometimes pre-defined.
unset PROMPT_COMMAND



# SCM status information in the prompt.
gitprompt() {
	local branch="$(git symbolic-ref HEAD 2>/dev/null)"
	if [ -n "$branch" ]; then
		echo -n "${branch#refs/heads/} "
		local flags="$(git status | sed -n -e 's/^# Your branch is ahead of .\+ by \([0-9]\+\) commits\?.$/\1/p' -e 's/^# Changes to be committed:$/+/p' -e 's/^# Changed but not updated:$/~/p' -e 's/^# Untracked files:$/?/p' | tr -d \\n)"
		[ -n "$flags" ] && echo -n "$flags "
	fi
}



# Define the prompt.

USERCOLOR=32                             # green by default
[[ "$USER" != 'scy' ]] && USERCOLOR=33   # yellow if not "scy"
[[ "$UID" -eq 0 ]] && USERCOLOR=31       # red if root

case "$HOSTNAME" in
	bijaz)
		HOSTCOLOR=32;;   # green for the default, bijaz.
	chani)
		HOSTCOLOR=33;;   # yellow for chani
	*)
		HOSTCOLOR=37;;   # white by default
esac

# Use window titles only in known X terminals.
case "$TERM" in
	xterm*|rxvt*|Eterm|aterm|kterm|gnome|screen)
		TITLE='\[\e]0;\u@\h:\w\a\]';;
	*)
		unset TITLE;;
esac

PS1="$TITLE\[\e[1;${USERCOLOR}m\]\u\[\e[0;32m\]@\[\e[1;${HOSTCOLOR}m\]\h\[\e[1;34m\] \w \[\e[0;36m\]$(which git >/dev/null && echo '$(gitprompt)')\[\e[1;30m\]\$(cut -d ' ' -f 1 /proc/loadavg 2>/dev/null)\[\e[0;37m\] \A \[\e[1;${USERCOLOR}m\]\\\$\[\e[0m\] "
unset TITLE
unset HOSTCOLOR
unset USERCOLOR



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
