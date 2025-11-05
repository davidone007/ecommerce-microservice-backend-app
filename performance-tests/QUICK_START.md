# 🚀 GUÍA RÁPIDA - Pruebas de Rendimiento

## ✅ ¿Qué se ha implementado?

Se ha creado una **suite completa de pruebas de rendimiento y estrés** para el sistema de e-commerce con las siguientes características:

### 📦 Componentes Implementados

1. **`locustfile.py`** - Suite principal de pruebas
   - Escenarios realistas de usuarios
   - Flujos de navegación y compra
   - Manejo automático de autenticación JWT
   - Métricas detalladas en tiempo real

2. **Scripts de Ejecución**
   - `quickstart.sh` - Inicio rápido (30 segundos)
   - `scripts/run-tests.sh` - Menú interactivo completo
   - `scripts/analyze_results.py` - Análisis de resultados
   - `scripts/compare_results.py` - Comparación de tests

3. **Configuración**
   - `config/test-config.yaml` - Configuración centralizada
   - `docker-compose.yml` - Ejecución distribuida
   - `Dockerfile` - Containerización

4. **Documentación**
   - `README.md` - Documentación completa
   - Ejemplos de uso
   - Mejores prácticas

## 🎯 Tipos de Pruebas Disponibles

| Tipo | Duración | Usuarios | Objetivo |
|------|----------|----------|----------|
| **🔥 Smoke Test** | 2 min | 5 | Verificación básica |
| **📊 Load Test** | 10 min | 50 | Carga normal |
| **💪 Stress Test** | 15 min | 200 | Identificar límites |
| **⚡ Spike Test** | 3 min | 300 | Picos de tráfico |
| **🏊 Soak Test** | 30 min | 100 | Resistencia prolongada |

## 📊 Métricas Capturadas

- ⏱️ **Tiempo de Respuesta**: Avg, Median, P95, P99
- 🚀 **Throughput**: Requests/segundo (RPS)
- ✅ **Tasa de Éxito/Error**: Porcentaje de requests exitosas
- 📈 **Distribución de Tiempos**: Por endpoint y operación
- 🎯 **Performance por Endpoint**: Análisis individual

## 🚀 USO RÁPIDO (3 pasos)

### 1️⃣ Instalar Dependencias

```bash
cd performance-tests
pip install -r requirements.txt
```

### 2️⃣ Asegurar que los Microservicios Estén Corriendo

```bash
# Desde la raíz del proyecto
cd ..
docker-compose -f compose.yml up -d

# Verificar
curl http://localhost:8080/app/api/products
```

### 3️⃣ Ejecutar Prueba Rápida

```bash
cd performance-tests
./quickstart.sh
```

Este comando ejecutará una prueba de 30 segundos y generará un reporte HTML.

## 💻 USO AVANZADO

### Menú Interactivo

```bash
./scripts/run-tests.sh
```

Verás un menú como este:

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

### Modo Web UI (Recomendado)

```bash
locust -f locustfile.py --host=http://localhost:8080
```

Luego abre en tu navegador: **http://localhost:8089**

Aquí podrás:
- ⚙️ Configurar número de usuarios y duración
- 📊 Ver métricas en tiempo real
- 📈 Gráficos dinámicos
- 🔍 Monitorear requests y errores
- 💾 Descargar reportes

### Comandos Directos

```bash
# Load Test de 5 minutos con 50 usuarios
locust -f locustfile.py \
    --host=http://localhost:8080 \
    --users 50 \
    --spawn-rate 5 \
    --run-time 5m \
    --headless \
    --html=results/my_test.html

# Stress Test de 10 minutos con 200 usuarios
locust -f locustfile.py \
    --host=http://localhost:8080 \
    --users 200 \
    --spawn-rate 10 \
    --run-time 10m \
    --headless \
    --csv=results/stress_test
```

## 📊 Análisis de Resultados

### Generar Reporte Mejorado

```bash
python scripts/analyze_results.py results/load_test_stats.csv --output results/analysis.html
```

Esto generará:
- ✅ Reporte HTML con diseño profesional
- 📊 Gráficos comparativos
- 🎯 Estado general del sistema
- 📈 Métricas consolidadas

### Comparar Resultados

```bash
python scripts/compare_results.py \
    results/baseline_stats.csv \
    results/current_stats.csv
```

Muestra:
- 📊 Tabla comparativa
- 📈 Diferencias porcentuales
- ✅ Mejoras y degradaciones

## 🐳 Uso con Docker

### Ejecución Individual

```bash
# Construir imagen
docker build -t ecommerce-locust .

# Ejecutar prueba
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

```bash
# Iniciar cluster (1 master + 2 workers)
docker-compose up -d

# Ver logs
docker-compose logs -f

# Acceder a Web UI
open http://localhost:8089

# Escalar workers
docker-compose up -d --scale locust-worker=5

