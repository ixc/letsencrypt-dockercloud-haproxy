#!/bin/bash

# See: https://github.com/tartley/rerun2

set -e

mkdir -p "$LIVE_CERT_FOLDER"

# Abort, if already running.
if [[ -n "$(ps | grep inotifywait | grep -v grep)" ]]; then
	echo "Already watching directory: $LIVE_CERT_FOLDER" >&2
	exit 1
fi

# Debounce for 60 seconds, which we assume is enough time to create or renew
# all certifies and avoid multiple restarts.
IGNORE_SECS=60
IGNORE_UNTIL="$(date +%s)"

# Watch the live certificates directory. When changes are detected, install
# combined certificates and reload HAproxy.
echo "Watching directory: $LIVE_CERT_FOLDER"
inotifywait \
	--event create \
	--event delete \
	--event modify \
	--event move \
	--format "%e %w%f" \
	--monitor \
	--quiet \
	--recursive \
	"$LIVE_CERT_FOLDER" |
while read CHANGED
do
	echo "$CHANGED"
	NOW="$(date +%s)"
	if (( NOW > IGNORE_UNTIL )); then
		(( IGNORE_UNTIL = NOW + IGNORE_SECS ))
		(sleep $IGNORE_SECS; install-certs.sh; /reload.sh) &
	fi
done
