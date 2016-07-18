#!/bin/bash

set -e

install-certs.sh
watch-certs.sh &

exec "$@"
