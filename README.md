# E-Commerce Microservices - Sistema de Backend con Arquitectura Cloud-Native# E-Commerce Microservices - Sistema de Backend con Arquitectura Cloud-Native



![Java](https://img.shields.io/badge/Java-11-orange)![Java](https://img.shields.io/badge/Java-11-orange)

![Spring Boot](https://img.shields.io/badge/Spring%20Boot-2.5.7-brightgreen)![Spring Boot](https://img.shields.io/badge/Spring%20Boot-2.5.7-brightgreen)

![Docker](https://img.shields.io/badge/Docker-Enabled-blue)![Docker](https://img.shields.io/badge/Docker-Enabled-blue)

![Kubernetes](https://img.shields.io/badge/Kubernetes-Ready-326CE5)![Kubernetes](https://img.shields.io/badge/Kubernetes-Ready-326CE5)

![CI/CD](https://img.shields.io/badge/CI%2FCD-Azure%20Pipelines-0078D7)![CI/CD](https://img.shields.io/badge/CI%2FCD-Azure%20Pipelines-0078D7)



## 📋 Descripción del Proyecto## 📋 Descripción del Proyecto



Este proyecto implementa un sistema completo de **e-commerce** basado en arquitectura de microservicios utilizando **Spring Boot** y **Spring Cloud**. El sistema fue heredado como una base de código funcional, y mi trabajo se centró en la **containerización completa con Docker**, **orquestación con Kubernetes (Minikube)**, **implementación de pipelines CI/CD**, **corrección de errores críticos de lógica**, **optimización de código** y **automatización de despliegues**.Este proyecto implementa un sistema completo de **e-commerce** basado en arquitectura de microservicios utilizando **Spring Boot** y **Spring Cloud**. El sistema fue heredado como una base de código funcional, y mi trabajo se centró en la **containerización completa con Docker**, **orquestación con Kubernetes (Minikube)**, **implementación de pipelines CI/CD**, **corrección de errores críticos de lógica**, **optimización de código** y **automatización de despliegues**.



## 🎯 Mi Contribución al Proyecto## 🎯 Mi Contribución al Proyecto



### ✅ Trabajo Realizado### ✅ Trabajo Realizado



- **🐳 Containerización Completa**- **🐳 Containerización Completa**

  - Creación de Dockerfiles optimizados para cada microservicio  - Creación de Dockerfiles optimizados para cada microservicio

  - Configuración de Docker Compose para desarrollo local  - Configuración de Docker Compose para desarrollo local

  - Implementación de multi-stage builds para reducir tamaño de imágenes  - Implementación de multi-stage builds para reducir tamaño de imágenes

  - Configuración de redes y volúmenes Docker  - Configuración de redes y volúmenes Docker



- **☸️ Orquestación con Kubernetes**- **☸️ Orquestación con Kubernetes**

  - Creación de manifiestos YAML para todos los servicios  - Creación de manifiestos YAML para todos los servicios

  - Configuración de Deployments, Services y ConfigMaps  - Configuración de Deployments, Services y ConfigMaps

  - Implementación de health checks y readiness probes  - Implementación de health checks y readiness probes

  - Scripts de automatización para despliegue en Minikube  - Scripts de automatización para despliegue en Minikube

  - Configuración de port-forwarding para acceso a servicios  - Configuración de port-forwarding para acceso a servicios



- **🔄 CI/CD Pipelines**- **🔄 CI/CD Pipelines**

  - Implementación de Azure Pipelines para integración continua  - Implementación de Azure Pipelines para integración continua

  - Configuración de GitHub Actions self-hosted runner  - Configuración de GitHub Actions self-hosted runner

  - Automatización de builds y pruebas  - Automatización de builds y pruebas

  - Versionado semántico y gestión de releases  - Versionado semántico y gestión de releases

  - Despliegue automatizado a diferentes entornos  - Despliegue automatizado a diferentes entornos



- **🐛 Corrección de Errores**- **🐛 Corrección de Errores**

  - Identificación y corrección de múltiples errores de lógica de negocio  - Identificación y corrección de múltiples errores de lógica de negocio

  - Solución de problemas de configuración en Spring Cloud  - Solución de problemas de configuración en Spring Cloud

  - Corrección de dependencias entre servicios  - Corrección de dependencias entre servicios

  - Optimización de consultas y manejo de excepciones  - Optimización de consultas y manejo de excepciones



- **📝 Scripts de Automatización**- **📝 Scripts de Automatización**

  - Scripts bash para construcción de imágenes  - Scripts bash para construcción de imágenes

  - Scripts de despliegue en Kubernetes  - Scripts de despliegue en Kubernetes

  - Automatización de port-forwarding  - Automatización de port-forwarding

  - Scripts de limpieza y mantenimiento  - Scripts de limpieza y mantenimiento



- **🧪 Testing**- **🧪 Testing**

  - Implementación de pruebas de integración  - Implementación de pruebas de integración

  - Configuración de Postman collections para E2E testing  - Configuración de Postman collections para E2E testing

  - Preparación de infraestructura para pruebas de rendimiento con Locust  - Preparación de infraestructura para pruebas de rendimiento con Locust



### 📦 Código Base Original### 📦 Código Base Original



El código de negocio de los microservicios (lógica de dominio, repositorios, servicios, controladores) ya existía como punto de partida. Mi trabajo se enfocó en hacer que este código fuera **deployable**, **escalable** y **mantenible** mediante las prácticas modernas de DevOps y Cloud-Native.El código de negocio de los microservicios (lógica de dominio, repositorios, servicios, controladores) ya existía como punto de partida. Mi trabajo se enfocó en hacer que este código fuera **deployable**, **escalable** y **mantenible** mediante las prácticas modernas de DevOps y Cloud-Native.



## 🏗️ Arquitectura del Sistema## 🏗️ Arquitectura del Sistema



### Microservicios Implementados### Microservicios Implementados



| Servicio | Puerto | Descripción || Servicio | Puerto | Descripción |

|----------|--------|-------------||----------|--------|-------------|

| **service-discovery** | 8761 | Servidor Eureka para registro y descubrimiento de servicios || **service-discovery** | 8761 | Servidor Eureka para registro y descubrimiento de servicios |

| **cloud-config** | 9296 | Servidor de configuración centralizada || **cloud-config** | 9296 | Servidor de configuración centralizada |

| **api-gateway** | 8080 | Gateway principal para enrutamiento de peticiones || **api-gateway** | 8080 | Gateway principal para enrutamiento de peticiones |

| **proxy-client** | 8900 | Servicio de autenticación y autorización || **proxy-client** | 8900 | Servicio de autenticación y autorización |

| **user-service** | 8700 | Gestión de usuarios y credenciales || **user-service** | 8700 | Gestión de usuarios y credenciales |

| **product-service** | 8500 | Gestión de productos y categorías || **product-service** | 8500 | Gestión de productos y categorías |

| **favourite-service** | 8800 | Gestión de productos favoritos de usuarios || **favourite-service** | 8800 | Gestión de productos favoritos de usuarios |

| **order-service** | 8300 | Gestión de órdenes de compra || **order-service** | 8300 | Gestión de órdenes de compra |

| **payment-service** | 8400 | Procesamiento de pagos || **payment-service** | 8400 | Procesamiento de pagos |

| **shipping-service** | 8600 | Gestión de envíos || **shipping-service** | 8600 | Gestión de envíos |

| **zipkin** | 9411 | Distributed tracing y monitoreo || **zipkin** | 9411 | Distributed tracing y monitoreo |



### Diagrama de Arquitectura### Diagrama de Arquitectura



![Arquitectura del Sistema](app-architecture.drawio.png)![Arquitectura del Sistema](app-architecture.drawio.png)



### Modelo de Datos### Required software



![ERD del Sistema](ecommerce-ERD.drawio.png)The following are the initially required software pieces:



## 📚 Documentación Completa1. **Java 11**: JDK 11 LTS can be downloaded and installed from https://www.oracle.com/java/technologies/javase/jdk11-archive-downloads.html



La documentación está organizada en los siguientes documentos:1. **Git**: it can be downloaded and installed from https://git-scm.com/downloads



### 📖 Documentación Principal1. **Maven**: Apache Maven is a software project management and comprehension tool, it can be downloaded from here https://maven.apache.org/download.cgi



- **[01 - Arquitectura y Diseño](docs/01-arquitectura-y-diseno.md)**1. **curl**: this command-line tool for testing HTTP-based APIs can be downloaded and installed from https://curl.haxx.se/download.html

  - Arquitectura de microservicios

  - Patrones de diseño implementados1. **jq**: This command-line JSON processor can be downloaded and installed from https://stedolan.github.io/jq/download/

  - Tecnologías utilizadas

  - Diagramas del sistema1. **Spring Boot Initializer**: This *Initializer* generates *spring* boot project with just what you need to start quickly! Start from here https://start.spring.io/



- **[02 - Containerización con Docker](docs/02-containerizacion-docker.md)**1. **Docker**: The fastest way to containerize applications on your desktop, and you can download it from here [https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)

  - Dockerfiles de cada servicio

  - Docker Compose configuración1. **Kubernetes**: We can install **minikube** for testing puposes https://minikube.sigs.k8s.io/docs/start/

  - Estrategia de imágenes

  - Troubleshooting Docker   > For each future stage, I will list the newly required software. 



- **[03 - Orquestación con Kubernetes](docs/03-orquestacion-kubernetes.md)**Follow the installation guide for each software website link and check your software versions from the command line to verify that they are all installed correctly.

  - Manifiestos de Kubernetes

  - Despliegue en Minikube## Using an IDE

  - Scripts de automatización

  - Gestión de serviciosI recommend that you work with your Java code using an IDE that supports the development of Spring Boot applications such as Spring Tool Suite or IntelliJ IDEA Ultimate Edition. So you can use the Spring Boot Dashboard to run the services, run each microservice test case, and many more.



- **[04 - Pipelines CI/CD](docs/04-pipelines-ci-cd.md)**All that you want to do is just fire up your IDE **->** open or import the parent folder `ecommerce-microservice-backend-app`, and everything will be ready for you.

  - Azure Pipelines configuración

  - GitHub Actions workflows## Data Model

  - Estrategia de branching### Entity-Relationship-Diagram

  - Versionado y releases![System Boundary](ecommerce-ERD.drawio.png)



- **[05 - Pruebas y Testing](docs/05-pruebas-testing.md)**## Playing With e-Commerce-boot Project

  - Pruebas unitarias e integración

  - Pruebas E2E con Postman### Cloning It

  - Infraestructura de pruebas de rendimiento

  - Resultados y métricasThe first thing to do is to open **git bash** command line, and then simply you can clone the project under any of your favorite places as the following:



- **[06 - Correcciones y Mejoras](docs/06-correcciones-mejoras.md)**```bash

  - Errores corregidos> git clone https://github.com/SelimHorri/ecommerce-microservice-backend-app.git

  - Mejoras implementadas```

  - Refactorización de código

  - Optimizaciones### Build & Test Them In Isolation



- **[07 - Scripts y Automatización](docs/07-scripts-automatizacion.md)**To build and run the test cases for each service & shared modules in the project, we need to do the following:

  - Scripts de construcción

  - Scripts de despliegue#### Build & Test µServices

  - Scripts de mantenimientoNow it is the time to build our **10 microservices** and run each service integration test in

  - Guía de uso isolation by running the following commands:



- **[08 - Release Notes](docs/08-release-notes.md)**```bash

  - Versión 0.0.3 (master - production)selim@:~/ecommerce-microservice-backend-app$ ./mvnw clean package 

  - Versión 0.0.1-pre-release (stage)```

  - Historial de versiones

  - Changelog detallado

- **[09 - Performance Testing](docs/09-performance-testing.md)**

  - Pruebas de rendimiento con Locust

  - Escenarios de carga

  - Análisis de resultadosAll build commands and test suite for each microservice should run successfully, and the final output should be like this:



## 🚀 Inicio Rápido```bash

---------------< com.selimhorri.app:ecommerce-microservice-backend >-----------

### Prerequisitos[INFO] ------------------------------------------------------------------------

[INFO] Reactor Summary for ecommerce-microservice-backend 0.1.0:

- **Java 11** JDK[INFO] 

- **Maven 3.6+**[INFO] ecommerce-microservice-backend ..................... SUCCESS [  0.548 s]

- **Docker** y Docker Compose[INFO] service-discovery .................................. SUCCESS [  3.126 s]

- **Kubernetes** (Minikube para local)[INFO] cloud-config ....................................... SUCCESS [  1.595 s]

- **kubectl** CLI[INFO] api-gateway ........................................ SUCCESS [  1.697 s]

- **Git**[INFO] proxy-client ....................................... SUCCESS [  3.632 s]

[INFO] user-service ....................................... SUCCESS [  2.546 s]

### Clonar el Repositorio[INFO] product-service .................................... SUCCESS [  2.214 s]

[INFO] favourite-service .................................. SUCCESS [  2.072 s]

```bash[INFO] order-service ...................................... SUCCESS [  2.241 s]

git clone https://github.com/davidone007/ecommerce-microservice-backend-app.git[INFO] shipping-service ................................... SUCCESS [  2.197 s]

cd ecommerce-microservice-backend-app[INFO] payment-service .................................... SUCCESS [  2.006 s]

```[INFO] ------------------------------------------------------------------------

[INFO] BUILD SUCCESS

### Opción 1: Ejecutar con Docker Compose[INFO] ------------------------------------------------------------------------

[INFO] Total time:  24.156 s

```bash[INFO] Finished at: 2021-12-29T19:52:57+01:00

# Compilar el proyecto[INFO] ------------------------------------------------------------------------

./mvnw clean package```



# Establecer la variable de entorno para el tag### Running Them All

export BRANCH_TAG=latestNow it's the time to run all of our Microservices, and it's straightforward just run the following `docker-compose` commands:



# Levantar todos los servicios```bash

docker-compose -f compose.yml up -dselim@:~/ecommerce-microservice-backend-app$ docker-compose -f compose.yml up

```

# Ver logs

docker-compose logs -fAll the **services**, **databases**, and **messaging service** will run in parallel in detach mode (option `-d`), and command output will print to the console the following:

```

```bash

### Opción 2: Desplegar en Kubernetes (Minikube)Creating network "ecommerce-microservice-backend-app_default" with the default driver

Creating ecommerce-microservice-backend-app_api-gateway-container_1       ... done

```bashCreating ecommerce-microservice-backend-app_favourite-service-container_1 ... done

# 1. Iniciar MinikubeCreating ecommerce-microservice-backend-app_service-discovery-container_1 ... done

./scripts/start-minikube.shCreating ecommerce-microservice-backend-app_shipping-service-container_1  ... done

Creating ecommerce-microservice-backend-app_order-service-container_1     ... done

# 2. Construir las imágenes DockerCreating ecommerce-microservice-backend-app_user-service-container_1      ... done

./scripts/build-images.shCreating ecommerce-microservice-backend-app_payment-service-container_1   ... done

Creating ecommerce-microservice-backend-app_product-service-container_1   ... done

# 3. Cargar imágenes en MinikubeCreating ecommerce-microservice-backend-app_proxy-client-container_1      ... done

./scripts/load-images-minikube.shCreating ecommerce-microservice-backend-app_zipkin-container_1            ... done

Creating ecommerce-microservice-backend-app_cloud-config-container_1      ... done

# 4. Desplegar en Kubernetes```

./scripts/deploy-k8s.sh latest### Access proxy-client APIs

You can manually test `proxy-client` APIs throughout its **Swagger** interface at the following

# 5. Verificar el despliegue URL [https://localhost:8900/swagger-ui.html](https://localhost:8900/swagger-ui.html).

kubectl get pods### Access Service Discovery Server (Eureka)

kubectl get svcIf you would like to access the Eureka service discovery point to this URL [http://localhosts:8761/eureka](https://localhost:8761/eureka) to see all the services registered inside it. 



# 6. Habilitar port-forwarding para acceder a los servicios### Access user-service APIs

./scripts/port-forward-all-services-nohup.sh URL [https://localhost:8700/swagger-ui.html](https://localhost:8700/swagger-ui.html).

```

<!--

### Acceder a los ServiciosNote that it is accessed through API Gateway and is secured. Therefore the browser will ask you for `username:mt` and `password:p,` write them to the dialog, and you will access it. This type of security is a **basic form security**.

-->

Una vez desplegado, puedes acceder a:The **API Gateway** and **Store Service** both act as a *resource server*. <!--To know more about calling Store API in a secure way you can check the `test-em-all.sh` script on how I have changed the calling of the services using **OAuth2** security.-->



- **Eureka Dashboard**: <http://localhost:8761>#### Check all **Spring Boot Actuator** exposed metrics http://localhost:8080/app/actuator/metrics:

- **API Gateway**: <http://localhost:8080>

- **Zipkin Tracing**: <http://localhost:9411>```bash

- **Swagger UI (Proxy Client)**: <http://localhost:8900/swagger-ui.html>{

    "names": [

## 🔧 Comandos Útiles        "http.server.requests",

        "jvm.buffer.count",

### Docker        "jvm.buffer.memory.used",

        "jvm.buffer.total.capacity",

```bash        "jvm.classes.loaded",

# Ver estado de contenedores        "jvm.classes.unloaded",

docker-compose ps        "jvm.gc.live.data.size",

        "jvm.gc.max.data.size",

# Ver logs de un servicio específico        "jvm.gc.memory.allocated",

docker-compose logs -f service-discovery-container        "jvm.gc.memory.promoted",

        "jvm.gc.pause",

# Detener todos los servicios        "jvm.memory.committed",

docker-compose down        "jvm.memory.max",

        "jvm.memory.used",

# Limpiar volúmenes y redes        "jvm.threads.daemon",

docker-compose down -v --remove-orphans        "jvm.threads.live",

```        "jvm.threads.peak",

        "jvm.threads.states",

### Kubernetes        "logback.events",

        "process.cpu.usage",

```bash        "process.files.max",

# Ver todos los pods        "process.files.open",

kubectl get pods -o wide        "process.start.time",

        "process.uptime",

# Ver logs de un pod        "resilience4j.circuitbreaker.buffered.calls",

kubectl logs -f <pod-name>        "resilience4j.circuitbreaker.calls",

        "resilience4j.circuitbreaker.failure.rate",

# Describir un pod        "resilience4j.circuitbreaker.not.permitted.calls",

kubectl describe pod <pod-name>        "resilience4j.circuitbreaker.slow.call.rate",

        "resilience4j.circuitbreaker.slow.calls",

# Reiniciar un deployment        "resilience4j.circuitbreaker.state",

kubectl rollout restart deployment/<deployment-name>        "system.cpu.count",

        "system.cpu.usage",

# Eliminar todos los recursos        "system.load.average.1m",

kubectl delete -f k8s/        "tomcat.sessions.active.current",

```        "tomcat.sessions.active.max",

        "tomcat.sessions.alive.max",

## 📊 Versionado y Releases        "tomcat.sessions.created",

        "tomcat.sessions.expired",

### Estrategia de Branching        "tomcat.sessions.rejected",

        "zipkin.reporter.messages",

- **`master`**: Producción (v0.0.3)        "zipkin.reporter.messages.dropped",

- **`stage`**: Pre-producción (v0.0.1-pre-release)        "zipkin.reporter.messages.total",

- **`dev`**: Desarrollo activo        "zipkin.reporter.queue.bytes",

        "zipkin.reporter.queue.spans",

### Versiones Actuales        "zipkin.reporter.spans",

        "zipkin.reporter.spans.dropped",

- **Producción (master)**: `v0.0.3` - Release estable        "zipkin.reporter.spans.total"

- **Stage**: `v0.0.1-pre-release` - Pre-release para testing    ]

}

Ver [Release Notes completas](docs/08-release-notes.md)```



## 📸 Capturas de Pantalla#### Prometheus exposed metrics at http://localhost:8080/app/actuator/prometheus



### Docker Compose - Servicios Levantados```bash

# HELP resilience4j_circuitbreaker_not_permitted_calls_total Total number of not permitted calls

![Docker Compose API Gateway](img/dockercompose-apigateway.png)# TYPE resilience4j_circuitbreaker_not_permitted_calls_total counter

![Docker Compose Microservices](img/dockercompose-microservices.png)resilience4j_circuitbreaker_not_permitted_calls_total{kind="not_permitted",name="proxyService",} 0.0

# HELP jvm_gc_live_data_size_bytes Size of long-lived heap memory pool after reclamation

### Kubernetes - Despliegue Exitoso# TYPE jvm_gc_live_data_size_bytes gauge

jvm_gc_live_data_size_bytes 3721880.0

![Kubectl Apply](img/kubectl-apply.png)# HELP jvm_gc_pause_seconds Time spent in GC pause

![Kubectl Get Pods](img/kubectl-get-pods.png)# TYPE jvm_gc_pause_seconds summary

jvm_gc_pause_seconds_count{action="end of minor GC",cause="Metadata GC Threshold",} 1.0

### Eureka Service Discoveryjvm_gc_pause_seconds_sum{action="end of minor GC",cause="Metadata GC Threshold",} 0.071

jvm_gc_pause_seconds_count{action="end of minor GC",cause="G1 Evacuation Pause",} 6.0

![Eureka Dashboard](img/eureka.png)jvm_gc_pause_seconds_sum{action="end of minor GC",cause="G1 Evacuation Pause",} 0.551

# HELP jvm_gc_pause_seconds_max Time spent in GC pause

### Zipkin Distributed Tracing# TYPE jvm_gc_pause_seconds_max gauge

jvm_gc_pause_seconds_max{action="end of minor GC",cause="Metadata GC Threshold",} 0.071

![Zipkin Dashboard](img/zipkinBueno.png)jvm_gc_pause_seconds_max{action="end of minor GC",cause="G1 Evacuation Pause",} 0.136

# HELP system_cpu_usage The "recent cpu usage" for the whole system

### CI/CD Pipelines# TYPE system_cpu_usage gauge

system_cpu_usage 0.4069206655413552

![GitHub Dev Pipeline](img/github-dev-passed-pipeline.png)# HELP jvm_buffer_total_capacity_bytes An estimate of the total capacity of the buffers in this pool

![GitHub Stage Pipeline](img/github-stage-passed-pipeline.png)# TYPE jvm_buffer_total_capacity_bytes gauge

![GitHub Master Pipeline](img/github-master-passed-pipeline.png)jvm_buffer_total_capacity_bytes{id="mapped",} 0.0

jvm_buffer_total_capacity_bytes{id="direct",} 24576.0

### GitHub Releases# HELP zipkin_reporter_spans_dropped_total Spans dropped (failed to report)

# TYPE zipkin_reporter_spans_dropped_total counter

![Pre-release Stage](img/prerelease-stage.png)zipkin_reporter_spans_dropped_total 4.0

![Release Master](img/release-master.png)# HELP zipkin_reporter_spans_bytes_total Total bytes of encoded spans reported

# TYPE zipkin_reporter_spans_bytes_total counter

## 🛠️ Tecnologías Utilizadaszipkin_reporter_spans_bytes_total 1681.0

# HELP tomcat_sessions_active_current_sessions  

### Backend & Framework# TYPE tomcat_sessions_active_current_sessions gauge

tomcat_sessions_active_current_sessions 0.0

- **Java 11**# HELP jvm_classes_loaded_classes The number of classes that are currently loaded in the Java virtual machine

- **Spring Boot 2.5.7**# TYPE jvm_classes_loaded_classes gauge

- **Spring Cloud 2020.0.4**jvm_classes_loaded_classes 13714.0

- **Spring Cloud Netflix Eureka**# HELP process_files_open_files The open file descriptor count

- **Spring Cloud Config**# TYPE process_files_open_files gauge

- **Spring Cloud Gateway**process_files_open_files 17.0

- **Resilience4j** (Circuit Breaker)# HELP resilience4j_circuitbreaker_slow_call_rate The slow call of the circuit breaker

# TYPE resilience4j_circuitbreaker_slow_call_rate gauge

### Bases de Datosresilience4j_circuitbreaker_slow_call_rate{name="proxyService",} -1.0

# HELP system_cpu_count The number of processors available to the Java virtual machine

- **H2** (In-memory para desarrollo)# TYPE system_cpu_count gauge

- **MySQL** (Persistencia)system_cpu_count 8.0

# HELP jvm_threads_daemon_threads The current number of live daemon threads

### Containerización y Orquestación# TYPE jvm_threads_daemon_threads gauge

jvm_threads_daemon_threads 21.0

- **Docker**# HELP zipkin_reporter_messages_total Messages reported (or attempted to be reported)

- **Docker Compose**# TYPE zipkin_reporter_messages_total counter

- **Kubernetes**zipkin_reporter_messages_total 2.0

- **Minikube**# HELP zipkin_reporter_messages_dropped_total  

# TYPE zipkin_reporter_messages_dropped_total counter

### CI/CDzipkin_reporter_messages_dropped_total{cause="ResourceAccessException",} 2.0

# HELP zipkin_reporter_messages_bytes_total Total bytes of messages reported

- **Azure Pipelines**# TYPE zipkin_reporter_messages_bytes_total counter

- **GitHub Actions**zipkin_reporter_messages_bytes_total 1368.0

- **Self-hosted Runner**# HELP http_server_requests_seconds  

# TYPE http_server_requests_seconds summary

### Monitoreo y Observabilidadhttp_server_requests_seconds_count{exception="None",method="GET",outcome="SUCCESS",status="200",uri="/actuator/metrics",} 1.0

http_server_requests_seconds_sum{exception="None",method="GET",outcome="SUCCESS",status="200",uri="/actuator/metrics",} 1.339804427

- **Zipkin** (Distributed Tracing)http_server_requests_seconds_count{exception="None",method="GET",outcome="SUCCESS",status="200",uri="/actuator/prometheus",} 1.0

- **Spring Boot Actuator**http_server_requests_seconds_sum{exception="None",method="GET",outcome="SUCCESS",status="200",uri="/actuator/prometheus",} 0.053689381

- **Prometheus** (Métricas)# HELP http_server_requests_seconds_max  

# TYPE http_server_requests_seconds_max gauge

### Testinghttp_server_requests_seconds_max{exception="None",method="GET",outcome="SUCCESS",status="200",uri="/actuator/metrics",} 1.339804427

http_server_requests_seconds_max{exception="None",method="GET",outcome="SUCCESS",status="200",uri="/actuator/prometheus",} 0.053689381

- **JUnit 5**# HELP resilience4j_circuitbreaker_slow_calls The number of slow successful which were slower than a certain threshold

- **Testcontainers**# TYPE resilience4j_circuitbreaker_slow_calls gauge

- **Postman** (E2E Testing)resilience4j_circuitbreaker_slow_calls{kind="successful",name="proxyService",} 0.0

- **Locust** (Performance Testing)resilience4j_circuitbreaker_slow_calls{kind="failed",name="proxyService",} 0.0

# HELP jvm_classes_unloaded_classes_total The total number of classes unloaded since the Java virtual machine has started execution

### Herramientas de Desarrollo# TYPE jvm_classes_unloaded_classes_total counter

jvm_classes_unloaded_classes_total 0.0

- **Maven**# HELP process_files_max_files The maximum file descriptor count

- **Git**# TYPE process_files_max_files gauge

- **Swagger/OpenAPI**process_files_max_files 1048576.0

- **Bash Scripting**# HELP resilience4j_circuitbreaker_calls_seconds Total number of successful calls

# TYPE resilience4j_circuitbreaker_calls_seconds summary

## 🤝 Contribuciónresilience4j_circuitbreaker_calls_seconds_count{kind="successful",name="proxyService",} 0.0

resilience4j_circuitbreaker_calls_seconds_sum{kind="successful",name="proxyService",} 0.0

Este proyecto fue desarrollado como parte de una práctica profesional enfocada en:resilience4j_circuitbreaker_calls_seconds_count{kind="failed",name="proxyService",} 0.0

resilience4j_circuitbreaker_calls_seconds_sum{kind="failed",name="proxyService",} 0.0

- Modernización de aplicaciones monolíticas/microserviciosresilience4j_circuitbreaker_calls_seconds_count{kind="ignored",name="proxyService",} 0.0

- Implementación de prácticas DevOpsresilience4j_circuitbreaker_calls_seconds_sum{kind="ignored",name="proxyService",} 0.0

- Automatización de despliegues# HELP resilience4j_circuitbreaker_calls_seconds_max Total number of successful calls

- Containerización de aplicaciones Java/Spring Boot# TYPE resilience4j_circuitbreaker_calls_seconds_max gauge

- Orquestación con Kubernetesresilience4j_circuitbreaker_calls_seconds_max{kind="successful",name="proxyService",} 0.0

- Implementación de pipelines CI/CDresilience4j_circuitbreaker_calls_seconds_max{kind="failed",name="proxyService",} 0.0

resilience4j_circuitbreaker_calls_seconds_max{kind="ignored",name="proxyService",} 0.0

## 📞 Contacto# HELP zipkin_reporter_spans_total Spans reported

# TYPE zipkin_reporter_spans_total counter

**David E. Fernández**zipkin_reporter_spans_total 5.0

# HELP zipkin_reporter_queue_bytes Total size of all encoded spans queued for reporting

- GitHub: [@davidone007](https://github.com/davidone007)# TYPE zipkin_reporter_queue_bytes gauge

- Repository: [ecommerce-microservice-backend-app](https://github.com/davidone007/ecommerce-microservice-backend-app)zipkin_reporter_queue_bytes 0.0

# HELP tomcat_sessions_expired_sessions_total  

## 📄 Licencia# TYPE tomcat_sessions_expired_sessions_total counter

tomcat_sessions_expired_sessions_total 0.0

Este proyecto es parte de un trabajo académico/profesional y está disponible para fines educativos y de demostración.# HELP tomcat_sessions_alive_max_seconds  

# TYPE tomcat_sessions_alive_max_seconds gauge

---tomcat_sessions_alive_max_seconds 0.0

# HELP process_uptime_seconds The uptime of the Java virtual machine

## 🎓 Aprendizajes Clave# TYPE process_uptime_seconds gauge

process_uptime_seconds 224.402

Este proyecto me permitió desarrollar y demostrar habilidades en:# HELP tomcat_sessions_active_max_sessions  

# TYPE tomcat_sessions_active_max_sessions gauge

✅ **Containerización** de aplicaciones empresariales complejas  tomcat_sessions_active_max_sessions 0.0

✅ **Orquestación** con Kubernetes en entorno local  # HELP process_cpu_usage The "recent cpu usage" for the Java Virtual Machine process

✅ **Pipelines CI/CD** con Azure DevOps y GitHub Actions  # TYPE process_cpu_usage gauge

✅ **Debugging** y resolución de problemas en arquitecturas distribuidas  process_cpu_usage 5.625879043600563E-4

✅ **Automatización** mediante scripting bash  # HELP jvm_gc_memory_promoted_bytes_total Count of positive increases in the size of the old generation memory pool before GC to after GC

✅ **Monitoreo** y observabilidad de microservicios  # TYPE jvm_gc_memory_promoted_bytes_total counter

✅ **Versionado semántico** y gestión de releases  jvm_gc_memory_promoted_bytes_total 1.7851088E7

✅ **Documentación técnica** completa y profesional  # HELP logback_events_total Number of error level events that made it to the logs

# TYPE logback_events_total counter

---logback_events_total{level="warn",} 5.0

logback_events_total{level="debug",} 79.0

**⭐ Si encuentras útil este proyecto, considera darle una estrella en GitHub!**logback_events_total{level="error",} 0.0

logback_events_total{level="trace",} 0.0
logback_events_total{level="info",} 60.0
# HELP tomcat_sessions_created_sessions_total  
# TYPE tomcat_sessions_created_sessions_total counter
tomcat_sessions_created_sessions_total 0.0
# HELP jvm_threads_live_threads The current number of live threads including both daemon and non-daemon threads
# TYPE jvm_threads_live_threads gauge
jvm_threads_live_threads 25.0
# HELP jvm_threads_states_threads The current number of threads having NEW state
# TYPE jvm_threads_states_threads gauge
jvm_threads_states_threads{state="runnable",} 6.0
jvm_threads_states_threads{state="blocked",} 0.0
jvm_threads_states_threads{state="waiting",} 8.0
jvm_threads_states_threads{state="timed-waiting",} 11.0
jvm_threads_states_threads{state="new",} 0.0
jvm_threads_states_threads{state="terminated",} 0.0
# HELP tomcat_sessions_rejected_sessions_total  
# TYPE tomcat_sessions_rejected_sessions_total counter
tomcat_sessions_rejected_sessions_total 0.0
# HELP process_start_time_seconds Start time of the process since unix epoch.
# TYPE process_start_time_seconds gauge
process_start_time_seconds 1.64088634006E9
# HELP resilience4j_circuitbreaker_buffered_calls The number of buffered failed calls stored in the ring buffer
# TYPE resilience4j_circuitbreaker_buffered_calls gauge
resilience4j_circuitbreaker_buffered_calls{kind="successful",name="proxyService",} 0.0
resilience4j_circuitbreaker_buffered_calls{kind="failed",name="proxyService",} 0.0
# HELP jvm_memory_max_bytes The maximum amount of memory in bytes that can be used for memory management
# TYPE jvm_memory_max_bytes gauge
jvm_memory_max_bytes{area="nonheap",id="CodeHeap 'profiled nmethods'",} 1.22908672E8
jvm_memory_max_bytes{area="heap",id="G1 Survivor Space",} -1.0
jvm_memory_max_bytes{area="heap",id="G1 Old Gen",} 5.182062592E9
jvm_memory_max_bytes{area="nonheap",id="Metaspace",} -1.0
jvm_memory_max_bytes{area="nonheap",id="CodeHeap 'non-nmethods'",} 5836800.0
jvm_memory_max_bytes{area="heap",id="G1 Eden Space",} -1.0
jvm_memory_max_bytes{area="nonheap",id="Compressed Class Space",} 1.073741824E9
jvm_memory_max_bytes{area="nonheap",id="CodeHeap 'non-profiled nmethods'",} 1.22912768E8
# HELP jvm_memory_committed_bytes The amount of memory in bytes that is committed for the Java virtual machine to use
# TYPE jvm_memory_committed_bytes gauge
jvm_memory_committed_bytes{area="nonheap",id="CodeHeap 'profiled nmethods'",} 1.6646144E7
jvm_memory_committed_bytes{area="heap",id="G1 Survivor Space",} 2.4117248E7
jvm_memory_committed_bytes{area="heap",id="G1 Old Gen",} 1.7301504E8
jvm_memory_committed_bytes{area="nonheap",id="Metaspace",} 7.6857344E7
jvm_memory_committed_bytes{area="nonheap",id="CodeHeap 'non-nmethods'",} 2555904.0
jvm_memory_committed_bytes{area="heap",id="G1 Eden Space",} 2.71581184E8
jvm_memory_committed_bytes{area="nonheap",id="Compressed Class Space",} 1.0354688E7
jvm_memory_committed_bytes{area="nonheap",id="CodeHeap 'non-profiled nmethods'",} 6619136.0
# HELP jvm_memory_used_bytes The amount of used memory
# TYPE jvm_memory_used_bytes gauge
jvm_memory_used_bytes{area="nonheap",id="CodeHeap 'profiled nmethods'",} 1.6585088E7
jvm_memory_used_bytes{area="heap",id="G1 Survivor Space",} 2.4117248E7
jvm_memory_used_bytes{area="heap",id="G1 Old Gen",} 2.0524392E7
jvm_memory_used_bytes{area="nonheap",id="Metaspace",} 7.4384552E7
jvm_memory_used_bytes{area="nonheap",id="CodeHeap 'non-nmethods'",} 1261696.0
jvm_memory_used_bytes{area="heap",id="G1 Eden Space",} 2.5165824E7
jvm_memory_used_bytes{area="nonheap",id="Compressed Class Space",} 9365664.0
jvm_memory_used_bytes{area="nonheap",id="CodeHeap 'non-profiled nmethods'",} 6604416.0
# HELP system_load_average_1m The sum of the number of runnable entities queued to available processors and the number of runnable entities running on the available processors averaged over a period of time
# TYPE system_load_average_1m gauge
system_load_average_1m 8.68
# HELP resilience4j_circuitbreaker_state The states of the circuit breaker
# TYPE resilience4j_circuitbreaker_state gauge
resilience4j_circuitbreaker_state{name="proxyService",state="forced_open",} 0.0
resilience4j_circuitbreaker_state{name="proxyService",state="closed",} 1.0
resilience4j_circuitbreaker_state{name="proxyService",state="disabled",} 0.0
resilience4j_circuitbreaker_state{name="proxyService",state="open",} 0.0
resilience4j_circuitbreaker_state{name="proxyService",state="half_open",} 0.0
resilience4j_circuitbreaker_state{name="proxyService",state="metrics_only",} 0.0
# HELP jvm_buffer_memory_used_bytes An estimate of the memory that the Java virtual machine is using for this buffer pool
# TYPE jvm_buffer_memory_used_bytes gauge
jvm_buffer_memory_used_bytes{id="mapped",} 0.0
jvm_buffer_memory_used_bytes{id="direct",} 24576.0
# HELP resilience4j_circuitbreaker_failure_rate The failure rate of the circuit breaker
# TYPE resilience4j_circuitbreaker_failure_rate gauge
resilience4j_circuitbreaker_failure_rate{name="proxyService",} -1.0
# HELP zipkin_reporter_queue_spans Spans queued for reporting
# TYPE zipkin_reporter_queue_spans gauge
zipkin_reporter_queue_spans 0.0
# HELP jvm_gc_memory_allocated_bytes_total Incremented for an increase in the size of the (young) heap memory pool after one GC to before the next
# TYPE jvm_gc_memory_allocated_bytes_total counter
jvm_gc_memory_allocated_bytes_total 1.402994688E9
# HELP jvm_buffer_count_buffers An estimate of the number of buffers in the pool
# TYPE jvm_buffer_count_buffers gauge
jvm_buffer_count_buffers{id="mapped",} 0.0
jvm_buffer_count_buffers{id="direct",} 3.0
# HELP jvm_threads_peak_threads The peak live thread count since the Java virtual machine started or peak was reset
# TYPE jvm_threads_peak_threads gauge
jvm_threads_peak_threads 25.0
# HELP jvm_gc_max_data_size_bytes Max size of long-lived heap memory pool
# TYPE jvm_gc_max_data_size_bytes gauge
jvm_gc_max_data_size_bytes 5.182062592E9
```

#### Check All Services Health
From ecommerce front Service proxy we can check all the core services health when you have all the
 microservices up and running using Docker Compose,
```bash
selim@:~/ecommerce-microservice-backend-app$ curl -k https://localhost:8443/actuator/health -s | jq .components."\"Core Microservices\""
```
This will result in the following response:
```json
{
    "status": "UP",
    "components": {
        "circuitBreakers": {
            "status": "UP",
            "details": {
                "proxyService": {
                    "status": "UP",
                    "details": {
                        "failureRate": "-1.0%",
                        "failureRateThreshold": "50.0%",
                        "slowCallRate": "-1.0%",
                        "slowCallRateThreshold": "100.0%",
                        "bufferedCalls": 0,
                        "slowCalls": 0,
                        "slowFailedCalls": 0,
                        "failedCalls": 0,
                        "notPermittedCalls": 0,
                        "state": "CLOSED"
                    }
                }
            }
        },
        "clientConfigServer": {
            "status": "UNKNOWN",
            "details": {
                "error": "no property sources located"
            }
        },
        "discoveryComposite": {
            "status": "UP",
            "components": {
                "discoveryClient": {
                    "status": "UP",
                    "details": {
                        "services": [
                            "proxy-client",
                            "api-gateway",
                            "cloud-config",
                            "product-service",
                            "user-service",
                            "favourite-service",
                            "order-service",
                            "payment-service",
                            "shipping-service"
                        ]
                    }
                },
                "eureka": {
                    "description": "Remote status from Eureka server",
                    "status": "UP",
                    "details": {
                        "applications": {
                            "FAVOURITE-SERVICE": 1,
                            "PROXY-CLIENT": 1,
                            "API-GATEWAY": 1,
                            "PAYMENT-SERVICE": 1,
                            "ORDER-SERVICE": 1,
                            "CLOUD-CONFIG": 1,
                            "PRODUCT-SERVICE": 1,
                            "SHIPPING-SERVICE": 1,
                            "USER-SERVICE": 1
                        }
                    }
                }
            }
        },
        "diskSpace": {
            "status": "UP",
            "details": {
                "total": 981889826816,
                "free": 325116776448,
                "threshold": 10485760,
                "exists": true
            }
        },
        "ping": {
            "status": "UP"
        },
        "refreshScope": {
            "status": "UP"
        }
    }
}
```
### Testing Them All
Now it's time to test all the application functionality as one part. To do so just run
 the following automation test script:

```bash
selim@:~/ecommerce-microservice-backend-app$ ./test-em-all.sh start
```
> You can use `stop` switch with `start`, that will 
>1. start docker, 
>2. run the tests, 
>3. stop the docker instances.

The result will look like this:

```bash
Starting 'ecommerce-microservice-backend-app' for [Blackbox] testing...

Start Tests: Tue, May 31, 2020 2:09:36 AM
HOST=localhost
PORT=8080
Restarting the test environment...
$ docker-compose -p -f compose.yml down --remove-orphans
$ docker-compose -p -f compose.yml up -d
Wait for: curl -k https://localhost:8080/actuator/health... , retry #1 , retry #2, {"status":"UP"} DONE, continues...
Test OK (HTTP Code: 200)
...
Test OK (actual value: 1)
Test OK (actual value: 3)
Test OK (actual value: 3)
Test OK (HTTP Code: 404, {"httpStatus":"NOT_FOUND","message":"No product found for productId: 13","path":"/app/api/products/20","time":"2020-04-12@12:34:25.144+0000"})
...
Test OK (actual value: 3)
Test OK (actual value: 0)
Test OK (HTTP Code: 422, {"httpStatus":"UNPROCESSABLE_ENTITY","message":"Invalid productId: -1","path":"/app/api/products/-1","time":"2020-04-12@12:34:26.243+0000"})
Test OK (actual value: "Invalid productId: -1")
Test OK (HTTP Code: 400, {"timestamp":"2020-04-12T12:34:26.471+00:00","path":"/app/api/products/invalidProductId","status":400,"error":"Bad Request","message":"Type mismatch.","requestId":"044dcdf2-13"})
Test OK (actual value: "Type mismatch.")
Test OK (HTTP Code: 401, )
Test OK (HTTP Code: 200)
Test OK (HTTP Code: 403, )
Start Circuit Breaker tests!
Test OK (actual value: CLOSED)
Test OK (HTTP Code: 500, {"timestamp":"2020-05-26T00:09:48.784+00:00","path":"/app/api/products/2","status":500,"error":"Internal Server Error","message":"Did not observe any item or terminal signal within 2000ms in 'onErrorResume' (and no fallback has been configured)","requestId":"4aa9f5e8-119"})
...
Test OK (actual value: Did not observe any item or terminal signal within 2000ms)
Test OK (HTTP Code: 200)
Test OK (actual value: Fallback product2)
Test OK (HTTP Code: 200)
Test OK (actual value: Fallback product2)
Test OK (HTTP Code: 404, {"httpStatus":"NOT_FOUND","message":"Product Id: 14 not found in fallback cache!","path":"/app/api/products/14","timestamp":"2020-05-26@00:09:53.998+0000"})
...
Test OK (actual value: product name C)
Test OK (actual value: CLOSED)
Test OK (actual value: CLOSED_TO_OPEN)
Test OK (actual value: OPEN_TO_HALF_OPEN)
Test OK (actual value: HALF_OPEN_TO_CLOSED)
End, all tests OK: Tue, May 31, 2020 2:10:09 AM
```
### Tracking the services with Zipkin
Now, you can now track Microservices interactions throughout Zipkin UI from the following link:
[http://localhost:9411/zipkin/](http://localhost:9411/zipkin/)
![Zipkin UI](zipkin-dash.png)

### Closing The Story

Finally, to close the story, we need to shut down Microservices manually service by service, hahaha just kidding, run the following command to shut them all:

```bash
selim@:~/ecommerce-microservice-backend-app$ docker-compose -f compose.yml down --remove-orphans
```
 And you should see output like the following:

```bash
Removing ecommerce-microservice-backend-app_payment-service-container_1   ... done
Removing ecommerce-microservice-backend-app_zipkin-container_1            ... done
Removing ecommerce-microservice-backend-app_service-discovery-container_1 ... done
Removing ecommerce-microservice-backend-app_product-service-container_1   ... done
Removing ecommerce-microservice-backend-app_cloud-config-container_1      ... done
Removing ecommerce-microservice-backend-app_proxy-client-container_1      ... done
Removing ecommerce-microservice-backend-app_order-service-container_1     ... done
Removing ecommerce-microservice-backend-app_user-service-container_1      ... done
Removing ecommerce-microservice-backend-app_shipping-service-container_1  ... done
Removing ecommerce-microservice-backend-app_api-gateway-container_1       ... done
Removing ecommerce-microservice-backend-app_favourite-service-container_1 ... done
Removing network ecommerce-microservice-backend-app_default
```
### The End
In the end, I hope you enjoyed the application and find it useful, as I did when I was developing it. 
If you would like to enhance, please: 
- **Open PRs**, 
- Give **feedback**, 
- Add **new suggestions**, and
- Finally, give it a 🌟.

*Happy Coding ...* 🙂
