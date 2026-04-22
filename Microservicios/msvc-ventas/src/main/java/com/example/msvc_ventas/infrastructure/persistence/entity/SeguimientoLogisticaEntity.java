package com.example.msvc_ventas.infrastructure.persistence.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "seguimiento_logistica")
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class SeguimientoLogisticaEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "venta_id", nullable = false)
    private Long ventaId;

    @Enumerated(EnumType.STRING)
    @Column(name = "estado_logistica", nullable = false, length = 50)
    private EstadoLogistica estadoLogistica;

    @Column(columnDefinition = "TEXT")
    private String descripcion;

    @Column(length = 255)
    private String ubicacion;

    @Column(length = 100)
    private String responsable;

    @Column(columnDefinition = "TEXT")
    private String observaciones;

    @Column(name = "fecha_actualizacion", nullable = false)
    private LocalDateTime fechaActualizacion;

    @Column(name = "fecha_creacion", nullable = false)
    private LocalDateTime fechaCreacion;

    @PrePersist
    protected void onCreate() {
        fechaCreacion = LocalDateTime.now();
        fechaActualizacion = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        fechaActualizacion = LocalDateTime.now();
    }

    public enum EstadoLogistica {
        PAGO_APROBADO,
        EN_PREPARACION,
        LISTO_PARA_ENVIO,
        EN_CAMINO,
        EN_PUNTO_ENTREGA,
        ENTREGADO,
        CANCELADO
    }
}
