#!/bin/bash

# Script para hacer port-forward de todos los servicios de Kubernetes
# Guarda los PIDs en un archivo para poder detenerlos después

LOG_DIR="port-forward-logs"
PID_FILE="port-forward-pids.txt"

# Crear directorio de logs si no existe
mkdir -p "$LOG_DIR"

# Limpiar archivo de PIDs anterior
> "$PID_FILE"

echo "Iniciando port-forwards para todos los servicios..."
echo "=================================="

# Array de servicios con su puerto local y puerto del servicio
declare -a services=(
    "api-gateway-container:8080:8080"
    "cloud-config-container:9296:9296"
    "favourite-service-container:8800:8800"
    "order-service-container:8300:8300"
    "payment-service-container:8400:8400"
    "product-service-container:8500:8500"
    "proxy-client-container:8900:8900"
    "service-discovery-container:8761:8761"
    "shipping-service-container:8600:8600"
    "user-service-container:8700:8700"
    "zipkin-container:9411:9411"
)

# Iniciar port-forward para cada servicio
for service in "${services[@]}"; do
    IFS=':' read -r service_name local_port service_port <<< "$service"
    
    log_file="$LOG_DIR/${service_name}-portforward.log"
    
    echo "Iniciando port-forward: $service_name (localhost:$local_port -> :$service_port)"
    
    nohup kubectl port-forward svc/$service_name $local_port:$service_port > "$log_file" 2>&1 &
    
    pid=$!
    echo "$service_name:$pid" >> "$PID_FILE"
    echo "  PID: $pid"
done

echo ""
echo "=================================="
echo "Port-forwards iniciados correctamente"
echo "PIDs guardados en: $PID_FILE"
echo "Logs disponibles en: $LOG_DIR/"
echo ""
echo "Para detener todos los port-forwards ejecuta:"
echo "  ./stop-port-forward-all-services.sh"
