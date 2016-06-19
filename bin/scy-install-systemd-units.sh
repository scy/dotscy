#!/bin/sh
set -e

fromdir="$HOME/res/systemd"
todir='/etc/systemd/system'

do_rsync() {
	cmd='rsync'
	if [ "$sudo" = 'y' ]; then
		cmd='sudo rsync'
	fi
	$cmd -rtli $1 --del --filter '+ /scy-*' --filter '- *' "$fromdir/" "$todir"
}

case "$1" in
	check|dry-run)
		lines="$(do_rsync -n | grep -v '^..\.\.t\.\{6\} ' || true)"
		if [ -n "$lines" ]; then
			echo 'The following changes need to be made to your systemd units (rsync -i output style):'
			echo
			echo "$lines"
			echo
			echo 'Run "scy-install-systemd-units.sh run" to install them.'
			exit 1
		fi
		exit 0
		;;
	run)
		sudo=y do_rsync -v
		sudo systemctl daemon-reload
		for unit in $(find "$todir" -maxdepth 1 -name 'scy-*' | sed -e 's/.*scy-/scy-/'); do
			sudo systemctl enable "$unit"
		done
		;;
	*)
		echo 'usage: scy-install-systemd-units.sh check|run' >&2
		exit 2
		;;
esac
