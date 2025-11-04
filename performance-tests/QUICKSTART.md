# Guía de Inicio Rápido - Pruebas de Rendimiento

## 🚀 Instalación (2 minutos)

### Paso 1: Instalar dependencias Python

```bash
cd performance-tests
pip install -r requirements.txt
```

Esto instalará:
- **locust**: Framework de pruebas de carga
- **requests**: Cliente HTTP
- **faker**: Generador de datos realistas
- **python-dotenv**: Gestor de variables de entorno

### Paso 2: Verificar instalación

```bash
locust --version
```

Deberías ver algo como: `locust 2.20.0`

## 🎯 Ejecución Rápida (Elige una opción)

### Opción A: Modo Interactivo (Recomendado para primera vez)

```bash
./demo.sh
```

Menú interactivo con opciones de:
- Explicación de conceptos
- Demostración guiada
- Diferentes tipos de pruebas

### Opción B: Prueba Rápida (5 usuarios, 2 minutos)

```bash
./run_performance_tests.sh -u 5 -t 2m
```

Luego abre: **http://localhost:8089**

### Opción C: Prueba de Carga (30 usuarios, 5 minutos)

```bash
./run_performance_tests.sh -u 30 -r 3 -t 5m --summary
```

### Opción D: Probar un Servicio Específico

```bash
# Product Service
./test_service.sh products -u 20 -t 5m

# Order Service
./test_service.sh orders -u 50 -t 10m

# Payment Service
./test_service.sh payments -u 30 -t 5m
```

## 📊 Ver Resultados

### En tiempo real (modo web)

```bash
./run_performance_tests.sh
# Ir a http://localhost:8089
```

### Generar reporte HTML

```bash
python3 generate_report.py performance-results/TIMESTAMP_results_stats.csv
```

Esto crea un archivo `TIMESTAMP_results_stats_report.html` que puedes abrir en el navegador.

## 🔧 Configuración

Crear archivo `.env` en `performance-tests/`:

```bash
cp .env.example .env
# Editar .env con tus URLs de servicios
```

## 📋 Comandos comunes

```bash
# Prueba simple con interfaz web
./run_performance_tests.sh

# Prueba con 100 usuarios, 10 minutos, modo headless
./run_performance_tests.sh -u 100 -t 10m --summary

# Prueba de estrés interactiva
./stress_test.sh

# Prueba de un servicio
./test_service.sh orders -u 50 -t 10m

# Ver ayuda
./run_performance_tests.sh --help
```

## ⚠️ Requisitos previos

1. **Python 3.8+** instalado
2. **Servicios corriendo**:
   - API Gateway en `http://localhost:8100`
   - O especificar con `-h http://tu-host:puerto`

Verificar servicios:
```bash
curl http://localhost:8100/actuator/health
```

## 🐛 Troubleshooting

### "Connection refused"
```bash
# Verificar que los servicios estén corriendo
docker ps
docker-compose up
```

### "Module not found"
```bash
pip install --upgrade -r requirements.txt
```

### Port 8089 already in use
```bash
./run_performance_tests.sh -w --web-port 8090
# O acceder a http://localhost:8090
```

## 📚 Próximos pasos

1. Lee el [README.md](./README.md) completo
2. Explora los diferentes tipos de pruebas
3. Analiza los resultados en `performance-results/`
4. Ajusta configuración según tus necesidades

## 🎓 Recursos

- [Documentación de Locust](https://docs.locust.io/)
- [HTTP Status Codes](https://httpwg.org/specs/rfc7231.html#status.codes)
- [Performance Testing Best Practices](https://www.joecolantonio.com/load-testing/)

---

**¿Preguntas?** Revisa el archivo README.md o la documentación de Locust.
