package com.example.msvc_ventas.application.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class PagoResponseDto {
    private Long id;
    private Long ventaId;
    private String numeroFactura;
    private BigDecimal monto;
    private String metodoPago;
    private String estadoPago;
    private String referenciaTransaccion;
    private String comprobanteUrl;
    private LocalDateTime fechaPago;
    private LocalDateTime fechaCreacion;
    private LocalDateTime fechaActualizacion;
    
    // Datos de la venta asociada
    private Long clienteId;
    private String clienteNombre;
    private Long emprendedorId;
}
