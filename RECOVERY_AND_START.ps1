# RECOVERY KHALIL & YASMINE
Write-Host "🚑 DÉMARRAGE DE LA PROCÉDURE DE RÉCUPÉRATION..." -ForegroundColor Cyan

# 1. NETTOYAGE DU CLUSTER (Suppression des services lourds qui ont crashé le système)
Write-Host "🧹 Nettoyage des ressources fantômes (Nexus/Sonar)..." -ForegroundColor Yellow
& "D:\Kubernetes\Minikube\minikube.exe" kubectl -- delete deploy nexus -n devops-prod --ignore-not-found=true
& "D:\Kubernetes\Minikube\minikube.exe" kubectl -- delete svc nexus -n devops-prod --ignore-not-found=true
& "D:\Kubernetes\Minikube\minikube.exe" kubectl -- delete deploy sonarqube -n devops-prod --ignore-not-found=true
& "D:\Kubernetes\Minikube\minikube.exe" kubectl -- delete svc sonarqube -n devops-prod --ignore-not-found=true
Write-Host "✅ Nettoyage terminé." -ForegroundColor Green

# 2. RÉCUPÉRATION DES NOUVELLES ADRESSES DYNAMIQUES
Write-Host "🔗 Récupération des accès Minikube..." -ForegroundColor Yellow

$argo = & "D:\Kubernetes\Minikube\minikube.exe" service argocd-server -n argocd --url | Select-Object -First 1
$front = & "D:\Kubernetes\Minikube\minikube.exe" service devops-platform-frontend -n devops-prod --url | Select-Object -First 1
$back = & "D:\Kubernetes\Minikube\minikube.exe" service devops-platform-backend -n devops-prod --url | Select-Object -First 1
$graf = & "D:\Kubernetes\Minikube\minikube.exe" service grafana -n monitoring --url | Select-Object -First 1
$prom = & "D:\Kubernetes\Minikube\minikube.exe" service prometheus -n monitoring --url | Select-Object -First 1
$alert = & "D:\Kubernetes\Minikube\minikube.exe" service alertmanager -n monitoring --url | Select-Object -First 1

# Remplacement dans le HTML
$file = "d:\projet nouv tech version2\DEV_DASHBOARD.html"
$txt = Get-Content $file -Raw

# Regex pour remplacer les anciens liens http://127.0.0.1:XXXXX
# On remplace intelligemment selon le contexte
$txt = $txt -replace "href=`"http://127.0.0.1:\d+`" target=`"_blank`" class=`"btn`">Accéder à l'App Boutique", "href=`"$front`" target=`"_blank`" class=`"btn`">Accéder à l'App Boutique"
$txt = $txt -replace "href=`"http://127.0.0.1:\d+/api/swagger-ui.html`"", "href=`"$back/api/swagger-ui.html`""
$txt = $txt -replace "href=`"http://127.0.0.1:\d+`" target=`"_blank`" class=`"btn secondary`">Interface ArgoCD", "href=`"$argo`" target=`"_blank`" class=`"btn secondary`">Interface ArgoCD"
$txt = $txt -replace "href=`"http://127.0.0.1:\d+/d/.*`"", "href=`"$graf/d/spring_boot_21/spring-boot-2-1-system-monitor?orgId=1&refresh=5s`""
$txt = $txt -replace "href=`"http://127.0.0.1:\d+/targets`"", "href=`"$prom/targets`""
$txt = $txt -replace "href=`"http://127.0.0.1:\d+/alerts`"", "href=`"$alert/alerts`""

Set-Content -Path $file -Value $txt

Write-Host "✅ Dashboard mis à jour avec les nouveaux ports !" -ForegroundColor Green
Write-Host "👉 Frontend: $front"
Write-Host "👉 Backend: $back"
Write-Host "👉 ArgoCD: $argo"

# 3. OUVERTURE
Start-Process $file
Write-Host "🎉 SYSTÈME OPÉRATIONNEL. PRÊT POUR LA SOUTENANCE." -ForegroundColor Cyan
