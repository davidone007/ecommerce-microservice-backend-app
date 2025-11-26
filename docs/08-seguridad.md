# 08. Seguridad

La seguridad se ha integrado en cada etapa del ciclo de vida de desarrollo (DevSecOps), desde el código hasta el despliegue.

## 🛡️ Medidas de Seguridad Implementadas

### 1. Escaneo Continuo de Vulnerabilidades
Utilizamos **Trivy** en el pipeline de **Dev** para escanear:
*   **Imágenes Docker:** Detección de vulnerabilidades (CVEs) en el sistema operativo base y paquetes instalados.
*   **Repositorio (Filesystem):** Búsqueda de secretos hardcodeados y malas configuraciones en archivos IaC (Terraform, Kubernetes).

> **Política:** Las vulnerabilidades CRITICAL se reportan, pero en el entorno de desarrollo (Dev) están configuradas para no romper el build (exit code 0) para no bloquear el flujo de trabajo ágil, aunque se generan alertas.

### 2. Pruebas de Seguridad Dinámicas (DAST)
En el pipeline de **Stage**, ejecutamos **OWASP ZAP (Zed Attack Proxy)**.
*   **Tipo:** Full Scan.
*   **Objetivo:** Atacar activamente la aplicación desplegada para encontrar vulnerabilidades explotables en tiempo de ejecución.

### 3. Gestión Segura de Secretos
Nunca almacenamos credenciales en el código fuente.
*   **GitHub Secrets:** Para credenciales de CI/CD (Azure Service Principal, Docker Hub Token, Sonar Token).
*   **Kubernetes Secrets:** Para credenciales en tiempo de ejecución (Base de datos, RabbitMQ).

### 4. Control de Acceso Basado en Roles (RBAC)
Implementamos RBAC en Kubernetes para restringir quién puede desplegar o modificar recursos en el cluster.
*   **Devs:** Permisos limitados.
*   **Ops/Admin:** Control total sobre el cluster.

### 5. Comunicaciones Seguras
*   **TLS/SSL:** Todos los servicios expuestos públicamente a través del Ingress Controller están protegidos con TLS.
*   **API Gateway:** Actúa como punto único de entrada, ocultando la topología interna de la red.

## 📸 Evidencia de Seguridad

### Ejemplo de RBAC
![RBAC](../img/img-RBAC/RBAC-example.png)
