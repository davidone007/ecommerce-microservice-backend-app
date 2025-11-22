#!/usr/bin/env bash

# restart-services.sh
# Restart Kubernetes deployments for one or more services (or all)
# Usage: ./restart-services.sh [options] <service1> <service2> ...
# Options:
#    -n, --namespace <ns>   Kubernetes namespace (default: dev)
#    -a, --all              Restart all known services
#    -w, --wait             Wait for rollout to finish for each deployment
#    --dry-run              Show commands that would run, do not execute
#    -y, --yes              Do not prompt for confirmation
#    -h, --help             Show this help

set -u

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NAMESPACE="dev"
WAIT=false
DRY_RUN=false
ASK_CONFIRMATION=true

KNOWN=(
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

usage(){
  cat <<EOF
Usage: $0 [options] <service1> <service2> ...

Options:
  -n, --namespace <ns>   Kubernetes namespace (default: ${NAMESPACE})
  -a, --all              Restart all known services
  -w, --wait             Wait for rollout to finish for each deployment
  --dry-run              Show commands that would run, do not execute
  -y, --yes              Do not prompt for confirmation
  -h, --help             Show this help

Examples:
  # Restart product-service only
  $0 product-service

  # Restart api-gateway and product-service, waiting for rollouts
  $0 -w api-gateway product-service

  # Restart all known services in namespace 'dev'
  $0 -a
EOF
}

# parse args
POSITIONAL=()
while [[ $# -gt 0 ]]; do
  case $1 in
    -n|--namespace)
      NAMESPACE="$2"; shift 2;;
    -a|--all)
      POSITIONAL+=("all"); shift;;
    -w|--wait)
      WAIT=true; shift;;
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

set -- "${POSITIONAL[@]}"

# compute list
TARGETS=()
if [ ${#POSITIONAL[@]} -eq 0 ]; then
  echo "No services specified. Use --all or list one or more services."; usage; exit 2
fi

if [[ " ${POSITIONAL[*]} " =~ " all " ]]; then
  TARGETS=("${KNOWN[@]}")
else
  for s in "${POSITIONAL[@]}"; do
    ok=false
    for k in "${KNOWN[@]}"; do
      if [[ "$s" == "$k" ]]; then ok=true; break; fi
    done
    if ! $ok; then
      echo "Unknown service: $s"; exit 2
    fi
    TARGETS+=("$s")
  done
fi

if [ ${#TARGETS[@]} -eq 0 ]; then
  echo "No valid targets found."; exit 2
fi

# confirmation
echo "Namespace: $NAMESPACE"
echo "Targets: ${TARGETS[*]}"
echo "Wait: ${WAIT}"
echo "Dry run: ${DRY_RUN}"

if $ASK_CONFIRMATION; then
  read -p "Proceed and restart the above deployments? (y/N): " -r
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted by user."; exit 0
  fi
fi

# check kubectl
if ! command -v kubectl >/dev/null 2>&1; then
  echo "kubectl not found in PATH"; exit 1
fi

# perform restarts
for s in "${TARGETS[@]}"; do
  deployment="${s}-container"
  cmd_restart=(kubectl rollout restart deployment/${deployment} -n ${NAMESPACE})
  if $DRY_RUN; then
    echo "DRY RUN: ${cmd_restart[*]}"
  else
    echo "Restarting deployment ${deployment} in namespace ${NAMESPACE}..."
    if ! kubectl rollout restart deployment/${deployment} -n ${NAMESPACE}; then
      echo "Failed to restart ${deployment}."; continue
    fi
    echo "Triggered restart for ${deployment}."

    if $WAIT; then
      echo "Waiting for rollout to finish for ${deployment}..."
      if ! kubectl rollout status deployment/${deployment} -n ${NAMESPACE} --timeout=2m; then
        echo "Rollout failed or timed out for ${deployment}. Check pod events/logs."; continue
      fi
      echo "Rollout finished for ${deployment}."
    fi
  fi
  echo ""
done

echo "All restarts processed."
