##############################################################################
# APP SERVICE: QUARKUS JVM APP
##############################################################################

# Build the Quarkus application
mvn clean package -Dquarkus.package.jar.type=uber-jar -Dmaven.test.skip=true


# To get all the available runtimes az webapp list-runtimes --os-type linux
echo "Creating the JAR webapp..."
echo "----------------------"
az webapp create \
  --resource-group "$RESOURCE_GROUP" \
  --tags system="$TAG" \
  --name "$APPSERVICE_QUARKUS_JVM_APP" \
  --plan "$APPSERVICE_PLAN" \
  --runtime "JAVA:21-java21" \
  --public-network-access "Enabled"


echo "Setting the configuration of the JAR webapp..."
echo "----------------------"
az webapp config appsettings set \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APPSERVICE_QUARKUS_JVM_APP" \
  --settings QUARKUS_HTTP_PORT="80" \
             QUARKUS_DATASOURCE_JDBC_URL="$POSTGRES_DB_CONNECT_STRING" \
             QUARKUS_LANGCHAIN4J_OPENAI_API_KEY="$OPENAI_API_KEY"

az webapp config appsettings set \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APPSERVICE_QUARKUS_JVM_APP" \
  --settings ApplicationInsightsAgent_EXTENSION_VERSION="~3" \
             XDT_MicrosoftApplicationInsights_Mode="recommended" \
             APPINSIGHTS_PROFILERFEATURE_VERSION="1.0.0" \
             DiagnosticServices_EXTENSION_VERSION="~3" \
             APPINSIGHTS_SNAPSHOTFEATURE_VERSION="1.0.0" \
             SnapshotDebugger_EXTENSION_VERSION="disabled" \
             InstrumentationEngine_EXTENSION_VERSION="disabled" \
             XDT_MicrosoftApplicationInsights_BaseExtensions="disabled" \
             XDT_MicrosoftApplicationInsights_PreemptSdk="disabled" \
             APPLICATIONINSIGHTS_CONFIGURATION_CONTENT=""

echo "Setting up the Health Check..."
echo "----------------------"
az webapp config set \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APPSERVICE_QUARKUS_JVM_APP" \
  --generic-configurations '{"healthCheckPath": "/quarkus/health/"}'

az monitor metrics list \
  --resource-group "$RESOURCE_GROUP" \
  --resource "$APPSERVICE_QUARKUS_JVM_APP" \
  --resource-type "Microsoft.Web/sites" \
  --metric "HealthCheckStatus" \
  --interval 5m

# Build the Uber JAR with mvn clean package -Dquarkus.package.jar.type=uber-jar -Dmaven.test.skip=true
# java -jar target/quarkus-app-1.0.0-SNAPSHOT-runner.jar
# curl 'localhost:8701/quarkus/load'

echo "Deploying the JAR webapp..."
echo "----------------------"
az webapp deploy \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APPSERVICE_QUARKUS_JVM_APP" \
  --type jar \
  --src-path /Users/agoncal/Documents/Code/AGoncal/agoncal-sample-azure-monitoring/quarkus-app/target/quarkus-app-1.0.0-SNAPSHOT-runner.jar

echo "Get the URL of the JAR webapp..."
echo "----------------------"
az webapp show \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APPSERVICE_QUARKUS_JVM_APP" \
  --output tsv --query defaultHostName


echo "Listing the settings of the JVM webapp..."
echo "----------------------"
az webapp config appsettings list \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APPSERVICE_QUARKUS_JVM_APP" \
  --output table

az webapp connection list \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APPSERVICE_QUARKUS_JVM_APP"

echo "Stopping and tarting the JVM webapp..."
echo "----------------------"
az webapp stop \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APPSERVICE_QUARKUS_JVM_APP"

az webapp start \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APPSERVICE_QUARKUS_JVM_APP"


echo "Deleting the JVM webapp..."
echo "----------------------"
az webapp delete \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APPSERVICE_QUARKUS_JVM_APP" \
  --keep-empty-plan


az webapp config appsettings set \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APPSERVICE_QUARKUS_JVM_APP" \
  --settings ApplicationInsightsAgent_EXTENSION_VERSION="~3"


# This command adds the variables APPINSIGHTS_CONNECTIONSTRING (instead of APPLICATIONINSIGHTS_CONNECTION_STRING) and APPINSIGHTS_INSTRUMENTATIONKEY
az monitor app-insights component connect-webapp \
  --resource-group "$RESOURCE_GROUP" \
  --web-app "$APPSERVICE_QUARKUS_JVM_APP" \
  --app "$APP_INSIGHTS_APPSERVICE_QUARKUS_JVM_APP"
