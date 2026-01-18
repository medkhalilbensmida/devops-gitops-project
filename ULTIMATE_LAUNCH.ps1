function Start-VisibleTunnel ($title, $cmd) {
    Write-Host "🚀 Lancement : $title" -ForegroundColor Cyan
    Start-Process cmd -ArgumentList "/c title $title & $cmd"
}

Write-Host "🧹 Nettoyage des tunnels existants..." -ForegroundColor Yellow
taskkill /F /IM kubectl.exe 2>$null
taskkill /F /IM kubectl-argo-rollouts.exe 2>$null
Start-Sleep -Seconds 2

Write-Host "🚀 Démarrage des tunnels en fenêtres séparées..." -ForegroundColor Cyan

# Frontend : 4200 -> 80
Start-VisibleTunnel "TUNNEL_FRONTEND_4200" "minikube kubectl -- port-forward -n devops-prod svc/devops-platform-frontend 4200:80 --address 127.0.0.1"

# Backend : 8080 -> 8080
Start-VisibleTunnel "TUNNEL_BACKEND_8080" "minikube kubectl -- port-forward -n devops-prod svc/devops-platform-backend 8080:8080 --address 127.0.0.1"

# ArgoCD : 8081 -> 80
Start-VisibleTunnel "TUNNEL_ARGOCD_8081" "minikube kubectl -- port-forward -n argocd svc/argocd-server 8081:80 --address 127.0.0.1"

# Grafana : 3000 -> 3000
Start-VisibleTunnel "TUNNEL_GRAFANA_3000" "minikube kubectl -- port-forward -n monitoring svc/grafana 3000:3000 --address 127.0.0.1"

# Prometheus : 9090 -> 9090
Start-VisibleTunnel "TUNNEL_PROMETHEUS_9090" "minikube kubectl -- port-forward -n monitoring svc/prometheus 9090:9090 --address 127.0.0.1"

# Argo Rollouts Dashboard (Dashboard Canary)
Start-VisibleTunnel "TUNNEL_ROLLOUTS_3100" ".\kubectl-argo-rollouts.exe dashboard --port 3100 -n devops-prod"

Write-Host "`n⏳ Attente 10s pour stabilisation..." -ForegroundColor Gray
Start-Sleep -Seconds 10

Write-Host "✅ Terminé. Ouverture du Dashboard..." -ForegroundColor Green
Start-Process "DEV_DASHBOARD.html"
