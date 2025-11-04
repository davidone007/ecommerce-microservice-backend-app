#!/bin/bash

# Script para cargar imágenes Docker locales en Minikube

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuración
REGISTRY="ghcr.io/davidone007"
BRANCH_TAG="${BRANCH_TAG:-latest}"
SERVICES=(
    "service-discovery"
    "cloud-config"
    "api-gateway"
    "proxy-client"
    "order-service"
    "payment-service"
    "product-service"
    "shipping-service"
    "user-service"
    "favourite-service"
)

echo -e "${BLUE}🐳 Script de Carga de Imágenes Docker en Minikube${NC}"
echo ""

# Verificar si minikube está corriendo
echo "🔍 Verificando estado de Minikube..."
if ! minikube status | grep -q "host: Running"; then
    echo -e "${RED}❌ Minikube no está corriendo${NC}"
    echo "Ejecuta: ./scripts/start-minikube.sh"
    exit 1
fi

echo -e "${GREEN}✅ Minikube está corriendo${NC}"
echo ""

# Verificar si las imágenes existen localmente (en Docker host, no en minikube)
echo -e "${BLUE}📋 Imágenes a cargar (desde construcción local):${NC}"
for service in "${SERVICES[@]}"; do
    echo "   - ${REGISTRY}/${service}:${BRANCH_TAG}"
done
echo ""

# Preguntar si continuar
read -p "¿Continuar con la carga de imágenes en Minikube? (s/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "Operación cancelada."
    exit 0
fi

echo ""
echo -e "${BLUE}🔄 Iniciando carga de imágenes en Minikube...${NC}"
echo ""

# Variables para estadísticas
TOTAL_SERVICES=${#SERVICES[@]}
LOADED=0
FAILED=0

# Cargar cada imagen en minikube usando minikube image load
for service in "${SERVICES[@]}"; do
    IMAGE_NAME="${REGISTRY}/${service}:${BRANCH_TAG}"
    echo -e "${YELLOW}📦 Procesando: ${IMAGE_NAME}${NC}"
    
    # Verificar si la imagen existe en Docker local (sin eval minikube docker-env)
    if docker image inspect "${IMAGE_NAME}" &> /dev/null; then
        echo "   ✓ Imagen encontrada en Docker local"
        
        # Cargar la imagen en minikube
        echo "   ⏳ Cargando en Minikube..."
        if minikube image load "${IMAGE_NAME}" > /dev/null 2>&1; then
            echo -e "   ${GREEN}✅ Imagen cargada exitosamente en Minikube${NC}"
            ((LOADED++))
        else
            echo -e "   ${RED}⚠️  Error al cargar la imagen en Minikube${NC}"
            ((FAILED++))
        fi
    else
        echo -e "   ${RED}❌ Imagen NO encontrada en Docker local${NC}"
        echo "   Construye primero la imagen:"
        echo "   ./scripts/build-images.sh"
        ((FAILED++))
    fi
    echo ""
done

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo -e "Resumen de Carga de Imágenes:"
echo -e "${GREEN}✅ Cargadas: ${LOADED}/${TOTAL_SERVICES}${NC}"
if [ $FAILED -gt 0 ]; then
    echo -e "${RED}❌ Fallidas: ${FAILED}/${TOTAL_SERVICES}${NC}"
fi
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo ""

# Mostrar imágenes disponibles en minikube
echo "📊 Imágenes disponibles en Minikube:"
minikube image ls | grep "${REGISTRY}" || echo "   (ninguna encontrada)"
echo ""

# Verificar imágenes en Kubernetes
echo "🔍 Para verificar las imágenes en el cluster de Kubernetes:"
echo "   minikube image ls | grep ghcr.io/davidone007"
echo ""

# Opciones siguientes
echo -e "${BLUE}📚 Próximos pasos:${NC}"
echo "1. Desplegar los servicios:"
echo "   ./scripts/deploy-k8s.sh ${BRANCH_TAG}"
echo ""
echo "2. Ver estado de los pods:"
echo "   kubectl get pods"
echo ""
echo "3. Ver logs de un pod:"
echo "   kubectl logs -f <pod-name>"
echo ""
echo "4. Port forwarding:"
echo "   kubectl port-forward svc/service-discovery-container 8761:8761"
echo ""

echo -e "${GREEN}✨ ¡Listo para desplegar!${NC}"
