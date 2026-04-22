package com.example.msvc_ventas.infrastructure.persistence.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "ventas")
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class VentaEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "numero_factura", nullable = false, unique = true, length = 20)
    private String numeroFactura;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cliente_id", nullable = false)
    private ClienteEntity cliente;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal subtotal;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal impuesto;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal total;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private EstadoVenta estado;

    @Column(name = "fecha_venta", nullable = false)
    private LocalDateTime fechaVenta;

    @Column(name = "fecha_creacion", nullable = false)
    private LocalDateTime fechaCreacion;

    @Column(name = "fecha_actualizacion", nullable = false)
    private LocalDateTime fechaActualizacion;

    @Column(name = "emprendedor_id", nullable = false)
    private Long emprendedorId;
    
    // Información de pago
    @Enumerated(EnumType.STRING)
    @Column(name = "metodo_pago", length = 50)
    private MetodoPago metodoPago;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "estado_pago", length = 50)
    private EstadoPago estadoPago;
    
    @Column(name = "comprobante_pago_url", columnDefinition = "TEXT")
    private String comprobantePagoUrl;
    
    @Column(name = "referencia_transaccion", length = 255)
    private String referenciaTransaccion;
    
    @Column(name = "fecha_pago")
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