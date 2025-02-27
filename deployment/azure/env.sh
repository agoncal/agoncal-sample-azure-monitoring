##############################################################################
# Usage: source env.sh
# Set all environment variables needed for the project.
# Following naming conventions https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations
##############################################################################

PROJECT="monitoringjavaruntimes"
RESOURCE_GROUP="rg-$PROJECT"
LOCATION="swedencentral"
TAG="$PROJECT"
UNIQUE_IDENTIFIER=${UNIQUE_IDENTIFIER:-${GITHUB_USER:-$(whoami)}}

# az postgres flexible-server list-skus --location "$LOCATION" --query "[].supportedServerVersions[].name" --output table
# az postgres flexible-server list-skus --location "$LOCATION" --output table
POSTGRES_DB="psql-$PROJECT"
POSTGRES_DB_SCHEMA="stats"
POSTGRES_DB_ADMIN="admin$PROJECT"
POSTGRES_DB_PWD="$PROJECT-p#ssw0rd-12046"
POSTGRES_DB_VERSION="17"
POSTGRES_SKU="Standard_B1ms"
POSTGRES_TIER="Burstable"
POSTGRES_DB_CONNECT_STRING="jdbc:postgresql://${POSTGRES_DB}.postgres.database.azure.com:5432/${POSTGRES_DB_SCHEMA}?ssl=true&sslmode=require"

# az cognitiveservices account list-skus --location "$LOCATION"
# az cognitiveservices account list-kinds
COGNITIVE_SERVICE="oai-$PROJECT"
AZURE_OPENAI_DEPLOYMENT_NAME="gpt-4o-mini-$PROJECT"

APP_SERVICE_PLAN="asp-$PROJECT"
QUARKUS_APP="quarkus-$PROJECT"


#LOG_ANALYTICS_WORKSPACE="log-$PROJECT"
#CONTAINERAPPS_ENVIRONMENT="cae-$PROJECT"
#
#echo "Using unique identifier is: $UNIQUE_IDENTIFIER"
#echo "You can override it by setting it manually before running this script:"
#echo "UNIQUE_IDENTIFIER=<your-unique-identifier>"
#
#REGISTRY="cr${PROJECT}"
#IMAGES_TAG="1.0"
#
#QUARKUS_APP="quarkus-app"
#MICRONAUT_APP="micronaut-app"
#SPRING_APP="springboot-app"
#
#LOG_ANALYTICS_WORKSPACE_CLIENT_ID=$(az monitor log-analytics workspace show  \
#  --resource-group "$RESOURCE_GROUP" \
#  --workspace-name "$LOG_ANALYTICS_WORKSPACE" \
#  --query customerId  \
#  --output tsv \
#  2>/dev/null | tr -d '[:space:]' \
#)
#
#LOG_ANALYTICS_WORKSPACE_CLIENT_SECRET=$(az monitor log-analytics workspace get-shared-keys \
#  --resource-group "$RESOURCE_GROUP" \
#  --workspace-name "$LOG_ANALYTICS_WORKSPACE" \
#  --query primarySharedKey \
#  --output tsv \
#  2>/dev/null | tr -d '[:space:]' \
#)
#
#REGISTRY_URL=$(az acr show \
#  --resource-group "$RESOURCE_GROUP" \
#  --name "$REGISTRY" \
#  --query "loginServer" \
#  --output tsv \
#  2>/dev/null \
#)
#
#QUARKUS_HOST=$(
#  az containerapp show \
#    --name "$QUARKUS_APP" \
#    --resource-group "$RESOURCE_GROUP" \
#    --query "properties.configuration.ingress.fqdn" \
#    --output tsv \
#    2>/dev/null \
#)
#
#MICRONAUT_HOST=$(
#  az containerapp show \
#    --name "$MICRONAUT_APP" \
#    --resource-group "$RESOURCE_GROUP" \
#    --query "properties.configuration.ingress.fqdn" \
#    --output tsv \
#    2>/dev/null \
#)
#
#SPRING_HOST=$(
#  az containerapp show \
#    --name "$SPRING_APP" \
#    --resource-group "$RESOURCE_GROUP" \
#    --query "properties.configuration.ingress.fqdn" \
#    --output tsv \
#    2>/dev/null \
#)
#
#echo "Exported environment variables for project '${PROJECT}'."
