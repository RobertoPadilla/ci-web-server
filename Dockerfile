FROM php:8.1-apache

# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Init server config
RUN apt update

# Installing dependencies for codeigniter 4
RUN apt install unzip &&\
  apt-get install libicu-dev -y &&\
  docker-php-ext-configure intl -q &&\
  docker-php-ext-install intl opcache

# Changing owner
RUN useradd -ms /bin/bash apache
USER apache

# Changing DocumentRoot
WORKDIR /var/www/app
COPY conf/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY conf/opcache.ini $PHP_INI_DIR/conf.d/opcache.ini
COPY . /var/www/app
RUN apachectl restart


COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer