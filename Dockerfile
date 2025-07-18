FROM dunglas/frankenphp

ENV SERVER_NAME=":80"

WORKDIR /app

COPY . /app

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN apt-get update && apt-get install -y libzip-dev && \
    docker-php-ext-install zip && \
    docker-php-ext-enable zip

RUN composer install
