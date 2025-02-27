##############################################################################
# Dependencies:
#   * Azure CLI
#   * deploy-environment.sh
##############################################################################

echo "Deploying the database..."
echo "----------------------"
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

echo "Executing the SQL script for the database..."
echo "----------------------"
az postgres flexible-server execute \
  --name "$POSTGRES_DB" \
  --admin-user "$POSTGRES_DB_ADMIN" \
  --admin-password "$POSTGRES_DB_PWD" \
  --database-name "$POSTGRES_DB_SCHEMA" \
  --file-path "../local/db-init/initialize-databases.sql"


echo "Storing the connection string in environment variables..."
echo "--------------------------------------------------------"
POSTGRES_CONNECTION_STRING=$(
  az postgres flexible-server show-connection-string \
    --server-name "$POSTGRES_DB" \
    --admin-user "$POSTGRES_DB_ADMIN" \
    --admin-password "$POSTGRES_DB_PWD" \
    --database-name "$POSTGRES_DB_SCHEMA" \
    --query "connectionStrings.jdbc" \
    --output tsv
)

echo "POSTGRES_CONNECTION_STRING=$POSTGRES_CONNECTION_STRING"
