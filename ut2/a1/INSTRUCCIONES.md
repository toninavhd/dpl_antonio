# Instrucciones de Despliegue

## 📍 ubicación de los archivos

- **Entorno Nativo:** `~/calc_native/`
- **Entorno Dockerizado:** `/home/alu/Documentos/dpl_antonio/ut2/a1/calc_docker/`

---

## 🚀 Despliegue Entorno Nativo

### Paso 1: Instalar Nginx y PHP-FPM

```bash
sudo apt update
sudo apt install nginx php-fpm -y
```

### Paso 2: Configurar Nginx

```bash
# Copiar configuración
sudo cp ~/calc_native/nginx.conf /etc/nginx/sites-available/calculadora

# Habilitar sitio
sudo ln -s /etc/nginx/sites-available/calculadora /etc/nginx/sites-enabled/

# Deshabilitar sitio por defecto
sudo unlink /etc/nginx/sites-enabled/default

# Verificar y recargar
sudo nginx -t
sudo systemctl reload nginx

# Dar permisos
sudo chmod -R 755 ~/calc_native/
```

### Paso 3: Acceder a la aplicación

🌐 **URL:** http://localhost

---

## 🐳 Despliegue Entorno Dockerizado

### Paso 1: Verificar que Docker está instalado

```bash
docker --version
docker-compose --version
```

### Paso 2: Construir y ejecutar el contenedor

```bash
cd /home/alu/Documentos/dpl_antonio/ut2/a1/calc_docker/

# Construir imagen
docker build -t calculadora-nginx-php .

# Ejecutar contenedor
docker run -d -p 8017:80 --name calculadora-app calculadora-nginx-php
```

### O usando Docker Compose

```bash
cd /home/alu/Documentos/dpl_antonio/ut2/a1/calc_docker/
docker-compose up -d
```

### Paso 3: Acceder a la aplicación

🌐 **URL:** http://localhost:8017

---

## 🔧 Comandos útiles

### Verificar que Nginx está funcionando

```bash
sudo systemctl status nginx
curl http://localhost
```

### Verificar contenedores Docker

```bash
# Ver contenedores activos
docker ps

# Ver logs
docker logs calculadora-app

# Detener contenedor
docker stop calculadora-app

# Eliminar contenedor
docker rm calculadora-app
```

### Reiniciar Nginx (entorno nativo)

```bash
sudo systemctl restart nginx
```

---

## 📁 Estructura de archivos

```
ut2/a1/
├── calc_native/
│   ├── index.php          # Aplicación PHP
│   ├── calculadora.css    # Estilos
│   ├── calculadora.png    # Imagen
│   └── nginx.conf         # Configuración Nginx
├── calc_docker/
│   ├── Dockerfile         # Imagen Docker
│   ├── docker-compose.yml # Orquestación
│   ├── nginx.conf         # Configuración Nginx
│   ├── index.php          # Aplicación PHP
│   ├── calculadora.css    # Estilos
│   └── calculadora.png    # Imagen
└── README.md              # Documentación
```

---

## ✅ Verificación

| Entorno     | URL                   | Estado |
| ----------- | --------------------- | ------ |
| Nativo      | http://localhost      | [ ]    |
| Dockerizado | http://localhost:8017 | [ ]    |

**Puesto de trabajo:** 17 → Puerto Docker: 8017
