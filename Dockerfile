# Use an official PHP runtime as a parent image
FROM php:8.1-fpm

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev zip git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy the existing application directory contents
COPY . /var/www

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader
RUN npm install && npm run prod

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
