#!/bin/sh

cd "$HOME/.uzbl/tmp"
fifo="$(echo uzbltabbed_* | cut -d ' ' -f 1)"
echo "goto $@" > "$fifo"
cd -
