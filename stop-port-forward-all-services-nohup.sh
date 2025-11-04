#!/bin/bash

# Script para detener todos los port-forwards

echo "Deteniendo todos los port-forwards..."
echo ""

if [ -f port-forward-pids.txt ]; then
    while IFS=':' read -r service pid; do
        if [ ! -z "$pid" ]; then
            echo "❌ Deteniendo $service (PID: $pid)"
            kill $pid 2>/dev/null || true
        fi
    done < port-forward-pids.txt
    
    # Limpiar el archivo de PIDs
    rm port-forward-pids.txt
    echo ""
    echo "✅ Todos los port-forwards han sido detenidos"
else
    echo "⚠️  No se encontró archivo port-forward-pids.txt"
    echo "Intentando detener todos los kubectl port-forward..."
    pkill -f "kubectl port-forward" || true
    echo "✅ Comando ejecutado"
fi
