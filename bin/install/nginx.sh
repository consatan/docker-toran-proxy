#!/bin/bash

# Logs
if [ ! -d "$WORK_DIRECTORY/logs" ]; then
    echo "Creating Nginx logs directory..."
    mkdir -p $WORK_DIRECTORY/logs
fi

# Vhosts
echo "Loading Nginx vhosts..."
rm -f /etc/nginx/sites-enabled/*
if [ "${TORAN_HTTPS}" == "true" ]; then

    echo "Loading HTTPS Certificates..."

    if [ ! -e "$WORK_DIRECTORY/certs/toran-proxy.key" ]; then
        echo "ERROR: "
        echo "  Please add toran-proxy.key in folder certs/"
        exit 1
    fi

    if [ ! -e "$WORK_DIRECTORY/certs/toran-proxy.crt" ]; then
        echo "ERROR: "
        echo "  Please add toran-proxy.crt in folder certs/"
        exit 1
    fi

    # Add certificates trusted
    ln -s $WORK_DIRECTORY/certs /usr/local/share/ca-certificates/toran-proxy
    update-ca-certificates

    ln -s /etc/nginx/sites-available/toran-proxy-https.conf /etc/nginx/sites-enabled/toran-proxy-https.conf
else
    ln -s /etc/nginx/sites-available/toran-proxy-http.conf /etc/nginx/sites-enabled/toran-proxy-http.conf
fi