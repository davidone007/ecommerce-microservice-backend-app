#!/bin/bash

###############################################################################
# Script para limpiar port-forwards y preparar el ambiente para pruebas
###############################################################################

set -e

echo "🧹 Limpiando port-forwards y preparando ambiente..."
echo ""

# Verificar si hay procesos kubectl usando puertos
echo "📍 Procesos kubectl activos en puertos:"
lsof -i :8080 | grep kubectl || echo "  Ninguno en puerto 8080"
lsof -i :8761 | grep kubectl || echo "  Ninguno en puerto 8761"
echo ""

# Preguntar si desea detener los port-forwards
read -p "¿Deseas detener todos los port-forwards de kubectl? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🛑 Deteniendo port-forwards de kubectl..."
    pkill -f "kubectl port-forward" 2>/dev/null || echo "  No hay port-forwards activos"
    sleep 2
    echo "✅ Port-forwards detenidos"
fi

echo ""
echo "🔍 Verificando puertos ahora..."
if lsof -i :8080 > /dev/null 2>&1; then
    echo "⚠️  Puerto 8080 aún en uso:"
    lsof -i :8080
else
    echo "✅ Puerto 8080 disponible"
fi

echo ""
echo "📦 Verificando servicios en Docker Compose..."
cd ..
if docker-compose -f compose.yml ps | grep -q "Up"; then
    echo "✅ Servicios Docker Compose activos"
    docker-compose -f compose.yml ps
else
    echo "⚠️  No hay servicios Docker Compose activos"
    echo ""
    read -p "¿Deseas iniciar los servicios? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🚀 Iniciando servicios..."
        docker-compose -f compose.yml up -d
        echo ""
        echo "⏳ Esperando que los servicios estén listos (30 segundos)..."
        sleep 30
        docker-compose -f compose.yml ps
    fi
fi

echo ""
echo "🎯 Verificando conectividad al API Gateway..."
if curl -s -o /dev/null -w "%{http_code}" "http://localhost:8080/app/api/products" | grep -q "200\|401"; then
    echo "✅ API Gateway respondiendo correctamente"
else
    echo "⚠️  No se puede conectar al API Gateway"
    echo "   Verifica que los servicios estén corriendo correctamente"
fi

echo ""
echo "✅ Ambiente preparado para ejecutar pruebas de rendimiento"
echo ""
echo "Para ejecutar pruebas:"
echo "  cd performance-tests"
echo "  ./quickstart.sh"
