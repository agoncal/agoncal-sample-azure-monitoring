#!/usr/bin/env bash
##############################################################################
# Dependencies: curl
##############################################################################

#URL=app-quarkus-ubi-jvm.azurewebsites.net/quarkus
# URL=app-quarkus-jvm.azurewebsites.net/quarkus
# URL=app-quarkus-ubi-native.azurewebsites.net/quarkus
# URL=https://ca-quarkus-ubi-jvm.wonderfulground-be1df78e.swedencentral.azurecontainerapps.io/quarkus
#URL=https://app-quarkus-ubi-native.azurewebsites.net/quarkus
URL=https://app-quarkus-ubuntu-native.azurewebsites.net/quarkus
MODE=Native
#MODE=JVM

while true; do
  curl "$URL"
  echo
  sleep 1

  curl "$URL/load?desc=$MODE"
  echo
  sleep 1

  curl "$URL/load?cpu=10&desc=$MODE"
  echo
  sleep 1

  curl "$URL/load?cpu=10&memory=20&desc=$MODE"
  echo
  sleep 1

  curl "$URL/load?cpu=50&memory=50&db=true&desc=$MODE"
  echo
  sleep 1

  curl "$URL/load?cpu=100&memory=100&db=true&desc=$MODE"
  echo
  sleep 1

  curl "$URL/load?cpu=10&memory=20&db=true&llm=true&desc=$MODE"
  echo
  sleep 1
done
