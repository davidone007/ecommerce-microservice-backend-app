#!/bin/bash

###############################################################################
# Script para ejecutar diferentes tipos de pruebas de rendimiento con Locust
# Autor: Performance Testing Suite
# Fecha: 2024-11-04
###############################################################################

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables por defecto
HOST="${HOST:-http://localhost:8080}"
RESULTS_DIR="results"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Crear directorio de resultados si no existe
mkdir -p "$RESULTS_DIR"

###############################################################################
# Funciones auxiliares
###############################################################################

print_header() {
    echo -e "${BLUE}"
    echo "================================================================================"
    echo "$1"
    echo "================================================================================"
    echo -e "${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

check_services() {
    print_header "Verificando que los servicios estén disponibles..."
    
    if curl -s -o /dev/null -w "%{http_code}" "$HOST/app/api/products" | grep -q "200\|401"; then
        print_success "Servicios disponibles en $HOST"
        return 0
    else
        print_error "No se puede conectar a $HOST"
        print_warning "Asegúrate de que docker-compose esté ejecutándose:"
        echo "  docker-compose -f compose.yml up -d"
        return 1
    fi
}

###############################################################################
# Tipos de pruebas
###############################################################################

run_smoke_test() {
    print_header "🔥 PRUEBA DE HUMO (Smoke Test)"
    echo "Objetivo: Verificar que el sistema funciona con carga mínima"
    echo "Duración: 2 minutos"
    echo "Usuarios: 5"
    echo ""
    
    locust \
        -f locustfile.py \
        --host="$HOST" \
        --users 5 \
        --spawn-rate 1 \
        --run-time 2m \
        --headless \
        --html="$RESULTS_DIR/smoke_test_${TIMESTAMP}.html" \
        --csv="$RESULTS_DIR/smoke_test_${TIMESTAMP}" \
        --loglevel INFO
    
    print_success "Prueba de humo completada. Resultados en: $RESULTS_DIR/smoke_test_${TIMESTAMP}.html"
}

run_load_test() {
    print_header "📊 PRUEBA DE CARGA (Load Test)"
    echo "Objetivo: Evaluar comportamiento bajo carga normal esperada"
    echo "Duración: 10 minutos"
    echo "Usuarios: 50"
    echo "Tasa de spawn: 5 usuarios/segundo"
    echo ""
    
    locust \
        -f locustfile.py \
        --host="$HOST" \
        --users 50 \
        --spawn-rate 5 \
        --run-time 10m \
        --headless \
        --html="$RESULTS_DIR/load_test_${TIMESTAMP}.html" \
        --csv="$RESULTS_DIR/load_test_${TIMESTAMP}" \
        --loglevel INFO
    
    print_success "Prueba de carga completada. Resultados en: $RESULTS_DIR/load_test_${TIMESTAMP}.html"
}

run_stress_test() {
    print_header "💪 PRUEBA DE ESTRÉS (Stress Test)"
    echo "Objetivo: Identificar límites del sistema y puntos de quiebre"
    echo "Duración: 15 minutos"
    echo "Usuarios: 200"
    echo "Tasa de spawn: 10 usuarios/segundo"
    echo ""
    
    print_warning "Esta prueba puede causar alta carga en el sistema"
    
    locust \
        -f locustfile.py \
        --host="$HOST" \
        --users 200 \
        --spawn-rate 10 \
        --run-time 15m \
        --headless \
        --html="$RESULTS_DIR/stress_test_${TIMESTAMP}.html" \
        --csv="$RESULTS_DIR/stress_test_${TIMESTAMP}" \
        --loglevel INFO
    
    print_success "Prueba de estrés completada. Resultados en: $RESULTS_DIR/stress_test_${TIMESTAMP}.html"
}

run_spike_test() {
    print_header "⚡ PRUEBA DE PICOS (Spike Test)"
    echo "Objetivo: Evaluar respuesta ante aumentos súbitos de tráfico"
    echo "Duración: 3 minutos"
    echo "Usuarios: 300"
    echo "Tasa de spawn: 50 usuarios/segundo (muy rápido)"
    echo ""
    
    print_warning "Esta prueba simula un pico súbito de tráfico"
    
    locust \
        -f locustfile.py \
        --host="$HOST" \
        --users 300 \
        --spawn-rate 50 \
        --run-time 3m \
        --headless \
        --html="$RESULTS_DIR/spike_test_${TIMESTAMP}.html" \
        --csv="$RESULTS_DIR/spike_test_${TIMESTAMP}" \
        --loglevel INFO
    
    print_success "Prueba de picos completada. Resultados en: $RESULTS_DIR/spike_test_${TIMESTAMP}.html"
}

run_soak_test() {
    print_header "🏊 PRUEBA DE RESISTENCIA (Soak Test)"
    echo "Objetivo: Evaluar estabilidad del sistema bajo carga prolongada"
    echo "Duración: 30 minutos"
    echo "Usuarios: 100"
    echo "Tasa de spawn: 5 usuarios/segundo"
    echo ""
    
    print_warning "Esta prueba durará 30 minutos"
    
    locust \
        -f locustfile.py \
        --host="$HOST" \
        --users 100 \
        --spawn-rate 5 \
        --run-time 30m \
        --headless \
        --html="$RESULTS_DIR/soak_test_${TIMESTAMP}.html" \
        --csv="$RESULTS_DIR/soak_test_${TIMESTAMP}" \
        --loglevel INFO
    
    print_success "Prueba de resistencia completada. Resultados en: $RESULTS_DIR/soak_test_${TIMESTAMP}.html"
}

run_web_ui() {
    print_header "🌐 MODO WEB UI INTERACTIVO"
    echo "Iniciando Locust en modo Web UI..."
    echo ""
    print_success "Accede a la interfaz web en: http://localhost:8089"
    print_warning "Presiona Ctrl+C para detener"
    echo ""
    
    locust \
        -f locustfile.py \
        --host="$HOST" \
        --web-host 0.0.0.0 \
        --web-port 8089
}

run_all_tests() {
    print_header "🚀 EJECUTAR TODAS LAS PRUEBAS"
    echo "Se ejecutarán todas las pruebas en secuencia:"
    echo "1. Smoke Test (2 min)"
    echo "2. Load Test (10 min)"
    echo "3. Stress Test (15 min)"
    echo "4. Spike Test (3 min)"
    echo ""
    print_warning "Tiempo total estimado: ~30 minutos"
    echo ""
    
    read -p "¿Continuar? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "Pruebas canceladas"
        exit 0
    fi
    
    run_smoke_test
    echo ""
    sleep 5
    
    run_load_test
    echo ""
    sleep 5
    
    run_stress_test
    echo ""
    sleep 5
    
    run_spike_test
    echo ""
    
    print_header "✅ TODAS LAS PRUEBAS COMPLETADAS"
    echo "Resultados guardados en: $RESULTS_DIR/"
    ls -lh "$RESULTS_DIR/"*"${TIMESTAMP}"*
}

###############################################################################
# Menú principal
###############################################################################

show_menu() {
    clear
    print_header "SISTEMA DE PRUEBAS DE RENDIMIENTO - E-COMMERCE MICROSERVICES"
    echo ""
    echo "Host configurado: $HOST"
    echo ""
    echo "Selecciona el tipo de prueba:"
    echo ""
    echo "  1) 🔥 Smoke Test       - Verificación básica (2 min, 5 usuarios)"
    echo "  2) 📊 Load Test        - Carga normal (10 min, 50 usuarios)"
    echo "  3) 💪 Stress Test      - Prueba de estrés (15 min, 200 usuarios)"
    echo "  4) ⚡ Spike Test       - Picos de tráfico (3 min, 300 usuarios)"
    echo "  5) 🏊 Soak Test        - Resistencia (30 min, 100 usuarios)"
    echo "  6) 🌐 Web UI           - Modo interactivo"
    echo "  7) 🚀 Todas las pruebas"
    echo "  8) 🔍 Ver últimos resultados"
    echo "  9) ❌ Salir"
    echo ""
    echo -n "Opción: "
}

view_latest_results() {
    print_header "📁 ÚLTIMOS RESULTADOS"
    
    if [ -z "$(ls -A $RESULTS_DIR 2>/dev/null)" ]; then
        print_warning "No hay resultados disponibles"
        return
    fi
    
    echo "Archivos HTML de resultados:"
    ls -lht "$RESULTS_DIR"/*.html 2>/dev/null | head -5
    echo ""
    
    latest_html=$(ls -t "$RESULTS_DIR"/*.html 2>/dev/null | head -1)
    if [ -n "$latest_html" ]; then
        print_success "Último reporte: $latest_html"
        echo "Abre el archivo en tu navegador para ver los resultados detallados"
    fi
    
    echo ""
    read -p "Presiona Enter para continuar..."
}

###############################################################################
# Main
###############################################################################

main() {
    # Verificar que estamos en el directorio correcto
    if [ ! -f "locustfile.py" ]; then
        print_error "Error: locustfile.py no encontrado"
        echo "Ejecuta este script desde el directorio performance-tests/"
        exit 1
    fi
    
    # Verificar si locust está instalado
    if ! command -v locust &> /dev/null; then
        print_error "Locust no está instalado"
        echo "Instala las dependencias con: pip install -r requirements.txt"
        exit 1
    fi
    
    # Verificar servicios
    if ! check_services; then
        exit 1
    fi
    
    # Loop del menú
    while true; do
        show_menu
        read option
        
        case $option in
            1)
                run_smoke_test
                echo ""
                read -p "Presiona Enter para continuar..."
                ;;
            2)
                run_load_test
                echo ""
                read -p "Presiona Enter para continuar..."
                ;;
            3)
                run_stress_test
                echo ""
                read -p "Presiona Enter para continuar..."
                ;;
            4)
                run_spike_test
                echo ""
                read -p "Presiona Enter para continuar..."
                ;;
            5)
                run_soak_test
                echo ""
                read -p "Presiona Enter para continuar..."
                ;;
            6)
                run_web_ui
                ;;
            7)
                run_all_tests
                echo ""
                read -p "Presiona Enter para continuar..."
                ;;
            8)
                view_latest_results
                ;;
            9)
                print_success "¡Hasta luego!"
                exit 0
                ;;
            *)
                print_error "Opción inválida"
                sleep 2
                ;;
        esac
    done
}

# Ejecutar main
main
