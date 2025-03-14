##############################################################################
# Dependencies:
#   * Azure CLI
#   * deploy-environment.sh
##############################################################################

echo "Creating the AppService plan..."
echo "----------------------"
az storage account create \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --tags system="$TAG" \
  --name "$STORAGE_ACCOUNT"

echo "Deleting the AppService plan..."
echo "----------------------"
az storage account delete \
  --resource-group "$RESOURCE_GROUP" \
  --name "$STORAGE_ACCOUNT" \
  --yes
