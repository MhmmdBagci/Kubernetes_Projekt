#!/bin/bash

# Stoppe das Skript bei Fehlern
set -e

# Umgebungsvariablen für Docker Hub und Tags
export IMAGE_BACKEND="mahbagci/todo-backend"
export IMAGE_FRONTEND="mahbagci/todo-frontend"
export IMAGE_TAG="1.0.0"

echo "🔍 Prüfe auf Änderungen..."

# Prüfe auf lokale Änderungen im Git-Repo
CHANGED=$(git status --porcelain)

if [ -z "$CHANGED" ]; then
    echo "⚠️  Keine Änderungen gefunden – Build & Deployment wird übersprungen."
    exit 0
fi

echo "📦 Änderungen gefunden – beginne mit Build und Deployment..."

# 1. Spring Boot Projekt bauen
echo "🔨 Baue das Backend mit Maven..."
cd backend
./mvnw clean package || mvn clean package
cd ..

# 2. Docker Compose: stoppe alte Container und baue neue Images
echo "🐳 Baue Docker-Images mit Docker Compose..."
docker compose down
docker compose build
docker compose up -d

# 3. Docker-Images taggen mit Version
docker tag $IMAGE_BACKEND:latest $IMAGE_BACKEND:$IMAGE_TAG
docker tag $IMAGE_FRONTEND:latest $IMAGE_FRONTEND:$IMAGE_TAG

# 4. Images zu Docker Hub pushen
echo "⬆️  Pushe Docker-Images zu Docker Hub..."
docker push $IMAGE_BACKEND:latest
docker push $IMAGE_BACKEND:$IMAGE_TAG
docker push $IMAGE_FRONTEND:latest
docker push $IMAGE_FRONTEND:$IMAGE_TAG

# 5. Kubernetes Deployments & Services anwenden
echo "☸️  Wende Kubernetes YAMLs an..."
kubectl apply -f backend/backend.yaml
kubectl apply -f frontend/frontend.yaml

# 6. Kubernetes: Setze neue Image-Versionen (Rolling Update)
echo "🔄 Aktualisiere Kubernetes-Deployments mit neuen Images..."
kubectl set image deployment/backend-deployment backend=$IMAGE_BACKEND:$IMAGE_TAG
kubectl set image deployment/frontend-deployment frontend=$IMAGE_FRONTEND:$IMAGE_TAG

echo "✅ Deployment abgeschlossen."
