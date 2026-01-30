# TravelRoad - Laravel Application

<p align="center">
  <a href="https://laravel.com" target="_blank">
    <img src="https://raw.githubusercontent.com/laravel/art/master/logo-lockup/5%20SVG/2%20CMYK/1%20Full%20Color/laravel-logolockup-cmyk-red.svg" width="400" alt="Laravel Logo">
  </a>
</p>

<p align="center">
  <strong>Powered by Laravel</strong>
</p>

## Descripción

TravelRoad es una aplicación web desarrollada con Laravel que permite gestionar una lista de lugares visitados y lugares que se desean visitar. La aplicación consulta una base de datos PostgreSQL y muestra los resultados en una interfaz HTML.

## Requisitos del Sistema

- **PHP**: Versión 8.4
- **Composer**: Gestor de dependencias de PHP
- **PostgreSQL**: Base de datos
- **Nginx**: Servidor web
- **PHP-FPM**: Procesador de PHP para Nginx

### Paquetes PHP requeridos

```bash
sudo apt install -y php8.4-mbstring php8.4-xml php8.4-bcmath php8.4-curl php8.4-pgsql
```

| Paquete | Descripción |
|---------|-------------|
| mbstring | Gestión de cadenas de caracteres multibyte |
| xml | Análisis XML |
| bcmath | Operaciones matemáticas de precisión arbitraria |
| curl | Cliente de cURL |
| pgsql | Herramientas para PostgreSQL |

## Instalación

1. **Clonar el repositorio**:

```bash
git clone <repository-url> travelroad_laravel
cd travelroad_laravel
```

2. **Instalar dependencias**:

```bash
composer install
```

3. **Configurar el archivo .env**:

```bash
cp .env.example .env
php artisan key:generate
```

4. **Configurar la base de datos** en `.env`:

```env
DB_CONNECTION=pgsql
DB_HOST=127.0.0.1
DB_PORT=5432
DB_DATABASE=travelroad
DB_USERNAME=travelroad_user
DB_PASSWORD=dpl0000
```

5. **Ejecutar migraciones**:

```bash
php artisan migrate
```

## Configuración Nginx

### Permisos de carpetas

```bash
sudo chgrp -R nginx storage bootstrap/cache
sudo chmod -R ug+rwx storage bootstrap/cache
```

### Configuración del Virtual Host

Copiar el archivo `nginx.conf` a `/etc/nginx/conf.d/travelroad.conf`:

```bash
sudo cp nginx.conf /etc/nginx/conf.d/travelroad.conf
```

### Verificar y recargar Nginx

```bash
sudo nginx -t
sudo systemctl reload nginx
```

### Añadir al archivo hosts (para desarrollo local)

```bash
echo "127.0.0.1 travelroad" | sudo tee -a /etc/hosts
```

## Certificado SSL

Para habilitar HTTPS en producción, se requiere un certificado SSL. Se pueden obtener certificados gratuitos mediante Let's Encrypt.

### Instalación de Certbot

```bash
sudo apt install -y certbot python3-certbot-nginx
```

### Obtención del certificado

```bash
sudo certbot --nginx -d travelroad
```

### Renovación automática

Los certificados de Let's Encrypt caducan a los 90 días. Para configurar la renovación automática:

```bash
sudo systemctl enable certbot.timer
sudo systemctl start certbot.timer
```

### Configuración Nginx con SSL (producción)

El archivo `nginx.conf` ya incluye una sección comentada para HTTPS. Descomentar y configurar:

```nginx
server {
    listen 443 ssl http2;
    server_name travelroad;
    root /home/toni/Documentos/dpl_antonio/ut4/a3/travelroad_laravel/public;
    
    ssl_certificate /etc/letsencrypt/live/travelroad/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/travelroad/privkey.pem;
    
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    
    # ... resto de la configuración
}
```

## Estructura del Proyecto

```
travelroad_laravel/
├── app/
│   └── Providers/
│       └── AppServiceProvider.php
├── bootstrap/
│   ├── app.php
│   └── providers.php
├── config/
│   ├── app.php
│   └── database.php
├── resources/
│   └── views/
│       └── travelroad.blade.php
├── routes/
│   ├── console.php
│   └── web.php
├── .editorconfig
├── .env
├── .env.example
├── .gitignore
├── artisan
├── composer.json
├── deploy.sh
└── nginx.conf
```

## Archivo deploy.sh

El script de despliegue automatiza el proceso de actualización en producción:

```bash
chmod +x deploy.sh
./deploy.sh
```

El script realiza las siguientes operaciones:
1. Conexión SSH al servidor
2. Actualización del código fuente (git pull)
3. Instalación de dependencias (composer install)
4. Ejecución de migraciones
5. Limpieza de caché
6. Optimización de la aplicación
7. Recarga de PHP-FPM

## Configuración de Git

### Archivos ignorados (.gitignore)

El archivo `.gitignore` está configurado para:
- Ignorar archivos de configuración sensibles (.env)
- Ignorar la carpeta vendor (se genera con `composer install`)
- Ignorar archivos de caché y logs
- Ignorar archivos de desarrollo

### Variables sensibles ignoradas

Las siguientes variables del archivo `.env` NO deben incluirse en el control de versiones:
- `APP_KEY`: Clave de encriptación de la aplicación
- `DB_PASSWORD`: Contraseña de la base de datos
- Cualquier credential de API o servicio externo

## Uso

Una vez configurado, acceder a la aplicación en:

- **Desarrollo**: http://travelroad
- **Producción**: https://travelroad

La página principal muestra:
- Lista de lugares por visitar
- Lista de lugares visitados

## Powered by

Esta aplicación está **powered by Laravel**, un framework PHP moderno y elegante para desarrolladores web.

## Licencia

Este proyecto está bajo la licencia MIT.

