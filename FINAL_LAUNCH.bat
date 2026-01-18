@echo off
TITLE LAUNCHER_DEVOPS_PROJECT
color 0A
echo ===================================================
echo   DEMARRAGE DE L'ENVIRONNEMENT DE SOUTENANCE (AUTO-HEAL)
echo ===================================================
echo.
echo 1. Nettoyage des processus existants...
taskkill /F /IM kubectl.exe >nul 2>&1
taskkill /F /IM kubectl-argo-rollouts.exe >nul 2>&1
timeout /t 2 /nobreak >nul

echo 2. Lancement des tunnels (MODE ROBUSTE)...
echo.

echo   - Frontend (4200)...
start "TUNNEL_FRONTEND" cmd /c "for /l %%x in (1, 1, 100) do (echo Lancement Tunnel Frontend... & minikube kubectl -- port-forward -n devops-prod svc/devops-platform-frontend 4200:80 --address 127.0.0.1 & echo Crash Tunnel! Redemarrage... & timeout /t 1)"

echo   - Backend (8080)...
start "TUNNEL_BACKEND" cmd /c "for /l %%x in (1, 1, 100) do (echo Lancement Tunnel Backend... & minikube kubectl -- port-forward -n devops-prod svc/devops-platform-backend 8080:8080 --address 127.0.0.1 & echo Crash Tunnel! Redemarrage... & timeout /t 1)"

echo   - ArgoCD (8081)...
start "TUNNEL_ARGOCD" cmd /c "for /l %%x in (1, 1, 100) do (echo Lancement Tunnel ArgoCD... & minikube kubectl -- port-forward -n argocd svc/argocd-server 8081:80 --address 127.0.0.1 & echo Crash Tunnel! Redemarrage... & timeout /t 1)"

echo   - Grafana (3000)...
start "TUNNEL_GRAFANA" cmd /c "for /l %%x in (1, 1, 100) do (echo Lancement Tunnel Grafana... & minikube kubectl -- port-forward -n monitoring svc/grafana 3000:3000 --address 127.0.0.1 & echo Crash Tunnel! Redemarrage... & timeout /t 1)"

echo   - Prometheus (9090)...
start "TUNNEL_PROMETHEUS" cmd /c "for /l %%x in (1, 1, 100) do (echo Lancement Tunnel Prometheus... & minikube kubectl -- port-forward -n monitoring svc/prometheus 9090:9090 --address 127.0.0.1 & echo Crash Tunnel! Redemarrage... & timeout /t 1)"

echo   - Canary (3100)...
start "TUNNEL_CANARY" cmd /c "for /l %%x in (1, 1, 100) do (echo Lancement Tunnel Canary... & .\kubectl-argo-rollouts.exe dashboard --port 3100 -n devops-prod & echo Crash Tunnel! Redemarrage... & timeout /t 1)"

echo.
echo 3. Attente de 10 secondes pour la stabilisation...
timeout /t 10 /nobreak >nul

echo 4. Lancement du Dashboard...
start "" "DEV_DASHBOARD.html"

echo.
echo ===================================================
echo   TOUT EST LANCE ET PROTEGE !
echo   LES TUNNELS REDEMARRERONT AUTOMATIQUEMENT SI CRASH.
echo   BONNE CHANCE POUR LA SOUTENANCE !
echo ===================================================
pause
