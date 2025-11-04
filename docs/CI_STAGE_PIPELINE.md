# CI/CD Stage Pipeline

## Descripción

El pipeline `ci-stage.yml` es un workflow completo de CI/CD diseñado para la rama `stage`. Ejecuta pruebas exhaustivas y despliegue en Kubernetes.

## Flujo del Pipeline

### 1. **maven-build** (self-hosted)
   - Compila la aplicación
   - Ejecuta pruebas unitarias (`*ServiceImplTest`)
   - Ejecuta pruebas de integración (`*IntegrationTest`)
   - Genera análisis SonarQube
   - Carga workspace como artefacto

### 2. **docker-build** (ubuntu-latest)
   - Descarga el workspace compilado
   - Construye imágenes Docker para cada servicio
   - Las pushea a GHCR con tag `stage` y SHA corto
   - Solo ejecuta en push directo a `stage` (no en PRs)

### 3. **kubernetes-deploy** (self-hosted)
   - **Requisito**: kubectl configurado con acceso al cluster K8s
   - Aplica todos los manifiestos de `k8s/`
   - Espera a que todos los deployments estén ready (timeout 5min c/u)
   - Valida estado de pods y servicios
   - Solo ejecuta si docker-build tuvo éxito

### 4. **integration-tests** (self-hosted)
   - Espera a que API Gateway esté disponible en `http://localhost:8080`
   - Ejecuta nuevamente pruebas de integración contra servicios desplegados
   - Genera reportes en formato XML para análisis
   - Solo ejecuta si kubernetes-deploy tuvo éxito

### 5. **e2e-tests** (self-hosted)
   - Instala Newman (CLI de Postman)
   - Ejecuta la colección E2E completa
   - Genera reportes HTML y JSON
   - Pruebas incluyen: setup, usuarios, compra, productos, envíos, favoritos
   - Solo ejecuta si integration-tests tuvo éxito

## Requisitos Previos

### En el Runner Self-Hosted

1. **kubectl configurado** con acceso a tu cluster K8s:
   ```bash
   kubectl cluster-info
   kubectl get nodes
   ```

2. **Acceso a Docker**:
   ```bash
   docker ps
   ```

3. **Java 11 y Maven** (se instalan automáticamente en el step)

4. **Kubeconfig válido** (~/.kube/config o $KUBECONFIG)

### Secretos en GitHub

Agregar en Settings → Secrets:
- `SONAR_HOST_URL`: URL de SonarQube (ej: `http://localhost:9000`)
- `SONAR_TOKEN`: Token de autenticación en SonarQube

## Activación

El pipeline se ejecuta automáticamente cuando:
- Haces push a la rama `stage`
- Creas/actualizas un PR a la rama `stage`

```bash
git push origin feature-branch:stage
```

## Archivos Clave

- **`.github/workflows/ci-stage.yml`**: Definición del workflow
- **`k8s/*-deployment.yaml`**: Manifiestos de deployment
- **`k8s/*-service.yaml`**: Manifiestos de servicio
- **`postman-collections/E2E Ecommerce Microservices Tests.postman_collection.json`**: Colección E2E
- **`postman-collections/local-stage.postman_environment.json`**: Variables de ambiente para Postman

## Troubleshooting

### ❌ Error: "kubectl not found"
Instala kubectl en el runner:
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
```

### ❌ Error: "kubeconfig not found"
Configura kubectl:
```bash
export KUBECONFIG=~/.kube/config
# O copia tu kubeconfig a ~/.kube/config
```

### ❌ Error: "No tests were executed" (IntegrationTest)
El pipeline continúa ejecutándose con `-DfailIfNoTests=false`. Si necesitas que falle, edita el workflow.

### ❌ Pods en estado "CrashLoopBackOff"
Inspecciona logs:
```bash
kubectl logs deployment/api-gateway-container
kubectl describe pod <pod-name>
```

### ❌ E2E tests fallan con "Cannot POST /app/api/users"
Verifica que:
- API Gateway está running: `kubectl get pods`
- Port-forward si es necesario: `kubectl port-forward svc/api-gateway-container-service 8080:8080`

## Variables de Ambiente (Postman)

El archivo `local-stage.postman_environment.json` define:
- `base_url`: Base de la API (http://localhost:8080/app/api)
- IDs de recursos (se pueblan automáticamente en los tests)
- Tokens JWT (capturados en el setup)

## Ejecución Local para Debugging

Para simular el pipeline localmente:

```bash
# 1. Build y unit tests
chmod +x ./mvnw
./mvnw -B -T 1C verify -Dtest="*ServiceImplTest,*IntegrationTest" -DfailIfNoTests=false

# 2. Desplegar a K8s (requiere kubectl)
kubectl apply -f k8s/*-deployment.yaml
kubectl apply -f k8s/*-service.yaml
kubectl rollout status deployment/api-gateway-container --timeout=5m

# 3. Ejecutar E2E tests
npm install -g newman
newman run "postman-collections/E2E Ecommerce Microservices Tests.postman_collection.json" \
  --environment "postman-collections/local-stage.postman_environment.json"
```

## Performance & Timeouts

- Cada deployment espera máx 5 minutos para estar ready
- API Gateway check espera máx 5 minutos (50 intentos de 5s)
- Requests en Postman: timeout 10s, delay entre requests 500ms

## Próximas Mejoras

- [ ] Agregar paso de rollback automático si E2E falla
- [ ] Métricas de performance (Prometheus/Grafana)
- [ ] Notificaciones Slack/Teams en caso de fallo
- [ ] Smoke tests post-deployment
- [ ] Limpieza automática de pods si E2E falla
