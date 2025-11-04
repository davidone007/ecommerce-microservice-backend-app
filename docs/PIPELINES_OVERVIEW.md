# CI/CD Pipelines Overview

## Dev Pipeline vs Stage Pipeline

### 🔵 DEV Pipeline (ci-dev.yml)
**Trigger**: Push a `dev`, `feat/*`, `ops/feat/*`

```
┌─────────────────────────────────────────────────────┐
│ Maven Build (self-hosted)                           │
│ ├─ Checkout                                         │
│ ├─ Unit Tests (*ServiceImplTest)                    │
│ ├─ SonarQube Analysis                               │
│ └─ Upload Artifacts                                 │
└─────────────────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────┐
│ Docker Build per Service (ubuntu-latest)            │
│ ├─ Build image                                      │
│ └─ Push to GHCR (tag: dev, sha)                     │
└─────────────────────────────────────────────────────┘

⏱️  Duration: ~10-15 min
🎯 Purpose: Fast feedback, code quality
```

---

### 🟢 STAGE Pipeline (ci-stage.yml)
**Trigger**: Push a `stage` o PR a `stage`

```
┌─────────────────────────────────────────────────────────────┐
│ Maven Build (self-hosted)                                   │
│ ├─ Checkout                                                 │
│ ├─ Unit Tests (*ServiceImplTest)                            │
│ ├─ Integration Tests (*IntegrationTest)                     │
│ ├─ SonarQube Analysis                                       │
│ └─ Upload Artifacts & Reports                              │
└─────────────────────────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│ Docker Build per Service (ubuntu-latest)                    │
│ ├─ Build image                                              │
│ └─ Push to GHCR (tag: stage, sha)                           │
└─────────────────────────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│ Kubernetes Deploy (self-hosted)                             │
│ ├─ kubectl apply -f k8s/*-deployment.yaml                   │
│ ├─ kubectl apply -f k8s/*-service.yaml                      │
│ ├─ Wait for all deployments ready (5min timeout)            │
│ └─ Verify pods & services status                            │
└─────────────────────────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│ Integration Tests (self-hosted)                             │
│ ├─ Wait for API Gateway ready (http://localhost:8080)       │
│ ├─ Run *IntegrationTest against live services               │
│ └─ Upload Test Reports                                      │
└─────────────────────────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│ E2E Tests (self-hosted)                                     │
│ ├─ Install Newman (Postman CLI)                             │
│ ├─ Run Postman Collection (E2E scenarios)                   │
│ │  ├─ E2E-00: Setup Authentication                         │
│ │  ├─ E2E-01: User Registration & Management               │
│ │  ├─ E2E-02: Complete Purchase Flow                       │
│ │  ├─ E2E-03: Product & Stock Management                   │
│ │  ├─ E2E-04: Shipping Flow                                │
│ │  ├─ E2E-05: Favorites Management                         │
│ │  └─ E2E-99: Cleanup                                      │
│ └─ Generate HTML & JSON Reports                            │
└─────────────────────────────────────────────────────────────┘

⏱️  Duration: ~30-45 min
🎯 Purpose: Full integration & end-to-end validation
📋 Artifacts: Test reports, E2E HTML report
```

---

## Test Patterns

| Pattern | File Location | Pipeline |
|---------|---------------|----------|
| Unit Tests | `**/src/test/java/**/*ServiceImplTest.java` | dev, stage |
| Integration Tests | `**/src/test/java/**/integration/*IntegrationTest.java` | stage only |
| E2E Tests | Postman Collection | stage only |

---

## Deployment Flow

```
Stage Branch
    │
    ├─→ Docker images built (tag: stage)
    │
    ├─→ Push to GHCR
    │
    ├─→ kubectl apply manifests
    │   ├─ api-gateway-container
    │   ├─ cloud-config-container
    │   ├─ favourite-service-container
    │   ├─ order-service-container
    │   ├─ payment-service-container
    │   ├─ product-service-container
    │   ├─ proxy-client-container
    │   ├─ service-discovery-container
    │   ├─ shipping-service-container
    │   ├─ user-service-container
    │   └─ zipkin-container
    │
    ├─→ Wait for rollout
    │
    ├─→ Integration tests run
    │
    └─→ E2E tests run
```

---

## Environment & Configuration

### Dev
- **Runner**: self-hosted (macOS)
- **K8s**: None
- **Tests**: Unit only
- **Deployment**: Docker images only
- **SonarQube**: Optional

### Stage
- **Runner**: self-hosted (macOS with kubectl)
- **K8s**: Yes (Local cluster or cloud)
- **Tests**: Unit + Integration + E2E
- **Deployment**: Full Kubernetes deployment
- **SonarQube**: Optional

---

## Required Secrets (GitHub)

```yaml
SONAR_HOST_URL: http://localhost:9000    # Optional
SONAR_TOKEN: your-sonar-token            # Optional
GITHUB_TOKEN: (auto-provided)
```

---

## Local Testing Command Reference

### Run Dev Pipeline Locally
```bash
chmod +x ./mvnw
./mvnw -B -T 1C verify -Dtest="*ServiceImplTest" -DfailIfNoTests=false
```

### Run Stage Pipeline Locally
```bash
# 1. Build + Tests
chmod +x ./mvnw
./mvnw -B -T 1C verify -Dtest="*ServiceImplTest,*IntegrationTest" -DfailIfNoTests=false

# 2. Build Docker images
docker-compose -f compose.yml build

# 3. Deploy to K8s
kubectl apply -f k8s/

# 4. Wait for deployment
kubectl rollout status deployment/api-gateway-container --timeout=5m

# 5. Run E2E tests
npm install -g newman
newman run "postman-collections/E2E Ecommerce Microservices Tests.postman_collection.json" \
  --environment "postman-collections/local-stage.postman_environment.json"
```

---

## Monitoring & Debugging

### Check Pipeline Status
- GitHub → Actions → Select workflow → View run

### Download Artifacts
- Test reports
- E2E HTML report
- Workspace (for inspection)

### Check K8s Deployment
```bash
kubectl get deployments
kubectl get pods
kubectl get services
kubectl logs deployment/api-gateway-container
```

### Postman Collection Variables
Defined in `postman-collections/local-stage.postman_environment.json`
- Auto-populated during test execution
- Shared across test requests
