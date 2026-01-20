# Fix Permissions Guide - ngx_small_light

## Problema de Permisos con ngx_small_light

El módulo `ngx_small_light` puede fallar debido a problemas de permisos. Aquí están las soluciones:

## 📋 Métodos de Solución

### Opción 1: Usar el Script de Despliegue (Recomendado)

```bash
cd ut3
chmod +x deploy.sh
./deploy.sh all
```

Esto construirá e iniciará el contenedor con todos los permisos correctos.

### Opción 2: Script de Permisos para Servidor Local

Si estás ejecutando nginx directamente (sin Docker):

```bash
cd ut3
chmod +x fix_permissions.sh
sudo bash fix_permissions.sh
sudo systemctl restart nginx
```

### Opción 3: Dentro del Contenedor Docker

```bash
# Acceder al contenedor
docker exec -it antonio_small_light /bin/bash

# Ejecutar el script de permisos
bash /entrypoint.sh

# O manualmente:
chown -R nginx:nginx /var/www/html
chmod -R 755 /var/www/html/img
mkdir -p /tmp/small_light
chown -R nginx:nginx /tmp/small_light
chmod 755 /tmp/small_light

# Salir y reiniciar
exit
docker restart antonio_small_light
```

## 🔧 Permisos Específicos Corregidos

### 1. Directorio de Imágenes
```bash
chown -R nginx:nginx /var/www/html
chmod -R 755 /var/www/html/img
chmod 644 /var/www/html/img/*.jpg
```

### 2. Módulos de Nginx
```bash
chown -R nginx:nginx /etc/nginx/modules
chmod 644 /etc/nginx/modules/*.so
```

### 3. Directorio Temporal (Peermission 0755)
```bash
mkdir -p /tmp/small_light
chown -R nginx:nginx /tmp/small_light
chmod 755 /tmp/small_light
chmod 1777 /tmp
```

### 4. Logs de Nginx
```bash
chown -R nginx:nginx /var/log/nginx
```

### 5. PID File
```bash
touch /var/run/nginx.pid
chown nginx:nginx /var/run/nginx.pid
```

### 6. Certificados SSL
```bash
chown nginx:nginx /etc/nginx/ssl
chmod 600 /etc/nginx/ssl/server.key
chmod 644 /etc/nginx/ssl/server.crt
```

### 7. ImageMagick Policy
```bash
chown nginx:nginx /etc/ImageMagick-6/policy.xml
chmod 644 /etc/ImageMagick-6/policy.xml
```

## 🐳 Comandos Docker Útiles

```bash
# Ver estado del contenedor
docker ps | grep antonio_small_light

# Ver logs
docker logs antonio_small_light

# Acceder al contenedor
docker exec -it antonio_small_light /bin/bash

# Reiniciar contenedor
docker restart antonio_small_light

# Verificar configuración nginx
docker exec antonio_small_light nginx -t

# Recargar nginx
docker exec antonio_small_light nginx -s reload
```

## 🔍 Diagnóstico de Problemas

### Verificar permisos dentro del contenedor:
```bash
docker exec antonio_small_light ls -la /var/www/html/img/
docker exec antonio_small_light ls -la /tmp/small_light/
docker exec antonio_small_light id nginx
```

### Verificar logs de error:
```bash
docker exec antonio_small_light cat /var/log/nginx/error.log
```

### Probar ImageMagick:
```bash
docker exec antonio_small_light convert --version
docker exec antonio_small_light convert /var/www/html/img/image01.jpg -resize 100x100 /tmp/test.jpg
```

## ✅ Verificación Final

Para verificar que ngx_small_light funciona correctamente:

1. Accede a: `https://images.antonio.me`
2. Verás el formulario de procesamiento de imágenes
3. Ajusta los parámetros (tamaño, borde, color, etc.)
4. Pulsa "Generar"
5. Las imágenes deben aparecer procesadas según los parámetros

Si las imágenes no se cargan, revisa:
- Los logs del navegador (F12 > Console)
- Los logs de nginx (`docker logs antonio_small_light`)
- Los permisos de los directorios de imágenes

