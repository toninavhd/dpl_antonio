#!/bin/bash

# Script de instalación de ngx_small_light en nativo (sin Docker)
# Este script instala nginx con el módulo ngx_small_light compilado dinámicamente

set -e

echo "=========================================="
echo "  Instalación de ngx_small_light Nativo"
echo "=========================================="
echo ""

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar si es root
if [ "$EUID" -ne 0 ]; then
    print_error "Este script debe ejecutarse como root (usa sudo)"
    exit 1
fi

# Detectar sistema operativo
print_status "Detectando sistema operativo..."
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_NAME="$NAME"
    OS_VERSION="$VERSION_ID"
    print_status "Sistema detectado: $OS_NAME $OS_VERSION"
else
    print_error "No se pudo detectar el sistema operativo"
    exit 1
fi

# Instalar dependencias según el sistema operativo
print_status "Instalando dependencias..."

case "$OS_NAME" in
    "Ubuntu"|"Debian"|"Debian GNU/Linux"|"Linux Mint"|"Pop!_OS"|"KDE neon")
        export DEBIAN_FRONTEND=noninteractive
        apt-get update
        apt-get install -y \
            nginx \
            build-essential \
            imagemagick \
            libpcre2-dev \
            libmagickwand-dev \
            git \
            curl \
            vim \
            openssl \
            libssl-dev \
            zlib1g-dev
        ;;
    "Fedora"|"CentOS"|"Red Hat Enterprise Linux"|"Rocky Linux"|"AlmaLinux")
        dnf install -y \
            nginx \
            gcc \
            gcc-c++ \
            ImageMagick \
            pcre \
            pcre-devel \
            ImageMagick-devel \
            git \
            curl \
            vim \
            openssl \
            openssl-devel \
            zlib-devel
        ;;
    *)
        print_error "Sistema operativo no soportado: $OS_NAME"
        print_warning "Por favor, instala las dependencias manualmente:"
        echo "  - nginx"
        echo "  - build-essential / gcc gcc-c++"
        echo "  - imagemagick / ImageMagick"
        echo "  - libpcre3-dev / pcre-devel"
        echo "  - libmagickwand-dev / ImageMagick-devel"
        echo "  - git, curl, openssl"
        exit 1
        ;;
esac

print_success "Dependencias instaladas"

# Obtener versión de nginx
print_status "Obteniendo versión de nginx..."
NGINX_VERSION=$(nginx -v 2>&1 | grep -o '/[0-9.]*' | cut -d'/' -f2)
print_status "Versión de nginx: $NGINX_VERSION"

# Crear directorio de trabajo
WORKDIR="/tmp/ngx_small_light_build_$$"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

print_status "Directorio de trabajo: $WORKDIR"

# Clonar ngx_small_light
print_status "Clonando ngx_small_light..."
if [ -d "ngx_small_light" ]; then
    rm -rf ngx_small_light
fi
git clone https://github.com/cubicdaiya/ngx_small_light.git
cd ngx_small_light
./setup

# Descargar código fuente de nginx
print_status "Descargando código fuente de nginx $NGINX_VERSION..."
cd "$WORKDIR"
if [ -f "nginx-${NGINX_VERSION}.tar.gz" ]; then
    rm -f nginx-${NGINX_VERSION}.tar.gz
fi
curl -sL https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz | tar -xz

# Compilar módulo ngx_small_light
print_status "Configurando compilación con ngx_small_light..."
cd nginx-${NGINX_VERSION}
./configure --add-dynamic-module=../ngx_small_light --with-compat

print_status "Compilando módulo ngx_small_light..."
make modules

# Instalar módulo
print_status "Instalando módulo ngx_small_light..."
mkdir -p /etc/nginx/modules
cp objs/ngx_http_small_light_module.so /etc/nginx/modules/
chmod 644 /etc/nginx/modules/ngx_http_small_light_module.so

# Limpiar
cd /
rm -rf "$WORKDIR"

print_success "Módulo ngx_small_light compilado e instalado"

# Verificar instalación del módulo
print_status "Verificando instalación del módulo..."
if [ -f "/etc/nginx/modules/ngx_http_small_light_module.so" ]; then
    print_success "Módulo ngx_http_small_light_module.so instalado correctamente"
else
    print_error "Error al instalar el módulo"
    exit 1
fi

