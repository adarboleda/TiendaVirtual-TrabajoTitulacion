@echo off
echo ========================================
echo EJECUTANDO PRUEBAS DE INTEGRACION
echo ========================================
echo.

cd Microservicios\msvc-ventas

echo [1/3] Compilando proyecto...
call mvnw.cmd clean compile
if %ERRORLEVEL% neq 0 (
    echo ERROR: Compilacion fallida
    pause
    exit /b 1
)

echo.
echo [2/3] Ejecutando pruebas de integracion...
call mvnw.cmd test -Dtest=VentaIntegrationTest
if %ERRORLEVEL% neq 0 (
    echo ERROR: Pruebas fallidas
    pause
    exit /b 1
)

echo.
echo [3/3] Generando reporte de cobertura...
call mvnw.cmd jacoco:report

echo.
echo ========================================
echo PRUEBAS COMPLETADAS EXITOSAMENTE
echo ========================================
echo.
echo Reporte de cobertura en:
echo target\site\jacoco\index.html
echo.
pause
