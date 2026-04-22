-- Insertar datos de prueba en emprendedores
USE auth_service;

-- Insertar o actualizar emprendedores
INSERT INTO emprendedores (usuario_id, empresa_id, descripcion, activo) 
VALUES 
    (1, 1, 'Emprendedor principal de prueba', TRUE),
    (2, 2, 'Segundo emprendedor de prueba', TRUE),
    (3, 3, 'Tercer emprendedor de prueba', TRUE)
ON DUPLICATE KEY UPDATE 
    empresa_id = VALUES(empresa_id),
    descripcion = VALUES(descripcion),
    fecha_actualizacion = CURRENT_TIMESTAMP;

-- Verificar datos
SELECT 
    e.id,
    e.usuario_id,
    u.username,
    e.empresa_id,
    e.descripcion,
    e.activo
FROM emprendedores e
INNER JOIN usuarios u ON e.usuario_id = u.id;
