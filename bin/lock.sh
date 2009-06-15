#!/bin/sh

killall -SIGHUP gpg-agent 2>/dev/null
xscreensaver-command -lock >/dev/null
