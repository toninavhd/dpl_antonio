#!/bin/bash

# TravelRoad Laravel - Directory Structure Fix Script
# This script creates missing directories and sets proper permissions

set -e

echo "🔧 Fixing Laravel directory structure..."

PROJECT_DIR="$(dirname "$0")"
cd "$PROJECT_DIR"

# Create missing storage directories
echo "📁 Creating storage directories..."
mkdir -p storage/framework/cache
mkdir -p storage/framework/sessions
mkdir -p storage/framework/views
mkdir -p storage/logs
mkdir -p bootstrap/cache

# Set proper permissions
echo "🔐 Setting permissions..."
chmod -R 775 storage bootstrap/cache

# Create .gitkeep files to preserve directory structure
echo "📝 Creating .gitkeep files..."
touch storage/framework/cache/.gitkeep
touch storage/framework/sessions/.gitkeep
touch storage/framework/views/.gitkeep
touch storage/logs/.gitkeep
touch bootstrap/cache/.gitkeep

echo "✅ Directory structure fixed!"
echo ""
echo "Next steps to resolve the 500 error:"
echo "1. Run: composer install"
echo "2. Run: php artisan migrate"
echo "3. Restart PHP-FPM: sudo systemctl restart php8.4-fpm"

