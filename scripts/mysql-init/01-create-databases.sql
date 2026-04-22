-- ============================================
-- SCRIPT: Inicialización MySQL - Crear Bases de Datos
-- ============================================

CREATE DATABASE IF NOT EXISTS `auth_service` 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

CREATE DATABASE IF NOT EXISTS `productos` 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

CREATE DATABASE IF NOT EXISTS `inventario` 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

CREATE DATABASE IF NOT EXISTS `ventas` 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- Otorgar todos los privilegios al usuario admin
GRANT ALL PRIVILEGES ON auth_service.* TO 'admin'@'%';
GRANT ALL PRIVILEGES ON productos.* TO 'admin'@'%';
GRANT ALL PRIVILEGES ON inventario.* TO 'admin'@'%';
GRANT ALL PRIVILEGES ON ventas.* TO 'admin'@'%';

FLUSH PRIVILEGES;
