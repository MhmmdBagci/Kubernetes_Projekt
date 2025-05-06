#!/bin/bash

# Farben für die Ausgabe (optional, schön lesbar)
GREEN="\033[0;32m"
NC="\033[0m" # No Color

echo -e "${GREEN}🔧 Starte automatisierten Build & Deploy-Prozess...${NC}"

# Backend mit Maven bauen
echo -e "${GREEN}📦 Baue Spring Boot Backend mit Maven...${NC}"
cd backend
./mvnw clean package -DskipTests || mvn clean package -DskipTests
cd ..

# Baue Docker-Images
echo -e "${GREEN}🐳 Baue Docker-Images für Frontend & Backend...${NC}"
docker build -t mahbagci/todo-backend:latest ./backend
docker build -t mahbagci/todo-frontend:latest ./frontend

# Push zu Docker Hub
echo -e "${GREEN}⬆️  Pushe Images zu Docker Hub...${NC}"
docker push mahbagci/todo-backend:latest
docker push mahbagci/todo-frontend:latest

# Kubernetes YAMLs anwenden
echo -e "${GREEN}☸️  Wende Kubernetes Konfigurationen an...${NC}"
kubectl apply -f backend.yaml
kubectl apply -f frontend.yaml

echo -e "${GREEN}✅ Deployment abgeschlossen!${NC}"
