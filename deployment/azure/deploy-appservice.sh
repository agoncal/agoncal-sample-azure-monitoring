##############################################################################
# Dependencies:
#   * Azure CLI
#   * deploy-environment.sh
##############################################################################

echo "Creating and AppService plan..."
echo "----------------------"
az appservice plan create \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --tags system="$TAG" \
  --name "$APP_SERVICE_PLAN" \
  --sku "B1" \
  --is-linux

# To get all the available runtimes az webapp list-runtimes --os-type linux

echo "Creating a webapp..."
echo "----------------------"
az webapp create \
  --resource-group "$RESOURCE_GROUP" \
  --tags system="$TAG" \
  --name "$QUARKUS_APP" \
  --plan "$APP_SERVICE_PLAN" \
  --runtime "JAVA:21-java21" \
  --public-network-access "Enabled"


echo "Listing the settings of the webapp..."
echo "----------------------"
az webapp config appsettings set \
  --resource-group "$RESOURCE_GROUP" \
  --name "$QUARKUS_APP" \
  --settings QUARKUS_HTTP_PORT="80" \
             QUARKUS_DATASOURCE_JDBC_URL="$POSTGRES_DB_CONNECT_STRING" \
             QUARKUS_LANGCHAIN4J_OPENAI_API_KEY="$OPENAI_API_KEY"


echo "Deploying a webapp..."
echo "----------------------"
az webapp deploy \
  --resource-group "$RESOURCE_GROUP" \
  --name "$QUARKUS_APP" \
  --type jar \
  --src-path /Users/agoncal/Documents/Code/AGoncal/agoncal-sample-azure-monitoring/quarkus-app/target/quarkus-app-1.0.0-SNAPSHOT-runner.jar


echo "Get the URL of the webapp..."
echo "----------------------"
az webapp show \
  --resource-group "$RESOURCE_GROUP" \
  --name "$QUARKUS_APP" \
  --output tsv --query defaultHostName


echo "Listing the settings of the webapp..."
echo "----------------------"
az webapp config appsettings list \
  --resource-group "$RESOURCE_GROUP" \
  --name "$QUARKUS_APP"


echo "Deleting the webapp..."
echo "----------------------"
az webapp delete \
  --resource-group "$RESOURCE_GROUP" \
  --name "$QUARKUS_APP" \
  --keep-empty-plan
