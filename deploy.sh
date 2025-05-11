#!/bin/bash
set -e

echo "🔨 Baue Backend mit Maven..."
cd backend
./mvnw clean package || mvn clean package
cd ..

echo "🐳 Baue Docker-Images lokal..."
docker build -t todo-backend:1.0.0 ./backend
docker build -t todo-frontend:1.0.0 ./frontend

echo "☸️  Wende Kubernetes-Konfigurationen an..."
kubectl apply -f backend/backend.yaml
kubectl apply -f frontend/frontend.yaml

echo "🔄 Aktualisiere Kubernetes-Deployments mit lokalen Images..."
kubectl set image deployment/backend-deployment backend=todo-backend:1.0.0
kubectl set image deployment/frontend-deployment frontend=todo-frontend:1.0.0

echo "✅ Lokales Deployment abgeschlossen."
