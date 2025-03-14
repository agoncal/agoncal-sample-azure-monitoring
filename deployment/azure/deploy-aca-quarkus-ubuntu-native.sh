##############################################################################
# ACA: QUARKUS CONTAINER UBUNTU Native APP
##############################################################################

echo "Creating the Native ACA..."
echo "----------------------"
az containerapp create \
  --resource-group "$RESOURCE_GROUP" \
  --tags system="$TAG" \
  --name "$CONTAINERAPPS_QUARKUS_UBUNTU_NATIVE_APP" \
  --image "${REGISTRY_URL}/${CONTAINER_QUARKUS_UBUNTU_NATIVE_IMAGE}" \
  --environment "$CONTAINERAPPS_ENVIRONMENT" \
  --ingress external \
  --target-port 80 \
  --min-replicas 1 \
  --runtime "java"

  \
  --enable-java-agent "true" \
  --enable-java-metrics "true" \
  --settings QUARKUS_HTTP_PORT="80" \
             QUARKUS_DATASOURCE_JDBC_URL="$POSTGRES_DB_CONNECT_STRING" \
             QUARKUS_LANGCHAIN4J_OPENAI_API_KEY="$OPENAI_API_KEY"



echo "Deleting the Native webapp..."
echo "----------------------"
az containerapp delete \
  --resource-group "$RESOURCE_GROUP" \
  --name "$CONTAINERAPPS_QUARKUS_UBUNTU_NATIVE_APP" \
  --yes
