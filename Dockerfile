# Use the PHP 8.2 image
FROM php:8.2-fpm

# Install necessary dependencies
RUN apt-get update && apt-get install -y libzip-dev libpng-dev libjpeg-dev libfreetype6-dev git unzip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the application files
COPY . /var/www

# Set working directory
WORKDIR /var/www

# Install PHP extensions required by Laravel
RUN docker-php-ext-configure zip
RUN docker-php-ext-install zip

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader

# Run npm
RUN npm install && npm run prod

# Expose port and run server
EXPOSE 80
CMD ["php-fpm"]
