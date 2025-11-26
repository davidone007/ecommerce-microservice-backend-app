# 07. Observabilidad y Monitoreo

Para garantizar la alta disponibilidad y el rendimiento del sistema, hemos implementado una pila completa de observabilidad.

## 📡 Stack de Monitoreo

### Prometheus y Grafana (Producción)
Utilizamos **Prometheus** para la recolección de métricas y **Grafana** para la visualización.

*   **Prometheus:** Scrapea métricas de los microservicios (expuestas vía Spring Boot Actuator) y del cluster de Kubernetes.
*   **Grafana:** Dashboards personalizados para visualizar CPU, Memoria, Latencia y Errores.

> **Estrategia de Despliegue:** Para optimizar recursos y costos, la pila completa de **Prometheus y Grafana se encuentra desplegada ÚNICAMENTE en el entorno de Producción**. En Stage, validamos la funcionalidad sin la sobrecarga del monitoreo persistente.

### ELK Stack (Elasticsearch, Logstash, Kibana)
Centralizamos los logs de todos los microservicios.
*   **Logstash:** Recibe logs de los contenedores.
*   **Elasticsearch:** Almacena e indexa los logs.
*   **Kibana:** Permite la búsqueda y visualización de logs en tiempo real.

### Tracing Distribuido (Zipkin)
Implementamos **Zipkin** para rastrear las peticiones a medida que viajan entre los microservicios.
*   **Integración:** Spring Cloud Sleuth inyecta IDs de traza en las cabeceras HTTP.
*   **Visualización:** Zipkin UI permite ver el grafo de dependencias y tiempos de respuesta por servicio.

## 🚨 Alertas y Health Checks

*   **Liveness Probes:** `/actuator/health/liveness` - Reinicia el pod si falla.
*   **Readiness Probes:** `/actuator/health/readiness` - Detiene el tráfico si no está listo.

## 📸 Evidencia de Tracing

### Traza Distribuida (Zipkin)
![Zipkin Trace](../img/zipkinBueno.png)

### Dashboard de Zipkin
![Zipkin Dashboard](../img/zipkin-dash.png)
