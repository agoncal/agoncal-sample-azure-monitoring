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

## Run the Code

Since native apps are built for the machine it runs on, make sure you execute this on a unix machine.
## Local

### Quarkus

```shell
mvn test                          # Execute the tests

mvn quarkus:dev                   # Execute the application

curl 'localhost:8701/quarkus'
curl 'localhost:8701/quarkus/load'
curl 'localhost:8701/quarkus/load?cpu=10'
curl 'localhost:8701/quarkus/load?cpu=10&memory=20&db=true&llm=true'
curl 'localhost:8701/quarkus/stats' | jq
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





