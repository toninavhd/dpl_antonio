#!/bin/bash
echo "🔍 DIAGNÓSTICO COMPLETO"
echo "========================"

echo "1. 📁 RUTA DE LA APLICACIÓN:"
ls -la "/home/toni/Documentos/dpl_antonio/ut4/a3/laravel/travelroad/public/"

echo -e "\n2. 🌐 SERVICIOS:"
sudo systemctl status nginx --no-pager | grep -E "(Active|PID)"
sudo systemctl status php8.4-fpm --no-pager | grep -E "(Active|PID)"

echo -e "\n3. 🔌 PUERTOS:"
sudo netstat -tulpn | grep -E "(:80|:9000|:8080)"

echo -e "\n4. ⚙️ CONFIGURACIÓN NGINX (resumen):"
for file in /etc/nginx/sites-enabled/*; do
    echo "--- $file ---"
    sudo grep -E "(server_name|root|fastcgi_pass)" "$file" 2>/dev/null || echo "Vacío"
done

echo -e "\n5. 📊 PRUEBAS HTTP:"
echo "   Travelroad: $(curl -s -o /dev/null -w "%{http_code}" http://travelroad/simple_test.php 2>/dev/null || echo "FAIL")"
echo "   Localhost:  $(curl -s -o /dev/null -w "%{http_code}" http://localhost/simple_test.php 2>/dev/null || echo "FAIL")"
echo "   127.0.0.1:  $(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1/simple_test.php 2>/dev/null || echo "FAIL")"

echo -e "\n6. 📝 ÚLTIMOS ERRORES:"
sudo tail -5 /var/log/nginx/error.log 2>/dev/null || echo "No hay logs de error"
sudo tail -5 /var/log/nginx/travelroad_error.log 2>/dev/null || echo "No hay logs específicos"

echo -e "\n7. 👤 PERMISOS:"
ls -ld "/home/toni/Documentos/dpl_antonio/ut4/a3/laravel/travelroad/public/"
ls -la "/home/toni/Documentos/dpl_antonio/ut4/a3/laravel/travelroad/public/index.php" 2>/dev/null || echo "No existe index.php"

echo -e "\n8. 🐘 PHP-FPM DIRECT TEST:"
timeout 2 bash -c "echo > /dev/tcp/127.0.0.1/9000" && echo "✅ Puerto 9000 accesible" || echo "❌ Puerto 9000 no accesible"
