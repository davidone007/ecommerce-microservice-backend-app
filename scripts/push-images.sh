#!/bin/bash

# Script to build and push Docker images

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
REGISTRY="ghcr.io/davidone007"
TAG="${1:-latest}"
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Services
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

echo -e "${BLUE}🐳 Build and Push Script${NC}"
echo "Tag: $TAG"

# Build images first
echo -e "${BLUE}🔨 Building images...${NC}"
./scripts/build-images.sh "$TAG"

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Build failed. Aborting push.${NC}"
    exit 1
fi

# Push images
echo -e "${BLUE}🚀 Pushing images to registry...${NC}"

for service in "${SERVICES[@]}"; do
    IMAGE_NAME="${REGISTRY}/${service}:${TAG}"
    echo -e "${YELLOW}Pushing $IMAGE_NAME...${NC}"
    docker push "$IMAGE_NAME"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Pushed $IMAGE_NAME${NC}"
    else
        echo -e "${RED}❌ Failed to push $IMAGE_NAME${NC}"
        exit 1
    fi
done

echo -e "${GREEN}✨ All images pushed successfully!${NC}"
