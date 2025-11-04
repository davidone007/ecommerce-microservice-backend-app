"""
Archivo informativo: Métricas y KPIs esperados en las pruebas de rendimiento.
Este módulo documentan los umbrales de aceptación para el sistema.
"""

# BENCHMARKS Y UMBRALES DE ACEPTACIÓN


class PerformanceBenchmarks:
    """
    Define los objetivos de rendimiento para cada tipo de prueba.
    Basados en mejores prácticas y requisitos del sistema.
    """

    # Pruebas de Carga Normal
    LOAD_TEST = {
        "users": 30,
        "duration_minutes": 5,
        "target_response_time_ms": 500,
        "target_p95_ms": 1000,
        "target_p99_ms": 2000,
        "max_failure_rate": 1,  # porcentaje
        "min_throughput_req_sec": 100,
        "description": "Carga normal esperada en horarios regulares",
    }

    # Pruebas de Estrés
    STRESS_TEST = {
        "users": 100,
        "duration_minutes": 10,
        "target_response_time_ms": 1000,
        "target_p95_ms": 2500,
        "target_p99_ms": 5000,
        "max_failure_rate": 5,  # porcentaje
        "min_throughput_req_sec": 200,
        "description": "Carga máxima que el sistema debe soportar",
    }

    # Pruebas de Resistencia
    ENDURANCE_TEST = {
        "users": 30,
        "duration_minutes": 60,
        "target_response_time_ms": 500,
        "target_p95_ms": 1000,
        "target_p99_ms": 2000,
        "max_failure_rate": 0.5,  # porcentaje (más estricto)
        "min_throughput_req_sec": 100,
        "description": "Carga sostenida durante periodos prolongados",
    }


class EndpointMetrics:
    """
    Métricas esperadas para cada endpoint del sistema.
    """

    PRODUCT_SERVICE = {
        "GET /products": {
            "avg_response_time": 200,
            "p95": 500,
            "p99": 1000,
            "weight": 3,  # Se espera más frecuente
        },
        "GET /products/{id}": {
            "avg_response_time": 150,
            "p95": 400,
            "p99": 800,
            "weight": 2,
        },
        "POST /products": {
            "avg_response_time": 300,
            "p95": 700,
            "p99": 1500,
            "weight": 1,
        },
    }

    ORDER_SERVICE = {
        "POST /orders": {
            "avg_response_time": 400,
            "p95": 1000,
            "p99": 2000,
            "weight": 4,  # Operación crítica
        },
        "GET /orders/{id}": {
            "avg_response_time": 200,
            "p95": 500,
            "p99": 1000,
            "weight": 3,
        },
        "GET /orders/user/{userId}": {
            "avg_response_time": 300,
            "p95": 700,
            "p99": 1500,
            "weight": 2,
        },
    }

    PAYMENT_SERVICE = {
        "POST /payments": {
            "avg_response_time": 500,
            "p95": 1500,
            "p99": 3000,
            "weight": 5,  # Crítico, puede ser lento
        },
        "GET /payments/{id}": {
            "avg_response_time": 200,
            "p95": 500,
            "p99": 1000,
            "weight": 2,
        },
        "PUT /payments/{id}/status": {
            "avg_response_time": 300,
            "p95": 800,
            "p99": 1500,
            "weight": 3,
        },
    }


class HealthChecks:
    """
    Puntos de control que indican salud del sistema.
    """

    # Indicadores de un sistema SANO
    HEALTHY = {
        "failure_rate": 0,  # 0% de fallos
        "response_time_degradation": 0,  # Sin degradación
        "memory_growth": 0,  # Estable
        "cpu_usage": "< 70%",
        "error_logs": 0,
        "timeout_count": 0,
    }

    # Indicadores de ADVERTENCIA
    WARNING = {
        "failure_rate": "1-5%",
        "response_time_degradation": "10-25% más lento",
        "memory_growth": "< 5% por minuto",
        "cpu_usage": "70-85%",
        "error_logs": "< 10/minuto",
        "timeout_count": "< 1% de requests",
    }

    # Indicadores de CRÍTICO
    CRITICAL = {
        "failure_rate": "> 5%",
        "response_time_degradation": "> 25% más lento",
        "memory_growth": "> 5% por minuto",
        "cpu_usage": "> 85%",
        "error_logs": "> 10/minuto",
        "timeout_count": "> 1% de requests",
    }


