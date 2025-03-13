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
APPSERVICE_PLAN="asp-$PROJECT"
APPSERVICE_QUARKUS_JVM_APP="app-quarkus-jvm"
APPSERVICE_QUARKUS_NATIVE_APP="app-quarkus-native"
APPSERVICE_QUARKUS_UBI_JVM_APP="app-quarkus-ubi-jvm"
APPSERVICE_QUARKUS_UBI_NATIVE_APP="app-quarkus-ubi-native"
APPSERVICE_QUARKUS_UBI_MICRO_NATIVE_APP="app-quarkus-ubi-micro-native"

# ACA
CONTAINERAPPS_ENVIRONMENT="cae-$PROJECT"
CONTAINERAPPS_QUARKUS_UBI_JVM_APP="ca-quarkus-ubi-jvm"
CONTAINERAPPS_QUARKUS_UBI_NATIVE_APP="ca-quarkus-ubi-native"
CONTAINERAPPS_QUARKUS_UBI_MICRO_NATIVE_APP="ca-quarkus-ubi-micro-native"

# Log Analytics
LOG_ANALYTICS_WORKSPACE="log-$PROJECT"


# App Insights
APP_INSIGHTS_APPSERVICE_QUARKUS_JVM_APP="appi-$APPSERVICE_QUARKUS_JVM_APP"
APP_INSIGHTS_APPSERVICE_QUARKUS_NATIVE_APP="appi-$APPSERVICE_QUARKUS_NATIVE_APP"
APP_INSIGHTS_APPSERVICE_QUARKUS_UBI_JVM_APP="appi-$APPSERVICE_QUARKUS_UBI_JVM_APP"
APP_INSIGHTS_APPSERVICE_QUARKUS_UBI_NATIVE_APP="appi-$APPSERVICE_QUARKUS_UBI_NATIVE_APP"
APP_INSIGHTS_APPSERVICE_QUARKUS_UBI_MICRO_NATIVE_APP="appi-$APPSERVICE_QUARKUS_UBI_MICRO_NATIVE_APP"


# Container Registry
CONTAINER_REGISTRY="cr$PROJECT"


# Docker Images
IMAGES_TAG="latest"
CONTAINER_QUARKUS_UBI_JVM_IMAGE="${PROJECT}/quarkus-ubi-jvm:${IMAGES_TAG}"
CONTAINER_QUARKUS_UBI_NATIVE_IMAGE="${PROJECT}/quarkus-ubi-native:${IMAGES_TAG}"
CONTAINER_QUARKUS_UBI_MICRO_NATIVE_IMAGE="${PROJECT}/quarkus-ubi-micro-native:${IMAGES_TAG}"

