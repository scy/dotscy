#!/bin/sh

# Copyright (c) 2007 Tim Weber <scy-proj-scytools@scytale.de>

PORTAGE="/usr/portage"

status() {
	echo -n "$1... "
}

ok() {
	echo "ok"
}

die() {
	echo "$1" >&2
	exit 1
}

BIN="$1"
if [[ ! -e "$BIN" ]]; then
	die "File $BIN does not exist."
fi

DATE="$(date -d "$2" +%s)"
if [[ -z "$DATE" ]]; then
	die "Invalid date '$2'."
fi

status "Getting libraries in $BIN"
LIBS="$(ldd "$BIN" | grep -Eo ' => /[^ ]+' | cut -d ' ' -f 3)"
if [[ -z "$LIBS" ]]; then
	die "No libs used? Is $BIN a script?"
fi
ok

status "Getting packages for each library"
PACKS="$(echo -n '('; for LIB in $LIBS; do
	SPEC="$(equery -q -C b "$LIB" | cut -d ' ' -f 1)"
	FULLSPEC="$SPEC"
	while [[ ! -d "$PORTAGE/$SPEC" ]]; do
		SPEC="$(echo "$SPEC" | sed -r -e 's/-[^-]*$//')"
		if [[ "$(echo "$SPEC" | grep -c -)" -eq 0 ]]; then
			die "Cannot find package for $FULLSPEC, please add a directory for it in $PORTAGE"
		fi
	done
	echo "$SPEC"
done | sort | uniq | tr '\n' '|' | sed -e 's/|$/)/')"
ok

status "Finding all merges of those packages $PACKS"
TIMES="$(grep -E ">>> emerge \\([0-9]+ of [0-9]+\\) ${PACKS}-[^ ]+ to /" /var/log/emerge.log | cut -d : -f 1)"
ok

echo "Possible culprits (merged after $(date -d "@$DATE")):"
for TIME in $TIMES; do
	if [[ "$TIME" -ge "$DATE" ]]; then
		echo "  $(grep -E "${TIME}: +>>> emerge \\([0-9]+ of [0-9]+\\) ${PACKS}-[^ ]+ to /" /var/log/emerge.log | grep -Eo "${PACKS}-[^ ]+") (merged $(date -d "@$TIME") ($TIME))"
	fi
done
