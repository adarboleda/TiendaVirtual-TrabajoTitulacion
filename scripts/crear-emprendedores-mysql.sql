-- ============================================
-- SCRIPT: Crear tabla emprendedores en MySQL
-- Base de datos: auth_service
-- ============================================

USE auth_service;

-- Crear tabla emprendedores si no existe
CREATE TABLE IF NOT EXISTS emprendedores (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    usuario_id BIGINT NOT NULL UNIQUE,
    empresa_id BIGINT NULL,
    descripcion TEXT,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_emprendedor_usuario FOREIGN KEY (usuario_id) 
        REFERENCES usuarios(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Índices para búsquedas rápidas (ignorar si ya existen)
CREATE INDEX idx_emprendedores_usuario_id ON emprendedores(usuario_id);
CREATE INDEX idx_emprendedores_empresa_id ON emprendedores(empresa_id);

-- Insertar datos de prueba (vinculando usuarios con empresas)
-- Asumiendo que ya existen usuarios con IDs 1, 2, 3, etc.
INSERT INTO emprendedores (usuario_id, empresa_id, descripcion, activo) 
VALUES 
    (1, 1, 'Emprendedor principal de prueba', TRUE),
    (2, 2, 'Segundo emprendedor de prueba', TRUE),
    (3, 3, 'Tercer emprendedor de prueba', TRUE)
ON DUPLICATE KEY UPDATE 
    empresa_id = VALUES(empresa_id),
    descripcion = VALUES(descripcion),
    fecha_actualizacion = CURRENT_TIMESTAMP;

-- Verificar datos insertados
SELECT 
    e.id,
    e.usuario_id,
    u.username,
    e.empresa_id,
    e.descripcion,
    e.activo
FROM emprendedores e
INNER JOIN usuarios u ON e.usuario_id = u.id;
