##############################################################################
# QUARKUS CONTAINER UBI JVM APP
##############################################################################

echo "Getting the Container Registry URL..."
echo "----------------------"
REGISTRY_URL=$(az acr show \
  --resource-group "$RESOURCE_GROUP" \
  --name "$CONTAINER_REGISTRY" \
  --query "loginServer" \
  --output tsv)

echo "REGISTRY_URL=$REGISTRY_URL"


echo "Building the Quarkus application..."
echo "----------------------"
mvn clean package -Dmaven.test.skip=true


echo "Building the Docker Image..."
echo "----------------------"
docker build -f src/main/docker/Dockerfile-ubi.jvm -t "${PROJECT}/${QUARKUS_CONTAINER_UBI_JVM_IMAGE}:${IMAGES_TAG}" .

# If you want to run the container locally
# docker run -i --rm -p 80:80 "${PROJECT}/${QUARKUS_CONTAINER_UBI_JVM_IMAGE}:${IMAGES_TAG}"
# curl 'localhost:80/quarkus/load'

echo "Tagging the Docker Image for Azure Container Registry..."
echo "----------------------"
docker tag "${PROJECT}/${QUARKUS_CONTAINER_UBI_JVM_IMAGE}:${IMAGES_TAG}"    "${REGISTRY_URL}/${PROJECT}/${QUARKUS_CONTAINER_UBI_JVM_IMAGE}:${IMAGES_TAG}"


echo "Listing local images..."
echo "----------------------"
docker image ls | grep $PROJECT


echo "Pushing the Docker Image to the Azure Container Registry..."
echo "----------------------"
docker push "${REGISTRY_URL}/${PROJECT}/${QUARKUS_CONTAINER_UBI_JVM_IMAGE}:${IMAGES_TAG}"


echo "Creating the Container UBI JVM webapp..."
echo "----------------------"
az webapp create \
  --resource-group "$RESOURCE_GROUP" \
  --tags system="$TAG" \
  --name "$QUARKUS_CONTAINER_UBI_JVM_APP" \
  --plan "$APP_SERVICE_PLAN" \
  --container-image-name "${REGISTRY_URL}/${PROJECT}/${QUARKUS_CONTAINER_UBI_JVM_IMAGE}:${IMAGES_TAG}" \
  --public-network-access "Enabled"

echo "Setting up the Health Check..."
echo "----------------------"
az webapp config set \
  --resource-group "$RESOURCE_GROUP" \
  --name "$QUARKUS_CONTAINER_UBI_JVM_APP" \
  --generic-configurations '{"healthCheckPath": "/quarkus/health/"}'


echo "Setting the configuration of the UBI JVM webapp..."
echo "----------------------"
az webapp config appsettings set \
  --resource-group "$RESOURCE_GROUP" \
  --name "$QUARKUS_CONTAINER_UBI_JVM_APP" \
  --settings QUARKUS_HTTP_PORT="80" \
             QUARKUS_DATASOURCE_JDBC_URL=$POSTGRES_CONNECTION_STRING \
             QUARKUS_LANGCHAIN4J_OPENAI_API_KEY=$OPENAI_KEY


echo "Restarting the UBI JVM webapp..."
echo "----------------------"
az webapp restart \
  --resource-group "$RESOURCE_GROUP" \
  --name "$QUARKUS_CONTAINER_UBI_JVM_APP"


echo "Get the URL of the JAR webapp..."
echo "----------------------"
az webapp show \
  --resource-group "$RESOURCE_GROUP" \
  --name "$QUARKUS_CONTAINER_UBI_JVM_APP" \
  --output tsv --query defaultHostName



echo "Deleting the JVM webapp..."
echo "----------------------"
az webapp delete \
  --resource-group "$RESOURCE_GROUP" \
  --name "$QUARKUS_CONTAINER_UBI_JVM_APP" \
  --keep-empty-plan
