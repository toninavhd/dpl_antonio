#!/bin/bash

cd /home/toni/Documentos/dpl_antonio/ut4/a3/travelroad_laravel
git pull
composer install --no-dev --optimize-autoloader
php artisan config:cache
php artisan route:cache
php artisan view:cache
sudo systemctl reload nginx