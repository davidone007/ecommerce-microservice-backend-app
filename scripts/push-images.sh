#!/bin/bash

# Script para subir imágenes Docker al registro de GitHub (GHCR)

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuración
REGISTRY="ghcr.io/davidone007"
BRANCH_TAG="${1:-latest}"
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

echo -e "${BLUE}🚀 Script de Push de Imágenes a GHCR${NC}"
echo ""
echo "📦 Registry: $REGISTRY"
echo "🏷️  Tag: $BRANCH_TAG"
echo ""

# Verificar login en Docker
echo "🔍 Verificando autenticación en Docker..."
# Nota: Esto es una verificación básica, puede que no detecte todos los estados de login
if ! docker info | grep -q "Username"; then
    echo -e "${YELLOW}⚠️  Advertencia: No parece haber una sesión activa en Docker Hub/GHCR.${NC}"
    echo "Asegúrate de haber hecho login con: echo \$CR_PAT | docker login ghcr.io -u USERNAME --password-stdin"
    echo ""
fi

# Verificar si las imágenes existen localmente
echo -e "${BLUE}📋 Imágenes a subir:${NC}"
for service in "${SERVICES[@]}"; do
    echo "   - ${REGISTRY}/${service}:${BRANCH_TAG}"
done
echo ""

# Preguntar si continuar
read -p "¿Continuar con el push de imágenes? (s/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "Operación cancelada."
    exit 0
fi

echo ""
echo -e "${BLUE}🔄 Iniciando push de imágenes...${NC}"
echo ""

# Variables para estadísticas
TOTAL_SERVICES=${#SERVICES[@]}
PUSHED=0
FAILED=0

# Subir cada imagen
for service in "${SERVICES[@]}"; do
    IMAGE_NAME="${REGISTRY}/${service}:${BRANCH_TAG}"
    echo -e "${YELLOW}📦 Procesando: ${IMAGE_NAME}${NC}"
    
    # Verificar si la imagen existe localmente
    if docker image inspect "${IMAGE_NAME}" &> /dev/null; then
        echo "   ✓ Imagen encontrada localmente"
        
        # Push de la imagen
        echo "   ⬆️  Subiendo a GHCR..."
        if docker push "${IMAGE_NAME}"; then
            echo -e "   ${GREEN}✅ Imagen subida exitosamente${NC}"
            ((PUSHED++))
        else
            echo -e "   ${RED}❌ Error al subir la imagen${NC}"
            ((FAILED++))
        fi
    else
        echo -e "   ${RED}❌ Imagen NO encontrada localmente${NC}"
        echo "   Construye primero la imagen con: ./scripts/build-images.sh"
        ((FAILED++))
    fi
    echo ""
done

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo -e "Resumen de Push:"
echo -e "${GREEN}✅ Subidas: ${PUSHED}/${TOTAL_SERVICES}${NC}"
if [ $FAILED -gt 0 ]; then
    echo -e "${RED}❌ Fallidas: ${FAILED}/${TOTAL_SERVICES}${NC}"
fi
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo ""

echo -e "${GREEN}✨ ¡Proceso completado!${NC}"
