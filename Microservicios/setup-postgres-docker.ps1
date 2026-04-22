# Script para crear un contenedor PostgreSQL desde cero para los microservicios
# Contraseña: tesis123
# Puerto: 5433

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Configurando PostgreSQL con Docker" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Configuración
$CONTAINER_NAME = "postgres-microservicios"
$POSTGRES_PASSWORD = "tesis123"
$POSTGRES_USER = "postgres"
$POSTGRES_PORT = "5433"
$POSTGRES_VERSION = "16"

# Paso 1: Detener y eliminar contenedor existente si existe
Write-Host "`n[1/5] Verificando contenedores existentes..." -ForegroundColor Yellow
$existingContainer = docker ps -a --filter "name=$CONTAINER_NAME" --format "{{.ID}}"

if ($existingContainer) {
    Write-Host "  Deteniendo contenedor existente..." -ForegroundColor Yellow
    docker stop $CONTAINER_NAME 2>$null
    Write-Host "  Eliminando contenedor existente..." -ForegroundColor Yellow
    docker rm $CONTAINER_NAME 2>$null
    Write-Host "  [OK] Contenedor anterior eliminado" -ForegroundColor Green
} else {
    Write-Host "  [OK] No hay contenedores previos" -ForegroundColor Green
}

# Paso 2: Verificar si el puerto está libre
Write-Host "`n[2/5] Verificando puerto $POSTGRES_PORT..." -ForegroundColor Yellow
$portInUse = Test-NetConnection -ComputerName localhost -Port $POSTGRES_PORT -InformationLevel Quiet -WarningAction SilentlyContinue

if ($portInUse) {
    Write-Host "  [ADVERTENCIA] El puerto $POSTGRES_PORT está en uso" -ForegroundColor Red
    Write-Host "  Puedes cambiar el puerto o detener el servicio que lo usa" -ForegroundColor Yellow
    $continue = Read-Host "  ¿Deseas continuar de todas formas? (s/n)"
    if ($continue -ne "s") {
        Write-Host "`nOperación cancelada" -ForegroundColor Red
        exit
    }
} else {
    Write-Host "  [OK] Puerto disponible" -ForegroundColor Green
}

# Paso 3: Crear el contenedor
Write-Host "`n[3/5] Creando contenedor PostgreSQL..." -ForegroundColor Yellow
Write-Host "  Nombre: $CONTAINER_NAME" -ForegroundColor Gray
Write-Host "  Version: PostgreSQL $POSTGRES_VERSION" -ForegroundColor Gray
Write-Host "  Puerto: $POSTGRES_PORT" -ForegroundColor Gray
Write-Host "  Usuario: $POSTGRES_USER" -ForegroundColor Gray
Write-Host "  Password: $POSTGRES_PASSWORD" -ForegroundColor Gray

docker run -d `
    --name $CONTAINER_NAME `
    -e POSTGRES_USER=$POSTGRES_USER `
    -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD `
    -e POSTGRES_DB=postgres `
    -p ${POSTGRES_PORT}:5432 `
    -v postgres-data:/var/lib/postgresql/data `
    postgres:$POSTGRES_VERSION

if ($LASTEXITCODE -eq 0) {
    Write-Host "  [OK] Contenedor creado exitosamente" -ForegroundColor Green
} else {
    Write-Host "  [ERROR] Fallo al crear el contenedor" -ForegroundColor Red
    exit 1
}

# Paso 4: Esperar a que PostgreSQL esté listo
Write-Host "`n[4/5] Esperando a que PostgreSQL esté listo..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

$maxAttempts = 30
$attempt = 0
$isReady = $false

while ($attempt -lt $maxAttempts -and -not $isReady) {
    $attempt++
    $testConnection = Test-NetConnection -ComputerName localhost -Port $POSTGRES_PORT -InformationLevel Quiet -WarningAction SilentlyContinue
    
    if ($testConnection) {
        Write-Host "  [OK] PostgreSQL está listo (intento $attempt)" -ForegroundColor Green
        $isReady = $true
    } else {
        Write-Host "  Esperando... (intento $attempt/$maxAttempts)" -ForegroundColor Gray
        Start-Sleep -Seconds 2
    }
}

if (-not $isReady) {
    Write-Host "  [ERROR] PostgreSQL no respondió a tiempo" -ForegroundColor Red
    exit 1
}

# Paso 5: Crear las bases de datos necesarias
Write-Host "`n[5/5] Creando bases de datos..." -ForegroundColor Yellow

$databases = @("auth-service", "productos", "inventario", "ventas")

foreach ($db in $databases) {
    Write-Host "  Creando base de datos: $db" -ForegroundColor Gray
    
    # Crear base de datos usando docker exec
    docker exec -it $CONTAINER_NAME psql -U $POSTGRES_USER -c "CREATE DATABASE `"$db`";" 2>$null
    
    if ($LASTEXITCODE -eq 0 -or $LASTEXITCODE -eq 1) {
        Write-Host "    [OK] $db" -ForegroundColor Green
    } else {
        Write-Host "    [ADVERTENCIA] Puede que $db ya exista" -ForegroundColor Yellow
    }
}

# Resumen final
Write-Host "`n========================================" -ForegroundColor Green
Write-Host "¡PostgreSQL configurado exitosamente!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

Write-Host "`nInformación de conexión:" -ForegroundColor Cyan
Write-Host "  Host: localhost" -ForegroundColor White
Write-Host "  Puerto: $POSTGRES_PORT" -ForegroundColor White
Write-Host "  Usuario: $POSTGRES_USER" -ForegroundColor White
Write-Host "  Password: $POSTGRES_PASSWORD" -ForegroundColor White

Write-Host "`nBases de datos creadas:" -ForegroundColor Cyan
foreach ($db in $databases) {
    Write-Host "  - $db" -ForegroundColor White
}

Write-Host "`nComandos útiles:" -ForegroundColor Cyan
Write-Host "  Ver logs:     docker logs $CONTAINER_NAME" -ForegroundColor Gray
Write-Host "  Detener:      docker stop $CONTAINER_NAME" -ForegroundColor Gray
Write-Host "  Iniciar:      docker start $CONTAINER_NAME" -ForegroundColor Gray
Write-Host "  Eliminar:     docker rm -f $CONTAINER_NAME" -ForegroundColor Gray
Write-Host "  Conectar:     docker exec -it $CONTAINER_NAME psql -U $POSTGRES_USER" -ForegroundColor Gray

Write-Host "`nAhora actualiza las credenciales en los microservicios:" -ForegroundColor Yellow
Write-Host "  .\actualizar-db-config.ps1 -NuevaPassword `"$POSTGRES_PASSWORD`" -NuevoPuerto `"$POSTGRES_PORT`"" -ForegroundColor Gray

Write-Host "`nPresiona cualquier tecla para cerrar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
