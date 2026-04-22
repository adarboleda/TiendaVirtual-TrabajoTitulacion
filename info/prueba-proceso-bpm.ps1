# Script de prueba para Proceso BPM de Venta Completa
# Fecha: Febrero 2026

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  PRUEBA DE PROCESO BPM - VENTA COMPLETA" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$baseUrl = "http://localhost:8083"

# Test 1: Proceso Exitoso
Write-Host "📋 TEST 1: Proceso de Venta Exitoso" -ForegroundColor Green
Write-Host "-----------------------------------" -ForegroundColor Green

$ventaExitosa = @{
    clienteId = 1
    items = @(
        @{
            productoId = 1
            cantidad = 1
        }
    )
    metodoPago = "TARJETA"
} | ConvertTo-Json -Depth 3

try {
    Write-Host "Iniciando proceso BPM..." -ForegroundColor Yellow
    $response1 = Invoke-RestMethod -Uri "$baseUrl/api/bpm/ventas/iniciar" -Method Post -Body $ventaExitosa -ContentType "application/json"
    Write-Host "✅ Proceso iniciado exitosamente" -ForegroundColor Green
    Write-Host "Process Instance ID: $($response1.processInstanceId)" -ForegroundColor Cyan
    Write-Host "Estado: $($response1.estadoProceso)" -ForegroundColor Cyan
    if ($response1.ventaId) {
        Write-Host "Venta ID: $($response1.ventaId)" -ForegroundColor Cyan
        Write-Host "Factura: $($response1.numeroFactura)" -ForegroundColor Cyan
        Write-Host "Total: $($response1.total)" -ForegroundColor Cyan
    }
    Write-Host ""
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
}

Start-Sleep -Seconds 2

# Test 2: Producto Inexistente
Write-Host "📋 TEST 2: Producto Inexistente (Debe Fallar)" -ForegroundColor Yellow
Write-Host "-----------------------------------" -ForegroundColor Yellow

$ventaProductoInvalido = @{
    clienteId = 1
    items = @(
        @{
            productoId = 99999
            cantidad = 1
        }
    )
    metodoPago = "TARJETA"
} | ConvertTo-Json -Depth 3

try {
    Write-Host "Iniciando proceso BPM con producto inválido..." -ForegroundColor Yellow
    $response2 = Invoke-RestMethod -Uri "$baseUrl/api/bpm/ventas/iniciar" -Method Post -Body $ventaProductoInvalido -ContentType "application/json"
    Write-Host "✅ Proceso iniciado" -ForegroundColor Green
    Write-Host "Process Instance ID: $($response2.processInstanceId)" -ForegroundColor Cyan
    Write-Host "Estado: $($response2.estadoProceso)" -ForegroundColor Cyan
    if ($response2.motivo) {
        Write-Host "Motivo: $($response2.motivo)" -ForegroundColor Red
    }
    Write-Host ""
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
}

Start-Sleep -Seconds 2

# Test 3: Stock Insuficiente
Write-Host "📋 TEST 3: Stock Insuficiente (Debe Fallar)" -ForegroundColor Yellow
Write-Host "-----------------------------------" -ForegroundColor Yellow

$ventaStockInsuficiente = @{
    clienteId = 1
    items = @(
        @{
            productoId = 1
            cantidad = 10000
        }
    )
    metodoPago = "TRANSFERENCIA"
} | ConvertTo-Json -Depth 3

try {
    Write-Host "Iniciando proceso BPM con stock insuficiente..." -ForegroundColor Yellow
    $response3 = Invoke-RestMethod -Uri "$baseUrl/api/bpm/ventas/iniciar" -Method Post -Body $ventaStockInsuficiente -ContentType "application/json"
    Write-Host "✅ Proceso iniciado" -ForegroundColor Green
    Write-Host "Process Instance ID: $($response3.processInstanceId)" -ForegroundColor Cyan
    Write-Host "Estado: $($response3.estadoProceso)" -ForegroundColor Cyan
    if ($response3.motivo) {
        Write-Host "Motivo: $($response3.motivo)" -ForegroundColor Red
    }
    Write-Host ""
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
}

Start-Sleep -Seconds 2

# Test 4: Venta con Múltiples Productos
Write-Host "📋 TEST 4: Venta con Múltiples Productos" -ForegroundColor Green
Write-Host "-----------------------------------" -ForegroundColor Green

$ventaMultiple = @{
    clienteId = 1
    items = @(
        @{
            productoId = 1
            cantidad = 2
        },
        @{
            productoId = 2
            cantidad = 1
        }
    )
    metodoPago = "DEUNA"
} | ConvertTo-Json -Depth 3

try {
    Write-Host "Iniciando proceso BPM con múltiples productos..." -ForegroundColor Yellow
    $response4 = Invoke-RestMethod -Uri "$baseUrl/api/bpm/ventas/iniciar" -Method Post -Body $ventaMultiple -ContentType "application/json"
    Write-Host "✅ Proceso iniciado exitosamente" -ForegroundColor Green
    Write-Host "Process Instance ID: $($response4.processInstanceId)" -ForegroundColor Cyan
    Write-Host "Estado: $($response4.estadoProceso)" -ForegroundColor Cyan
    if ($response4.ventaId) {
        Write-Host "Venta ID: $($response4.ventaId)" -ForegroundColor Cyan
        Write-Host "Factura: $($response4.numeroFactura)" -ForegroundColor Cyan
        Write-Host "Total: $($response4.total)" -ForegroundColor Cyan
    }
    Write-Host ""
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
}

Start-Sleep -Seconds 2

# Test 5: Consultar Procesos Activos
Write-Host "📋 TEST 5: Listar Procesos Activos" -ForegroundColor Cyan
Write-Host "-----------------------------------" -ForegroundColor Cyan

try {
    Write-Host "Consultando procesos activos..." -ForegroundColor Yellow
    $procesosActivos = Invoke-RestMethod -Uri "$baseUrl/api/bpm/ventas/procesos-activos" -Method Get
    Write-Host "✅ Total de procesos activos: $($procesosActivos.totalProcesos)" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  PRUEBAS COMPLETADAS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "💡 TIP: Accede a Camunda Cockpit en: http://localhost:8083/camunda" -ForegroundColor Yellow
Write-Host "   Usuario: admin / Contraseña: admin" -ForegroundColor Yellow
Write-Host ""
