# Pruebas de Rendimiento y Estrés - Sistema E-Commerce Microservicios

Este directorio contiene pruebas de rendimiento y estrés utilizando **Locust** para validar la capacidad del sistema de e-commerce bajo carga.

## 📋 Descripción

Las pruebas simulan casos de uso reales del sistema:

1. **Búsqueda de productos** - Los usuarios buscan productos
2. **Visualización de detalles** - Consultan información detallada
3. **Agregar a favoritos** - Guardan productos favoritos
4. **Crear órdenes** - Realizan compras
5. **Procesar pagos** - Pagan sus órdenes
6. **Rastrear envíos** - Monitorean entregas

## 🚀 Quick Start

### 1. Instalación de dependencias

```bash
pip install -r requirements.txt
```

### 2. Ejecutar pruebas básicas (10 usuarios, 5 minutos)

```bash
chmod +x *.sh
./run_performance_tests.sh
```

Acceder a la interfaz web: http://localhost:8089

### 3. Ejecutar prueba de estrés interactiva

```bash
./stress_test.sh
```

Selecciona el nivel de estrés deseado (Ligero, Moderado, Fuerte, Crítico, Personalizado)

### 4. Probar un servicio específico

```bash
./test_service.sh products -u 20 -t 5m
./test_service.sh orders -u 50 -t 10m
./test_service.sh payments -u 30 -t 5m
```

## 📊 Estructuras de archivos

```
performance-tests/
├── requirements.txt              # Dependencias Python
├── config.py                     # Configuración centralizada
├── utils.py                      # Utilidades y generador de datos
├── locustfile.py                 # Test principal (flujo completo)
├── locustfile_products.py        # Test de Product Service
├── locustfile_orders.py          # Test de Order Service
├── locustfile_payments.py        # Test de Payment Service
├── locustfile_favorites.py       # Test de Favourite Service
├── locustfile_shipping.py        # Test de Shipping Service
├── run_performance_tests.sh      # Script principal de ejecución
├── stress_test.sh                # Script de prueba de estrés
├── test_service.sh               # Script para probar servicios individuales
├── performance-results/          # Resultados de las pruebas (CSV)
└── README.md                     # Este archivo
```

## 🔧 Configuración

### Variables de entorno (.env)

```bash
# URLs de los servicios
API_GATEWAY_URL=http://localhost:8100
PRODUCT_SERVICE_URL=http://localhost:8200
ORDER_SERVICE_URL=http://localhost:8300
PAYMENT_SERVICE_URL=http://localhost:8400
FAVOURITE_SERVICE_URL=http://localhost:8800
SHIPPING_SERVICE_URL=http://localhost:8600
```

## 📈 Ejemplos de uso

### Ejecutar con interfaz gráfica (recomendado para análisis)

```bash
./run_performance_tests.sh -u 50 -r 5 -t 10m
```

Luego acceder a http://localhost:8089

### Ejecutar en modo headless (sin interfaz)

```bash
./run_performance_tests.sh -u 100 -r 10 -t 15m --summary
```

### Prueba personalizada

```bash
./run_performance_tests.sh \
    --users 200 \
    --rate 20 \
    --time 30m \
    --host http://production.example.com:8100 \
    --csv results_prod
```

### Prueba de servicio específico

```bash
# Product Service - 20 usuarios, 5 minutos
./test_service.sh products -u 20 -t 5m

# Order Service - 50 usuarios, 10 minutos  
./test_service.sh orders -u 50 -t 10m

# Payment Service - 30 usuarios, 5 minutos
./test_service.sh payments -u 30 -t 5m
```

## 📊 Interpretación de resultados

### Métricas clave

| Métrica | Descripción | Objetivo |
|---------|-------------|----------|
| **Response Time (ms)** | Tiempo de respuesta promedio | < 500ms |
| **Request Rate (req/s)** | Solicitudes por segundo procesadas | > 100 req/s |
| **Failure Rate (%)** | Porcentaje de solicitudes fallidas | < 1% |
| **P95/P99 Response Time** | Percentiles 95 y 99 | < 1000ms (P95), < 2000ms (P99) |
| **Concurrent Users** | Usuarios activos simultáneamente | Variable según objetivo |

