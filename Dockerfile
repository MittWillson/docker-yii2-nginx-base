FROM webdevops/php-nginx:alpine-php7
MAINTAINER Mitt <MittWillson@icloud.com>

WORKDIR /www

ONBUILD ADD composer.json composer.lock ./

ONBUILD RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com \
  && composer global require fxp/composer-asset-plugin \
  && composer install

# Source Code
ONBUILD COPY . .
