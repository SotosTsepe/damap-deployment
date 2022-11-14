FROM nginx:1

COPY docker-entrypoint.d /docker-entrypoint.d/
COPY nginx.conf /etc/nginx/nginx.conf

RUN chmod -R a+x docker-entrypoint.d
