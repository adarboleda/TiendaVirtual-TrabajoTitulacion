package com.example.msvc_ventas.application.mapper;

import com.example.msvc_ventas.application.dto.PagoResponseDto;
import com.example.msvc_ventas.infrastructure.persistence.entity.PagoEntity;
import org.springframework.stereotype.Component;

@Component
public class PagoMapper {

    public PagoResponseDto toDto(PagoEntity entity) {
        if (entity == null) {
            return null;
        }

        return PagoResponseDto.builder()
                .id(entity.getId())
                .ventaId(entity.getVenta().getId())
                .numeroFactura(entity.getVenta().getNumeroFactura())
                .monto(entity.getMonto())
                .metodoPago(entity.getMetodoPago() != null ? entity.getMetodoPago().name() : null)
                .estadoPago(entity.getEstadoPago() != null ? entity.getEstadoPago().name() : null)
                .referenciaTransaccion(entity.getReferenciaTransaccion())
                .comprobanteUrl(entity.getComprobanteUrl())
                .fechaPago(entity.getFechaPago())
                .fechaCreacion(entity.getFechaCreacion())
                .fechaActualizacion(entity.getFechaActualizacion())
                .clienteId(entity.getVenta().getCliente().getId())
                .clienteNombre(entity.getVenta().getCliente().getNombre())
                .emprendedorId(entity.getVenta().getEmprendedorId())
                .build();
    }
}
