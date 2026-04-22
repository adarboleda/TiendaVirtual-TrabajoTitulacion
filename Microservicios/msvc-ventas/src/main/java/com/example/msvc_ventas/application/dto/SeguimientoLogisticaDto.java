package com.example.msvc_ventas.application.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class SeguimientoLogisticaDto {
    private Long id;
    private Long ventaId;
    private String numeroFactura;
    private String estadoLogistica;
    private String estadoTitulo;
    private String descripcion;
    private String ubicacion;
    private String responsable;
    private String observaciones;
    private LocalDateTime fechaActualizacion;
    private LocalDateTime fechaCreacion;
}
