#!/bin/bash

# Script para reemplazar ${BRANCH_TAG} en los archivos YAML de Kubernetes y desplegar

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuración
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
K8S_DIR="$BASE_DIR/k8s"
BRANCH_TAG="${1:-latest}"
NAMESPACE="${2:-dev}"

echo -e "${BLUE}🚀 Script de Despliegue en Kubernetes${NC}"
echo ""
echo "📍 Base directory: $BASE_DIR"
echo "🏷️  Branch tag: $BRANCH_TAG"
echo "🌐 Namespace: $NAMESPACE"
echo ""

# Validar que exista el directorio k8s
if [ ! -d "$K8S_DIR" ]; then
    echo -e "${RED}❌ Directorio k8s no encontrado: $K8S_DIR${NC}"
    exit 1
fi

# Verificar kubectl está disponible
if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}❌ kubectl no está instalado${NC}"
    exit 1
fi

echo -e "${GREEN}✅ kubectl está disponible${NC}"
echo ""

# Verificar si las imágenes existen localmente
echo -e "${BLUE}🔍 Verificando imágenes Docker locales...${NC}"

# Array de servicios
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

IMAGES_FOUND=0
for service in "${SERVICES[@]}"; do
    IMAGE_NAME="ghcr.io/davidone007/${service}:${BRANCH_TAG}"
    if docker image inspect "$IMAGE_NAME" &> /dev/null; then
        ((IMAGES_FOUND++))
    fi
done

echo "   Imágenes encontradas: $IMAGES_FOUND/${#SERVICES[@]}"

if [ "$IMAGES_FOUND" -lt "${#SERVICES[@]}" ]; then
    echo -e "${YELLOW}⚠️  No todas las imágenes están disponibles localmente${NC}"
    echo "   Construye primero las imágenes con: ./scripts/build-images.sh"
    echo ""
    read -p "¿Continuar de todas formas? (s/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        echo "Operación cancelada."
        exit 0
    fi
else
    echo -e "${GREEN}✅ Todas las imágenes están disponibles${NC}"
fi
echo ""

# Crear archivo temporal para los YAML modificados
TEMP_DIR=$(mktemp -d)
echo "📁 Usando directorio temporal: $TEMP_DIR"
echo ""

# Copiar archivos YAML y reemplazar ${BRANCH_TAG}
echo -e "${BLUE}📝 Preparando archivos YAML...${NC}"
echo ""

# Copiar todos los archivos YAML al temporal, reemplazando variables
for yaml_file in "$K8S_DIR"/*.yaml; do
    filename=$(basename "$yaml_file")
    temp_file="$TEMP_DIR/$filename"
    
    # Reemplazar ${BRANCH_TAG} con el valor proporcionado
    sed "s/\${BRANCH_TAG}/$BRANCH_TAG/g" "$yaml_file" > "$temp_file"
    
    # Agregar imagePullPolicy: IfNotPresent después de cada línea de image (compatible con macOS)
    if grep -q "ghcr.io/davidone007" "$temp_file"; then
        # Crear archivo temporal para el procesamiento
        tmp_file="${temp_file}.tmp"
        while IFS= read -r line; do
            echo "$line"
            if [[ "$line" =~ "image: ghcr.io/davidone007" ]]; then
                echo "          imagePullPolicy: IfNotPresent"
            fi
        done < "$temp_file" > "$tmp_file"
        mv "$tmp_file" "$temp_file"
    fi
    
    echo -e "✓ Procesado: $filename"
done

echo ""
echo -e "${YELLOW}📋 Archivos modificados:${NC}"
grep -l "ghcr.io/davidone007" "$TEMP_DIR"/*.yaml | while read file; do
    echo "   - $(basename $file)"
done
echo ""

# Mostrar preview de cambios
echo -e "${BLUE}🔍 Preview de imágenes a desplegar:${NC}"
grep "image: ghcr.io/davidone007" "$TEMP_DIR"/*.yaml | sed 's/.*image: //' | sort -u | while read image; do
    echo "   ✓ $image"
done
echo ""

# Preguntar confirmación
read -p "¿Continuar con el despliegue? (s/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "Operación cancelada."
    rm -rf "$TEMP_DIR"
    exit 0
fi

echo ""

# Aplicar los archivos YAML en el namespace especificado
echo -e "${BLUE}🚀 Desplegando servicios en namespace $NAMESPACE...${NC}"
echo ""

if kubectl apply -f "$TEMP_DIR" -n "$NAMESPACE"; then
    echo -e "${GREEN}✅ Archivos desplegados exitosamente${NC}"
else
    echo -e "${RED}❌ Error al desplegar archivos${NC}"
    rm -rf "$TEMP_DIR"
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
echo "  kubectl logs -f deployment/service-discovery-container"
echo ""
echo "Describir un pod:"
echo "  kubectl describe pod <pod-name>"
echo ""
echo "Ver estado de los deployments:"
echo "  kubectl get deployments"
echo ""
echo "Ver servicios:"
echo "  kubectl get svc"
echo ""
echo "Port forwarding:"
echo "  kubectl port-forward svc/service-discovery-container 8761:8761"
echo ""
echo "Eliminar todos los recursos:"
echo "  kubectl delete -f $K8S_DIR"
echo ""

# Limpiar archivo temporal
rm -rf "$TEMP_DIR"

echo -e "${GREEN}✨ ¡Listo!${NC}"
