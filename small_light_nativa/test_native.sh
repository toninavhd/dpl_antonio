#!/bin/bash

# Script de prueba para ngx_small_light nativo
# Uso: bash test_native.sh

set -e

echo "=========================================="
echo "  Test de ngx_small_light (Nativo)"
echo "=========================================="
echo ""

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

PASS=0
FAIL=0

test_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $2"
        ((PASS++))
    else
        echo -e "${RED}✗${NC} $2"
        ((FAIL++))
    fi
}

# Test 1: Nginx instalado
echo "1. Verificando nginx instalado..."
if command -v nginx &> /dev/null; then
    NGINX_VERSION=$(nginx -v 2>&1)
    test_result 0 "Nginx instalado: $NGINX_VERSION"
else
    test_result 1 "Nginx NO instalado"
fi

# Test 2: Módulo ngx_small_light
echo ""
echo "2. Verificando módulo ngx_small_light..."
if nginx -V 2>&1 | grep -q "ngx_small_light"; then
    test_result 0 "Módulo ngx_small_light cargado"
else
    test_result 1 "Módulo ngx_small_light NO cargado"
fi

# Test 3: Nginx en ejecución
echo ""
echo "3. Verificando servicio nginx..."
if systemctl is-active --quiet nginx 2>/dev/null; then
    test_result 0 "Servicio nginx en ejecución"
else
    test_result 1 "Servicio nginx NO en ejecución"
    echo -e "${YELLOW}  Ejecuta: sudo systemctl start nginx${NC}"
fi

# Test 4: Puerto 80 escuchando
echo ""
echo "4. Verificando puerto 80..."
if command -v ss &>/dev/null; then
    if ss -tln | grep -q ":80 "; then
        test_result 0 "Puerto 80 escuchando"
    else
        test_result 1 "Puerto 80 NO escuchando"
    fi
elif command -v netstat &>/dev/null; then
    if netstat -tln | grep -q ":80 "; then
        test_result 0 "Puerto 80 escuchando"
    else
        test_result 1 "Puerto 80 NO escuchando"
    fi
else
    echo -e "${YELLOW}  No se pudo verificar (ss/netstat no disponibles)${NC}"
fi

# Test 5: Puerto 443 escuchando
echo ""
echo "5. Verificando puerto 443..."
if command -v ss &>/dev/null; then
    if ss -tln | grep -q ":443 "; then
        test_result 0 "Puerto 443 escuchando"
    else
        test_result 1 "Puerto 443 NO escuchando"
    fi
elif command -v netstat &>/dev/null; then
    if netstat -tln | grep -q ":443 "; then
        test_result 0 "Puerto 443 escuchando"
    else
        test_result 1 "Puerto 443 NO escuchando"
    fi
else
    echo -e "${YELLOW}  No se pudo verificar${NC}"
fi

# Test 6: Directorio de imágenes
echo ""
echo "6. Verificando directorio de imágenes..."
if [ -d "/var/www/html/img" ]; then
    test_result 0 "Directorio /var/www/html/img existe"
else
    test_result 1 "Directorio /var/www/html/img NO existe"
fi

# Test 7: Imágenes disponibles
echo ""
echo "7. Verificando imágenes..."
if [ -d "/var/www/html/img" ]; then
    IMAGE_COUNT=$(ls /var/www/html/img/*.jpg 2>/dev/null | wc -l)
    if [ "$IMAGE_COUNT" -ge 20 ]; then
        test_result 0 "Imágenes disponibles: $IMAGE_COUNT (mínimo 20)"
    else
        test_result 1 "Imágenes disponibles: $IMAGE_COUNT (se esperan mínimo 20)"
    fi
else
    test_result 1 "No hay directorio de imágenes"
fi

# Test 8: ImageMagick
echo ""
echo "8. Verificando ImageMagick..."
if command -v convert &> /dev/null; then
    IM_VERSION=$(convert --version | head -1)
    test_result 0 "ImageMagick instalado: $IM_VERSION"
else
    test_result 1 "ImageMagick NO instalado"
fi

# Test 9: Certificado SSL
echo ""
echo "9. Verificando certificado SSL..."
if [ -f "/etc/nginx/ssl/server.crt" ]; then
    test_result 0 "Certificado SSL existe"
else
    test_result 1 "Certificado SSL NO existe"
fi

# Test 10: Módulo .so existe
echo ""
echo "10. Verificando módulo ngx_small_light.so..."
if [ -f "/etc/nginx/modules/ngx_http_small_light_module.so" ]; then
    test_result 0 "Módulo ngx_http_small_light_module.so existe"
else
    test_result 1 "Módulo ngx_http_small_light_module.so NO existe"
fi

# Test 11: Configuración válida
echo ""
echo "11. Verificando configuración de nginx..."
if nginx -t 2>&1 | grep -q "syntax is ok"; then
    test_result 0 "Configuración de nginx válida"
else
    test_result 1 "Error en configuración de nginx"
fi

# Test 12: Directorio temporal
echo ""
echo "12. Verificando directorio temporal..."
if [ -d "/tmp/small_light" ]; then
    test_result 0 "Directorio /tmp/small_light existe"
else
    test_result 1 "Directorio /tmp/small_light NO existe"
fi

# Resumen
echo ""
echo "=========================================="
echo "  Resumen de Tests"
echo "=========================================="
echo -e "${GREEN}Pasados:${NC} $PASS"
echo -e "${RED}Fallidos:${NC} $FAIL"
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}🎉 ¡Todos los tests pasaron!${NC}"
    echo ""
    echo "Accede a: https://images.antonio.me"
else
    echo -e "${YELLOW}⚠️  Algunos tests fallaron${NC}"
    echo ""
    echo "Para ver logs:"
    echo "  journalctl -u nginx -n 50"
    echo ""
    echo "Para verificar configuración:"
    echo "  sudo nginx -t"
fi

# Test de imagen procesada (opcional)
echo ""
echo "=========================================="
echo "  Test de Procesamiento"
echo "=========================================="
echo ""
echo "URL de prueba:"
echo "  https://images.antonio.me/img/image01.jpg?small=square,200"
echo ""
echo "Si tienes curl instalado, puedes probar:"
echo "  curl -k -I 'https://images.antonio.me/img/image01.jpg?small=square,200'"
echo ""
echo "La respuesta debe incluir:"
echo "  - HTTP/2 200"
echo "  - Content-Type: image/jpeg"
echo ""


