FROM php:8.0.10-cli-alpine

ARG WWWGROUP 

ENV TZ=UTC

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apk update && apk upgrade
# Install dependencies
RUN apk add mariadb-client ca-certificates libpng-dev postgresql-dev libssh-dev zip libzip-dev libxml2-dev jpegoptim optipng pngquant gifsicle unzip git libxslt-dev curl rabbitmq-c-dev icu-dev oniguruma-dev  gmp-dev

RUN docker-php-ext-install zip opcache pdo_mysql pdo_pgsql mysqli mbstring bcmath sockets xsl exif gd intl gmp

RUN curl -L -o /usr/local/bin/pickle https://github.com/FriendsOfPHP/pickle/releases/latest/download/pickle.phar \
&& chmod +x /usr/local/bin/pickle

# Install extensions
RUN apk add --no-cache $PHPIZE_DEPS \
   && pickle install redis \
   && docker-php-ext-enable redis

WORKDIR /var/www

# Install composer
RUN curl -sS  https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php"]