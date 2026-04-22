package com.example.msvc_ventas.infrastructure.persistence.mapper;

import com.example.msvc_ventas.domain.model.Venta;
import com.example.msvc_ventas.infrastructure.persistence.entity.VentaEntity;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class VentaEntityMapper {

    private final ClienteEntityMapper clienteEntityMapper;

    public VentaEntity toEntity(Venta domain) {
        return VentaEntity.builder()
                .id(domain.getId())
                .numeroFactura(domain.getNumeroFactura())
                .cliente(clienteEntityMapper.toEntity(domain.getCliente()))
                .emprendedorId(domain.getEmprendedorId())
                .subtotal(domain.getSubtotal())
                .impuesto(domain.getImpuesto())
                .total(domain.getTotal())
                .estado(mapEstado(domain.getEstado()))
                .metodoPago(domain.getMetodoPago() != null ? mapMetodoPago(domain.getMetodoPago()) : null)
                .estadoPago(domain.getEstadoPago() != null ? mapEstadoPago(domain.getEstadoPago()) : null)
                .comprobantePagoUrl(domain.getComprobantePagoUrl())
                .referenciaTransaccion(domain.getReferenciaTransaccion())
                .fechaPago(domain.getFechaPago())
                .fechaVenta(domain.getFechaVenta())
                .fechaCreacion(domain.getFechaCreacion())
                .fechaActualizacion(domain.getFechaActualizacion())
                .build();
    }

    public Venta toDomain(VentaEntity entity) {
        return Venta.builder()
                .id(entity.getId())
                .numeroFactura(entity.getNumeroFactura())
                .cliente(clienteEntityMapper.toDomain(entity.getCliente()))
                .emprendedorId(entity.getEmprendedorId())
                .subtotal(entity.getSubtotal())
                .impuesto(entity.getImpuesto())
                .total(entity.getTotal())
                .estado(mapEstadoDomain(entity.getEstado()))
                .metodoPago(entity.getMetodoPago() != null ? mapMetodoPagoDomain(entity.getMetodoPago()) : null)
                .estadoPago(entity.getEstadoPago() != null ? mapEstadoPagoDomain(entity.getEstadoPago()) : null)
                .comprobantePagoUrl(entity.getComprobantePagoUrl())
                .referenciaTransaccion(entity.getReferenciaTransaccion())
                .fechaPago(entity.getFechaPago())
                .fechaVenta(entity.getFechaVenta())
                .fechaCreacion(entity.getFechaCreacion())
                .fechaActualizacion(entity.getFechaActualizacion())
                .build();
    }

    private VentaEntity.EstadoVenta mapEstado(Venta.EstadoVenta estado) {
        return VentaEntity.EstadoVenta.valueOf(estado.name());
    }

    private Venta.EstadoVenta mapEstadoDomain(VentaEntity.EstadoVenta estado) {
        return Venta.EstadoVenta.valueOf(estado.name());
    }
    
    private VentaEntity.MetodoPago mapMetodoPago(Venta.MetodoPago metodo) {
        return VentaEntity.MetodoPago.valueOf(metodo.name());
    }
    
    private Venta.MetodoPago mapMetodoPagoDomain(VentaEntity.MetodoPago metodo) {
        return Venta.MetodoPago.valueOf(metodo.name());
    }
    
    private VentaEntity.EstadoPago mapEstadoPago(Venta.EstadoPago estado) {
        return VentaEntity.EstadoPago.valueOf(estado.name());
    }
    
    private Venta.EstadoPago mapEstadoPagoDomain(VentaEntity.EstadoPago estado) {
        return Venta.EstadoPago.valueOf(estado.name());
    }
}