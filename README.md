# Monitoring Java Applications on Azure

# Telemetry for GraalVM native images

This repository contains code demonstrating how to enable Monitor Java applications for JVM and GraalVM native images on:

* Azure AppServices
* Azure Container Apps
* Azure Functions

It uses several Java frameworks:

* Spring Boot
* Quarkus
* Micronaut

## Quarkus

### Local Development with DevServices

```shell
mvn test                          # Execute the tests

mvn quarkus:dev                   # Execute the application

curl 'localhost:8701/quarkus'
curl 'localhost:80/quarkus/load'
curl 'localhost:8701/quarkus/load?cpu=10'
curl 'localhost:8701/quarkus/load?cpu=10&memory=20&db=true&llm=true'
curl 'localhost:8701/quarkus/stats' | jq
```

### Local Development with Docker

To build a Fat-Jar version of the application to use with a local database:

```shell
mvn clean package -Dquarkus.package.jar.type=uber-jar -Dmaven.test.skip=true
docker compose -f deployment/local/postgres.yaml up
java -jar target/quarkus-app-1.0.0-SNAPSHOT-runner.jar
```

To use a remote database deployed on Azure just override the JDBC URL.
Make sure you export the `QUARKUS_LANGCHAIN4J_OPENAI_API_KEY` environment variable to your OpenAI API key.
Port 80 is used by default:

```shell
mvn clean package -Dquarkus.package.jar.type=uber-jar -Dmaven.test.skip=true
java -Dquarkus.datasource.jdbc.url="$POSTGRES_CONNECTION_STRING" -jar target/quarkus-app-1.0.0-SNAPSHOT-runner.jar

curl 'localhost:8701/quarkus'
curl 'localhost:8701/quarkus/load'
curl 'localhost:8701/quarkus/load?cpu=10'
curl 'localhost:8701/quarkus/load?cpu=10&memory=20&db=true&llm=true'
curl 'localhost:8701/quarkus/stats' | jq
curl 'localhost:8701/quarkus/health'
```

### Local Development - Quarkus Native

To build a native application (you need GraalVM installed and `GRAALVM_HOME` set) for you local machine:

```shell
mvn -Pnative clean package -Dmaven.test.skip=true

./target/quarkus-app-1.0.0-SNAPSHOT-runner -Dquarkus.datasource.jdbc.url="$POSTGRES_CONNECTION_STRING"

curl 'localhost:8701/quarkus/load?cpu=10&memory=20&db=true&llm=true&desc=GraalVM'
```

### Azure AppServices - Quarkus JVM

When the application is deployed to Azure AppServices, the following properties have to be overriden:

* `QUARKUS_HTTP_PORT`
* `QUARKUS_LANGCHAIN4J_OPENAI_API_KEY`
* `QUARKUS_DATASOURCE_JDBC_URL`

```shell
mvn clean package -Dquarkus.package.jar.type=uber-jar -Dmaven.test.skip=true

az webapp create ...
az webapp config appsettings set ...
az webapp deploy ...
az webapp start ...

curl 'quarkus-jvm-monitoringjava.azurewebsites.net/quarkus'
curl 'quarkus-jvm-monitoringjava.azurewebsites.net/quarkus/load'
curl 'quarkus-jvm-monitoringjava.azurewebsites.net/quarkus/load?cpu=10'
curl 'quarkus-jvm-monitoringjava.azurewebsites.net/quarkus/load?cpu=10&memory=20&db=true&llm=true'
curl 'quarkus-jvm-monitoringjava.azurewebsites.net/quarkus/stats' | jq

```

### Azure AppServices - Quarkus Native

To build a native application for a Linux machine:

```shell
mvn install -Dnative -Dquarkus.native.container-build=true -Dmaven.test.skip=true

curl 'quarkus-monitoringjavaruntimes.azurewebsites.net/quarkus'
curl 'quarkus-monitoringjavaruntimes.azurewebsites.net/quarkus/load'
curl 'quarkus-monitoringjavaruntimes.azurewebsites.net/quarkus/load?cpu=10'
curl 'quarkus-monitoringjavaruntimes.azurewebsites.net/quarkus/load?cpu=10&memory=20&db=true&llm=true'
curl 'quarkus-monitoringjavaruntimes.azurewebsites.net/quarkus/stats' | jq
```

### Azure AppServices - Docker

There are several choices to deploy a Quarkus application to Azure AppServices using Docker, and therefore, several Dockerfiles to choose from:

* `Dockerfile-mariner-distroless.jvm`
* `Dockerfile-mariner.jvm`
* `Dockerfile-quarkus-micro.native`
* `Dockerfile-ubi.jvm`
* `Dockerfile-ubi.native`

To build a Docker image with the JVM version of the application, you first need to build the application with:

To build a Docker image with the native application (you need to build the native image on Linux):

```shell
docker build -t quarkus-app-native -f src/main/docker/Dockerfile.native .
```

### Micronaut

```shell
mvn test                          # Execute the tests

docker compose -f deployment/local/postgres.yaml up
mvn mn:run                        # Execute the application

curl 'localhost:8702/micronaut'
curl 'localhost:8702/micronaut/load'
curl 'localhost:8702/micronaut/load?cpu=10'
curl 'localhost:8702/micronaut/load?cpu=10&memory=20&db=true&llm=true'
curl 'localhost:8702/micronaut/stats' | jq

```

### Spring Boot

```shell
mvn test                          # Execute the tests

docker compose -f deployment/local/postgres.yaml up
mvn spring-boot:run               # Execute the application

curl 'localhost:8703/springboot'
curl 'localhost:8703/springboot/load'
curl 'localhost:8703/springboot/load?cpu=10'
curl 'localhost:8703/springboot/load?cpu=10&memory=20&db=true&llm=true'
curl 'localhost:8703/springboot/stats' | jq
```





