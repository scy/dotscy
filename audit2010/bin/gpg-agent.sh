#!/bin/sh

debug() {
	echo "$@" >&2
}

INFOFILE="$HOME/.gnupg/gpg-agent-info-$HOSTNAME"

# Do we have gpg-agent at all? If not, all of this is nonsense.
if ! which gpg-agent >/dev/null 2>&1; then
	debug "No gpg-agent on this system."
	exit
fi

# If we have no agent info in the current shell, then maybe the agent
# was started in a sibling shell. Use the env file.
if [ -z "$GPG_AGENT_INFO" ]; then
	if [ -r "$INFOFILE" ]; then
		debug "Reading $INFOFILE."
		source "$INFOFILE" 2>/dev/null
	else
		debug "No info environment, no info file."
	fi
fi

# If we now have an agent info, check whether it is scratc^Wstale.
if [ -n "$GPG_AGENT_INFO" ]; then
	pid="$(echo "$GPG_AGENT_INFO" | cut -d : -f 2)"
	debug "Checking whether agent[$pid] is alive."
	# If this process is not owned by us or does no exist, it cannot be an agent.
	if [ "$(stat -c %U "/proc/$pid" 2>/dev/null)" != "$USER" ]; then
		debug "Process $pid does not exist or not belong to me."
		GPG_AGENT_INFO=''
	else
		# Make sure the process is actually an agent.
		if [ "$(basename "$(readlink "/proc/$pid/exe" 2>/dev/null)")" != 'gpg-agent' ]; then
			debug "Process $pid is not an agent."
			GPG_AGENT_INFO=''
		fi
	fi
fi

# If, after all these checks, we have no agent info, we need to start one.
if [ -z "$GPG_AGENT_INFO" ]; then
	debug "Launching a new agent."
	eval gpg-agent --daemon --write-env-file "$INFOFILE"
else
	debug "Keeping existing agent."
fi

# Export settings.
for var in GPG_AGENT_INFO SSH_AUTH_SOCK SSH_AGENT_PID; do
	echo "$var=${!var}"
	echo "export $var"
	export "$var"
done
