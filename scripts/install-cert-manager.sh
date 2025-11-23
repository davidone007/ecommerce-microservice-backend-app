#!/bin/bash

# Script para instalar Cert-Manager en Kubernetes
# Requisito para obtener certificados SSL gratuitos con Let's Encrypt

echo "📦 Instalando Cert-Manager..."

# Agregar repositorio de Jetstack
helm repo add jetstack https://charts.jetstack.io
helm repo update

# Instalar Cert-Manager
helm upgrade --install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.13.3 \
  --set installCRDs=true

echo "✅ Cert-Manager instalado correctamente."
echo "⏳ Esperando a que los pods estén listos..."
kubectl wait --namespace cert-manager \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/instance=cert-manager \
  --timeout=90s

echo "✨ Cert-Manager está listo para usar."
