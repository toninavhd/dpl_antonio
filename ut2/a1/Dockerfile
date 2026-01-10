# Dockerfile para Calculadora PHP con Nginx + PHP-FPM
# Puerto: 8017 (puesto de trabajo 17)

FROM nginx:alpine

# Instalar PHP-FPM
RUN apk add --no-cache php-fpm php-curl php-json php-mbstring

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

# Configurar Nginx para que funcione con PHP-FPM
RUN echo "server { \
    listen 80; \
    server_name localhost; \
    root /var/www/html; \
    index index.php index.html; \
    \
    location / { \
        try_files \$uri \$uri/ =404; \
    } \
    \
    location ~ \.php\$ { \
        include fastcgi_params; \
        fastcgi_pass 127.0.0.1:9000; \
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name; \
        fastcgi_index index.php; \
    } \
}" > /etc/nginx/conf.d/default.conf

# Iniciar PHP-FPM y Nginx
CMD ["sh", "-c", "php-fpm -D && nginx -g 'daemon off;'"]
