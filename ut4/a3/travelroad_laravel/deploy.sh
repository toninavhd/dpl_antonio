#!/bin/bash

cd ~/travelroad_laravel
git pull
composer install --no-dev --optimize-autoloader
php artisan config:cache
php artisan route:cache
php artisan view:cache
sudo systemctl reload nginx