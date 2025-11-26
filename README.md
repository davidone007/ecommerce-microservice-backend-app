# 📘 Proyecto Final de Ingeniería de Software - E-Commerce Microservices


## 👥 Autores

- [![GitHub - Davide](https://img.shields.io/badge/Davide%20Flamini%20Cazaran-181717?logo=github&style=for-the-badge)](https://github.com/davidone007)
- [![GitHub - Andrés](https://img.shields.io/badge/Andrés%20Cabezas%20Guerrero-181717?logo=github&style=for-the-badge)](https://github.com/andrescabezas26)


Bienvenido a la documentación oficial del proyecto final de Ingeniería de Software. Este repositorio contiene la implementación completa de una arquitectura de microservicios para un sistema de E-Commerce, desplegada en Azure utilizando prácticas modernas de DevOps, Infraestructura como Código (IaC) y Observabilidad.

## 🚀 Introducción

Este proyecto demuestra la implementación de un ciclo de vida de desarrollo de software completo (SDLC) utilizando metodologías ágiles, integración y despliegue continuo (CI/CD), y una arquitectura robusta basada en microservicios. El objetivo principal fue migrar una aplicación monolítica o construir desde cero una solución escalable, resiliente y segura.

## 🏗️ Arquitectura General

El sistema está compuesto por múltiples microservicios (Product, Order, User, Payment, Shipping) que se comunican entre sí, orquestados por Kubernetes en Azure (AKS). Utilizamos un API Gateway para la gestión del tráfico y Eureka para el descubrimiento de servicios.

### Diagrama de Arquitectura (Propuesta Inicial)

A continuación se presenta el diagrama conceptual inicial de la arquitectura propuesta:

```mermaid
graph TD
    User((Usuario)) -->|HTTPS| CDN[Azure CDN]
    CDN -->|Traffic| AG[API Gateway / Load Balancer]
    
    subgraph AKS[Azure Kubernetes Service AKS]
        AG -->|Route| Auth[Auth Service]
        AG -->|Route| Prod[Product Service]
        AG -->|Route| Order[Order Service]
        AG -->|Route| Pay[Payment Service]
        
        Prod <--> DB1[(SQL Database)]
        Order <--> DB2[(SQL Database)]
        Pay <--> DB3[(SQL Database)]
        
        Order -->|Event| Broker[Message Broker RabbitMQ/Kafka]
        Broker -->|Consume| Ship[Shipping Service]
    end
    
    subgraph Observability
        Prom[Prometheus] -->|Scrape| Auth
        Prom -->|Scrape| Prod
        Prom -->|Scrape| Order
        Graf[Grafana] -->|Visualize| Prom
        ELK[ELK Stack] -->|Logs| Auth
        ELK -->|Logs| Prod
        ELK -->|Logs| Order
    end
    
    subgraph CICD[CI/CD Pipeline]
        Git[GitHub] -->|Push| Actions[GitHub Actions]
        Actions -->|Deploy| AG
        Actions -->|IaC| TF[Terraform]
        TF -->|Provision| Azure[Azure Resources]
    end
    
    style User fill:#e1f5ff
    style CDN fill:#4CAF50
    style AG fill:#FF9800
    style AKS fill:#f5f5f5
    style Observability fill:#fff3e0
    style CICD fill:#e8f5e9
```

### Diagrama de Arquitectura Implementada

![Arquitectura General](img/arch-diagram-prod.drawio.png)

## 📚 Índice de Documentación

La documentación detallada del proyecto se encuentra dividida en los siguientes módulos:

1.  [**Metodología y Estrategia de Branching**](./docs/01-metodologia-branching.md)
    *   Detalles sobre Kanban, Historias de Usuario y Gitflow.
2.  [**Infraestructura como Código (Terraform)**](./docs/02-infraestructura-terraform.md)
    *   Modularización, multi-ambiente y gestión de estado en Azure.
3.  [**Patrones de Diseño**](./docs/03-patrones-de-diseno.md)
    *   Circuit Breaker, Config Server, API Gateway y más.
4.  [**CI/CD Avanzado**](./docs/04-cicd-avanzado.md)
    *   Pipelines de GitHub Actions, SonarQube, Trivy y despliegues.
5.  [**Estrategia de Pruebas**](./docs/05-pruebas.md)
    *   Unitarias, Integración, E2E, Performance y Seguridad.
6.  [**Gestión de Cambios y Releases**](./docs/06-change-management-releases.md)
    *   Versionamiento semántico y notas de lanzamiento.
7.  [**Observabilidad y Monitoreo**](./docs/07-observabilidad.md)
    *   Prometheus, Grafana, ELK y Tracing distribuido.
8.  [**Seguridad**](./docs/08-seguridad.md)
    *   Análisis de vulnerabilidades, gestión de secretos y RBAC.
9.  [**Costos y Operaciones**](./docs/09-costos-operaciones.md)
    *   Estimación de costos en Azure y manual operativo.

## 🖼️ Galería del Proyecto

### Tablero Kanban
![Kanban Board](img/kanban-board.png)

### Pipelines de CI/CD
![Pipelines](img/github-master-passed-pipeline.png)

### Monitoreo en Grafana
![Grafana Dashboard](img/zipkinBueno.png)

---
*Proyecto Final de Ingeniería de Software - 2025*
