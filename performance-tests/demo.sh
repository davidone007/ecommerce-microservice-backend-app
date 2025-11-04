#!/bin/bash

# Script de demostración: Ejecuta las pruebas paso a paso
# Muestra ejemplos de diferentes tipos de pruebas

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

clear

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║    DEMOSTRACIÓN - PRUEBAS DE RENDIMIENTO Y ESTRÉS              ║${NC}"
echo -e "${BLUE}║    E-Commerce Microservicios con Locust                        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Verificar instalación
if ! command -v locust &> /dev/null; then
    echo -e "${RED}❌ Error: Locust no está instalado${NC}"
    echo "Instala las dependencias con:"
    echo -e "${CYAN}pip install -r requirements.txt${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Locust está instalado${NC}"
echo ""

# Menu
show_menu() {
    echo -e "${YELLOW}Selecciona una demostración:${NC}"
    echo ""
    echo -e "${CYAN}1) EXPLICACIÓN RÁPIDA${NC}"
    echo "   - Qué son las pruebas de rendimiento"
    echo "   - Por qué son importantes"
    echo ""
    echo -e "${CYAN}2) DEMOSTRACIÓN INTERACTIVA${NC}"
    echo "   - Ejecuta prueba simple (5 usuarios, 2 minutos)"
    echo "   - Accede a http://localhost:8089"
    echo ""
    echo -e "${CYAN}3) PRUEBA DE CARGA (sin interfaz)${NC}"
    echo "   - 30 usuarios, 5 minutos"
    echo "   - Simula carga normal del sistema"
    echo ""
    echo -e "${CYAN}4) PRUEBA DE ESTRÉS (sin interfaz)${NC}"
    echo "   - 100 usuarios, 10 minutos"
    echo "   - Prueba los límites del sistema"
    echo ""
    echo -e "${CYAN}5) PRUEBA DE SERVICIO ESPECÍFICO${NC}"
    echo "   - Escoge un servicio y ejecuta pruebas"
    echo ""
    echo -e "${CYAN}6) ANALIZAR RESULTADO ANTERIOR${NC}"
    echo "   - Genera reporte HTML de resultados"
    echo ""
    echo -e "${CYAN}0) SALIR${NC}"
    echo ""
    read -p "Selecciona opción (0-6): " option
}

# Explicación
show_explanation() {
    clear
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║    ¿QUÉ SON LAS PRUEBAS DE RENDIMIENTO Y ESTRÉS?               ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${GREEN}📊 PRUEBA DE CARGA (Load Testing)${NC}"
    echo "   - Simula usuarios normales usando el sistema"
    echo "   - Valida que cumple objetivos de rendimiento"
    echo "   - Típicamente: 10-100 usuarios"
    echo "   - Objetivo: Todos los endpoints responden < 500ms"
    echo ""
    
    echo -e "${YELLOW}⚡ PRUEBA DE ESTRÉS (Stress Testing)${NC}"
    echo "   - Incrementa carga gradualmente hasta punto de quiebre"
    echo "   - Encuentra el máximo de usuarios concurrentes"
    echo "   - Típicamente: 100-1000 usuarios"
    echo "   - Objetivo: Identificar límite del sistema"
    echo ""
    
    echo -e "${RED}🔥 PRUEBA DE RESISTENCIA (Endurance Testing)${NC}"
    echo "   - Mantiene carga constante por tiempo prolongado"
    echo "   - Detecta memory leaks y degradación"
    echo "   - Típicamente: 30 usuarios, 1-2 horas"
    echo "   - Objetivo: Sistema estable en el tiempo"
    echo ""
    
    echo -e "${CYAN}📈 MÉTRICAS IMPORTANTES${NC}"
    echo "   • Response Time: Tiempo de respuesta del servidor"
    echo "   • Throughput: Solicitudes procesadas por segundo"
    echo "   • Error Rate: Porcentaje de solicitudes fallidas"
    echo "   • P95/P99: 95% y 99% de respuestas bajo este tiempo"
    echo ""
    
    echo -e "${CYAN}🎯 CASOS DE USO REALISTAS${NC}"
    echo "   1. Usuario busca productos → GET /products?query=laptop"
    echo "   2. Abre detalles → GET /products/5"
    echo "   3. Agrega a favoritos → POST /favourites"
    echo "   4. Crea orden → POST /orders"
    echo "   5. Realiza pago → POST /payments"
    echo "   6. Rastrea envío → GET /shippings/123"
    echo ""
    
    read -p "Presiona Enter para volver al menú..."
    show_menu
}

# Demostración interactiva
demo_interactive() {
    clear
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║    DEMOSTRACIÓN INTERACTIVA                                   ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${YELLOW}Iniciando prueba con interfaz web...${NC}"
    echo ""
    echo -e "${CYAN}Configuración:${NC}"
    echo "  • Usuarios: 5"
    echo "  • Tasa: 1 usuario/segundo"
    echo "  • Duración: 2 minutos"
    echo ""
    echo -e "${GREEN}Interfaz web disponible en: http://localhost:8089${NC}"
    echo ""
    echo "Controles en la interfaz web:"
    echo "  • Start: Inicia la prueba"
    echo "  • Stop: Detiene la prueba"
    echo "  • Charts: Visualiza gráficos en tiempo real"
    echo "  • Download: Descarga resultados en CSV"
    echo ""
    read -p "Presiona Enter para iniciar (asegúrate que los servicios estén corriendo)..."
    
    if [ -f "run_performance_tests.sh" ]; then
        chmod +x run_performance_tests.sh
        ./run_performance_tests.sh -u 5 -r 1 -t 2m -h http://localhost:8100
    else
        echo -e "${RED}Error: No se encontró run_performance_tests.sh${NC}"
    fi
}

