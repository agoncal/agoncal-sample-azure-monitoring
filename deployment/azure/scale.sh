#!/usr/bin/env bash
##############################################################################
# Dependencies:
#   * Azure CLI
#   * env.sh
##############################################################################

curl 'quarkus-monitoringjavaruntimes.azurewebsites.net/quarkus'
echo
curl 'quarkus-monitoringjavaruntimes.azurewebsites.net/quarkus/load'
echo
curl 'quarkus-monitoringjavaruntimes.azurewebsites.net/quarkus/load?cpu=10'
echo
curl 'quarkus-monitoringjavaruntimes.azurewebsites.net/quarkus/load?cpu=10&memory=20'
echo
curl 'quarkus-monitoringjavaruntimes.azurewebsites.net/quarkus/load?cpu=50&memory=50&db=true'
echo
curl 'quarkus-monitoringjavaruntimes.azurewebsites.net/quarkus/load?cpu=100&memory=100&db=true'
echo
curl 'quarkus-monitoringjavaruntimes.azurewebsites.net/quarkus/load?cpu=10&memory=20&db=true&llm=true'


