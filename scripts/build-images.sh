#!/bin/bash

# Script para construir todas las imágenes Docker localmente

# NO usar set -e para evitar que el script se detenga en errores
# set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuración
REGISTRY="ghcr.io/davidone007"
BRANCH_TAG="${BRANCH_TAG:-latest}"
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Array de servicios con sus paths
declare -A SERVICES=(
    ["service-discovery"]="service-discovery"
    ["cloud-config"]="cloud-config"
    ["api-gateway"]="api-gateway"
    ["proxy-client"]="proxy-client"
    ["order-service"]="order-service"
    ["payment-service"]="payment-service"
    ["product-service"]="product-service"
    ["shipping-service"]="shipping-service"
    ["user-service"]="user-service"
    ["favourite-service"]="favourite-service"
)

echo -e "${BLUE}🐳 Script de Construcción de Imágenes Docker${NC}"
echo ""
echo "📍 Base directory: $BASE_DIR"
echo "📦 Registry: $REGISTRY"
echo "🏷️  Tag: $BRANCH_TAG"
echo ""

# Verificar que docker está instalado
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker no está instalado${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Docker está disponible${NC}"
echo ""

# Mostrar servicios a construir
echo -e "${BLUE}📋 Servicios a construir:${NC}"
for service in "${!SERVICES[@]}"; do
    echo "   - $service"
done
echo ""

# Preguntar confirmación
read -p "¿Continuar con la construcción de todas las imágenes? (s/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "Operación cancelada."
    exit 0
fi

echo ""
echo -e "${BLUE}🔨 Iniciando construcción de imágenes...${NC}"
echo ""

# Variables para estadísticas
TOTAL_SERVICES=${#SERVICES[@]}
BUILT=0
FAILED=0
FAILED_SERVICES=()

# Primero, construir todos los JARs con Maven
echo -e "${BLUE}📦 Paso 1: Construyendo JARs con Maven...${NC}"
echo ""

for service in "${!SERVICES[@]}"; do
    SERVICE_PATH="${SERVICES[$service]}"
    FULL_PATH="$BASE_DIR/$SERVICE_PATH"
    
    echo -e "${YELLOW}🏗️  Construyendo JAR: ${service}${NC}"
    
    # Verificar que el directorio existe
    if [ ! -d "$FULL_PATH" ]; then
        echo -e "   ${RED}❌ Directorio no encontrado: $FULL_PATH${NC}"
        ((FAILED++))
        FAILED_SERVICES+=("$service")
        echo ""
        continue
    fi
    
    # Verificar que existe pom.xml
    if [ ! -f "$FULL_PATH/pom.xml" ]; then
        echo -e "   ${RED}❌ pom.xml no encontrado en: $FULL_PATH${NC}"
        ((FAILED++))
        FAILED_SERVICES+=("$service")
        echo ""
        continue
    fi
    
    # Construir el JAR
    echo "   ⏳ Compilando con Maven (esto puede tardar unos minutos)..."
    if cd "$FULL_PATH" && ./mvnw clean package -DskipTests > /dev/null 2>&1; then
        echo -e "   ${GREEN}✅ JAR construido exitosamente${NC}"
    else
        echo -e "   ${RED}❌ Error al construir JAR${NC}"
        ((FAILED++))
        FAILED_SERVICES+=("$service")
        cd "$BASE_DIR"
        echo ""
        continue
    fi
    
    cd "$BASE_DIR"
    echo ""
done

if [ $FAILED -gt 0 ]; then
    echo -e "${RED}⚠️  Hay errores en la compilación de JARs. Abortando.${NC}"
    exit 1
fi

echo -e "${BLUE}✅ Todos los JARs compilados exitosamente${NC}"
echo ""

# Reset counters para fase Docker
BUILT=0
FAILED=0
FAILED_SERVICES=()

echo -e "${BLUE}📦 Paso 2: Construyendo imágenes Docker...${NC}"
echo ""

# Ahora construir las imágenes Docker
for service in "${!SERVICES[@]}"; do
    SERVICE_PATH="${SERVICES[$service]}"
    FULL_PATH="$BASE_DIR/$SERVICE_PATH"
    IMAGE_NAME="${REGISTRY}/${service}:${BRANCH_TAG}"
    
    echo -e "${YELLOW}🐳 Construyendo imagen: ${service}${NC}"
    echo "   Imagen: $IMAGE_NAME"
    
    # Verificar que existe Dockerfile
    if [ ! -f "$FULL_PATH/Dockerfile" ]; then
        echo -e "   ${RED}❌ Dockerfile no encontrado en: $FULL_PATH${NC}"
        ((FAILED++))
        FAILED_SERVICES+=("$service")
        echo ""
        continue
    fi
    
    # Construir la imagen Docker
    echo "   ⏳ Construyendo imagen..."
    
    # Construir sin detener el script en errores
    docker build -t "$IMAGE_NAME" \
        --build-arg PROJECT_VERSION="0.1.0" \
        -f "$FULL_PATH/Dockerfile" \
        "$BASE_DIR" > /dev/null 2>&1
    BUILD_EXIT=$?
    
    if [ $BUILD_EXIT -eq 0 ]; then
        echo -e "   ${GREEN}✅ Imagen construida exitosamente${NC}"
        ((BUILT++))
        
        # Mostrar información de la imagen
        IMAGE_SIZE=$(docker images "$IMAGE_NAME" --format "{{.Size}}" 2>/dev/null || echo "N/A")
        echo "   📊 Tamaño: $IMAGE_SIZE"
    else
        echo -e "   ${RED}❌ Error al construir la imagen (código: $BUILD_EXIT)${NC}"
        ((FAILED++))
        FAILED_SERVICES+=("$service")
    fi
    
    echo ""
done

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo -e "Resumen de Construcción de Imágenes:"
echo -e "${GREEN}✅ Construidas: ${BUILT}/${TOTAL_SERVICES}${NC}"
if [ $FAILED -gt 0 ]; then
    echo -e "${RED}❌ Fallidas: ${FAILED}/${TOTAL_SERVICES}${NC}"
    echo -e "${YELLOW}Servicios fallidos:${NC}"
    for failed_service in "${FAILED_SERVICES[@]}"; do
        echo "   - $failed_service"
    done
fi
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo ""

# Mostrar imágenes construidas
echo "📊 Imágenes disponibles localmente:"
docker images | grep "$REGISTRY" || echo "   (ninguna encontrada)"
echo ""

# Opciones siguientes
if [ $FAILED -eq 0 ]; then
    echo -e "${BLUE}📚 Próximos pasos:${NC}"
    echo ""
    echo "1. Desplegar en Kubernetes:"
    echo "   ./scripts/deploy-k8s.sh <tag>"
    echo ""
    echo "   Ejemplo:"
    echo "   ./scripts/deploy-k8s.sh ${BRANCH_TAG}"
    echo ""
    echo -e "${GREEN}✨ ¡Imágenes construidas exitosamente!${NC}"
else
    echo -e "${RED}⚠️  Hay errores en la construcción. Revisa los logs anteriores.${NC}"
    exit 1
fi
