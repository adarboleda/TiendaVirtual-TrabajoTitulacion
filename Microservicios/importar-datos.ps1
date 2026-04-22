# Script para importar los dumps de las bases de datos
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Importando datos a PostgreSQL" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$CONTAINER_NAME = "postgres-microservicios"
$DUMPS_PATH = "C:\Users\mycke\Desktop\TrabajoTitulacion-main\TrabajoTitulacion-main"

# Verificar que el contenedor esté corriendo
Write-Host "`n[1/4] Verificando contenedor PostgreSQL..." -ForegroundColor Yellow
$containerStatus = docker ps --filter "name=$CONTAINER_NAME" --format "{{.Status}}"

if (-not $containerStatus) {
    Write-Host "  [ERROR] El contenedor no está corriendo. Inicia PostgreSQL primero." -ForegroundColor Red
    exit 1
}
Write-Host "  [OK] Contenedor activo" -ForegroundColor Green

# Importar productos
Write-Host "`n[2/4] Importando base de datos: productos" -ForegroundColor Yellow
$productosFile = Join-Path $DUMPS_PATH "productos"
if (Test-Path $productosFile) {
    Get-Content $productosFile | docker exec -i $CONTAINER_NAME psql -U postgres -d productos
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  [OK] Productos importados" -ForegroundColor Green
    } else {
        Write-Host "  [ADVERTENCIA] Hubo algunos errores al importar productos" -ForegroundColor Yellow
    }
} else {
    Write-Host "  [ERROR] No se encontró el archivo: $productosFile" -ForegroundColor Red
}

# Importar inventario
Write-Host "`n[3/4] Importando base de datos: inventario" -ForegroundColor Yellow
$inventarioFile = Join-Path $DUMPS_PATH "inventario"
if (Test-Path $inventarioFile) {
    Get-Content $inventarioFile | docker exec -i $CONTAINER_NAME psql -U postgres -d inventario
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  [OK] Inventario importado" -ForegroundColor Green
    } else {
        Write-Host "  [ADVERTENCIA] Hubo algunos errores al importar inventario" -ForegroundColor Yellow
    }
} else {
    Write-Host "  [ERROR] No se encontró el archivo: $inventarioFile" -ForegroundColor Red
}

# Importar ventas
Write-Host "`n[4/4] Importando base de datos: ventas" -ForegroundColor Yellow
$ventasFile = Join-Path $DUMPS_PATH "ventas"
if (Test-Path $ventasFile) {
    Get-Content $ventasFile | docker exec -i $CONTAINER_NAME psql -U postgres -d ventas
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  [OK] Ventas importadas" -ForegroundColor Green
    } else {
        Write-Host "  [ADVERTENCIA] Hubo algunos errores al importar ventas" -ForegroundColor Yellow
    }
} else {
    Write-Host "  [ERROR] No se encontró el archivo: $ventasFile" -ForegroundColor Red
}

# Verificar los datos importados
Write-Host "`n========================================" -ForegroundColor Green
Write-Host "Verificando datos importados" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

Write-Host "`nProductos:" -ForegroundColor Cyan
docker exec $CONTAINER_NAME psql -U postgres -d productos -c "SELECT COUNT(*) as total_productos FROM productos;"

Write-Host "`nInventario:" -ForegroundColor Cyan
docker exec $CONTAINER_NAME psql -U postgres -d inventario -c "SELECT COUNT(*) as total_inventarios FROM inventarios;"

Write-Host "`nVentas:" -ForegroundColor Cyan
docker exec $CONTAINER_NAME psql -U postgres -d ventas -c "SELECT COUNT(*) as total_ventas FROM ventas;"

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "Importación completada!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

Write-Host "`nAhora puedes iniciar los microservicios:" -ForegroundColor Yellow
Write-Host "  .\start-all-services.ps1" -ForegroundColor Gray

Write-Host "`nPresiona cualquier tecla para cerrar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
