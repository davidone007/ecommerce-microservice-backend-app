# 05. Estrategia de Pruebas (QA)

La calidad del software es una prioridad en este proyecto. Hemos implementado una estrategia de pruebas integral que cubre desde la unidad más pequeña hasta el comportamiento del sistema completo bajo carga, ejecutada automáticamente en nuestros pipelines.

## 🧪 Tipos de Pruebas Implementadas

### 1. Pruebas Unitarias (Dev Pipeline)
Verifican la lógica de negocio aislada de cada componente.
*   **Herramientas:** JUnit 5, Mockito.
*   **Ejecución:** En cada push a `dev`.
*   **Comando:** `./mvnw verify -Dtest="*ServiceImplTest"`

### 2. Pruebas de Integración (Stage Pipeline)
Validan la interacción entre componentes y con dependencias externas en un entorno real.
*   **Herramientas:** Maven Failsafe Plugin.
*   **Ejecución:** Contra el entorno desplegado en Stage.
*   **Comando:** `./mvnw verify -Dtest="*IntegrationTest"`

### 3. Pruebas End-to-End (E2E) (Stage Pipeline)
Simulan flujos de usuario reales recorriendo todos los microservicios a través del API Gateway.
*   **Herramientas:** Postman Collection + Newman.
*   **Ejecución:** Pipeline de Stage.
*   **Cobertura:** Flujos de compra, pago y consulta de productos.

### 4. Pruebas de Rendimiento (Stage Pipeline)
Evalúan el comportamiento del sistema bajo carga.
*   **Herramienta:** Locust (Python).
*   **Ejecución:** Pipeline de Stage.
*   **Escenario:** Simulación de 10 usuarios concurrentes con una tasa de spawn de 2 usuarios/segundo durante 1 minuto.
*   **Objetivo:** Verificar estabilidad básica bajo carga antes de ir a producción.

### 5. Pruebas de Seguridad (DAST) (Stage Pipeline)
Análisis dinámico de seguridad de aplicaciones.
*   **Herramienta:** OWASP ZAP (Full Scan).
*   **Ejecución:** Pipeline de Stage.
*   **Objetivo:** Detectar vulnerabilidades en los endpoints expuestos (XSS, SQL Injection, etc.).

### 6. Smoke Tests (Master Pipeline)
Verificación rápida post-despliegue en Producción.
*   **Herramienta:** Script Bash (cURL).
*   **Ejecución:** Pipeline de Master tras el despliegue.
*   **Objetivo:** Confirmar que los servicios principales responden (HTTP 200) antes de dar por exitoso el release.

## 📊 Integración y Reportes

Todas las pruebas generan reportes que se almacenan como artefactos:
*   **Unit/Integration:** `surefire-reports` (XML).
*   **E2E:** `e2e-test-report.html`.
*   **Performance:** `report.html` (Locust).
*   **Security:** `zap-security-report` (HTML/JSON).

## 📸 Evidencia de Pruebas

### Ejecución de Pruebas E2E (Postman)
![Postman E2E](../img/postmane2e-run.png)

### Análisis de Pruebas de Carga (Locust)
![Load Test Analysis](../img/load-test-analysis.png)

### Gráficas de Rendimiento
![Load Test Plots](../img/load-test-plots.png)

### Análisis de SonarQube
![SonarQube](../img/sonnar.png)
