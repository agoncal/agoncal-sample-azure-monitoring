##############################################################################
# Dependencies:
#   * Azure CLI
#   * env.sh
##############################################################################

echo "Creating Log Analytics..."
echo "----------------------"
az monitor log-analytics workspace create \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --tags system="$TAG" \
  --workspace-name "$LOG_ANALYTICS_WORKSPACE"

echo "Creating Application Insights..."
echo "----------------------"
az monitor app-insights component create \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --tags system="$TAG" \
  --app "$APP_INSIGHTS_APPSERVICE_QUARKUS_JVM_APP" \
  --workspace "$LOG_ANALYTICS_WORKSPACE" \
  --kind java



echo "Deleting Application Insights..."
echo "----------------------"
az monitor app-insights component delete \
  --resource-group "$RESOURCE_GROUP" \
  --app "$APP_INSIGHTS_APPSERVICE_QUARKUS_JVM_APP"

echo "Deleting Log Analytics..."
echo "----------------------"
az monitor log-analytics workspace delete \
  --resource-group "$RESOURCE_GROUP" \
  --workspace-name "$LOG_ANALYTICS_WORKSPACE" \
  --force \
  --yes
