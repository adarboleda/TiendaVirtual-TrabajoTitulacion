# ============================================
# Script PowerShell: Recrear bases de datos
# Descripción: Ejecuta el script SQL maestro para recrear todas las bases de datos
# ============================================

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "RECREACIÓN DE BASES DE DATOS" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Configuración
$POSTGRES_HOST = "localhost"
$POSTGRES_PORT = "5433"
$POSTGRES_USER = "postgres"
$POSTGRES_PASSWORD = "tesis123"
$SCRIPT_DIR = $PSScriptRoot

# Configurar variable de entorno para la contraseña
$env:PGPASSWORD = $POSTGRES_PASSWORD

Write-Host "Configuración:" -ForegroundColor Yellow
Write-Host "  Host: $POSTGRES_HOST" -ForegroundColor Gray
Write-Host "  Puerto: $POSTGRES_PORT" -ForegroundColor Gray
Write-Host "  Usuario: $POSTGRES_USER" -ForegroundColor Gray
Write-Host "  Directorio: $SCRIPT_DIR" -ForegroundColor Gray
Write-Host ""

# Verificar que PostgreSQL esté corriendo
Write-Host "Verificando conexión a PostgreSQL..." -ForegroundColor Yellow
$connectionTest = Test-NetConnection -ComputerName $POSTGRES_HOST -Port $POSTGRES_PORT -InformationLevel Quiet

if (-not $connectionTest) {
    Write-Host "ERROR: No se puede conectar a PostgreSQL en $POSTGRES_HOST`:$POSTGRES_PORT" -ForegroundColor Red
    Write-Host "Asegúrate de que PostgreSQL esté corriendo." -ForegroundColor Red
    Write-Host ""
    Read-Host "Presiona Enter para salir"
    exit 1
}

Write-Host "Conexión exitosa." -ForegroundColor Green
Write-Host ""

# Advertencia
Write-Host "============================================" -ForegroundColor Red
Write-Host "ADVERTENCIA" -ForegroundColor Red
Write-Host "============================================" -ForegroundColor Red
Write-Host "Este script ELIMINARÁ todas las bases de datos existentes:" -ForegroundColor Red
Write-Host "  - auth-service" -ForegroundColor Red
Write-Host "  - productos" -ForegroundColor Red
Write-Host "  - inventario" -ForegroundColor Red
Write-Host "  - ventas" -ForegroundColor Red
Write-Host ""
Write-Host "Y las recreará con el nuevo esquema incluyendo:" -ForegroundColor Yellow
Write-Host "  + Tabla emprendedores en auth-service" -ForegroundColor Green
Write-Host "  + Campo emprendedor_id en productos" -ForegroundColor Green
Write-Host "  + Campo emprendedor_id en ventas y detalles_venta" -ForegroundColor Green
Write-Host "  + Tabla pagos para métodos de pago (Transferencia, Tarjeta, Deuna)" -ForegroundColor Green
Write-Host "  + Mejoras en índices para mejor rendimiento" -ForegroundColor Green
Write-Host ""

$confirmacion = Read-Host "¿Estás seguro de continuar? (escribe 'SI' para continuar)"

if ($confirmacion -ne "SI") {
    Write-Host ""
    Write-Host "Operación cancelada por el usuario." -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Presiona Enter para salir"
    exit 0
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "EJECUTANDO SCRIPTS SQL" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

try {
    # Cambiar al directorio de scripts
    Set-Location $SCRIPT_DIR

    # Ejecutar script maestro
    Write-Host "Ejecutando script maestro..." -ForegroundColor Yellow
    
    $psqlArgs = @(
        "-h", $POSTGRES_HOST,
        "-p", $POSTGRES_PORT,
        "-U", $POSTGRES_USER,
        "-d", "postgres",
        "-f", "recrear-bases-datos-completo.sql"
    )
    
    $process = Start-Process -FilePath "psql" -ArgumentList $psqlArgs -NoNewWindow -Wait -PassThru
    
    if ($process.ExitCode -eq 0) {
        Write-Host ""
        Write-Host "============================================" -ForegroundColor Green
        Write-Host "PROCESO COMPLETADO EXITOSAMENTE" -ForegroundColor Green
        Write-Host "============================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "Las bases de datos han sido recreadas con éxito." -ForegroundColor Green
        Write-Host ""
        Write-Host "Próximos pasos:" -ForegroundColor Yellow
        Write-Host "  1. Actualizar las entidades JPA en los microservicios" -ForegroundColor Gray
        Write-Host "  2. Actualizar los DTOs para incluir emprendedor_id" -ForegroundColor Gray
        Write-Host "  3. Reiniciar todos los microservicios" -ForegroundColor Gray
        Write-Host "  4. Probar el flujo de compra completo" -ForegroundColor Gray
        Write-Host ""
    } else {
        Write-Host ""
        Write-Host "ERROR: El script falló con código de salida $($process.ExitCode)" -ForegroundColor Red
        Write-Host "Revisa los mensajes de error anteriores." -ForegroundColor Red
        Write-Host ""
    }
    
} catch {
    Write-Host ""
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
} finally {
    # Limpiar variable de entorno
    Remove-Item Env:PGPASSWORD -ErrorAction SilentlyContinue
}

Write-Host ""
Read-Host "Presiona Enter para salir"
