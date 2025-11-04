#!/bin/bash

# Script para ejecutar pruebas de rendimiento con Locust
# Uso: ./run_performance_tests.sh [opciones]

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuración por defecto
USERS=10
SPAWN_RATE=2
RUN_TIME="5m"
HOST="http://localhost:8100"
ONLY_SUMMARY=false
CSV_PREFIX="results"

# Función para mostrar uso
show_usage() {
    echo -e "${BLUE}Uso: ./run_performance_tests.sh [opciones]${NC}"
    echo ""
    echo "Opciones:"
    echo "  -u, --users NUM           Número de usuarios concurrentes (default: 10)"
    echo "  -r, --rate NUM            Tasa de generación de usuarios/segundo (default: 2)"
    echo "  -t, --time TIME           Duración de la prueba (default: 5m)"
    echo "                           Ej: 60s, 5m, 1h"
    echo "  -h, --host URL            URL base del API Gateway (default: http://localhost:8100)"
    echo "  -s, --summary             Solo mostrar resumen (sin interfaz web)"
    echo "  -c, --csv PREFIX          Prefijo para archivos CSV (default: results)"
    echo "  --help                    Mostrar esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  ./run_performance_tests.sh -u 50 -t 10m"
    echo "  ./run_performance_tests.sh -u 100 -r 5 -t 30m -s"
    echo "  ./run_performance_tests.sh -h http://production.example.com:8100"
}

# Parsear argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        -u|--users)
            USERS="$2"
            shift 2
            ;;
        -r|--rate)
            SPAWN_RATE="$2"
            shift 2
            ;;
        -t|--time)
            RUN_TIME="$2"
            shift 2
            ;;
        -h|--host)
            HOST="$2"
            shift 2
            ;;
        -s|--summary)
            ONLY_SUMMARY=true
            shift
            ;;
        -c|--csv)
            CSV_PREFIX="$2"
            shift 2
            ;;
        --help)
            show_usage
            exit 0
            ;;
        *)
            echo -e "${RED}Opción desconocida: $1${NC}"
            show_usage
            exit 1
            ;;
    esac
done

# Verificar que Locust está instalado
if ! command -v locust &> /dev/null; then
    echo -e "${RED}Error: Locust no está instalado${NC}"
    echo "Instálalo con: pip install -r requirements.txt"
    exit 1
fi

# Banner
echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  PRUEBAS DE RENDIMIENTO Y ESTRÉS - E-COMMERCE MICROSERVICES   ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Mostrar configuración
echo -e "${GREEN}Configuración de prueba:${NC}"
echo "  📊 Usuarios concurrentes: $USERS"
echo "  ⚡ Tasa de creación: $SPAWN_RATE usuarios/segundo"
echo "  ⏱️  Duración: $RUN_TIME"
echo "  🌐 Host: $HOST"
echo ""

# Crear directorio de resultados si no existe
mkdir -p performance-results

# Generar timestamp para nombres únicos de archivos
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
CSV_STATS="${TIMESTAMP}_${CSV_PREFIX}_stats.csv"
CSV_HIST="${TIMESTAMP}_${CSV_PREFIX}_hist.csv"

# Construir comando de locust
LOCUST_CMD="locust -f locustfile.py"
LOCUST_CMD="$LOCUST_CMD --users=$USERS"
LOCUST_CMD="$LOCUST_CMD --spawn-rate=$SPAWN_RATE"
LOCUST_CMD="$LOCUST_CMD --run-time=$RUN_TIME"
LOCUST_CMD="$LOCUST_CMD --host=$HOST"
LOCUST_CMD="$LOCUST_CMD --csv=performance-results/$CSV_STATS"

if [ "$ONLY_SUMMARY" = true ]; then
    LOCUST_CMD="$LOCUST_CMD --headless"
    echo -e "${YELLOW}Modo: Headless (solo resumen)${NC}"
else
    echo -e "${YELLOW}Modo: Interfaz web en http://localhost:8089${NC}"
fi

echo ""
echo -e "${BLUE}Iniciando Locust...${NC}"
echo ""

# Ejecutar locust
eval "$LOCUST_CMD"

echo ""
echo -e "${GREEN}✅ Pruebas completadas${NC}"
echo ""
echo -e "${BLUE}Archivos de resultados guardados en:${NC}"
echo "  performance-results/${CSV_STATS}"
echo ""
