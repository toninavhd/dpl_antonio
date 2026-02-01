#!/bin/bash

# TravelRoad Laravel Deployment Script
# This script deploys the Laravel application to a production server

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Starting TravelRoad Laravel deployment...${NC}"

# Server configuration
SERVER_HOST="${SERVER_HOST:-dplprod_antonio@10.102.19.40}"

# ⚠️ CORRECCIÓN IMPORTANTE: Define la ruta del proyecto en el SERVIDOR REMOTO, no la local.
# Ajusta esta ruta si tu proyecto en producción está en otro lugar.
REMOTE_PROJECT_DIR="/home/dplprod_antonio/dpl_antonio/ut4/a3/travelroad_laravel" 

echo -e "${YELLOW}📦 Connecting to server: $SERVER_HOST${NC}"

# Deploy to server via SSH
# Nota: Usamos comillas dobles "..." para el bloque SSH para que las variables locales se expandan si es necesario,
# pero usamos comillas simples '...' dentro donde queramos evitar expansiones prematuras.
ssh "$SERVER_HOST" "
  set -e
  
  echo -e '${GREEN}📂 Navigating to project directory: $REMOTE_PROJECT_DIR${NC}'
  cd '$REMOTE_PROJECT_DIR' || exit 1
  
  echo -e '${GREEN}🔄 Pulling latest changes from Git...${NC}'
  git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || echo 'No specific branch pulled or already up to date'
  
  echo -e '${GREEN}📦 Installing Composer dependencies...${NC}'
  # Aseguramos que composer use el composer.json del directorio actual
  composer install --no-dev --optimize-autoloader
  
  echo -e '${GREEN}🔄 Running database migrations...${NC}'
  php artisan migrate --force
  
  echo -e '${GREEN}🗃️ Clearing and caching configuration...${NC}'
  # IMPORTANT: Delete ALL cached files first to ensure .env changes are picked up
  rm -f bootstrap/cache/config.php bootstrap/cache/packages.php bootstrap/cache/services.php
  php artisan config:clear
  php artisan cache:clear
  php artisan route:clear
  php artisan view:clear
  
  echo -e '${GREEN}⚡ Optimizing application...${NC}'
  php artisan optimize
  
  echo -e '${GREEN}🔄 Reloading PHP-FPM...${NC}'
  # A veces es necesario recargar nginx también si la config cambió
  sudo systemctl reload php8.4-fpm 2>/dev/null || sudo systemctl reload php-fpm 2>/dev/null || echo 'PHP-FPM reload skipped (maybe permission issue or service name diff)'
  
  echo -e '${GREEN}✅ Deployment completed successfully!${NC}'
"

echo -e "${GREEN}🎉 All done! The application has been deployed.${NC}"