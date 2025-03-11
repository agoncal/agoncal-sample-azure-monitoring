#!/usr/bin/env bash

### #################################################################
### This script is used to bootstrap the environment for the workshop
### #################################################################


echo "### Removes all the generated files from the project"
rm -rf pom.xml \
  quarkus-app \
  micronaut-app \
  springboot-app \
  tomcat-app \
  jboss-app \
  commons

echo "### Bootstraps the Common App"
mvn archetype:generate "-DgroupId=io.azure.monitoring.javaruntime" "-DartifactId=commons" "-DarchetypeArtifactId=maven-archetype-quickstart" "-DarchetypeVersion=1.5" "-Dversion=1.0.0-SNAPSHOT" -DjavaCompilerVersion=21 -DinteractiveMode=false
mvn archetype:generate "-DgroupId=io.azure.monitoring.javaruntime" "-DartifactId=tomcat-app" "-DarchetypeArtifactId=maven-archetype-quickstart" "-DarchetypeVersion=1.5" "-Dversion=1.0.0-SNAPSHOT" -DjavaCompilerVersion=21 -DinteractiveMode=false
mvn archetype:generate "-DgroupId=io.azure.monitoring.javaruntime" "-DartifactId=jboss-app" "-DarchetypeArtifactId=maven-archetype-quickstart" "-DarchetypeVersion=1.5" "-Dversion=1.0.0-SNAPSHOT" -DjavaCompilerVersion=21 -DinteractiveMode=false

echo "### Bootstraps the Micronaut App"
curl --location --request GET 'https://launch.micronaut.io/create/default/io.azure.monitoring.javaruntime.micronaut.micronaut-app?lang=JAVA&build=MAVEN&test=JUNIT&javaVersion=JDK_21&features=data-jpa&features=postgres&features=testcontainers&features=micronaut-test-rest-assured' --output micronaut-app.zip && unzip -o micronaut-app.zip && rm micronaut-app.zip

echo "### Bootstraps the Quarkus App"
mvn io.quarkus:quarkus-maven-plugin:3.19.2:create \
    -DplatformVersion=3.19.2 \
    -DprojectGroupId=io.azure.monitoring.javaruntime \
    -DprojectArtifactId=quarkus-app \
    -DprojectName="Azure Container Apps and Java Runtimes Workshop :: Quarkus" \
    -DjavaVersion=21 \
    -DclassName="io.azure.monitoring.javaruntime.quarkus.QuarkusResource" \
    -Dpath="/quarkus" \
    -Dextensions="resteasy, resteasy-jsonb, hibernate-orm-panache, jdbc-postgresql"

echo "### Bootstraps the Spring Boot App"
curl https://start.spring.io/starter.tgz  -d bootVersion=3.4.3 -d javaVersion=21 -d dependencies=web,data-jpa,postgresql,testcontainers -d type=maven-project -d packageName=io.azure.monitoring.javaruntime.springboot -d artifactId=springboot-app -d version=1.0.0-SNAPSHOT -d baseDir=springboot-app -d name=springboot -d groupId=io.azure.monitoring.javaruntime -d description=Azure%20Container%20Apps%20and%20Java%20Runtimes%20Workshop%20%3A%3A%20Spring%20Boot | tar -xzvf -

echo "### Creates a Parent POM"
echo -e "<?xml version=\"1.0\"?>
<project xsi:schemaLocation=\"http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd\"
         xmlns=\"http://maven.apache.org/POM/4.0.0\"
         xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
  <modelVersion>4.0.0</modelVersion>
  <groupId>io.azure.monitoring.javaruntime</groupId>
  <artifactId>parent</artifactId>
  <version>1.0.0-SNAPSHOT</version>
  <packaging>pom</packaging>
  <name>Monitoring Java Runtimes on Azure</name>

  <modules>
    <module>commons</module>
    <module>jboss-app</module>
    <module>micronaut-app</module>
    <module>quarkus-app</module>
    <module>springboot-app</module>
    <module>tomcat-app</module>
  </modules>

</project>
" >> pom.xml


echo "### Adding .editorconfig file"
echo -e "# EditorConfig helps developers define and maintain consistent
# coding styles between different editors and IDEs
# editorconfig.org

root = true

[*]

# We recommend you to keep these unchanged
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true

# Change these settings to your own preference
indent_style = space
indent_size = 2

[*.java]
indent_size = 4

[*.md]
trim_trailing_whitespace = false
max_line_length = 1024
" >> .editorconfig

echo "### Compile code and tests"
mvn test-compile
