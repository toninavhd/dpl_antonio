#!/bin/bash

# Script de entrada para Docker que configura permisos antes de iniciar nginx
# Este script se ejecuta cuando el contenedor inicia

set -e

echo "🚀 Inicializando contenedor con permisos correctos..."

# Definir usuario nginx
NGINX_USER="nginx"
NGINX_GROUP="nginx"

# Verificar si el usuario nginx existe
if ! id "$NGINX_USER" &>/dev/null; then
    echo "⚠️ El usuario nginx no existe, creando..."
    useradd -r -s /sbin/nologin nginx
    NGINX_USER="nginx"
    NGINX_GROUP="nginx"
fi

echo "🔐 Configurando permisos para ngx_small_light..."

# Directorios de imágenes
echo "📁 Directorios de imágenes..."
for dir in /var/www/html/img /var/www/html/css /var/www/html/js; do
    if [ -d "$dir" ]; then
        chown -R $NGINX_USER:$NGINX_GROUP "$dir"
        chmod -R 755 "$dir"
    fi
done

# Dar permisos de lectura a todas las imágenes
echo "🖼️ Permisos para imágenes..."
find /var/www/html/img -type f -exec chmod 644 {} \; 2>/dev/null || true

# Módulos de nginx
echo "📦 Directorios de módulos..."
if [ -d "/etc/nginx/modules" ]; then
    chown -R $NGINX_USER:$NGINX_GROUP /etc/nginx/modules
    chmod 755 /etc/nginx/modules
    chmod 644 /etc/nginx/modules/*.so
fi

# Logs
echo "📝 Logs de nginx..."
if [ -d "/var/log/nginx" ]; then
    chown -R $NGINX_USER:$NGINX_GROUP /var/log/nginx
fi

# Directorio temporal para small_light
echo "📝 Directorios temporales..."
SMALL_LIGHT_TMP="/tmp/small_light"
mkdir -p "$SMALL_LIGHT_TMP"
chown -R $NGINX_USER:$NGINX_GROUP "$SMALL_LIGHT_TMP"
chmod -R 755 "$SMALL_LIGHT_TMP"

# Directorio /tmp general
chmod 1777 /tmp

# PID file
echo "📄 PID y archivos de socket..."
if [ -f "/var/run/nginx.pid" ]; then
    chown $NGINX_USER:$NGINX_GROUP /var/run/nginx.pid
else
    touch /var/run/nginx.pid
    chown $NGINX_USER:$NGINX_GROUP /var/run/nginx.pid
fi

# SSL
echo "🔒 Certificados SSL..."
if [ -d "/etc/nginx/ssl" ]; then
    chown -R $NGINX_USER:$NGINX_GROUP /etc/nginx/ssl
    chmod 600 /etc/nginx/ssl/server.key
    chmod 644 /etc/nginx/ssl/server.crt
fi

# ImageMagick
echo "🎨 ImageMagick..."
if [ -f "/etc/ImageMagick-6/policy.xml" ]; then
    chown $NGINX_USER:$NGINX_GROUP /etc/ImageMagick-6/policy.xml
    chmod 644 /etc/ImageMagick-6/policy.xml
fi

# Directorio de cache de ImageMagick
IM_CACHE="/tmp/.magick"
mkdir -p "$IM_CACHE" 2>/dev/null || true
chown -R $NGINX_USER:$NGINX_GROUP "$IM_CACHE" 2>/dev/null || true

echo "✅ Permisos configurados correctamente!"
echo ""

# Verificar syntax de nginx
echo "🔍 Verificando configuración de nginx..."
nginx -t

echo ""
echo "🌐 Iniciando nginx..."
exec "$@"

