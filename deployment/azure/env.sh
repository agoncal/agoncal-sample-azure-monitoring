##############################################################################
# Usage: source env.sh
# Set all environment variables needed for the project.
# Following naming conventions https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations
##############################################################################

PROJECT="monitoringjava"
RESOURCE_GROUP="rg-$PROJECT"
LOCATION="swedencentral"
TAG="$PROJECT"

# Postgre Flexible Server
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

# App Service
APP_SERVICE_PLAN="asp-$PROJECT"

# Quarkus
QUARKUS_JVM_APP="quarkus-jvm-$PROJECT"
QUARKUS_NATIVE_APP="quarkus-native-$PROJECT"

QUARKUS_CONTAINER_UBI_JVM_IMAGE="quarkus-ubi-jvm"
QUARKUS_CONTAINER_UBI_JVM_APP="quarkus-container-ubi-jvm-$PROJECT"

QUARKUS_CONTAINER_UBI_NATIVE_IMAGE="quarkus-ubi-native"
QUARKUS_CONTAINER_UBI_NATIVE_APP="quarkus-container-ubi-native-$PROJECT"

QUARKUS_CONTAINER_MICRO_NATIVE_APP="quarkus-container-micro-native-$PROJECT"
QUARKUS_CONTAINER_MARINER_JVM_APP="quarkus-container-mariner-jvm-$PROJECT"
QUARKUS_CONTAINER_MARINER_DISTROLESS_APP="quarkus-container-mariner-distroless-$PROJECT"


# Log Analytics
LOG_ANALYTICS_QUARKUS_JVM_APP="log-quarkus-jvm-$PROJECT"
LOG_ANALYTICS_QUARKUS_NATIVE_APP="log-quarkus-native-$PROJECT"
LOG_ANALYTICS_QUARKUS_CONTAINER_UBI_JVM_APP="log-quarkus-container-ubi-jvm-$PROJECT"
LOG_ANALYTICS_QUARKUS_CONTAINER_UBI_NATIVE_APP="log-quarkus-container-ubi-native-$PROJECT"
LOG_ANALYTICS_QUARKUS_CONTAINER_MICRO_NATIVE_APP="log-quarkus-container-micro-native-$PROJECT"
LOG_ANALYTICS_QUARKUS_CONTAINER_MARINER_JVM_APP="log-quarkus-container-mariner-jvm-$PROJECT"
LOG_ANALYTICS_QUARKUS_CONTAINER_MARINER_DISTROLESS_APP="log-quarkus-container-mariner-distroless-$PROJECT"


# App Insights
APP_INSIGHTS_QUARKUS_JVM_APP="appi-quarkus-jvm-$PROJECT"
APP_INSIGHTS_QUARKUS_NATIVE_APP="appi-quarkus-native-$PROJECT"
APP_INSIGHTS_QUARKUS_CONTAINER_UBI_JVM_APP="appi-quarkus-container-ubi-jvm-$PROJECT"
APP_INSIGHTS_QUARKUS_CONTAINER_UBI_NATIVE_APP="appi-quarkus-container-ubi-native-$PROJECT"
APP_INSIGHTS_QUARKUS_CONTAINER_MICRO_NATIVE_APP="appi-quarkus-container-micro-native-$PROJECT"
APP_INSIGHTS_QUARKUS_CONTAINER_MARINER_JVM_APP="appi-quarkus-container-mariner-jvm-$PROJECT"
APP_INSIGHTS_QUARKUS_CONTAINER_MARINER_DISTROLESS_APP="appi-quarkus-container-mariner-distroless-$PROJECT"


# Container Registry
CONTAINER_REGISTRY="cr$PROJECT"
IMAGES_TAG="latest"
