#!/bin/sh

LNBASE=".$USER"
OUTDIR="$HOME"
TPLDIR="$OUTDIR/$LNBASE"

if [ "$(sed --version 2>&1 | cut -b 3)" = 'GNU' ]; then
	ESED='sed -r'
else
	ESED='sed -E'
fi

# Which files to ignore when copying over to $OUTDIR.
SEDCMD='s/^(\.git|\.gitignore|\.scy|dotfiles\.sh|res|[^/]\{1,\}\.(txt|ini|bat))$//'

# Formatted death.
die() {
	echo dotfiles.sh: "$1" >&2
	exit 1
}

cd "$TPLDIR" || die "could not change to template directory '$TPLDIR'"

find . -maxdepth 1 | cut -b 3- | $ESED -e "$SEDCMD" | while read ITEM; do
	if [ -n "$ITEM" ]; then
		LNTARGET="$LNBASE/$ITEM" # Where to link to.
		# If the destination already exists and is no symlink, remove it.
		[ -e "$OUTDIR/$ITEM" -a \( ! -L "$OUTDIR/$ITEM" \) ] && rm -rf "$OUTDIR/$ITEM"
		if [ -L "$ITEM" ]; then
			# If template is a symlink itself, copy instead of linking to link.
			cp -Pa "$ITEM" "$OUTDIR"
		else
			ln -sf "$LNTARGET" "$OUTDIR/$ITEM"
		fi
	fi
done
