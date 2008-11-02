#!/bin/bash

while true; do
	if [[ "$(lpq -P FS-3700+ | tail -n +2 | head -n 1)" != 'no entries' ]]; then
		/usr/local/bin/fhem set printer on-for-timer 320 &>/dev/null
		sleep 25
	fi
	sleep 5
done

