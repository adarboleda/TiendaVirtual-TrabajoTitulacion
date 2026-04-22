# Script para aplicar la migracion de informacion de pagos en ventas
# Ejecutar desde la raiz del proyecto

Write-Host "======================================" -ForegroundColor Cyan
Write-Host " Migracion: Informacion de Pagos" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

$containerName = "postgres-microservicios"
$dbName = "ventas"
$sqlFile = "actualizar-ventas-pagos.sql"

# Verificar que el contenedor este corriendo
Write-Host "Verificando contenedor PostgreSQL..." -ForegroundColor Yellow
$containerRunning = docker ps --filter "name=$containerName" --filter "status=running" --format "{{.Names}}"

if (-not $containerRunning) {
    Write-Host "Error: El contenedor '$containerName' no esta corriendo" -ForegroundColor Red
    Write-Host "Ejecuta: docker start $containerName" -ForegroundColor Yellow
    exit 1
}

Write-Host "Contenedor encontrado y corriendo" -ForegroundColor Green
Write-Host ""

# Verificar que existe el archivo SQL
if (-not (Test-Path $sqlFile)) {
    Write-Host "Error: No se encuentra el archivo $sqlFile" -ForegroundColor Red
    exit 1
}

Write-Host "Aplicando migracion a la base de datos '$dbName'..." -ForegroundColor Yellow
Write-Host ""

# Ejecutar el script SQL
$resultado = Get-Content $sqlFile | docker exec -i $containerName psql -U postgres -d $dbName 2>&1

# Verificar si hubo errores
if ($LASTEXITCODE -eq 0) {
    Write-Host "Migracion aplicada exitosamente" -ForegroundColor Green
    Write-Host ""
    Write-Host "Columnas agregadas a la tabla ventas:" -ForegroundColor Green
    Write-Host "  - metodo_pago" -ForegroundColor White
    Write-Host "  - estado_pago" -ForegroundColor White
    Write-Host "  - comprobante_pago_url" -ForegroundColor White
    Write-Host "  - referencia_transaccion" -ForegroundColor White
    Write-Host "  - fecha_pago" -ForegroundColor White
    Write-Host ""
    
    # Mostrar los registros actualizados
    Write-Host "Verificando datos..." -ForegroundColor Yellow
    docker exec -it $containerName psql -U postgres -d $dbName -c "SELECT id, numero_factura, total, estado, metodo_pago, estado_pago FROM ventas ORDER BY fecha_venta DESC LIMIT 5;"
}
else {
    Write-Host "Error al aplicar la migracion" -ForegroundColor Red
    Write-Host $resultado
    exit 1
}

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host " Migracion completada" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Ahora puedes:" -ForegroundColor Yellow
Write-Host "1. Reiniciar el microservicio msvc-ventas" -ForegroundColor White
Write-Host "2. Los clientes podran ver el historial completo con estados de pago" -ForegroundColor White
Write-Host "3. Cada venta mostrara el metodo y estado del pago" -ForegroundColor White
