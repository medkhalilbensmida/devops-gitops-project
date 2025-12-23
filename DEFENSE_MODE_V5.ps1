# DEFENSE MODE - SINGLE ROBUST WINDOW (V5 - FINAL FINAL)
Write-Host "🛡️ MODE SOUTENANCE ACTIVÉ (V5 - TCP FIX)..." -ForegroundColor Cyan

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

$KubeExe = "C:\Program Files\Docker\Docker\Resources\bin\kubectl.exe"
if (-not (Test-Path $KubeExe)) { $KubeExe = "kubectl.exe" }
$RolloutExe = "$ScriptDir\kubectl-argo-rollouts.exe"

# 3. Startup Function (With TCP Check)
function Start-HiddenTunnel ($name, $cmd, $port) {
    Write-Host "   -> Démarrage : $name (Port $port)..." -NoNewline
    $LogFile = "$LogDir\tunnel_$port.log"
    $job = Start-Job -ScriptBlock {
        param($c, $l)
        Invoke-Expression "$c > '$l' 2>&1"
    } -ArgumentList $cmd, $LogFile
    
    if ($job.State -eq 'Running') { Write-Host " [LANCÉ]" -ForegroundColor Green }
    else { Write-Host " [CRASH]" -ForegroundColor Red }
}

# 4. Launch Tunnels (EXPLICIT NAMES & HTTP PORTS)

# Frontend 4200:80
Start-HiddenTunnel "Frontend" "& '$KubeExe' port-forward -n devops-prod svc/devops-platform-frontend 4200:80 --address 0.0.0.0" 4200

# Backend 8080:8080
Start-HiddenTunnel "Backend" "& '$KubeExe' port-forward -n devops-prod svc/devops-platform-backend 8080:8080 --address 0.0.0.0" 8080

# ArgoCD 8081:80 (Back to HTTP to match Dashboard)
Start-HiddenTunnel "ArgoCD" "& '$KubeExe' port-forward -n argocd svc/argocd-server 8081:80 --address 0.0.0.0" 8081

# Grafana 3000:80 (Standard endpoint for grafana svc)
Start-HiddenTunnel "Grafana" "& '$KubeExe' port-forward -n monitoring svc/grafana 3000:80 --address 0.0.0.0" 3000

# Prometheus 9090:9090 (Using LONG NAME found in monitoring list)
# Previous lists showed 'prometheus-kube-prometheus-prometheus'
Start-HiddenTunnel "Prometheus" "& '$KubeExe' port-forward -n monitoring svc/prometheus-kube-prometheus-prometheus 9090:9090 --address 0.0.0.0" 9090

# Canary
Start-HiddenTunnel "Canary" "& '$RolloutExe' dashboard --port 3100" 3100

# 5. Verification Loop
Write-Host "`n⏳ Attente stabilisation (15s)..." -ForegroundColor Cyan
Start-Sleep -Seconds 15

$ports = @(4200, 8080, 8081, 3000, 9090, 3100)
foreach ($p in $ports) {
    Try {
        $conn = Test-NetConnection -ComputerName localhost -Port $p -WarningAction SilentlyContinue
        if ($conn.TcpTestSucceeded) {
            Write-Host "   ✅ Port $p : ACTIF" -ForegroundColor Green
        } else {
            Write-Host "   ❌ Port $p : ECHEC" -ForegroundColor Red
            if (Test-Path "$LogDir\tunnel_$p.log") {
                Write-Host "      -- ERREUR LOG --" -ForegroundColor Red
                Get-Content "$LogDir\tunnel_$p.log" -Tail 3 | ForEach-Object { Write-Host "      $_" -ForegroundColor DarkGray }
                Write-Host "      ----------------" -ForegroundColor Red
            }
        }
    } Catch {
        Write-Host "   ⚠️  Erreur check port $p" -ForegroundColor Yellow
    }
}

# 6. Open Dashboard
Start-Process "$ScriptDir\DEV_DASHBOARD.html"

# 7. Keep Alive
Write-Host "`n⚠️  LAISSEZ CETTE FENÊTRE OUVERTE. 🛑" -ForegroundColor Red
while ($true) { Start-Sleep -Seconds 60 }
