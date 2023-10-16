
FROM php:7.0.33-apache

RUN apt-get update \
    && docker-php-ext-install pdo pdo_mysql \
    && docker-php-ext-enable pdo_mysql

RUN a2enmod rewrite

RUN pecl install xdebug-2.9.8 && if [ "$XDEBUG_ENABLE" = "1" ] ; then docker-php-ext-enable xdebug ; fi

RUN pecl install mongodb && docker-php-ext-enable mongodb

WORKDIR /var/www/html

COPY /home/ec2-user/php/index.php .

EXPOSE 80

CMD ["apache2-foreground"]