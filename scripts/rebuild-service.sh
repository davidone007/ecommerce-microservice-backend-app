#!/bin/bash

# Script para compilar, construir imagen y cargar a Minikube un servicio específico

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuración
REGISTRY="ghcr.io/davidone007"
SERVICE_NAME="${1}"
BRANCH_TAG="${2:-latest}"
NAMESPACE="${3:-dev}"
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Validar entrada
if [ -z "$SERVICE_NAME" ]; then
    echo -e "${BLUE}🔨 Script de Compilación, Build y Carga de Servicio${NC}"
    echo ""
    echo "Uso: $0 <service-name> [tag] [namespace]"
    echo ""
    echo "Servicios disponibles:"
    echo "   - service-discovery"
    echo "   - cloud-config"
    echo "   - api-gateway"
    echo "   - proxy-client"
    echo "   - order-service"
    echo "   - payment-service"
    echo "   - product-service"
    echo "   - shipping-service"
    echo "   - user-service"
    echo "   - favourite-service"
    echo ""
    echo "Ejemplo:"
    echo "   $0 user-service"
    echo "   $0 order-service v1.0.0"
    exit 0
fi

echo -e "${BLUE}🔨 Compilación, Build y Carga de Servicio${NC}"
echo ""
echo "📍 Base directory: $BASE_DIR"
echo "🎯 Servicio: $SERVICE_NAME"
echo "📦 Registry: $REGISTRY"
echo "🏷️  Tag: $BRANCH_TAG"
echo "🌐 Namespace: $NAMESPACE"
echo ""

# Validar que el servicio existe
SERVICE_PATH="$BASE_DIR/$SERVICE_NAME"
if [ ! -d "$SERVICE_PATH" ]; then
    echo -e "${RED}❌ Servicio no encontrado: $SERVICE_PATH${NC}"
    exit 1
fi

if [ ! -f "$SERVICE_PATH/pom.xml" ]; then
    echo -e "${RED}❌ pom.xml no encontrado en: $SERVICE_PATH${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Servicio encontrado${NC}"
echo ""

# ============================================================================
# PASO 1: Compilar con Maven
# ============================================================================
echo -e "${BLUE}📦 Paso 1: Compilando JAR con Maven...${NC}"
echo ""

cd "$SERVICE_PATH"
echo "📍 Directorio: $(pwd)"
echo ""

echo "⏳ Compilando (esto puede tardar unos minutos)..."
if ./mvnw clean package -DskipTests > /tmp/maven_build.log 2>&1; then
    echo -e "${GREEN}✅ JAR compilado exitosamente${NC}"
else
    echo -e "${RED}❌ Error al compilar JAR${NC}"
    echo "Revisa: /tmp/maven_build.log"
    exit 1
fi

cd "$BASE_DIR"
echo ""

# ============================================================================
# PASO 2: Construir imagen Docker
# ============================================================================
echo -e "${BLUE}🐳 Paso 2: Construyendo imagen Docker...${NC}"
echo ""

IMAGE_NAME="${REGISTRY}/${SERVICE_NAME}:${BRANCH_TAG}"
DOCKERFILE="$SERVICE_PATH/Dockerfile"

if [ ! -f "$DOCKERFILE" ]; then
    echo -e "${RED}❌ Dockerfile no encontrado: $DOCKERFILE${NC}"
    exit 1
fi

echo "📸 Imagen: $IMAGE_NAME"
echo ""

echo "⏳ Construyendo imagen (esto puede tardar unos minutos)..."
if docker build -t "$IMAGE_NAME" \
    --build-arg PROJECT_VERSION="0.1.0" \
    -f "$DOCKERFILE" \
    "$BASE_DIR" > /tmp/docker_build.log 2>&1; then
    
    echo -e "${GREEN}✅ Imagen construida exitosamente${NC}"
    
    # Mostrar información de la imagen
    IMAGE_SIZE=$(docker images "$IMAGE_NAME" --format "{{.Size}}")
    echo "📊 Tamaño: $IMAGE_SIZE"
else
    echo -e "${RED}❌ Error al construir la imagen${NC}"
    echo "Revisa: /tmp/docker_build.log"
    exit 1
fi

echo ""

# ============================================================================
# PASO 3: Verificar Minikube
# ============================================================================
echo -e "${BLUE}🚀 Paso 3: Verificando Minikube...${NC}"
echo ""

if ! minikube status | grep -q "host: Running"; then
    echo -e "${RED}❌ Minikube no está corriendo${NC}"
    echo "Ejecuta: minikube start --memory=16384 --cpus=4"
    exit 1
