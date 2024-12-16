# Use the PHP 8.2 image
FROM php:8.2-fpm

# Install system dependencies and libraries required for PHP and Laravel
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    git \
    unzip \
    curl \
    gnupg \
    ca-certificates

# Install Node.js and npm
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the application files
COPY . /var/www

# Set working directory
WORKDIR /var/www

# Install PHP extensions required by Laravel
RUN docker-php-ext-configure zip
RUN docker-php-ext-install zip

# Install Laravel PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Install Node.js dependencies (npm)
RUN npm install && npm run prod

# Expose port and run server
EXPOSE 80
CMD ["php-fpm"]