# Configurar ImageMagick para permitir procesamiento
print_status "Configurando ImageMagick..."
cat > /etc/ImageMagick-6/policy.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE policymap [
  <!ELEMENT policymap (policy)+>
  <!ATTLIST policymap xmlns CDATA #FIXED ''>
  <!ELEMENT policy EMPTY>
  <!ATTLIST policy xmlns CDATA #FIXED '' domain NMTOKEN #REQUIRED
    name NMTOKEN #IMPLIED pattern CDATA #IMPLIED rights NMTOKEN #IMPLIED
    stealth NMTOKEN #IMPLIED value CDATA #IMPLIED>
]>
<policymap>
  <policy domain="resource" name="memory" value="512MiB"/>
  <policy domain="resource" name="map" value="1GiB"/>
  <policy domain="resource" name="width" value="32KP"/>
  <policy domain="resource" name="height" value="32KP"/>
  <policy domain="resource" name="area" value="256MB"/>
  <policy domain="resource" name="disk" value="2GiB"/>
  <policy domain="coder" rights="read|write" pattern="*" />
  <policy domain="filter" rights="read|write" pattern="*" />
  <policy domain="delegate" rights="read|write" pattern="*" />
  <policy domain="path" rights="read|write" pattern="@*" />
</policymap>
EOF
print_success "ImageMagick configurado"

# Generar certificado SSL autofirmado
print_status "Generando certificado SSL autofirmado..."
mkdir -p /etc/nginx/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/server.key \
    -out /etc/nginx/ssl/server.crt \
    -subj "/C=ES/ST=Canarias/L=SantaCruz/O=Education/CN=images.antonio.me" \
    -addext "subjectAltName=DNS:images.antonio.me,DNS:www.images.antonio.me"
chmod 600 /etc/nginx/ssl/server.key
chmod 644 /etc/nginx/ssl/server.crt
print_success "Certificado SSL generado"

# Crear estructura de directorios
print_status "Creando estructura de directorios..."
mkdir -p /var/www/html/img
mkdir -p /var/www/html/css
mkdir -p /var/www/html/js
mkdir -p /tmp/small_light
chmod 755 /tmp/small_light
chmod 1777 /tmp

# Copiar archivos de la aplicación
print_status "Copiando archivos de la aplicación..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -f "$SCRIPT_DIR/index.html" ]; then
    cp "$SCRIPT_DIR/index.html" /var/www/html/
    print_status "Copiado index.html"
fi

if [ -f "$SCRIPT_DIR/style.css" ]; then
    cp "$SCRIPT_DIR/style.css" /var/www/html/css/style.css
    print_status "Copiado style.css"
fi

if [ -d "$SCRIPT_DIR/images" ]; then
    cp -r "$SCRIPT_DIR/images/"* /var/www/html/img/
    chmod 644 /var/www/html/img/*.jpg
    print_status "Copiadas imágenes"
fi

# Copiar script.js
if [ -f "$SCRIPT_DIR/script.js" ]; then
    mkdir -p /var/www/html/js
    cp "$SCRIPT_DIR/script.js" /var/www/html/js/script.js
    print_status "Copiado script.js"
fi

# Configurar permisos
print_status "Configurando permisos..."
chown -R www-data:www-data /var/www/html 2>/dev/null || \
chown -R nginx:nginx /var/www/html 2>/dev/null || \
chown -R root:root /var/www/html

chmod -R 755 /var/www/html/img
chmod 644 /var/www/html/img/*.jpg
chown -R www-data:www-data /tmp/small_light 2>/dev/null || \
chown -R nginx:nginx /tmp/small_light 2>/dev/null || \
chown -R root:root /tmp/small_light

print_success "Permisos configurados"

# Copiar configuración de nginx
print_status "Configurando nginx..."
if [ -f "$SCRIPT_DIR/nginx.conf" ]; then
    cp "$SCRIPT_DIR/nginx.conf" /etc/nginx/nginx.conf
    print_success "Configuración de nginx actualizada"
else
    print_warning "No se encontró nginx.conf en el directorio del script"
    print_warning "La configuración debe hacerse manualmente"
fi

# Verificar configuración de nginx
print_status "Verificando configuración de nginx..."
if nginx -t 2>&1; then
    print_success "Configuración de nginx válida"
else
    print_error "Error en la configuración de nginx"
    exit 1
fi

echo ""
echo "=========================================="
print_success "¡Instalación completada!"
echo "=========================================="
echo ""
echo "📋 Resumen:"
echo "   - Nginx con módulo ngx_small_light"
echo "   - Imagenagick configurado"
echo "   - Certificado SSL autofirmado"
echo "   - Archivos de la aplicación en /var/www/html"
echo ""
echo "📝 Próximos pasos:"
echo "   1. Edita /etc/hosts si no tienes DNS:"
echo "      echo '127.0.0.1 images.antonio.me' >> /etc/hosts"
echo ""
echo "   2. Inicia nginx:"
echo "      systemctl start nginx"
echo ""
echo "   3. Habilita inicio automático:"
echo "      systemctl enable nginx"
echo ""
echo "   4. Accede a: https://images.antonio.me"
echo ""
echo "🐛 Si hay errores, revisa:"
echo "   - /var/log/nginx/error.log"
echo "   - Permisos de /var/www/html/img"
echo "   - Permisos de /tmp/small_light"
echo ""


