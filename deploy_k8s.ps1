# Automation Script for DevOps/GitOps Project Deployment
# Run this once 'minikube start' is successful.

Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "   GITOPS PLATFORM AUTO-DEPLOYMENT" -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan

$MINIKUBE_BIN = "D:\Kubernetes\Minikube\minikube.exe"

# 1. Enable Ingress
Write-Host "[1/6] Enabling Minikube Ingress..." -ForegroundColor Yellow
& $MINIKUBE_BIN addons enable ingress

# 2. Create Namespaces
Write-Host "[2/6] Creating Namespaces..." -ForegroundColor Yellow
kubectl create namespace argocd
kubectl create namespace devops-prod
kubectl create namespace monitoring

# 3. Install ArgoCD
Write-Host "[3/6] Installing ArgoCD..." -ForegroundColor Yellow
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# 4. Wait for ArgoCD (Basic wait)
Write-Host "Waiting 30s for ArgoCD services to initialize..." -ForegroundColor Green
Start-Sleep -Seconds 30

# 5. Apply ArgoCD Application Manifest
Write-Host "[4/6] Deploying Project via GitOps (ArgoCD)..." -ForegroundColor Yellow
kubectl apply -f argocd/application.yaml

# 6. Deploy Monitoring Stack
Write-Host "[5/6] Deploying Monitoring (Prometheus/Grafana)..." -ForegroundColor Yellow
kubectl apply -f monitoring/

# 7. Final Info
Write-Host "[6/6] Getting Connection Info..." -ForegroundColor Yellow
$argo_pass = kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"
$decoded_pass = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($argo_pass))

Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "DEPLOYMENT INITIATED!" -ForegroundColor Green
Write-Host "ArgoCD URL: run '& `$MINIKUBE_BIN service argocd-server -n argocd'"
Write-Host "ArgoCD Login: admin"
Write-Host "ArgoCD Password: $decoded_pass"
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "Note: It may take 2-5 minutes for all pods to be READY."
