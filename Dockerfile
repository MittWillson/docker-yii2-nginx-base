FROM webdevops/php-nginx:7.2
MAINTAINER Mitt <MittWillson@icloud.com>

# 暂时不支持 ipv6
ENV PHP_EXTRA_CONFIGURE_ARGS="$(PHP_EXTRA_CONFIGURE_ARGS) --ipv6=false"

RUN apt-get update && apt-get install -y libz-dev libicu-dev g++

RUN apt-get install -y libcurl3-dev libgmp-dev libpq-dev \
		libmcrypt-dev \
 && docker-php-ext-configure gmp \
 && docker-php-ext-install -j$(nproc) mysqli pdo pdo_mysql pdo_pgsql zip opcache exif gmp

# Install GD
RUN apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev libpng16-16 zlib1g-dev
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ --with-zlib-dir=/usr \
    && docker-php-ext-install gd

RUN docker-php-ext-configure intl \
 && docker-php-ext-install intl

RUN apt-get install -y git

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Clean
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /www

ONBUILD ADD composer.json composer.lock ./

ONBUILD RUN composer install

# Source Code
ONBUILD COPY . .
