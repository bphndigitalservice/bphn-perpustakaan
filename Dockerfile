FROM webdevops/php-apache:8.1-alpine

# Install dependencies
RUN apk update && \
    apk add --no-cache \
    freetype-dev \
    jpeg-dev \
    libpng-dev \
    icu-dev \
    libxml2-dev \
    libzip-dev \
    gettext-dev \
    unzip \
    git \
    mariadb-client \
    ca-certificates

# Install PHP extensions
# Alpine needs additional dependencies for some PHP extensions
RUN apk add --no-cache oniguruma-dev && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) \
    gd \
    gettext \
    mysqli \
    pdo_mysql \
    intl \
    xml \
    zip \
    mbstring

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Enable Apache modules in Alpine
RUN sed -i 's/#LoadModule rewrite_module/LoadModule rewrite_module/' /etc/apache2/httpd.conf && \
    sed -i 's/#LoadModule headers_module/LoadModule headers_module/' /etc/apache2/httpd.conf && \
    # Enable .htaccess files
    sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/httpd.conf

# Set working directory
WORKDIR /app

# Copy application files
COPY . /app

# Install PHP dependencies with Composer
RUN composer install --no-interaction --no-dev --optimize-autoloader

# Set initial permissions - will be updated by entrypoint script for mounted volumes
RUN chown -R apache:apache /app \
    && find /app -type d -exec chmod 755 {} \; \
    && find /app -type f -exec chmod 644 {} \;


# Expose port 80
EXPOSE 80 443
