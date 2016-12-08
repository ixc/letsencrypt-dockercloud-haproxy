#!/bin/bash

set -e

install-certs.sh
watch-certs.sh &

LETSENCRYPT_CERT="$(cat /certs/letsencrypt0.pem)"
export DEFAULT_SSL_CERT="${DEFAULT_SSL_CERT:-$LETSENCRYPT_CERT}"

exec "$@"
