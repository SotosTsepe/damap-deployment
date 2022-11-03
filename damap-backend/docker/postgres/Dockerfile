FROM postgres:12

COPY docker-entrypoint-initdb.d /docker-entrypoint-initdb.d
COPY healthcheck.sh /usr/local/bin/healthcheck.sh

USER ${POSTGRES_USER}