fi

echo -e "${GREEN}✅ Minikube está corriendo${NC}"
echo ""

# ============================================================================
# PASO 4: Cargar imagen en Minikube
# ============================================================================
echo -e "${BLUE}📦 Paso 4: Cargando imagen en Minikube...${NC}"
echo ""

echo "⏳ Cargando imagen (esto puede tardar unos minutos)..."
if minikube image load "$IMAGE_NAME" > /tmp/minikube_load.log 2>&1; then
    echo -e "${GREEN}✅ Imagen cargada exitosamente en Minikube${NC}"
else
    echo -e "${RED}❌ Error al cargar la imagen en Minikube${NC}"
    echo "Revisa: /tmp/minikube_load.log"
    exit 1
fi

echo ""

# ============================================================================
# PASO 5: Reiniciar deployment en Kubernetes
# ============================================================================
echo -e "${BLUE}🔄 Paso 5: Actualizando deployment con Helm...${NC}"
echo ""

RELEASE_NAME="ecommerce-local"
CHART_PATH="$BASE_DIR/helm/ecommerce-microservices"
VALUES_FILE="$CHART_PATH/values.yaml"

# Verificar helm
if ! command -v helm &> /dev/null; then
    echo -e "${RED}❌ helm no está instalado${NC}"
    exit 1
fi

echo "🚀 Actualizando servicio $SERVICE_NAME a tag $BRANCH_TAG..."

# Usamos helm upgrade para actualizar solo la imagen de este servicio
# Si el release existe, usamos --reuse-values para mantener otras configuraciones
# Si no existe, instalamos desde cero

if helm list -n "$NAMESPACE" | grep -q "$RELEASE_NAME"; then
    echo "   Release encontrado, actualizando..."
    if helm upgrade "$RELEASE_NAME" "$CHART_PATH" \
        --namespace "$NAMESPACE" \
        --reuse-values \
        --set services.${SERVICE_NAME}.tag="$BRANCH_TAG"; then
        echo -e "${GREEN}✅ Helm upgrade exitoso${NC}"
    else
        echo -e "${RED}❌ Error en Helm upgrade${NC}"
        exit 1
    fi
else
    echo "   Release no encontrado, instalando..."
    if helm upgrade --install "$RELEASE_NAME" "$CHART_PATH" \
        -f "$VALUES_FILE" \
        --namespace "$NAMESPACE" \
        --create-namespace \
        --set services.${SERVICE_NAME}.tag="$BRANCH_TAG"; then
        echo -e "${GREEN}✅ Helm install exitoso${NC}"
    else
        echo -e "${RED}❌ Error en Helm install${NC}"
        exit 1
    fi
fi

echo ""
echo "⏳ Esperando a que el pod esté listo (máximo 2 minutos)..."
# El nombre del deployment suele ser el nombre del servicio + "-container" según el chart
DEPLOYMENT_NAME="${SERVICE_NAME}-container"

if kubectl rollout status deployment/"$DEPLOYMENT_NAME" -n "$NAMESPACE" --timeout=120s; then
    echo -e "${GREEN}✅ Deployment actualizado exitosamente${NC}"
else
    echo -e "${YELLOW}⚠️  Timeout esperando el deployment${NC}"
    echo "Revisa el estado con:"
    echo "   kubectl get pods -n $NAMESPACE | grep $SERVICE_NAME"
    echo "   kubectl describe pod <pod-name> -n $NAMESPACE"
fi

echo ""

# ============================================================================
# RESUMEN
# ============================================================================
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo -e "${GREEN}✨ Proceso completado${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo ""

echo -e "${BLUE}📊 Estado actual:${NC}"
echo ""
echo "Imagen:"
docker images "$IMAGE_NAME" --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"
echo ""

echo "Pod en Kubernetes:"
kubectl get pods -n "$NAMESPACE" -l "io.kompose.service=${SERVICE_NAME}-container" -o wide
echo ""

echo -e "${BLUE}📚 Comandos útiles:${NC}"
echo ""
echo "Ver logs del servicio:"
echo "  kubectl logs -f deployment/${SERVICE_NAME}-container -n $NAMESPACE"
echo ""
echo "Describir el pod:"
echo "  kubectl describe pod <pod-name> -n $NAMESPACE"
echo ""
echo "Port forwarding:"
echo "  kubectl port-forward svc/${SERVICE_NAME}-container <port> -n $NAMESPACE"
echo ""

echo -e "${GREEN}✨ ¡Listo!${NC}"
