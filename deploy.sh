#!/bin/bash

# Fehler stoppen
set -e

# Image-Namen und Tags
export IMAGE_BACKEND="mahbagci/todo-backend"
export IMAGE_FRONTEND="mahbagci/todo-frontend"
export IMAGE_TAG="1.0.0"

echo "🔍 Prüfe auf Änderungen im Git-Repo..."
CHANGED=$(git status --porcelain)

if [ -z "$CHANGED" ]; then
    echo "⚠️  Keine Änderungen – Build wird übersprungen."
    exit 0
fi

echo "📦 Änderungen erkannt – beginne Build..."

# 1. Backend bauen
echo "🔨 Baue Spring Boot Backend mit Maven..."
cd backend
./mvnw clean package || mvn clean package
cd ..

# 2. Docker-Images bauen
echo "🐳 Baue Docker-Images..."
docker build -t $IMAGE_BACKEND:latest ./backend
docker build -t $IMAGE_FRONTEND:latest ./frontend

# 3. Tagging
docker tag $IMAGE_BACKEND:latest $IMAGE_BACKEND:$IMAGE_TAG
docker tag $IMAGE_FRONTEND:latest $IMAGE_FRONTEND:$IMAGE_TAG

# 4. Push zu Docker Hub
echo "⬆️  Pushe Docker-Images..."
docker push $IMAGE_BACKEND:latest
docker push $IMAGE_BACKEND:$IMAGE_TAG
docker push $IMAGE_FRONTEND:latest
docker push $IMAGE_FRONTEND:$IMAGE_TAG

# 5. Kubernetes anwenden (YAMLs)
echo "☸️  Wende Kubernetes Deployments an..."
kubectl apply -f backend/backend.yaml
kubectl apply -f frontend/frontend.yaml

# 6. Rolling Update mit neuen Images
echo "🔄 Kubernetes Rolling Update..."
kubectl set image deployment/backend-deployment backend=$IMAGE_BACKEND:$IMAGE_TAG
kubectl set image deployment/frontend-deployment frontend=$IMAGE_FRONTEND:$IMAGE_TAG

echo "✅ Deployment abgeschlossen."
