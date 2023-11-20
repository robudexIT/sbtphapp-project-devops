FROM php:7.2-apache

RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable pdo_mysql

WORKDIR /var/www/html

COPY   .   /var/www/html/

RUN chown -R www-data:www-data ./sbtph_api/
