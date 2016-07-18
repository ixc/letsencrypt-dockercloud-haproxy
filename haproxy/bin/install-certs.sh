#!/bin/bash

set -e

mkdir -p "$CERT_FOLDER"
mkdir -p "$LIVE_CERT_FOLDER"

# Create a self signed default certificate, so HAproxy can start before we have
# any real certificates.
if [[ ! -f "$CERT_FOLDER/cert0.pem" ]]; then
	openssl req -x509 -newkey rsa:2048 -keyout key.pem -out ca.pem -days 90 -nodes -subj '/CN=*/O=My Company Name LTD./C=US'
	cat key.pem ca.pem > "$CERT_FOLDER/cert0.pem"
	rm key.pem ca.pem
fi

# Install combined certificates for HAproxy.
if [[ -n "$(ls -A $LIVE_CERT_FOLDER)" ]]; then
	COUNT=0
	for DIR in "$LIVE_CERT_FOLDER"/*; do
		cat "$DIR/privkey.pem" "$DIR/fullchain.pem" > "$CERT_FOLDER/cert$COUNT.pem"
		(( COUNT += 1 ))
	done
fi
