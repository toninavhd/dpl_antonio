#!/bin/bash

# Script de despliegue completo para ngx_small_light
# Uso: bash deploy.sh [opcion]
# Opciones:
#   build     - Construir la imagen Docker
#   start     - Iniciar el contenedor
#   stop      - Detener el contenedor
#   restart   - Reiniciar el contenedor
#   logs      - Ver logs del contenedor
#   shell     - Acceder al contenedor como root
#   nginx     - Acceder al shell del nginx user
#   perm      - Ejecutar script de permisos
#   status    - Ver estado del contenedor
#   all       - Construir e iniciar (defecto)

set -e

CONTAINER_NAME="antonio_small_light"
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
IMAGE_NAME="antonio_small_light"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Verificar que Docker está instalado
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker no está instalado. Por favor, instala Docker primero."
        exit 1
    fi
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null 2>&1; then
        print_error "Docker Compose no está instalado. Por favor, instala Docker Compose primero."
        exit 1
    fi
}

# Verificar que los archivos necesarios existen
check_files() {
    print_status "Verificando archivos necesarios..."
    
    REQUIRED_FILES=("Dockerfile" "docker-compose.yml" "nginx.conf" "index.html" "style.css" "script.js")
    MISSING_FILES=()
    
    for file in "${REQUIRED_FILES[@]}"; do
        if [ ! -f "$PROJECT_DIR/$file" ]; then
            MISSING_FILES+=("$file")
        fi
    done
    
    if [ ${#MISSING_FILES[@]} -ne 0 ]; then
        print_error "Faltan archivos necesarios: ${MISSING_FILES[*]}"
        exit 1
    fi
    
    if [ ! -d "$PROJECT_DIR/images" ]; then
        print_warning "Directorio de imágenes no encontrado. Las imágenes deberán estar en images/"
    fi
    
    print_success "Todos los archivos necesarios están presentes."
}

# Construir la imagen Docker
build_image() {
    print_status "Construyendo imagen Docker..."
    cd "$PROJECT_DIR"
    
    if docker compose build --no-cache 2>/dev/null || docker-compose build --no-cache; then
        print_success "Imagen construida correctamente."
    else
        print_error "Error al construir la imagen."
        exit 1
    fi
}

# Iniciar el contenedor
start_container() {
    print_status "Iniciando contenedor..."
    cd "$PROJECT_DIR"
    
    # Verificar si ya existe un contenedor con ese nombre
    if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
            print_warning "El contenedor ya está en ejecución."
            return 0
        else
            print_status "Reinicando contenedor existente..."
            docker start "$CONTAINER_NAME"
        fi
    else
        if docker compose up -d 2>/dev/null || docker-compose up -d; then
            print_success "Contenedor iniciado correctamente."
        else
            print_error "Error al iniciar el contenedor."
            exit 1
        fi
    fi
    
    # Esperar a que nginx esté listo
    print_status "Esperando a que nginx esté listo..."
    sleep 3
    
    # Verificar que el contenedor está ejecutándose
    if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        print_success "Contenedor $CONTAINER_NAME está en ejecución."
        
        # Mostrar información de acceso
        echo ""
        print_success "=========================================="
        print_success "🎉 ¡Despliegue completado exitosamente!"
        print_success "=========================================="
        echo ""
        echo "📋 Información de acceso:"
        echo "   - URL: https://images.antonio.me"
        echo "   - Contenedor: $CONTAINER_NAME"
        echo ""
        echo "📝 Para ver los logs:"
        echo "   bash $0 logs"
        echo ""
        echo "🐚 Para acceder al contenedor:"
        echo "   bash $0 shell"
        echo ""
    else
        print_error "El contenedor no se está ejecutando."
        show_logs
        exit 1
    fi
}

# Detener el contenedor
stop_container() {
    print_status "Deteniendo contenedor..."
    cd "$PROJECT_DIR"
    
    if docker compose down 2>/dev/null || docker-compose down; then
        print_success "Contenedor detenido correctamente."
    else
        print_warning "No se pudo detener el contenedor (¿existe?)."
    fi
}

# Reiniciar el contenedor
restart_container() {
    print_status "Reiniciando contenedor..."
    stop_container
    sleep 2
    start_container
}

# Ver logs del contenedor
show_logs() {
    print_status "Mostrando logs del contenedor..."
    cd "$PROJECT_DIR"
    
    if docker logs --tail 50 -f "$CONTAINER_NAME" 2>&1; then
        :
    else
        print_error "No se pudieron mostrar los logs."
    fi
}

# Acceder al contenedor como root
shell_root() {
    print_status "Accediendo al contenedor como root..."
    docker exec -it "$CONTAINER_NAME" /bin/bash
}

# Acceder al shell del usuario nginx
shell_nginx() {
    print_status "Accediendo al contenedor como usuario nginx..."
    docker exec -it -u nginx "$CONTAINER_NAME" /bin/bash
}

# Ejecutar script de permisos dentro del contenedor
fix_permissions_container() {
    print_status "Ejecutando script de permisos en el contenedor..."
    docker exec "$CONTAINER_NAME" /bin/bash /entrypoint.sh
}

# Verificar estado del contenedor
status_container() {
    print_status "Estado del contenedor:"
    echo ""
    docker ps --filter "name=$CONTAINER_NAME" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    echo ""
}

# Mostrar ayuda
show_help() {
    echo ""
    echo "=========================================="
    echo "  Script de despliegue ngx_small_light"
    echo "=========================================="
    echo ""
    echo "Uso: $0 [opcion]"
    echo ""
    echo "Opciones:"
    echo "  build     - Construir la imagen Docker"
    echo "  start     - Iniciar el contenedor"
    echo "  stop      - Detener el contenedor"
    echo "  restart   - Reiniciar el contenedor"
    echo "  logs      - Ver logs del contenedor"
    echo "  shell     - Acceder al contenedor como root"
    echo "  nginx     - Acceder al shell del usuario nginx"
    echo "  perm      - Ejecutar script de permisos"
    echo "  status    - Ver estado del contenedor"
    echo "  all       - Construir e iniciar (defecto)"
    echo "  help      - Mostrar esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  $0 all        # Construir e iniciar"
    echo "  $0 build      # Solo construir"
    echo "  $0 start      # Solo iniciar"
    echo "  $0 shell      # Acceder al contenedor"
    echo ""
}

# Menú principal
case "${1:-all}" in
    build)
        check_docker
        check_files
        build_image
        ;;
    start)
        check_docker
        start_container
        ;;
    stop)
        stop_container
        ;;
    restart)
        restart_container
        ;;
    logs)
        show_logs
        ;;
    shell)
        check_docker
        shell_root
        ;;
    nginx)
        check_docker
        shell_nginx
        ;;
    perm)
        check_docker
        fix_permissions_container
        ;;
    status)
        status_container
        ;;
    all)
        check_docker
        check_files
        build_image
        start_container
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

