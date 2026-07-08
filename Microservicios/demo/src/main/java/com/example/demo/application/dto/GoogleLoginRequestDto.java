package com.example.demo.application.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class GoogleLoginRequestDto {

    @NotBlank(message = "El idToken de Google es requerido")
    private String idToken;
}
