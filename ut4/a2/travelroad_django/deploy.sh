#!/bin/bash

# Script de despliegue para travelroad_django
# Este script automatiza el proceso de despliegue de la aplicación

set -e  # Exit on error

echo "=================================="
echo "Deploy script para travelroad_django"
echo "=================================="

# Obtener el directorio del script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo ""
echo "1. Instalando dependencias..."
echo "----------------------------"
source .venv/bin/activate
pip install -r requirements.txt

echo ""
echo "2. Verificando configuración de Django..."
echo "----------------------------------------"
python manage.py check

echo ""
echo "3. Aplicando migraciones de base de datos..."
echo "--------------------------------------------"
python manage.py migrate

echo ""
echo "4. Reiniciando servicio supervisor..."
echo "-------------------------------------"
supervisorctl restart travelroad_django

echo ""
echo "5. Recargando nginx..."
echo "---------------------"
sudo systemctl reload nginx

echo ""
echo "=================================="
echo "Despliegue completado exitosamente!"
echo "=================================="
echo ""
echo "La aplicación debería estar disponible en:"
echo "http://travelroad_django.local"

