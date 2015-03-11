#!/bin/bash

WORK_DIRECTORY=/var/www
ASSETS_DIRECTORY=/assets
BIN_DIRECTORY=/bin/toran-proxy

# Initilisation
source $BIN_DIRECTORY/init.sh

# Start PHP-FPM
echo "Starting PHP-FPM..."
php5-fpm -R

# Start Cron
if [ "$TORAN_INIT" == "false" ]; then
    echo "Starting Cron..."
    php $WORK_DIRECTORY/bin/cron -v
fi

# Start Nginx
echo "Starting Nginx..."
nginx -c /etc/nginx/nginx.conf