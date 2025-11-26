# 09. Costos y Operaciones

Este documento presenta una estimación de costos para la infraestructura en Azure y un manual básico de operaciones para el mantenimiento del sistema.

## 💰 Estimación de Costos (Mensual)

La infraestructura está optimizada para equilibrar rendimiento y costo. A continuación, una estimación detallada por ambiente basada en los recursos aprovisionados en Terraform.

### 1. Costos Totales Consolidados

| Recurso | SKU / Tier | Cantidad Total | Costo Aprox. (USD) |
| :--- | :--- | :--- | :--- |
| **Azure Kubernetes Service (AKS)** | Standard_E2_v3 (2 vCPU, 16GB RAM) | 4 Nodos | ~$240.00 |
| **Azure Key Vault** | Standard | 2 | ~$0.06 |
| **Azure Container Registry** | Basic | 1 | ~$5.00 |
| **Storage Accounts** | LRS Hot | 2 | ~$2.00 |
| **Load Balancer** | Standard | 1 | ~$18.00 |
| **Total Estimado** | | | **~$265.00 / mes** |

---

### 2. Desglose por Ambiente

#### 🟢 Producción (Prod)
Entorno crítico con alta disponibilidad y monitoreo completo.

| Recurso | Detalle | Costo Aprox. |
| :--- | :--- | :--- |
| **AKS Cluster** | 2 Nodos (Standard_E2_v3) | ~$120.00 |
| **Key Vault** | `ecommerce-kv-prod` | ~$0.03 |
| **Storage Account** | Terraform State (Prod) | ~$1.00 |
| **Monitoreo** | Prometheus + Grafana (Recursos en cluster) | Incluido en Nodos |
| **Load Balancer** | Ingress Controller IP | ~$9.00 |
| **Subtotal Prod** | | **~$130.03** |

#### 🟡 Staging (Stage)
Entorno de pruebas idéntico a producción pero sin monitoreo persistente para ahorro.

| Recurso | Detalle | Costo Aprox. |
| :--- | :--- | :--- |
| **AKS Cluster** | 2 Nodos (Standard_E2_v3) | ~$120.00 |
| **Key Vault** | `ecommerce-kv-stage` | ~$0.03 |
| **Storage Account** | Terraform State (Stage) | ~$1.00 |
| **Monitoreo** | No desplegado | $0.00 |
| **Load Balancer** | Ingress Controller IP | ~$9.00 |
| **Subtotal Stage** | | **~$130.03** |

#### 🔵 Recursos Compartidos (Global)
Recursos utilizados por ambos entornos.

| Recurso | Detalle | Costo Aprox. |
| :--- | :--- | :--- |
| **Azure Container Registry** | Basic (Almacenamiento de imágenes) | ~$5.00 |
| **Subtotal Global** | | **~$5.00** |

> **Nota:** Los costos pueden variar según el tráfico y el uso de almacenamiento. No se incluyen costos de bases de datos gestionadas (Azure SQL) ya que actualmente no están aprovisionadas en Terraform; los servicios utilizan bases de datos en contenedores o en memoria para esta fase.

## 🛠️ Manual de Operaciones

### Recursos por Ambiente

*   **Stage:**
    *   **Cluster:** 2 Nodos (Standard_E2_v3).
    *   **Monitoreo:** No desplegado (para ahorro de recursos).
*   **Prod:**
    *   **Cluster:** 2 Nodos (Standard_E2_v3).
    *   **Monitoreo:** Stack completo de Prometheus y Grafana activo.

### Buenas Prácticas Operativas

1.  **Monitoreo Diario:** Revisar el dashboard de Grafana (solo en Prod) al inicio del día para verificar anomalías nocturnas.
2.  **Backups:** Verificar periódicamente que los volúmenes persistentes se estén respaldando correctamente.
3.  **Actualizaciones:** Aplicar parches de seguridad a las imágenes Docker y actualizar la versión de Kubernetes trimestralmente.
4.  **Limpieza:** Ejecutar scripts de limpieza de imágenes antiguas en ACR para no exceder la cuota.

### Procedimientos Comunes

#### Reiniciar un Microservicio
Si un servicio se queda pegado y el Liveness Probe no lo reinicia:
```bash
kubectl rollout restart deployment/product-service -n prod
```

#### Ver Logs en Tiempo Real
```bash
kubectl logs -f deployment/order-service -n prod
```

#### Escalar un Servicio Manualmente
Ante un pico de tráfico inesperado:
```bash
kubectl scale deployment/payment-service --replicas=5 -n prod
```

## 📉 Optimización de Costos

*   **Spot Instances:** Considerar su uso en el entorno de Stage para reducir costos de cómputo hasta en un 90%.
*   **Auto-scaling:** Configurar Horizontal Pod Autoscaler (HPA) y Cluster Autoscaler para ajustar recursos a la demanda real.
*   **Apagado Programado:** Apagar el cluster de Stage durante fines de semana si no se realizan pruebas.
