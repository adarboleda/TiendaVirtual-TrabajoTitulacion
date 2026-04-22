package com.example.msvc_ventas.application.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class StripePaymentIntentResponseDto {
    
    private String clientSecret;
    private String paymentIntentId;
    private String status;
    private String message;
}
