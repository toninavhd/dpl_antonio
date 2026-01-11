<center>

# Implantación de Calculadora PHP con Nginx + PHP-FPM

</center>

**_Alumno:_** Antonio Navarro Hernandez
**_Curso:_** 2º de Ciclo Superior de Desarrollo de Aplicaciones Web

---

### ÍNDICE

- [Introducción](#id1)
- [Objetivos](#id2)
- [Material empleado](#id3)
- [Desarrollo](#id4)
  - [Entorno Nativo](#id4-1)
  - [Entorno Dockerizado](#id4-2)
- [Conclusiones](#id5)

---

## **1. Introducción** <a name="id1"></a>

Esta práctica consiste en desplegar una aplicación PHP que funciona como calculadora utilizando el servidor web Nginx junto con PHP-FPM. Se implementarán dos entornos de despliegue:

1. **Entorno Nativo**: Instalación directa en el sistema operativo
2. **Entorno Dockerizado**: Contenedor Docker con Nginx + PHP-FPM

Ambas implementaciones permitirán realizar operaciones matemáticas básicas (suma, resta, multiplicación y división) a través de una interfaz web intuitiva.

---

## **2. Objetivos** <a name="id2"></a>

Los objetivos de esta práctica son:

-  Configurar Nginx como servidor web para servir aplicaciones PHP
-  Integrar PHP-FPM para el procesamiento de scripts PHP
-  Crear una aplicación funcional de calculadora con interfaz web
-  Aplicar estilos CSS para una presentación visual adecuada
-  Desplegar la aplicación en un entorno nativo (localhost:80)
-  Dockerizar la aplicación usando Dockerfile personalizado
-  Exponer la aplicación dockerizada en el puerto 8017 (puesto 17)
-  Documentar todo el proceso de instalación y configuración

---

## **3. Material empleado** <a name="id3"></a>

### **3.1 Software utilizado**

| Software       | Versión   | Propósito                    |
| -------------- | --------- | ---------------------------- |
| Ubuntu         | 22.04 LTS | Sistema operativo            |
| Nginx          | Latest    | Servidor web HTTP            |
| PHP-FPM        | Latest    | Procesador de PHP            |
| Docker         | Latest    | Plataforma de contenedores   |
| Docker Compose | Latest    | Orquestación de contenedores |

### **3.2 Hardware**

- Ordenador personal con capacidad de virtualización
- Conexión a internet para descargas de paquetes

### **3.3 Archivos del proyecto**

La estructura del proyecto es:

```
ut2/a1/
├── calc_native/
│   ├── index.php          # Aplicación PHP (entorno nativo)
│   ├── calculadora.css    # Estilos CSS
│   ├── calculadora.png    # Imagen de la calculadora
│   └── nginx.conf         # Configuración Nginx nativo
├── calc_docker/
│   ├── Dockerfile         # Imagen Docker personalizada
│   ├── docker-compose.yml # Orquestación de contenedores
│   ├── nginx.conf         # Configuración Nginx Docker
│   ├── index.php          # Aplicación PHP (dockerizada)
│   ├── calculadora.css    # Estilos CSS
│   └── calculadora.png    # Imagen de la calculadora
└── README.md              # Este documento
```

---

## **4. Desarrollo** <a name="id4"></a>

### **4.1 Entorno Nativo** <a name="id4-1"></a>

#### **4.1.1 Instalación de Nginx y PHP-FPM**

Primero, actualizamos el sistema e instalamos los paquetes necesarios:

```bash
# Actualizar repositorios
sudo apt update

# Instalar Nginx
sudo apt install nginx -y

# Instalar PHP-FPM
sudo apt install php-fpm -y

# Verificar instalación
nginx -v
php-fpm -v
```


#### **4.1.2 Creación de la estructura de carpetas**

```bash
# Crear directorio de la aplicación
mkdir -p ~/calc_native

# Verificar creación
ls -la ~/calc_native/
```


#### **4.1.3 Archivos de la aplicación**

Se han creado los siguientes archivos en `~/calc_native/`:

**index.php**: Contiene la lógica de la calculadora con las operaciones:

- Suma (+)
- Resta (-)
- Multiplicación (×)
- División (÷)

#### **4.1.4 Configuración de Nginx**

Creamos el archivo de configuración del VirtualHost:

```bash
# Copiar configuración
sudo cp nginx.conf /etc/nginx/sites-available/calculadora

# Habilitar el sitio
sudo ln -s /etc/nginx/sites-available/calculadora /etc/nginx/sites-enabled/

# Deshabilitar sitio por defecto
sudo unlink /etc/nginx/sites-enabled/default

# Verificar sintaxis
sudo nginx -t

# Recargar Nginx
sudo systemctl reload nginx
```


#### **4.1.5 Configuración de permisos**

```bash
# Dar permisos de lectura
sudo chmod -R 755 ~/calc_native/

# Verificar funcionamiento
curl http://localhost
```

#### **4.1.6 Verificación en navegador**

Accedemos a: **http://localhost**

---
![Calculadora_nativa](img/ut2/a1/img/calc.png)


### **4.2 Entorno Dockerizado** <a name="id4-2"></a>

#### **4.2.1 Estructura del Dockerfile**

El Dockerfile está basado en `nginx:alpine` e incluye:

```dockerfile
FROM nginx:alpine

# Instalar PHP-FPM
RUN apk add --no-cache php-fpm php-curl php-json php-mbstring

# Crear directorio de trabajo
RUN mkdir -p /var/www/html

# Copiar archivos de la aplicación
COPY index.php /var/www/html/
COPY calculadora.css /var/www/html/
COPY calculadora.png /var/www/html/

# Copiar configuración Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exponer puerto 80
EXPOSE 80

# Comandos de inicio
CMD ["sh", "-c", "php-fpm -D && nginx -g 'daemon off;'"]
```

#### **4.2.2 Configuración de Nginx para Docker**

```nginx
server {
    listen 80;
    server_name localhost;
    root /var/www/html;
    index index.php index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_index index.php;
    }
}
```

#### **4.2.3 Docker Compose**

Para facilitar el despliegue, se ha creado `docker-compose.yml`:

```yaml
version: "3.8"

services:
  web:
    build: .
    ports:
      - "8017:80"
    container_name: calculadora-nginx-php
    restart: always
```

#### **4.2.4 Construcción y ejecución del contenedor**

```bash
# Navegar al directorio
cd /home/alu/Documentos/dpl_antonio/ut2/a1/calc_docker

# Construir la imagen
docker build -t calculadora-nginx-php .

# Verificar creación de imagen
docker images | grep calculadora

# Ejecutar el contenedor
docker run -d -p 8017:80 --name calculadora-app calculadora-nginx-php
```

#### **4.2.5 Verificación**

```bash
# Verificar que el contenedor está ejecutándose
docker ps

# Probar conexión
curl http://localhost:8017
```

#### **4.2.6 Verificación en navegador**

Accedemos a: **http://localhost:8017**


---

## **5. Conclusiones** <a name="id5"></a>

Hemos aprendido a crear una calculadora php implementando nginx y docker para su despliegue y correcto funcionamiento en cualquier máquina. Aunque su configuración me fue algo complicada, es innegable la utilidad que tiene para compartir aplicaciones y desplegarlas sin necesidad de tener cada una de las dependencias.

