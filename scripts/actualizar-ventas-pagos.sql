-- Script para agregar campos de método de pago y estado de pago a la tabla ventas
-- Base de datos: ventas

-- Agregar columnas de método de pago
ALTER TABLE ventas 
ADD COLUMN IF NOT EXISTS metodo_pago VARCHAR(50),
ADD COLUMN IF NOT EXISTS estado_pago VARCHAR(50) DEFAULT 'PENDIENTE',
ADD COLUMN IF NOT EXISTS comprobante_pago_url TEXT,
ADD COLUMN IF NOT EXISTS referencia_transaccion VARCHAR(255),
ADD COLUMN IF NOT EXISTS fecha_pago TIMESTAMP;

-- Crear índice para búsquedas por cliente
CREATE INDEX IF NOT EXISTS idx_ventas_cliente 
    ON ventas(cliente_id);

-- Crear índice para búsquedas por estado de pago
CREATE INDEX IF NOT EXISTS idx_ventas_estado_pago 
    ON ventas(estado_pago);

-- Comentarios para documentación
COMMENT ON COLUMN ventas.metodo_pago IS 'Método de pago utilizado: transferencia, tarjeta, deuna';
COMMENT ON COLUMN ventas.estado_pago IS 'Estado del pago: PENDIENTE, PROCESANDO, APROBADO, RECHAZADO';
COMMENT ON COLUMN ventas.comprobante_pago_url IS 'URL del comprobante de pago (para transferencias)';
COMMENT ON COLUMN ventas.referencia_transaccion IS 'ID de transacción o referencia del pago';
COMMENT ON COLUMN ventas.fecha_pago IS 'Fecha y hora en que se completó el pago';

-- Actualizar ventas existentes con valores por defecto
UPDATE ventas 
SET metodo_pago = 'tarjeta',
    estado_pago = 'APROBADO'
WHERE metodo_pago IS NULL;

-- Verificar los cambios
SELECT 
    id,
    numero_factura,
    cliente_id,
    total,
    estado,
    metodo_pago,
    estado_pago,
    fecha_venta,
    fecha_pago
FROM ventas
ORDER BY fecha_venta DESC
LIMIT 10;
