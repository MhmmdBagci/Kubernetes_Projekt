#!/bin/bash
set -e

# Docker Hub Login mit Umgebungsvariablen aus Jenkins
echo "🔐 Versuche Docker Login mit Jenkins Credentials..."
if ! echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin; then
    echo "⚠️ Login mit Jenkins Credentials fehlgeschlagen. Versuche Fallback-Login..."
    
    # Fallback: manuell gesetzte Zugangsdaten (nur für Tests!)
    FALLBACK_USER="mahbagci"
    FALLBACK_PASS="Pjkez6&qc"  # ❗ Bitte nach Test wieder löschen

    echo "$FALLBACK_PASS" | docker login -u "$FALLBACK_USER" --password-stdin
fi

echo "✅ Docker Login erfolgreich."

# Maven Build
echo "🔨 Baue Backend..."
cd backend
./mvnw clean package || mvn clean package
cd ..

# Docker Compose Build
echo "🐳 Starte Build mit docker compose..."
docker compose down
docker compose build
docker compose up -d

# Taggen
docker tag mahbagci/todo-backend:latest mahbagci/todo-backend:1.0.0
docker tag mahbagci/todo-frontend:latest mahbagci/todo-frontend:1.0.0

# Push
docker push mahbagci/todo-backend:latest
docker push mahbagci/todo-backend:1.0.0
docker push mahbagci/todo-frontend:latest
docker push mahbagci/todo-frontend:1.0.0

# Kubernetes Deployments
kubectl apply -f backend/backend.yaml
kubectl apply -f frontend/frontend.yaml

# Kubernetes Rolling Update
kubectl set image deployment/backend-deployment backend=mahbagci/todo-backend:1.0.0
kubectl set image deployment/frontend-deployment frontend=mahbagci/todo-frontend:1.0.0

echo "✅ Deployment abgeschlossen."
