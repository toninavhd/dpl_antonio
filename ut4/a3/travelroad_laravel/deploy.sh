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
PROJECT_DIR="$(dirname "$0")"

# Navigate to project directory
cd "$PROJECT_DIR"

echo -e "${YELLOW}📦 Connecting to server: $SERVER_HOST${NC}"

# Deploy to server via SSH
ssh "$SERVER_HOST" "
  set -e
  
  echo -e '${GREEN}📂 Navigating to project directory...${NC}'
  cd $PROJECT_DIR
  
  echo -e '${GREEN}🔄 Pulling latest changes from Git...${NC}'
  git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || echo 'No git changes to pull'
  
  echo -e '${GREEN}📦 Installing Composer dependencies...${NC}'
  composer install --no-dev --optimize-autoloader
  
  echo -e '${GREEN}🔄 Running database migrations...${NC}'
  php artisan migrate --force
  
  echo -e '${GREEN}🗃️ Clearing and caching configuration...${NC}'
  php artisan config:clear
  php artisan cache:clear
  php artisan route:clear
  php artisan view:clear
  
  echo -e '${GREEN}⚡ Optimizing application...${NC}'
  php artisan optimize
  
  echo -e '${GREEN}🔄 Reloading PHP-FPM...${NC}'
  sudo systemctl reload php8.4-fpm 2>/dev/null || sudo systemctl reload php-fpm 2>/dev/null || echo 'PHP-FPM reload skipped'
  
  echo -e '${GREEN}✅ Deployment completed successfully!${NC}'
"

echo -e "${GREEN}🎉 All done! The application has been deployed.${NC}"

