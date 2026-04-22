package com.example.msvc_ventas.application.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class InventarioInfoDto {
    private Long id;
    private Integer cantidad;
    private String ubicacion;
    
    // Alias para compatibilidad con diferentes versiones
    public Integer getCantidadDisponible() {
        return cantidad;
    }
    
    public void setCantidadDisponible(Integer cantidadDisponible) {
        this.cantidad = cantidadDisponible;
    }
}