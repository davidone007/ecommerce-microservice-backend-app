#!/bin/bash

# Set default values
RG_NAME="tfstate-rg"
LOCATION="eastus"
CONTAINER_NAME="tfstate"
# Generate a unique suffix for the storage account to ensure global uniqueness
RANDOM_SUFFIX=$((RANDOM % 90000 + 10000))
STORAGE_ACCOUNT_NAME="tfstate${RANDOM_SUFFIX}"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting Terraform Backend Setup...${NC}"

# Check if az CLI is installed
if ! command -v az &> /dev/null; then
    echo -e "${RED}Azure CLI (az) is not installed. Please install it first.${NC}"
    exit 1
fi

# Check if logged in
echo "Checking Azure login status..."
az account show &> /dev/null
if [ $? -ne 0 ]; then
    echo -e "${RED}You are not logged in to Azure. Please run 'az login' and try again.${NC}"
    exit 1
fi

# Create Resource Group
echo "Creating Resource Group: $RG_NAME in $LOCATION..."
az group create --name $RG_NAME --location $LOCATION

# Create Storage Account
echo "Creating Storage Account: $STORAGE_ACCOUNT_NAME..."
az storage account create --resource-group $RG_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Create Storage Container
echo "Creating Storage Container: $CONTAINER_NAME..."
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME

# Determine the path to backend.tf files
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROD_BACKEND_FILE="$SCRIPT_DIR/../terraform/environments/prod/backend.tf"
STAGE_BACKEND_FILE="$SCRIPT_DIR/../terraform/environments/stage/backend.tf"

# Function to update backend file
update_backend_file() {
    local file=$1
    if [ -f "$file" ]; then
        echo "Updating $file with new configuration..."
        
        # Use sed to replace values. 
        # Using -i.bak for compatibility with macOS (BSD sed) and Linux (GNU sed)
        sed -i.bak "s/resource_group_name  = \".*\"/resource_group_name  = \"$RG_NAME\"/" "$file"
        sed -i.bak "s/storage_account_name = \".*\"/storage_account_name = \"$STORAGE_ACCOUNT_NAME\"/" "$file"
        sed -i.bak "s/container_name       = \".*\"/container_name       = \"$CONTAINER_NAME\"/" "$file"
        
        rm "${file}.bak"
        echo -e "${GREEN}Updated $file successfully!${NC}"
    else
        echo -e "${RED}Warning: $file not found.${NC}"
    fi
}

# Update backend files
update_backend_file "$PROD_BACKEND_FILE"
update_backend_file "$STAGE_BACKEND_FILE"

echo -e "${GREEN}Backend configuration updated successfully!${NC}"
echo -e "${GREEN}Storage Account Name: $STORAGE_ACCOUNT_NAME${NC}"

echo -e "${GREEN}Setup complete! You can now run 'terraform init' in your environments.${NC}"
