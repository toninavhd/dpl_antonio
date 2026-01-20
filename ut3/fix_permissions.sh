#!/bin/bash

# Script para conceder permisos al módulo ngx_small_light
# Ejecutar con: sudo bash fix_permissions.sh

echo "🔐 Corrigiendo permisos para ngx_small_light..."

# Definir usuario nginx
NGINX_USER="nginx"
NGINX_GROUP="nginx"

# Verificar si el usuario nginx existe
if ! id "$NGINX_USER" &>/dev/null; then
    echo "⚠️ El usuario $NGINX_USER no existe, usando root"
    NGINX_USER="root"
    NGINX_GROUP="root"
fi

echo "📁 Directorios de imágenes..."

# Directorios de imágenes
IMG_DIRS="/var/www/html/img /var/www/html/css /var/www/html/js"

for dir in $IMG_DIRS; do
    if [ -d "$dir" ]; then
        echo "  Configurando permisos en $dir..."
        chown -R $NGINX_USER:$NGINX_GROUP "$dir"
        chmod -R 755 "$dir"
        chmod 644 "$dir"/*.*
    fi
done

echo "🖼️ Permisos para imágenes..."
# Dar permisos de lectura a todas las imágenes
find /var/www/html/img -type f -exec chmod 644 {} \; 2>/dev/null || true

echo "📦 Directorios de módulos..."
# Módulos de nginx
if [ -d "/etc/nginx/modules" ]; then
    chown -R $NGINX_USER:$NGINX_GROUP /etc/nginx/modules
    chmod -R 755 /etc/nginx/modules
    chmod 644 /etc/nginx/modules/*.so
fi

echo "📝 Logs de nginx..."
# Logs
if [ -d "/var/log/nginx" ]; then
    chown -R $NGINX_USER:$NGINX_GROUP /var/log/nginx
fi

echo "🔧 Directorios temporales..."
# Directorio temporal para small_light
SMALL_LIGHT_TMP="/tmp/small_light"
mkdir -p "$SMALL_LIGHT_TMP"
chown -R $NGINX_USER:$NGINX_GROUP "$SMALL_LIGHT_TMP"
chmod -R 755 "$SMALL_LIGHT_TMP"

# Directorio /tmp general
chmod 1777 /tmp

echo "📄 PID y archivos de socket..."
# PID file
if [ -f "/var/run/nginx.pid" ]; then
    chown $NGINX_USER:$NGINX_GROUP /var/run/nginx.pid
else
    touch /var/run/nginx.pid
    chown $NGINX_USER:$NGINX_GROUP /var/run/nginx.pid
fi

echo "🔒 Certificados SSL..."
# SSL
if [ -d "/etc/nginx/ssl" ]; then
    chown -R $NGINX_USER:$NGINX_GROUP /etc/nginx/ssl
    chmod 600 /etc/nginx/ssl/server.key
    chmod 644 /etc/nginx/ssl/server.crt
fi

echo "🎨 ImageMagick..."
# ImageMagick policy - asegurar que es modificable
if [ -f "/etc/ImageMagick-6/policy.xml" ]; then
    chown $NGINX_USER:$NGINX_GROUP /etc/ImageMagick-6/policy.xml
    chmod 644 /etc/ImageMagick-6/policy.xml
fi

# Directorio de cache de ImageMagick
IM_CACHE="/tmp/.magick"
mkdir -p "$IM_CACHE" 2>/dev/null || true
chown -R $NGINX_USER:$NGINX_GROUP "$IM_CACHE" 2>/dev/null || true

echo "✅ Permisos corregidos exitosamente!"
echo ""
echo "📋 Resumen de permisos:"
echo "   - Usuario Nginx: $NGINX_USER"
echo "   - Directorio tmp: $SMALL_LIGHT_TMP"
echo "   - Imágenes: /var/www/html/img"
echo ""
echo "🚀 Para reiniciar nginx: systemctl restart nginx"
echo "🐳 Para Docker: docker restart antonio_small_light"

