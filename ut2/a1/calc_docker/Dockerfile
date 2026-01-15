# Dockerfile para Calculadora PHP con Nginx + PHP-FPM
# Puerto: 8017 (puesto de trabajo 17)

FROM nginx:alpine

# Actualizar repositorios e instalar PHP-FPM
RUN apk update && \
    apk add --no-cache php-fpm php-curl php-json php-mbstring php-openssl

# Crear directorio para la aplicación
RUN mkdir -p /var/www/html

# Copiar archivos de la aplicación
COPY index.php /var/www/html/
COPY calculadora.css /var/www/html/
COPY calculadora.png /var/www/html/

# Copiar configuración de Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exponer el puerto 80 (se mapea al 8017 al ejecutar)
EXPOSE 80

# Iniciar PHP-FPM y Nginx (el binario en Alpine 3.23 es php-fpm84)
CMD ["sh", "-c", "php-fpm84 --nodaemonize & nginx -g 'daemon off;'"]

