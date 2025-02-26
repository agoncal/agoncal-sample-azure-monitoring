##############################################################################
# Dependencies:
#   * Azure CLI
#   * deploy-environment.sh
##############################################################################

az postgres flexible-server create \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --tags system="$TAG" \
  --name "$POSTGRES_DB" \
  --database-name "$POSTGRES_DB_SCHEMA" \
  --admin-user "$POSTGRES_DB_ADMIN" \
  --admin-password "$POSTGRES_DB_PWD" \
  --public-access "All" \
  --tier "$POSTGRES_TIER" \
  --sku-name "$POSTGRES_SKU" \
  --storage-size 32 \
  --version "$POSTGRES_DB_VERSION"
