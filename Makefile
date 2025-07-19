.PHONY: help
help:
	@echo "Available commands:"
	@echo "  make setup       - Initial project setup"
	@echo "  make up          - Start containers"
	@echo "  make down        - Stop containers"
	@echo "  make restart     - Restart containers"
	@echo "  make logs        - View logs"
	@echo "  make shell       - Access app shell"
	@echo "  make test        - Run tests"
	@echo "  make fresh       - Fresh migration with seed"

setup:
ifeq ($(OS),Windows_NT)
	powershell -ExecutionPolicy Bypass -File setup-windows.ps1
else
	chmod +x setup.sh
	./setup.sh
endif

up:
	docker-compose up -d

down:
	docker-compose down

restart:
	docker-compose restart

logs:
	docker-compose logs -f app

shell:
	docker-compose exec app sh

shell-root:
	docker-compose exec -u root app sh

composer-install:
	docker-compose exec app su-exec www-data composer install

npm-install:
	docker-compose exec app su-exec www-data npm install

npm-dev:
	docker-compose exec app su-exec www-data npm run dev

npm-build:
	docker-compose exec app su-exec www-data npm run build

migrate:
	docker-compose exec app su-exec www-data php artisan migrate

fresh:
	docker-compose exec app su-exec www-data php artisan migrate:fresh --seed

test:
	docker-compose exec app su-exec www-data php artisan test

fix-permissions:
	docker-compose exec -u root app chown -R www-data:www-data /app
	docker-compose exec -u root app chmod -R 755 /app
	docker-compose exec -u root app chmod -R 777 /app/storage /app/bootstrap/cache

clear-cache:
	docker-compose exec app su-exec www-data php artisan cache:clear
	docker-compose exec app su-exec www-data php artisan config:clear
	docker-compose exec app su-exec www-data php artisan route:clear
	docker-compose exec app su-exec www-data php artisan view:clear
