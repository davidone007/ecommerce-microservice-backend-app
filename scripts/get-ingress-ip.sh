#!/bin/bash
# Script para obtener la IP pública del Ingress Controller

echo "🔍 Buscando IP pública del Ingress..."
IP=""
while [ -z "$IP" ]; do
  IP=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null)
  if [ -z "$IP" ]; then
    echo "⏳ Esperando a que Azure asigne una IP pública... (reintentando en 10s)"
    sleep 10
  fi
done

echo ""
echo "✅ IP Pública encontrada: $IP"
echo ""
echo "👉 Ahora actualiza tu archivo terraform/environments/prod/values.yaml con:"
echo "   host: ecommerce.$IP.nip.io"
echo ""
