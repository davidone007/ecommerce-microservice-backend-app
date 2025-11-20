#!/bin/bash

# Script maestro para levantamiento completo de Minikube + microservicios

set -e

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Funciones de utilidad
print_header() {
    echo ""
    echo -e "${BLUE}════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════${NC}"
    echo ""
}

print_step() {
    echo -e "${YELLOW}→ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Script principal
main() {
    print_header "🚀 SETUP COMPLETO - MINIKUBE + MICROSERVICIOS"
    
    # Obtener directorio base del script
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
    
    echo "📍 Directorio del proyecto: $PROJECT_DIR"
    echo ""
    
    # Menú interactivo
    echo "Selecciona una opción:"
    echo ""
    echo "1) Setup completo (Construir + Minikube + Cargar + Deploy)"
    echo "2) Solo construir imágenes"
    echo "3) Solo iniciar Minikube"
    echo "4) Solo cargar imágenes"
    echo "5) Solo desplegar servicios en Kubernetes"
    echo "6) Ver estado actual"
    echo "7) Limpiar todo (eliminar cluster y namespace)"
    echo ""
    read -p "Opción (1-7): " option
    
    case $option in
        1)
            full_setup
            ;;
        2)
            build_images_only
            ;;
        3)
            start_minikube_only
            ;;
        4)
            load_images_only
            ;;
        5)
            deploy_only
            ;;
        6)
            show_status
            ;;
        7)
            cleanup
            ;;
        *)
            print_error "Opción no válida"
            exit 1
            ;;
    esac
}

full_setup() {
    print_header "🔧 SETUP COMPLETO"
    
    # Solicitar tag de las imágenes
    echo "Ingresa el tag de las imágenes a usar (default: latest):"
    read -p "Tag: " TAG
    TAG="${TAG:-latest}"
    export BRANCH_TAG="$TAG"
    
    echo ""
    echo "Se usará el tag: $TAG"
    # Preguntar namespace
    echo "Ingresa el namespace donde desplegaremos (default: dev):"
    read -p "Namespace: " NAMESPACE
    NAMESPACE="${NAMESPACE:-dev}"
    export NAMESPACE
    echo ""
    
    # Paso 1: Construir imágenes
    print_step "Paso 1/4: Construir imágenes Docker"
    cd "$PROJECT_DIR"
    bash scripts/build-images.sh "$TAG"
    print_success "Imágenes construidas"
    
    echo ""
    read -p "Presiona Enter para continuar..." -t 10 || true
    
    # Paso 2: Iniciar Minikube
    print_step "Paso 2/4: Iniciar Minikube"
    bash scripts/start-minikube.sh
    print_success "Minikube iniciado"
    
    echo ""
    read -p "Presiona Enter para continuar..." -t 10 || true
    
    # Paso 3: Cargar imágenes
    print_step "Paso 3/4: Cargar imágenes en Minikube"
    bash scripts/load-images-minikube.sh "$TAG"
    print_success "Imágenes cargadas"
    
    echo ""
    read -p "Presiona Enter para continuar..." -t 10 || true
    
    # Paso 4: Desplegar servicios
    print_step "Paso 4/4: Desplegar servicios"
    bash scripts/deploy-k8s.sh "$TAG" "$NAMESPACE"
    print_success "Servicios desplegados"
    
    print_header "✨ SETUP COMPLETADO"
    echo "El cluster está listo. Usa los comandos anteriores para interactuar."
}

start_minikube_only() {
    print_header "🚀 INICIANDO MINIKUBE"
    cd "$PROJECT_DIR"
    bash scripts/start-minikube.sh
}

build_images_only() {
    print_header "🐳 CONSTRUYENDO IMÁGENES"
    cd "$PROJECT_DIR"
    echo "Ingresa el tag de las imágenes a construir (default: latest):"
    read -p "Tag: " TAG
    TAG="${TAG:-latest}"
    bash scripts/build-images.sh "$TAG"
}

load_images_only() {
    print_header "🐳 CARGANDO IMÁGENES"
    cd "$PROJECT_DIR"
    echo "Ingresa el tag de las imágenes a cargar en Minikube (default: latest):"
    read -p "Tag: " TAG
    TAG="${TAG:-latest}"
    bash scripts/load-images-minikube.sh "$TAG"
}

deploy_only() {
    print_header "📦 DESPLEGANDO SERVICIOS EN KUBERNETES"
    cd "$PROJECT_DIR"
    
    echo "Ingresa el tag de las imágenes a desplegar (default: latest):"
    read -p "Tag: " TAG
    TAG="${TAG:-latest}"

    echo "Ingresa el namespace donde desplegar (default: dev):"
    read -p "Namespace: " NAMESPACE
    NAMESPACE="${NAMESPACE:-dev}"

    bash scripts/deploy-k8s.sh "$TAG" "$NAMESPACE"
}

show_status() {
    print_header "📊 ESTADO ACTUAL"
    
    echo "Estado de Minikube:"
    if minikube status 2>/dev/null; then
        print_success "Minikube está corriendo"
    else
        print_error "Minikube no está corriendo"
        return
    fi
    
    echo ""
    echo "Pods en cluster:"
    kubectl get pods 2>/dev/null || {
        echo "   (Cluster no está disponible)"
    }
    
    echo ""
    echo "Servicios:"
    kubectl get svc 2>/dev/null || {
        echo "   (Sin servicios desplegados)"
    }
    
    echo ""
    echo "Deployments:"
    kubectl get deployments 2>/dev/null || {
        echo "   (Sin deployments desplegados)"
    }
}

cleanup() {
    print_header "🧹 LIMPIEZA"
    
    read -p "⚠️  ¿Estás seguro de que quieres eliminar todos los recursos? (s/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        echo "Operación cancelada."
        return
    fi
    
    echo "Eliminando recursos de Kubernetes..."
    kubectl delete -f "$PROJECT_DIR/k8s" 2>/dev/null || true
    print_success "Recursos eliminados"
    
    echo ""
    read -p "¿Deseas detener Minikube también? (s/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        echo "Deteniendo Minikube..."
        minikube stop
        print_success "Minikube detenido"
    fi
    
    print_header "✨ LIMPIEZA COMPLETADA"
}

# Ejecutar main
main
