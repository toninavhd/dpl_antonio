<center>

# DESPLIEGUE DE APLICACIÓN WEB PARA PROCESAMIENTO DE IMÁGENES CON NGINX Y ngx_small_light

</center>

**_Nombre:_** Antonio Navarro Hernández
**_Curso:_** 2º de Ciclo Superior de Desarrollo de Aplicaciones Web.

### ÍNDICE

- [Introducción](#id1)
- [Objetivos](#id2)
- [Material empleado](#id3)
- [Desarrollo](#id4)
- [Conclusiones](#id5)

#### **_Introducción_**. <a name="id1"></a>

En esta práctica vamos a desplegar una aplicación web que permite el procesamiento de imágenes "on the fly" utilizando el módulo **ngx_small_light** de Nginx. Este módulo es un processor de imágenes dinámico que permite realizar transformaciones a las imágenes a través de parámetros en la URL, sin necesidad de pre-procesarlas ni almacenarlas en diferentes tamaños.

El módulo ngx_small_light nos permite realizar operaciones como:

- Redimensionado de imágenes
- Aplicación de bordes
- Conversión de formatos
- Ajustes de color
- Efectos de desenfoque/enfoque

Todo esto se realiza mediante peticiones GET al servidor Nginx, modificando simplemente los parámetros de la URL de la imagen.

#### **_Objetivos_**. <a name="id2"></a>

Los objetivos que se pretenden alcanzar con esta práctica son:

1. **Instalar y configurar el módulo ngx_small_light** en Nginx de forma dinámica
2. **Crear un virtual host** específico para el dominio `images.toninavhd.me`
3. **Habilitar el módulo** ngx_small_light únicamente para el location `/img`
4. **Desarrollar una aplicación web** con formulario para procesar imágenes
5. **Implementar certificado SSL** con Let's Encrypt
6. **Configurar redirección** del subdominio www al dominio base
7. **Dockerizar la aplicación** para facilitar su despliegue

#### **_Material empleado_**. <a name="id3"></a>

**Software utilizado:**

- Sistema operativo: Linux (distribución basada en Debian/Ubuntu)
- Servidor web: Nginx
- Módulo: ngx_small_light (https://github.com/cubicdaiya/ngx_small_light)
- Herramientas de desarrollo: Git, build-essential, imagemagick
- Certbot para certificados SSL de Let's Encrypt
- Docker y Docker Compose (para dockerizar la aplicación)

**Dependencias instaladas:**

```bash
sudo apt install -y build-essential imagemagick libpcre3 libpcre3-dev libmagickwand-dev
```

**Configuraciones de red:**

- Dominio configurado: `images.toninavhd.me`
- Puerto 80 (HTTP) y 443 (HTTPS)
- Virtual host en `/etc/nginx/conf.d/images.conf`

#### **_Desarrollo_**. <a name="id4"></a>

### Paso 1: Instalación del módulo ngx_small_light

**Captura de pantalla del proceso de instalación de dependencias:**

_(Aquí se debe capturar la terminal mostrando la instalación de las dependencias con sudo apt install)_

**Explicación:** Primero instalamos todas las dependencias necesarias para compilar el módulo:

- `build-essential`: Herramientas de compilación (gcc, make, etc.)
- `imagemagick`: Librería para manipulación de imágenes
- `libpcre3` y `libpcre3-dev`: Librería de expresiones regulares
- `libmagickwand-dev`: Interfaz de desarrollo para ImageMagick

**Captura de pantalla de la descarga del código fuente del módulo:**

_(Aquí se debe capturar la terminal mostrando el git clone del módulo)_

**Comando ejecutado:**

```bash
git clone https://github.com/cubicdaiya/ngx_small_light.git
```

**Captura de pantalla de la configuración del módulo:**

_(Aquí se debe capturar la terminal mostrando la ejecución de ./setup dentro de la carpeta del módulo)_

**Explicación:** Una vez descargado el código fuente del módulo, entramos en su carpeta y ejecutamos `./setup` para preparar la configuración del módulo antes de compilar Nginx.

### Paso 2: Descarga y compilación del módulo para Nginx

**Captura de pantalla del proceso de configuración:**

_(Aquí se debe capturar la terminal mostrando el proceso de ./configure con el módulo añadido)_

**Comandos ejecutados:**

```bash
cd /tmp/nginx-1.xx.x
./configure --add-dynamic-module=../ngx_small_light --with-compat
make modules
sudo cp objs/ngx_http_small_light_module.so /etc/nginx/modules/
```

**Explicación:** Descargamos el código fuente de Nginx con la misma versión instalada en el sistema, configuramos la compilación añadiendo el módulo ngx_small_light como módulo dinámico, generamos el archivo `.so` y lo copiamos a la carpeta de módulos de Nginx.

### Paso 3: Configuración de Nginx para cargar el módulo

**Captura de pantalla del archivo nginx.conf modificado:**

_(Aquí se debe capturar el contenido del archivo /etc/nginx/nginx.conf mostrando la línea load_module)_

**Modificación realizada en `/etc/nginx/nginx.conf`:**

```nginx
load_module /etc/nginx/modules/ngx_http_small_light_module.so;

user nginx;
worker_processes auto;
...
```

**Captura de pantalla de la verificación de sintaxis:**

_(Aquí se debe capturar la salida de sudo nginx -t)_

**Explicación:** Añadimos la directiva `load_module` al principio del archivo de configuración principal de Nginx para cargar dinámicamente el módulo ngx_small_light. Verificamos que la sintaxis es correcta antes de recargar el servicio.

### Paso 4: Creación del virtual host

**Captura de pantalla de la configuración del virtual host:**

_(Aquí se debe capturar el contenido del archivo /etc/nginx/conf.d/images.conf)_

**Archivo de configuración creado `/etc/nginx/conf.d/images.conf`:**

```nginx
server {
    server_name images.toninavhd.me;
    root /home/usuario/www/images;
    index index.html;

    # Configuración SSL (después de certbot)
    listen 443 ssl;
    ssl_certificate /etc/letsencrypt/live/images.toninavhd.me/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/images.toninavhd.me/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    location /img {
        small_light on;
        small_light_pixelate off;
        small_light_radblur 0x0;
        small_light_contrast 0;
        small_light_saturation 0;
        small_light_hue 0;
        small_light_brightness 0;
    }
}

# Redirección de www al dominio base
server {
    listen 80;
    server_name www.images.toninavhd.me;
    return 301 https://images.toninavhd.me$request_uri;
}
```

**Captura de pantalla de la verificación del virtual host:**

_(Aquí se debe capturar la salida de sudo nginx -t después de crear el virtual host)_

### Paso 5: Subida de imágenes

**Captura de pantalla de las imágenes en la carpeta:**

_(Aquí se debe capturar la salida de ls -la ~/www/images/ mostrando las 20 imágenes)_

**Explicación:** Las 20 imágenes (image01.jpg a image20.jpg) ya están disponibles en la carpeta `ut3/images/` del repositorio. Se deben copiar a la carpeta de trabajo del servidor web.

### Paso 6: Creación de la aplicación web

**Captura de pantalla del archivo HTML:**

_(Aquí se debe capturar el contenido del archivo index.html)_

**Archivo `index.html` creado:**

```html
<!DOCTYPE html>
<html lang="es">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Procesador de Imágenes - ngx_small_light</title>
    <link rel="stylesheet" href="style.css" />
  </head>
  <body>
    <h1>Procesador de Imágenes con ngx_small_light</h1>

    <form id="imageForm">
      <div class="form-group">
        <label for="size">Tamaño de la imagen (píxeles):</label>
        <input
          type="number"
          id="size"
          name="size"
          value="300"
          min="50"
          max="800"
        />
      </div>

      <div class="form-group">
        <label for="border">Ancho del borde (píxeles):</label>
        <input
          type="number"
          id="border"
          name="border"
          value="5"
          min="0"
          max="50"
        />
      </div>

      <div class="form-group">
        <label for="borderColor">Color del borde (formato hexadecimal):</label>
        <input
          type="color"
          id="borderColor"
          name="borderColor"
          value="#000000"
        />
      </div>

      <div class="form-group">
        <label for="focus">Enfoque (formato radius x sigma):</label>
        <input
          type="text"
          id="focus"
          name="focus"
          placeholder="0x0"
          value="0x0"
        />
      </div>

      <div class="form-group">
        <label for="blur">Desenfoque (formato radius x sigma):</label>
        <input
          type="text"
          id="blur"
          name="blur"
          placeholder="0x0"
          value="0x0"
        />
      </div>

      <button type="submit">Generar</button>
    </form>

    <div class="images-container">
      <h2>Galería de Imágenes</h2>
      <div id="gallery" class="gallery">
        <!-- Las imágenes se generarán aquí -->
      </div>
    </div>

    <script src="script.js"></script>
  </body>
</html>
```

**Captura de pantalla del archivo JavaScript:**

_(Aquí se debe capturar el contenido del archivo script.js)_

**Archivo `script.js` creado:**

```javascript
document.getElementById("imageForm").addEventListener("submit", function (e) {
  e.preventDefault();

  const size = document.getElementById("size").value;
  const border = document.getElementById("border").value;
  const borderColor = document.getElementById("borderColor").value;
  const focus = document.getElementById("focus").value;
  const blur = document.getElementById("blur").value;

  const gallery = document.getElementById("gallery");
  gallery.innerHTML = "";

  // Generar las 20 imágenes con los parámetros
  for (let i = 1; i <= 20; i++) {
    const imgNum = i.toString().padStart(2, "0");
    const img = document.createElement("img");

    // Construir URL con parámetros de ngx_small_light
    const baseUrl = `https://images.toninavhd.me/img/image${imgNum}.jpg`;
    const params = new URLSearchParams({
      small: `square,${size}`,
      "small:extborder": border,
      "small:extbordercolor": borderColor,
      "small:radialblur": focus,
      "small:gaussianblur": blur,
    });

    img.src = `${baseUrl}?${params.toString()}`;
    img.alt = `Imagen ${imgNum}`;
    img.title = `Imagen ${imgNum}`;

    gallery.appendChild(img);
  }
});

// Generar imágenes al cargar la página
document.getElementById("imageForm").dispatchEvent(new Event("submit"));
```

**Captura de pantalla del archivo CSS:**

_(Aquí se debe capturar el contenido del archivo style.css)_

**Archivo `style.css` creado:**

```css
body {
  font-family: Arial, sans-serif;
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
  background-color: #f5f5f5;
}

h1 {
  color: #333;
  text-align: center;
}

form {
  background: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  margin-bottom: 20px;
}

.form-group {
  margin-bottom: 15px;
}

label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
}

input[type="number"],
input[type="text"],
input[type="color"] {
  width: 100%;
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
}

button {
  background-color: #4caf50;
  color: white;
  padding: 10px 20px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 16px;
}

button:hover {
  background-color: #45a049;
}

.gallery {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  justify-content: center;
}

.gallery img {
  border: 1px solid #ddd;
  border-radius: 4px;
  padding: 5px;
  transition: transform 0.3s;
}

.gallery img:hover {
  transform: scale(1.05);
}
```

**Captura de pantalla de la aplicación web en funcionamiento:**

_(Aquí se debe capturar una captura de pantalla del navegador mostrando la aplicación web con las imágenes procesadas)_

### Paso 7: Obtención del certificado SSL

**Captura de pantalla del proceso de certbot:**

_(Aquí se debe capturar la terminal mostrando la ejecución de sudo certbot --nginx)_

**Comando ejecutado:**

```bash
sudo certbot --nginx -d images.toninavhd.me -d www.images.toninavhd.me
```

**Captura de pantalla del certificado:**

_(Aquí se debe capturar una imagen del certificado SSL en el navegador)_

**Explicación:** Ejecutamos Certbot con el plugin de Nginx para obtener y configurar automáticamente los certificados SSL de Let's Encrypt para nuestro dominio. El proceso incluye:

1. Validación del dominio mediante desafío HTTP-01
2. Generación del certificado
3. Configuración automática del virtual host con SSL
4. Configuración de redirección de HTTP a HTTPS

### Paso 8: Dockerización de la aplicación

**Captura de pantalla del Dockerfile:**

_(Aquí se debe capturar el contenido del Dockerfile)_

**Dockerfile creado:**

```dockerfile
FROM nginx:alpine

# Instalar dependencias necesarias
RUN apk add --no-cache build-base imagemagick git pcre-dev libmagickwand-dev

# Crear directorio de trabajo
WORKDIR /tmp

# Clonar y configurar ngx_small_light
RUN git clone https://github.com/cubicdaiya/ngx_small_light.git && \
    cd ngx_small_light && \
    ./setup

# Descargar código fuente de Nginx
ENV NGINX_VERSION 1.22.0
RUN curl -sL https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz | tar -xz && \
    cd nginx-${NGINX_VERSION} && \
    ./configure --add-dynamic-module=../ngx_small_light --with-compat && \
    make modules && \
    cp objs/ngx_http_small_light_module.so /etc/nginx/modules/ && \
    cd / && rm -rf /tmp/ngx_small_light /tmp/nginx-${NGINX_VERSION}

# Copiar configuración de Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Crear estructura de directorios
RUN mkdir -p /usr/share/nginx/html/img

# Copiar imágenes
COPY images/ /usr/share/nginx/html/img/

# Copiar aplicación web
COPY html/ /usr/share/nginx/html/

# Exponer puertos
EXPOSE 80 443

# Comando de inicio
CMD ["nginx", "-g", "daemon off;"]
```

**Captura de pantalla del archivo nginx.conf:**

_(Aquí se debe capturar el contenido del archivo nginx.conf con la configuración del módulo)_

**Archivo nginx.conf para Docker:**

```nginx
load_module /etc/nginx/modules/ngx_http_small_light_module.so;

user nginx;
worker_processes auto;

error_log /var/log/nginx/error.log notice;
pid /var/run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    sendfile on;
    keepalive_timeout 65;

    server {
        listen 80;
        server_name images.toninavhd.me;
        root /usr/share/nginx/html;
        index index.html;

        location /img {
            small_light on;
        }
    }
}
```

**Captura de pantalla del docker-compose.yml:**

_(Aquí se debe capturar el contenido del docker-compose.yml)_

**Archivo docker-compose.yml:**

```yaml
version: "3.8"

services:
  nginx:
    build: .
    container_name: toninavhd_small_light
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    networks:
      - app-network

networks:
  app-network:
    driver: bridge
```

**Captura de pantalla de la construcción de la imagen Docker:**

_(Aquí se debe capturar la terminal mostrando docker-compose build)_

**Captura de pantalla del contenedor en ejecución:**

_(Aquí se debe capturar la salida de docker ps)_

**Exportar el contenedor como imagen:**

```bash
docker export toninavhd_small_light | docker import - toninavhd_small_light:latest
```

**Captura de pantalla de la imagen exportada:**

_(Aquí se debe capturar la salida de docker images)_

#### **_Conclusiones_**. <a name="id5"></a>

El desarrollo de esta práctica ha permitido adquirir conocimientos avanzados en la administración de servidores web Nginx, particularmente en:

1. **Instalación de módulos dinámicos**: Se ha aprendido el proceso completo de compilación e instalación de módulos de terceros en Nginx, desde la instalación de dependencias hasta la configuración y carga del módulo.

2. **Procesamiento de imágenes on-the-fly**: El módulo ngx_small_light ofrece una solución eficiente para el procesamiento de imágenes sin necesidad de pre-generar múltiples versiones de cada imagen, lo que ahorro de almacenamiento.

3. **Configuración de virtual hosts**: Se ha profundizado en la creación y configuración de hosts virtuales en Nginx, incluyendo la gestión de múltiples dominios y subdominios.

4. **Seguridad web con SSL**: La implementación de certificados con Let's Encrypt y Certbot ha demostrado lo sencillo que es actualmente securizar un sitio web.

5. **Dockerización de aplicaciones**: La containerización de la aplicación facilita enormemente el despliegue y la portabilidad, permitiendo que cualquier compañero pueda desplegar la aplicación con un simple comando.

En definitiva, esta práctica ha integrado múltiples tecnologías y conceptos fundamentales en el desarrollo y despliegue de aplicaciones web modernas.
