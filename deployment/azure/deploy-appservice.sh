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

##############################################################################
# QUARKUS JVM APP
##############################################################################
# To get all the available runtimes az webapp list-runtimes --os-type linux
echo "Creating the JAR webapp..."
echo "----------------------"
az webapp create \
  --resource-group "$RESOURCE_GROUP" \
  --tags system="$TAG" \
  --name "$QUARKUS_JVM_APP" \
  --plan "$APP_SERVICE_PLAN" \
  --runtime "JAVA:21-java21" \
  --public-network-access "Enabled"


echo "Setting the configuration of the JAR webapp..."
echo "----------------------"
az webapp config appsettings set \
  --resource-group "$RESOURCE_GROUP" \
  --name "$QUARKUS_JVM_APP" \
  --settings QUARKUS_HTTP_PORT="80" \
             QUARKUS_DATASOURCE_JDBC_URL="$POSTGRES_DB_CONNECT_STRING" \
             QUARKUS_LANGCHAIN4J_OPENAI_API_KEY="$OPENAI_API_KEY"

echo "Deploying the JAR webapp..."
echo "----------------------"
az webapp deploy \
  --resource-group "$RESOURCE_GROUP" \
  --name "$QUARKUS_JVM_APP" \
  --type jar \
  --src-path /Users/agoncal/Documents/Code/AGoncal/agoncal-sample-azure-monitoring/quarkus-app/target/quarkus-app-1.0.0-SNAPSHOT-runner.jar


echo "Get the URL of the JAR webapp..."
echo "----------------------"
az webapp show \
  --resource-group "$RESOURCE_GROUP" \
  --name "$QUARKUS_JVM_APP" \
  --output tsv --query defaultHostName


echo "Listing the settings of the JAR webapp..."
echo "----------------------"
az webapp config appsettings list \
  --resource-group "$RESOURCE_GROUP" \
  --name "$QUARKUS_JVM_APP" \
  --output table

az webapp connection list \
  --resource-group "$RESOURCE_GROUP" \
  --name "$QUARKUS_JVM_APP"

echo "Deleting the JAR webapp..."
echo "----------------------"
az webapp delete \
  --resource-group "$RESOURCE_GROUP" \
  --name "$QUARKUS_JVM_APP" \
  --keep-empty-plan


##############################################################################
# QUARKUS NATIVE APP
##############################################################################
echo "Creating the Native webapp..."
echo "----------------------"
az webapp create \
  --resource-group "$RESOURCE_GROUP" \
  --tags system="$TAG" \
  --name "$QUARKUS_NATIVE_APP" \
  --plan "$APP_SERVICE_PLAN" \
  --runtime "JAVA:21-java21" \
  --public-network-access "Enabled"

CREDS=($(az webapp deployment list-publishing-profiles --name "$QUARKUS_NATIVE_APP" --resource-group "$RESOURCE_GROUP"  --query "[?contains(publishMethod, 'FTP')].[publishUrl,userName,userPWD]" --output tsv))

curl -T /Users/agoncal/Documents/Code/AGoncal/agoncal-sample-azure-monitoring/quarkus-app/target/quarkus-app-1.0.0-SNAPSHOT-runner -u ${CREDS[2]}:${CREDS[3]} ${CREDS[1]}/


echo "Setting the configuration of the Native webapp..."
echo "----------------------"
az webapp config appsettings set \
  --resource-group "$RESOURCE_GROUP" \
  --name "$QUARKUS_NATIVE_APP" \
  --settings QUARKUS_HTTP_PORT="80" \
             QUARKUS_DATASOURCE_JDBC_URL="$POSTGRES_DB_CONNECT_STRING" \
             QUARKUS_LANGCHAIN4J_OPENAI_API_KEY="$OPENAI_API_KEY"

echo "Deploying the Native webapp..."
echo "----------------------"
az webapp deploy \
  --resource-group "$RESOURCE_GROUP" \
  --name "$QUARKUS_NATIVE_APP" \
  --type static \
  --src-path /Users/agoncal/Documents/Code/AGoncal/agoncal-sample-azure-monitoring/quarkus-app/target/quarkus-app-1.0.0-SNAPSHOT-runner

echo "Deploying the Startup script..."
echo "----------------------"
az webapp deploy \
  --resource-group "$RESOURCE_GROUP" \
  --name "$QUARKUS_NATIVE_APP" \
  --type startup \
  --src-path /Users/agoncal/Documents/Code/AGoncal/agoncal-sample-azure-monitoring/deployment/azure/startup.sh

echo "Deleting the JAR webapp..."
echo "----------------------"
az webapp delete \
  --resource-group "$RESOURCE_GROUP" \
  --name "$QUARKUS_NATIVE_APP" \
  --keep-empty-plan

##############################################################################
# QUARKUS CONTAINER UBI JVM APP
##############################################################################
echo "Creating the Container UBI JVM webapp..."
echo "----------------------"
az webapp create \
  --resource-group "$RESOURCE_GROUP" \
  --tags system="$TAG" \
  --name "$QUARKUS_CONTAINER_UBI_JVM_APP" \
  --plan "$APP_SERVICE_PLAN" \
  --container-image-name "monitoringjavaruntime/quarkus-ubi-jvm:latest" \
  --public-network-access "Enabled"

##############################################################################
# QUARKUS CONTAINER UBI NATIVE APP
##############################################################################
echo "Creating the Container UBI Native webapp..."
echo "----------------------"
az webapp create \
  --resource-group "$RESOURCE_GROUP" \
  --tags system="$TAG" \
  --name "$QUARKUS_CONTAINER_UBI_NATIVE_APP" \
  --plan "$APP_SERVICE_PLAN" \
  --container-image-name "monitoringjavaruntime/quarkus-ubi-native:latest" \
  --public-network-access "Enabled"

##############################################################################
# QUARKUS CONTAINER MICRO NATIVE APP
##############################################################################
echo "Creating the Container Micro Native webapp..."
echo "----------------------"
az webapp create \
  --resource-group "$RESOURCE_GROUP" \
  --tags system="$TAG" \
  --name "$QUARKUS_CONTAINER_MICRO_NATIVE_APP" \
  --plan "$APP_SERVICE_PLAN" \
  --container-image-name "monitoringjavaruntime/quarkus-micro-native:latest" \
  --public-network-access "Enabled"

##############################################################################
# QUARKUS CONTAINER MARINER JVM APP
##############################################################################
echo "Creating the Container Mariner JVM webapp..."
echo "----------------------"
az webapp create \
  --resource-group "$RESOURCE_GROUP" \
  --tags system="$TAG" \
  --name "$QUARKUS_CONTAINER_MARINER_JVM_APP" \
  --plan "$APP_SERVICE_PLAN" \
  --container-image-name "monitoringjavaruntime/quarkus-mariner-jvm:latest" \
  --public-network-access "Enabled"

##############################################################################
# QUARKUS CONTAINER MARINER DISTROLESS APP
##############################################################################
echo "Creating the Container Mariner Distroless webapp..."
echo "----------------------"
az webapp create \
  --resource-group "$RESOURCE_GROUP" \
  --tags system="$TAG" \
  --name "$QUARKUS_CONTAINER_MARINER_DISTROLESS_APP" \
  --plan "$APP_SERVICE_PLAN" \
  --container-image-name "monitoringjavaruntime/quarkus-mariner-distroless:latest" \
  --public-network-access "Enabled"
