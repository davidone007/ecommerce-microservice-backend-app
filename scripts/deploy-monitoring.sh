#!/bin/bash

# Script para desplegar el stack de monitoreo en Kubernetes

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

NAMESPACE="${1:-stage}"

echo -e "${BLUE}🚀 Desplegando Stack de Monitoreo en namespace: $NAMESPACE${NC}"
echo ""

# Crear namespace si no existe
kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

# Aplicar manifiestos
echo "📦 Aplicando manifiestos de monitoreo..."
kubectl apply -f k8s/monitoring/ -n "$NAMESPACE"

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ Stack de monitoreo desplegado exitosamente${NC}"
    echo ""
    echo "Servicios desplegados:"
    echo "- Prometheus (Puerto 9090)"
    echo "- Grafana (Puerto 3000)"
    echo "- Elasticsearch (Puerto 9200)"
    echo "- Logstash (Puerto 5000)"
    echo "- Kibana (Puerto 5601)"
else
    echo ""
    echo -e "${RED}❌ Error al desplegar el stack de monitoreo${NC}"
    exit 1
fi
