# Script para probar el endpoint de productos y contar las queries de Hibernate

Write-Host "=== PRUEBA DE ENDPOINT /api/productos ===" -ForegroundColor Cyan
Write-Host ""

Write-Host "Realizando petición a http://localhost:8081/api/productos..." -ForegroundColor Yellow

$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8081/api/productos" -Method Get
    $stopwatch.Stop()
    
    Write-Host ""
    Write-Host "OK Peticion exitosa" -ForegroundColor Green
    Write-Host "Productos obtenidos: $($response.Count)" -ForegroundColor Green
    Write-Host "Tiempo de respuesta: $($stopwatch.ElapsedMilliseconds) ms" -ForegroundColor Green
    Write-Host ""
    Write-Host "Revisa la consola de msvc-producto para ver las queries de Hibernate" -ForegroundColor Cyan
    Write-Host "Deberías ver:" -ForegroundColor Yellow
    Write-Host "  - 1 query con LEFT JOIN (bueno)" -ForegroundColor Yellow
    Write-Host "  - NO queries individuales SELECT ... WHERE id=? (malo)" -ForegroundColor Yellow
    
} catch {
    $stopwatch.Stop()
    Write-Host ""
    Write-Host "X Error en la peticion" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}

Write-Host ""
Write-Host "Presiona Enter para salir..."
Read-Host
