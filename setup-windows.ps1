# setup-windows.ps1
Write-Host "Setting up Laravel FrankenPHP project for Windows..." -ForegroundColor Green

# Stop containers if running
docker-compose down

# Remove old containers and volumes
docker-compose rm -f
docker volume prune -f

# Build fresh containers
docker-compose build --no-cache

# Start containers
docker-compose up -d

# Wait for containers to be ready
Start-Sleep -Seconds 5

# Fix permissions inside container
docker-compose exec -T app sh -c "chown -R www-data:www-data /app"

# Install composer dependencies
docker-compose exec -T app sh -c "su-exec www-data composer install"

# Install npm dependencies
docker-compose exec -T app sh -c "su-exec www-data npm install"

# Copy .env file
if (!(Test-Path ".env")) {
    Copy-Item ".env.example" ".env"
}

# Generate application key
docker-compose exec -T app sh -c "su-exec www-data php artisan key:generate"

# Run migrations
docker-compose exec -T app sh -c "su-exec www-data php artisan migrate --force"

Write-Host "Setup complete! Application running at http://localhost:8000" -ForegroundColor Green