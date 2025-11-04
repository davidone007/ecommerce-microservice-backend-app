# ✅ Stage Pipeline - Pre-Launch Checklist

Antes de hacer push a `stage`, verifica que todo esté listo:

## 📋 Requisitos del Runner Self-Hosted

### Java & Maven
```bash
java -version
# Expected: openjdk version "11" or higher

mvn -v
# Expected: Apache Maven 3.x.x

# Make sure mvnw scripts are executable
chmod +x ./mvnw
chmod +x ./mvnw.cmd
```

### Docker
```bash
docker ps
# Expected: Shows running containers (or empty list)

docker --version
# Expected: Docker version 20+
```

### Kubernetes
```bash
kubectl cluster-info
# Expected: Kubernetes master is running

kubectl config current-context
# Expected: Shows current context

kubectl get nodes
# Expected: Lists one or more nodes

echo $KUBECONFIG
# If empty, ensure ~/.kube/config exists:
ls -la ~/.kube/config
# Expected: File exists and has correct permissions (600)
```

### Git
```bash
git --version
# Expected: git version 2.x or higher
```

### Node.js (for Newman/Postman)
```bash
npm -v
# Expected: npm version 8+

# If not installed, install Node.js:
# macOS: brew install node
# Linux: sudo apt-get install nodejs npm
# Windows: Download from https://nodejs.org/
```

## 📁 Project Structure

```bash
# Verify key files exist:
ls -la .github/workflows/ci-stage.yml
# Expected: File exists

ls -la scripts/deploy-k8s.sh
# Expected: File exists and is executable

ls -la k8s/*-deployment.yaml
# Expected: Multiple YAML files

ls -la postman-collections/E2E\ Ecommerce\ Microservices\ Tests.postman_collection.json
# Expected: File exists

ls -la postman-collections/local-stage.postman_environment.json
# Expected: File exists
```

## 🔧 GitHub Actions

### Secrets Configured
1. Go to: GitHub → Repo → Settings → Secrets and variables → Actions
2. Verify these secrets exist (optional but recommended):
   - ✓ `SONAR_HOST_URL` (if using SonarQube)
   - ✓ `SONAR_TOKEN` (if using SonarQube)
   - ✓ `GITHUB_TOKEN` (auto-provided)

### Branch Protection
1. Go to: GitHub → Repo → Settings → Branches
2. (Optional) Set up branch protection for `stage`:
   - Require PR reviews before merge
   - Require status checks to pass (ci-stage)
   - Dismiss stale PR approvals

## 🐳 Docker Images

### Verify Images Can Be Built
```bash
# Test building one service
cd api-gateway
docker build -t test-api-gateway:test .
# Expected: Builds successfully

docker image ls | grep test-api-gateway
# Expected: Shows the image

# Clean up
docker rmi test-api-gateway:test
cd ..
```

### GHCR Authentication (if pushing to GHCR)
```bash
# If using GHCR, authenticate:
# 1. Create GitHub Personal Access Token (PAT)
#    - Scope: write:packages, read:packages
# 2. Log in to GHCR:
echo $GITHUB_TOKEN | docker login ghcr.io -u <username> --password-stdin

# Verify login
docker pull ghcr.io/${{ github.repository_owner }}/api-gateway:dev
# Expected: Either pulls successfully or "not found" (both are OK at this stage)
```

## ☸️  Kubernetes Setup

### Cluster Access
```bash
# List all contexts
kubectl config get-contexts
# Expected: Shows available contexts with one marked as current

# Test access
kubectl auth can-i get pods
# Expected: yes

kubectl auth can-i create deployments
# Expected: yes

kubectl auth can-i create services
# Expected: yes
```

### Namespace
```bash
# Check if 'default' namespace exists
kubectl get namespace default
# Expected: Shows namespace

# Or use a specific namespace:
export KUBE_NAMESPACE=stage
kubectl create namespace $KUBE_NAMESPACE
```

### Deploy Script Permissions
```bash
# Make deploy script executable
chmod +x ./scripts/deploy-k8s.sh

# Test the script (dry-run)
./scripts/deploy-k8s.sh --help
# Or just check it runs:
bash -n ./scripts/deploy-k8s.sh
# Expected: No syntax errors
```

### Test K8s Deployment (Optional)
```bash
# Try deploying with a test tag
./scripts/deploy-k8s.sh "test-tag"

# Verify deployment
kubectl get pods
kubectl get services
kubectl get deployments

# Clean up (if desired)
kubectl delete -f k8s/
```

## 📮 Postman Collections

### Verify Collection Syntax
```bash
# Check if JSON is valid
jq . "postman-collections/E2E Ecommerce Microservices Tests.postman_collection.json"
# Expected: Valid JSON output (no errors)

jq . "postman-collections/local-stage.postman_environment.json"
# Expected: Valid JSON output (no errors)
```

### Newman Installation
```bash
# Install Newman globally
npm install -g newman
npm install -g newman-reporter-htmlextra

# Verify installation
newman --version
# Expected: Shows version number
```