# Prueba de carga
demo_load_test() {
    clear
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║    PRUEBA DE CARGA                                           ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${CYAN}Configuración:${NC}"
    echo "  • Usuarios: 30"
    echo "  • Tasa: 3 usuarios/segundo"
    echo "  • Duración: 5 minutos"
    echo "  • Modo: Headless (sin interfaz)"
    echo ""
    echo -e "${YELLOW}Validará que el sistema maneja carga normal correctamente.${NC}"
    echo ""
    read -p "Presiona Enter para iniciar..."
    
    if [ -f "run_performance_tests.sh" ]; then
        chmod +x run_performance_tests.sh
        ./run_performance_tests.sh -u 30 -r 3 -t 5m --summary
    else
        echo -e "${RED}Error: No se encontró run_performance_tests.sh${NC}"
    fi
}

# Prueba de estrés
demo_stress_test() {
    clear
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║    PRUEBA DE ESTRÉS                                          ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${CYAN}Configuración:${NC}"
    echo "  • Usuarios: 100"
    echo "  • Tasa: 10 usuarios/segundo"
    echo "  • Duración: 10 minutos"
    echo "  • Modo: Headless (sin interfaz)"
    echo ""
    echo -e "${RED}⚠️  ADVERTENCIA: Esta prueba ejercerá carga significativa${NC}"
    echo "Asegúrate que los servicios tienen suficientes recursos."
    echo ""
    read -p "¿Continuar? (s/n): " confirm
    
    if [ "$confirm" = "s" ] || [ "$confirm" = "S" ]; then
        if [ -f "run_performance_tests.sh" ]; then
            chmod +x run_performance_tests.sh
            ./run_performance_tests.sh -u 100 -r 10 -t 10m --summary
        else
            echo -e "${RED}Error: No se encontró run_performance_tests.sh${NC}"
        fi
    else
        echo "Prueba cancelada."
    fi
}

# Prueba de servicio específico
demo_service_test() {
    clear
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║    PRUEBA DE SERVICIO ESPECÍFICO                              ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${CYAN}Servicios disponibles:${NC}"
    echo "  1) Product Service (Búsqueda y visualización de productos)"
    echo "  2) Order Service (Creación y gestión de órdenes)"
    echo "  3) Payment Service (Procesamiento de pagos)"
    echo "  4) Favourite Service (Gestión de favoritos)"
    echo "  5) Shipping Service (Rastreo de envíos)"
    echo ""
    read -p "Selecciona servicio (1-5): " service_num
    
    case $service_num in
        1) SERVICE="products" ;;
        2) SERVICE="orders" ;;
        3) SERVICE="payments" ;;
        4) SERVICE="favorites" ;;
        5) SERVICE="shipping" ;;
        *) echo "Opción inválida"; return ;;
    esac
    
    read -p "Número de usuarios (default 20): " users
    users=${users:-20}
    
    read -p "Duración en minutos (default 5): " minutes
    minutes=${minutes:-5}
    
    if [ -f "test_service.sh" ]; then
        chmod +x test_service.sh
        ./test_service.sh "$SERVICE" -u "$users" -t "${minutes}m"
    else
        echo -e "${RED}Error: No se encontró test_service.sh${NC}"
    fi
}

# Analizar resultados
demo_analyze() {
    clear
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║    ANALIZAR RESULTADOS                                        ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    if [ ! -d "performance-results" ]; then
        echo -e "${YELLOW}No hay resultados previos.${NC}"
        echo "Ejecuta primero una prueba para generar resultados."
        read -p "Presiona Enter para volver..."
        return
    fi
    
    echo -e "${CYAN}Archivos de resultados disponibles:${NC}"
    ls -1 performance-results/*_stats.csv 2>/dev/null | nl || echo "No hay resultados"
    
    read -p "Ingresa el número del archivo o presiona Enter para el más reciente: " file_num
    
    if [ -z "$file_num" ]; then
        latest=$(ls -t performance-results/*_stats.csv 2>/dev/null | head -1)
        if [ -n "$latest" ]; then
            file_num="$latest"
        fi
    else
        file_num=$(ls -1 performance-results/*_stats.csv 2>/dev/null | sed -n "${file_num}p")
    fi
    
    if [ -z "$file_num" ]; then
        echo -e "${RED}Error: No se encontró el archivo${NC}"
        read -p "Presiona Enter para volver..."
        return
    fi
    
    if [ -f "generate_report.py" ]; then
        echo -e "${YELLOW}Generando reporte HTML...${NC}"
        python3 generate_report.py "$file_num"
        echo ""
        echo -e "${GREEN}✅ Reporte generado${NC}"
    else
        echo -e "${RED}Error: No se encontró generate_report.py${NC}"
    fi
    
    read -p "Presiona Enter para volver..."
}

# Bucle principal
while true; do
    show_menu
    
    case $option in
        1)
            show_explanation
            ;;
        2)
            demo_interactive
            ;;
        3)
            demo_load_test
            ;;
        4)
            demo_stress_test
            ;;
        5)
            demo_service_test
            ;;
        6)
            demo_analyze
            ;;
        0)
            echo -e "${GREEN}¡Gracias por usar la demostración!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Opción inválida${NC}"
            sleep 2
            ;;
    esac
done
