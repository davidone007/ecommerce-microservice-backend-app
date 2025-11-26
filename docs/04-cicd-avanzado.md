# 04. CI/CD Avanzado con GitHub Actions

Hemos implementado pipelines de CI/CD robustos y automatizados utilizando **GitHub Actions**, cubriendo todo el ciclo de vida desde el commit hasta el despliegue en producción.

## 🚀 Estructura de Pipelines

Nuestros pipelines están diseñados con responsabilidades claras por ambiente, asegurando que solo el código validado avance hacia producción.

### 1. Pipeline de Desarrollo (Dev)
Se ejecuta en ramas `dev` y Pull Requests hacia `dev`.
*   **Build & Unit Tests:** Compilación con Maven y ejecución de pruebas unitarias (`*ServiceImplTest`).
*   **Análisis de Calidad (SonarQube):** Análisis estático de código para detectar bugs y deuda técnica.
*   **Escaneo de Seguridad (Trivy):**
    *   **Filesystem Scan:** Busca secretos y malas configuraciones en el repositorio.
    *   **Image Scan:** Busca vulnerabilidades (CVEs) en las imágenes Docker construidas.
*   **Docker Build & Push:** Construcción de imágenes y subida a GHCR (solo en merge a `dev`).
*   **Release:** Generación de pre-release `dev-x.x.x`.

### 2. Pipeline de Staging (Stage)
Se ejecuta al hacer merge a `stage`. Este es el entorno de **validación intensiva**.
*   **Fetch Image:** Reutiliza la imagen inmutable generada en Dev.
*   **Deploy to Stage:** Despliegue en el cluster AKS (namespace `stage`).
*   **Pruebas de Integración:** Ejecución de pruebas Maven (`*IntegrationTest`) contra el entorno desplegado.
*   **Pruebas E2E:** Ejecución de colección de Postman con Newman para validar flujos completos de usuario.
*   **Pruebas de Seguridad (DAST):** Escaneo dinámico con **OWASP ZAP** contra los endpoints vivos.
*   **Pruebas de Rendimiento:** Ejecución de pruebas de carga con **Locust**.
*   **Release:** Generación de pre-release `stage-x.x.x`.

### 3. Pipeline de Producción (Master)
Se ejecuta al hacer merge a `master`.
*   **Fetch Stage Tag:** Identifica la versión validada en Stage.
*   **Deploy to Production:** Despliegue en el cluster AKS (namespace `prod`).
    *   *Requiere aprobación manual en GitHub Environments.*
*   **Smoke Tests:** Verificación rápida de salud de los servicios críticos post-despliegue.
*   **Release Final:** Generación de release oficial `vX.X.X` y notas de cambio.

## 📦 Gestión de Artefactos

Los resultados de cada etapa se almacenan como artefactos en GitHub Actions para auditoría y depuración:
*   `test-results`: Reportes XML de JUnit.
*   `trivy-repo-scan`: Reportes de vulnerabilidades del repositorio.
*   `e2e-test-report`: Reporte HTML de pruebas Postman.
*   `zap-security-report`: Reporte de vulnerabilidades detectadas por OWASP ZAP.
*   `performance-test-results`: Reportes HTML/CSV de Locust.

## 📸 Evidencia de Pipelines

### Pipeline Exitoso (Master)
![Master Pipeline](../img/github-master-passed-pipeline.png)

### Artefactos Generados
![Artifacts](../img/github-artifacts-master-pipeline.png)
