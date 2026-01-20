<center>

# DESPLIEGUE DE LARAVEL (PHP)

</center>


#### **_Introducción_**. <a name="id1"></a>

Esta práctica se centra en el despliegue de una aplicación web utilizando Laravel, un framework de código abierto para desarrollar aplicaciones y servicios web con PHP. Laravel es conocido por sus herramientas eficientes para el desarrollo de aplicaciones. El objetivo principal es desplegar la aplicación TravelRoad, que permite gestionar una lista de lugares visitados y lugares deseados para visitar, utilizando Laravel como framework de desarrollo y PostgreSQL como base de datos.

#### **_URL de Despliegue_**. <a name="id2"></a>

**URL de la aplicación:** https://laravel.antonio.arkania.es

Esta URL corresponde al despliegue en producción de la aplicación TravelRoad utilizando el framework Laravel. El certificado de seguridad SSL ha sido configurado para garantizar conexiones cifradas entre el cliente y el servidor.

#### **_Objetivos_**. <a name="id3"></a>

Los objetivos principales de esta práctica son:

1. **Instalación de Composer**: Instalar el gestor de dependencias de PHP para poder instalar Laravel y sus dependencias.

2. **Configuración de paquetes PHP**: Instalar los módulos PHP necesarios para el funcionamiento de Laravel, incluyendo mbstring, xml, bcmath, curl y pgsql.

3. **Creación del proyecto Laravel**: Generar la estructura del proyecto utilizando composer create-project con el paquete laravel/laravel.

4. **Configuración de PostgreSQL**: Modificar el archivo de configuración .env para conectar Laravel con la base de datos PostgreSQL.

5. **Configuración de Nginx**: Crear el virtual host para servir la aplicación Laravel con el servidor web Nginx.

6. **Personalización de la aplicación**: Modificar las rutas y plantillas para mostrar los datos de lugares visitados y deseados.

7. **Implementación de despliegue automatizado**: Crear scripts de instalación y despliegue para automatizar el proceso de puesta en producción.

#### **_Material empleado_**. <a name="id4"></a>

**Hardware:**

- Sistema operativo Linux (Ubuntu/Debian)
- Equipo de desarrollo con conexión a internet
- Servidor remoto Arkania para el despliegue

**Software:**

- **Sistema operativo**: Linux con interfaz de línea de comandos
- **PHP**: Intérprete de PHP 8.x con módulos necesarios
- **Composer**: Gestor de dependencias de PHP
- **Laravel**: Framework web de PHP (versión 10.x)
- **PostgreSQL**: Sistema de gestión de base de datos relacional
- **Nginx**: Servidor web
- **PHP-FPM**: Procesador de PHP para Nginx

**Dependencias PHP instaladas:**

| Paquete | Descripción |
|---------|-------------|
| mbstring | Gestión de cadenas de caracteres multibyte |
| xml | Análisis XML |
| bcmath | Operaciones matemáticas de precisión arbitraria |
| curl | Cliente de cURL |
| pgsql | Herramientas para PostgreSQL |

#### **_Desarrollo_**. <a name="id5"></a>

**Paso 1: Instalación de Composer**

Composer es el gestor de dependencias estándar para PHP. Se instala mediante el siguiente comando:

```bash
curl -fsSL https://raw.githubusercontent.com/composer/getcomposer.org/main/web/installer \
| php -- --quiet | sudo mv composer.phar /usr/local/bin/composer
```

Verificamos la versión instalada:

```bash
composer --version
```

**Paso 2: Instalación de paquetes de soporte PHP**

Instalamos los módulos PHP necesarios para el funcionamiento de Laravel:

```bash
sudo apt install -y php8.2-mbstring php8.2-xml \
php8.2-bcmath php8.2-curl php8.2-pgsql
```

**Paso 3: Creación del proyecto Laravel**

Generamos la estructura del proyecto TravelRoad:

```bash
composer create-project laravel/laravel travelroad
```

Se crea una carpeta travelroad con el andamiaje completo:

```
travelroad/
├── artisan
├── bootstrap/
├── config/
├── database/
├── public/
├── resources/
├── routes/
├── storage/
├── vendor/
├── composer.json
└── composer.lock
```

**Paso 4: Configuración de la base de datos**

Abrimos el archivo .env y configuramos las credenciales de PostgreSQL:

