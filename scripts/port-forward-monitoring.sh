#!/bin/bash

# Script para hacer port-forward de los servicios de monitoreo

NAMESPACE="${1:-stage}"

# Array de servicios de monitoreo
SERVICES=(
    "prometheus:9090:9090"
    "grafana:3000:3000"
    "kibana:5601:5601"
    "elasticsearch:9200:9200"
)

mkdir -p port-forward-logs

echo "🔍 Iniciando port-forward para servicios de monitoreo en namespace: $NAMESPACE"

for service_config in "${SERVICES[@]}"; do
    IFS=':' read -r service local_port remote_port <<< "$service_config"
    ports="${local_port}:${remote_port}"
    log_file="port-forward-logs/${service}-portforward.log"
    
    echo "🔄 Exponiendo $service en http://localhost:$local_port"
    nohup kubectl port-forward "svc/$service" "$ports" -n "$NAMESPACE" > "$log_file" 2>&1 &
done

echo ""
echo "✅ Servicios de monitoreo expuestos."
echo "📊 Grafana:     http://localhost:3000 (admin/admin)"
echo "🔥 Prometheus:  http://localhost:9090"
echo "🪵 Kibana:      http://localhost:5601"
echo ""
