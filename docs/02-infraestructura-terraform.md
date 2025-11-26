# 02. Infraestructura como Código (Terraform)

La infraestructura del proyecto ha sido aprovisionada y gestionada en su totalidad utilizando **Terraform**, siguiendo las mejores prácticas de **Infraestructura como Código (IaC)**.

## 🏗️ Arquitectura de Infraestructura

La infraestructura se despliega en **Microsoft Azure** y está diseñada para soportar una arquitectura de microservicios escalable.

### Características Principales

*   **Infraestructura Modular:** El código de Terraform se ha dividido en módulos reutilizables (ej. `aks`, `keyvault`, `monitoring`) para facilitar el mantenimiento.
*   **Multi-ambiente:** Soportamos dos entornos principales gestionados por Terraform:
    *   **Stage:** Entorno de pruebas pre-producción.
    *   **Prod:** Entorno de producción.
*   **Backend Remoto:** El estado de Terraform (`terraform.tfstate`) se almacena de forma segura en un Azure Storage Account.

### Dimensionamiento de Clusters (AKS)

Ambos entornos han sido dimensionados para equilibrar costo y rendimiento durante esta fase del proyecto:

| Entorno | Nodos | SKU VM | vCPU | RAM |
| :--- | :--- | :--- | :--- | :--- |
| **Stage** | 2 | Standard_E2_v3 | 2 | 16 GB |
| **Prod** | 2 | Standard_E2_v3 | 2 | 16 GB |

### Reglas de Protección

Para garantizar la estabilidad, implementamos reglas de protección en GitHub y en los entornos de despliegue:

```text
stage-infra → 1 protection rule  
production_infra → 1 protection rule  
dev  
stage → 2 protection rules  
production → 1 protection rule  
```

## 🗺️ Diagrama de Infraestructura (Propuesta)

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

## 📸 Evidencia de Infraestructura

### Ejecución de Terraform
![Terraform Apply](../img/kubectl-apply.png)

### Recursos en Azure (Entornos)
![Environments](../img/environments.png)
