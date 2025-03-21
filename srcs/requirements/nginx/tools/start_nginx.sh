#!/bin/bash

envsubst '${DOMAIN_NAME}' < /etc/nginx/conf.d/default.conf > /etc/nginx/conf.d/default.tmp
mv /etc/nginx/conf.d/default.tmp /etc/nginx/conf.d/default.conf

exec nginx -g "daemon off;"