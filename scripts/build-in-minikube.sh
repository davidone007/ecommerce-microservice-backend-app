#!/usr/bin/env bash

# build-in-minikube.sh
# Compila servicios seleccionados (o todos) y construye imágenes directamente dentro del Docker de Minikube.
# - Usa eval $(minikube docker-env) para construir dentro del entorno Docker de Minikube
# - Soporta tag (por defecto "stage") y lista de servicios o "all"
# - Opción --no-build para saltarse la compilación de JARs
# - Opción --dry-run para ver los pasos sin ejecutarlos

set -u

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REGISTRY="ghcr.io/davidone007"
TAG="stage"
SERVICES=(
  "service-discovery"
  "cloud-config"
  "api-gateway"
  "proxy-client"
  "order-service"
  "payment-service"
  "product-service"
  "shipping-service"
  "user-service"
  "favourite-service"
)

# defaults
DO_BUILD_JARS=true
DRY_RUN=false
ASK_CONFIRMATION=true

usage() {
  cat <<EOF
Usage: $0 [options] [service1 service2 ...]

Options:
  -t, --tag <tag>          Docker tag to use (default: ${TAG})
  -n, --no-build           Skip mvn build (only build docker images)
  -y, --yes                Do not prompt for confirmation
  --dry-run                Show commands that would run, don't execute
  -h, --help               Show this help

Examples:
  # build entire platform inside minikube using tag 'stage'
  $0 -t stage all

  # compile and build only product-service
  $0 -t stage product-service

  # only build images (skip mvn package)
  $0 -n -t stage api-gateway product-service
EOF
}

# parse args
POSITIONAL=()
while [[ $# -gt 0 ]]; do
  case $1 in
    -t|--tag)
      TAG="$2"; shift 2;;
    -n|--no-build)
      DO_BUILD_JARS=false; shift;;
    --dry-run)
      DRY_RUN=true; shift;;
    -y|--yes)
      ASK_CONFIRMATION=false; shift;;
    -h|--help)
      usage; exit 0;;
    *)
      POSITIONAL+=("$1"); shift;;
  esac
done

# restore positional
set -- "${POSITIONAL[@]}"

# compute selected services
SELECTED=()
if [ $# -eq 0 ]; then
  # no args => all
  SELECTED=("${SERVICES[@]}")
else
  # if 'all' specified, use all
  if [[ "$1" == "all" ]]; then
    SELECTED=("${SERVICES[@]}")
  else
    # validate services
    for arg in "$@"; do
      found=false
      for s in "${SERVICES[@]}"; do
        if [[ "$s" == "$arg" ]]; then
          found=true; break
        fi
      done
      if ! $found; then
        echo "Unknown service: $arg"; exit 2
      fi
      SELECTED+=("$arg")
    done
  fi
fi

if [ ${#SELECTED[@]} -eq 0 ]; then
  echo "No services selected."; exit 2
fi

echo "Base dir: $BASE_DIR"
echo "Registry: $REGISTRY"
echo "Tag: $TAG"
echo "Services: ${SELECTED[*]}"
echo "Build JARs: ${DO_BUILD_JARS}"
echo "Dry run: ${DRY_RUN}"

if $ASK_CONFIRMATION; then
  read -p "Proceed? (y/N): " -r
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted by user."; exit 0
  fi
fi

# Make sure minikube is available
if ! command -v minikube >/dev/null 2>&1; then
  echo "minikube is not installed or not available in PATH"; exit 1
fi

# Enable use of Minikube docker daemon
DOCKER_ENV_CMD="eval $(minikube docker-env --shell bash)"

if $DRY_RUN; then
  echo "DRY RUN: would run: $DOCKER_ENV_CMD"
else
  echo "Setting docker env to Minikube..."
  eval $(minikube docker-env)
fi

# Optional: compile JARs
if $DO_BUILD_JARS; then
  echo "\n=== Building JARs (Maven) ===\n"
  for s in "${SELECTED[@]}"; do
    SERVICE_DIR="$BASE_DIR/$s"
    if [ ! -d "$SERVICE_DIR" ]; then
      echo "Service dir $SERVICE_DIR not found, skipping..."; continue
    fi
    echo "Building $s..."
    if $DRY_RUN; then
      echo "DRY RUN: cd $SERVICE_DIR && ./mvnw clean package -DskipTests"
    else
      (cd "$SERVICE_DIR" && ./mvnw clean package -DskipTests) || { echo "Maven build failed for $s"; exit 1; }
    fi
  done
fi

# Build images inside minikube's docker
echo "\n=== Building Docker images inside Minikube ===\n"
for s in "${SELECTED[@]}"; do
  SERVICE_DIR="$BASE_DIR/$s"
  IMAGE_NAME="$REGISTRY/$s:$TAG"
  DOCKERFILE="$SERVICE_DIR/Dockerfile"

  if [ ! -f "$DOCKERFILE" ]; then
    echo "Dockerfile not found for $s at $DOCKERFILE, skipping..."; continue
  fi

  if $DRY_RUN; then
    echo "DRY RUN: docker build -f $DOCKERFILE -t $IMAGE_NAME $BASE_DIR"
  else
    echo "Building image $IMAGE_NAME"
    docker build -f "$DOCKERFILE" -t "$IMAGE_NAME" "$BASE_DIR" || { echo "docker build failed for $s"; exit 1; }
    echo "Built $IMAGE_NAME"
  fi
  echo ""
done

# Reset docker env back to default if not dry-run
if ! $DRY_RUN; then
  echo "Resetting docker env back to host Docker"
  eval $(minikube docker-env -u)
fi

echo "\nAll done. Remember to restart deployments to use the new images, e.g.:"
echo "  kubectl rollout restart deployment/product-service-container -n dev"

echo "Script finished."
