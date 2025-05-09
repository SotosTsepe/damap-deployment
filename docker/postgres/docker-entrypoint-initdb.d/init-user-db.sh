#!/bin/bash

set -eu

function create_user_and_database() {
	local database=$1
	echo "Creating user and database '$database'."
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
	    CREATE USER $database WITH PASSWORD '$database';
	    CREATE DATABASE $database;
	    GRANT ALL PRIVILEGES ON DATABASE $database TO $database;
	    \c $database
	    ALTER SCHEMA public OWNER TO $database;
	    GRANT ALL PRIVILEGES ON SCHEMA public TO $database;
EOSQL
}

if [ -n "$POSTGRES_EXTRA_DBS" ]; then
	echo "Multiple database creation requested: $POSTGRES_EXTRA_DBS"
	for db in $(echo $POSTGRES_EXTRA_DBS | tr ',' ' '); do
		create_user_and_database $db
	done
	echo "Multiple databases created."
fi
