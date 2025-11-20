#!/bin/bash

# Script para hacer port-forward de todos los servicios en Kubernetes usando nohup

# Leer namespace del primer argumento, por defecto "dev"
NAMESPACE="${1:-dev}"

# Array de servicios con sus puertos (formato: "servicio:puerto-local:puerto-remoto")
SERVICES=(
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

# Crear directorio para logs si no existe
mkdir -p port-forward-logs

# Limpiar archivo de PIDs anterior
> port-forward-pids.txt

echo "Iniciando port-forward para todos los servicios..."
echo "Logs se guardarán en port-forward-logs/"
echo ""

# Iterar sobre cada servicio
for service_config in "${SERVICES[@]}"; do
    IFS=':' read -r service local_port remote_port <<< "$service_config"
    ports="${local_port}:${remote_port}"
    log_file="port-forward-logs/${service}-portforward.log"
    
    echo "🔄 Port-forward para $service en puertos $ports (namespace: $NAMESPACE)"
    nohup kubectl port-forward "svc/$service" "$ports" -n "$NAMESPACE" > "$log_file" 2>&1 &
    pid=$!
    echo "$service:$pid" >> port-forward-pids.txt
    sleep 1  # Pequeña pausa entre cada comando
done

echo ""
echo "✅ Port-forward iniciado para todos los servicios"
echo "📝 PIDs guardados en port-forward-pids.txt"
echo "📋 Logs disponibles en port-forward-logs/"
echo ""
echo "Para detener todos los port-forwards, ejecuta:"
echo "  ./stop-port-forward-all-services-nohup.sh"
