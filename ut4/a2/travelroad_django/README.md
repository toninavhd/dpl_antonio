# TravelRoad - Django Application

Aplicación web de lista de lugares visitados y por visitar, desarrollada con Django y PostgreSQL.

## Requisitos

- Python 3.x
- PostgreSQL
- pip

## Instalación

1. Clonar el repositorio:
```bash
git clone <repository_url>
cd travelroad_django
```

2. Crear entorno virtual:
```bash
python -m venv .venv
source .venv/bin/activate  # Linux/Mac
# .venv\Scripts\activate  # Windows
```

3. Instalar dependencias:
```bash
pip install -r requirements.txt
```

4. Configurar variables de entorno:
```bash
cp .env.example .env
# Editar .env con la configuración adecuada
```

5. Ejecutar migraciones:
```bash
./manage.py migrate
```

6. Arrancar el servidor de desarrollo:
```bash
./manage.py runserver
```

La aplicación estará disponible en `http://localhost:8000`

## Producción

### Script de inicio (run.sh)

El script `run.sh` inicia Gunicorn con el socket UNIX:

```bash
./run.sh
```

### Despliegue (deploy.sh)

El script `deploy.sh` conecta por SSH al servidor y realiza el despliegue:

```bash
./deploy.sh
```

### Configuración de Supervisor

Copiar el archivo de configuración:

```bash
sudo cp supervisor_travelroad.conf /etc/supervisor/conf.d/travelroad.conf
sudo supervisorctl reread
sudo supervisorctl add travelroad
```

### Configuración de Nginx

Copiar el archivo de configuración:

```bash
sudo cp nginx_travelroad.conf /etc/nginx/conf.d/travelroad.conf
sudo systemctl reload nginx
```

## Estructura del proyecto

```
travelroad_django/
├── manage.py
├── requirements.txt
├── .env.example
├── .gitignore
├── run.sh
├── deploy.sh
├── supervisor_travelroad.conf
├── nginx_travelroad.conf
├── main/
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
└── places/
    ├── models.py
    ├── views.py
    ├── urls.py
    ├── templates/
    │   └── places/
    │       └── index.html
    └── migrations/
```

## Modelo

El modelo `Place` tiene los siguientes campos:
- `name`: CharField (255 caracteres) - Nombre del lugar
- `visited`: BooleanField - Indica si el lugar ha sido visitado

