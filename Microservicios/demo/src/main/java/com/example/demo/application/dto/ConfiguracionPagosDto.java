package com.example.demo.application.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ConfiguracionPagosDto {
    private Long id;
    private Long emprendedorId;
    private DatosBancariosDto datosBancarios;
    private String qrDeunaUrl;
    private PayphoneDto payphone;
    private BigDecimal costoEnvio;
}
