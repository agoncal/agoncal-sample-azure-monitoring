##############################################################################
# Dependencies:
#   * Azure CLI
#   * deploy-environment.sh
##############################################################################

echo "Creating the FunctionApp plan..."
echo "----------------------"
az functionapp plan create \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --tags system="$TAG" \
  --name "$FUNCTIONAPPS_PLAN" \
  --sku "B1" \
  --is-linux

echo "Deleting the AppService plan..."
echo "----------------------"
az functionapp plan delete \
  --resource-group "$RESOURCE_GROUP" \
  --name "$FUNCTIONAPPS_PLAN" \
  --yes
