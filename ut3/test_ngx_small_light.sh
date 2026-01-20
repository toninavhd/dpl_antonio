#!/bin/bash

# Script de prueba rápida para verificar ngx_small_light
# Uso: bash test_ngx_small_light.sh

set -e

CONTAINER_NAME="antonio_small_light"

echo "=========================================="
echo "  Test de ngx_small_light"
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

# Test 1: Contenedor en ejecución
echo "1. Verificando contenedor en ejecución..."
if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    test_result 0 "Contenedor $CONTAINER_NAME está en ejecución"
else
    test_result 1 "Contenedor $CONTAINER_NAME NO está en ejecución"
    echo -e "${YELLOW}  Ejecuta: ./deploy.sh all${NC}"
fi

# Test 2: Puerto 80 escuchando
echo ""
echo "2. Verificando puerto 80..."
if docker exec "$CONTAINER_NAME" netstat -tln | grep -q ":80 "; then
    test_result 0 "Puerto 80 está escuchando"
else
    test_result 1 "Puerto 80 NO está escuchando"
fi

# Test 3: Puerto 443 escuchando
echo ""
echo "3. Verificando puerto 443..."
if docker exec "$CONTAINER_NAME" netstat -tln | grep -q ":443 "; then
    test_result 0 "Puerto 443 está escuchando"
else
    test_result 1 "Puerto 443 NO está escuchando"
fi

# Test 4: Módulo cargado
echo ""
echo "4. Verificando módulo ngx_small_light..."
if docker exec "$CONTAINER_NAME" nginx -V 2>&1 | grep -q "ngx_small_light"; then
    test_result 0 "Módulo ngx_small_light cargado"
else
    test_result 1 "Módulo ngx_small_light NO cargado"
fi

# Test 5: Directorio de imágenes existe
echo ""
echo "5. Verificando directorio de imágenes..."
if docker exec "$CONTAINER_NAME" test -d /var/www/html/img; then
    test_result 0 "Directorio /var/www/html/img existe"
else
    test_result 1 "Directorio /var/www/html/img NO existe"
fi

# Test 6: Imágenes disponibles
echo ""
echo "6. Verificando imágenes..."
IMAGE_COUNT=$(docker exec "$CONTAINER_NAME" ls /var/www/html/img/*.jpg 2>/dev/null | wc -l)
if [ "$IMAGE_COUNT" -ge 20 ]; then
    test_result 0 "Imágenes disponibles: $IMAGE_COUNT (mínimo 20)"
else
    test_result 1 "Imágenes disponibles: $IMAGE_COUNT (se esperan mínimo 20)"
fi

# Test 7: Permisos de imágenes
echo ""
echo "7. Verificando permisos de imágenes..."
PERM_OK=$(docker exec "$CONTAINER_NAME" stat -c '%U' /var/www/html/img/image01.jpg 2>/dev/null)
if [ "$PERM_OK" = "nginx" ]; then
    test_result 0 "Propietario correcto: nginx"
else
    test_result 1 "Propietario incorrecto: $PERM_OK (esperado: nginx)"
fi

# Test 8: Directorio temporal
echo ""
echo "8. Verificando directorio temporal..."
if docker exec "$CONTAINER_NAME" test -d /tmp/small_light; then
    test_result 0 "Directorio /tmp/small_light existe"
else
    test_result 1 "Directorio /tmp/small_light NO existe"
fi

# Test 9: ImageMagick
echo ""
echo "9. Verificando ImageMagick..."
if docker exec "$CONTAINER_NAME" convert --version &>/dev/null; then
    test_result 0 "ImageMagick instalado"
else
    test_result 1 "ImageMagick NO instalado"
fi

# Test 10: Certificado SSL
echo ""
echo "10. Verificando certificado SSL..."
if docker exec "$CONTAINER_NAME" test -f /etc/nginx/ssl/server.crt; then
    test_result 0 "Certificado SSL existe"
else
    test_result 1 "Certificado SSL NO existe"
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
    echo "Para ver los logs:"
    echo "  docker logs $CONTAINER_NAME"
    echo ""
    echo "Para acceder al contenedor:"
    echo "  docker exec -it $CONTAINER_NAME /bin/bash"
fi

# Test de imagen procesada (opcional)
echo ""
echo "=========================================="
echo "  Test de Procesamiento de Imagen"
echo "=========================================="
echo ""

# Generar URL de prueba
TEST_URL="https://images.antonio.me/img/image01.jpg?small=square,200"
echo "URL de prueba: $TEST_URL"
echo ""
echo "Si tienes curl instalado, puedes probar:"
echo "  curl -k -I '$TEST_URL'"
echo ""
echo "La respuesta debe incluir:"
echo "  - HTTP/2 200"
echo "  - Content-Type: image/jpeg"
echo ""

