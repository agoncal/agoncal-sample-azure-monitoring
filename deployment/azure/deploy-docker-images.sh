##############################################################################
# BUILDS AND DEPLOYS DOCKER IMAGES TO CONTAINER REGISTRY
##############################################################################


echo "Getting the Container Registry URL..."
echo "----------------------"
REGISTRY_URL=$(az acr show \
  --resource-group "$RESOURCE_GROUP" \
  --name "$CONTAINER_REGISTRY" \
  --query "loginServer" \
  --output tsv)

echo "REGISTRY_URL=$REGISTRY_URL"


echo "Logging into the Container Registry..."
echo "----------------------"
az acr login \
  --name "$CONTAINER_REGISTRY"


echo "Listing local Docker images..."
echo "----------------------"
docker image ls | grep $PROJECT


# JVM
#######
echo "Building the JVM Quarkus application..."
echo "----------------------"
mvn clean package -Dmaven.test.skip=true


echo "Building the Docker Images for JVM Quarkus application..."
echo "----------------------"
docker buildx build --platform=linux/amd64,linux/arm64 -f src/main/docker/Dockerfile-ubi.jvm     -t "${CONTAINER_QUARKUS_UBI_JVM_IMAGE}" .

# If you want to run the container locally
# docker run -i --rm -p 80:80 "${CONTAINER_QUARKUS_UBI_JVM_IMAGE}"
# docker run -i --rm -p 80:80 "${CONTAINER_QUARKUS_MARINER_JVM_IMAGE}"
# curl 'localhost:80/quarkus/load'
# curl 'localhost:80/quarkus/health'

echo "Tagging the Docker Image of the JVM Quarkus application for Azure Container Registry..."
echo "----------------------"
docker tag "${CONTAINER_QUARKUS_UBI_JVM_IMAGE}"      "${REGISTRY_URL}/${CONTAINER_QUARKUS_UBI_JVM_IMAGE}"


echo "Pushing the Docker Image to the Azure Container Registry..."
echo "----------------------"
docker push "${REGISTRY_URL}/${CONTAINER_QUARKUS_UBI_JVM_IMAGE}"
docker push "${REGISTRY_URL}/${CONTAINER_QUARKUS_MARINER_JVM_IMAGE}"


# NATIVE
##########
echo "Building the Native Quarkus application..."
echo "----------------------"
mvn clean install -Dnative -Dquarkus.native.container-build=true -Dmaven.test.skip=true

echo "Building the Docker Images for the Native Quarkus applications..."
echo "----------------------"
docker buildx build --platform=linux/amd64,linux/arm64 -f src/main/docker/Dockerfile-ubi.native       -t "${CONTAINER_QUARKUS_UBI_NATIVE_IMAGE}" .
docker buildx build --platform=linux/amd64,linux/arm64 -f src/main/docker/Dockerfile-ubi-micro.native -t "${CONTAINER_QUARKUS_UBI_MICRO_NATIVE_IMAGE}" .

# If you want to run the container locally
# docker run -i --rm -p 80:80 "${CONTAINER_QUARKUS_UBI_NATIVE_IMAGE}"
# docker run -i --rm -p 80:80 "${CONTAINER_QUARKUS_UBI_MICRO_NATIVE_IMAGE}"
# curl 'localhost:80/quarkus/load'
# curl 'localhost:80/quarkus/health'

echo "Tagging the Docker Image of the JVM Quarkus application for Azure Container Registry..."
echo "----------------------"
docker tag "${CONTAINER_QUARKUS_UBI_NATIVE_IMAGE}"        "${REGISTRY_URL}/${CONTAINER_QUARKUS_UBI_NATIVE_IMAGE}"
docker tag "${CONTAINER_QUARKUS_UBI_MICRO_NATIVE_IMAGE}"  "${REGISTRY_URL}/${CONTAINER_QUARKUS_UBI_MICRO_NATIVE_IMAGE}"


echo "Pushing the Docker Image to the Azure Container Registry..."
echo "----------------------"
docker push "${REGISTRY_URL}/${CONTAINER_QUARKUS_UBI_NATIVE_IMAGE}"
docker push "${REGISTRY_URL}/${CONTAINER_QUARKUS_UBI_MICRO_NATIVE_IMAGE}"
