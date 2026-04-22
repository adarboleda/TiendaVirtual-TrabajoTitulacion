# Script simplificado para iniciar cada microservicio uno por uno
# Usa este si el script automático te da problemas

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Guia para Iniciar Microservicios" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "`nPREREQUISITOS:" -ForegroundColor Yellow
Write-Host "1. PostgreSQL debe estar corriendo en puerto 5433" -ForegroundColor White
Write-Host "2. Las bases de datos deben estar creadas (usa crear-bases-datos.sql)" -ForegroundColor White
Write-Host "3. Java 17 instalado" -ForegroundColor White

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "INSTRUCCIONES:" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "`n1. EUREKA SERVER (PRIMERO - OBLIGATORIO)" -ForegroundColor Green
Write-Host "   Abre una nueva terminal y ejecuta:" -ForegroundColor White
Write-Host "   cd eureka-server" -ForegroundColor Gray
Write-Host "   .\mvnw.cmd spring-boot:run" -ForegroundColor Gray
Write-Host "   Espera a ver: 'Eureka Server started'" -ForegroundColor Yellow
Write-Host "   Verifica en: http://localhost:8761" -ForegroundColor Cyan

Write-Host "`n2. AUTH SERVICE" -ForegroundColor Green
Write-Host "   Abre una nueva terminal y ejecuta:" -ForegroundColor White
Write-Host "   cd demo" -ForegroundColor Gray
Write-Host "   .\mvnw.cmd spring-boot:run" -ForegroundColor Gray

Write-Host "`n3. PRODUCTO SERVICE" -ForegroundColor Green
Write-Host "   Abre una nueva terminal y ejecuta:" -ForegroundColor White
Write-Host "   cd msvc-producto" -ForegroundColor Gray
Write-Host "   .\mvnw.cmd spring-boot:run" -ForegroundColor Gray

Write-Host "`n4. INVENTARIO SERVICE" -ForegroundColor Green
Write-Host "   Abre una nueva terminal y ejecuta:" -ForegroundColor White
Write-Host "   cd msvc-inventario" -ForegroundColor Gray
Write-Host "   .\mvnw.cmd spring-boot:run" -ForegroundColor Gray

Write-Host "`n5. VENTAS SERVICE" -ForegroundColor Green
Write-Host "   Abre una nueva terminal y ejecuta:" -ForegroundColor White
Write-Host "   cd msvc-ventas" -ForegroundColor Gray
Write-Host "   .\mvnw.cmd spring-boot:run" -ForegroundColor Gray

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "PUERTOS DE LOS SERVICIOS:" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Eureka Server:  http://localhost:8761" -ForegroundColor White
Write-Host "  Auth Service:   (revisa application.properties)" -ForegroundColor White
Write-Host "  Producto:       http://localhost:8081" -ForegroundColor White
Write-Host "  Inventario:     http://localhost:8082" -ForegroundColor White
Write-Host "  Ventas:         http://localhost:8083" -ForegroundColor White

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "COMANDOS ALTERNOS:" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "Para iniciar automaticamente:" -ForegroundColor Yellow
Write-Host "  .\start-all-services.ps1" -ForegroundColor Gray
Write-Host "`nPara detener todos:" -ForegroundColor Yellow
Write-Host "  .\stop-all-services.ps1" -ForegroundColor Gray

Write-Host "`nPresiona cualquier tecla para cerrar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
