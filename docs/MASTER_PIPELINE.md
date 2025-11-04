# CI/CD Pipeline Master - Documentación Completa

## 📋 Descripción General

Este pipeline de **producción (master)** automatiza el proceso completo de despliegue desde la construcción hasta la validación en producción, incluyendo:

- ✅ Compilación y pruebas unitarias
- ✅ Análisis de calidad de código (SonarQube)
- ✅ Construcción de imágenes Docker
- ✅ Generación automática de Release Notes
- ✅ Despliegue en Kubernetes
- ✅ Pruebas de sistema
- ✅ Pruebas de humo (Smoke Tests)
- ✅ Reportes y verificación

## 🏗️ Arquitectura del Pipeline

```
┌─────────────────────┐
│   maven-build       │  (Unit Tests + SonarQube)
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   docker-build      │  (Build 10 services)
└──────────┬──────────┘
           │
    ┌──────┴──────┐
    ▼             ▼
┌─────────┐  ┌──────────────────┐
│ K8s Deploy │  │ Generate Release │
└─────────┘  └──────────────────┘
    │             │
    └──────┬──────┘
           ▼
    ┌────────────────┐
    │ system-tests   │  (Validación de sistema)
    └────────┬───────┘
             ▼
    ┌────────────────┐
    │  smoke-tests   │  (Health Checks)
    └────────┬───────┘
             ▼
    ┌────────────────────────┐
    │ post-deployment        │  (Verificación final)
    └────────────────────────┘
```

## 📝 Trabajos (Jobs)

### 1. **maven-build** ⚙️
**Ejecuta en:** `self-hosted`

Responsabilidades:
- Checkout del código
- Setup de JDK 11
- Build con Maven (compilación + pruebas unitarias)
- Verificación de SonarQube
- Análisis de calidad de código
- Upload de artefactos

**Patterns de tests:**
- `*ServiceImplTest` - Pruebas unitarias

### 2. **docker-build** 🐳
**Ejecuta en:** `ubuntu-latest` (runners paralelos)

Responsabilidades:
- Construcción de imágenes Docker para 10 servicios
- Push a GitHub Container Registry (GHCR)
- Tagging con semver automático
- Fallback a build local si falla GHCR

**Servicios construidos:**
- api-gateway
- cloud-config
- favourite-service
- order-service
- payment-service
- product-service
- proxy-client
- service-discovery
- shipping-service
- user-service

**Tags generados:**
- `v<major>.<minor>.<patch>` (Semantic Versioning)
- `latest` (tag principal en production)

### 3. **generate-release-notes** 📝
**Ejecuta en:** `ubuntu-latest`

Responsabilidades:
- Obtener versión anterior desde tags de git
- Calcular nueva versión automáticamente
- Generar changelog desde commits
- Crear GitHub Release automáticamente
- Documentar cambios y artifacts

**Salidas:**
- `release_version` - Versión nueva (ej: 1.2.3)
- `changelog` - Lista de commits

**Release Notes incluye:**
- 📝 Changelog completo
- 📦 Información del build
- 🔗 Links a las imágenes Docker
- ✅ Quality gates que pasaron

### 4. **kubernetes-deploy** 🚀
**Ejecuta en:** `self-hosted`

Responsabilidades:
- Verificar configuración de kubectl
- Ejecutar script de despliegue (`deploy-k8s.sh`)
- Reemplazar tag `latest` en manifiestos
- Aplicar configuraciones a Kubernetes
- Esperar rollout de todos los deployments

**Tag usado:** `latest`

**Servicios desplegados:** 11 (incluye cloud-config)

### 5. **system-tests** 🧪
**Ejecuta en:** `self-hosted`

Responsabilidades:
- Esperar a que todos los servicios estén listos
- Ejecutar pruebas de sistema (`*SystemTest`)
- Recolectar reportes de pruebas
- Fallar si hay errores

**Endpoints validados:**
- `http://localhost:8080/app/api/products`
- `http://localhost:8600/shipping-service/api/shippings`
- `http://localhost:8700/user-service/api/users`
- `http://localhost:8500/product-service/api/products`
- `http://localhost:8800/favourite-service/api/favourites`
- `http://localhost:8400/payment-service/api/payments`

**Timeout:** 5 minutos por servicio

