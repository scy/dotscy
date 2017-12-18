#!/bin/sh
set -e

destdir="$HOME/IntelliJ"

if [ "$#" -ne 1 ]; then
	echo 'Please supply the .tar.gz filename as the first parameter.' >&2
	exit 1
fi

tarball="$1"; shift

echo 'Detecting version...'
version="$(tar tzvf "$tarball" | head -n 1 | awk '{ print $6 }' | cut -d / -f 1)"

if [ -z "$version" ]; then
	echo 'Could not detect version.' >&2
	exit 2
fi

echo "Version detected: $version"

mkdir -p "$destdir"

echo "Extracting..."

tar xz -C "$destdir" -f "$tarball"

echo "Linking $version to $destdir/preferred..."

ln -sf "$version" "$destdir/preferred"

echo "All done. Run 'IDE' to start it."
