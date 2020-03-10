FROM webdevops/php-nginx:alpine-php7
MAINTAINER Mitt <MittWillson@icloud.com>

WORKDIR /www

ONBUILD ADD composer.json composer.lock ./

ONBUILD RUN composer install

# Source Code
ONBUILD COPY . .
