FROM dunglas/frankenphp:latest-php8.3-alpine

# Install system dependencies
RUN apk add --no-cache \
    postgresql-dev \
    nodejs \
    npm \
    git \
    zip \
    unzip \
    curl \
    bash

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install PHP extensions
RUN install-php-extensions \
    pdo_pgsql \
    redis \
    opcache \
    intl \
    exif \
    gd \
    zip

# Set working directory
WORKDIR /app

# Copy composer files first for better caching
COPY composer.json composer.lock ./

# Install PHP dependencies
RUN composer install --no-scripts --no-autoloader --no-dev --prefer-dist

# Copy package files for npm
COPY package*.json ./

# Install npm dependencies (if you have any)
RUN if [ -f "package.json" ]; then npm ci --only=production; fi

# Copy application code
COPY . .

# Generate optimized autoloader
RUN composer dump-autoload --optimize --no-dev

# Build frontend assets (if using Vite/Mix)
RUN if [ -f "package.json" ]; then npm run build; fi

# Create necessary directories and set permissions
RUN mkdir -p /app/storage/logs \
    && mkdir -p /app/storage/framework/cache \
    && mkdir -p /app/storage/framework/sessions \
    && mkdir -p /app/storage/framework/views \
    && mkdir -p /app/bootstrap/cache \
    && chown -R www-data:www-data /app/storage /app/bootstrap/cache \
    && chmod -R 775 /app/storage /app/bootstrap/cache

# Copy Caddy configuration
COPY Caddyfile /etc/caddy/Caddyfile

# Expose ports
EXPOSE 80 443

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/health || exit 1

# Run FrankenPHP
CMD ["frankenphp", "run", "--config", "/etc/caddy/Caddyfile"]
