#!/bin/bash

# Script para iniciar Minikube con configuración optimizada para microservicios

set -e

echo "🚀 Iniciando Minikube..."

# Parámetros de configuración
MEMORY=20000
CPUS=4
DRIVER="docker" # o "hyperkit" en Mac

# Verificar si minikube está instalado
if ! command -v minikube &> /dev/null; then
    echo "❌ Minikube no está instalado. Por favor instálalo primero."
    echo "   Instrucciones: https://minikube.sigs.k8s.io/docs/start/"
    exit 1
fi

# Verificar si el cluster ya está corriendo
if minikube status &> /dev/null; then
    echo "⚠️  Minikube ya está corriendo"
    echo "   Ejecutando: minikube dashboard"
    minikube dashboard &
    exit 0
fi

# Iniciar minikube con la configuración especificada
echo "⏳ Iniciando cluster con:"
echo "   - Memoria: ${MEMORY}MB"
echo "   - CPUs: ${CPUS}"
echo "   - Driver: ${DRIVER}"

minikube start \
    --memory="${MEMORY}" \
    --cpus="${CPUS}" \
    --driver="${DRIVER}"

echo ""
echo "✅ Minikube iniciado exitosamente"
echo ""

# Obtener información del cluster
echo "📋 Información del cluster:"
kubectl cluster-info
echo ""

# Configurar contexto
echo "🔧 Configurando contexto de Kubernetes..."
kubectl config use-context minikube

# Configurar Docker environment
echo ""
echo "🐳 Configurando Docker environment..."
eval "$(minikube docker-env)"
echo "Docker env configurado. Para usar docker directamente en minikube, ejecuta:"
echo "   eval \$(minikube docker-env)"
echo ""

# Mostrar comandos útiles
echo ""
echo "📚 Comandos útiles:"
echo "   - Ver dashboard: minikube dashboard"
echo "   - Ver servicios: kubectl get svc"
echo "   - Ver pods: kubectl get pods"
echo "   - Ver logs: kubectl logs <pod-name>"
echo "   - Port forward: kubectl port-forward <pod-name> <local-port>:<pod-port>"
echo ""

echo "✨ ¡Listo para desplegar!"

# Lanzar dashboard
echo "🌐 Abriendo dashboard de Minikube..."
minikube dashboard &

echo "✨ ¡Listo para desplegar!"
