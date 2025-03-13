##############################################################################
# ACA: QUARKUS CONTAINER UBI Native APP
##############################################################################

echo "Creating the Native ACA..."
echo "----------------------"
az containerapp create \
  --resource-group "$RESOURCE_GROUP" \
  --tags system="$TAG" \
  --name "$CONTAINERAPPS_QUARKUS_UBI_MICRO_NATIVE_APP" \
  --image "${REGISTRY_URL}/${CONTAINER_QUARKUS_UBI_MICRO_NATIVE_IMAGE}" \
  --environment "$CONTAINERAPPS_ENVIRONMENT" \
  --ingress external \
  --target-port 80 \
  --min-replicas 1 \
  --runtime "java" \
  --enable-java-agent "true" \
  --enable-java-metrics "true" \
  --settings QUARKUS_HTTP_PORT="80" \
             QUARKUS_DATASOURCE_JDBC_URL="$POSTGRES_DB_CONNECT_STRING" \
             QUARKUS_LANGCHAIN4J_OPENAI_API_KEY="$OPENAI_API_KEY"


echo "Retrieving the URL of the Native app..."
echo "----------------------"
CONTAINERAPPS_QUARKUS_MARINER_NATIVE_APP_URL="https://$(az containerapp ingress show \
  --resource-group "$RESOURCE_GROUP" \
  --name "$CONTAINERAPPS_QUARKUS_MARINER_NATIVE_APP" \
  --output json | jq -r .fqdn)"

echo "CONTAINERAPPS_QUARKUS_MARINER_NATIVE_APP_URL=$CONTAINERAPPS_QUARKUS_MARINER_NATIVE_APP_URL"


echo "Connecting the ACA application to the Postgres Database..."
echo "----------------------"
az containerapp connection create postgres-flexible


az containerapp connection create app-insights


az containerapp env java-component
az containerapp env telemetry app-insights
az containerapp env telemetry
az containerapp env telemetry otlp


echo "Setting up the Health Check..."
echo "----------------------"
az webapp config set \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APPSERVICE_QUARKUS_UBI_NATIVE_APP" \
  --generic-configurations '{"healthCheckPath": "/quarkus/health/"}'


echo "Setting the configuration of the UBI Native webapp..."
echo "----------------------"
az containerapp config appsettings set \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APPSERVICE_QUARKUS_UBI_NATIVE_APP" \
  --settings QUARKUS_HTTP_PORT="80" \
             QUARKUS_DATASOURCE_JDBC_URL=$POSTGRES_CONNECTION_STRING \
             QUARKUS_LANGCHAIN4J_OPENAI_API_KEY=$OPENAI_KEY


echo "Restarting the UBI Native webapp..."
echo "----------------------"
az webapp restart \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APPSERVICE_QUARKUS_UBI_NATIVE_APP"


echo "Get the URL of the JAR webapp..."
echo "----------------------"
az webapp show \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APPSERVICE_QUARKUS_UBI_NATIVE_APP" \
  --output tsv --query defaultHostName



echo "Deleting the Native webapp..."
echo "----------------------"
az containerapp delete \
  --resource-group "$RESOURCE_GROUP" \
  --name "$CONTAINERAPPS_QUARKUS_UBI_NATIVE_APP" \
  --yes
