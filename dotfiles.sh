#!/bin/sh

TPLDIR="$HOME/.$USER"
LNBASE=".$USER"
OUTDIR="$HOME"
SEDCMD="s/^(\.git|dotfiles.sh|bin)$//"

die() {
	echo dotfiles.sh: "$1" >&2
	exit 1
}

cd "$TPLDIR" || die "could not change to template directory '$TPLDIR'"

find . -maxdepth 1 | grep -v '^\.$' | cut -d / -f 2- | sed -r -e "$SEDCMD" | while read ITEM; do
	if [[ ! -z "$ITEM" ]]; then
		LNTARGET="$LNBASE/$ITEM"
		if [[ -L "$ITEM" ]]; then
			# If template is symlink, copy instead of linking to link.
			cp -uPa "$ITEM" "$OUTDIR"
		elif [[ ( ! -L "$OUTDIR/$ITEM" ) || ( "$(stat -c %Y "$OUTDIR/$ITEM" 2>/dev/null)" -lt "$(stat -c %Y "$ITEM")" ) ]]; then
			# If target doesn't exist as symlink or is out-of-date, link it.
			ln -sfT "$LNTARGET" "$OUTDIR/$ITEM"
		fi
	fi
done
