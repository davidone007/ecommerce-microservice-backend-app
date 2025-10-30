#!/usr/bin/env zsh
# Build all services and load images into minikube
# Usage: ./scripts/build-and-load-images.sh [service1 service2 ...]
# If no service names are provided, builds the default set declared below.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${0}")/.." && pwd)"
cd "$ROOT_DIR"

# Default services to build (folders at repo root)
services=(api-gateway cloud-config service-discovery proxy-client order-service payment-service product-service shipping-service user-service favourite-service)

# If user passed services on command line, use those
if [[ $# -gt 0 ]]; then
  services=($@)
fi

image_tag="0.1.0"
image_prefix="selimhorri"

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Required command not found: $1" >&2
    exit 1
  fi
}

require_cmd minikube
require_cmd docker
# mvn is optional (we prefer using the service's ./mvnw if present). Don't fail if global mvn is absent.

# Prefer the wrapper if present for each service

echo "Root: $ROOT_DIR"

if ! minikube status >/dev/null 2>&1; then
  echo "Warning: minikube does not appear to be running. Start minikube before running this script: minikube start"
fi

for svc in "${services[@]}"; do
  svc_dir="$ROOT_DIR/$svc"
  if [[ ! -d "$svc_dir" ]]; then
    echo "[skip] $svc: directory not found ($svc_dir)"
    continue
  fi

  echo "\n=== Building $svc ==="
  cd "$svc_dir"

  if [[ -x ./mvnw ]]; then
    echo "Running ./mvnw -DskipTests package"
    ./mvnw -DskipTests package
  else
    if command -v mvn >/dev/null 2>&1; then
      echo "Running mvn -DskipTests package"
      mvn -DskipTests package
    else
      echo "No mvn wrapper or mvn available. Skipping $svc" >&2
      cd "$ROOT_DIR"
      continue
    fi
  fi

  # Compose the image name exactly like the k8s manifests expect
  image_name="$image_prefix/${svc}-ecommerce-boot:${image_tag}"
  echo "Building Docker image: $image_name"

  if [[ -f "$svc_dir/Dockerfile" ]]; then
    # Build using the repository root as context so Dockerfiles that reference
    # other folders (e.g. COPY api-gateway/ ...) work correctly.
    docker build -t "$image_name" -f "$svc_dir/Dockerfile" "$ROOT_DIR"
  else
    echo "No Dockerfile in $svc_dir, skipping docker build" >&2
    cd "$ROOT_DIR"
    continue
  fi

  echo "Loading image into minikube: $image_name"
  if minikube image load "$image_name" >/dev/null 2>&1; then
    echo "Loaded $image_name into minikube"
  else
    echo "minikube image load failed; attempting fallback using minikube docker-env"
    eval "$(minikube -p minikube docker-env)"
    docker build -t "$image_name" -f Dockerfile .
    # Unset docker-env
    eval "$(minikube -p minikube docker-env --unset)"
    echo "Fallback build completed for $image_name"
  fi

  # back to repo root
  cd "$ROOT_DIR"

done

echo "\nAll requested images built and (attempted) loaded into minikube."
echo "You can now: kubectl apply -f k8s/"
