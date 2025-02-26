##############################################################################
# Dependencies:
#   * Azure CLI
#   * deploy-environment.sh
##############################################################################

echo "Creating the Cognitive Service..."
echo "---------------------------------"
az cognitiveservices account create \
  --name "$COGNITIVE_SERVICE" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --tags system="$TAG" \
  --kind "OpenAI" \
  --sku "S0" \
  --yes

# To know which models are available, run:
az cognitiveservices account list-models \
  --name "$COGNITIVE_SERVICE" \
  --resource-group "$RESOURCE_GROUP" \
  --output table

echo "Deploying the model..."
echo "----------------------"
az cognitiveservices account deployment create \
  --name "$COGNITIVE_SERVICE" \
  --resource-group "$RESOURCE_GROUP" \
  --deployment-name "$COGNITIVE_DEPLOYMENT" \
  --model-name "gpt-4o-mini" \
  --model-version "2024-07-18"  \
  --model-format "OpenAI" \
  --sku-capacity 1 \
  --sku-name "Standard"

echo "Getting the model..."
echo "--------------------"
az cognitiveservices account deployment show \
  --name "$COGNITIVE_SERVICE" \
  --resource-group "$RESOURCE_GROUP" \
  --deployment-name "$COGNITIVE_DEPLOYMENT"


echo "Storing the key and endpoint in environment variables..."
echo "--------------------------------------------------------"
AZURE_OPENAI_KEY=$(
  az cognitiveservices account keys list \
    --name "$COGNITIVE_SERVICE" \
    --resource-group "$RESOURCE_GROUP" \
    | jq -r .key1
  )
AZURE_OPENAI_ENDPOINT=$(
  az cognitiveservices account show \
    --name "$COGNITIVE_SERVICE" \
    --resource-group "$RESOURCE_GROUP" \
    | jq -r .properties.endpoint
  )

echo "AZURE_OPENAI_KEY=$AZURE_OPENAI_KEY"
echo "AZURE_OPENAI_ENDPOINT=$AZURE_OPENAI_ENDPOINT"
echo "AZURE_OPENAI_DEPLOYMENT_NAME=$AZURE_OPENAI_DEPLOYMENT_NAME"
