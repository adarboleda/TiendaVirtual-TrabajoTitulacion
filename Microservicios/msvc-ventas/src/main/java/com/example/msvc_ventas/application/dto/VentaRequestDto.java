package com.example.msvc_ventas.application.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class VentaRequestDto {

    @NotNull(message = "El ID del cliente es obligatorio")
    private Long clienteId;

    @NotEmpty(message = "Los items de la venta no pueden estar vacíos")
    @Size(min = 1, message = "Debe haber al menos un item en la venta")
    @Valid
    private List<VentaItemRequestDto> items;

    @NotNull(message = "El método de pago es obligatorio")
    private String metodoPago; // TRANSFERENCIA, TARJETA, DEUNA

    private String comprobanteUrl; // Opcional, requerido solo para TRANSFERENCIA

    private Long emprendedorId; // ID del emprendedor/empresa que realiza la venta
}