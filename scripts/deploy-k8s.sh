#!/bin/bash

# Script para desplegar usando Helm

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuración
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CHART_PATH="$BASE_DIR/helm/ecommerce-microservices"
VALUES_FILE="$CHART_PATH/values.yaml"
BRANCH_TAG="${1:-latest}"
NAMESPACE="${2:-dev}"
RELEASE_NAME="ecommerce-local"

echo -e "${BLUE}🚀 Script de Despliegue con Helm${NC}"
echo ""
echo "📍 Base directory: $BASE_DIR"
echo "🏷️  Image Tag: $BRANCH_TAG"
echo "🌐 Namespace: $NAMESPACE"
echo "📦 Release Name: $RELEASE_NAME"
echo ""

# Validar que exista el chart
if [ ! -d "$CHART_PATH" ]; then
    echo -e "${RED}❌ Chart de Helm no encontrado: $CHART_PATH${NC}"
    exit 1
fi

# Verificar helm está disponible
if ! command -v helm &> /dev/null; then
    echo -e "${RED}❌ helm no está instalado${NC}"
    exit 1
fi

echo -e "${GREEN}✅ helm está disponible${NC}"
echo ""

# Verificar kubectl está disponible
if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}❌ kubectl no está instalado${NC}"
    exit 1
fi

echo -e "${GREEN}✅ kubectl está disponible${NC}"
echo ""

# Desplegar con Helm
echo -e "${BLUE}🚀 Ejecutando helm upgrade --install...${NC}"
echo ""

if helm upgrade --install "$RELEASE_NAME" "$CHART_PATH" \
    -f "$VALUES_FILE" \
    --set global.imageTag="$BRANCH_TAG" \
    --namespace "$NAMESPACE" \
    --create-namespace; then
    
    echo ""
    echo -e "${GREEN}✅ Despliegue exitoso${NC}"
else
    echo ""
    echo -e "${RED}❌ Error al desplegar con Helm${NC}"
    exit 1
fi

echo ""

# Mostrar estado de los pods
echo -e "${BLUE}📊 Estado de los pods:${NC}"
echo ""
kubectl get pods -o wide -n "$NAMESPACE"

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo -e "${GREEN}✨ Despliegue completado${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo ""

# Mostrar comandos útiles
echo -e "${BLUE}📚 Comandos útiles:${NC}"
echo ""
echo "Ver logs de un servicio:"
echo "  kubectl logs -f -l app=service-discovery-container -n $NAMESPACE"
echo ""
echo "Listar releases de Helm:"
echo "  helm list -n $NAMESPACE"
echo ""
echo "Desinstalar release:"
echo "  helm uninstall $RELEASE_NAME -n $NAMESPACE"
echo ""

echo -e "${GREEN}✨ ¡Listo!${NC}"
