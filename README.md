# 📦 Kubernetes ToDo-Projekt

Dieses Projekt wurde im Rahmen einer praxisnahen **Weiterbildungsaufgabe zum DevOps Engineer** entwickelt.  
Es basiert auf einer simulierten Anforderung durch das fiktive Unternehmen **"Borngraben IT Dienstleistung Services GmbH"**.

Ziel war es, ein einfaches Fullstack-Projekt mit Frontend und Backend zu:

- 🐳 **Dockerisieren**
- 🧪 **Lokal mit Docker Compose testen**
- ☸️ **In einem Kubernetes-Cluster bereitstellen**
- 🔄 **Per Jenkins CI/CD automatisiert deployen**

---

## 🖥️ Projektüberblick

| Komponente | Beschreibung |
|------------|--------------|
| 🎨 **Frontend** | To-Do-Liste in Vanilla JavaScript, ausgeliefert über Nginx |
| 🛠️ **Backend**  | Spring Boot-Anwendung (Java + Maven), protokolliert Aufgaben |
| ⚙️ **CI/CD**    | Jenkins-Pipeline automatisiert Build & Deployment |
| ☸️ **Kubernetes** | Deployments + Services für beide Komponenten |

---

## 📁 Projektstruktur

```
.
├── backend/             # Spring Boot Projekt (inkl. Dockerfile + backend.yaml)
├── frontend/            # HTML, CSS, JS (inkl. Dockerfile + frontend.yaml)
├── docker-compose.yml   # Lokales Setup mit individuellen Ports
├── deploy.sh            # Automatisiertes Build- & Deploy-Skript
├── Jenkinsfile          # Jenkins-Pipeline Definition
└── README.md            # Projektdokumentation (diese Datei)
```

---

## 🧪 Lokaler Test mit Docker Compose

Das Projekt kann lokal getestet werden – mit angepassten Ports zur Vermeidung von Konflikten (z. B. bei parallelen Jenkins-Builds):

- 🔗 **Frontend**: http://localhost:8086  
- 🔗 **Backend**: http://localhost:8087

```bash
docker-compose up --build
```

---

## ☸️ Kubernetes Setup

Für den produktiven Betrieb im Kubernetes-Cluster wurden zwei YAML-Dateien erstellt:

- `frontend.yaml`  
- `backend.yaml`

Diese enthalten jeweils:

- ein **Deployment**
- einen **Service**

Da keine externe Registry verwendet wird, nutzen die Deployments lokal gebaute Docker-Images:

```yaml
image: todo-backend:1.0.0
imagePullPolicy: Never
```

Dies erlaubt Kubernetes, auf die lokalen Docker-Images zuzugreifen – vorausgesetzt, das Cluster läuft lokal (z. B. via Docker Desktop).

---

## 🔧 Automatisiertes Deployment mit `deploy.sh`

Die Datei `deploy.sh` übernimmt:

1. Maven-Build des Backends (`./mvnw clean package`)
2. Docker-Build für Backend und Frontend
3. Anwendung der Kubernetes-Manifeste (`kubectl apply`)
4. Rolling Update mit neuen Images (`kubectl set image`)

Es erkennt automatisch Änderungen und aktualisiert das Cluster bei Bedarf.

---

## 🔁 CI/CD mit Jenkins

Die CI/CD-Pipeline wird über ein `Jenkinsfile` definiert.  
Dieses enthält alle Schritte:

- 🧹 `cleanWs()` – Bereinigung des Jenkins-Arbeitsverzeichnisses
- 🔄 GitHub Checkout (automatisch per Webhook oder Polling)
- ⚙️ Maven-Build + Docker-Build
- ☸️ Kubernetes Deployment über `kubectl`

---

## 📦 Inhalte des Repositories

✅ **Backend**  
→ Spring Boot + Maven + Dockerfile + backend.yaml

✅ **Frontend**  
→ HTML, CSS, JavaScript + Dockerfile + frontend.yaml

✅ **docker-compose.yml**  
→ Für lokale Tests (angepasste Ports 8086/8087)

✅ **deploy.sh**  
→ Shell-Skript zur Build- & Kubernetes-Automatisierung

✅ **Jenkinsfile**  
→ Definiert die CI/CD-Pipeline

✅ **README.md**  
→ Projektdokumentation

---

## ✅ Zusammenfassung

| Ziel                          | Erreicht |
|-------------------------------|----------|
| Dockerisierung                | ✅        |
| Lokales Testing mit Compose   | ✅        |
| Kubernetes Deployments        | ✅        |
| Automatisiertes Deployment    | ✅        |
| CI/CD mit Jenkins             | ✅        |

---

## 📝 Hinweise

- Das Projekt simuliert eine vollständige **DevOps-Pipeline**
- Vom lokalen Test bis zur Kubernetes-Produktion
- Ideal als Lernprojekt oder Vorlage für moderne Microservice-Deployments

---

## 👤 Autor

**Muhammed Bagci**  
Weiterbildung zum DevOps Engineer  
Alle Dateien stehen zu Lern- und Testzwecken zur Verfügung.
