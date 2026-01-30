#!/bin/bash
echo "=== DIAGNÓSTICO FINAL ==="
echo ""
echo "1. Servicios:"
sudo systemctl status nginx --no-pager | grep -E "(Active|Main PID)"
sudo systemctl status php8.4-fpm --no-pager | grep -E "(Active|Main PID)"
echo ""
echo "2. Conexiones:"
sudo netstat -tulpn | grep -E "(:80|:9000)"
echo ""
echo "3. Configuración PHP-FPM:"
sudo grep "^listen\|^user\|^group" /etc/php/8.4/fpm/pool.d/www.conf
echo ""
echo "4. Configuración Nginx PHP:"
sudo grep -A3 "\.php$" /etc/nginx/sites-available/laravel-travelroad
echo ""
echo "5. Logs recientes:"
sudo tail -5 /var/log/nginx/error.log
echo ""
echo "6. Prueba de archivo PHP:"
curl -s -o /dev/null -w "%{http_code}" http://travelroad/test.php
echo " (Código HTTP)"
echo ""
echo "7. Usuario/Grupo archivos:"
ls -la /home/toni/Documentos/dpl_antonio/ut4/a3/laravel/travelroad/public/index.php | awk '{print "Archivo: " $9 " | Owner: " $3 ":" $4 " | Permisos: " $1}'
