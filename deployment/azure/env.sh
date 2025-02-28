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
QUARKUS_JAR_APP="quarkus-jar-$PROJECT"
QUARKUS_NATIVE_APP="quarkus-native-$PROJECT"


