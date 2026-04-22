package com.example.msvc_ventas.domain.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class SeguimientoLogistica {
    private Long id;
    private Long ventaId;
    private EstadoLogistica estadoLogistica;
    private String descripcion;
    private String ubicacion;
    private String responsable;
    private String observaciones;
    private LocalDateTime fechaActualizacion;
    private LocalDateTime fechaCreacion;

    public enum EstadoLogistica {
        PAGO_APROBADO("Pago aprobado", "El pago ha sido verificado y aprobado por el emprendedor"),
        EN_PREPARACION("En preparación", "El pedido está siendo preparado"),
        LISTO_PARA_ENVIO("Listo para envío", "El pedido está listo para ser enviado"),
        EN_CAMINO("En camino", "El pedido está en tránsito"),
        EN_PUNTO_ENTREGA("En punto de entrega", "El pedido ha llegado al punto de entrega"),
        ENTREGADO("Entregado", "El pedido ha sido entregado al cliente"),
        CANCELADO("Cancelado", "El pedido ha sido cancelado");

        private final String titulo;
        private final String descripcionDefault;

        EstadoLogistica(String titulo, String descripcionDefault) {
            this.titulo = titulo;
            this.descripcionDefault = descripcionDefault;
        }

        public String getTitulo() {
            return titulo;
        }

        public String getDescripcionDefault() {
            return descripcionDefault;
        }
    }
}
