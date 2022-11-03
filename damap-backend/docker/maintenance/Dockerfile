FROM nginx:1

COPY conf.d/ /etc/nginx/conf.d/
COPY data /data

# RUN chown -R nginx /etc/nginx && \
#     chown -R nginx /var/cache/nginx

## add permissions for nginx user
RUN chown -R nginx /var/cache/nginx && \
    chown -R nginx /var/log/nginx && \
    chown -R nginx /etc/nginx

RUN touch /var/run/nginx.pid && \
        chown -R nginx:nginx /var/run/nginx.pid

USER nginx
