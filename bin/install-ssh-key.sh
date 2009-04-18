#!/bin/sh

if [ -z "$HOME" ]; then
	echo '$HOME is not set; are you kidding me?' >&2
	exit 1
fi

DEFAULTPUB="$HOME/.ssh/id_rsa.pub"

if [ -z "$1" ]; then
	echo "Usage: $(basename "$0") [user@]host [pubkey]"
	echo "       pubkey defaults to $DEFAULTPUB"
	exit
fi

pubkey="$DEFAULTPUB"

if [ -n "$2" ]; then
	pubkey="$2"
fi

ssh "$1" 'cd && mkdir -p .ssh && cat >>.ssh/authorized_keys' <"$pubkey"
