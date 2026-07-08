package com.example.demo.application.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class RestablecerConTokenDto {

    @NotBlank(message = "El nombre de usuario es requerido")
    private String username;

    @NotBlank(message = "El token de restablecimiento es requerido")
    private String resetToken;

    @NotBlank(message = "La nueva contraseña es requerida")
    @Size(min = 6, message = "La contraseña debe tener al menos 6 caracteres")
    private String nuevaPassword;
}