### 6. **smoke-tests** 🔥
**Ejecuta en:** `self-hosted`

Responsabilidades:
- Validar endpoints principales con curl
- Realizar health checks de cada servicio
- Generar reporte de pruebas de humo
- Verificar que todas las rutas funcionan

**Tests incluidos:**
1. ✅ API Gateway - Products
2. ✅ Product Service - Products
3. ✅ User Service - Users
4. ✅ Order Service - Orders
5. ✅ Payment Service - Payments
6. ✅ Shipping Service - Shippings
7. ✅ Favourite Service - Favourites

**Salida:** Log detallado con PASS/FAIL por endpoint

### 7. **post-deployment** 📊
**Ejecuta en:** `self-hosted`

Responsabilidades:
- Generar reporte final
- Mostrar estado de deployments
- Mostrar estado de pods
- Verificación post-despliegue

## 🔄 Flujo de Ejecución

### Cuando alguien hace push a `master`:

1. **GitHub dispara el workflow**
2. **maven-build** se ejecuta:
   - Compila el código
   - Ejecuta pruebas unitarias
   - Analiza con SonarQube
   - Sube artefactos

3. **docker-build** inicia después (10 servicios en paralelo):
   - Descarga workspace compilado
   - Construye imágenes Docker
   - Sube a GHCR con tags semver

4. **generate-release-notes** y **kubernetes-deploy** en paralelo:
   - Genera Release automáticamente en GitHub
   - Despliega a Kubernetes con tag `latest`

5. **system-tests** valida:
   - Que los servicios estén listos
   - Ejecuta pruebas de sistema
   - Fallar si algo sale mal

6. **smoke-tests** verifica:
   - 7 endpoints críticos
   - Genera reporte de humo
   - Confirma que todo funciona

7. **post-deployment** muestra:
   - Estado final de deployments
   - Resumen de pods

## 📊 Permisos Requeridos

```yaml
permissions:
  contents: write          # Para crear releases
  packages: write          # Para push a GHCR
  id-token: write          # Para seguridad mejorada
```

## 🔐 Secretos Necesarios

- `SONAR_HOST_URL` - URL de SonarQube
- `SONAR_TOKEN` - Token de SonarQube
- `GITHUB_TOKEN` - Token automático de GitHub (o `GHCR_TOKEN` para mejor control)

## 📈 Versionado Semántico

El pipeline genera versiones automáticamente:

```
Versión actual: v1.2.3
Último commit: feature X
Siguiente versión: v1.2.4 (patch increment)

Tag en Git: v1.2.4
Docker Images: ghcr.io/owner/service:v1.2.4
Release en GitHub: Release v1.2.4
```

## 📝 Changelog Automático

El changelog se genera desde los commits entre la versión anterior y la actual:

```
Commits entre v1.2.3 y v1.2.4:
- a1b2c3d: Fix bug en OrderService (Juan)
- d4e5f6g: Add new endpoint (María)
- h7i8j9k: Refactor ProductService (Pedro)
```

## 🧪 Cambios vs. Stage Pipeline

| Aspecto | Stage | Master |
|---------|-------|--------|
| Rama | `stage` | `master` |
| Tag Docker | `stage` + SHA | `semver` + `latest` |
| Release Notes | ❌ No | ✅ Sí |
| Tests | IntegrationTest | SystemTest + SmokeTest |
| K8s | staging | production |
| Permisos | read/write packages | write contents + packages |
| Smoke Tests | ❌ No | ✅ 7 endpoints |
| Versiones | Constante | Automática |

## 🚀 Próximos Pasos

1. **Configurar Personal Access Token (PAT)** para GHCR:
   - Ir a https://github.com/settings/tokens
   - Crear token con permisos `write:packages`
   - Agregar como secreto `GHCR_TOKEN`

2. **Verificar que la rama `master` está protegida**:
   - Solo puede ser actualizada por PRs
   - Requiere aprovaciones
   - Todos los checks deben pasar

3. **Configurar notificaciones**:
   - Slack webhook para releases
   - Email para fallos

4. **Documentar en README**:
   - Cómo hacer releases
   - Proceso de Change Management
   - Links a Release Notes

## 📚 Referencias

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Semantic Versioning](https://semver.org/)
- [Kubernetes Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
