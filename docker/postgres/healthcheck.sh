#!/bin/bash
#
# NOTE: this script is based on the postgres docker-healthcheck from docker-library:
# https://github.com/docker-library/healthcheck/blob/master/postgres/docker-healthcheck

set -euo pipefail

host="127.0.0.1"
user="${POSTGRES_NON_ROOT_USER:-${POSTGRES_USER}}"
db="${POSTGRES_DB:-${user}}"
export PGPASSWORD="${POSTGRES_NON_ROOT_PASSWORD:-${POSTGRES_PASSWORD}}"

args=(
	# force postgres to not use the local unix socket (test "external" connectibility)
	--host "$host"
	--username "$user"
	--dbname "$db"
	--quiet --no-align --tuples-only
)

if select="$(echo 'SELECT 1' | psql "${args[@]}")" && [ "$select" = '1' ]; then
	exit 0
fi

exit 1
