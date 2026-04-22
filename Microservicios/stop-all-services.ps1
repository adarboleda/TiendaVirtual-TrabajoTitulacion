# Script para detener todos los microservicios
# Cierra todas las ventanas de PowerShell que ejecutan mvnw

Write-Host "========================================" -ForegroundColor Red
Write-Host "Deteniendo todos los microservicios" -ForegroundColor Red
Write-Host "========================================" -ForegroundColor Red

# Detener todos los procesos de Java (Spring Boot)
Write-Host "`n[INFO] Buscando procesos Java..." -ForegroundColor Yellow
$javaProcesses = Get-Process -Name "java" -ErrorAction SilentlyContinue

if ($javaProcesses) {
    Write-Host "[INFO] Encontrados $($javaProcesses.Count) procesos Java" -ForegroundColor Yellow
    foreach ($process in $javaProcesses) {
        Write-Host "[INFO] Deteniendo proceso: $($process.ProcessName) (PID: $($process.Id))" -ForegroundColor Yellow
        Stop-Process -Id $process.Id -Force
    }
    Write-Host "[OK] Todos los procesos Java han sido detenidos" -ForegroundColor Green
} else {
    Write-Host "[INFO] No se encontraron procesos Java corriendo" -ForegroundColor Gray
}

Write-Host "`n[OK] Operación completada" -ForegroundColor Green
Write-Host "`nPresiona cualquier tecla para cerrar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
