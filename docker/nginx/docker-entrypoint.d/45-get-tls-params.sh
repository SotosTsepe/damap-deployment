#!/bin/bash

DATA_PATH="/etc/letsencrypt"

if [ ! -e "$DATA_PATH/options-ssl-nginx.conf" ] || [ ! -e "$DATA_PATH/ssl-dhparams.pem" ]; then
  echo "45-get-tls-params.sh: info: Downloading recommended TLS parameters ..."
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf > "$DATA_PATH/options-ssl-nginx.conf"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem > "$DATA_PATH/ssl-dhparams.pem"
fi
