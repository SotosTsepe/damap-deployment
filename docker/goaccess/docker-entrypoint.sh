#!/bin/sh

# Custom docker entrypoint for goaccess container.
# It continuously reads the access.log file from nginx while excluding
# routes provided and feeds those lines to the goaccess command.

tail -f -n +0 /srv/logs/access.log | \
grep -v -f /etc/goaccess/exclude_routes.txt | \
goaccess - \
    -o /srv/report/report.html \
    --real-time-html \
    --log-format=COMBINED \
    --time-format='%H:%M:%S'\
    --date-format='%d/%b/%Y' \
    --db-path=/srv/data \
    --persist \
    --restore
