# Dockerfile para Calculadora PHP con Nginx + PHP-FPM
# Puerto: 8017 (puesto de trabajo 17)

FROM php:8-fpm-alpine

# Instalar Nginx
RUN apk add --no-cache nginx

# Crear directorio para la aplicación
RUN mkdir -p /var/www/html

# Copiar archivos de la aplicación
COPY index.php /var/www/html/
COPY calculadora.css /var/www/html/
COPY calculadora.png /var/www/html/

# Copiar configuración de Nginx
COPY nginx.conf /etc/nginx/http.d/default.conf

# Exponer el puerto 80 (se mapea al 8017 al ejecutar)
EXPOSE 80

# Iniciar PHP-FPM y Nginx
CMD ["sh", "-c", "php-fpm & nginx -g 'daemon off;'"]

