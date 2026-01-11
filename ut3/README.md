<center>

# UT3-TE1: Despliegue de Aplicación Web para Procesamiento de Imágenes con Nginx y ngx_small_light

</center>

***Nombre:*** Antonio Navarro Hernández
***Curso:*** 2º de Ciclo Superior de Desarrollo de Aplicaciones Web.

### ÍNDICE

+ [Introducción](#id1)
+ [Objetivos](#id2)
+ [Material empleado](#id3)
+ [Desarrollo](#id4)
+ [Conclusiones](#id5)

#### ***Introducción***. <a name="id1"></a>

El objetivo de esta práctica es desplegar una aplicación web que permite procesar imágenes en tiempo real utilizando el módulo **ngx_small_light** de Nginx. Este módulo es un procesador de imágenes dinámico que permite realizar transformaciones a través de parámetros en la URL, sin necesidad de pre-procesar las imágenes ni almacenarlas en diferentes tamaños.

Todo esto se realiza mediante peticiones al servidor Nginx, modificando simplemente los parámetros de la URL de la imagen.
#### ***Objetivos***. <a name="id2"></a>

Los objetivos que se pretenden alcanzar con esta práctica son:

1. **Instalar y configurar el módulo ngx_small_light** en Nginx de forma dinámica, compilándolo como módulo dinámico
2. **Crear un virtual host** específico para el dominio `images.antonio_dpl`
3. **Habilitar el módulo** ngx_small_light únicamente para el location `/img`, dejando el resto de la web sin procesar
4. **Desarrollar una aplicación web** con formulario HTML/JavaScript para procesar las imágenes
5. **Dockerizar la aplicación** para facilitar su despliegue y portabilidad
6. **Configurar SSL** (opcional) con Let's Encrypt para securizar las conexiones
7. **Redirigir el subdominio www** al dominio base incluyendo SSL

#### ***Material empleado***. <a name="id3"></a>

**Software utilizado:**

- **Sistema operativo:** Ubuntu 20.04 (usado en el contenedor Docker)
- **Servidor web:** Nginx 1.18.0
- **Módulo:** ngx_small_light (https://github.com/cubicdaiya/ngx_small_light)
- **Librerías de procesamiento de imágenes:** ImageMagick 6, libmagickwand-dev
- **Docker y Docker Compose:** Para containerizar la aplicación
- **Git:** Para clonar el código fuente del módulo

**Dependencias instaladas:**

```bash
apt install -y nginx build-essential imagemagick libpcre3 libpcre3-dev libmagickwand-dev git curl
```

**Configuraciones de red:**

- **Dominio configurado:** `images.antonio_dpl`
- **Puerto:** 80 (HTTP)
- **Virtual host:** Configurado en `/etc/nginx/nginx.conf`
- **Raíz web:** `/var/www/html`

**Estructura de archivos:**

```
ut3/
├── index.html          # Formulario web
├── style.css           # Estilos CSS
├── script.js           # Lógica JavaScript
├── nginx.conf          # Configuración Nginx
├── Dockerfile          # Imagen Docker
├── docker-compose.yml  # Orquestación
├── README.md           # Este informe
└── images/             # 20 imágenes (image01.jpg a image20.jpg)
```

#### ***Desarrollo***. <a name="id4"></a>

El desarrollo de esta práctica se ha dividido en varios pasos que detallamos a continuación.

##### Creación de la aplicación web (frontend)

La aplicación web está compuesta por tres archivos que trabajan juntos:

- **index.html** 

- **script.js** 

Ejemplo de URL generada:
```
https://images.antonio_dpl/img/image01.jpg?small=square,300&small:extborder=5&small:extbordercolor=#000000&small:radialblur=0x0&small:gaussianblur=0x0
```

- **style.css** 

##### Configuración de Nginx con ngx_small_light

La configuración de Nginx (`nginx.conf`) incluye:

1. **Carga del módulo dinámico:**
   ```nginx
   load_module /etc/nginx/modules/ngx_http_small_light_module.so;
   ```

2. **Configuración del servidor:**
   ```nginx
   server {
       listen 80;
       server_name images.antonio_dpl;
       root /var/www/html;
       index index.html;
       
       location /img {
           small_light on;
       }
   }
   ```

El módulo solo está habilitado en `/img`, lo que significa que las imágenes se procesarán cuando accedamos a esa ruta, pero el resto de la web (formulario, CSS, JS) se servirá estáticamente sin procesamiento.

##### Paso 4: Dockerfile y Dockerización

El Dockerfile está basado en Ubuntu 20.04 y realiza las siguientes operaciones:

1. Instala todas las dependencias necesarias (nginx, build-essential, imagemagick, etc.)
2. Clona el repositorio de ngx_small_light y ejecuta `./setup`
3. Descarga el código fuente de Nginx y configura la compilación con el módulo dinámico
4. Compila solo el módulo (`make modules`) y lo copia a `/etc/nginx/modules/`
5. Copia las imágenes y los archivos de la aplicación web
6. Expone los puertos 80 y 443

**Dificultad encontrada:** La principal dificultad fue la incompatibilidad entre ngx_small_light e ImageMagick 7. Las versiones modernas de Alpine Linux y Ubuntu 22.04+ incluyen ImageMagick 7 por defecto, que no es compatible con este módulo. La solución fue usar Ubuntu 20.04 que incluye ImageMagick 6.

##### Paso 5: docker-compose.yml

El archivo docker-compose.yml configura el servicio con:
- Nombre del contenedor: `antonio_dpl_small_light`
- Puerto 80 mapeado al host
- Construcción desde el Dockerfile
- Red Bridge para aislamiento

##### Paso 6: Ejecución y pruebas

Para levantar el entorno:
```bash
docker-compose up --build
```

Una vez en marcha, accedemos a `http://localhost` y veremos el formulario. Al pulsar "Generar", aparecerán las 20 imágenes procesadas según los parámetros seleccionados.

#### ***Conclusiones***. <a name="id5"></a>

 En esta práctica he aprendido a desplegar una aplicación web usando nginx y docker, aunque las incompatibilidades entre aplicaciones complicaron bastante la tarea, finalmente logramos darle una solución y hacer que funcionase.