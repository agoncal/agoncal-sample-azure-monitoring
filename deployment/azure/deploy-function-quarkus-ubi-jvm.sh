##############################################################################
# ACA: QUARKUS CONTAINER UBI JVM APP
##############################################################################

# List the available runtimes az functionapp list-runtimes --os-type Linux --output table
echo "Creating the JVM FunctionApp..."
echo "----------------------"
az functionapp create \
  --resource-group "$RESOURCE_GROUP" \
  --tags system="$TAG" \
  --name "$FUNCTIONAPPS_QUARKUS_UBI_JVM_APP" \
  --plan "$FUNCTIONAPPS_PLAN" \
  --os-type "Linux" \
  --workspace "$LOG_ANALYTICS_WORKSPACE" \
  --image "${REGISTRY_URL}/${CONTAINER_QUARKUS_UBI_JVM_IMAGE}" \


--app-insights
--app-insights-key

  --environment "$CONTAINERAPPS_ENVIRONMENT" \
  --ingress external \
  --target-port 8701 \
  --min-replicas 1 \
  --runtime "java" \
  --enable-java-agent "true" \
  --enable-java-metrics "true" \
  --env-vars QUARKUS_HTTP_PORT="80" \
             QUARKUS_DATASOURCE_JDBC_URL="$POSTGRES_DB_CONNECT_STRING" \
             QUARKUS_LANGCHAIN4J_OPENAI_API_KEY="$OPENAI_API_KEY"



az containerapp create \
  --resource-group "$RESOURCE_GROUP" \
  --tags system="$TAG" \
  --name "$CONTAINERAPPS_QUARKUS_UBI_NATIVE_APP" \
  --image "${REGISTRY_URL}/${CONTAINER_QUARKUS_UBI_NATIVE_IMAGE}" \
  --environment "$CONTAINERAPPS_ENVIRONMENT" \
  --ingress external \
  --target-port 80 \
  --min-replicas 1 \
  --runtime "java" \
  --enable-java-agent "true" \
  --enable-java-metrics "true" \
  --env-vars QUARKUS_HTTP_PORT="80" \
             QUARKUS_DATASOURCE_JDBC_URL="$POSTGRES_DB_CONNECT_STRING" \
             QUARKUS_LANGCHAIN4J_OPENAI_API_KEY="$OPENAI_API_KEY"



echo "Retrieving the URL of the JVM app..."
echo "----------------------"
CONTAINERAPPS_QUARKUS_MARINER_JVM_APP_URL="https://$(az containerapp ingress show \
  --resource-group "$RESOURCE_GROUP" \
  --name "$CONTAINERAPPS_QUARKUS_MARINER_JVM_APP" \
  --output json | jq -r .fqdn)"

echo "CONTAINERAPPS_QUARKUS_MARINER_JVM_APP_URL=$CONTAINERAPPS_QUARKUS_MARINER_JVM_APP_URL"


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
  --name "$APPSERVICE_QUARKUS_UBI_JVM_APP" \
  --generic-configurations '{"healthCheckPath": "/quarkus/health/"}'


echo "Setting the configuration of the UBI JVM webapp..."
echo "----------------------"
az containerapp config appsettings set \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APPSERVICE_QUARKUS_UBI_JVM_APP" \
  --settings QUARKUS_HTTP_PORT="80" \
             QUARKUS_DATASOURCE_JDBC_URL=$POSTGRES_CONNECTION_STRING \
             QUARKUS_LANGCHAIN4J_OPENAI_API_KEY=$OPENAI_KEY


echo "Restarting the UBI JVM webapp..."
echo "----------------------"
az webapp restart \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APPSERVICE_QUARKUS_UBI_JVM_APP"


echo "Get the URL of the JAR webapp..."
echo "----------------------"
az webapp show \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APPSERVICE_QUARKUS_UBI_JVM_APP" \
  --output tsv --query defaultHostName



echo "Deleting the JVM webapp..."
echo "----------------------"
az containerapp delete \
  --resource-group "$RESOURCE_GROUP" \
  --name "$CONTAINERAPPS_QUARKUS_UBI_JVM_APP" \
  --yes
