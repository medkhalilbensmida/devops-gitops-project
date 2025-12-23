# DEFENSE MODE - SINGLE ROBUST WINDOW (V4 - ULTRA STABLE)
Write-Host "🛡️ MODE SOUTENANCE ACTIVÉ (V4 - FINAL)..." -ForegroundColor Cyan

# 1. Cleanup
Write-Host "🧹 Nettoyage des processus..." -ForegroundColor Yellow
Stop-Process -Name "kubectl" -ErrorAction SilentlyContinue
Stop-Process -Name "kubectl-argo-rollouts" -ErrorAction SilentlyContinue
Get-Job | Remove-Job -Force

# 2. Setup Paths & Logs
$ScriptDir = $PSScriptRoot
if (-not $ScriptDir) { $ScriptDir = "d:\projet nouv tech version2" }
$LogDir = "$ScriptDir\logs"
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null

# DETECT KUBECTL
$KubeExe = "C:\Program Files\Docker\Docker\Resources\bin\kubectl.exe"
if (-not (Test-Path $KubeExe)) { $KubeExe = "kubectl.exe" }
$RolloutExe = "$ScriptDir\kubectl-argo-rollouts.exe"

# 3. Startup Function
function Start-HiddenTunnel ($name, $cmd, $port) {
    Write-Host "   -> Démarrage : $name (Port $port)..." -NoNewline
    $LogFile = "$LogDir\tunnel_$port.log"
    # STRICT QUOTING FIX
    $job = Start-Job -ScriptBlock {
        param($c, $l)
        Invoke-Expression "$c > '$l' 2>&1"
    } -ArgumentList $cmd, $LogFile
    
    if ($job.State -eq 'Running') { Write-Host " [EN COURS]" -ForegroundColor Green }
    else { Write-Host " [ECHEC]" -ForegroundColor Red }
}

# 4. Launch Tunnels (VERIFIED NAMES & PORTS)

# Frontend: Verified working
Start-HiddenTunnel "Frontend" "& '$KubeExe' port-forward -n devops-prod svc/devops-platform-frontend 4200:80 --address 0.0.0.0" 4200

# Backend: Verified working
Start-HiddenTunnel "Backend" "& '$KubeExe' port-forward -n devops-prod svc/devops-platform-backend 8080:8080 --address 0.0.0.0" 8080

# ArgoCD: Try HTTPS port 443 (8081 -> 443)
Start-HiddenTunnel "ArgoCD" "& '$KubeExe' port-forward -n argocd svc/argocd-server 8081:443 --address 0.0.0.0" 8081

# Grafana: Try port 80 first, fallback to 3000 if failed. Svc Name: 'grafana'
Start-HiddenTunnel "Grafana" "& '$KubeExe' port-forward -n monitoring svc/grafana 3000:80 --address 0.0.0.0" 3000

# Prometheus: Correct name 'prometheus', port 9090
Start-HiddenTunnel "Prometheus" "& '$KubeExe' port-forward -n monitoring svc/prometheus 9090:9090 --address 0.0.0.0" 9090

# Canary: Local binary
Start-HiddenTunnel "Canary" "& '$RolloutExe' dashboard --port 3100" 3100

# 5. Verification Loop
Write-Host "`n⏳ Initialisation des tunnels (15s)..." -ForegroundColor Cyan
Start-Sleep -Seconds 15

$ports = @(4200, 8080, 8081, 3000, 9090, 3100)
foreach ($p in $ports) {
    # Try connectivity test
    $conn = Test-NetConnection -ComputerName localhost -Port $p -WarningAction SilentlyContinue
    if ($conn.TcpTestSucceeded) {
        Write-Host "   ✅ Port $p : ACTIF" -ForegroundColor Green
    } else {
        # READ LOG IF FAILED
        Write-Host "   ❌ Port $p : INACTIF -> DIAGNOSTIC:" -ForegroundColor Red
        if (Test-Path "$LogDir\tunnel_$p.log") {
            Get-Content "$LogDir\tunnel_$p.log" -Tail 3 | ForEach-Object { Write-Host "      LOG: $_" -ForegroundColor DarkGray }
        } else {
            Write-Host "      (Pas de log - Job crash?)" -ForegroundColor DarkGray
        }
    }
}

# 6. Open Dashboard
Write-Host "`n🌐 Lancement du Dashboard..."
Start-Process "$ScriptDir\DEV_DASHBOARD.html"

# 7. Keep Alive
Write-Host "⚠️  NE FERMEZ PAS CETTE FENÊTRE." -ForegroundColor Red
# Low CPU usage loop
while ($true) { Start-Sleep -Seconds 60 }
