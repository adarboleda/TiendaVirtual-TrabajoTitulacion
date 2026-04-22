-- =====================================================
-- Script: Crear tabla de Seguimiento Logístico
-- Base de datos: ventas
-- Fecha: 2026-01-04
-- =====================================================

USE ventas;

-- Tabla para el historial de seguimiento logístico de pedidos
CREATE TABLE IF NOT EXISTS seguimiento_logistica (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    venta_id BIGINT NOT NULL,
    estado_logistica ENUM(
        'PAGO_APROBADO',
        'EN_PREPARACION',
        'LISTO_PARA_ENVIO',
        'EN_CAMINO',
        'EN_PUNTO_ENTREGA',
        'ENTREGADO',
        'CANCELADO'
    ) NOT NULL,
    descripcion TEXT,
    ubicacion VARCHAR(255),
    responsable VARCHAR(100),
    observaciones TEXT,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Índices para optimizar búsquedas
    INDEX idx_venta_id (venta_id),
    INDEX idx_estado_logistica (estado_logistica),
    INDEX idx_fecha_actualizacion (fecha_actualizacion),
    
    -- Foreign key
    FOREIGN KEY (venta_id) REFERENCES ventas(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Comentarios de tabla
ALTER TABLE seguimiento_logistica 
COMMENT 'Historial completo de seguimiento logístico de pedidos';

-- Insertar datos de ejemplo para las ventas existentes (si hay alguna)
-- Esto es opcional y para demostración

-- Verificar que la tabla se creó correctamente
SELECT 'Tabla seguimiento_logistica creada exitosamente' AS resultado;

-- Mostrar estructura de la tabla
DESCRIBE seguimiento_logistica;
