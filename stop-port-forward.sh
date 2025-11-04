#!/bin/zsh

# Script para detener todos los port forwards

echo "Deteniendo port forwards..."

if [ -f "./port-forward-pids.txt" ]; then
    while IFS= read -r pid; do
        if [ ! -z "$pid" ] && kill -0 "$pid" 2>/dev/null; then
            kill "$pid" 2>/dev/null
            echo "✅ Detenido PID: $pid"
        fi
    done < ./port-forward-pids.txt
    rm -f ./port-forward-pids.txt
else
    pkill -f "kubectl port-forward" 2>/dev/null
    echo "✅ Todos los procesos kubectl port-forward detenidos"
fi

rm -rf ./port-forward-logs 2>/dev/null
echo "✅ Limpieza completada"
