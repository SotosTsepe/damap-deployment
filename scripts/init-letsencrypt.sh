#!/bin/bash
#
# This script must be run only once to receive a Let's Encrypt certificate.
# Afterwards, the new certificates will be requested automatically.
#
# Usage: ./init-letsencrypt.sh domains="example.org www.example.org example.net" staging=0 [email="user@example.com"]


# bash strict mode
set -euo pipefail

RSA_KEY_SIZE=4096
DATA_PATH="./docker/certbot"

# -------------------- #
# docker compose check #
# -------------------- #
if ! docker compose version &> /dev/null; then
    echo '[ERROR] docker compose (v2) is not installed.' >&2
    exit 1
fi

declare -A args

# Split args into key-value pairs
for arg in "$@"; do
    key="${arg%%=*}"
    value="${arg#*=}"
    args["$key"]="$value"
done

# --------------- #
# Variable checks #
# --------------- #

if [ -z "${args['domains']+set}" ] || [ -z "${args['staging']+set}" ]; then
    echo "[ERROR] 'domains' and 'staging' arguments are required."
    echo "Usage: $0 domains=<domains> staging=<staging_mode> [email=email]"
    exit 1
fi

domains="${args['domains']}"
staging="${args['staging']}"
email="${args['email']:-}"

# Check if at least one domain is provided
if [ -z "$domains" ]; then
    echo "[ERROR] At least one domain must be provided."
    exit 1
fi

# Check if the provided staging value is 0 or 1
if [ -z "$staging" ] || [[ ! "$staging" =~ ^[01]$ ]]; then
    echo "[ERROR] Invalid value for 'staging.' It must be 0 or 1."
    exit 1
fi

# Split the space-separated string of domains into an array
IFS=" " read -ra domains <<< "$domains"

if [ -d "$DATA_PATH/conf/live" ]; then
  read -p "[WARN] Existing data found for $domains. Continue and replace existing certificate? (y/N) " decision
  if [ "$decision" != "Y" ] && [ "$decision" != "y" ]; then
    exit
  fi
fi

echo "[INFO] Creating self-signed certificate for ${domains[*]} ..."
path="/etc/letsencrypt/live/$domains"
mkdir -p "$DATA_PATH/conf/live/$domains"

docker compose run --rm --entrypoint "\
  openssl req -x509 -nodes -newkey rsa:$RSA_KEY_SIZE -days 1 \
    -keyout '$path/privkey.pem' \
    -out '$path/fullchain.pem' \
    -subj '/CN=localhost'" certbot

echo "[INFO] Starting nginx ..."
docker compose up --force-recreate -d nginx

echo "[INFO] Deleting self-signed certificate for ${domains[*]} ..."
docker compose run --rm --entrypoint "\
  rm -Rf /etc/letsencrypt/live/$domains && \
  rm -Rf /etc/letsencrypt/archive/$domains && \
  rm -Rf /etc/letsencrypt/renewal/$domains.conf" certbot

echo "[INFO] Requesting Let's Encrypt certificate for ${domains[*]} ..."
# Join $domains to -d args
domain_args=""
for domain in "${domains[@]}"; do
  domain_args="$domain_args -d $domain"
done

# Select appropriate email arg
case "$email" in
  "") email_arg="--register-unsafely-without-email" ;;
  *) email_arg="--email $email" ;;
esac

# Enable staging mode if needed
staging_arg=""
if [ $staging != "0" ]; then staging_arg="--staging"; fi

docker compose run --rm --entrypoint "\
  certbot certonly --webroot -w /var/www/certbot \
    $staging_arg \
    $email_arg \
    $domain_args \
    --rsa-key-size $RSA_KEY_SIZE \
    --agree-tos \
    --force-renewal" certbot

echo "[INFO] Reloading nginx ..."
docker compose exec nginx nginx -s reload

echo "[INFO] Done."
