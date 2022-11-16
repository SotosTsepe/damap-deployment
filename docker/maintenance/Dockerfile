FROM nginx:1

COPY maintenance/templates /etc/nginx/templates/
COPY maintenance/data /data
COPY ssl /etc/nginx/ssl

## add permissions for nginx user
RUN chown -R nginx /var/cache/nginx && \
    chown -R nginx /var/log/nginx && \
    chown -R nginx /etc/nginx

RUN touch /var/run/nginx.pid && \
        chown -R nginx:nginx /var/run/nginx.pid

USER nginx
