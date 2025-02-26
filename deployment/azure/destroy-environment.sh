#!/usr/bin/env bash
##############################################################################
# Dependencies:
#   * Azure CLI
#   * env.sh
##############################################################################

echo "Destroying environment..."

echo "Setting environment variables..."
source ./env.sh

echo "Deleting resource group..."
az group delete \
  --name "$RESOURCE_GROUP" \
  --yes
