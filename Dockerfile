FROM serversideup/php:8.2-fpm-nginx

ENV PHP_OPCACHE_ENABLE=1

USER root

# Install Node.js and MySQL client
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash -
RUN apt-get update && apt-get install -y \
    nodejs \
    default-mysql-client

# Install PHP intl and exif extensions
RUN apt-get install -y \
    libicu-dev \
    libexif-dev \
    && docker-php-ext-install intl exif

COPY --chown=www-data:www-data . /var/www/html

USER www-data

RUN npm install
RUN npm run build

# Run Composer with --ignore-platform-req=ext-exif to avoid issues in case the extension is not required.
RUN composer install --no-interaction --optimize-autoloader



CMD ["/bin/sh", "-c", "/init && php-fpm -D && nginx -g 'daemon off;'"]