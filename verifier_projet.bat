@echo off
echo ===================================================
echo   CHASSIS DE VERIFICATION DU PROJET GITOPS
echo ===================================================

echo [1/6] Verification du Backend...
if exist backend\pom.xml (echo OK: pom.xml trouve) else (echo ERR: pom.xml manquant)
if exist backend\src\main\java\com\example\devopsapi\DevopsApiApplication.java (echo OK: Application Java trouvee) else (echo ERR: Main manquant)
if exist backend\Dockerfile (echo OK: Dockerfile Backend trouve) else (echo ERR: Dockerfile manquant)

echo.
echo [2/6] Verification du Frontend...
if exist frontend\package.json (echo OK: package.json trouve) else (echo ERR: package.json manquant)
if exist frontend\src\main.ts (echo OK: Main Angular trouve) else (echo ERR: main.ts manquant)
if exist frontend\Dockerfile (echo OK: Dockerfile Frontend trouve) else (echo ERR: Dockerfile manquant)

echo.
echo [3/6] Verification de Kubernetes (Helm)...
if exist k8s\Chart.yaml (echo OK: Helm Chart trouve) else (echo ERR: Chart manquant)
if exist k8s\values.yaml (echo OK: Values Helm trouvees) else (echo ERR: Values manquantes)
if exist k8s\rollout.yaml (echo OK: Argo Rollout Canary trouve) else (echo ERR: Rollout manquant)

echo.
echo [4/6] Verification du CI/CD...
if exist .github\workflows\main.yml (echo OK: Pipeline GitHub Actions trouve) else (echo ERR: Pipeline manquant)
if exist argocd\application.yaml (echo OK: Manifest ArgoCD trouve) else (echo ERR: ArgoCD manquant)

echo.
echo [5/6] Verification de l'Observabilite...
if exist monitoring\prometheus.yaml (echo OK: Config Prometheus trouvee) else (echo ERR: Prometheus manquant)
if exist monitoring\grafana.yaml (echo OK: Config Grafana trouvee) else (echo ERR: Grafana manquant)
if exist monitoring\alertmanager.yaml (echo OK: Config Alertmanager trouvee) else (echo ERR: Alertmanager manquant)

echo.
echo [6/6] Verification du Docker Compose...
if exist docker-compose.yml (echo OK: Docker Compose trouve) else (echo ERR: Docker Compose manquant)

echo.
echo ===================================================
echo   RESUME : TOUS LES COMPOSANTS SONT PRESENTS
echo ===================================================
