# UT3-TE1: Despliegue de Aplicación Web para Procesamiento de Imágenes con Nginx y ngx_small_light

<center>

***Nombre:*** Antonio Navarro Hernández
***Curso:*** 2º de Ciclo Superior de Desarrollo de Aplicaciones Web.

</center>

## 📋 ÍNDICE

+ [Introducción](#id1)
+ [Objetivos](#id2)
+ [Material empleado](#id3)
+ [Desarrollo](#id4)
+ [Dockerización](#id5)
+ [Permisos (CORREGIDO)](#id6)
+ [Exportar contenedor](#id7)
+ [Conclusiones](#id8)

---

## 1. INTRODUCCIÓN <a name="id1"></a>

El objetivo de esta práctica es desplegar una aplicación web que permite procesar imágenes en tiempo real utilizando el módulo **ngx_small_light** de Nginx. Este módulo es un procesador de imágenes dinámico que permite realizar transformaciones a través de parámetros en la URL, sin necesidad de pre-procesar las imágenes ni almacenarlas en diferentes tamaños.

Todo esto se realiza mediante peticiones al servidor Nginx, modificando simplemente los parámetros de la URL de la imagen.

---

## 2. OBJETIVOS <a name="id2"></a>

Los objetivos que se pretenden alcanzar con esta práctica son:

1. **Instalar y configurar el módulo ngx_small_light** en Nginx de forma dinámica, compilándolo como módulo dinámico
2. **Crear un virtual host** específico para el dominio `images.antonio.me`
3. **Habilitar el módulo** ngx_small_light únicamente para el location `/img`, dejando el resto de la web sin procesar
4. **Desarrollar una aplicación web** con formulario HTML/JavaScript para procesar las imágenes
5. **Dockerizar la aplicación** para facilitar su despliegue y portabilidad
6. **Configurar SSL** con certificado autofirmado para securizar las conexiones
7. **Redirigir el subdominio www** al dominio base incluyendo SSL
8. **CORREGIDO:** Configurar permisos correctos para el funcionamiento de ngx_small_light

---

## 3. MATERIAL EMPLEADO <a name="id3"></a>

### Software utilizado:

- **Sistema operativo:** Ubuntu 20.04 (usado en el contenedor Docker)
- **Servidor web:** Nginx 1.18.0
- **Módulo:** ngx_small_light (https://github.com/cubicdaiya/ngx_small_light)
- **Librerías de procesamiento de imágenes:** ImageMagick 6, libmagickwand-dev
- **Docker y Docker Compose:** Para containerizar la aplicación
- **Git:** Para clonar el código fuente del módulo

### Dependencias instaladas:

```bash
apt install -y nginx build-essential imagemagick libpcre3 libpcre3-dev libmagickwand-dev git curl openssl
```

### Configuraciones de red:

- **Dominio configurado:** `images.antonio.me`
- **Puertos:** 80 (HTTP) y 443 (HTTPS)
- **Virtual host:** Configurado en `/etc/nginx/nginx.conf`
- **Raíz web:** `/var/www/html`
- **Certificado SSL:** Autofirmado en `/etc/nginx/ssl/`

---

## 4. DESARROLLO <a name="id4"></a>

### 4.1 Instalación del módulo ngx_small_light

El módulo ngx_small_light requiere ser compilado junto con Nginx. Los pasos realizados en el Dockerfile son:

1. Instalar dependencias necesarias:
```bash
apt install -y build-essential imagemagick libpcre3 libpcre3-dev libmagickwand-dev
```

2. Clonar y configurar el módulo:
```bash
git clone https://github.com/cubicdaiya/ngx_small_light.git
cd ngx_small_light
./setup
```

3. Compilar el módulo como módulo dinámico de Nginx:
```bash
./configure --add-dynamic-module=../ngx_small_light --with-compat
make modules
cp objs/ngx_http_small_light_module.so /etc/nginx/modules/
```

### 4.2 Creación de la aplicación web (frontend)

La aplicación web está compuesta por tres archivos:

- **index.html**: Formulario con campos para tamaño, borde, color, enfoque y desenfoque
- **script.js**: Genera las URLs con parámetros de ngx_small_light
- **style.css**: Estilos para la galería de imágenes

Ejemplo de URL generada por ngx_small_light:
```
https://images.antonio.me/img/image01.jpg?small=square,300&small:extborder=5&small:extbordercolor=#000000&small:radialblur=0x0&small:gaussianblur=0x0
```

### 4.3 Configuración de Nginx con SSL

La configuración de Nginx incluye:

1. **Carga del módulo dinámico:**
```nginx
load_module /etc/nginx/modules/ngx_http_small_light_module.so;
```

2. **Servidor HTTP con redirección a HTTPS:**
```nginx
server {
    listen 80;
    server_name images.antonio.me www.images.antonio.me;
    return 301 https://images.antonio.me$request_uri;
}
```

3. **Servidor HTTPS con certificado:**
```nginx
server {
    listen 443 ssl;
    server_name images.antonio.me;
    
    ssl_certificate /etc/nginx/ssl/server.crt;
    ssl_certificate_key /etc/nginx/ssl/server.key;
    
    location /img {
        small_light on;
    }
}
```

El módulo solo está habilitado en `/img`, lo que significa que las imágenes se procesarán cuando accedamos a esa ruta, pero el resto de la web (formulario, CSS, JS) se servirá estáticamente sin procesamiento.

---

## 5. DOCKERIZACIÓN <a name="id5"></a>

### 5.1 Dockerfile

El Dockerfile está basado en Ubuntu 20.04 y realiza las siguientes operaciones:

1. Instala todas las dependencias necesarias (nginx, build-essential, imagemagick, openssl, etc.)
2. Clona el repositorio de ngx_small_light y ejecuta `./setup`
3. Descarga el código fuente de Nginx y configura la compilación con el módulo dinámico
4. Compila solo el módulo (`make modules`) y lo copia a `/etc/nginx/modules/`
5. Genera un certificado SSL autofirmado con openssl
6. Copia las imágenes y los archivos de la aplicación web
7. **CORREGIDO:** Configura todos los permisos necesarios para el usuario nginx
8. **NUEVO:** Usa un entrypoint que verifica permisos al iniciar
9. Expone los puertos 80 y 443

**Nota:** Se usa Ubuntu 20.04 porque incluye ImageMagick 6, que es compatible con ngx_small_light. Las versiones más recientes de Ubuntu incluyen ImageMagick 7, que no es compatible.

### 5.2 docker-compose.yml

El archivo docker-compose.yml configura el servicio con:
- **Nombre del contenedor:** `antonio_small_light`
- **Puertos:** 80 y 443 mapeados al host
- **Construcción:** Desde el Dockerfile
- **Red:** Bridge para aislamiento
- **Reinicio:** Automático (`restart: unless-stopped`)
- **Usuario:** root (para evitar problemas de permisos)

### 5.3 Ejecución y pruebas

Para levantar el entorno:
```bash
cd ut3
chmod +x deploy.sh
./deploy.sh all
```

Para detener el entorno:
```bash
./deploy.sh stop
```

Una vez en marcha, accedemos a `https://images.antonio.me` y veremos el formulario. Al pulsar "Generar", aparecerán las 20 imágenes procesadas según los parámetros seleccionados.

---

## 6. PERMISOS <a name="id6"></a>

### 6.1 Problema de Permisos

El módulo ngx_small_light puede fallar si el usuario `nginx` no tiene acceso a:
- Directorios de imágenes
- Directorio temporal para procesamiento
- Módulos de nginx
- Archivos de logs
- Certificados SSL

### 6.2 Scripts de Permisos Creados

Se han creado varios scripts para solucionar los problemas de permisos:

#### **deploy.sh** - Script principal de despliegue
```bash
cd ut3
chmod +x deploy.sh
./deploy.sh all  # Construye e inicia el contenedor con permisos correctos
```

#### **fix_permissions.sh** - Script para servidor local (sin Docker)
```bash
cd ut3
chmod +x fix_permissions.sh
sudo bash fix_permissions.sh
sudo systemctl restart nginx
```

#### **entrypoint.sh** - Script que se ejecuta al iniciar el contenedor
```bash
# Se ejecuta automáticamente cuando el contenedor inicia
# Configura todos los permisos necesarios para el usuario nginx
```

#### **test_ngx_small_light.sh** - Script de pruebas
```bash
cd ut3
chmod +x test_ngx_small_light.sh
./test_ngx_small_light.sh
```

### 6.3 Configuración ImageMagick

Se ha configurado ImageMagick 6 con políticas permisivas para permitir el procesamiento:

```xml
<policymap>
  <policy domain="resource" name="memory" value="512MiB"/>
  <policy domain="resource" name="map" value="1GiB"/>
  <policy domain="resource" name="width" value="32KP"/>
  <policy domain="resource" name="height" value="32KP"/>
  <policy domain="resource" name="area" value="256MB"/>
  <policy domain="resource" name="disk" value="2GiB"/>
  <policy domain="coder" rights="read|write" pattern="*" />
  <policy domain="filter" rights="read|write" pattern="*" />
  <policy domain="delegate" rights="read|write" pattern="*" />
  <policy domain="path" rights="read|write" pattern="@*" />
</policymap>
```

### 6.4 Verificación de Funcionamiento

```bash
# Verificar estado del contenedor
./deploy.sh status

# Ver logs
./deploy.sh logs

# Ejecutar tests
./test_ngx_small_light.sh

# Acceder al contenedor
./deploy.sh shell
```

---

## 7. EXPORTAR CONTENEDOR <a name="id7"></a>

Para exportar el contenedor configurado como una nueva imagen y compartirlo:

1. **Verificar el nombre del contenedor:**
```bash
docker ps
```

1. **Crear una imagen a partir del contenedor:**
```bash
docker commit antonio_small_light antonio_small_light:latest
```

1. **Guardar la imagen en un archivo tar:**
```bash
docker save -o antonio_small_light.tar antonio_small_light:latest
```

1. **En otro equipo, cargar la imagen:**
```bash
docker load -i antonio_small_light.tar
```

1. **Ejecutar el contenedor desde la imagen exportada:**
```bash
docker run -d -p 80:80 -p 443:443 --name antonio_small_light_instance antonio_small_light:latest
```

**También se puede usar docker-compose para restaurar:**
```bash
docker-compose up -d
```

### Compartir con compañeros

Para compartir el contenedor con un compañero:
1. Envía el archivo `antonio_small_light.tar` (puede ser por email, Drive, etc.)
2. Tu compañero ejecuta:
   - `docker load -i antonio_small_light.tar`
   - `docker run -d -p 80:80 -p 443:443 --name antonio_small_light antonio_small_light:latest`

---

## 8. CONCLUSIONES <a name="id8"></a>

En esta práctica he aprendido a desplegar una aplicación web usando nginx y docker. La principal dificultad fue:

1. **La incompatibilidad entre ngx_small_light e ImageMagick 7**, que se resolvió usando Ubuntu 20.04.

2. **Los problemas de permisos del módulo ngx_small_light**

También he aprendido a:
- Compilar módulos dinámicos para Nginx
- Configurar HTTPS con certificados SSL autofirmados
- Redirigir tráfico HTTP a HTTPS
- Redirigir subdominios www al dominio base
- Dockerizar aplicaciones web
- Exportar e importar contenedores Docker para compartir con compañeros
- Diagnosticar y solucionar problemas de permisos en contenedores Docker

---

## INICIO RÁPIDO CON SCRIPT

```bash
# 1. Navegar al directorio
cd ut3

# 2. Hacer ejecutables los scripts
chmod +x deploy.sh fix_permissions.sh entrypoint.sh test_ngx_small_light.sh

# 3. Desplegar
./deploy.sh all

# 4. Verificar
./test_ngx_small_light.sh

# 5. Acceder a la aplicación
# https://images.antonio.me
```

---


