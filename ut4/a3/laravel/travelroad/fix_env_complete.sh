#!/bin/bash
echo "🔧 Reparando archivo .env completo..."

cd /home/toni/Documentos/dpl_antonio/ut4/a3/laravel/travelroad

# Backup
cp .env .env.backup.$(date +%s)

# Crear .env CORRECTO
cat > .env << 'ENV_FILE'
APP_NAME=TravelRoad
APP_ENV=local
APP_KEY=base64:$(openssl rand -base64 32)
APP_DEBUG=true
APP_URL=http://travelroad

DB_CONNECTION=pgsql
DB_HOST=127.0.0.1
DB_PORT=5432
DB_DATABASE=travelroad
DB_USERNAME=travelroad_user
DB_PASSWORD=dpl0000

BROADCAST_DRIVER=log
CACHE_DRIVER=file
FILESYSTEM_DISK=local
QUEUE_CONNECTION=sync
SESSION_DRIVER=file
SESSION_LIFETIME=120

MEMCACHED_HOST=127.0.0.1

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_MAILER=smtp
MAIL_HOST=mailpit
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="hello@example.com"
MAIL_FROM_NAME="${APP_NAME}"
ENV_FILE

echo "✅ .env creado con clave generada"
echo "Clave APP_KEY: $(grep APP_KEY .env)"

# Permisos
chmod 664 .env

# Limpiar caché
php artisan config:clear
php artisan cache:clear
php artisan view:clear

echo -e "\n�� Configuración completada. Probando aplicación..."
curl -s -o /dev/null -w "Código HTTP: %{http_code}\n" http://travelroad/