# Detener
docker-compose down
```

## 🎓 Escenarios Simulados

### 1. Usuarios Navegando (75%)

- Navegar productos
- Ver detalles de productos
- Crear cuenta de usuario
- Agregar a favoritos
- Ver lista de favoritos

### 2. Usuarios Comprando (25%)

- Crear cuenta
- Crear productos (admin)
- Crear carrito
- Crear orden
- Procesar pago
- Completar compra

## 📈 Interpretación de Resultados

### ✅ Excelente

```
✓ Response Time < 200ms
✓ Success Rate > 99.5%
✓ Throughput > 50 RPS
```

### 🟢 Bueno

```
✓ Response Time < 500ms
✓ Success Rate > 99%
✓ Throughput > 30 RPS
```

### 🟡 Aceptable

```
⚠ Response Time < 1000ms
⚠ Success Rate > 95%
⚠ Throughput > 10 RPS
```

### 🔴 Necesita Mejoras

```
✗ Response Time > 1000ms
✗ Success Rate < 95%
✗ Throughput < 10 RPS
```

## 🔧 Solución de Problemas

### Error: Connection Refused

```bash
# Verificar servicios
docker-compose -f ../compose.yml ps

# Reiniciar servicios
docker-compose -f ../compose.yml restart
```

### Error: Locust no encontrado

```bash
# Instalar dependencias
pip install -r requirements.txt
```

### Performance Baja

```bash
# Verificar recursos
docker stats

# Aumentar recursos en Docker Desktop
# Settings > Resources > Advanced
```

## 📁 Estructura de Archivos

```
performance-tests/
├── locustfile.py              # Suite principal de pruebas
├── requirements.txt            # Dependencias Python
├── Dockerfile                  # Container image
├── docker-compose.yml          # Modo distribuido
├── quickstart.sh              # ⭐ Inicio rápido
├── README.md                   # Documentación completa
├── config/
│   └── test-config.yaml       # Configuración
├── scripts/
│   ├── run-tests.sh           # ⭐ Menú interactivo
│   ├── analyze_results.py     # Análisis de resultados
│   └── compare_results.py     # Comparación de tests
└── results/                    # Reportes generados
    ├── *.html                  # Reportes HTML
    ├── *.csv                   # Datos CSV
    └── *.png                   # Gráficos
```

## 💡 Tips y Mejores Prácticas

1. **Siempre ejecuta Smoke Test primero**
   ```bash
   ./scripts/run-tests.sh  # Opción 1
   ```

2. **Establece un baseline**
   - Ejecuta Load Test en condiciones normales
   - Guarda los resultados como referencia
   - Compara tests futuros contra el baseline

3. **Monitorea el sistema durante las pruebas**
   ```bash
   # En otra terminal
   docker stats
   docker-compose -f ../compose.yml logs -f
   ```

4. **Incrementa carga gradualmente**
   - Empieza con pocos usuarios
   - Aumenta progresivamente
   - Observa el comportamiento

5. **Documenta los hallazgos**
   - Anota configuración utilizada
   - Identifica cuellos de botella
   - Propone mejoras

## 🎯 Próximos Pasos Recomendados

1. **Primera Ejecución**
   ```bash
   ./quickstart.sh
   ```

2. **Ejecutar Suite Completa**
   ```bash
   ./scripts/run-tests.sh  # Opción 7
   ```

3. **Analizar Resultados**
   ```bash
   python scripts/analyze_results.py results/*_stats.csv
   ```

4. **Establecer CI/CD**
   - Integrar en pipeline de GitHub Actions
   - Ejecutar en cada release
   - Alertas automáticas si hay degradación

5. **Personalizar Escenarios**
   - Editar `locustfile.py`
   - Añadir nuevos flujos de usuario
   - Ajustar distribución de carga

## 📚 Recursos Adicionales

- 📖 **README.md** - Documentación completa
- 🌐 **Locust Docs**: https://docs.locust.io/
- 📊 **Spring Boot Actuator**: http://localhost:8080/actuator
- 🔍 **Zipkin**: http://localhost:9411/zipkin/

## ✅ Checklist de Verificación

- [ ] Dependencias instaladas (`pip install -r requirements.txt`)
- [ ] Microservicios corriendo (`docker-compose up`)
- [ ] Scripts ejecutables (`chmod +x scripts/*.sh quickstart.sh`)
- [ ] Primera prueba ejecutada (`./quickstart.sh`)
- [ ] Reporte HTML generado y revisado
- [ ] Métricas dentro de umbrales aceptables

## 🎉 ¡Listo!

Tu sistema de pruebas de rendimiento está completamente configurado y listo para usar.

**Comando recomendado para empezar:**

```bash
cd performance-tests
./quickstart.sh
```

¡Buena suerte con tus pruebas de rendimiento! 🚀
