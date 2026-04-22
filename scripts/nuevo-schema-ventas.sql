-- ============================================
-- SCRIPT: Nuevo Schema para VENTAS
-- Descripción: Incluye emprendedor_id para tracking de ventas por emprendedor
-- ============================================

-- Eliminar tablas existentes si existen (CUIDADO: Esto borra todos los datos)
DROP TABLE IF EXISTS public.pagos CASCADE;
DROP TABLE IF EXISTS public.detalles_venta CASCADE;
DROP TABLE IF EXISTS public.ventas CASCADE;
DROP TABLE IF EXISTS public.clientes CASCADE;

-- ============================================
-- TABLA: clientes
-- Descripción: Clientes que realizan compras
-- ============================================
CREATE TABLE public.clientes (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(15),
    documento VARCHAR(20),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Índices
CREATE INDEX idx_clientes_email ON public.clientes(email);
CREATE INDEX idx_clientes_documento ON public.clientes(documento);

-- ============================================
-- TABLA: ventas
-- Descripción: Ventas realizadas, ahora con emprendedor_id
-- ============================================
CREATE TABLE public.ventas (
    id BIGSERIAL PRIMARY KEY,
    numero_factura VARCHAR(20) NOT NULL UNIQUE,
    cliente_id BIGINT NOT NULL REFERENCES public.clientes(id),
    emprendedor_id BIGINT NOT NULL,  -- ID del emprendedor (de auth-service)
    
    -- Montos
    subtotal DECIMAL(10,2) NOT NULL CHECK (subtotal >= 0),
    impuesto DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (impuesto >= 0),
    total DECIMAL(10,2) NOT NULL CHECK (total >= 0),
    
    -- Estado
    estado VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE' CHECK (estado IN ('PENDIENTE', 'COMPLETADA', 'CANCELADA')),
    
    -- Fechas
    fecha_venta TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Índices para búsquedas eficientes
CREATE INDEX idx_ventas_cliente_id ON public.ventas(cliente_id);
CREATE INDEX idx_ventas_emprendedor_id ON public.ventas(emprendedor_id);
CREATE INDEX idx_ventas_numero_factura ON public.ventas(numero_factura);
CREATE INDEX idx_ventas_estado ON public.ventas(estado);
CREATE INDEX idx_ventas_fecha ON public.ventas(fecha_venta DESC);

-- ============================================
-- TABLA: detalles_venta
-- Descripción: Ítems de cada venta con info del emprendedor
-- ============================================
CREATE TABLE public.detalles_venta (
    id BIGSERIAL PRIMARY KEY,
    venta_id BIGINT NOT NULL REFERENCES public.ventas(id) ON DELETE CASCADE,
    producto_id BIGINT NOT NULL,  -- ID del producto (de microservicio productos)
    emprendedor_id BIGINT NOT NULL,  -- ID del emprendedor dueño del producto
    
    -- Información del producto (snapshot al momento de la venta)
    nombre_producto VARCHAR(100) NOT NULL,
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10,2) NOT NULL CHECK (precio_unitario >= 0),
    subtotal DECIMAL(10,2) NOT NULL CHECK (subtotal >= 0)
);

-- Índices
CREATE INDEX idx_detalles_venta_id ON public.detalles_venta(venta_id);
CREATE INDEX idx_detalles_producto_id ON public.detalles_venta(producto_id);
CREATE INDEX idx_detalles_emprendedor_id ON public.detalles_venta(emprendedor_id);

-- ============================================
-- TABLA: pagos
-- Descripción: Información de pagos de ventas
-- ============================================
CREATE TABLE public.pagos (
    id BIGSERIAL PRIMARY KEY,
    venta_id BIGINT NOT NULL REFERENCES public.ventas(id) ON DELETE CASCADE,
    
    -- Información de pago
    metodo_pago VARCHAR(50) NOT NULL CHECK (metodo_pago IN ('TRANSFERENCIA', 'TARJETA', 'DEUNA')),
    estado_pago VARCHAR(50) NOT NULL DEFAULT 'PENDIENTE' CHECK (estado_pago IN ('PENDIENTE', 'PROCESANDO', 'APROBADO', 'RECHAZADO')),
    
    -- Detalles del método de pago
    banco VARCHAR(100),
    numero_cuenta VARCHAR(50),
    titular_cuenta VARCHAR(100),
    numero_transaccion VARCHAR(100),
    
    -- Información de tarjeta (encriptada)
    numero_tarjeta_parcial VARCHAR(20),  -- Solo últimos 4 dígitos
    
    -- Información Deuna
    qr_code TEXT,
    
    -- Montos
    monto DECIMAL(10,2) NOT NULL CHECK (monto >= 0),
    
    -- Fechas
    fecha_pago TIMESTAMP,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Índices
CREATE INDEX idx_pagos_venta_id ON public.pagos(venta_id);
CREATE INDEX idx_pagos_estado ON public.pagos(estado_pago);
CREATE INDEX idx_pagos_metodo ON public.pagos(metodo_pago);

-- ============================================
-- COMENTARIOS EN TABLAS
-- ============================================
COMMENT ON TABLE public.clientes IS 'Clientes que realizan compras';
COMMENT ON TABLE public.ventas IS 'Ventas realizadas por clientes';
COMMENT ON TABLE public.detalles_venta IS 'Detalles de productos en cada venta';
COMMENT ON TABLE public.pagos IS 'Información de pagos de ventas';

COMMENT ON COLUMN public.ventas.emprendedor_id IS 'ID del emprendedor principal de la venta (puede ser múltiple si hay productos de varios emprendedores)';
COMMENT ON COLUMN public.detalles_venta.emprendedor_id IS 'ID del emprendedor dueño del producto (ref a auth-service, sin FK física)';
