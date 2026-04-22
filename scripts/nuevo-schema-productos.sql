-- ============================================
-- SCRIPT: Nuevo Schema para PRODUCTOS
-- Descripción: Incluye emprendedor_id en productos para vinculación
-- ============================================

-- Eliminar tablas existentes si existen (CUIDADO: Esto borra todos los datos)
DROP TABLE IF EXISTS public.productos CASCADE;
DROP TABLE IF EXISTS public.empresas CASCADE;
DROP TABLE IF EXISTS public.categorias CASCADE;

-- ============================================
-- TABLA: categorias
-- Descripción: Categorías de productos
-- ============================================
CREATE TABLE public.categorias (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(250),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABLA: empresas
-- Descripción: Empresas/tiendas de emprendedores
-- ============================================
CREATE TABLE public.empresas (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ruc VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100),
    telefono VARCHAR(15),
    direccion VARCHAR(200),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Índices
CREATE INDEX idx_empresas_ruc ON public.empresas(ruc);
CREATE INDEX idx_empresas_activo ON public.empresas(activo);

-- ============================================
-- TABLA: productos
-- Descripción: Productos vinculados a emprendedor, empresa y categoría
-- ============================================
CREATE TABLE public.productos (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(500),
    precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0),
    imagen VARCHAR(255),
    
    -- Relaciones
    categoria_id BIGINT NOT NULL REFERENCES public.categorias(id),
    empresa_id BIGINT NOT NULL REFERENCES public.empresas(id),
    emprendedor_id BIGINT NOT NULL,  -- ID del emprendedor en microservicio auth-service
    
    -- Campos de auditoría
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Índices para búsquedas eficientes
CREATE INDEX idx_productos_categoria_id ON public.productos(categoria_id);
CREATE INDEX idx_productos_empresa_id ON public.productos(empresa_id);
CREATE INDEX idx_productos_emprendedor_id ON public.productos(emprendedor_id);
CREATE INDEX idx_productos_activo ON public.productos(activo);
CREATE INDEX idx_productos_nombre ON public.productos(nombre);

-- ============================================
-- COMENTARIOS EN TABLAS
-- ============================================
COMMENT ON TABLE public.categorias IS 'Categorías de productos (Vinos, Lácteos, etc.)';
COMMENT ON TABLE public.empresas IS 'Empresas/tiendas de emprendedores';
COMMENT ON TABLE public.productos IS 'Productos ofrecidos por emprendedores';

COMMENT ON COLUMN public.productos.emprendedor_id IS 'ID del emprendedor propietario del producto (ref a auth-service, sin FK física)';
