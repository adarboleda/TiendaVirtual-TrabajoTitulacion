-- ============================================
-- SCRIPT: Nuevo Schema para INVENTARIO
-- Descripción: Mejorado con índices y constraints para mejor rendimiento
-- ============================================

-- Eliminar tablas existentes si existen (CUIDADO: Esto borra todos los datos)
DROP TABLE IF EXISTS public.movimientos_inventario CASCADE;
DROP TABLE IF EXISTS public.inventarios CASCADE;

-- ============================================
-- TABLA: inventarios
-- Descripción: Control de inventario por producto
-- ============================================
CREATE TABLE public.inventarios (
    id BIGSERIAL PRIMARY KEY,
    producto_id BIGINT NOT NULL UNIQUE,  -- ID del producto en microservicio productos
    cantidad INTEGER NOT NULL DEFAULT 0 CHECK (cantidad >= 0),
    ubicacion VARCHAR(100),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Índices para búsquedas rápidas
CREATE INDEX idx_inventarios_producto_id ON public.inventarios(producto_id);
CREATE INDEX idx_inventarios_activo ON public.inventarios(activo);

-- ============================================
-- TABLA: movimientos_inventario
-- Descripción: Historial de movimientos de inventario
-- ============================================
CREATE TABLE public.movimientos_inventario (
    id BIGSERIAL PRIMARY KEY,
    inventario_id BIGINT NOT NULL REFERENCES public.inventarios(id) ON DELETE CASCADE,
    tipo_movimiento VARCHAR(20) NOT NULL CHECK (tipo_movimiento IN ('ENTRADA', 'SALIDA', 'AJUSTE')),
    cantidad INTEGER NOT NULL,
    motivo VARCHAR(200),
    usuario_id BIGINT,  -- ID del usuario que realizó el movimiento (ref a auth-service)
    fecha_movimiento TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Índices para consultas de historial
CREATE INDEX idx_movimientos_inventario_id ON public.movimientos_inventario(inventario_id);
CREATE INDEX idx_movimientos_fecha ON public.movimientos_inventario(fecha_movimiento DESC);
CREATE INDEX idx_movimientos_tipo ON public.movimientos_inventario(tipo_movimiento);

-- ============================================
-- COMENTARIOS EN TABLAS
-- ============================================
COMMENT ON TABLE public.inventarios IS 'Control de stock de productos';
COMMENT ON TABLE public.movimientos_inventario IS 'Historial de movimientos de inventario';

COMMENT ON COLUMN public.inventarios.producto_id IS 'ID del producto en microservicio productos (sin FK física)';
COMMENT ON COLUMN public.movimientos_inventario.usuario_id IS 'ID del usuario que realizó el movimiento (ref a auth-service, sin FK física)';
