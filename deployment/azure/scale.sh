#!/usr/bin/env bash
##############################################################################
# Dependencies: curl
##############################################################################

# URL=quarkus-jvm-monitoringjava.azurewebsites.net/quarkus
URL=quarkus-container-ubi-jvm-monitoringjava.azurewebsites.net/quarkus

while true; do
  curl "$URL"
  echo
  sleep 1

  curl "$URL/load"
  echo
  sleep 1

  curl "$URL/load?cpu=10"
  echo
  sleep 1

  curl "$URL/load?cpu=10&memory=20"
  echo
  sleep 1

  curl "$URL/load?cpu=50&memory=50&db=true"
  echo
  sleep 1

  curl "$URL/load?cpu=100&memory=100&db=true"
  echo
  sleep 1

  curl "$URL/load?cpu=10&memory=20&db=true&llm=true"
  echo
  sleep 1
done
