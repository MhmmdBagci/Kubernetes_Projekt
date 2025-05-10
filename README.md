Kubernetes ToDo-Projekt

Dieses Projekt wurde im Rahmen der Weiterbildung zum DevOps Engineer bei der Borngraben IT Dienstleistung Services GmbH umgesetzt. Ziel war es, ein einfaches Fullstack-Projekt mit Frontend und Backend zu dockerisieren, lokal mit Docker Compose zu betreiben und anschließend in einem Kubernetes-Cluster bereitzustellen. Zusätzlich wurde eine CI/CD-Pipeline mit Jenkins integriert, die das gesamte Deployment automatisiert.

Das Frontend besteht aus einer To-Do-Liste in Vanilla JavaScript und wird mit Nginx ausgeliefert. Das Backend ist eine Spring Boot-Anwendung, die eingetragene Aufgaben protokolliert. Beide Komponenten wurden jeweils mit einem eigenen Dockerfile versehen. Für lokale Tests wurde eine docker-compose.yml erstellt, in der das Frontend auf Port 8086 und das Backend auf Port 8087 läuft, um mögliche Portkonflikte (z. B. bei parallelen Jenkins-Builds) zu vermeiden.

Für den produktiven Betrieb im Kubernetes-Cluster wurden zwei YAML-Dateien (frontend.yaml und backend.yaml) erstellt, die jeweils sowohl das Deployment als auch den Service definieren. Die Docker-Images wurden in die öffentliche Docker-Hub-Registry unter dem Benutzernamen mahbagci gepusht. Somit können sie vom Kubernetes-Cluster direkt verwendet werden.

Die Datei deploy.sh automatisiert den gesamten Ablauf: Wenn Änderungen im Repository erkannt werden, wird das Backend mit Maven gebaut, die Docker-Images neu erstellt und zu Docker Hub gepusht. Anschließend erfolgt ein Rolling Update im Kubernetes-Cluster mit kubectl set image, sodass die Anwendung nahtlos aktualisiert wird.

Für die CI/CD-Pipeline wurde ein Jenkinsfile erstellt, das alle gängigen Schritte umfasst: Bereinigung des Arbeitsverzeichnisses (cleanWs()), Auschecken des Codes und Ausführen des deploy.sh-Skripts. Damit kann bei jedem Push ins GitHub-Repository automatisch ein neuer Build ausgelöst und das Projekt ausgerollt werden. Optional kann ein Webhook in GitHub eingerichtet werden oder Polling aktiviert werden.

Das Repository enthält alle relevanten Dateien:

backend/ mit dem Spring Boot Projekt

frontend/ mit HTML, CSS und JS

docker-compose.yml für lokale Tests

backend.yaml und frontend.yaml für Kubernetes

deploy.sh zur Automatisierung

Jenkinsfile für CI/CD

README.md zur Projektdokumentation

Das Projekt erfüllt alle Anforderungen: vollständige Dockerisierung, funktionierende Kubernetes-Deployments, automatisiertes Rollout per Shell-Skript und CI/CD-Integration in Jenkins. Damit simuliert es eine moderne DevOps-Pipeline vom lokalen Test bis zur produktionsreifen Bereitstellung.