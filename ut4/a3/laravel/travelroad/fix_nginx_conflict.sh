#!/bin/bash
echo "🛠️  Solucionando conflictos de Nginx..."

# 1. Parar Nginx
sudo systemctl stop nginx

# 2. Backup de configuraciones
BACKUP_DIR="/tmp/nginx_backup_$(date +%s)"
sudo mkdir -p "$BACKUP_DIR"
sudo cp -r /etc/nginx/sites-enabled/ "$BACKUP_DIR/" 2>/dev/null
sudo cp -r /etc/nginx/conf.d/ "$BACKUP_DIR/" 2>/dev/null

# 3. Limpiar TODO
sudo rm -rf /etc/nginx/sites-enabled/*
sudo rm -f /etc/nginx/conf.d/*.conf 2>/dev/null

# 4. Crear configuración ÚNICA y SIMPLE
sudo tee /etc/nginx/sites-available/travelroad_app << 'NGINX_CONFIG'
server {
    listen 80;
    server_name travelroad;
    
    root /home/toni/Documentos/dpl_antonio/ut4/a3/laravel/travelroad/public;
    index index.php;
    
    location / {
        try_files $uri $uri/ /index.php$is_args$args;
    }
    
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
NGINX_CONFIG

# 5. Habilitar
sudo ln -sf /etc/nginx/sites-available/travelroad_app /etc/nginx/sites-enabled/

# 6. Actualizar hosts
sudo sed -i '/travelroad/d' /etc/hosts
echo "127.0.0.1 travelroad" | sudo tee -a /etc/hosts

# 7. Iniciar servicios
sudo systemctl restart php8.4-fpm
sleep 2
sudo systemctl start nginx

# 8. Verificar
echo ""
echo "✅ Verificación:"
sudo nginx -t
echo ""
echo "🌐 Estado:"
sudo systemctl status nginx --no-pager | grep "Active"
echo ""
echo "🔌 Puerto 80:"
sudo netstat -tulpn | grep :80
echo ""
echo "📡 Prueba HTTP:"
curl -s -o /dev/null -w "Código: %{http_code}\n" http://travelroad/debug.php || echo "Falló"