### Archivos de resultados

Los resultados se guardan en `performance-results/`:

- `*_stats.csv` - Estadísticas de cada request
- `*_hist.csv` - Histograma de respuestas

Analizar con Excel, Pandas, o GraphQL:

```python
import pandas as pd

stats = pd.read_csv('performance-results/20240101_100000_results_stats.csv')
print(stats[['Name', 'requests', 'failures', 'median', 'p95']])
```

## 🎯 Escenarios de prueba

### 1. Prueba de carga (Load Test)
```bash
./run_performance_tests.sh -u 50 -r 5 -t 10m
```
Valida que el sistema maneja la carga esperada.

### 2. Prueba de estrés (Stress Test)
```bash
./run_performance_tests.sh -u 200 -r 20 -t 15m --summary
```
Determina el punto de quiebre del sistema.

### 3. Prueba de resistencia (Endurance Test)
```bash
./run_performance_tests.sh -u 30 -r 3 -t 60m --summary
```
Valida que el sistema es estable durante periodos prolongados.

### 4. Prueba de picos (Spike Test)
```bash
# Primero: carga base
./run_performance_tests.sh -u 20 -t 5m

# Después: incremento rápido
./run_performance_tests.sh -u 100 -t 5m
```

## 🔍 Análisis detallado

### Ver tabla de estadísticas en vivo
Acceder a http://localhost:8089 durante la ejecución

### Analisar resultado CSV con Python

```python
import pandas as pd
import matplotlib.pyplot as plt

# Cargar datos
df = pd.read_csv('performance-results/timestamp_results_stats.csv')

# Gráfico de tiempo de respuesta
df[['Name', 'Average']].plot(kind='bar')
plt.title('Tiempo de Respuesta Promedio por Endpoint')
plt.show()

# Filtrar errores
errors = df[df['Failure rate'] > 0]
print("Endpoints con errores:", errors)

# Resumen
print(f"\nTotal de requests: {df['requests'].sum()}")
print(f"Total de fallos: {df['failures'].sum()}")
print(f"Tasa de fallos global: {(df['failures'].sum() / df['requests'].sum() * 100):.2f}%")
```

## 🐛 Troubleshooting

### Error: "Connection refused"
```bash
# Verificar que los servicios estén corriendo
docker ps
# O iniciar con: docker-compose up
```

### Error: "Module not found"
```bash
pip install --upgrade -r requirements.txt
```

### Interfaz web no abre en http://localhost:8089
```bash
# Usar puerto diferente
locust -f locustfile.py -w --web-port 8090
```

### Resultados inconsistentes
1. Asegurar que el sistema tiene suficientes recursos (CPU, RAM)
2. Ejecutar pruebas sin otros procesos intensivos
3. Repetir pruebas varias veces y promediar resultados

## 📚 Documentación adicional

### Locust Documentation
- https://docs.locust.io/

### Mejores prácticas de pruebas de carga
- https://www.locust.io/

### Análisis de resultados
- Spreadsheets: Excel, Google Sheets
- Visualización: Matplotlib, Plotly
- BI: Kibana, Grafana (con TimeSeriesDB)

## 📝 Notas importantes

1. **Impacto en producción**: Nunca ejecutar contra producción sin autorización
2. **Recursos**: Las pruebas de estrés consumirán recursos significativos
3. **Datos de prueba**: Se utilizan datos faker generados, sin afectar datos reales
4. **Concurrencia**: Locust ejecuta usuarios en paralelo usando gevent
5. **Resultados**: Mejor ejecutar múltiples pruebas y promediar

## 🤝 Contribuciones

Para agregar nuevas pruebas:

1. Crear nuevo `locustfile_servicio.py`
2. Definir casos de uso realistas
3. Documentar en este README
4. Ejecutar validación

## 📞 Soporte

Para dudas o problemas:
1. Revisar logs: `performance-results/*.csv`
2. Consultar Locust docs: https://docs.locust.io/
3. Verificar conectividad a servicios
