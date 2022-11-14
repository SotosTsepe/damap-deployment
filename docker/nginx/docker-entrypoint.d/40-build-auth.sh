#!/bin/bash

USER="${HTTP_AUTH_USER}"
PASSWORD="${HTTP_AUTH_PASSWORD}"
FILE="/etc/nginx/.htpasswd"

if [[ ! -f "${FILE}" ]]; then
    touch ${FILE}
fi

if [[ $(grep --count "^${USER}" "${FILE}") -ge 1 ]]; then
    echo "40-build-auth.sh: info: Basic auth already set for user ${USER}. Skipping..."
    exit 0
fi

echo "${USER}:$(openssl passwd -apr1 ${PASSWORD})" >> ${FILE}
echo "40-build-auth.sh: info: Basic auth was successfully set for user ${USER}"
