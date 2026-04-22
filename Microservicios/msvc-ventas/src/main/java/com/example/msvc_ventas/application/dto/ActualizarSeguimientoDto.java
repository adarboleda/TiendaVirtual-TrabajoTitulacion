package com.example.msvc_ventas.application.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ActualizarSeguimientoDto {
    
    @NotNull(message = "El ID de la venta es obligatorio")
    private Long ventaId;
    
    @NotBlank(message = "El estado logístico es obligatorio")
    private String estadoLogistica; // PAGO_APROBADO, EN_PREPARACION, etc.
    
    private String descripcion;
    
    private String ubicacion;
    
    private String responsable;
    
    private String observaciones;
}
