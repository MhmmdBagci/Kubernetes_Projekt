#!/bin/bash
set -e

# 1. Maven Build (Spring Boot Backend)
echo "🔨 Baue Backend mit Maven..."
cd backend
./mvnw clean package || mvn clean package
cd ..

# 2. Docker-Images bauen
echo "🐳 Baue Docker-Images..."
docker build -t mahbagci/todo-backend:latest ./backend
docker build -t mahbagci/todo-frontend:latest ./frontend

# 3. Docker-Images taggen
echo "🏷️  Tagge Docker-Images..."
docker tag mahbagci/todo-backend:latest mahbagci/todo-backend:1.0.0
docker tag mahbagci/todo-frontend:latest mahbagci/todo-frontend:1.0.0

# 4. Docker-Images pushen
echo "⬆️  Pushe Docker-Images zu Docker Hub..."
docker push mahbagci/todo-backend:latest
docker push mahbagci/todo-backend:1.0.0
docker push mahbagci/todo-frontend:latest
docker push mahbagci/todo-frontend:1.0.0

# 5. Kubernetes Manifeste anwenden
echo "☸️  Wende Kubernetes-Konfigurationen an..."
kubectl apply -f backend/backend.yaml
kubectl apply -f frontend/frontend.yaml

# 6. Kubernetes Rolling Update (neue Images setzen)
echo "🔄 Aktualisiere Kubernetes-Deployments mit neuen Images..."
kubectl set image deployment/backend-deployment backend=mahbagci/todo-backend:1.0.0
kubectl set image deployment/frontend-deployment frontend=mahbagci/todo-frontend:1.0.0

echo "✅ Deployment abgeschlossen."
