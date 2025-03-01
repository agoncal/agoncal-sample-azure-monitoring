#!/usr/bin/env bash
##############################################################################
# Dependencies: curl
##############################################################################

while true; do
  curl 'quarkus-monitoringjavaruntimes.azurewebsites.net/quarkus'
  echo
  sleep 1

  curl 'quarkus-monitoringjavaruntimes.azurewebsites.net/quarkus/load'
  echo
  sleep 1

  curl 'quarkus-monitoringjavaruntimes.azurewebsites.net/quarkus/load?cpu=10'
  echo
  sleep 1

  curl 'quarkus-monitoringjavaruntimes.azurewebsites.net/quarkus/load?cpu=10&memory=20'
  echo
  sleep 1

  curl 'quarkus-monitoringjavaruntimes.azurewebsites.net/quarkus/load?cpu=50&memory=50&db=true'
  echo
  sleep 1

  curl 'quarkus-monitoringjavaruntimes.azurewebsites.net/quarkus/load?cpu=100&memory=100&db=true'
  echo
  sleep 1

  curl 'quarkus-monitoringjavaruntimes.azurewebsites.net/quarkus/load?cpu=10&memory=20&db=true&llm=true'
  echo
  sleep 1
done
