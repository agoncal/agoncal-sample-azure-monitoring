##############################################################################
# APP SERVICE: QUARKUS CONTAINER UBI Native APP
##############################################################################

echo "Creating the Container UBI Native webapp..."
echo "----------------------"
az webapp create \
  --resource-group "$RESOURCE_GROUP" \
  --tags system="$TAG" \
  --name "$APPSERVICE_QUARKUS_UBI_MICRO_NATIVE_APP" \
  --plan "$APPSERVICE_PLAN" \
  --container-image-name "${REGISTRY_URL}/${CONTAINER_QUARKUS_UBI_MICRO_NATIVE_IMAGE}" \
  --public-network-access "Enabled"


echo "Setting up the Health Check..."
echo "----------------------"
az webapp config set \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APPSERVICE_QUARKUS_UBI_MICRO_NATIVE_APP" \
  --generic-configurations '{"healthCheckPath": "/quarkus/health/"}'


echo "Setting the configuration of the UBI Native webapp..."
echo "----------------------"
az webapp config appsettings set \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APPSERVICE_QUARKUS_UBI_MICRO_NATIVE_APP" \
  --settings QUARKUS_HTTP_PORT="80" \
             QUARKUS_DATASOURCE_JDBC_URL="$POSTGRES_DB_CONNECT_STRING" \
             QUARKUS_LANGCHAIN4J_OPENAI_API_KEY="$OPENAI_API_KEY"


echo "Restarting the UBI Native webapp..."
echo "----------------------"
az webapp restart \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APPSERVICE_QUARKUS_UBI_MICRO_NATIVE_APP"


echo "Get the URL of the JAR webapp..."
echo "----------------------"
az webapp show \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APPSERVICE_QUARKUS_UBI_MICRO_NATIVE_APP" \
  --output tsv --query defaultHostName



echo "Deleting the Native webapp..."
echo "----------------------"
az webapp delete \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APPSERVICE_QUARKUS_UBI_MICRO_NATIVE_APP" \
  --keep-empty-plan
