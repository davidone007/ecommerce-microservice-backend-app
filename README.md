# E-Commerce Microservices - Sistema de Backend con Arquitectura Cloud-Native

![Java](https://img.shields.io/badge/Java-11-orange)
![Docker](https://img.shields.io/badge/Docker-Enabled-blue)
![Kubernetes](https://img.shields.io/badge/Kubernetes-Ready-326CE5)
![CI/CD](https://img.shields.io/badge/CI%2FCD-Azure%20Pipelines-0078D7)

## 📋 Descripción del Proyecto

Este proyecto implementa un sistema completo de **e-commerce** basado en arquitectura de microservicios utilizando **Spring Boot** y **Spring Cloud**. El sistema fue heredado como una base de código funcional, y mi trabajo se centró en la **containerización completa con Docker**, **orquestación con Kubernetes (Minikube)**, **implementación de pipelines CI/CD**, **corrección de errores críticos de lógica**, **optimización de código** y **automatización de despliegues**.

## 🎯 Mi Contribución al Proyecto

### ✅ Trabajo Realizado

#### 🐳 Containerización Completa
- Creación de Dockerfiles optimizados para cada microservicio
- Configuración de Docker Compose para desarrollo local
- Implementación de multi-stage builds para reducir tamaño de imágenes
- Configuración de redes y volúmenes Docker

#### ☸️ Orquestación con Kubernetes
- Creación de manifiestos YAML para todos los servicios
- Configuración de Deployments, Services y ConfigMaps
- Implementación de health checks y readiness probes
- Scripts de automatización para despliegue en Minikube
- Configuración de port-forwarding para acceso a servicios

#### 🔄 CI/CD Pipelines
- Implementación de Azure Pipelines para integración continua
- Configuración de GitHub Actions self-hosted runner
- Automatización de builds y pruebas
- Versionado semántico y gestión de releases
- Despliegue automatizado a diferentes entornos

#### 🐛 Corrección de Errores
- Identificación y corrección de múltiples errores de lógica de negocio
- Solución de problemas de configuración en Spring Cloud
- Corrección de dependencias entre servicios
- Optimización de consultas y manejo de excepciones

#### 📝 Scripts de Automatización
- Scripts bash para construcción de imágenes
- Scripts de despliegue en Kubernetes
- Automatización de port-forwarding
- Scripts de limpieza y mantenimiento

#### 🧪 Testing
- Implementación de pruebas de integración
- Configuración de Postman collections para E2E testing
- **Pruebas de Seguridad (OWASP ZAP)**: Escaneo automatizado de vulnerabilidades en el pipeline CI/CD.
 - **Pruebas de Seguridad (OWASP ZAP)**: Escaneo automatizado de vulnerabilidades en el pipeline CI/CD.
 - **Escaneo Continuo de Vulnerabilidades**: Trivy (imágenes GHCR) + OWASP Dependency-Check (dependencias Maven) se ejecutan periódicamente y bajo demanda para detectar vulnerabilidades en imágenes y dependencias.
- Preparación de infraestructura para pruebas de rendimiento con Locust

### 📦 Código Base Original

El código de negocio de los microservicios (lógica de dominio, repositorios, servicios, controladores) ya existía como punto de partida. Mi trabajo se enfocó en hacer que este código fuera **deployable**, **escalable** y **mantenible** mediante las prácticas modernas de DevOps y Cloud-Native.

## 🏗️ Arquitectura del Sistema

### Microservicios Implementados

| Servicio | Puerto | Descripción |
|----------|--------|-------------|
| **service-discovery** | 8761 | Servidor Eureka para registro y descubrimiento de servicios |
| **cloud-config** | 9296 | Servidor de configuración centralizada |
| **api-gateway** | 8080 | Gateway principal para enrutamiento de peticiones |
| **proxy-client** | 8900 | Servicio de autenticación y autorización |
| **user-service** | 8700 | Gestión de usuarios y credenciales |
| **product-service** | 8500 | Gestión de productos y categorías |
| **favourite-service** | 8800 | Gestión de productos favoritos de usuarios |
| **order-service** | 8300 | Gestión de órdenes de compra |
| **payment-service** | 8400 | Procesamiento de pagos |
| **shipping-service** | 8600 | Gestión de envíos |
| **zipkin** | 9411 | Distributed tracing y monitoreo |

### Diagrama de Arquitectura

![Arquitectura del Sistema](app-architecture.drawio.png)

### Modelo de Datos

![ERD del Sistema](ecommerce-ERD.drawio.png)

## 📚 Documentación Completa

La documentación está organizada en los siguientes documentos:

### 📖 Documentación Principal

- **[01 - Arquitectura y Diseño](docs/01-arquitectura-y-diseno.md)**
  - Arquitectura de microservicios
  - Patrones de diseño implementados
  - Tecnologías utilizadas
  - Diagramas del sistema

- **[02 - Containerización con Docker](docs/02-containerizacion-docker.md)**
  - Dockerfiles de cada servicio
  - Docker Compose configuración
  - Estrategia de imágenes
  - Troubleshooting Docker

- **[03 - Orquestación con Kubernetes](docs/03-orquestacion-kubernetes.md)**
  - Manifiestos de Kubernetes
  - Despliegue en Minikube
  - Scripts de automatización
  - Gestión de servicios

- **[04 - Pipelines CI/CD](docs/04-pipelines-ci-cd.md)**
  - Azure Pipelines configuración
  - GitHub Actions workflows
  - Estrategia de branching
  - Versionado y releases

- **[05 - Pruebas y Testing](docs/05-pruebas-testing.md)**
  - Pruebas unitarias e integración
  - Pruebas E2E con Postman
  - Infraestructura de pruebas de rendimiento
  - Resultados y métricas

- **[06 - Correcciones y Mejoras](docs/06-correcciones-mejoras.md)**
  - Errores corregidos
  - Mejoras implementadas
  - Refactorización de código
  - Optimizaciones

- **[07 - Scripts y Automatización](docs/07-scripts-automatizacion.md)**
  - Scripts de construcción
  - Scripts de despliegue
  - Scripts de mantenimiento
  - Guía de uso

- **[08 - Release Notes](docs/08-release-notes.md)**
  - Versión 0.0.3 (master - production)
  - Versión 0.0.1-pre-release (stage)
  - Historial de versiones
  - Changelog detallado

- **[09 - Performance Testing](docs/09-performance-testing.md)**
  - Pruebas de rendimiento con Locust
  - Escenarios de carga
  - Análisis de resultados

## 🚀 Inicio Rápido

### Prerequisitos

- **Java 11** JDK
- **Maven 3.6+**
- **Docker** y Docker Compose
- **Kubernetes** (Minikube para local)
- **kubectl** CLI
- **Git**

### Software Requerido

1. **Java 11**: Descargar de [Oracle JDK 11](https://www.oracle.com/java/technologies/javase/jdk11-archive-downloads.html)
2. **Git**: Descargar de [git-scm.com](https://git-scm.com/downloads)
3. **Maven**: Descargar de [maven.apache.org](https://maven.apache.org/download.cgi)
4. **curl**: Descargar de [curl.se](https://curl.haxx.se/download.html)
5. **jq**: Descargar de [stedolan.github.io/jq](https://stedolan.github.io/jq/download/)
6. **Docker**: Descargar de [docker.com](https://www.docker.com/products/docker-desktop)
7. **Minikube**: Descargar de [minikube.sigs.k8s.io](https://minikube.sigs.k8s.io/docs/start/)

### Clonar el Repositorio

```bash
git clone https://github.com/davidone007/ecommerce-microservice-backend-app.git
cd ecommerce-microservice-backend-app
```

### Construir el Proyecto

```bash
./mvnw clean package
```

El resultado esperado:

```bash
[INFO] ------------------------------------------------------------------------
[INFO] Reactor Summary for ecommerce-microservice-backend 0.1.0:
[INFO] 
[INFO] ecommerce-microservice-backend ..................... SUCCESS [  0.548 s]
[INFO] service-discovery .................................. SUCCESS [  3.126 s]
[INFO] cloud-config ....................................... SUCCESS [  1.595 s]
[INFO] api-gateway ........................................ SUCCESS [  1.697 s]
[INFO] proxy-client ....................................... SUCCESS [  3.632 s]
[INFO] user-service ....................................... SUCCESS [  2.546 s]
[INFO] product-service .................................... SUCCESS [  2.214 s]
[INFO] favourite-service .................................. SUCCESS [  2.072 s]
[INFO] order-service ...................................... SUCCESS [  2.241 s]
[INFO] shipping-service ................................... SUCCESS [  2.197 s]
[INFO] payment-service .................................... SUCCESS [  2.006 s]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
```

### Opción 1: Ejecutar con Docker Compose
## 🔐 Escaneo continuo de vulnerabilidades (Trivy + Dependency-Check)

Este repositorio ejecuta escaneos automáticos de seguridad para detectar vulnerabilidades en imágenes de contenedor y en dependencias del proyecto:

- Trivy: escanea imágenes publicadas en GHCR (tags `dev` y `latest`) — se ejecuta diariamente y también puede dispararse manualmente desde GitHub Actions. El trabajo programado genera artefactos con los resultados en cada ejecución.
- OWASP Dependency-Check: ejecuta un análisis de dependencias en la base de código Maven y sube el informe HTML y XML como artefactos.

Dónde revisar resultados:
- pestaña `Actions` → ejecutar el workflow `Security - Continuous Vulnerability Scans` (programado o manual).
- artefactos adjuntos a la ejecución: `dependency-check-reports` y logs de Trivy para cada imagen.

Cómo ajustar comportamiento:
- El pipeline `ci-cd-dev.yml` ya está configurado para fallar (exit-code 1) cuando Trivy detecta vulnerabilidades CRÍTICAS en la imagen semver generada por Dev, evitando promover imágenes inseguras a Stage.
- Para recibir notificaciones por email, configura los secretos `MAIL_ENABLED=true`, `MAIL_USERNAME`, `MAIL_PASSWORD`, `MAIL_TO` en tu repositorio o Environment — el workflow programado enviará correo si está habilitado.

Si quieres, puedo:
- Añadir integración con Slack / Teams para avisos de seguridad.
- Configurar bloqueo más estricto (fail build on HIGH) o generar SBOMs y firmar imágenes (cosign).

### 🔎 Trivy: escaneo del repositorio (trivy fs / trivy config)

Además de escanear imágenes y dependencias, Trivy puede ejecutar escaneos directamente sobre el repositorio:

- trivy fs (File-System scan): inspecciona el árbol de ficheros (paquetes y dependencias detectadas en la fuente) para encontrar vulnerabilidades.
- trivy config (Configuration scan): revisa archivos de configuración e IAC (Dockerfile, YAML, Helm charts, Terraform) para detectar malas prácticas o configuraciones inseguras.

Ejemplos rápidos (desde la raíz del repositorio):

```bash
# Escaneo filesystem (JSON y formato tabla)
trivy fs --format json --output trivy-fs.json --severity CRITICAL,HIGH .
trivy fs --format table .

# Escaneo de configuraciones (JSON y formato tabla)
trivy config --format json --output trivy-config.json --severity CRITICAL,HIGH .
trivy config --format table .
```

Buenas prácticas para CI:
- Para streams programados (schedules) es recomendable no bloquear por defecto (exit code 0) y usar los resultados como trazabilidad; para pipelines de PRs o pushes a ramas de integración puede usarse `--exit-code 1` para bloquear cuando se detecten vulnerabilidades críticas.
- Los informes generados por el workflow `Security - Continuous Vulnerability Scans` se publican como artefactos (trivy-fs.json / trivy-config.json) para su análisis.


```bash
# Establecer la variable de entorno para el tag
export BRANCH_TAG=latest

# Levantar todos los servicios
docker-compose -f compose.yml up -d

# Ver logs
docker-compose logs -f
```

### Opción 2: Desplegar en Kubernetes (Minikube)

```bash
# 1. Iniciar Minikube
./scripts/start-minikube.sh

# 2. Construir las imágenes Docker
./scripts/build-images.sh

# 3. Cargar imágenes en Minikube
./scripts/load-images-minikube.sh

# 4. Desplegar en Kubernetes
./scripts/deploy-k8s.sh latest

# 5. Verificar el despliegue
kubectl get pods
kubectl get svc

# 6. Habilitar port-forwarding para acceder a los servicios
./scripts/port-forward-all-services-nohup.sh
```

### Acceder a los Servicios

Una vez desplegado, puedes acceder a:

- **Eureka Dashboard**: http://localhost:8761
- **API Gateway**: http://localhost:8080
- **Zipkin Tracing**: http://localhost:9411
- **Swagger UI (Proxy Client)**: http://localhost:8900/swagger-ui.html

## 🔧 Comandos Útiles

### Docker

```bash
# Ver estado de contenedores
docker-compose ps

# Ver logs de un servicio específico
docker-compose logs -f service-discovery-container

# Detener todos los servicios
docker-compose down

# Limpiar volúmenes y redes
docker-compose down -v --remove-orphans
```

### Kubernetes

```bash
# Ver todos los pods
kubectl get pods -o wide

# Ver logs de un pod
kubectl logs -f <pod-name>

# Describir un pod
kubectl describe pod <pod-name>

# Reiniciar un deployment
kubectl rollout restart deployment/<deployment-name>

# Eliminar todos los recursos
kubectl delete -f k8s/
```

## 🧪 Pruebas

### Ejecutar Pruebas Automatizadas

```bash
./test-em-all.sh start
```

Para iniciar, probar y detener:

```bash
./test-em-all.sh stop
```

### Verificar Health de los Servicios

```bash
curl -k https://localhost:8080/actuator/health -s | jq
```

### Acceder a Métricas

- **Actuator Metrics**: http://localhost:8080/app/actuator/metrics
- **Prometheus Metrics**: http://localhost:8080/app/actuator/prometheus

## 📊 Versionado y Releases

### Estrategia de Branching

- **`master`**: Producción (v0.0.3)
- **`stage`**: Pre-producción (v0.0.1-pre-release)
- **`dev`**: Desarrollo activo

### Versiones Actuales

- **Producción (master)**: `v0.0.3` - Release estable
- **Stage**: `v0.0.1-pre-release` - Pre-release para testing

Ver [Release Notes completas](docs/08-release-notes.md)

## 🔁 Promoción controlada entre entornos (dev → stage → prod)

Se ha habilitado un flujo de **promoción manual** para mover una versión semántica ya construida a los entornos **stage** y **prod** sin reconstruir las imágenes.

- Workflow: `.github/workflows/promote.yml` (ejecución manual - workflow_dispatch)
- Parámetros: `version` (ej. 1.2.3) y `target` (stage | prod)

Cómo funciona brevemente:

1. Las imágenes Docker se construyen y etiquetan con la versión semántica (p. ej. `v1.2.3`) en la pipeline principal.
2. Usa el workflow `Promote Release` (Actions → Promote Release → Run workflow) y pasa `version=vX.Y.Z` y `target=stage` para promover esa versión a Stage.
3. Para promoción a producción, usa `target=prod`. El workflow se encarga de conectarse al AKS correspondiente y ejecutar el deploy Helm con `imageTag=vX.Y.Z`.

Beneficios:

- Promociones controladas y manuales (aprobación humana cuando se requiere)
- Evita reconstrucciones innecesarias — se despliega exactamente la imagen ya publicada
- Mantiene trazabilidad por versión (etiquetas semánticas + releases en GitHub)

Prueba segura (recomendado): prueba primero con `target=stage` usando una versión que ya exista en GHCR (por ejemplo una versión `dev-...` o la semver publicada) y verifica que los servicios se despliegan correctamente antes de promover a `prod`.

###  Aprobar despliegues a producción (GitHub Environments)

Para asegurar que los despliegues a `prod` requieren aprobación humana, utiliza GitHub Environments protections:

- Crea un Environment llamado exactamente `production` en GitHub (Settings → Environments).
- Configura "Required reviewers" en ese Environment para forzar aprobaciones manuales antes de ejecutar cualquier job que use ese environment.
- Opcionalmente puedes configurar un "Wait timer" o restricciones adicionales (por ejemplo, reviewers específicos o teams).

El workflow `.github/workflows/promote.yml` y la job de `kubernetes-deploy` en `ci-cd-master.yml` están configuradas para usar ese environment. Cuando se ejecute una promoción o un deploy de `master` dirigido a `production`, GitHub pedirá las aprobaciones configuradas antes de permitir que el job continúe.

Si prefieres administrar esto desde CLI, la creación y configuración de environments se puede hacer con la GitHub API o `gh api` — pero la protección (required reviewers) debe configurarse en la UI o a través de la API con los permisos adecuados.

## 📌 Metodología Ágil, Gestión del Proyecto y Estrategia de Branching

El desarrollo de este sistema se gestionó utilizando una **metodología ágil basada en Scrum adaptado**, apoyada con un **tablero Kanban dentro de GitHub Projects**. Esta combinación permite mantener una planificación clara mediante Historias de Usuario (HU) y al mismo tiempo un flujo continuo y visual del progreso.

---

## 🟩 Metodología Ágil Implementada

### ✔ Historias de Usuario (HU)

Se definieron **11 Historias de Usuario**, abarcando:

* Infraestructura con Terraform
* Modularización IaC
* Multiambientes (dev, stage, prod)
* Backend remoto de Terraform
* Despliegue con Helm
* Configuración de probes
* Pipelines CI/CD
* Seguridad (SonarQube, Trivy)
* Pruebas completas (unitarias, integración, E2E, rendimiento)
* Observabilidad (Prometheus, Grafana, ELK, Jaeger)
* Preparación de la presentación final

Cada HU incluye descripción y criterios de aceptación claros.

---

## 🟨 Gestión con GitHub Projects

Se configuró un tablero tipo **Kanban**, con las columnas:

* **Backlog**
* **To Do**
* **In Progress**
* **In Review**
* **Done**

Todas las HU fueron creadas como **GitHub Issues** y vinculadas al tablero.
El avance del proyecto se controla moviendo cada HU a través de estas columnas según su estado.

### Beneficios:

* Visualización completa del progreso
* Seguimiento granular por HU
* Trazabilidad exacta para CI/CD y desarrollo

---

## 🟦 Estrategia de Branching (GitHub Flow Adaptado)

Se utilizó **GitHub Flow** pero adaptado a ambientes múltiples (dev, stage, prod).

### Ramas principales:

* **main → Producción**
* **stage → Preproducción**
* **dev → Desarrollo**
* **feature/HU-xx → Trabajo específico**

### Flujo de trabajo:

1. Crear rama `feature/HUxx-nombre` desde `dev`.
2. Desarrollar la HU.
3. Hacer Pull Request hacia `dev`.
4. Cuando se valida: merge `dev → stage`.
5. Con aprobación manual: `stage → main`.

Este flujo permite **promoción controlada**, despliegues seguros y trazabilidad completa.

---

## 🧩 Fases del Proyecto

### **Fase 1: Infraestructura y Despliegue Base**

* HU1 – Terraform IaC
* HU2 – Modularización
* HU3 – Ambientes
* HU4 – Backend remoto
* HU5 – Despliegue con Helm

### **Fase 2: Calidad, Seguridad y Observabilidad**

* HU6 – Probes
* HU7 – CI/CD
* HU8 – Seguridad y análisis de calidad
* HU9 – Pruebas completas
* HU10 – Observabilidad
* HU11 – Presentación final

## 📸 Capturas de Pantalla

### Docker Compose - Servicios Levantados

![Docker Compose API Gateway](img/dockercompose-apigateway.png)
![Docker Compose Microservices](img/dockercompose-microservices.png)

### Kubernetes - Despliegue Exitoso

![Kubectl Apply](img/kubectl-apply.png)
![Kubectl Get Pods](img/kubectl-get-pods.png)

### Eureka Service Discovery

![Eureka Dashboard](img/eureka.png)

### Zipkin Distributed Tracing

![Zipkin Dashboard](img/zipkinBueno.png)

### CI/CD Pipelines

![GitHub Dev Pipeline](img/github-dev-passed-pipeline.png)
![GitHub Stage Pipeline](img/github-stage-passed-pipeline.png)
![GitHub Master Pipeline](img/github-master-passed-pipeline.png)

### GitHub Releases

![Pre-release Stage](img/prerelease-stage.png)
![Release Master](img/release-master.png)

## 🛠️ Tecnologías Utilizadas

### Backend & Framework

- **Java 11**
- **Spring Boot 2.5.7**
- **Spring Cloud 2020.0.4**
- **Spring Cloud Netflix Eureka**
- **Spring Cloud Config**
- **Spring Cloud Gateway**
- **Resilience4j** (Circuit Breaker)

### Bases de Datos

- **H2** (In-memory para desarrollo)
- **MySQL** (Persistencia)

### Containerización y Orquestación

- **Docker**
- **Docker Compose**
- **Kubernetes**
- **Minikube**

### CI/CD

- **Azure Pipelines**
- **GitHub Actions**
- **Self-hosted Runner**

### Monitoreo y Observabilidad

- **Zipkin** (Distributed Tracing)
- **Spring Boot Actuator**
- **Prometheus** (Métricas)

### Testing

- **JUnit 5**
- **Testcontainers**
- **Postman** (E2E Testing)
- **Locust** (Performance Testing)

### Herramientas de Desarrollo

- **Maven**
- **Git**
- **Swagger/OpenAPI**
- **Bash Scripting**

## 🤝 Contribución

Este proyecto fue desarrollado como parte de una práctica profesional enfocada en:

- Modernización de aplicaciones monolíticas/microservicios
- Implementación de prácticas DevOps
- Automatización de despliegues
- Containerización de aplicaciones Java/Spring Boot
- Orquestación con Kubernetes
- Implementación de pipelines CI/CD

## 📞 Contacto

**Davide Flamini**

- GitHub: [@davidone007](https://github.com/davidone007)
- Repository: [ecommerce-microservice-backend-app](https://github.com/davidone007/ecommerce-microservice-backend-app)

## 📄 Licencia

Este proyecto es parte de un trabajo académico/profesional y está disponible para fines educativos y de demostración.

---

## 🎓 Aprendizajes Clave

Este proyecto me permitió desarrollar y demostrar habilidades en:

✅ **Containerización** de aplicaciones empresariales complejas  
✅ **Orquestación** con Kubernetes en entorno local  
✅ **Pipelines CI/CD** con Azure DevOps y GitHub Actions  
✅ **Debugging** y resolución de problemas en arquitecturas distribuidas  
✅ **Automatización** mediante scripting bash  
✅ **Monitoreo** y observabilidad de microservicios  
✅ **Versionado semántico** y gestión de releases  
✅ **Documentación técnica** completa y profesional

---

**⭐ Si encuentras útil este proyecto, considera darle una estrella en GitHub!**