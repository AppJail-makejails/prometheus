#!/bin/sh

. /lib.subr

set -e

create_user

change_owner /prometheus

if [ "${1#-}" != "$1" ]; then
    set -- prometheus "$@"
fi

if [ "$1" = "prometheus" ]; then
    set -- su-exec noroot "$@"
fi

exec "$@"
