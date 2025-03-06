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
             QUARKUS_DATASOURCE_JDBC_URL=$POSTGRES_CONNECTION_STRING \
             QUARKUS_LANGCHAIN4J_OPENAI_API_KEY=$OPENAI_KEY


az webapp config appsettings set \
  --resource-group "$RESOURCE_GROUP" \
  --name "$QUARKUS_JVM_APP" \
  --settings QUARKUS_HTTP_PORT="80" \
             QUARKUS_DATASOURCE_JDBC_URL=$POSTGRES_CONNECTION_STRING \
             QUARKUS_LANGCHAIN4J_OPENAI_API_KEY=$OPENAI_KEY \
             ApplicationInsightsAgent_EXTENSION_VERSION="~3" \
             XDT_MicrosoftApplicationInsights_Mode="recommended" \
             APPINSIGHTS_PROFILERFEATURE_VERSION="1.0.0" \
             DiagnosticServices_EXTENSION_VERSION="~3" \
             APPINSIGHTS_SNAPSHOTFEATURE_VERSION="1.0.0" \
             SnapshotDebugger_EXTENSION_VERSION="disabled" \
             InstrumentationEngine_EXTENSION_VERSION="disabled" \
             XDT_MicrosoftApplicationInsights_BaseExtensions="disabled" \
             XDT_MicrosoftApplicationInsights_PreemptSdk="disabled" \
             APPLICATIONINSIGHTS_CONFIGURATION_CONTENT=""

             APPINSIGHTS_INSTRUMENTATIONKEY="bca53de3-b103-4158-81d2-308290f81569" \
             APPINSIGHTS_CONNECTIONSTRING="InstrumentationKey=bca53de3-b103-4158-81d2-308290f81569;IngestionEndpoint=https://swedencentral-0.in.applicationinsights.azure.com/;LiveEndpoint=https://swedencentral.livediagnostics.monitor.azure.com/;ApplicationId=6cbfbec1-9f5a-4804-9ec9-743ca38628e8" \
             APPLICATIONINSIGHTS_CONNECTION_STRING="InstrumentationKey=bca53de3-b103-4158-81d2-308290f81569;IngestionEndpoint=https://swedencentral-0.in.applicationinsights.azure.com/;LiveEndpoint=https://swedencentral.livediagnostics.monitor.azure.com/;ApplicationId=6cbfbec1-9f5a-4804-9ec9-743ca38628e8" \


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


echo "Listing the settings of the JVM webapp..."
echo "----------------------"
az webapp config appsettings list \
  --resource-group "$RESOURCE_GROUP" \
  --name "$QUARKUS_JVM_APP" \
  --output table

az webapp connection list \
  --resource-group "$RESOURCE_GROUP" \
  --name "$QUARKUS_JVM_APP"

echo "Stopping and tarting the JVM webapp..."
echo "----------------------"
az webapp stop \
  --resource-group "$RESOURCE_GROUP" \
  --name "$QUARKUS_JVM_APP"

az webapp start \
  --resource-group "$RESOURCE_GROUP" \
  --name "$QUARKUS_JVM_APP"


echo "Deleting the JAR webapp..."
echo "----------------------"
az webapp delete \
  --resource-group "$RESOURCE_GROUP" \
  --name "$QUARKUS_JVM_APP" \
  --keep-empty-plan


az webapp config appsettings set \
  --resource-group "$RESOURCE_GROUP" \
  --name "$QUARKUS_JVM_APP" \
  --settings ApplicationInsightsAgent_EXTENSION_VERSION="~3"


# This command adds the variables APPINSIGHTS_CONNECTIONSTRING (instead of APPLICATIONINSIGHTS_CONNECTION_STRING) and APPINSIGHTS_INSTRUMENTATIONKEY
az monitor app-insights component connect-webapp \
  --resource-group "$RESOURCE_GROUP" \
  --web-app "$QUARKUS_JVM_APP" \
  --app "$APP_INSIGHTS_QUARKUS_JVM_APP"


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
  --src-path /Users/agoncal/Documents/Code/AGoncal/agoncal-sample-azure-monitoring/quarkus-app/target/quarkus-app-1.0.0-SNAPSHOT-runner \
  --restart false

echo "Deploying the Startup script..."
echo "----------------------"
az webapp deploy \
  --resource-group "$RESOURCE_GROUP" \
  --name "$QUARKUS_NATIVE_APP" \
  --type startup \
  --src-path /Users/agoncal/Documents/Code/AGoncal/agoncal-sample-azure-monitoring/deployment/azure/startup.sh \
  --restart false

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
  --container-image-name "monitoringjavaruntimetoto/totoquarkus-ubi-jvm:latest" \
  --public-network-access "Enabled"

az webapp deploy \
  --resource-group "$RESOURCE_GROUP" \
  --name "$QUARKUS_CONTAINER_UBI_JVM_APP"

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
