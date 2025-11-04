#!/bin/bash

# Script para ejecutar pruebas específicas por servicio
# Ejecuta Locust contra un servicio individual

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

show_usage() {
    echo -e "${BLUE}Uso: ./test_service.sh SERVICE [OPCIONES]${NC}"
    echo ""
    echo "Servicios disponibles:"
    echo "  products      - Product Service"
    echo "  orders        - Order Service"
    echo "  payments      - Payment Service"
    echo "  favorites     - Favourite Service"
    echo "  shipping      - Shipping Service"
    echo ""
    echo "Opciones:"
    echo "  -u, --users NUM     Número de usuarios (default: 10)"
    echo "  -t, --time TIME     Duración (default: 5m)"
    echo "  --help              Mostrar esta ayuda"
}

if [ $# -eq 0 ] || [ "$1" = "--help" ]; then
    show_usage
    exit 0
fi

SERVICE=$1
shift

# Variables por defecto
USERS=10
TIME="5m"
LOCUST_FILE=""

case $SERVICE in
    products)
        LOCUST_FILE="locustfile_products.py"
        ;;
    orders)
        LOCUST_FILE="locustfile_orders.py"
        ;;
    payments)
        LOCUST_FILE="locustfile_payments.py"
        ;;
    favorites)
        LOCUST_FILE="locustfile_favorites.py"
        ;;
    shipping)
        LOCUST_FILE="locustfile_shipping.py"
        ;;
    *)
        echo -e "${RED}Servicio desconocido: $SERVICE${NC}"
        show_usage
        exit 1
        ;;
esac

# Parsear opciones adicionales
while [[ $# -gt 0 ]]; do
    case $1 in
        -u|--users)
            USERS="$2"
            shift 2
            ;;
        -t|--time)
            TIME="$2"
            shift 2
            ;;
        *)
            echo -e "${RED}Opción desconocida: $1${NC}"
            show_usage
            exit 1
            ;;
    esac
done

# Determinar URL base según servicio
case $SERVICE in
    products)
        HOST="http://localhost:8200"
        ;;
    orders)
        HOST="http://localhost:8300"
        ;;
    payments)
        HOST="http://localhost:8400"
        ;;
    favorites)
        HOST="http://localhost:8800"
        ;;
    shipping)
        HOST="http://localhost:8600"
        ;;
esac

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  PRUEBA DE RENDIMIENTO - $(printf '%-45s' $(echo $SERVICE | tr a-z A-Z))||${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Configuración:${NC}"
echo "  📊 Usuarios: $USERS"
echo "  ⏱️  Duración: $TIME"
echo "  🌐 Host: $HOST"
echo "  📄 Locustfile: $LOCUST_FILE"
echo ""

mkdir -p performance-results
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo -e "${YELLOW}Iniciando prueba...${NC}"
locust -f "$LOCUST_FILE" \
    --users="$USERS" \
    --spawn-rate=2 \
    --run-time="$TIME" \
    --host="$HOST" \
    --csv="performance-results/${TIMESTAMP}_${SERVICE}" \
    --headless

echo ""
echo -e "${GREEN}✅ Prueba completada${NC}"
