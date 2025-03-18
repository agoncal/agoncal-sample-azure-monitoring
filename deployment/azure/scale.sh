#!/usr/bin/env bash
##############################################################################
# Dependencies: curl
##############################################################################

#URL=app-quarkus-ubi-jvm.azurewebsites.net/quarkus
# URL=app-quarkus-jvm.azurewebsites.net/quarkus
# URL=app-quarkus-ubi-native.azurewebsites.net/quarkus
# URL=https://ca-quarkus-ubi-jvm.wonderfulground-be1df78e.swedencentral.azurecontainerapps.io/quarkus
#URL=https://app-quarkus-ubi-native.azurewebsites.net/quarkus
URL1=https://app-quarkus-ubuntu-native.azurewebsites.net/quarkus
URL2=https://monit-app-quarkus-ubuntu-native.azurewebsites.net/quarkus
DESC1=Native
DESC2=NativeOTLP

while true; do
  curl "$URL1"
  echo
  curl "$URL2"
  echo
  sleep 1

  curl "$URL1/load?desc=$DESC1"
  echo
  curl "$URL2/load?desc=$DESC2"
  echo
  sleep 1

  curl "$URL1/load?cpu=10&desc=$DESC1"
  echo
  curl "$URL2/load?cpu=10&desc=$DESC2"
  echo
  sleep 1

  curl "$URL1/load?cpu=10&memory=20&desc=$DESC1"
  echo
  curl "$URL2/load?cpu=10&memory=20&desc=$DESC2"
  echo
  sleep 1

  curl "$URL1/load?cpu=50&memory=50&db=true&desc=$DESC1"
  echo
  curl "$URL2/load?cpu=50&memory=50&db=true&desc=$DESC2"
  echo
  sleep 1

  curl "$URL1/load?cpu=100&memory=100&db=true&desc=$DESC1"
  echo
  curl "$URL2/load?cpu=100&memory=100&db=true&desc=$DESC2"
  echo
  sleep 1

  curl "$URL1/load?cpu=10&memory=20&db=true&llm=true&desc=$DESC1"
  echo
  curl "$URL2/load?cpu=10&memory=20&db=true&llm=true&desc=$DESC2"
  echo
  sleep 1
done
