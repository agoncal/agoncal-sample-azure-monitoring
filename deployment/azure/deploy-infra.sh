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
# az account show
# az login --tenant xxxx-xxx-xxx-xxx-xxxx  --use-device-code

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

echo "Deploying Storage..."
echo "----------------------"
source ./deploy-infra-storage.sh

echo "Deploying AppService..."
echo "----------------------"
source ./deploy-infra-appservice.sh

echo "Deploying ACA..."
echo "----------------------"
source ./deploy-infra-aca.sh

echo "Deploying Azure Function..."
echo "----------------------"
source ./deploy-infra-functionapp.sh


echo "Deleting Resource Group..."
echo "----------------------"
az group delete \
  --name "$RESOURCE_GROUP" \
  --yes