### Test Postman Collection (Optional)
```bash
# Test E2E collection (may fail if services not running, that's OK)
newman run "postman-collections/E2E Ecommerce Microservices Tests.postman_collection.json" \
  --environment "postman-collections/local-stage.postman_environment.json" \
  --timeout-request 5000 \
  --reporters cli

# Expected: Runs (may show failures if services not ready, that's OK at this stage)
```

## 🧪 Local Test Run (Optional but Recommended)

### Full Pipeline Simulation
```bash
# Stage 1: Unit tests
chmod +x ./mvnw
./mvnw -B verify -Dtest="*ServiceImplTest" -DfailIfNoTests=false
echo "Stage 1 result: $?"

# Stage 2: Build Docker (if needed)
# Skip this if using GHCR push

# Stage 3: Deploy to K8s
BRANCH_TAG=$(git rev-parse --short HEAD)
chmod +x ./scripts/deploy-k8s.sh
./scripts/deploy-k8s.sh "$BRANCH_TAG"
echo "Stage 3 result: $?"

# Verify K8s deployment
kubectl get pods
kubectl rollout status deployment/api-gateway-container --timeout=5m

# Stage 4: Integration tests
./mvnw -B verify -Dtest="*IntegrationTest" -DfailIfNoTests=false
echo "Stage 4 result: $?"

# Stage 5: E2E tests
newman run "postman-collections/E2E Ecommerce Microservices Tests.postman_collection.json" \
  --environment "postman-collections/local-stage.postman_environment.json"
echo "Stage 5 result: $?"
```

## 🚀 Final Checks Before Push

### Code Quality
```bash
# Ensure tests pass locally
./mvnw test -Dtest="*ServiceImplTest" -DfailIfNoTests=false
# Expected: All tests pass (BUILD SUCCESS)

# No uncommitted changes
git status
# Expected: clean working tree
```

### Branch Status
```bash
# Ensure on a feature branch
git branch
# Expected: Shows your branch, not 'stage' or 'master'

# Check ahead of remote
git log origin/stage..HEAD
# Expected: Shows your commits (OK to have commits)

# No conflicts with stage
git fetch origin
git merge-base --is-ancestor HEAD origin/stage
# Expected: Returns 0 (OK) or 1 (may need rebase)
```

### Commit Message
```bash
# Use clear, descriptive commit messages
git log -1 --oneline
# Expected: Shows clear description like:
# "feat: add new feature"
# "fix: resolve bug"
# "test: add integration tests"
```

## ✅ Launch Checklist

Before final push:

- [ ] Java 11 installed and working
- [ ] Maven installed and working
- [ ] Docker running and accessible
- [ ] kubectl configured and cluster accessible
- [ ] Node.js and npm installed
- [ ] Newman installed globally
- [ ] .github/workflows/ci-stage.yml exists
- [ ] scripts/deploy-k8s.sh exists and is executable
- [ ] k8s YAML files exist
- [ ] Postman collections exist and valid JSON
- [ ] GitHub secrets configured (SONAR_HOST_URL, SONAR_TOKEN optional)
- [ ] Local unit tests pass
- [ ] No uncommitted changes
- [ ] Branch is not 'stage' or 'master'
- [ ] Commit messages are clear

## 🎬 Ready to Push!

```bash
# Verify current branch
git branch

# Add changes
git add .

# Commit
git commit -m "feat: description of changes"

# Push to stage
git push origin current-branch:stage

# Watch the pipeline
# Go to: GitHub → Actions → CI - Stage build
```

## 🔍 Pipeline Monitoring

After push:

1. **Maven Build** (5-10 min)
   - Check: Unit tests pass
   - Expected: BUILD SUCCESS
   - Check logs for errors

2. **Docker Build** (10-15 min)
   - Check: All services built
   - Expected: "Build and push" step succeeds
   - Verify images in GHCR

3. **K8s Deploy** (10-15 min)
   - Check: `./scripts/deploy-k8s.sh` runs
   - Expected: All manifests applied
   - Verify: `kubectl get pods` shows running pods

4. **Integration Tests** (5-10 min)
   - Check: API Gateway ready check passes
   - Expected: Tests run against live services
   - Verify: XML reports generated

5. **E2E Tests** (10-20 min)
   - Check: Newman runs successfully
   - Expected: E2E test report generated
   - Verify: HTML and JSON reports available

## 🆘 Troubleshooting

If pipeline fails:

1. **Check logs**: GitHub Actions → View run → Check failed step
2. **Run locally**: Reproduce the failing stage locally first
3. **Check prerequisites**: Verify all tools are installed and configured
4. **Check secrets**: Ensure SONAR_* secrets are set if SonarQube is used
5. **Check K8s**: Run `kubectl get pods` to debug deployment issues
6. **Check images**: Verify Docker images exist and can be pulled

## 📚 Documentation

For more details, see:
- `docs/CI_STAGE_PIPELINE.md` - Detailed pipeline guide
- `docs/STAGE_PIPELINE_UPDATED.md` - Updated flow explanation
- `docs/PIPELINES_OVERVIEW.md` - Dev vs Stage comparison
- `scripts/STAGE_PIPELINE_QUICK_START.sh` - Quick reference

---

**Last Updated**: 2025-11-04
**Pipeline Version**: v1.0 (Updated with deploy-k8s.sh integration)
