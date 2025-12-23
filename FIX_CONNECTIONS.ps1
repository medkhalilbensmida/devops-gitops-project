# REPARATION DEFINITIVE DES ACCES (MODE PORT-FORWARD)
Write-Host "🔧 Démarrage du script de stabilisation des connexions..." -ForegroundColor Cyan

# 1. Tuer les anciens processus parasites
Write-Host "🛑 Arrêt des anciens tunnels..." -ForegroundColor Yellow
Stop-Process -Name "kubectl" -ErrorAction SilentlyContinue

# 2. Lancement des Port-Forwards en arrière-plan (Jobs)
Write-Host "🚀 Création des tunnels stables..." -ForegroundColor Yellow

# Fonction pour lancer un tunnel
function Start-Tunnel ($ns, $svc, $locPort, $remPort) {
    Write-Host "   -> Tunnel $svc ($locPort -> $remPort)"
    $job = Start-Job -ScriptBlock {
        param($n, $s, $l, $r)
        & kubectl port-forward -n $n svc/$s ${l}:${r} --address 0.0.0.0
    } -ArgumentList $ns, $svc, $locPort, $remPort
}

# --- CONFIGURATION DES TUNNELS ---
# Frontend -> 4200
Start-Tunnel "devops-prod" "devops-platform-frontend" 4200 80
# Backend -> 8080
Start-Tunnel "devops-prod" "devops-platform-backend" 8080 8080
# ArgoCD -> 8081
Start-Tunnel "argocd" "argocd-server" 8081 80
# Grafana -> 3000
Start-Tunnel "monitoring" "grafana" 3000 80
# Prometheus -> 9090
Start-Tunnel "monitoring" "prometheus" 9090 80 # Parfois port 9090 cible 80 du service

# Petite pause pour laisser les connexions s'établir
Start-Sleep -Seconds 5

# 3. MISE A JOUR DU DASHBOARD AVEC LIENS FIXES
Write-Host "📝 Mise à jour du Dashboard..." -ForegroundColor Yellow
$file = "d:\projet nouv tech version2\DEV_DASHBOARD.html"
$txt = Get-Content $file -Raw

# Remplacements pas des liens localhost stables
$txt = $txt -replace "href=`"http://127.0.0.1:\d+`" target=`"_blank`" class=`"btn`">Accéder à l'App Boutique", "href=`"http://localhost:4200`" target=`"_blank`" class=`"btn`">Accéder à l'App Boutique"
$txt = $txt -replace "href=`"http://127.0.0.1:\d+/api/swagger-ui.html`"", "href=`"http://localhost:8080/api/swagger-ui.html`""
$txt = $txt -replace "href=`"http://127.0.0.1:\d+`" target=`"_blank`" class=`"btn secondary`">Interface ArgoCD", "href=`"http://localhost:8081`" target=`"_blank`" class=`"btn secondary`">Interface ArgoCD"
# Grafana peut avoir une URL complexe, on reset vers la racine si besoin, ou on garde le path
$txt = $txt -replace "href=`"http://127.0.0.1:\d+/d/.*`"", "href=`"http://localhost:3000/d/spring_boot_21/spring-boot-2-1-system-monitor?orgId=1&refresh=5s`""
$txt = $txt -replace "href=`"http://127.0.0.1:\d+/targets`"", "href=`"http://localhost:9090/targets`""
$txt = $txt -replace "href=`"http://127.0.0.1:\d+/alerts`"", "href=`"http://localhost:9090/alert`"" # Prometheus native alert path

Set-Content -Path $file -Value $txt

Write-Host "✅ ACCÈS RÉPARÉS !" -ForegroundColor Green
Write-Host "🌐 Frontend:   http://localhost:4200"
Write-Host "🌐 Backend:    http://localhost:8080"
Write-Host "🌐 ArgoCD:     http://localhost:8081"
Write-Host "🌐 Grafana:    http://localhost:3000"

Start-Process $file

Write-Host "⚠️  IMPORTANT : NE FERMEZ PAS CETTE FENÊTRE (Les tunnels tournent ici)" -ForegroundColor Red
Read-Host "Appuyez sur Entrée pour quitter (et couper les connexions)..."
