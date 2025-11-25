#!/bin/bash

# Script para configurar Kibana automáticamente
# Crea index patterns y dashboards para los microservicios

KIBANA_URL="${KIBANA_URL:-http://localhost:5601}"
INDEX_PATTERN="microservices-logs-*"

echo "🔧 Configurando Kibana en $KIBANA_URL"

# Esperar a que Kibana esté listo
echo "⏳ Esperando a que Kibana esté listo..."
until curl -s "$KIBANA_URL/api/status" > /dev/null 2>&1; do
    echo "   Kibana aún no está listo, esperando..."
    sleep 5
done
echo "✅ Kibana está listo"

# Crear Index Pattern
echo "📊 Creando Index Pattern: $INDEX_PATTERN"
curl -X POST "$KIBANA_URL/api/saved_objects/index-pattern/microservices-logs" \
  -H 'kbn-xsrf: true' \
  -H 'Content-Type: application/json' \
  -d "{
    \"attributes\": {
      \"title\": \"$INDEX_PATTERN\",
      \"timeFieldName\": \"@timestamp\"
    }
  }" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ Index Pattern creado exitosamente"
else
    echo "⚠️  Index Pattern puede que ya exista o hubo un error"
fi

# Establecer como Index Pattern por defecto
echo "🔧 Estableciendo Index Pattern por defecto..."
curl -X POST "$KIBANA_URL/api/kibana/settings/defaultIndex" \
  -H 'kbn-xsrf: true' \
  -H 'Content-Type: application/json' \
  -d "{
    \"value\": \"microservices-logs\"
  }" 2>/dev/null

echo ""
echo "✅ Configuración de Kibana completada"
echo ""
echo "📋 Próximos pasos:"
echo "   1. Abre Kibana en: $KIBANA_URL"
echo "   2. Ve a 'Discover' para ver los logs"
echo "   3. Ve a 'Dashboard' para crear visualizaciones personalizadas"
echo ""
echo "💡 Filtros útiles en Discover:"
echo "   - service:\"USER-SERVICE\" - Ver logs solo del User Service"
echo "   - service:\"ORDER-SERVICE\" - Ver logs solo del Order Service"
echo "   - level:\"ERROR\" - Ver solo errores"
echo ""
