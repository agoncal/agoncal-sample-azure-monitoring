##############################################################################
# Dependencies:
#   * Azure CLI
#   * env.sh
##############################################################################

echo "Creating the Container Registry..."
echo "----------------------"
az acr create \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --tags system="$TAG" \
  --name "$CONTAINER_REGISTRY" \
  --sku Standard \
  --workspace "$LOG_ANALYTICS_QUARKUS_JVM_APP" \
  --public-network-enabled true

echo "Logging into the Container Registry..."
echo "----------------------"
az acr login \
  --name "$CONTAINER_REGISTRY" \

echo "Listing the images stored in the Container Registry..."
echo "----------------------"
az acr repository list \
  --name "$CONTAINER_REGISTRY" \
  --output table



echo "Deleting the Container Registry..."
echo "----------------------"
az acr delete \
  --resource-group "$RESOURCE_GROUP" \
  --name "$CONTAINER_REGISTRY" \
  --yes


REGISTRY_URL=$(az acr show \
  --resource-group "$RESOURCE_GROUP" \
  --name "$CONTAINER_REGISTRY" \
  --query "loginServer" \
  --output tsv)

echo "REGISTRY_URL=$REGISTRY_URL"
