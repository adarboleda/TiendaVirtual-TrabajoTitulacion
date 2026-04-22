-- ============================================
-- SEEDS: inventario
-- ============================================

USE inventario;

-- Inventarios para productos 1-39
INSERT INTO inventarios (producto_id, cantidad, ubicacion, activo) VALUES
-- El Último Inca (productos 1-13)
(1, 500, 'Bodega Principal - Quinticusig', TRUE),
(2, 1000, 'Bodega Principal - Quinticusig', TRUE),
(3, 500, 'Bodega Principal - Quinticusig', TRUE),
(4, 500, 'Bodega Principal - Quinticusig', TRUE),
(5, 1000, 'Bodega Principal - Quinticusig', TRUE),
(6, 500, 'Bodega Principal - Quinticusig', TRUE),
(7, 500, 'Bodega Principal - Quinticusig', TRUE),
(8, 1000, 'Bodega Principal - Quinticusig', TRUE),
(9, 500, 'Bodega Principal - Quinticusig', TRUE),
(10, 500, 'Bodega Principal - Quinticusig', TRUE),
(11, 1000, 'Bodega Principal - Quinticusig', TRUE),
(12, 500, 'Bodega Principal - Quinticusig', TRUE),
(13, 200, 'Bodega Principal - Quinticusig', TRUE),
-- Sigcholac (productos 14-23)
(14, 300, 'Planta de Producción - Sigcholac', TRUE),
(15, 300, 'Planta de Producción - Sigcholac', TRUE),
(16, 200, 'Planta de Producción - Sigcholac', TRUE),
(17, 300, 'Planta de Producción - Sigcholac', TRUE),
(18, 200, 'Planta de Producción - Sigcholac', TRUE),
(19, 500, 'Cámara Fría - Sigcholac', TRUE),
(20, 500, 'Cámara Fría - Sigcholac', TRUE),
(21, 300, 'Cámara Fría - Sigcholac', TRUE),
(22, 200, 'Cámara Fría - Sigcholac', TRUE),
(23, 50, 'Almacén Principal - Sigcholac', TRUE),
-- Perla Andina (productos 24-31)
(24, 500, 'Bodega - Perla Andina', TRUE),
(25, 1000, 'Bodega - Perla Andina', TRUE),
(26, 500, 'Bodega - Perla Andina', TRUE),
(27, 300, 'Bodega - Perla Andina', TRUE),
(28, 500, 'Bodega - Perla Andina', TRUE),
(29, 500, 'Bodega - Perla Andina', TRUE),
(30, 300, 'Bodega - Perla Andina', TRUE),
(31, 200, 'Bodega - Perla Andina', TRUE),
-- Grandes Foods (productos 32-39)
(32, 200, 'Planta - Grandes Foods, Quito', TRUE),
(33, 200, 'Planta - Grandes Foods, Quito', TRUE),
(34, 300, 'Planta - Grandes Foods, Quito', TRUE),
(35, 1000, 'Planta - Grandes Foods, Quito', TRUE),
(36, 500, 'Cámara Fría - Grandes Foods', TRUE),
(37, 500, 'Cámara Fría - Grandes Foods', TRUE),
(38, 300, 'Cámara Fría - Grandes Foods', TRUE),
(39, 300, 'Cámara Fría - Grandes Foods', TRUE);

-- Movimientos de entrada inicial
INSERT INTO movimientos_inventario (inventario_id, tipo_movimiento, cantidad, motivo, usuario_id, fecha_movimiento)
SELECT 
    id,
    'ENTRADA',
    cantidad,
    'Inventario inicial del producto',
    NULL,
    NOW()
FROM inventarios;
