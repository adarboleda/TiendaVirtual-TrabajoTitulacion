-- ============================================
-- SCRIPT: Seeds para VENTAS
-- Descripción: Clientes de prueba (sin ventas iniciales)
-- ============================================

BEGIN;

-- ============================================
-- PASO 1: Insertar Clientes de Prueba
-- ============================================

INSERT INTO public.clientes (nombre, apellido, email, telefono, documento, activo)
VALUES 
('Juan', 'Pérez', 'juan.perez@ejemplo.com', '0993336635', '1105888034', true),
('María', 'González', 'maria.gonzalez@ejemplo.com', '0996365874', '1104556789', true),
('Carlos', 'Ramírez', 'carlos.ramirez@ejemplo.com', '0993369852', '1103445678', true),
('Ana', 'Martínez', 'ana.martinez@ejemplo.com', '0999999999', '1102334567', true),
('Luis', 'Torres', 'luis.torres@ejemplo.com', '0998888888', '1101223456', true)
ON CONFLICT (email) DO NOTHING;

COMMIT;

-- ============================================
-- VERIFICACIÓN
-- ============================================
SELECT 'Clientes creados:' AS info;
SELECT id, nombre, apellido, email, telefono FROM public.clientes;

-- ============================================
-- NOTAS
-- ============================================
-- Las ventas se crearán dinámicamente cuando los clientes realicen compras
-- Cada venta incluirá:
-- - emprendedor_id: del emprendedor principal (o NULL si hay múltiples emprendedores)
-- - detalles_venta con emprendedor_id por cada producto
-- - pagos con información del método de pago
