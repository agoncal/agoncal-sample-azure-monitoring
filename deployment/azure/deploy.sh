#!/usr/bin/env bash
##############################################################################
# Dependencies:
#   * Azure CLI
#   * env.sh
##############################################################################

echo "Deploying environment..."
echo "----------------------"

echo "Setting environment variables..."
echo "----------------------"
source ./env.sh

echo "Loging to Azure..."
echo "----------------------"
az login
# az login --tenant xxxx-xxx-xxx-xxx-xxxx  --use-device-code

# az account show

echo "Creating resource group..."
echo "----------------------"
az group create \
  --name "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --tags system="$TAG"

echo "Deploying Postgres database..."
echo "----------------------"
source ./deploy-infra-postgres.sh

echo "Deploying AI model..."
echo "----------------------"
source ./deploy-infra-ai.sh

echo "Deploying Monitoring..."
echo "----------------------"
source ./deploy-infra-monitoring.sh

echo "Deploying Registry..."
echo "----------------------"
source ./deploy-infra-registry.sh


echo "Deleting Resource Group..."
echo "----------------------"
az group delete \
  --name "$RESOURCE_GROUP" \
  --yes
