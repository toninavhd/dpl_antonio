#!/bin/bash

# Script de despliegue para TravelRoad (Laravel)
# Este script se conecta al servidor remoto y realiza el despliegue

ssh arkania "
  cd /var/www/travelroad_laravel
  git pull
  composer install --no-dev --optimize-autoloader
  php artisan migrate --force
  php artisan config:cache
  php artisan route:cache
"
