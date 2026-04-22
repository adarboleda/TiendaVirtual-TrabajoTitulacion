package com.example.msvc_ventas.domain.service;

import java.io.File;

public interface FacturaService {
    /**
     * Genera una factura en PDF para una venta específica
     * @param ventaId ID de la venta
     * @return Ruta del archivo PDF generado
     */
    String generarFacturaPDF(Long ventaId);

    /**
     * Obtiene el archivo PDF de una factura
     * @param ventaId ID de la venta
     * @return Archivo PDF de la factura
     */
    File obtenerFacturaPDF(Long ventaId);

    /**
     * Verifica si existe una factura para una venta
     * @param ventaId ID de la venta
     * @return true si existe la factura, false en caso contrario
     */
    boolean existeFactura(Long ventaId);
}
