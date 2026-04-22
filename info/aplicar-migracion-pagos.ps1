# Script para aplicar la migración de configuración de métodos de pago
# Ejecutar desde la raíz del proyecto

Write-Host "======================================" -ForegroundColor Cyan
Write-Host " Migración: Configuración Métodos Pago" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

$containerName = "postgres-microservicios"
$dbName = "auth-service"
$sqlFile = "configuracion-metodos-pago.sql"

# Verificar que el contenedor esté corriendo
Write-Host "Verificando contenedor PostgreSQL..." -ForegroundColor Yellow
$containerRunning = docker ps --filter "name=$containerName" --filter "status=running" --format "{{.Names}}"

if (-not $containerRunning) {
    Write-Host "Error: El contenedor '$containerName' no está corriendo" -ForegroundColor Red
    Write-Host "Ejecuta: docker start $containerName" -ForegroundColor Yellow
    exit 1
}

Write-Host "✓ Contenedor encontrado y corriendo" -ForegroundColor Green
Write-Host ""

# Verificar que existe el archivo SQL
if (-not (Test-Path $sqlFile)) {
    Write-Host "Error: No se encuentra el archivo $sqlFile" -ForegroundColor Red
    exit 1
}

Write-Host "Aplicando migración a la base de datos '$dbName'..." -ForegroundColor Yellow
Write-Host ""

# Ejecutar el script SQL
$resultado = Get-Content $sqlFile | docker exec -i $containerName psql -U postgres -d $dbName 2>&1

# Verificar si hubo errores
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Migración aplicada exitosamente" -ForegroundColor Green
    Write-Host ""
    Write-Host "Tabla 'configuracion_metodos_pago' creada" -ForegroundColor Green
    Write-Host ""
    
    # Mostrar los registros creados
    Write-Host "Verificando datos..." -ForegroundColor Yellow
    docker exec -it $containerName psql -U postgres -d $dbName -c "SELECT id, emprendedor_id, banco, numero_cuenta, qr_deuna_url FROM configuracion_metodos_pago;"
} else {
    Write-Host "✗ Error al aplicar la migración" -ForegroundColor Red
    Write-Host $resultado
    exit 1
}

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host " Migración completada" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Ahora puedes:" -ForegroundColor Yellow
Write-Host "1. Reiniciar el microservicio msvc-auth (demo)" -ForegroundColor White
Write-Host "2. Acceder como emprendedor para configurar métodos de pago" -ForegroundColor White
Write-Host "3. Los clientes podrán ver el QR de Deuna y datos bancarios" -ForegroundColor White
