@echo off
TITLE LAUNCHER_DEVOPS_PROJECT
color 0A
echo ===================================================
echo   DEMARRAGE DE L'ENVIRONNEMENT DE SOUTENANCE
echo ===================================================
echo.
echo 1. Nettoyage des processus existants...
taskkill /F /IM kubectl.exe >nul 2>&1
taskkill /F /IM kubectl-argo-rollouts.exe >nul 2>&1
timeout /t 2 /nobreak >nul

echo 2. Lancement des tunnels (FENETRES SEPAREES)...
echo.

echo   - Frontend (4200)...
start "TUNNEL_FRONTEND" cmd /k "minikube kubectl -- port-forward -n devops-prod svc/devops-platform-frontend 4200:80 --address 127.0.0.1"

echo   - Backend (8080)...
start "TUNNEL_BACKEND" cmd /k "minikube kubectl -- port-forward -n devops-prod svc/devops-platform-backend 8080:8080 --address 127.0.0.1"

echo   - ArgoCD (8081)...
start "TUNNEL_ARGOCD" cmd /k "minikube kubectl -- port-forward -n argocd svc/argocd-server 8081:80 --address 127.0.0.1"

echo   - Grafana (3000)...
start "TUNNEL_GRAFANA" cmd /k "minikube kubectl -- port-forward -n monitoring svc/grafana 3000:3000 --address 127.0.0.1"

echo   - Prometheus (9090)...
start "TUNNEL_PROMETHEUS" cmd /k "minikube kubectl -- port-forward -n monitoring svc/prometheus 9090:9090 --address 127.0.0.1"

echo   - Canary (3100)...
:: Ciblage explicite du namespace devops-prod pour eviter le "Loading" infini
start "TUNNEL_CANARY" cmd /k ".\kubectl-argo-rollouts.exe dashboard --port 3100 -n devops-prod"

echo.
echo 3. Attente de 10 secondes pour la stabilisation...
timeout /t 10 /nobreak >nul

echo 4. Lancement du Dashboard...
start "" "DEV_DASHBOARD.html"

echo.
echo ===================================================
echo   TOUT EST LANCE !
echo   GARDEZ LES FENETRES NOIRES OUVERTES (6 fenetres).
echo   BONNE CHANCE POUR LA SOUTENANCE !
echo ===================================================
pause
