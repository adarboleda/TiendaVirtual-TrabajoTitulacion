-- ============================================
-- SEEDS: ventas
-- ============================================

USE ventas;

-- Insertar clientes de prueba
INSERT INTO clientes (nombre, apellido, email, telefono, documento, activo) VALUES
('Juan', 'Pérez', 'juan.perez@ejemplo.com', '0993336635', '1105888034', TRUE),
('María', 'González', 'maria.gonzalez@ejemplo.com', '0996365874', '1104556789', TRUE),
('Carlos', 'Ramírez', 'carlos.ramirez@ejemplo.com', '0993369852', '1103445678', TRUE),
('Ana', 'Martínez', 'ana.martinez@ejemplo.com', '0999999999', '1102334567', TRUE),
('Luis', 'Torres', 'luis.torres@ejemplo.com', '0998888888', '1101223456', TRUE)
ON DUPLICATE KEY UPDATE id=id;
