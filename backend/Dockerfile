# backend/Dockerfile

# Nutze OpenJDK 17
FROM openjdk:17-jdk-slim

# Arbeitsverzeichnis
WORKDIR /app

# Kopiere Maven-Build-Output (JAR-Datei)
COPY target/*.jar app.jar

# Anwendung starten
ENTRYPOINT ["java", "-jar", "app.jar"]

# Exponiere Backend-Port
EXPOSE 8080
