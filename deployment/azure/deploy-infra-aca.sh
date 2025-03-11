##############################################################################
# Dependencies:
#   * Azure CLI
#   * deploy-environment.sh
##############################################################################

echo "Creating the Azure Container Apps environment..."
echo "----------------------"
LOG_ANALYTICS_WORKSPACE_CLIENT_ID=`az monitor log-analytics workspace show  \
  --resource-group "$RESOURCE_GROUP" \
  --workspace-name "$LOG_ANALYTICS_WORKSPACE" \
  --query customerId  \
  --output tsv | tr -d '[:space:]'`

LOG_ANALYTICS_WORKSPACE_CLIENT_SECRET=`az monitor log-analytics workspace get-shared-keys \
  --resource-group "$RESOURCE_GROUP" \
  --workspace-name "$LOG_ANALYTICS_WORKSPACE" \
  --query primarySharedKey \
  --output tsv | tr -d '[:space:]'`

echo "LOG_ANALYTICS_WORKSPACE_CLIENT_ID=$LOG_ANALYTICS_WORKSPACE_CLIENT_ID"
echo "LOG_ANALYTICS_WORKSPACE_CLIENT_SECRET=$LOG_ANALYTICS_WORKSPACE_CLIENT_SECRET"


echo "Creating the Azure Container Apps environment..."
echo "----------------------"
az containerapp env create \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --tags system="$TAG" \
  --name "$CONTAINERAPPS_ENVIRONMENT" \
  --public-network-access "Enabled" \
  --logs-workspace-id "$LOG_ANALYTICS_WORKSPACE_CLIENT_ID" \
  --logs-workspace-key "$LOG_ANALYTICS_WORKSPACE_CLIENT_SECRET"


echo "Deleting the Azure Container Apps environment..."
echo "----------------------"
az containerapp env delete \
  --resource-group "$RESOURCE_GROUP" \
  --name "$CONTAINERAPPS_ENVIRONMENT" \
  --yes
