# Script simple de prueba de carga para productos
# Alternativa a JMeter usando PowerShell

param(
    [int]$TotalRequests = 100,
    [int]$ConcurrentUsers = 10,
    [string]$Url = "http://localhost:8081/api/productos"
)

Write-Host "=== PRUEBA DE CARGA - PRODUCTOS ===" -ForegroundColor Cyan
Write-Host "URL: $Url" -ForegroundColor Yellow
Write-Host "Total de peticiones: $TotalRequests" -ForegroundColor Yellow
Write-Host "Usuarios concurrentes: $ConcurrentUsers" -ForegroundColor Yellow
Write-Host ""

$results = @()
$errors = 0
$globalStopwatch = [System.Diagnostics.Stopwatch]::StartNew()

# Crear jobs concurrentes
$jobs = 1..$ConcurrentUsers | ForEach-Object {
    Start-Job -ScriptBlock {
        param($url, $requestsPerUser)
        
        $jobResults = @()
        for ($i = 1; $i -le $requestsPerUser; $i++) {
            $sw = [System.Diagnostics.Stopwatch]::StartNew()
            try {
                $response = Invoke-RestMethod -Uri $url -Method Get -TimeoutSec 30
                $sw.Stop()
                $jobResults += @{
                    Success = $true
                    Time = $sw.ElapsedMilliseconds
                    Products = $response.Count
                }
            } catch {
                $sw.Stop()
                $jobResults += @{
                    Success = $false
                    Time = $sw.ElapsedMilliseconds
                    Error = $_.Exception.Message
                }
            }
        }
        return $jobResults
    } -ArgumentList $Url, ([Math]::Floor($TotalRequests / $ConcurrentUsers))
}

Write-Host "Ejecutando pruebas..." -ForegroundColor Yellow

# Esperar a que terminen todos los jobs
$jobs | Wait-Job | Out-Null

# Recopilar resultados
foreach ($job in $jobs) {
    $jobResults = Receive-Job -Job $job
    $results += $jobResults
    Remove-Job -Job $job
}

$globalStopwatch.Stop()

# Calcular estadísticas
$successfulRequests = ($results | Where-Object { $_.Success -eq $true }).Count
$failedRequests = ($results | Where-Object { $_.Success -eq $false }).Count
$responseTimes = ($results | Where-Object { $_.Success -eq $true }).Time

if ($responseTimes.Count -gt 0) {
    $avgTime = ($responseTimes | Measure-Object -Average).Average
    $minTime = ($responseTimes | Measure-Object -Minimum).Minimum
    $maxTime = ($responseTimes | Measure-Object -Maximum).Maximum
} else {
    $avgTime = 0
    $minTime = 0
    $maxTime = 0
}

$throughput = [Math]::Round($successfulRequests / ($globalStopwatch.ElapsedMilliseconds / 1000), 2)

# Mostrar resultados
Write-Host ""
Write-Host "=== RESULTADOS ===" -ForegroundColor Green
Write-Host "Tiempo total: $($globalStopwatch.ElapsedMilliseconds) ms" -ForegroundColor White
Write-Host "Peticiones exitosas: $successfulRequests" -ForegroundColor Green
Write-Host "Peticiones fallidas: $failedRequests" -ForegroundColor $(if($failedRequests -gt 0){"Red"}else{"Green"})
Write-Host ""
Write-Host "=== TIEMPOS DE RESPUESTA ===" -ForegroundColor Cyan
Write-Host "Promedio: $([Math]::Round($avgTime, 2)) ms" -ForegroundColor White
Write-Host "Minimo: $minTime ms" -ForegroundColor White
Write-Host "Maximo: $maxTime ms" -ForegroundColor White
Write-Host ""
Write-Host "=== RENDIMIENTO ===" -ForegroundColor Cyan
Write-Host "Throughput: $throughput req/s" -ForegroundColor White
Write-Host ""

if ($failedRequests -gt 0) {
    Write-Host "Errores encontrados:" -ForegroundColor Red
    $results | Where-Object { $_.Success -eq $false } | Select-Object -First 5 | ForEach-Object {
        Write-Host "  - $($_.Error)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Presiona Enter para salir..."
Read-Host
