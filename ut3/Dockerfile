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
    && rm -rf /var/lib/apt/lists/*

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
    cp objs/ngx_http_small_light_module.so /etc/nginx/modules/ && \
    cd / && rm -rf /tmp/ngx_small_light /tmp/nginx-${NGINX_VERSION} /tmp/nginx_version.txt

# Crear estructura de directorios
RUN mkdir -p /var/www/html/img && \
    mkdir -p /var/www/html/css && \
    mkdir -p /var/www/html/js

# Copiar imágenes
COPY images/ /var/www/html/img/

# Copiar aplicación web
COPY index.html /var/www/html/
COPY style.css /var/www/html/css/
COPY script.js /var/www/html/js/

# Copiar configuración de Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Exponer puertos
EXPOSE 80 443

# Iniciar nginx
CMD ["nginx", "-g", "daemon off;"]

