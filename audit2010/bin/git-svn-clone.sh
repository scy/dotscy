#!/bin/sh

url="$1"; shift
proj="$(basename "$url")"

user="$1"; shift

authorsfile='.git/authorsfile'

git svn init -s --username="$user" "$url" "$proj"
cd "$proj"
scy-editor "$authorsfile"
git config svn.authorsfile "$authorsfile"

usertuple="$(sed -nr -e "s/^$user[ =]+(.+) +<(.+)> *$/\\2 \\1/p" "$authorsfile")"

git config user.email "$(echo "$usertuple" | cut -d ' ' -f 1)"
git config user.name  "$(echo "$usertuple" | cut -d ' ' -f 2-)"

git svn fetch
