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