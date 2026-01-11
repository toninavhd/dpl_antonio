FROM nginx:alpine

# Instalar dependencias necesarias
RUN apk add --no-cache build-base imagemagick git pcre-dev libmagickwand-dev

# Crear directorio de trabajo
WORKDIR /tmp

# Clonar y configurar ngx_small_light
RUN git clone https://github.com/cubicdaiya/ngx_small_light.git && \
    cd ngx_small_light && \
    ./setup

# Descargar código fuente de Nginx
ENV NGINX_VERSION 1.22.0
RUN curl -sL https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz | tar -xz && \
    cd nginx-${NGINX_VERSION} && \
    ./configure --add-dynamic-module=../ngx_small_light --with-compat && \
    make modules && \
    cp objs/ngx_http_small_light_module.so /etc/nginx/modules/ && \
    cd / && rm -rf /tmp/ngx_small_light /tmp/nginx-${NGINX_VERSION}

# Copiar configuración de Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Crear estructura de directorios
RUN mkdir -p /usr/share/nginx/html/img

# Copiar imágenes
COPY images/ /usr/share/nginx/html/img/

# Copiar aplicación web
COPY html/ /usr/share/nginx/html/

# Exponer puertos
EXPOSE 80 443

# Comando de inicio
CMD ["nginx", "-g", "daemon off;"]

