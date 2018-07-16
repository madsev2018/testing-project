################################################################################
# Base image
################################################################################

FROM alexcheng/magento2
# php:7.1.19-apache

################################################################################
# Build instructions
################################################################################

RUN apt-get update && apt-get install -y \
    curl \
    git \
    libicu-dev \
    libgmp-dev \
    libmagickwand-dev \
    libmagickcore-dev \
    libpng-dev \
    libssl-dev \
    libxslt-dev \
    libxml2-dev \
    locales \
    supervisor \
    unzip \
    vim \
    wget \
    libmcrypt-dev

# RUN curl -fsS -o /tmp/icu.tgz -L http://download.icu-project.org/files/icu4c/60.2/icu4c-60_2-src.tgz \
#    && tar -zxf /tmp/icu.tgz -C /tmp \
#    && cd /tmp/icu/source \
#    && ./configure --prefix=/usr/local \
#    && make \
#    && make install \
#    && rm -rf /tmp/icu*

# RUN pecl install apcu imagick opcache \
#    && docker-php-ext-enable apcu imagick opcache

# RUN docker-php-ext-configure intl --with-icu-dir=/usr/local \
#    && docker-php-ext-install gmp intl mbstring pdo_mysql zip bcmath soap mcrypt xsl gd

# RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz \
#     && tar xJf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz \
#     && rm -Rf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz \
#     && mv wkhtmltox/bin/wkhtmltoimage /usr/bin/wkhtmltoimage \
#     && chmod +x /usr/bin/wkhtmltoimage \
#     && rm -Rf wkhtmltox

############################################################################# ###
# Install composer
################################################################################

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod a+x /usr/local/bin/composer

################################################################################
# PHPUnit
################################################################################

RUN wget https://phar.phpunit.de/phpunit-7.0.phar \
    && chmod +x phpunit-7.0.phar \
    && mv phpunit-7.0.phar /usr/local/bin/phpunit \
    && phpunit --version
RUN pear install PHP_CodeSniffer

################################################################################
# Rewrite apache
################################################################################

RUN a2enmod rewrite

################################################################################
# Configurations
################################################################################

COPY ./docker/php.ini /usr/local/etc/php/conf.d/
COPY ./docker/supervisord.conf /etc/supervisor/conf.d/
COPY ./docker/vhost.conf /etc/apache2/sites-enabled/000-default.conf

################################################################################
# Application
################################################################################

COPY . /var/www/wise-ecommerce
WORKDIR /var/www/wise-ecommerce

################################################################################
# Entrypoint
################################################################################

COPY ./docker/entrypoint.sh /
RUN chmod 777 -Rf /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
