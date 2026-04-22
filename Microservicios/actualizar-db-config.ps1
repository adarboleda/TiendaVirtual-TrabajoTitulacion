# Script para actualizar la configuracion de PostgreSQL en todos los microservicios
param(
    [Parameter(Mandatory=$true)]
    [string]$NuevaPassword,
    
    [Parameter(Mandatory=$false)]
    [string]$NuevoPuerto = "5433",
    
    [Parameter(Mandatory=$false)]
    [string]$NuevoUsuario = "postgres"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Actualizando configuracion de PostgreSQL" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$archivos = @(
    "demo\src\main\resources\application.properties",
    "msvc-producto\src\main\resources\application.properties",
    "msvc-inventario\src\main\resources\application.properties",
    "msvc-ventas\src\main\resources\application.properties"
)

foreach ($archivo in $archivos) {
    $rutaCompleta = Join-Path $PSScriptRoot $archivo
    
    if (Test-Path $rutaCompleta) {
        Write-Host "`nActualizando: $archivo" -ForegroundColor Yellow
        
        $contenido = Get-Content $rutaCompleta -Raw
        
        # Actualizar password
        $contenido = $contenido -replace "spring.datasource.password=.*", "spring.datasource.password=$NuevaPassword"
        
        # Actualizar puerto si es diferente
        $contenido = $contenido -replace "jdbc:postgresql://localhost:\d+/", "jdbc:postgresql://localhost:$NuevoPuerto/"
        
        # Actualizar usuario
        $contenido = $contenido -replace "spring.datasource.username=.*", "spring.datasource.username=$NuevoUsuario"
        
        # Guardar cambios
        $contenido | Set-Content $rutaCompleta -NoNewline
        
        Write-Host "[OK] Archivo actualizado" -ForegroundColor Green
    } else {
        Write-Host "[ERROR] No se encontro: $archivo" -ForegroundColor Red
    }
}

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "Configuracion actualizada!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "`nNuevas credenciales:" -ForegroundColor Cyan
Write-Host "  Usuario: $NuevoUsuario" -ForegroundColor White
Write-Host "  Password: $NuevaPassword" -ForegroundColor White
Write-Host "  Puerto: $NuevoPuerto" -ForegroundColor White
Write-Host "`nAhora puedes ejecutar: .\start-all-services.ps1" -ForegroundColor Yellow
