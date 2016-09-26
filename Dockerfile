FROM ubuntu:xenial

# Install packages
RUN apt-get update && \
    apt-get install -y \
      apache2 \
      libapache2-mod-php \
      php-xml \
      php7.0-mbstring \
      php7.0-sqlite \
      php7.0-curl \
      curl \
      nodejs-legacy \
      npm \
      sqlite3 \
      git \
      zip \
      unzip

RUN rm -Rf /var/lib/apt/lists/*

WORKDIR /var/www/411
COPY . /var/www/411

# Override apache's default site with 411
RUN cp -a /var/www/411/docker/411.conf /etc/apache2/sites-available/000-default.conf
# Enable mod_headers, mod_rewrite
RUN a2enmod headers rewrite

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN npm install -g grunt-cli bower
RUN npm install
RUN bower install --allow-root
RUN composer install
RUN grunt prod

# setup the /data directory for easy mounting
RUN mkdir /data

# Overwrite the config file with our docker version
COPY docker/config.php /data/config.php
RUN ln -sf /data/config.php /var/www/411/config.php

COPY docker/startup.sh /startup.sh
CMD /startup.sh
