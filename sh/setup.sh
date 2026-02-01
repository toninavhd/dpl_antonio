#!/bin/bash

# TravelRoad Laravel - Complete Setup Script
# This script fixes all issues causing the 500 Server Error

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🚀 Starting TravelRoad Laravel Setup...${NC}"
echo ""

PROJECT_DIR="$(dirname "$0")"
cd "$PROJECT_DIR"

# Step 1: Create missing storage directories
echo -e "${YELLOW}📁 Step 1: Creating storage directories...${NC}"
mkdir -p storage/framework/{cache,sessions,views}
mkdir -p storage/logs
mkdir -p bootstrap/cache

# Create .gitkeep files
touch storage/framework/cache/.gitkeep
touch storage/framework/sessions/.gitkeep
touch storage/framework/views/.gitkeep
touch storage/logs/.gitkeep
touch bootstrap/cache/.gitkeep
echo -e "${GREEN}✅ Done!${NC}"
echo ""

# Step 2: Set proper permissions
echo -e "${YELLOW}🔐 Step 2: Setting permissions...${NC}"
chmod -R 775 storage bootstrap/cache
chmod -R 775 public
echo -e "${GREEN}✅ Done!${NC}"
echo ""

# Step 3: Install Composer dependencies
echo -e "${YELLOW}📦 Step 3: Installing Composer dependencies...${NC}"
if [ -f "composer.json" ]; then
    composer install --no-interaction --prefer-dist
    echo -e "${GREEN}✅ Done!${NC}"
else
    echo -e "${RED}❌ composer.json not found!${NC}"
    exit 1
fi
echo ""

# Step 4: Generate app key
echo -e "${YELLOW}🔑 Step 4: Generating application key...${NC}"
php artisan key:generate --ansi
echo -e "${GREEN}✅ Done!${NC}"
echo ""

# Step 5: Create database migrations for places table
echo -e "${YELLOW}🗃️ Step 5: Creating migrations directory and files...${NC}"
mkdir -p database/migrations

# Create the places table migration
cat > database/migrations/2024_01_01_000001_create_places_table.php << 'MIGRATION'
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('places', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->boolean('visited')->default(false);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('places');
    }
};
MIGRATION

# Create a seeder for sample data
mkdir -p database/seeders

cat > database/seeders/PlacesSeeder.php << 'SEEDER'
<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class PlacesSeeder extends Seeder
{
    public function run(): void
    {
        // Clear existing data
        DB::table('places')->delete();

        // Add places to visit
        DB::table('places')->insert([
            ['name' => 'París, Francia', 'visited' => false, 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'Tokio, Japón', 'visited' => false, 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'Nueva York, Estados Unidos', 'visited' => false, 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'Barcelona, España', 'visited' => false, 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'Bali, Indonesia', 'visited' => false, 'created_at' => now(), 'updated_at' => now()],
        ]);

        // Add visited places
        DB::table('places')->insert([
            ['name' => 'Londres, Reino Unido', 'visited' => true, 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'Roma, Italia', 'visited' => true, 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'Berlín, Alemania', 'visited' => true, 'created_at' => now(), 'updated_at' => now()],
        ]);
    }
}
SEEDER

echo -e "${GREEN}✅ Done!${NC}"
echo ""

# Step 6: Run database migrations
echo -e "${YELLOW}📊 Step 6: Running database migrations...${NC}"
php artisan migrate --force
echo -e "${GREEN}✅ Done!${NC}"
echo ""

# Step 7: Seed the database
echo -e "${YELLOW}🌱 Step 7: Seeding database with sample data...${NC}"
php artisan db:seed --class=PlacesSeeder --force
echo -e "${GREEN}✅ Done!${NC}"
echo ""

# Step 8: Clear all caches
echo -e "${YELLOW}🧹 Step 8: Clearing caches...${NC}"
php artisan config:clear
php artisan cache:clear
php artisan route:clear
php artisan view:clear
echo -e "${GREEN}✅ Done!${NC}"
echo ""

# Step 9: Optimize the application
echo -e "${YELLOW}⚡ Step 9: Optimizing application...${NC}"
php artisan optimize
echo -e "${GREEN}✅ Done!${NC}"
echo ""

echo -e "${GREEN}🎉 Setup completed successfully!${NC}"
echo ""
echo -e "${YELLOW}To complete the fix, restart PHP-FPM:${NC}"
echo -e "  sudo systemctl restart php8.4-fpm"
echo ""
echo -e "${YELLOW}Then access: http://laravel.travelroad${NC}"

