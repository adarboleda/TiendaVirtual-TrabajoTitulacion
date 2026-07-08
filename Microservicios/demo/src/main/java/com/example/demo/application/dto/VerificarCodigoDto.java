package com.example.demo.application.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class VerificarCodigoDto {

    @NotBlank(message = "El nombre de usuario es requerido")
    private String username;

    @NotBlank(message = "El código es requerido")
    private String codigo;
}
