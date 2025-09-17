#!/bin/bash

# Script de utilidades para gestionar los microservicios con Docker
# Uso: ./docker-utils.sh [comando]

set -e

PROJECT_NAME="pragma-credi-ya"
COMPOSE_FILE="docker-compose.yml"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para mostrar ayuda
show_help() {
    echo -e "${BLUE}=== PragmaCrediYa Docker Utilities ===${NC}"
    echo ""
    echo "Comandos disponibles:"
    echo ""
    echo -e "${GREEN}build${NC}          - Construir todas las imágenes"
    echo -e "${GREEN}start${NC}          - Iniciar todos los servicios"
    echo -e "${GREEN}stop${NC}           - Parar todos los servicios"
    echo -e "${GREEN}restart${NC}        - Reiniciar todos los servicios"
    echo -e "${GREEN}clean${NC}          - Limpiar contenedores, imágenes y volúmenes"
    echo -e "${GREEN}logs${NC}           - Ver logs de todos los servicios"
    echo -e "${GREEN}logs-auth${NC}      - Ver logs del servicio de autenticación"
    echo -e "${GREEN}logs-loans${NC}     - Ver logs del servicio de solicitudes"
    echo -e "${GREEN}status${NC}         - Ver el estado de todos los servicios"
    echo -e "${GREEN}health${NC}         - Verificar el health de los microservicios"
    echo -e "${GREEN}shell-auth${NC}     - Entrar al contenedor de autenticación"
    echo -e "${GREEN}shell-loans${NC}    - Entrar al contenedor de solicitudes"
    echo -e "${GREEN}db-connect${NC}     - Conectar a la base de datos (PostgreSQL)"
    echo -e "${GREEN}help${NC}           - Mostrar esta ayuda"
    echo ""
}

# Función para construir imágenes
build() {
    echo -e "${BLUE}Construyendo imágenes...${NC}"
    docker-compose build --no-cache
    echo -e "${GREEN}¡Imágenes construidas exitosamente!${NC}"
}

# Función para iniciar servicios
start() {
    echo -e "${BLUE}Iniciando servicios...${NC}"
    docker-compose up -d
    echo -e "${GREEN}¡Servicios iniciados!${NC}"
    echo ""
    status
}

# Función para parar servicios
stop() {
    echo -e "${YELLOW}Parando servicios...${NC}"
    docker-compose down
    echo -e "${GREEN}¡Servicios detenidos!${NC}"
}

# Función para reiniciar servicios
restart() {
    echo -e "${YELLOW}Reiniciando servicios...${NC}"
    docker-compose restart
    echo -e "${GREEN}¡Servicios reiniciados!${NC}"
}

# Función para limpiar todo
clean() {
    echo -e "${RED}¿Estás seguro que quieres limpiar todo? Esto eliminará contenedores, imágenes y volúmenes. [y/N]${NC}"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY]|[sS])$ ]]; then
        echo -e "${YELLOW}Limpiando...${NC}"
        docker-compose down -v --rmi all --remove-orphans
        docker system prune -f
        echo -e "${GREEN}¡Limpieza completada!${NC}"
    else
        echo -e "${BLUE}Operación cancelada.${NC}"
    fi
}

# Función para ver logs
logs() {
    echo -e "${BLUE}Mostrando logs (Ctrl+C para salir)...${NC}"
    docker-compose logs -f
}

# Función para ver logs de autenticación
logs_auth() {
    echo -e "${BLUE}Mostrando logs de Autenticación (Ctrl+C para salir)...${NC}"
    docker-compose logs -f autenticacion
}

# Función para ver logs de solicitudes
logs_loans() {
    echo -e "${BLUE}Mostrando logs de Solicitudes (Ctrl+C para salir)...${NC}"
    docker-compose logs -f solicitudes
}

# Función para ver estado
status() {
    echo -e "${BLUE}Estado de los servicios:${NC}"
    docker-compose ps
    echo ""
    echo -e "${BLUE}Uso de recursos:${NC}"
    docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"
}

# Función para verificar health
health() {
    echo -e "${BLUE}Verificando health de los microservicios...${NC}"
    echo ""
    
    echo -e "${YELLOW}Autenticación (puerto 8081):${NC}"
    if curl -s http://localhost:8081/actuator/health > /dev/null; then
        echo -e "${GREEN}✓ Servicio de Autenticación está funcionando${NC}"
    else
        echo -e "${RED}✗ Servicio de Autenticación no responde${NC}"
    fi
    
    echo -e "${YELLOW}Solicitudes (puerto 8082):${NC}"
    if curl -s http://localhost:8082/actuator/health > /dev/null; then
        echo -e "${GREEN}✓ Servicio de Solicitudes está funcionando${NC}"
    else
        echo -e "${RED}✗ Servicio de Solicitudes no responde${NC}"
    fi
    
    echo ""
    echo -e "${BLUE}URLs disponibles:${NC}"
    echo "- Autenticación: http://localhost:8081"
    echo "- Solicitudes: http://localhost:8082"
    echo "- PgAdmin: http://localhost:5050"
}

# Función para entrar al shell de autenticación
shell_auth() {
    echo -e "${BLUE}Entrando al contenedor de Autenticación...${NC}"
    docker-compose exec autenticacion sh
}

# Función para entrar al shell de solicitudes
shell_loans() {
    echo -e "${BLUE}Entrando al contenedor de Solicitudes...${NC}"
    docker-compose exec solicitudes sh
}

# Función para conectar a la base de datos
db_connect() {
    echo -e "${BLUE}Opciones de conexión a base de datos:${NC}"
    echo "1. Base de datos de Autenticación"
    echo "2. Base de datos de Solicitudes"
    echo -n "Selecciona una opción [1-2]: "
    read -r option
    
    case $option in
        1)
            echo -e "${BLUE}Conectando a la base de datos de Autenticación...${NC}"
            docker-compose exec db_autenticacion psql -U crediya -d crediya
            ;;
        2)
            echo -e "${BLUE}Conectando a la base de datos de Solicitudes...${NC}"
            docker-compose exec db_solicitudes psql -U crediya -d crediyasolicitud
            ;;
        *)
            echo -e "${RED}Opción inválida${NC}"
            ;;
    esac
}

# Función principal
main() {
    case "${1:-help}" in
        build)
            build
            ;;
        start)
            start
            ;;
        stop)
            stop
            ;;
        restart)
            restart
            ;;
        clean)
            clean
            ;;
        logs)
            logs
            ;;
        logs-auth)
            logs_auth
            ;;
        logs-loans)
            logs_loans
            ;;
        status)
            status
            ;;
        health)
            health
            ;;
        shell-auth)
            shell_auth
            ;;
        shell-loans)
            shell_loans
            ;;
        db-connect)
            db_connect
            ;;
        help|*)
            show_help
            ;;
    esac
}

# Verificar que Docker Compose esté disponible
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}Error: docker-compose no está instalado o no está en el PATH${NC}"
    exit 1
fi

# Ejecutar función principal
main "$@"
