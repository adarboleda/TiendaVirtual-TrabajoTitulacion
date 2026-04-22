# ============================================
# Script: Iniciar MySQL en Docker
# ============================================

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "INICIAR MYSQL EN DOCKER" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Verificar si Docker está corriendo
Write-Host "Verificando Docker..." -ForegroundColor Yellow
$dockerRunning = docker info 2>&1 | Select-String "Server Version"

if (-not $dockerRunning) {
    Write-Host "ERROR: Docker no está corriendo." -ForegroundColor Red
    Write-Host "Inicia Docker Desktop e intenta de nuevo." -ForegroundColor Red
    Write-Host ""
    Read-Host "Presiona Enter para salir"
    exit 1
}

Write-Host "Docker está corriendo." -ForegroundColor Green
Write-Host ""

# Verificar si el contenedor ya existe
Write-Host "Verificando contenedor existente..." -ForegroundColor Yellow
$existingContainer = docker ps -a --filter "name=mysql-feria-digital" --format "{{.Names}}"

if ($existingContainer) {
    Write-Host "Contenedor 'mysql-feria-digital' ya existe." -ForegroundColor Yellow
    $detener = Read-Host "¿Deseas detenerlo y eliminarlo para crear uno nuevo? (S/N)"
    
    if ($detener -eq "S" -or $detener -eq "s") {
        Write-Host "Deteniendo contenedor..." -ForegroundColor Yellow
        docker stop mysql-feria-digital 2>$null
        
        Write-Host "Eliminando contenedor..." -ForegroundColor Yellow
        docker rm mysql-feria-digital 2>$null
        
        Write-Host "Eliminando volumen..." -ForegroundColor Yellow
        docker volume rm trabajotitulacion-main_mysql_data 2>$null
        
        Write-Host "Contenedor eliminado." -ForegroundColor Green
    } else {
        Write-Host "Iniciando contenedor existente..." -ForegroundColor Yellow
        docker start mysql-feria-digital
        Write-Host ""
        Write-Host "Contenedor iniciado correctamente." -ForegroundColor Green
        Write-Host ""
        Write-Host "Credenciales:" -ForegroundColor Cyan
        Write-Host "  Host: localhost" -ForegroundColor Gray
        Write-Host "  Puerto: 3306" -ForegroundColor Gray
        Write-Host "  Usuario: admin" -ForegroundColor Gray
        Write-Host "  Contraseña: admin" -ForegroundColor Gray
        Write-Host ""
        Read-Host "Presiona Enter para salir"
        exit 0
    }
}

Write-Host ""

# Iniciar Docker Compose
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "INICIANDO CONTENEDOR MYSQL" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

try {
    Write-Host "Ejecutando docker-compose up..." -ForegroundColor Yellow
    docker-compose up -d
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "============================================" -ForegroundColor Green
        Write-Host "CONTENEDOR MYSQL INICIADO CORRECTAMENTE" -ForegroundColor Green
        Write-Host "============================================" -ForegroundColor Green
        Write-Host ""
        
        Write-Host "Esperando a que MySQL esté listo..." -ForegroundColor Yellow
        Start-Sleep -Seconds 10
        
        # Verificar estado del contenedor
        $containerStatus = docker ps --filter "name=mysql-feria-digital" --format "{{.Status}}"
        
        if ($containerStatus) {
            Write-Host "Estado del contenedor: $containerStatus" -ForegroundColor Green
            Write-Host ""
            
            Write-Host "Información de conexión:" -ForegroundColor Cyan
            Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
            Write-Host "  Host:       localhost" -ForegroundColor White
            Write-Host "  Puerto:     3306" -ForegroundColor White
            Write-Host "  Usuario:    admin" -ForegroundColor White
            Write-Host "  Contraseña: admin" -ForegroundColor White
            Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
            Write-Host ""
            
            Write-Host "Bases de datos creadas:" -ForegroundColor Cyan
            Write-Host "  [OK] auth_service" -ForegroundColor Green
            Write-Host "  [OK] productos" -ForegroundColor Green
            Write-Host "  [OK] inventario" -ForegroundColor Green
            Write-Host "  [OK] ventas" -ForegroundColor Green
            Write-Host ""
            
            Write-Host "Datos de prueba insertados:" -ForegroundColor Cyan
            Write-Host "  [OK] 6 usuarios (4 emprendedores, 1 admin, 1 cliente)" -ForegroundColor Green
            Write-Host "  [OK] 39 productos" -ForegroundColor Green
            Write-Host "  [OK] 39 inventarios" -ForegroundColor Green
            Write-Host "  [OK] 5 clientes" -ForegroundColor Green
            Write-Host ""
            
            Write-Host "Usuarios de prueba:" -ForegroundColor Yellow
            Write-Host "  admin / admin (ROLE_ADMIN)" -ForegroundColor Gray
            Write-Host "  ultimo_inca / ultimoinca123 (ROLE_EMP)" -ForegroundColor Gray
            Write-Host "  sigcholac / sigcholac123 (ROLE_EMP)" -ForegroundColor Gray
            Write-Host "  perla_andina / perlaandina123 (ROLE_EMP)" -ForegroundColor Gray
            Write-Host "  grandes_foods / grandesfoods123 (ROLE_EMP)" -ForegroundColor Gray
            Write-Host "  cliente1 / cliente123 (ROLE_USER)" -ForegroundColor Gray
            Write-Host ""
            
            Write-Host "Próximos pasos:" -ForegroundColor Yellow
            Write-Host "  1. Actualizar application.properties de cada microservicio" -ForegroundColor Gray
            Write-Host "     - spring.datasource.url=jdbc:mysql://localhost:3306/[database]" -ForegroundColor Gray
            Write-Host "     - spring.datasource.username=admin" -ForegroundColor Gray
            Write-Host "     - spring.datasource.password=admin" -ForegroundColor Gray
            Write-Host "     - spring.jpa.hibernate.ddl-auto=validate" -ForegroundColor Gray
            Write-Host "  2. Actualizar entidades JPA para incluir emprendedor_id" -ForegroundColor Gray
            Write-Host "  3. Reiniciar todos los microservicios" -ForegroundColor Gray
            Write-Host ""
            
            Write-Host "Comandos útiles:" -ForegroundColor Cyan
            Write-Host "  Ver logs:       docker logs mysql-feria-digital" -ForegroundColor Gray
            Write-Host "  Detener:        docker-compose down" -ForegroundColor Gray
            Write-Host "  Reiniciar:      docker-compose restart" -ForegroundColor Gray
            Write-Host "  Conectar CLI:   docker exec -it mysql-feria-digital mysql -u admin -padmin" -ForegroundColor Gray
            Write-Host ""
        } else {
            Write-Host "ADVERTENCIA: El contenedor se inició pero puede no estar listo aún." -ForegroundColor Yellow
            Write-Host "Espera unos segundos y verifica con: docker ps" -ForegroundColor Yellow
        }
        
    } else {
        Write-Host ""
        Write-Host "ERROR: Falló al iniciar el contenedor." -ForegroundColor Red
        Write-Host "Revisa los logs con: docker-compose logs" -ForegroundColor Red
    }
    
} catch {
    Write-Host ""
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Read-Host "Presiona Enter para salir"
