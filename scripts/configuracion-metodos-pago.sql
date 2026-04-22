-- Script para agregar tabla de configuración de métodos de pago del emprendedor
-- Base de datos: auth-service (donde están los usuarios)

-- Crear tabla para configuración de pagos del emprendedor
CREATE TABLE IF NOT EXISTS configuracion_metodos_pago (
    id SERIAL PRIMARY KEY,
    emprendedor_id INTEGER NOT NULL,
    
    -- Datos bancarios para transferencias
    banco VARCHAR(100),
    tipo_cuenta VARCHAR(50),
    numero_cuenta VARCHAR(50),
    titular VARCHAR(255),
    cedula_ruc VARCHAR(20),
    email VARCHAR(255),
    
    -- URL del QR de Deuna almacenado
    qr_deuna_url TEXT,
    
    -- Metadatos
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraint para que cada emprendedor tenga solo una configuración
    CONSTRAINT uk_emprendedor_config UNIQUE (emprendedor_id),
    
    -- Foreign key a la tabla de usuarios
    CONSTRAINT fk_emprendedor FOREIGN KEY (emprendedor_id) 
        REFERENCES usuarios(id) ON DELETE CASCADE
);

-- Crear índice para búsquedas rápidas por emprendedor
CREATE INDEX IF NOT EXISTS idx_config_pagos_emprendedor 
    ON configuracion_metodos_pago(emprendedor_id);

-- Función para actualizar el timestamp de updated_at automáticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para actualizar updated_at
DROP TRIGGER IF EXISTS update_config_pagos_updated_at ON configuracion_metodos_pago;
CREATE TRIGGER update_config_pagos_updated_at
    BEFORE UPDATE ON configuracion_metodos_pago
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Comentarios para documentación
COMMENT ON TABLE configuracion_metodos_pago IS 'Configuración de métodos de pago para emprendedores';
COMMENT ON COLUMN configuracion_metodos_pago.emprendedor_id IS 'ID del usuario emprendedor (ROLE_EMP)';
COMMENT ON COLUMN configuracion_metodos_pago.banco IS 'Nombre del banco para transferencias';
COMMENT ON COLUMN configuracion_metodos_pago.tipo_cuenta IS 'Tipo de cuenta: ahorros o corriente';
COMMENT ON COLUMN configuracion_metodos_pago.numero_cuenta IS 'Número de cuenta bancaria';
COMMENT ON COLUMN configuracion_metodos_pago.titular IS 'Nombre del titular de la cuenta';
COMMENT ON COLUMN configuracion_metodos_pago.cedula_ruc IS 'Cédula o RUC del titular';
COMMENT ON COLUMN configuracion_metodos_pago.qr_deuna_url IS 'URL pública del código QR de Deuna almacenado';

-- Insertar configuración de ejemplo para el emprendedor existente (si existe)
INSERT INTO configuracion_metodos_pago (
    emprendedor_id,
    banco,
    tipo_cuenta,
    numero_cuenta,
    titular,
    cedula_ruc,
    email
)
SELECT 
    u.id,
    'pichincha',
    'ahorros',
    '2100123456',
    'Maria Emprendedora',
    '1234567890',
    'emprendedor@test.com'
FROM usuarios u
WHERE u.username = 'emprendedor'
ON CONFLICT (emprendedor_id) DO NOTHING;

-- Verificar la creación
SELECT 
    cmp.*,
    u.username,
    u.email as usuario_email
FROM configuracion_metodos_pago cmp
INNER JOIN usuarios u ON u.id = cmp.emprendedor_id;
