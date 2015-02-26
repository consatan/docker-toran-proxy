FROM ubuntu:14.04
MAINTAINER dev@cedvan.com

# Install PHP and Nginx
RUN apt-get update -qq \
    && apt-get install -qqy \
        curl \
        ca-certificates \
        daemontools \
        php5-fpm \
        php5-json \
        php5-cli \
        php5-intl \
        php5-curl \
        nginx

# Configure PHP and Nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf \
    && sed -i "s/;date.timezone.*/date.timezone = Europe\/Paris/" /etc/php5/cli/php.ini \
    && rm -f /etc/nginx/sites-enabled/default \
    && rm -f /etc/nginx/sites-available/default

# Vhosts
COPY assets/vhosts /etc/nginx/sites-available

# Install Toran Proxy
RUN rm -rf /var/www \
    && curl -sL https://toranproxy.com/releases/toran-proxy-v1.1.1.tgz | tar xzC /tmp \
    && mv /tmp/toran /var/www \
    && chmod -R 777 /var/www/app/cache /var/www/app/logs

# Load Scripts bash
COPY assets/bin /bin/toran-proxy/
RUN chmod u+x /bin/toran-proxy/*
COPY assets/config/parameters.yml /var/www/app/config/parameters.yml

WORKDIR /var/www

EXPOSE 80
EXPOSE 443

CMD /bin/toran-proxy/launch.sh && php5-fpm -R && nginx -c /etc/nginx/nginx.conf