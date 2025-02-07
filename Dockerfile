FROM php:8.3-fpm-alpine

RUN apk add --no-cache $PHPIZE_DEPS \
    imagemagick-dev icu-dev zlib-dev libpq-dev jpeg-dev libpng-dev libzip-dev libgomp linux-headers; \
    docker-php-ext-configure gd --with-jpeg; \
    docker-php-ext-install intl pcntl gd exif zip mysqli pgsql pdo pdo_mysql pdo_pgsql bcmath opcache; \
    pecl install xdebug; \
    docker-php-ext-enable xdebug; \
    echo "xdebug.mode=coverage" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    echo "xdebug.client_port=9003" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    pecl install imagick; \
    docker-php-ext-enable imagick; \
    apk del $PHPIZE_DEPS; \
    rm -rf /tmp/pear;

# Install other dependencies
RUN apk add --no-cache curl nano && \
    apk update  && \
    apk add mysql-client && \
    apk add --no-cache libssh2-dev autoconf build-base && \
    pecl install ssh2-1.3.1 && docker-php-ext-enable ssh2 && \
    apk add --no-cache openssl-dev

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

COPY ./ /app

WORKDIR /app

EXPOSE 9000
