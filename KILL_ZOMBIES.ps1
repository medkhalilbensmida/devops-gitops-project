# KILL ZOMBIE PORTS
Write-Host "🔫 TUER LES PROCESSUS FANTÔMES..." -ForegroundColor Red

$ports = @(4200, 8080, 8081, 3000, 9090, 3100)

foreach ($p in $ports) {
    Write-Host "   Port $p : " -NoNewline
    # Find PID
    $line = netstat -ano | findstr ":$p "
    if ($line) {
        # Extract PID (Last column)
        $pidVal = $line.Trim().Split(" ", [StringSplitOptions]::RemoveEmptyEntries)[-1]
        Write-Host "OCCUPÉ par PID $pidVal -> KILL" -ForegroundColor Yellow
        Stop-Process -Id $pidVal -Force -ErrorAction SilentlyContinue
    } else {
        Write-Host "LIBRE" -ForegroundColor Green
    }
}

Write-Host "✅ NETTOYAGE TERMINÉ." -ForegroundColor Cyan
