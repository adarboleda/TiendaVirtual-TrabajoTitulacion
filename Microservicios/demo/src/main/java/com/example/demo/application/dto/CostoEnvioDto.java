package com.example.demo.application.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CostoEnvioDto {

    @NotNull(message = "El costo de envío es requerido")
    @DecimalMin(value = "0.0", message = "El costo de envío no puede ser negativo")
    private BigDecimal costoEnvio;
}
