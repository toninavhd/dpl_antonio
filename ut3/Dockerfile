# Usar Ubuntu 20.04 (tiene ImageMagick 6 compatible con ngx_small_light)
FROM ubuntu:20.04

# Evitar interacción durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Actualizar e instalar dependencias
RUN apt-get update && apt-get install -y \
    nginx \
    build-essential \
    imagemagick \
    libpcre3 \
    libpcre3-dev \
    libmagickwand-dev \
    git \
    curl \
    vim \
    openssl \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -r -s /sbin/nologin nginx

# Crear directorio de trabajo
WORKDIR /tmp

# Clonar y configurar ngx_small_light
RUN git clone https://github.com/cubicdaiya/ngx_small_light.git && \
    cd ngx_small_light && \
    ./setup

# Descargar código fuente de Nginx (la misma versión que viene instalada)
ENV NGINX_VERSION 1.18.0
RUN nginx -v 2>&1 | grep -o '/[0-9.]*' | cut -d'/' -f2 > /tmp/nginx_version.txt && \
    cat /tmp/nginx_version.txt && \
    curl -sL https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz | tar -xz && \
    cd nginx-${NGINX_VERSION} && \
    ./configure --add-dynamic-module=../ngx_small_light --with-compat && \
    make modules && \
    mkdir -p /etc/nginx/modules && \
    cp objs/ngx_http_small_light_module.so /etc/nginx/modules/ && \
    cd / && rm -rf /tmp/ngx_small_light /tmp/nginx-${NGINX_VERSION} /tmp/nginx_version.txt

# Crear estructura de directorios
RUN mkdir -p /var/www/html/img && \
    mkdir -p /var/www/html/css && \
    mkdir -p /var/www/html/js && \
    mkdir -p /etc/nginx/modules && \
    mkdir -p /etc/nginx/ssl && \
    mkdir -p /tmp/small_light

# Generar certificado SSL autofirmado con SAN para el hostname images.antonio.me
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/server.key \
    -out /etc/nginx/ssl/server.crt \
    -subj "/C=ES/ST=Canarias/L=SantaCruz/O=Education/CN=images.antonio.me" \
    -addext "subjectAltName=DNS:images.antonio.me,DNS:www.images.antonio.me" \
    && chmod 600 /etc/nginx/ssl/server.key

# Copiar imágenes
COPY images/ /var/www/html/img/

# Configurar ImageMagick para permitir el procesamiento de imágenes
# Esto es necesario para ngx_small_light
RUN cat > /etc/ImageMagick-6/policy.xml << 'EOF'
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
  <!-- Permitir todos los formatos de imagen -->
  <policy domain="coder" rights="read|write" pattern="*" />
  <policy domain="filter" rights="read|write" pattern="*" />
  <policy domain="delegate" rights="read|write" pattern="*" />
  <policy domain="path" rights="read|write" pattern="@*" />
</policymap>
EOF

# Copiar aplicación web
COPY index.html /var/www/html/
COPY style.css /var/www/html/css/
COPY script.js /var/www/html/js/
COPY entrypoint.sh /entrypoint.sh

# CONCEDER PERMISOS AL USUARIO NGINX - CORREGIDO
RUN chmod +x /entrypoint.sh && \
    chown -R nginx:nginx /var/www/html && \
    chmod -R 755 /var/www/html/img && \
    chmod 644 /var/www/html/img/*.jpg && \
    chown -R nginx:nginx /etc/nginx/modules && \
    chmod 755 /etc/nginx/modules && \
    chmod 644 /etc/nginx/modules/*.so && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /tmp/small_light && \
    chmod 755 /tmp/small_light && \
    touch /var/run/nginx.pid && \
    chown nginx:nginx /var/run/nginx.pid && \
    chown nginx:nginx /etc/nginx/ssl && \
    chmod 600 /etc/nginx/ssl/server.key && \
    chmod 644 /etc/nginx/ssl/server.crt && \
    chown nginx:nginx /etc/ImageMagick-6/policy.xml && \
    chmod 644 /etc/ImageMagick-6/policy.xml

# Copiar configuración de Nginx (solo la parte del archivo, sin duplicados)
COPY nginx.conf /etc/nginx/nginx.conf

# Exponer puertos
EXPOSE 80 443

# Usar entrypoint para configurar permisos al iniciar
ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]

