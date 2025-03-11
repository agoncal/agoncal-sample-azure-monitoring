##############################################################################
# Dependencies:
#   * Azure CLI
#   * deploy-environment.sh
##############################################################################

echo "Creating the AppService plan..."
echo "----------------------"
az appservice plan create \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --tags system="$TAG" \
  --name "$APPSERVICE_PLAN" \
  --sku "B1" \
  --is-linux

echo "Deleting the AppService plan..."
echo "----------------------"
az appservice plan delete \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APPSERVICE_PLAN" \
  --yes
