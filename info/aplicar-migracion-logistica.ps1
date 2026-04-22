# Script para aplicar migracion de Seguimiento Logistico
# Fecha: 2026-01-04

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Aplicando Migracion: Seguimiento Logistico" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Verificar que el contenedor de MySQL este corriendo
Write-Host "[1/3] Verificando contenedor MySQL..." -ForegroundColor Yellow
$container = docker ps --filter "name=mysql-feria-digital" --format "{{.Names}}"

if ($container -ne "mysql-feria-digital") {
    Write-Host "ERROR: El contenedor mysql-feria-digital no esta corriendo" -ForegroundColor Red
    Write-Host "Ejecuta: docker-compose up -d" -ForegroundColor Yellow
    exit 1
}

Write-Host "Contenedor MySQL corriendo" -ForegroundColor Green
Write-Host ""

# Aplicar migracion
Write-Host "[2/3] Aplicando migracion de seguimiento logistico..." -ForegroundColor Yellow
Get-Content scripts/crear-tabla-seguimiento-logistica.sql | docker exec -i mysql-feria-digital mysql -uadmin -padmin ventas

if ($LASTEXITCODE -eq 0) {
    Write-Host "Migracion aplicada exitosamente" -ForegroundColor Green
} else {
    Write-Host "ERROR: Fallo la migracion" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Verificar tabla creada
Write-Host "[3/3] Verificando tabla creada..." -ForegroundColor Yellow
docker exec mysql-feria-digital mysql -uadmin -padmin -e "USE ventas; SHOW TABLES LIKE 'seguimiento_logistica';"

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Migracion Completada" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Proximos pasos:" -ForegroundColor Yellow
Write-Host "1. Reiniciar el microservicio msvc-ventas" -ForegroundColor White
Write-Host "2. Probar los nuevos endpoints de seguimiento" -ForegroundColor White
Write-Host ""