```
DB_CONNECTION=pgsql
DB_HOST=127.0.0.1
DB_PORT=5432
DB_DATABASE=travelroad
DB_USERNAME=travelroad_user
DB_PASSWORD=dpl0000
```

**Paso 5: Creación del modelo Place**

Creamos el modelo Place en `app/Models/Place.php`:

```php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Place extends Model
{
    use HasFactory;

    protected $table = 'places';
    
    protected $guarded = ['id'];

    protected $casts = [
        'visited' => 'boolean',
    ];
}
```

**Paso 6: Creación de la migración**

Creamos la migración para la tabla places:

```php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('places', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->boolean('visited')->default(false);
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('places');
    }
};
```

**Paso 7: Configuración de rutas**

Modificamos `routes/web.php` para mostrar los lugares utilizando consultas directas a la base de datos:

```php
// https://laravel.com/api/6.x/Illuminate/Support/Facades/DB.html
use Illuminate\Support\Facades\DB;

Route::get('/', function () {
  $wished = DB::select('select * from places where visited = false');
  $visited = DB::select('select * from places where visited = true');

  return view('travelroad', ['wished' => $wished, 'visited' => $visited]);
});
```

**Paso 8: Creación de la plantilla Blade**

Creamos la plantilla `resources/views/travelroad.blade.php` con estilos CSS y el indicador "Powered by Laravel".

#### **_Configuración de Producción_**. <a name="id6"></a>

**Configuración Nginx**

La configuración del virtual host Nginx para Laravel se encuentra en el archivo `nginx_travelroad.conf`:

```nginx
server {
    server_name laravel.antonio.arkania.es;
    root /var/www/travelroad_laravel/public;

    index index.html index.htm index.php;

    charset utf-8;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }
}
```

**Permisos de carpetas**

Ajustamos los permisos para que Nginx y PHP-FPM puedan trabajar sin errores:

```bash
sudo chgrp -R nginx storage bootstrap/cache
sudo chmod -R ug+rwx storage bootstrap/cache
```

**Configuración de la base de datos en producción**

La aplicación utiliza las siguientes variables de entorno en producción:

```
DB_CONNECTION=pgsql
DB_HOST=127.0.0.1
DB_PORT=5432
DB_DATABASE=travelroad
DB_USERNAME=travelroad_user
DB_PASSWORD=dpl0000
```

#### **_Script de Despliegue_**. <a name="id7"></a>

El script `deploy.sh` automatiza el proceso de despliegue en el servidor remoto:

```bash
#!/bin/bash

# Script de despliegue para TravelRoad (Laravel)
# Este script se conecta al servidor remoto y realiza el despliegue

ssh arkania "
  cd /var/www/travelroad_laravel
  git pull
  composer install --no-dev --optimize-autoloader
  php artisan migrate --force
  php artisan config:cache
  php artisan route:cache
"
```
**Script de instalación local**

El script `install.sh` configura el entorno local:

```bash
#!/bin/bash

composer install --no-interaction
php artisan key:generate --ansi
php artisan migrate --force
php artisan config:cache
php artisan route:cache
```

#### **_Conclusiones_**. <a name="id8"></a>

El despliegue de la aplicación TravelRoad utilizando Laravel ha sido completado exitosamente. Los principales logros de esta práctica incluyen:

1. **Framework moderno**: Laravel proporciona una estructura robusta y elegante para el desarrollo de aplicaciones web en PHP, con características como Eloquent ORM, Blade Templates y Artisan CLI.

2. **Integración con PostgreSQL**: La configuración de Laravel para PostgreSQL permite utilizar todas las funcionalidades avanzadas del sistema de gestión de bases de datos, incluyendo tipos de datos específicos y optimizaciones de rendimiento.

3. **Despliegue automatizado**: Los scripts de instalación y despliegue facilitan la puesta en producción de la aplicación y garantizan un proceso reproducible y consistente.

4. **Seguridad**: La configuración de Nginx con PHP-FPM proporciona un entorno seguro para servir aplicaciones PHP, con aislamiento adecuado entre procesos.

5. **Mantenimiento**: La estructura modular de Laravel facilita el mantenimiento y la evolución de la aplicación, con separación clara entre modelos, vistas y controladores.

La aplicación TravelRoad desplegada en https://laravel.antonio.arkania.es demuestra la capacidad de Laravel para crear aplicaciones web completas y funcionales, con una interfaz de usuario mejorada y funcionalidades de gestión de datos robustas.

