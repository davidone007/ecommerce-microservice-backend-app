#!/bin/zsh

# Script para detener todos los port forwards

echo "Deteniendo todos los port forwards..."

# Opción 1: Usando el archivo de PIDs (si existe)
if [ -f "./port-forward-pids.txt" ]; then
    while IFS= read -r pid; do
        if kill -0 "$pid" 2>/dev/null; then
            kill "$pid"
            echo "✅ Detenido proceso con PID: $pid"
        fi
    done < ./port-forward-pids.txt
    rm ./port-forward-pids.txt
else
    # Opción 2: Matar todos los procesos kubectl port-forward
    pkill -f "kubectl port-forward"
    echo "✅ Todos los procesos kubectl port-forward han sido detenidos"
fi

echo "Limpiando logs..."
rm -rf ./port-forward-logs

echo "✅ Port forwards detenidos"