# INTERPRETACIÓN DE RESULTADOS

INTERPRETATION_GUIDE = """
╔════════════════════════════════════════════════════════════════╗
║          GUÍA DE INTERPRETACIÓN DE RESULTADOS                  ║
╚════════════════════════════════════════════════════════════════╝

1. FAILURE RATE (Tasa de Fallos)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   0%       = ✅ Perfecto
   < 1%     = ✅ Aceptable
   1-5%     = ⚠️  Revisar
   > 5%     = ❌ Crítico - Investigar inmediatamente

2. RESPONSE TIME (Tiempo de Respuesta)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   < 200ms  = ✅ Excelente
   200-500ms = ✅ Bueno
   500-1000ms = ⚠️  Aceptable pero lento
   > 1000ms = ❌ Demasiado lento

3. P95 y P99 (Percentiles)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   P95: 95% de requests responden en este tiempo
   P99: 99% de requests responden en este tiempo
   
   Si P95 >> Average: Algunos usuarios tienen experiencia pobre
   Si P99 >> P95: Casos extremos degradan experiencia

4. THROUGHPUT (Solicitudes/segundo)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Mayor es mejor - Indica cuántas solicitudes puede procesar
   Típico: 100-500 req/s dependiendo de operación
   Si baja bajo carga = Posible cuello de botella

5. MEMORY USAGE (Consumo de Memoria)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Debe ser estable durante toda la prueba
   Si crece constantemente = Memory leak
   Investigar con: JVM profiler, Heap dumps


ANÁLISIS RÁPIDO
╔════════════════════════════════════════════════════════════════╗

1. ¿La tasa de fallos es > 1%?
   → SÍ: Revisar logs de error
   → NO: Continuar

2. ¿El P95 es > 1000ms?
   → SÍ: Identificar endpoints lentos
   → NO: Continuar

3. ¿La memoria crece continuamente?
   → SÍ: Investigar memory leaks
   → NO: Buen signo

4. ¿El CPU está > 85%?
   → SÍ: System está al límite
   → NO: Margen disponible

5. ¿El throughput cae bajo carga?
   → SÍ: Bottleneck identificado
   → NO: Sistema escala bien


ACCIONES RECOMENDADAS
╔════════════════════════════════════════════════════════════════╗

✅ SI TODO ESTÁ VERDE:
   • Aumentar usuarios en siguiente prueba
   • Documentar como baseline
   • Considerar pruebas más largas

⚠️  SI HAY ADVERTENCIAS:
   • Identificar endpoints problemáticos
   • Revisar implementación
   • Considerar optimizaciones
   • Rerun para confirmar

❌ SI HAY CRÍTICOS:
   • DETENER - No desplegar en producción
   • Investigar root cause
   • Considerar cambios de arquitectura
   • Rerun después de fixes


PASOS PARA DEBUGGING
╔════════════════════════════════════════════════════════════════╗

1. Revisar logs de aplicación
   grep "ERROR" app.log | head -100

2. Monitorear métricas del sistema
   top, iostat, netstat durante prueba

3. Identificar endpoint problemático
   Mirar el CSV de resultados

4. Ejecutar prueba focused en ese endpoint
   ./test_service.sh [service] -u 50 -t 5m

5. Analizar con profiler/tracer
   Java: JProfiler, YourKit
   Python: cProfile, py-spy

6. Optimizar y rerun
   Comparar con benchmark anterior
"""

if __name__ == "__main__":
    print(INTERPRETATION_GUIDE)
    print("\n" + "=" * 70)
    print("Benchmarks de carga normal:")
    for key, value in PerformanceBenchmarks.LOAD_TEST.items():
        print(f"  {key}: {value}")
