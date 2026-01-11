# UT3-TE1: Procesador de Imágenes con ngx_small_light

Esta es la documentación de la práctica UT3-TE1 del módulo de Despliegue de Aplicaciones Web.

## Contenido del proyecto

- `html/` - Aplicación web (HTML, CSS, JavaScript)
- `img/` - Imágenes originales (image01.jpg a image20.jpg)
- `nginx.conf` - Configuración de Nginx con ngx_small_light
- `Dockerfile` - Imagen Docker con Nginx + módulo ngx_small_light
- `docker-compose.yml` - Orquestación del contenedor

## Cómo ejecutarlo

```bash
# Construir y levantar el contenedor
docker-compose up --build

# Ver los contenedores en ejecución
docker ps

# Acceder a la aplicación
# http://images.antonio_dpl:8080
```

## Configuración

- **Dominio:** images.antonio_dpl
- **Puerto HTTP:** 8080
- **Ubicación imágenes:** /var/www/html/img/
- **Módulo:** ngx_small_light para procesamiento de imágenes on-the-fly

## Parámetros de ngx_small_light

La aplicación usa los siguientes parámetros del módulo:

- `small=square,<tamaño>` - Redimensionar a cuadrado
- `small:extborder=<ancho>` - Ancho del borde
- `small:extbordercolor=<color>` - Color del borde (hex)
- `small:radialblur=<radius>x<sigma>` - Enfoque radial
- `small:gaussianblur=<radius>x<sigma>` - Desenfoque gaussiano

## Dockerización

Para dockerizar la aplicación:

```bash
# Acceder al contenedor
docker exec -it ut3-nginx /bin/bash

# Dentro del contenedor, instalar el módulo:
apt update
apt install -y build-essential imagemagick libpcre3 libpcre3-dev libmagickwand-dev
git clone https://github.com/cubicdaiya/ngx_small_light.git
cd ngx_small_light
./setup
./configure --add-dynamic-module=../ngx_small_light --with-compat
make modules
cp objs/ngx_http_small_light_module.so /etc/nginx/modules/

# Exportar el contenedor como imagen
docker export ut3-nginx | docker import - antonio_dpl_small_light:latest
```

## SSL

Para incorporar certificado SSL con Let's Encrypt:

```bash
certbot --nginx -d images.antonio_dpl
```

Esto generará automáticamente la configuración HTTPS y añadirá redirección de www al dominio base.

