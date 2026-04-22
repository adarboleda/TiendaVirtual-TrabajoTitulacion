package com.example.msvc_ventas.domain.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Venta {
    private Long id;
    private String numeroFactura;
    private Cliente cliente;
    private Long emprendedorId; // ID del emprendedor que gestiona esta venta
    private BigDecimal subtotal;
    private BigDecimal impuesto;
    private BigDecimal total;
    private EstadoVenta estado;
    private LocalDateTime fechaVenta;
    private LocalDateTime fechaCreacion;
    private LocalDateTime fechaActualizacion;
    private List<DetalleVenta> detalles = new ArrayList<>();
    
    // Información de pago
    private MetodoPago metodoPago;
    private EstadoPago estadoPago;
    private String comprobantePagoUrl;
    private String referenciaTransaccion;
    private LocalDateTime fechaPago;

    public enum EstadoVenta {
        PENDIENTE,
        COMPLETADA,
        CANCELADA
    }
    
    public enum MetodoPago {
        TRANSFERENCIA,
        TARJETA,
        DEUNA
    }
    
    public enum EstadoPago {
        PENDIENTE,
        PROCESANDO,
        APROBADO,
        RECHAZADO
    }
}