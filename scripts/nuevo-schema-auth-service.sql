-- ============================================
-- SCRIPT: Nuevo Schema para AUTH-SERVICE
-- Descripción: Incluye tabla emprendedores vinculada a usuarios y empresas
-- ============================================

-- Eliminar tablas existentes si existen (CUIDADO: Esto borra todos los datos)
DROP TABLE IF EXISTS public.emprendedores CASCADE;
DROP TABLE IF EXISTS public.usuario_roles CASCADE;
DROP TABLE IF EXISTS public.usuarios CASCADE;

-- ============================================
-- TABLA: usuarios
-- Descripción: Usuarios del sistema (admin, emprendedor, cliente)
-- ============================================
CREATE TABLE public.usuarios (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100),
    telefono VARCHAR(15),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Índices para búsquedas rápidas
CREATE INDEX idx_usuarios_username ON public.usuarios(username);
CREATE INDEX idx_usuarios_email ON public.usuarios(email);

-- ============================================
-- TABLA: usuario_roles
-- Descripción: Roles de usuarios (ROLE_ADMIN, ROLE_EMP, ROLE_USER)
-- ============================================
CREATE TABLE public.usuario_roles (
    usuario_id BIGINT NOT NULL REFERENCES public.usuarios(id) ON DELETE CASCADE,
    rol VARCHAR(50) NOT NULL,
    PRIMARY KEY (usuario_id, rol)
);

-- ============================================
-- TABLA: emprendedores
-- Descripción: Información adicional de emprendedores vinculada a usuarios
-- Un emprendedor tiene un usuario y puede gestionar una empresa
-- ============================================
CREATE TABLE public.emprendedores (
    id BIGSERIAL PRIMARY KEY,
    usuario_id BIGINT NOT NULL UNIQUE REFERENCES public.usuarios(id) ON DELETE CASCADE,
    empresa_id BIGINT,  -- Se vinculará con la tabla empresas del microservicio de productos
    descripcion TEXT,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Índices para búsquedas rápidas
CREATE INDEX idx_emprendedores_usuario_id ON public.emprendedores(usuario_id);
CREATE INDEX idx_emprendedores_empresa_id ON public.emprendedores(empresa_id);

-- ============================================
-- COMENTARIOS EN TABLAS
-- ============================================
COMMENT ON TABLE public.usuarios IS 'Usuarios del sistema con autenticación';
COMMENT ON TABLE public.usuario_roles IS 'Roles asignados a usuarios';
COMMENT ON TABLE public.emprendedores IS 'Información extendida de usuarios emprendedores';

COMMENT ON COLUMN public.emprendedores.empresa_id IS 'ID de empresa en microservicio de productos (sin FK física por ser microservicio diferente)';
