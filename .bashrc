s() {
	[ -e "$HOME/.sh/$1" ] && source "$HOME/.sh/$1"
}

s aliases

# If this shell is not interactive, stop at this point.
if [ -z "$PS1" ]; then return; fi

s private
s prompt
