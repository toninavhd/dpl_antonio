#!/bin/bash

# Script de despliegue nativo para ngx_small_light
# Uso: bash deploy_native.sh [opcion]
# Opciones:
#   start    - Iniciar nginx
#   stop     - Detener nginx
#   restart  - Reiniciar nginx
#   reload   - Recargar configuración
#   status   - Ver estado de nginx
#   test     - Verificar configuración
#   logs     - Ver logs
#   shell    - Acceder como root
#   nginx    - Acceder como usuario nginx
#   perm     - Corregir permisos
#   all      - Iniciar y configurar todo (defecto)

set -e

CONTAINER_NAME="ngx_small_light_native"
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar si nginx está instalado
check_nginx() {
    if ! command -v nginx &> /dev/null; then
        print_error "Nginx no está instalado. Ejecuta install.sh primero."
        exit 1
    fi
}

# Verificar permisos de root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        print_error "Este comando requiere permisos de root (usa sudo)"
        exit 1
    fi
}

# Iniciar nginx
start_nginx() {
    check_nginx
    print_status "Iniciando nginx..."
    
    if systemctl is-active --quiet nginx; then
        print_warning "nginx ya está en ejecución"
    else
        systemctl start nginx
        print_success "nginx iniciado"
    fi
    
    # Verificar que está ejecutándose
    if systemctl is-active --quiet nginx; then
        print_success "nginx está en ejecución"
        
        # Mostrar información
        echo ""
        echo "=========================================="
        print_success "🎉 ¡Despliegue completado!"
        echo "=========================================="
        echo ""
        echo "📋 Información de acceso:"
        echo "   - URL: https://images.antonio.me"
        echo ""
        echo "📝 Comandos útiles:"
        echo "   sudo systemctl stop nginx     # Detener"
        echo "   sudo systemctl restart nginx  # Reiniciar"
        echo "   sudo systemctl reload nginx   # Recargar config"
        echo "   sudo nginx -t                 # Verificar config"
        echo ""
    else
        print_error "nginx no se pudo iniciar"
        journalctl -xe -u nginx
        exit 1
    fi
}

# Detener nginx
stop_nginx() {
    check_root
    print_status "Deteniendo nginx..."
    
    if systemctl is-active --quiet nginx; then
        systemctl stop nginx
        print_success "nginx detenido"
    else
        print_warning "nginx no está en ejecución"
    fi
}

# Reiniciar nginx
restart_nginx() {
    check_root
    print_status "Reiniciando nginx..."
    
    if systemctl restart nginx; then
        print_success "nginx reiniciado correctamente"
    else
        print_error "Error al reiniciar nginx"
        exit 1
    fi
}

# Recargar configuración
reload_nginx() {
    check_root
    print_status "Recargando configuración de nginx..."
    
    if systemctl reload nginx; then
        print_success "Configuración recargada"
    else
        print_error "Error al recargar configuración"
        exit 1
    fi
}

# Verificar estado
status_nginx() {
    check_nginx
    echo ""
    systemctl status nginx --no-pager
    echo ""
}

# Verificar configuración
test_config() {
    check_nginx
    print_status "Verificando configuración de nginx..."
    
    if nginx -t 2>&1; then
        print_success "Configuración válida"
    else
        print_error "Error en la configuración"
        exit 1
    fi
}

# Ver logs
show_logs() {
    print_status "Mostrando logs de nginx..."
    journalctl -u nginx -n 50 --no-pager
}

# Acceder al shell como root
shell_root() {
    print_status "Accediendo al shell como root..."
    /bin/bash
}

# Acceder como usuario nginx
shell_nginx() {
    if id nginx &>/dev/null; then
        print_status "Accediendo como usuario nginx..."
        su - nginx -s /bin/bash
    elif id www-data &>/dev/null; then
        print_status "Accediendo como usuario www-data..."
        su - www-data -s /bin/bash
    else
        print_error "No hay usuario nginx ni www-data"
        exit 1
    fi
}

# Corregir permisos
fix_permissions() {
    check_root
    print_status "Corrigiendo permisos..."
    
    # Determinar usuario
    if id nginx &>/dev/null; then
        NGINX_USER="nginx"
        NGINX_GROUP="nginx"
    elif id www-data &>/dev/null; then
        NGINX_USER="www-data"
        NGINX_GROUP="www-data"
    else
        print_warning "No se encontró usuario nginx ni www-data, usando root"
        NGINX_USER="root"
        NGINX_GROUP="root"
    fi
    
    echo "   Usuario: $NGINX_USER"
    
    # Directorios de imágenes
    chown -R $NGINX_USER:$NGINX_GROUP /var/www/html
    chmod -R 755 /var/www/html/img
    chmod 644 /var/www/html/img/*.jpg 2>/dev/null || true
    
    # Directorio temporal
    mkdir -p /tmp/small_light
    chown -R $NGINX_USER:$NGINX_GROUP /tmp/small_light
    chmod -R 755 /tmp/small_light
    chmod 1777 /tmp
    
    # Logs
    chown -R $NGINX_USER:$NGINX_GROUP /var/log/nginx 2>/dev/null || true
    
    # PID file
    touch /var/run/nginx.pid 2>/dev/null || true
    chown $NGINX_USER:$NGINX_GROUP /var/run/nginx.pid 2>/dev/null || true
    
    # SSL
    chown $NGINX_USER:$NGINX_GROUP /etc/nginx/ssl 2>/dev/null || true
    chmod 600 /etc/nginx/ssl/server.key 2>/dev/null || true
    
    print_success "Permisos corregidos"
    print_status "Reiniciando nginx para aplicar cambios..."
    systemctl restart nginx
}

# Mostrar ayuda
show_help() {
    echo ""
    echo "=========================================="
    echo "  Script de despliegue ngx_small_light Nativo"
    echo "=========================================="
    echo ""
    echo "Uso: $0 [opcion]"
    echo ""
    echo "Opciones:"
    echo "  start    - Iniciar nginx"
    echo "  stop     - Detener nginx"
    echo "  restart  - Reiniciar nginx"
    echo "  reload   - Recargar configuración"
    echo "  status   - Ver estado de nginx"
    echo "  test     - Verificar configuración"
    echo "  logs     - Ver logs"
    echo "  shell    - Acceder al shell como root"
    echo "  nginx    - Acceder como usuario nginx"
    echo "  perm     - Corregir permisos"
    echo "  all      - Iniciar (defecto)"
    echo ""
    echo "Ejemplos:"
    echo "  sudo $0 all       # Iniciar nginx"
    echo "  sudo $0 restart   # Reiniciar nginx"
    echo "  sudo $0 test      # Verificar configuración"
    echo "  sudo $0 perm      # Corregir permisos"
    echo ""
}

# Menú principal
case "${1:-all}" in
    start)
        start_nginx
        ;;
    stop)
        stop_nginx
        ;;
    restart)
        restart_nginx
        ;;
    reload)
        reload_nginx
        ;;
    status)
        status_nginx
        ;;
    test)
        test_config
        ;;
    logs)
        show_logs
        ;;
    shell)
        check_root
        shell_root
        ;;
    nginx)
        shell_nginx
        ;;
    perm)
        fix_permissions
        ;;
    all)
        start_nginx
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        print_error "Opción no válida: $1"
        show_help
        exit 1
        ;;
esac


