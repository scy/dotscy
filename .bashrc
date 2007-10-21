# Not needed, but sometimes pre-defined.
unset PROMPT_COMMAND



# Define the prompt.

USERCOLOR=32                             # green by default
[[ "$USER" != 'scy' ]] && USERCOLOR=33   # yellow if not "scy"
[[ "$UID" -eq 0 ]] && USERCOLOR=31       # red if root

case "$HOSTNAME" in
	bijaz)
		HOSTCOLOR=32;;   # green for the default, bijaz.
	*)
		HOSTCOLOR=37;;   # white by default
esac

PS1="\[\e]0;\u@\h:\w\a\e[1;${USERCOLOR}m\]\u\[\e[0;32m\]@\[\e[1;${HOSTCOLOR}m\]\h\[\e[1;34m\] \w \[\e[1;30m\]\$(cut -d ' ' -f 1 /proc/loadavg 2>/dev/null)\[\e[0;37m\] \A \[\e[1;${USERCOLOR}m\]\\\$\[\e[0m\] "



# Quick hack for symlink ugliness.
[[ "$(pwd)" == '/mnt/crypt/home/scy' ]] && cd



# Set colors for ls.
for file in /etc/DIR_COLORS "$HOME/.dir_colors"; do
	[[ -r "$file" ]] && eval $(dircolors -b "$file")
done



# Load aliases.
[[ -f "$HOME/.bash_aliases" ]] && . "$HOME/.bash_aliases"



# More into the PATH.
export PATH="$HOME/bin:$HOME/.scy/bin:$HOME/doc/trackdb:$PATH:/usr/sbin"



# Set locale.
export LC_ALL='en_US.UTF-8'

# On bijaz, use German instead.
[[ "$HOSTNAME" == 'bijaz' ]] && export LC_ALL='de_DE.UTF-8'



# Disable "!"-style history expansion, sucks for literal "!"s.
set +H
