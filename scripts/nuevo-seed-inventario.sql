-- ============================================
-- SCRIPT: Seeds para INVENTARIO
-- Descripción: Inventarios iniciales para productos
-- ============================================

BEGIN;

-- ============================================
-- PASO 1: Crear inventarios para productos
-- Nota: producto_id corresponde a los IDs de productos creados
-- ============================================

-- Inventarios para productos de El Último Inca (IDs 1-13)
INSERT INTO public.inventarios (producto_id, cantidad, ubicacion, activo)
VALUES
(1, 500, 'Bodega Principal - Quinticusig', true),
(2, 1000, 'Bodega Principal - Quinticusig', true),
(3, 500, 'Bodega Principal - Quinticusig', true),
(4, 500, 'Bodega Principal - Quinticusig', true),
(5, 1000, 'Bodega Principal - Quinticusig', true),
(6, 500, 'Bodega Principal - Quinticusig', true),
(7, 500, 'Bodega Principal - Quinticusig', true),
(8, 1000, 'Bodega Principal - Quinticusig', true),
(9, 500, 'Bodega Principal - Quinticusig', true),
(10, 500, 'Bodega Principal - Quinticusig', true),
(11, 1000, 'Bodega Principal - Quinticusig', true),
(12, 500, 'Bodega Principal - Quinticusig', true),
(13, 200, 'Bodega Principal - Quinticusig', true);

-- Inventarios para productos de Sigcholac (IDs 14-23)
INSERT INTO public.inventarios (producto_id, cantidad, ubicacion, activo)
VALUES
(14, 300, 'Planta de Producción - Sigcholac', true),
(15, 300, 'Planta de Producción - Sigcholac', true),
(16, 200, 'Planta de Producción - Sigcholac', true),
(17, 300, 'Planta de Producción - Sigcholac', true),
(18, 200, 'Planta de Producción - Sigcholac', true),
(19, 500, 'Cámara Fría - Sigcholac', true),
(20, 500, 'Cámara Fría - Sigcholac', true),
(21, 300, 'Cámara Fría - Sigcholac', true),
(22, 200, 'Cámara Fría - Sigcholac', true),
(23, 50, 'Almacén Principal', true);

-- Inventarios para productos de Perla Andina (IDs 24-31)
INSERT INTO public.inventarios (producto_id, cantidad, ubicacion, activo)
VALUES
(24, 500, 'Bodega - Perla Andina', true),
(25, 1000, 'Bodega - Perla Andina', true),
(26, 500, 'Bodega - Perla Andina', true),
(27, 300, 'Bodega - Perla Andina', true),
(28, 500, 'Bodega - Perla Andina', true),
(29, 500, 'Bodega - Perla Andina', true),
(30, 300, 'Bodega - Perla Andina', true),
(31, 200, 'Bodega - Perla Andina', true);

-- Inventarios para productos de Grandes Foods (IDs 32-39)
INSERT INTO public.inventarios (producto_id, cantidad, ubicacion, activo)
VALUES
(32, 200, 'Planta - Grandes Foods, Quito', true),
(33, 200, 'Planta - Grandes Foods, Quito', true),
(34, 300, 'Planta - Grandes Foods, Quito', true),
(35, 1000, 'Planta - Grandes Foods, Quito', true),
(36, 500, 'Cámara Fría - Grandes Foods', true),
(37, 500, 'Cámara Fría - Grandes Foods', true),
(38, 300, 'Cámara Fría - Grandes Foods', true),
(39, 300, 'Cámara Fría - Grandes Foods', true);

-- ============================================
-- PASO 2: Registrar movimientos iniciales de inventario
-- ============================================

-- Movimientos de entrada inicial (inventario inicial)
INSERT INTO public.movimientos_inventario (inventario_id, tipo_movimiento, cantidad, motivo, usuario_id, fecha_movimiento)
SELECT 
    id,
    'ENTRADA',
    cantidad,
    'Inventario inicial del producto',
    NULL,  -- Sistema
    CURRENT_TIMESTAMP
FROM public.inventarios;

COMMIT;

-- ============================================
-- VERIFICACIÓN
-- ============================================
SELECT 'Inventarios creados:' AS info;
SELECT 
    i.id,
    i.producto_id,
    i.cantidad,
    i.ubicacion
FROM public.inventarios i
ORDER BY i.producto_id;

SELECT 'Total de inventarios por ubicación:' AS info;
SELECT 
    ubicacion,
    COUNT(*) AS total_productos,
    SUM(cantidad) AS total_unidades
FROM public.inventarios
GROUP BY ubicacion
ORDER BY ubicacion;

SELECT 'Movimientos registrados:' AS info;
SELECT COUNT(*) AS total_movimientos FROM public.movimientos_inventario;
