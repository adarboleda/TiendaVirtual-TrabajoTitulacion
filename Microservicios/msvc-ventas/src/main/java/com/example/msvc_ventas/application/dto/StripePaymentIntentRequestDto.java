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
public class StripePaymentIntentRequestDto {
    
    private Long ventaId;
    private Long clienteId;
    private BigDecimal monto;
}
