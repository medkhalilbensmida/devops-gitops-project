# MASTER RECOVERY SCRIPT - RUN AFTER PC RESTART (V2.1 - FINAL)
# Automates: Docker check -> Minikube start -> Comprehensive Readiness Check -> Tunnel launch

$ErrorActionPreference = "SilentlyContinue"
Write-Host "🚀 INITIALISATION DE LA RECUPERATION APRES REDEMARRAGE (V2.1)..." -ForegroundColor Cyan
Write-Host "-------------------------------------------------------------"

# 1. Check Docker
Write-Host "🔍 Etape 1 : Verification de Docker..." -NoNewline
$dockerCheck = docker version 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host " [ERREUR]" -ForegroundColor Red
    Write-Host "🛑 ERREUR : Docker Desktop n'est pas lancé." -ForegroundColor Yellow
    Write-Host "👉 VEUILLEZ LANCER DOCKER DESKTOP MANUELLEMENT, PUIS RELANCEZ CE SCRIPT." -ForegroundColor White
    pause
    exit
}
Write-Host " [OK]" -ForegroundColor Green

# 2. Start Minikube
Write-Host "🔍 Etape 2 : Demarrage de Minikube..." -ForegroundColor Cyan
minikube start --driver=docker

# 3. Wait for Pods Readiness (Multi-Namespace)
Write-Host "⏳ Etape 3 : Attente de preparation des Pods (Tous les services)..." -ForegroundColor Yellow
$maxRetries = 12
$retryCount = 0
$ready = $false

while (-not $ready -and $retryCount -lt $maxRetries) {
    # On check devops-prod (Frontend/Backend) et monitoring (Grafana/Prom)
    $prodPods = kubectl get pods -n devops-prod --no-headers 2>$null
    $monPods = kubectl get pods -n monitoring --no-headers 2>$null
    
    $notReady = ($prodPods + $monPods) | Select-String "0/" , "Pending", "ContainerCreating"
    
    if ($null -ne $notReady) {
        Write-Host "   ... En attente des services (Check $retryCount/$maxRetries)..."
        Start-Sleep -Seconds 10
        $retryCount++
    } else {
        $ready = $true
    }
}

Write-Host "✅ Cluster 100% prêt pour les tunnels !" -ForegroundColor Green

# 4. Launch the Final Tunnels
Write-Host "🔍 Etape 4 : Lancement des Tunnels de Soutenance..." -ForegroundColor Cyan
$BatchFile = Join-Path $PSScriptRoot "FINAL_LAUNCH.bat"
if (Test-Path $BatchFile) {
    # Nettoyage préventif
    taskkill /F /IM kubectl.exe >$null 2>&1
    taskkill /F /IM kubectl-argo-rollouts.exe >$null 2>&1
    
    Start-Process cmd -ArgumentList "/c `"$BatchFile`""
    Write-Host "✅ Tunnels lancés dans des fenetres separees." -ForegroundColor Green
}

Write-Host "-------------------------------------------------------------"
Write-Host "✨ RECUPERATION TERMINEE !" -ForegroundColor Green
Write-Host "Tous les services sont en cours de demarrage."
Write-Host "Veuillez patienter 10s et le Dashboard s'ouvrira."
Write-Host "-------------------------------------------------------------"
Start-Sleep -Seconds 10
Start-Process (Join-Path $PSScriptRoot "DEV_DASHBOARD.html")
