package com.example.demo.application.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class SolicitarCodigoDto {

    @NotBlank(message = "El nombre de usuario es requerido")
    private String username;
}
