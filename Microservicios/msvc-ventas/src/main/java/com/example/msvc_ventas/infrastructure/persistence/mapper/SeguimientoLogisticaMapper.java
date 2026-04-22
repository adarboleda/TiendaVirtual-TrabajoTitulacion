package com.example.msvc_ventas.infrastructure.persistence.mapper;

import com.example.msvc_ventas.domain.model.SeguimientoLogistica;
import com.example.msvc_ventas.infrastructure.persistence.entity.SeguimientoLogisticaEntity;
import org.springframework.stereotype.Component;

@Component
public class SeguimientoLogisticaMapper {

    public SeguimientoLogistica toDomain(SeguimientoLogisticaEntity entity) {
        if (entity == null) {
            return null;
        }

        return SeguimientoLogistica.builder()
                .id(entity.getId())
                .ventaId(entity.getVentaId())
                .estadoLogistica(mapEstadoLogistica(entity.getEstadoLogistica()))
                .descripcion(entity.getDescripcion())
                .ubicacion(entity.getUbicacion())
                .responsable(entity.getResponsable())
                .observaciones(entity.getObservaciones())
                .fechaActualizacion(entity.getFechaActualizacion())
                .fechaCreacion(entity.getFechaCreacion())
                .build();
    }

    public SeguimientoLogisticaEntity toEntity(SeguimientoLogistica domain) {
        if (domain == null) {
            return null;
        }

        return SeguimientoLogisticaEntity.builder()
                .id(domain.getId())
                .ventaId(domain.getVentaId())
                .estadoLogistica(mapEstadoLogisticaEntity(domain.getEstadoLogistica()))
                .descripcion(domain.getDescripcion())
                .ubicacion(domain.getUbicacion())
                .responsable(domain.getResponsable())
                .observaciones(domain.getObservaciones())
                .fechaActualizacion(domain.getFechaActualizacion())
                .fechaCreacion(domain.getFechaCreacion())
                .build();
    }

    private SeguimientoLogistica.EstadoLogistica mapEstadoLogistica(SeguimientoLogisticaEntity.EstadoLogistica estado) {
        if (estado == null) {
            return null;
        }
        return SeguimientoLogistica.EstadoLogistica.valueOf(estado.name());
    }

    private SeguimientoLogisticaEntity.EstadoLogistica mapEstadoLogisticaEntity(SeguimientoLogistica.EstadoLogistica estado) {
        if (estado == null) {
            return null;
        }
        return SeguimientoLogisticaEntity.EstadoLogistica.valueOf(estado.name());
    }
}
