# Pipeline Stage - Flujo Actualizado

## 🔄 Orden de Ejecución

```
┌─────────────────────────────────────────────────────────────┐
│ 1️⃣  Maven Build (self-hosted)                              │
│    • Solo pruebas unitarias: *ServiceImplTest               │
│    • NO ejecuta pruebas de integración (infra aún no lista) │
│    • SonarQube Analysis                                     │
│    • Genera workspace como artifact                         │
└─────────────────────────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│ 2️⃣  Docker Build (ubuntu-latest)                           │
│    • Descarga workspace                                     │
│    • Build imágenes Docker por servicio                     │
│    • Tags: ${SHA_CORTO} + "stage"                           │
│    • Push a GHCR                                            │
│    • Output: SHA corto para deploy                          │
└─────────────────────────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│ 3️⃣  Kubernetes Deploy (self-hosted)                        │
│    • Checkout (obtiene deploy-k8s.sh)                       │
│    • Ejecuta: ./scripts/deploy-k8s.sh ${SHA_CORTO}          │
│    • El script:                                             │
│      ├─ Reemplaza ${BRANCH_TAG} en YAML → SHA corto         │
│      ├─ Agrega imagePullPolicy: IfNotPresent                │
│      ├─ kubectl apply -f k8s/                               │
│      └─ Espera rollout de todos los deployments             │
│    • Valida status: kubectl get pods                        │
│    • ✅ Infra LISTA para tests                              │
└─────────────────────────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│ 4️⃣  Integration Tests (self-hosted)                        │
│    • Espera API Gateway ready: http://localhost:8080        │
│    • Ejecuta: *IntegrationTest contra servicios activos     │
│    • Las pruebas usan BD real, caché real, servicios reales │
│    • Genera reportes XML                                    │
│    • Valida resultados: total tests, failures               │
└─────────────────────────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│ 5️⃣  E2E Tests (self-hosted)                                │
│    • Install Newman (Postman CLI)                           │
│    • Ejecuta colección E2E completa                         │
│    • Setup → User → Purchase → Products → Shipping → FAQs   │
│    • Cleanup de datos                                       │
│    • Reportes: HTML + JSON                                  │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔑 Cambios Principales

### ✅ Maven Build
- **Antes**: Unit tests + Integration tests
- **Ahora**: Solo unit tests (`*ServiceImplTest`)
- **Por qué**: Los integration tests necesitan la infra (BD, servicios) arriba

### ✅ Kubernetes Deploy
- **Antes**: `kubectl apply` directo en el workflow
- **Ahora**: Usa `./scripts/deploy-k8s.sh ${SHA_CORTO}`
- **Ventajas**:
  - ✓ Reemplaza `${BRANCH_TAG}` en YAML con el SHA corto
  - ✓ Agrega `imagePullPolicy: IfNotPresent` automáticamente
  - ✓ Manejo de errores y confirmación interactiva
  - ✓ Pretty-prints de imágenes a desplegar
  - ✓ Scripts centralizado = una sola fuente de verdad

### ✅ Integration Tests
- **Ahora**: Ejecuta DESPUÉS de que K8s esté listo
- **Variables de entorno**: Conecta a http://localhost:8080
- **Contra infra real**: BD, caché, servicios desplegados
- **Reportes mejorados**: Resumen de éxito/falla

---

## 📊 Variables de Imagen

El script `deploy-k8s.sh` maneja el tag así:

```bash
# En el workflow:
BRANCH_TAG=$(git rev-parse --short HEAD)  # ej: "a1b2c3d"

# Paso deploy-k8s.sh:
./scripts/deploy-k8s.sh "a1b2c3d"

# El script reemplaza en YAML:
# ${BRANCH_TAG} → a1b2c3d

# Resultado en K8s:
image: ghcr.io/davidone007/api-gateway:a1b2c3d
imagePullPolicy: IfNotPresent
```

---

## 🚀 Ejecución Local

Para simular el pipeline completo localmente:

```bash
# 1. Build (unit tests solo)
chmod +x ./mvnw
./mvnw -B verify -Dtest="*ServiceImplTest" -DfailIfNoTests=false

# 2. Build Docker (requiere imágenes construidas previamente)
# O construir manualmente:
docker-compose -f compose.yml build

# 3. Deploy a K8s usando el script
BRANCH_TAG=$(git rev-parse --short HEAD)
chmod +x ./scripts/deploy-k8s.sh
./scripts/deploy-k8s.sh "$BRANCH_TAG"

# 4. Integration tests contra live services
./mvnw -B verify -Dtest="*IntegrationTest" -DfailIfNoTests=false

# 5. E2E tests
npm install -g newman
newman run "postman-collections/E2E Ecommerce Microservices Tests.postman_collection.json" \
  --environment "postman-collections/local-stage.postman_environment.json"
```

---

## 📝 Archivos Modificados

- **`.github/workflows/ci-stage.yml`**:
  - Maven build: Solo `*ServiceImplTest`
  - Docker build: Agrega `build-tag` output
  - K8s deploy: Usa `./scripts/deploy-k8s.sh`
  - Integration tests: Con mejor validación de resultados
  - E2E tests: Igual (posterior a integration tests)

---

## ⚙️ Requisitos en Runner

```bash
# Verificar todo está instalado:
java -version          # Java 11+
mvn -version           # Maven
docker ps              # Docker
kubectl cluster-info   # Kubernetes
git --version          # Git
npm -v                 # Node.js (para Newman)
```

---

## 🐛 Troubleshooting

### ❌ Error: "deploy-k8s.sh: No such file or directory"
```bash
chmod +x ./scripts/deploy-k8s.sh
```

### ❌ Error: "${BRANCH_TAG} not replaced in YAML"
El script usa `sed` con `/` delimiter. Si el SHA contiene `/`:
```bash
# El deploy-k8s.sh usa sed con @delimiter, no /
# Por lo que debería funcionar
```

### ❌ Integration tests fallan: "Cannot connect to API Gateway"
```bash
# Verifica que K8s deployment está ready
kubectl get deployments
kubectl get pods
kubectl logs deployment/api-gateway-container
kubectl describe pod <pod-name>
```

### ❌ Pods en CrashLoopBackOff
```bash
# Check logs
kubectl logs -f deployment/<service>-container
# Check events
kubectl describe pod <pod-name>
```

---

## 📊 Flujo Completo: Push a Stage

```bash
git commit -m "feat: new feature"
git push origin feature-branch:stage
```

↓ GitHub Actions dispara workflow ↓

```
✅ Maven Build (5 min)           → Artifact: workspace
   ↓
✅ Docker Build (15 min)         → Artifact: nada (images en GHCR)
   ↓
✅ K8s Deploy (10 min)           → K8s: 10 servicios + zipkin
   ↓
✅ Integration Tests (10 min)    → Artifact: XML reports
   ↓
✅ E2E Tests (15 min)            → Artifact: HTML + JSON report
   ↓
✅ COMPLETO (50-55 min total)    → Check GitHub Actions for details
```
