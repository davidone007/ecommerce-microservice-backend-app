#!/bin/bash

###############################################################################
# Script de Inicio Rápido para Pruebas de Rendimiento
# Ejecuta una prueba simple para verificar que todo funciona
###############################################################################

set -e

echo "🚀 INICIO RÁPIDO - Pruebas de Rendimiento"
echo "=========================================="
echo ""

# Verificar Python
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 no está instalado"
    exit 1
fi

echo "✓ Python detectado: $(python3 --version)"

# Verificar si locust está instalado
if ! command -v locust &> /dev/null; then
    echo "⚠️  Locust no está instalado. Instalando dependencias..."
    pip3 install -r requirements.txt
fi

echo "✓ Locust instalado: $(locust --version)"
echo ""

# Verificar servicios
echo "🔍 Verificando que los microservicios estén disponibles..."
if curl -s -o /dev/null -w "%{http_code}" "http://localhost:8080/app/api/products" | grep -q "200\|401"; then
    echo "✓ Microservicios disponibles"
else
    echo "❌ No se puede conectar a http://localhost:8080"
    echo ""
    echo "Por favor, inicia los microservicios primero:"
    echo "  cd .."
    echo "  docker-compose -f compose.yml up -d"
    exit 1
fi

echo ""
echo "🔥 Ejecutando Smoke Test (30 segundos, 3 usuarios)..."
echo "Esta prueba rápida verifica que todo funciona correctamente"
echo ""

# Ejecutar smoke test corto
locust \
    -f locustfile.py \
    --host=http://localhost:8080 \
    --users 3 \
    --spawn-rate 1 \
    --run-time 30s \
    --headless \
    --html=results/quickstart_test.html \
    --csv=results/quickstart_test \
    --loglevel INFO

echo ""
echo "✅ PRUEBA COMPLETADA"
echo ""
echo "📊 Resultados guardados en:"
echo "   - results/quickstart_test.html"
echo ""
echo "Abre el archivo HTML en tu navegador para ver los resultados"
echo ""
echo "Para ejecutar el menú completo de pruebas:"
echo "   ./scripts/run-tests.sh"
echo ""
