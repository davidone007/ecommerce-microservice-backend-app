# Pruebas de Rendimiento y Estrés - E-commerce Microservices

## 📋 Índice

- [Descripción](#descripción)
- [Características](#características)
- [Requisitos Previos](#requisitos-previos)
- [Instalación](#instalación)
- [Uso](#uso)
- [Tipos de Pruebas](#tipos-de-pruebas)
- [Métricas Clave](#métricas-clave)
- [Configuración](#configuración)
- [Resultados](#resultados)
- [Docker](#docker)
- [Mejores Prácticas](#mejores-prácticas)

## 🎯 Descripción

Suite completa de pruebas de rendimiento y estrés para el sistema de e-commerce basado en microservicios. Utiliza **Locust** para simular casos de uso reales y medir el comportamiento del sistema bajo diferentes condiciones de carga.

## ✨ Características

- **Escenarios Realistas**: Simulación de usuarios navegando, comprando y gestionando favoritos
- **Múltiples Tipos de Pruebas**: Smoke, Load, Stress, Spike y Soak tests
- **Métricas Detalladas**: Response time, throughput, error rate, percentiles
- **Reportes HTML**: Visualización interactiva de resultados con gráficos
- **Autenticación JWT**: Manejo automático de tokens de autenticación
- **Modo Distribuido**: Soporte para pruebas distribuidas con Docker
- **Interfaz Web**: Dashboard interactivo en tiempo real

## 📦 Requisitos Previos

### Software Necesario

- Python 3.11+
- pip (gestor de paquetes de Python)
- Docker & Docker Compose (opcional, para ejecución en contenedores)
- Sistema de microservicios ejecutándose (ver `compose.yml` en la raíz)

### Servicios del Sistema

Antes de ejecutar las pruebas, asegúrate de que los microservicios estén corriendo:

```bash
# Desde la raíz del proyecto
docker-compose -f compose.yml up -d
```

Verifica que los servicios estén disponibles:

```bash
curl http://localhost:8080/app/api/products
```

## 🚀 Instalación

### Opción 1: Instalación Local

```bash
# 1. Navegar al directorio de pruebas
cd performance-tests

# 2. Crear entorno virtual (recomendado)
python3 -m venv venv
source venv/bin/activate  # En Windows: venv\Scripts\activate

# 3. Instalar dependencias
pip install -r requirements.txt

# 4. Dar permisos de ejecución a scripts
chmod +x scripts/*.sh
```

### Opción 2: Usando Docker

```bash
# 1. Construir imagen
docker build -t ecommerce-locust .

# 2. O usar Docker Compose
docker-compose up -d
```

## 💻 Uso

### Menú Interactivo (Recomendado)

```bash
./scripts/run-tests.sh
```

Este comando abrirá un menú interactivo donde puedes seleccionar el tipo de prueba:

```
1) 🔥 Smoke Test       - Verificación básica (2 min, 5 usuarios)
2) 📊 Load Test        - Carga normal (10 min, 50 usuarios)
3) 💪 Stress Test      - Prueba de estrés (15 min, 200 usuarios)
4) ⚡ Spike Test       - Picos de tráfico (3 min, 300 usuarios)
5) 🏊 Soak Test        - Resistencia (30 min, 100 usuarios)
6) 🌐 Web UI           - Modo interactivo
7) 🚀 Todas las pruebas
8) 🔍 Ver últimos resultados
9) ❌ Salir
```

### Comandos Directos

#### Prueba de Carga Básica

```bash
locust -f locustfile.py \
    --host=http://localhost:8080 \
    --users 50 \
    --spawn-rate 5 \
    --run-time 5m \
    --headless
```

#### Modo Web UI (Interactivo)

```bash
locust -f locustfile.py --host=http://localhost:8080
```

Luego abre tu navegador en: `http://localhost:8089`

#### Generar Reportes

```bash
# Durante la ejecución, especifica archivos de salida
locust -f locustfile.py \
    --host=http://localhost:8080 \
    --users 50 \
    --spawn-rate 5 \
    --run-time 5m \
    --headless \
    --html=results/report.html \
    --csv=results/stats
```

#### Analizar Resultados

```bash
python scripts/analyze_results.py results/stats_stats.csv --output results/analysis.html
```

## 🧪 Tipos de Pruebas

### 1. 🔥 Smoke Test (Prueba de Humo)

**Objetivo**: Verificación rápida de que el sistema funciona

- **Duración**: 2 minutos
- **Usuarios**: 5
- **Uso**: Validación post-deployment

```bash
locust -f locustfile.py --host=http://localhost:8080 --users 5 --spawn-rate 1 --run-time 2m --headless
```

### 2. 📊 Load Test (Prueba de Carga)

**Objetivo**: Evaluar comportamiento bajo carga normal esperada

- **Duración**: 10 minutos
- **Usuarios**: 50
- **Uso**: Validar rendimiento en operación normal

```bash
locust -f locustfile.py --host=http://localhost:8080 --users 50 --spawn-rate 5 --run-time 10m --headless
```

### 3. 💪 Stress Test (Prueba de Estrés)

**Objetivo**: Identificar límites del sistema y puntos de quiebre

- **Duración**: 15 minutos
- **Usuarios**: 200
- **Uso**: Encontrar capacidad máxima

```bash
locust -f locustfile.py --host=http://localhost:8080 --users 200 --spawn-rate 10 --run-time 15m --headless
```

### 4. ⚡ Spike Test (Prueba de Picos)

**Objetivo**: Evaluar respuesta ante aumentos súbitos de tráfico

- **Duración**: 3 minutos
- **Usuarios**: 300
- **Uso**: Simular eventos como Black Friday

```bash
locust -f locustfile.py --host=http://localhost:8080 --users 300 --spawn-rate 50 --run-time 3m --headless
```

### 5. 🏊 Soak Test (Prueba de Resistencia)

**Objetivo**: Evaluar estabilidad bajo carga prolongada

- **Duración**: 30 minutos
- **Usuarios**: 100
- **Uso**: Detectar memory leaks y degradación

```bash
locust -f locustfile.py --host=http://localhost:8080 --users 100 --spawn-rate 5 --run-time 30m --headless
```

## 📊 Métricas Clave

### Tiempo de Respuesta

- **Average Response Time**: Tiempo promedio de respuesta
- **Median (P50)**: 50% de las requests están por debajo de este tiempo
- **P95**: 95% de las requests están por debajo de este tiempo
- **P99**: 99% de las requests están por debajo de este tiempo

### Throughput

- **RPS (Requests per Second)**: Cantidad de requests procesadas por segundo
- **Total Requests**: Total de requests ejecutadas
- **Requests/s**: Tasa de requests en tiempo real

### Confiabilidad

- **Success Rate**: Porcentaje de requests exitosas
- **Failure Rate**: Porcentaje de requests fallidas
- **Error Distribution**: Distribución de tipos de error

### Thresholds Recomendados

```yaml
Excelente:
  - Response Time: < 200ms
  - Success Rate: > 99.5%
  - Throughput: > 50 RPS

Bueno:
  - Response Time: < 500ms
  - Success Rate: > 99%
  - Throughput: > 30 RPS

Aceptable:
  - Response Time: < 1000ms
  - Success Rate: > 95%
  - Throughput: > 10 RPS
```

## ⚙️ Configuración

### Archivo de Configuración

Edita `config/test-config.yaml` para ajustar:

```yaml
scenarios:
  load_test:
    users: 50          # Número de usuarios concurrentes
    spawn_rate: 5      # Usuarios que se agregan por segundo
    duration: "10m"    # Duración de la prueba

performance_thresholds:
  response_time:
    excellent: 200     # ms
    acceptable: 1000   # ms
```

### Personalizar Locustfile

El archivo `locustfile.py` contiene dos clases de usuarios:

- **BrowsingUser**: Usuarios que navegan (peso: 3)
- **BuyingUser**: Usuarios que compran (peso: 1)

Ajusta los pesos para cambiar la distribución:

```python
class BrowsingUser(FastHttpUser):
    weight = 3  # 75% de usuarios

class BuyingUser(FastHttpUser):
    weight = 1  # 25% de usuarios
```

## 📁 Resultados

Los resultados se guardan en el directorio `results/`:

```
results/
├── load_test_20241104_153000.html      # Reporte HTML de Locust
├── load_test_20241104_153000_stats.csv # Estadísticas CSV
├── load_test_20241104_153000_failures.csv
├── analysis_20241104_153000.html       # Análisis detallado
└── performance_charts.png              # Gráficos
```

### Interpretar Resultados

#### Reporte HTML de Locust

Abre el archivo `.html` en tu navegador para ver:

- Dashboard con métricas en tiempo real
- Gráficos de requests/segundo
- Tabla de estadísticas por endpoint
- Distribución de tiempos de respuesta
- Log de errores

#### Reporte de Análisis

El script `analyze_results.py` genera un reporte mejorado con:

- Métricas consolidadas
- Gráficos comparativos
- Estado general del sistema
- Recomendaciones

## 🐳 Docker

### Ejecución Individual

```bash
# Ejecutar contenedor standalone
docker run -it --rm \
    --network host \
    -v $(pwd)/results:/performance-tests/results \
    ecommerce-locust \
    -f locustfile.py \
    --host=http://localhost:8080 \
    --users 50 \
    --spawn-rate 5 \
    --run-time 5m \
    --headless
```

### Modo Distribuido

Para pruebas de alto volumen, usa Docker Compose con workers:

```bash
# Iniciar cluster (1 master + 2 workers)
docker-compose up -d

# Ver logs
docker-compose logs -f

# Acceder a Web UI
open http://localhost:8089

# Detener
docker-compose down
```

El modo distribuido permite:

- Escalar horizontalmente añadiendo más workers
- Distribución de carga entre múltiples máquinas
- Mayor capacidad de generación de usuarios virtuales

### Escalar Workers

```bash
# Añadir más workers
docker-compose up -d --scale locust-worker=5
```

## 📚 Mejores Prácticas

### Antes de las Pruebas

1. **Asegurar Estado Limpio**:
   ```bash
   docker-compose -f ../compose.yml restart
   ```

2. **Verificar Recursos**:
   - CPU: Mínimo 4 cores disponibles
   - RAM: Mínimo 8GB
   - Disco: Espacio para logs y resultados

3. **Configurar Baseline**:
   - Ejecutar smoke test primero
   - Establecer métricas de referencia

### Durante las Pruebas

1. **Monitorear Sistema**:
   - Métricas de Docker: `docker stats`
   - Logs de servicios: `docker-compose logs -f`
   - Actuator endpoints: `http://localhost:8080/actuator/metrics`

2. **No Interferir**:
   - No ejecutar otras aplicaciones pesadas
   - No modificar el sistema durante las pruebas

### Después de las Pruebas

1. **Analizar Resultados**:
   ```bash
   python scripts/analyze_results.py results/latest_stats.csv
   ```

2. **Comparar con Baseline**:
   - Response time: ¿aumentó significativamente?
   - Error rate: ¿está dentro del threshold?
   - Throughput: ¿cumple con los objetivos?

3. **Documentar Hallazgos**:
   - Anotar configuración utilizada
   - Identificar cuellos de botella
   - Proponer mejoras

### Troubleshooting

#### Error: Connection Refused

```bash
# Verificar que los servicios estén corriendo
docker-compose -f ../compose.yml ps

# Verificar conectividad
curl http://localhost:8080/app/api/products
```

#### Error: Authentication Failed

El sistema crea usuarios automáticamente, pero si hay problemas:

```bash
# Verificar logs del proxy-client
docker-compose -f ../compose.yml logs proxy-client
```

#### Performance Degradation

Si las pruebas son más lentas de lo esperado:

```bash
# Verificar recursos de Docker
docker stats

# Aumentar recursos en Docker Desktop:
# Settings > Resources > Advanced
```

## 🔧 Comandos Útiles

```bash
# Ver estadísticas en tiempo real (durante Web UI)
watch -n 1 'curl -s http://localhost:8089/stats/requests | jq'

# Limpiar resultados antiguos
rm -rf results/*.html results/*.csv

# Ejecutar prueba rápida custom
locust -f locustfile.py --host=http://localhost:8080 \
    --users 10 --spawn-rate 2 --run-time 1m --headless

# Ver ayuda de Locust
locust --help
```

## 📖 Referencias

- [Documentación de Locust](https://docs.locust.io/)
- [Mejores prácticas de Performance Testing](https://martinfowler.com/articles/performance-testing.html)
- [Spring Boot Actuator Metrics](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html)

## 🤝 Contribuir

Para agregar nuevos escenarios o mejorar las pruebas:

1. Edita `locustfile.py` agregando nuevas tareas
2. Actualiza `test-config.yaml` con nueva configuración
3. Documenta los cambios en este README
4. Prueba los cambios con smoke test

## 📝 Licencia

Este proyecto es parte del sistema E-commerce Microservices.

---

**Autor**: Performance Testing Suite  
**Fecha**: 2024-11-04  
**Versión**: 1.0.0
