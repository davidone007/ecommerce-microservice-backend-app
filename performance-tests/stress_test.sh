#!/bin/bash

# Script para ejecutar pruebas de estrés intensivas
# Simula carga máxima al sistema

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  PRUEBA DE ESTRÉS INTENSIVA - E-COMMERCE MICROSERVICES        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Diferentes niveles de estrés
echo -e "${GREEN}Selecciona el nivel de estrés:${NC}"
echo "1) LIGERO    - 20 usuarios, 2 min"
echo "2) MODERADO  - 50 usuarios, 5 min"
echo "3) FUERTE    - 100 usuarios, 10 min"
echo "4) CRÍTICO   - 200 usuarios, 15 min"
echo "5) PERSONALIZADO"
echo ""
read -p "Selecciona una opción (1-5): " option

case $option in
    1)
        echo -e "${YELLOW}Ejecutando prueba LIGERA...${NC}"
        ./run_performance_tests.sh -u 20 -r 2 -t 2m --summary
        ;;
    2)
        echo -e "${YELLOW}Ejecutando prueba MODERADA...${NC}"
        ./run_performance_tests.sh -u 50 -r 5 -t 5m --summary
        ;;
    3)
        echo -e "${YELLOW}Ejecutando prueba FUERTE...${NC}"
        ./run_performance_tests.sh -u 100 -r 10 -t 10m --summary
        ;;
    4)
        echo -e "${YELLOW}Ejecutando prueba CRÍTICA...${NC}"
        ./run_performance_tests.sh -u 200 -r 20 -t 15m --summary
        ;;
    5)
        read -p "Número de usuarios: " users
        read -p "Tasa de generación (usuarios/segundo): " rate
        read -p "Duración (ej: 5m, 60s): " time
        echo -e "${YELLOW}Ejecutando prueba PERSONALIZADA...${NC}"
        ./run_performance_tests.sh -u "$users" -r "$rate" -t "$time" --summary
        ;;
    *)
        echo -e "${RED}Opción inválida${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}✅ Prueba de estrés completada${NC}"
