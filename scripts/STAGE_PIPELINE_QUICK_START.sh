#!/bin/bash

# Quick reference for Stage Pipeline execution

cat << 'EOF'
╔════════════════════════════════════════════════════════════════════════════╗
║                  🚀 STAGE PIPELINE - QUICK START GUIDE                     ║
╚════════════════════════════════════════════════════════════════════════════╝

📌 TRIGGER THE PIPELINE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Push to 'stage' branch:
  $ git push origin feature-branch:stage

Or create a PR to 'stage':
  $ git push origin feature-branch
  # Then create PR in GitHub → base: stage

╔════════════════════════════════════════════════════════════════════════════╗
║                           PIPELINE STAGES                                  ║
╚════════════════════════════════════════════════════════════════════════════╝

Stage 1: MAVEN BUILD (self-hosted) ✓ 5-10 min
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ Checkout code
  ✓ Set up JDK 11
  ✓ Run unit tests: *ServiceImplTest
  ✓ SonarQube analysis (optional)
  ✓ Upload workspace artifact

  Output: Compiled code + unit test reports


Stage 2: DOCKER BUILD (ubuntu-latest) ✓ 10-15 min
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ Download workspace
  ✓ Build Docker image per service
  ✓ Tag: ${SHORT_SHA} + "stage"
  ✓ Push to GHCR

  Services: api-gateway, cloud-config, favourite-service, order-service,
            payment-service, product-service, proxy-client, service-discovery,
            shipping-service, user-service

  Output: Images in GHCR tagged with short SHA


Stage 3: KUBERNETES DEPLOY (self-hosted) ✓ 10-15 min
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ Checkout (get deploy-k8s.sh)
  ✓ Configure kubectl
  ✓ Run: ./scripts/deploy-k8s.sh ${SHORT_SHA}
    • Replaces ${BRANCH_TAG} in YAML with short SHA
    • Adds imagePullPolicy: IfNotPresent
    • kubectl apply -f k8s/
    • Waits for all deployments ready
  ✓ Verify deployment (pods, services)

  Output: All 10 services running in Kubernetes


Stage 4: INTEGRATION TESTS (self-hosted) ✓ 5-10 min
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ Wait for API Gateway ready
  ✓ Run: *IntegrationTest pattern
  ✓ Tests run AGAINST LIVE SERVICES (real DB, cache, etc)
  ✓ Generate XML reports
  ✓ Upload artifacts

  Examples:
    - PaymentOrderIntegrationTest
    - OrderStatusCascadeIntegrationTest
    - ProductServiceIntegrationTest
    - FavouriteUserProductIntegrationTest
    - ShippingOrderProductIntegrationTest

  Output: Integration test reports (XML)


Stage 5: E2E TESTS (self-hosted) ✓ 10-20 min
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ Set up Node.js
  ✓ Install Newman (Postman CLI)
  ✓ Run: Postman collection (E2E Ecommerce Microservices Tests)
    • E2E-00: Setup Authentication
    • E2E-01: User Registration & Management
    • E2E-02: Complete Purchase Flow
    • E2E-03: Product & Stock Management
    • E2E-04: Shipping Flow
    • E2E-05: Favorites Management
    • E2E-99: Cleanup
  ✓ Generate HTML + JSON reports
  ✓ Upload artifacts

  Output: E2E test report (HTML + JSON)


╔════════════════════════════════════════════════════════════════════════════╗
║                         TOTAL TIME: ~50-60 min                            ║
╚════════════════════════════════════════════════════════════════════════════╝

📊 MONITORING THE PIPELINE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Check GitHub Actions:
   GitHub → Your repo → Actions → CI - Stage build

2. Download artifacts:
   ✓ test-results (Maven unit tests)
   ✓ integration-test-results (XML reports)
   ✓ e2e-test-report (HTML + JSON)
   ✓ workspace (if needed for debugging)

3. Check K8s status (while running):
   $ kubectl get pods
   $ kubectl get deployments
   $ kubectl get services


🔧 LOCAL TESTING (Without GitHub)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Stage 1: Unit tests
chmod +x ./mvnw
./mvnw -B verify -Dtest="*ServiceImplTest" -DfailIfNoTests=false

# Stage 2: Build Docker images (if not using GHCR)
docker-compose -f compose.yml build

# Stage 3: Deploy to K8s
BRANCH_TAG=$(git rev-parse --short HEAD)
chmod +x ./scripts/deploy-k8s.sh
./scripts/deploy-k8s.sh "$BRANCH_TAG"

# Stage 4: Integration tests
./mvnw -B verify -Dtest="*IntegrationTest" -DfailIfNoTests=false

# Stage 5: E2E tests
npm install -g newman
newman run "postman-collections/E2E Ecommerce Microservices Tests.postman_collection.json" \
  --environment "postman-collections/local-stage.postman_environment.json"


⚙️  PREREQUISITES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

In the self-hosted runner:
  ✓ Java 11 (auto-installed)
  ✓ Maven (auto-installed)
  ✓ Docker (for image builds)
  ✓ kubectl (configured + kubeconfig)
  ✓ Node.js (for Newman)
  ✓ Git

Verify:
  $ java -version
  $ mvn -v
  $ docker ps
  $ kubectl cluster-info
  $ git --version
  $ npm -v


📝 KEY FILES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  .github/workflows/ci-stage.yml
    └─ Main pipeline definition

  scripts/deploy-k8s.sh
    └─ K8s deployment script (handles image tag replacement)

  k8s/*-deployment.yaml
    └─ Service deployments (contains ${BRANCH_TAG} placeholder)

  k8s/*-service.yaml
    └─ Kubernetes services

  postman-collections/E2E Ecommerce Microservices Tests.postman_collection.json
    └─ E2E test suite

  postman-collections/local-stage.postman_environment.json
    └─ Postman environment variables


🐛 TROUBLESHOOTING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

❌ Pipeline fails at "Maven Build":
   → Check unit tests pass locally: ./mvnw verify -Dtest="*ServiceImplTest"

❌ Pipeline fails at "Docker Build":
   → Check Docker is running and runner has Docker access

❌ Pipeline fails at "K8s Deploy":
   → Check kubeconfig: kubectl cluster-info
   → Check deploy-k8s.sh: chmod +x ./scripts/deploy-k8s.sh
   → Check K8s cluster has resources: kubectl get nodes

❌ Pipeline fails at "Integration Tests":
   → Check API Gateway is ready: kubectl get pods
   → Check logs: kubectl logs deployment/api-gateway-container
   → Verify port-forward if needed

❌ Pipeline fails at "E2E Tests":
   → Check Newman installed: npm list -g newman
   → Check Postman collection exists and is valid
   → Check environment file has correct base_url


📞 NEED HELP?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Check docs:
    - docs/CI_STAGE_PIPELINE.md (detailed guide)
    - docs/STAGE_PIPELINE_UPDATED.md (updated flow)
    - docs/PIPELINES_OVERVIEW.md (dev vs stage comparison)

  Workflow file:
    - .github/workflows/ci-stage.yml

  Script:
    - scripts/deploy-k8s.sh


═══════════════════════════════════════════════════════════════════════════════
                            ✨ Ready to deploy! ✨
═══════════════════════════════════════════════════════════════════════════════
EOF
