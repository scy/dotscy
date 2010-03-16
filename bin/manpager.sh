#!/bin/sh

# Redefine colors for less. Read more about this at:
# <http://nion.modprobe.de/blog/archives/569-colored-manpages.html>
export LESS_TERMCAP_mb='[01;31m'
export LESS_TERMCAP_md='[01;32m'
export LESS_TERMCAP_me='[0m'
export LESS_TERMCAP_se='[0m'
export LESS_TERMCAP_so='[01;44;33m'
export LESS_TERMCAP_ue='[0m'
export LESS_TERMCAP_us='[01;36m'

exec "$PAGER"
