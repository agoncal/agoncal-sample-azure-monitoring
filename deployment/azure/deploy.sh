#!/usr/bin/env bash
##############################################################################
# Dependencies:
#   * Azure CLI
#   * env.sh
##############################################################################

echo "Deploying environment..."

echo "Setting environment variables..."
source ./env.sh

echo "Creating resource group..."
az group create \
  --name "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --tags system="$TAG"

echo "Deploying Postgres database..."
source ./deploy-infra-postgres.sh

echo "Deploying AI model..."
source ./deploy-infra-ai.sh

echo "Deploying Monitoring..."
source ./deploy-infra-monitoring.sh

echo "Deploying Registry..."
source ./deploy-infra-monitoring.sh

