-- ============================================
-- BASE DE DATOS: ventas
-- Schema para MySQL
-- ============================================

USE ventas;

-- ============================================
-- TABLA: clientes
-- ============================================
CREATE TABLE IF NOT EXISTS clientes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(15),
    documento VARCHAR(20),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_clientes_email (email),
    INDEX idx_clientes_documento (documento)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: ventas
-- ============================================
CREATE TABLE IF NOT EXISTS ventas (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    numero_factura VARCHAR(20) NOT NULL UNIQUE,
    cliente_id BIGINT NOT NULL,
    emprendedor_id BIGINT NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL CHECK (subtotal >= 0),
    impuesto DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (impuesto >= 0),
    total DECIMAL(10,2) NOT NULL CHECK (total >= 0),
    estado ENUM('PENDIENTE', 'COMPLETADA', 'CANCELADA') NOT NULL DEFAULT 'PENDIENTE',
    metodo_pago ENUM('TRANSFERENCIA', 'TARJETA', 'DEUNA'),
    estado_pago ENUM('PENDIENTE', 'PROCESANDO', 'APROBADO', 'RECHAZADO') NOT NULL DEFAULT 'PENDIENTE',
    comprobante_pago_url TEXT,
    referencia_transaccion VARCHAR(255),
    fecha_pago TIMESTAMP NULL,
    fecha_venta TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    INDEX idx_ventas_cliente_id (cliente_id),
    INDEX idx_ventas_emprendedor_id (emprendedor_id),
    INDEX idx_ventas_numero_factura (numero_factura),
    INDEX idx_ventas_estado (estado),
    INDEX idx_ventas_fecha (fecha_venta DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: detalles_venta
-- ============================================
CREATE TABLE IF NOT EXISTS detalles_venta (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    venta_id BIGINT NOT NULL,
    producto_id BIGINT NOT NULL,
    emprendedor_id BIGINT NOT NULL,
    nombre_producto VARCHAR(100) NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10,2) NOT NULL CHECK (precio_unitario >= 0),
    subtotal DECIMAL(10,2) NOT NULL CHECK (subtotal >= 0),
    
    FOREIGN KEY (venta_id) REFERENCES ventas(id) ON DELETE CASCADE,
    INDEX idx_detalles_venta_id (venta_id),
    INDEX idx_detalles_producto_id (producto_id),
    INDEX idx_detalles_emprendedor_id (emprendedor_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: pagos
-- ============================================
CREATE TABLE IF NOT EXISTS pagos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    venta_id BIGINT NOT NULL,
    metodo_pago ENUM('TRANSFERENCIA', 'TARJETA', 'DEUNA') NOT NULL,
    estado_pago ENUM('PENDIENTE', 'PROCESANDO', 'APROBADO', 'RECHAZADO') NOT NULL DEFAULT 'PENDIENTE',
    banco VARCHAR(100),
    numero_cuenta VARCHAR(50),
    titular_cuenta VARCHAR(100),
    numero_transaccion VARCHAR(100),
    referencia_transaccion VARCHAR(255),
    numero_tarjeta_parcial VARCHAR(20),
    qr_code TEXT,
    comprobante_url TEXT,
    monto DECIMAL(10,2) NOT NULL CHECK (monto >= 0),
    fecha_pago TIMESTAMP NULL,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (venta_id) REFERENCES ventas(id) ON DELETE CASCADE,
    INDEX idx_pagos_venta_id (venta_id),
    INDEX idx_pagos_estado (estado_pago),
    INDEX idx_pagos_metodo (metodo_pago)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: seguimiento_logistica
-- ============================================
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
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_seguimiento_logistica_venta
        FOREIGN KEY (venta_id) REFERENCES ventas(id) ON DELETE CASCADE,
    INDEX idx_venta_id (venta_id),
    INDEX idx_estado_logistica (estado_logistica),
    INDEX idx_fecha_actualizacion (fecha_actualizacion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
