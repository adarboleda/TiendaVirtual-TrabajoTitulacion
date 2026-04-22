-- ============================================
-- SEEDS: auth_service
-- ============================================

USE auth_service;

-- Insertar usuarios
INSERT INTO usuarios (username, email, password, nombre, apellido, telefono, activo) VALUES
('admin', 'admin@feriadigital.com', '$2a$10$7qQ1q8kNQf7tIYtG1s0qUu2gG6Zc3U5m9KpJx3HqX1zQ8o9sF1B3u', 'Administrador', 'Sistema', '0999999999', TRUE),
('ultimo_inca', 'contacto@ultimoinca.com', '$2a$10$LlOExy4xrjeQrf97migX6ekemzoyHMzseC1bsvt4RCKzedAvvTQrq', 'María', 'Quispe', '0997279323', TRUE),
('sigcholac', 'sigcholac@gmail.com', '$2a$10$kywJj9SI7ZW2CWuNlBPY/uFmZjjM9TuDakkeD8srL9TZtma59zsAS', 'Pedro', 'Guamán', '0992000198', TRUE),
('perla_andina', 'perlaandina@gmail.com', '$2a$10$N7qX3vK4mRdP8fLtY2nGzOzY1wH5sK9jP2mQ4rT6vZ8xL3yU5bN2a', 'Ana', 'Morocho', '0993396358', TRUE),
('grandes_foods', 'info@grandesfoods.com', '$2a$10$P8rY4wL5nSeQ9gMuZ3oHAOAZ2xI6tL0kQ3nR5sU7wA9yM4zV6cO3b', 'Carlos', 'Ramírez', '0993665065', TRUE),
('cliente1', 'cliente@ejemplo.com', '$2a$10$R9sZ5xM6oTfR0hNvA4pIBPBA3yJ7uM1lR4oS6tV8xB0zN5Aw7dP4c', 'Juan', 'Pérez', '0993336635', TRUE)
ON DUPLICATE KEY UPDATE id=id;

-- Asignar roles
INSERT INTO usuario_roles (usuario_id, rol)
SELECT id, 'ROLE_ADMIN' FROM usuarios WHERE username = 'admin'
ON DUPLICATE KEY UPDATE usuario_id=usuario_id;

INSERT INTO usuario_roles (usuario_id, rol)
SELECT id, 'ROLE_EMP' FROM usuarios WHERE username IN ('ultimo_inca', 'sigcholac', 'perla_andina', 'grandes_foods')
ON DUPLICATE KEY UPDATE usuario_id=usuario_id;

INSERT INTO usuario_roles (usuario_id, rol)
SELECT id, 'ROLE_USER' FROM usuarios WHERE username = 'cliente1'
ON DUPLICATE KEY UPDATE usuario_id=usuario_id;

-- Crear emprendedores
INSERT INTO emprendedores (usuario_id, empresa_id, descripcion, activo)
SELECT 
    u.id, 
    1,
    'Producción artesanal de vinos de frutas andinas. Especialidad en vino de mortiño, frambuesa, pitahaya y maracuyá.',
    TRUE
FROM usuarios u 
WHERE u.username = 'ultimo_inca'
ON DUPLICATE KEY UPDATE usuario_id=usuario_id;

INSERT INTO emprendedores (usuario_id, empresa_id, descripcion, activo)
SELECT 
    u.id, 
    2,
    'Producción y comercialización de productos lácteos artesanales: queso fresco, queso mozzarella, yogurt.',
    TRUE
FROM usuarios u 
WHERE u.username = 'sigcholac'
ON DUPLICATE KEY UPDATE usuario_id=usuario_id;

INSERT INTO emprendedores (usuario_id, empresa_id, descripcion, activo)
SELECT 
    u.id, 
    3,
    'Vinos premium de frutas andinas. Especialidad en vinos dulces y secos.',
    TRUE
FROM usuarios u 
WHERE u.username = 'perla_andina'
ON DUPLICATE KEY UPDATE usuario_id=usuario_id;

INSERT INTO emprendedores (usuario_id, empresa_id, descripcion, activo)
SELECT 
    u.id, 
    4,
    'Producción de lácteos y productos cárnicos. Chochos, salchichas, longanizas y morcillas.',
    TRUE
FROM usuarios u 
WHERE u.username = 'grandes_foods'
ON DUPLICATE KEY UPDATE usuario_id=usuario_id;
