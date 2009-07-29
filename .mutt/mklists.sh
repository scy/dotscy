#!/bin/sh

(
echo "send-hook . 'unmy_hdr From:'"
while read line; do
	addr="$(echo "$line" | cut -f 1 | sed -e 's/ /@/')"
	domain="$(echo "$line" | cut -f 2)"
	lists="$(echo "$line" | cut -f 3)"
	listexpr="^($(echo "$lists" | sed -e 's/ /|/g'))@$(echo "$domain" | sed -e 's/\./\\./g')\$"
	echo "send-hook '~C \"$listexpr\"' \"my_hdr From: \$realname <$addr>\""
	echo "subscribe '$listexpr'"
	for list in $lists; do
		echo "alias $list $list@$domain"
	done
done < subscriptions
) > lists.rc
