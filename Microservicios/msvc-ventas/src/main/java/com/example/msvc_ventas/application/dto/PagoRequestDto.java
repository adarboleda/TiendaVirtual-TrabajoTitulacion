package com.example.msvc_ventas.application.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class PagoRequestDto {
    private Long ventaId;
    private String metodoPago; // TRANSFERENCIA, TARJETA, DEUNA
    private String comprobanteUrl; // Opcional, solo para transferencias
}
