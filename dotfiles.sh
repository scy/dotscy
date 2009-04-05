#!/bin/sh

LNBASE=".$USER"
OUTDIR="$HOME"
TPLDIR="$OUTDIR/$LNBASE"

# Which files to ignore when copying over to $OUTDIR.
SEDCMD="s/^(\.git|\.scy|dotfiles.sh|bin|res|[^/]+\.(txt|ini|bat))$//"

# Formatted death.
die() {
	echo dotfiles.sh: "$1" >&2
	exit 1
}

cd "$TPLDIR" || die "could not change to template directory '$TPLDIR'"

find . -maxdepth 1 | grep -v '^\.$' | cut -d / -f 2- | sed -r -e "$SEDCMD" | while read ITEM; do
	if [[ ! -z "$ITEM" ]]; then
		LNTARGET="$LNBASE/$ITEM" # Where to link to.
		if [[ -L "$ITEM" ]]; then
			# If template is a symlink itself, copy instead of linking to link.
			cp -uPa "$ITEM" "$OUTDIR"
		elif [[ ( ! -L "$OUTDIR/$ITEM" ) || ( "$(stat -c %Y "$OUTDIR/$ITEM" 2>/dev/null)" -lt "$(stat -c %Y "$ITEM")" ) ]]; then
			# If target doesn't exist as symlink or is out-of-date, link it.
			ln -sfT "$LNTARGET" "$OUTDIR/$ITEM"
		fi
	fi
done
