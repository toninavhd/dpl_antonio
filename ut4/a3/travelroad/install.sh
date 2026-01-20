#!/bin/bash

# Script de instalación de dependencias para TravelRoad (Laravel)

set -e

echo "Instalando dependencias de Composer..."
composer install --no-interaction

echo "Generando clave de aplicación..."
php artisan key:generate --ansi

echo "Ejecutando migraciones..."
php artisan migrate --force

echo "Optimizando la aplicación..."
php artisan config:cache
php artisan route:cache

echo "Instalación completada correctamente."

