FROM nginx:1

COPY nginx/docker-entrypoint.d /docker-entrypoint.d/
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/templates /etc/nginx/templates/
COPY ssl /etc/nginx/ssl

RUN chmod -R a+x docker-entrypoint.d
