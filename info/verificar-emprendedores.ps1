# Script para verificar y corregir datos de emprendedores
Write-Host "=== VERIFICACIÓN DE EMPRENDEDORES ===" -ForegroundColor Cyan

# Conectar a PostgreSQL (auth-service)
$query = @"
-- Verificar usuarios y emprendedores
SELECT 
    u.id as usuario_id,
    u.username,
    u.nombre,
    e.id as emprendedor_id,
    e.empresa_id,
    e.activo
FROM usuarios u
LEFT JOIN emprendedores e ON u.id = e.usuario_id
WHERE u.username IN ('ultimo_inca', 'sigcholac', 'perla_andina', 'grandes_foods')
ORDER BY u.id;

-- Si no hay emprendedores, insertar datos
INSERT INTO public.emprendedores (usuario_id, empresa_id, descripcion, activo)
SELECT u.id, 1, 'Emprendedor de prueba', true
FROM usuarios u 
WHERE u.username = 'ultimo_inca' 
AND NOT EXISTS (SELECT 1 FROM emprendedores WHERE usuario_id = u.id);

INSERT INTO public.emprendedores (usuario_id, empresa_id, descripcion, activo)
SELECT u.id, 2, 'Emprendedor de prueba', true
FROM usuarios u 
WHERE u.username = 'sigcholac'
AND NOT EXISTS (SELECT 1 FROM emprendedores WHERE usuario_id = u.id);

INSERT INTO public.emprendedores (usuario_id, empresa_id, descripcion, activo)
SELECT u.id, 3, 'Emprendedor de prueba', true
FROM usuarios u 
WHERE u.username = 'perla_andina'
AND NOT EXISTS (SELECT 1 FROM emprendedores WHERE usuario_id = u.id);

INSERT INTO public.emprendedores (usuario_id, empresa_id, descripcion, activo)
SELECT u.id, 4, 'Emprendedor de prueba', true
FROM usuarios u 
WHERE u.username = 'grandes_foods'
AND NOT EXISTS (SELECT 1 FROM emprendedores WHERE usuario_id = u.id);

-- Verificar resultado final
SELECT 
    u.username,
    e.empresa_id,
    e.descripcion
FROM usuarios u
INNER JOIN emprendedores e ON u.id = e.usuario_id;
"@

# Ejecutar query en PostgreSQL
docker exec -i postgres-auth psql -U postgres -d auth_service -c "$query"

Write-Host "`n✅ Verificación completada" -ForegroundColor Green
Write-Host "Ahora haz LOGOUT y LOGIN nuevamente en el navegador" -ForegroundColor Yellow
