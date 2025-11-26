# 03. Patrones de Diseño de Microservicios

La arquitectura del sistema implementa diversos patrones de diseño de microservicios para garantizar la resiliencia, escalabilidad y mantenibilidad.

## 🛠️ Patrones Corregidos y Optimizados

En esta fase del proyecto, nos enfocamos en corregir implementaciones previas que eran deficientes y en añadir capacidades críticas de resiliencia y gestión.

### 1. Configuración Centralizada (Spring Cloud Config)
*   **Estado Anterior:** Implementación inestable, los servicios fallaban al iniciar si el config server no estaba listo.
*   **Mejora:** Se corrigió la orquestación (`initContainers` en K8s) y la configuración del cliente.
*   **Validación:**
    > **Configuración Centralizada con Hot Reload:** ✅ Probado cambiando propiedades en Git y refrescando sin reiniciar.

### 2. Resilience (Circuit Breaker)
*   **Estado Anterior:** Implementación incorrecta o inexistente en puntos críticos.
*   **Mejora:** Implementación robusta utilizando **Resilience4j** en el API Gateway.
    *   `failure-rate-threshold`: 50%
    *   `wait-duration-in-open-state`: 5s
*   **Validación:**
    > **Resilience (Circuit Breaker):** ✅ Probado obteniendo respuesta de fallback cuando el servicio está caído.

### 3. Feature Toggle
*   **Implementación:** Uso de propiedades dinámicas para habilitar/deshabilitar funcionalidades en tiempo de ejecución sin redesplegar.
*   **Validación:**
    > **Feature Toggle:** ✅ Probado habilitando/deshabilitando el borrado de productos en caliente.

## 🏗️ Otros Patrones Presentes en la Arquitectura

*   **API Gateway:** Punto de entrada único (Spring Cloud Gateway) que gestiona enrutamiento (`lb://SERVICE-NAME`) y cross-cutting concerns.
*   **Service Discovery (Eureka):** Registro dinámico de servicios.
*   **Distributed Tracing (Zipkin):** Rastreo de peticiones a través de los microservicios.
*   **Database per Service:** Cada microservicio gestiona sus propios datos.
*   **Health Check API:** Exposición de `/actuator/health`.

## 🎯 Conclusión

La arquitectura ha evolucionado de una implementación base a una solución resiliente y gestionable. La corrección de patrones críticos como el Circuit Breaker y la Configuración Centralizada asegura que el sistema pueda soportar fallos parciales y cambios de configuración sin tiempo de inactividad.

### Evidencia de Service Discovery
![Eureka Server](../img/eureka.png)
