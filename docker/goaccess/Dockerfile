FROM allinurl/goaccess:1.6.5

COPY exclude_routes.txt /etc/goaccess/exclude_routes.txt
COPY docker-entrypoint.sh /

ENTRYPOINT ["/bin/sh", "/docker-entrypoint.sh"]
