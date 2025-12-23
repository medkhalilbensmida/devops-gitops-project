# SCRIPT DE SAUVETAGE ULTIME - FENETRES SÉPARÉES
Write-Host "🆘 LANCEMENT DE LA PROCÉDURE DE SAUVETAGE VISUELLE..." -ForegroundColor Red

# 1. KILL ALL
Write-Host "☠️  Nettoyage des anciens processus..." -ForegroundColor Yellow
Stop-Process -Name "kubectl" -ErrorAction SilentlyContinue
Stop-Process -Name "kubectl-argo-rollouts" -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# Fonction pour ouvrir une nouvelle fenêtre CMD persistante
function Start-VisibleTunnel ($title, $cmd) {
    Write-Host "   -> Ouverture tunnel: $title"
    # On lance une fenêtre CMD qui reste ouverte (/k) pour voir les logs
    Start-Process cmd -ArgumentList "/k title $title && echo Lancement tunnel... && $cmd"
}

# 2. LANCEMENT DES TUNNELS (CHAQUE TUNNEL A SA FENETRE)
Write-Host "🚀 Démarrage des tunnels en fenêtres séparées..." -ForegroundColor Cyan

# Frontend : 4200 -> 80
Start-VisibleTunnel "TUNNEL_FRONTEND_4200" "kubectl port-forward -n devops-prod svc/devops-platform-frontend 4200:80 --address 0.0.0.0"

# Backend : 8080 -> 8080
Start-VisibleTunnel "TUNNEL_BACKEND_8080" "kubectl port-forward -n devops-prod svc/devops-platform-backend 8080:8080 --address 0.0.0.0"

# ArgoCD : 8081 -> 80
Start-VisibleTunnel "TUNNEL_ARGOCD_8081" "kubectl port-forward -n argocd svc/argocd-server 8081:80 --address 0.0.0.0"

# Grafana : 3000 -> 80
Start-VisibleTunnel "TUNNEL_GRAFANA_3000" "kubectl port-forward -n monitoring svc/grafana 3000:80 --address 0.0.0.0"

# Prometheus : 9090 -> 80 (Souvent le service expose 80 vers 9090 interne)
Start-VisibleTunnel "TUNNEL_PROMETHEUS_9090" "kubectl port-forward -n monitoring svc/prometheus 9090:80 --address 0.0.0.0"

# Argo Rollouts Dashboard (Dashboard Canary)
Start-VisibleTunnel "TUNNEL_ROLLOUTS_3100" "kubectl-argo-rollouts dashboard --port 3100"

# 3. VERIFICATION
Start-Sleep -Seconds 5
Write-Host "✅ Tunnels lancés ! Vérifiez les fenêtres noires qui se sont ouvertes." -ForegroundColor Green
Write-Host "   Si une fenêtre se ferme ou affiche une erreur, vous saurez pourquoi !"

# 4. OUVERTURE DASHBOARD
Write-Host "🌐 Ouverture du Dashboard..."
Start-Process "d:\projet nouv tech version2\DEV_DASHBOARD.html"
