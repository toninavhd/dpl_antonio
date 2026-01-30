#!/bin/bash
echo "🔍 DIAGNÓSTICO COMPLETO LARAVEL + POSTGRESQL"
echo "============================================"

echo "1. 📊 Servicios PostgreSQL:"
sudo systemctl status postgresql --no-pager | grep -E "(Active|Main PID)"

echo -e "\n2. 🗄️  Base de datos:"
sudo -u postgres psql -c "\l travelroad" 2>/dev/null || echo "Base de datos no encontrada"

echo -e "\n3. 📋 Tabla places:"
sudo -u postgres psql -d travelroad -c "\d places" 2>/dev/null || echo "Tabla no encontrada"

echo -e "\n4. 🔐 Permisos usuario travelroad_user:"
sudo -u postgres psql -d travelroad -c "\dp places" 2>/dev/null || echo "No se pueden ver permisos"

echo -e "\n5. 📁 Archivo .env (DB):"
grep "DB_" /home/toni/Documentos/dpl_antonio/ut4/a3/laravel/travelroad/.env 2>/dev/null || echo "No encontrado"

echo -e "\n6. 🐘 Prueba PDO directa:"
curl -s http://travelroad/test_pdo.php | grep -E "(✅|❌|Error)" | head -5

echo -e "\n7. 🎯 Prueba Laravel:"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://travelroad/)
echo "   Código HTTP: $HTTP_CODE"

if [ "$HTTP_CODE" != "200" ]; then
    echo -e "\n8. 📝 Log Laravel (últimas líneas):"
    tail -n 20 /home/toni/Documentos/dpl_antonio/ut4/a3/laravel/travelroad/storage/logs/laravel.log 2>/dev/null || echo "No hay logs"
fi

echo -e "\n9. 🛠️  Comandos para probar manualmente:"
echo "   sudo -u postgres psql -d travelroad -c \"SELECT * FROM places;\""
echo "   curl http://travelroad/test_pdo.php"
echo "   php artisan route:list"
