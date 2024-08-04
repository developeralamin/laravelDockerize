# Install php from php official website
FROM php:8.2-apache

# Linux Library
RUN apt-get update -y && apt-get install -y \
    libicu-dev \
    libmariadb-dev \
    unzip zip \
    zlib1g-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev 

# Mod Rewrite
RUN a2enmod rewrite

# Composer create project
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer


WORKDIR /var/www/html

# Copy Apache virtual host configuration
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

# PHP Extension
RUN docker-php-ext-install gettext intl pdo_mysql gd

RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
