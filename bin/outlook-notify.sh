#!/bin/sh

maildir="$1"
shift

inbox="$maildir/INBOX"

set >/tmp/outlook-notify.log

if ! [ -d "$inbox/new" ]; then
	exit 1
fi

unread="$(find "$inbox/new" -type f | wc -l)"

if [ "$unread" -gt 0 ]; then
	plural=''
	[ "$unread" -gt 1 ] && plural='s'
	DISPLAY=:0 notify-send -h 'string:bgcolor:#5f9f42' -h 'string:fgcolor:#ffffff' 'Outlook 365' "$unread unread message$plural"
fi
