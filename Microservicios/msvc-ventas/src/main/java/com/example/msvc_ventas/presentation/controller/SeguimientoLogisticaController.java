package com.example.msvc_ventas.presentation.controller;

import com.example.msvc_ventas.application.dto.ActualizarSeguimientoDto;
import com.example.msvc_ventas.application.dto.SeguimientoLogisticaDto;
import com.example.msvc_ventas.domain.model.SeguimientoLogistica;
import com.example.msvc_ventas.domain.repository.VentaRepository;
import com.example.msvc_ventas.domain.service.SeguimientoLogisticaService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@CrossOrigin(origins = {"http://localhost:3000", "http://127.0.0.1:3000"})
@RequestMapping("/api/seguimiento-logistica")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "Seguimiento Logístico", description = "API para gestionar el seguimiento logístico de pedidos")
public class SeguimientoLogisticaController {

    private final SeguimientoLogisticaService seguimientoService;
    private final VentaRepository ventaRepository;

    @PostMapping
    @Operation(summary = "Crear una nueva actualización de seguimiento")
    public ResponseEntity<?> crearSeguimiento(@Valid @RequestBody ActualizarSeguimientoDto dto) {
        log.info("Creando seguimiento para venta ID: {} con estado: {}", dto.getVentaId(), dto.getEstadoLogistica());
        
        try {
            SeguimientoLogistica.EstadoLogistica estado = SeguimientoLogistica.EstadoLogistica.valueOf(dto.getEstadoLogistica());
            
            SeguimientoLogistica seguimiento = seguimientoService.crearSeguimiento(
                    dto.getVentaId(),
                    estado,
                    dto.getDescripcion(),
                    dto.getUbicacion(),
                    dto.getResponsable(),
                    dto.getObservaciones()
            );

            return ResponseEntity.status(HttpStatus.CREATED).body(toDto(seguimiento));
        } catch (IllegalArgumentException e) {
            log.error("Estado logístico inválido: {}", dto.getEstadoLogistica());
            return ResponseEntity.badRequest().body("Estado logístico inválido: " + dto.getEstadoLogistica());
        } catch (Exception e) {
            log.error("Error al crear seguimiento", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error al crear seguimiento: " + e.getMessage());
        }
    }

    @PutMapping
    @Operation(summary = "Actualizar el estado de seguimiento de un pedido")
    public ResponseEntity<?> actualizarSeguimiento(@Valid @RequestBody ActualizarSeguimientoDto dto) {
        log.info("Actualizando seguimiento para venta ID: {} a estado: {}", dto.getVentaId(), dto.getEstadoLogistica());
        
        try {
            SeguimientoLogistica.EstadoLogistica estado = SeguimientoLogistica.EstadoLogistica.valueOf(dto.getEstadoLogistica());
            
            SeguimientoLogistica seguimiento = seguimientoService.actualizarEstado(
                    dto.getVentaId(),
                    estado,
                    dto.getDescripcion(),
                    dto.getUbicacion(),
                    dto.getResponsable(),
                    dto.getObservaciones()
            );

            return ResponseEntity.ok(toDto(seguimiento));
        } catch (IllegalArgumentException e) {
            log.error("Estado logístico inválido: {}", dto.getEstadoLogistica());
            return ResponseEntity.badRequest().body("Estado logístico inválido: " + dto.getEstadoLogistica());
        } catch (IllegalStateException e) {
            log.error("Error de estado: {}", e.getMessage());
            return ResponseEntity.status(HttpStatus.CONFLICT).body(e.getMessage());
        } catch (Exception e) {
            log.error("Error al actualizar seguimiento", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error al actualizar seguimiento: " + e.getMessage());
        }
    }

    @GetMapping("/venta/{ventaId}")
    @Operation(summary = "Obtener historial completo de seguimiento de una venta")
    public ResponseEntity<List<SeguimientoLogisticaDto>> obtenerHistorialPorVenta(@PathVariable Long ventaId) {
        log.info("Obteniendo historial de seguimiento para venta ID: {}", ventaId);
        
        List<SeguimientoLogistica> historial = seguimientoService.obtenerHistorialPorVenta(ventaId);
        List<SeguimientoLogisticaDto> dtos = historial.stream()
                .map(this::toDto)
                .collect(Collectors.toList());
        
        return ResponseEntity.ok(dtos);
    }

    @GetMapping("/venta/{ventaId}/ultimo")
    @Operation(summary = "Obtener el último estado de seguimiento de una venta")
    public ResponseEntity<?> obtenerUltimoEstado(@PathVariable Long ventaId) {
        log.info("Obteniendo último estado de seguimiento para venta ID: {}", ventaId);
        
        SeguimientoLogistica seguimiento = seguimientoService.obtenerUltimoEstado(ventaId);
        
        if (seguimiento == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body("No se encontró seguimiento para la venta con ID: " + ventaId);
        }
        
        return ResponseEntity.ok(toDto(seguimiento));
    }

    @GetMapping("/emprendedor/{emprendedorId}")
    @Operation(summary = "Obtener todos los seguimientos de un emprendedor")
    public ResponseEntity<List<SeguimientoLogisticaDto>> obtenerSeguimientosPorEmprendedor(@PathVariable Long emprendedorId) {
        log.info("Obteniendo seguimientos del emprendedor ID: {}", emprendedorId);
        
        List<SeguimientoLogistica> seguimientos = seguimientoService.obtenerSeguimientosPorEmprendedor(emprendedorId);
        List<SeguimientoLogisticaDto> dtos = seguimientos.stream()
                .map(this::toDto)
                .collect(Collectors.toList());
        
        return ResponseEntity.ok(dtos);
    }

    @GetMapping("/emprendedor/{emprendedorId}/estado/{estado}")
    @Operation(summary = "Obtener seguimientos de un emprendedor en un estado específico")
    public ResponseEntity<?> obtenerSeguimientosPorEmprendedorYEstado(
            @PathVariable Long emprendedorId,
            @PathVariable String estado) {
        log.info("Obteniendo seguimientos del emprendedor {} en estado {}", emprendedorId, estado);
        
        try {
            SeguimientoLogistica.EstadoLogistica estadoEnum = SeguimientoLogistica.EstadoLogistica.valueOf(estado);
            List<SeguimientoLogistica> seguimientos = seguimientoService.obtenerSeguimientosPorEmprendedorYEstado(emprendedorId, estadoEnum);
            List<SeguimientoLogisticaDto> dtos = seguimientos.stream()
                    .map(this::toDto)
                    .collect(Collectors.toList());
            
            return ResponseEntity.ok(dtos);
        } catch (IllegalArgumentException e) {
            log.error("Estado logístico inválido: {}", estado);
            return ResponseEntity.badRequest().body("Estado logístico inválido: " + estado);
        }
    }

    @GetMapping("/estados")
    @Operation(summary = "Obtener lista de todos los estados logísticos disponibles")
    public ResponseEntity<List<EstadoInfo>> obtenerEstadosDisponibles() {
        log.info("Obteniendo lista de estados logísticos disponibles");
        
        List<EstadoInfo> estados = List.of(
                new EstadoInfo("PAGO_APROBADO", "Pago aprobado", "El pago ha sido verificado y aprobado por el emprendedor"),
                new EstadoInfo("EN_PREPARACION", "En preparación", "El pedido está siendo preparado"),
                new EstadoInfo("LISTO_PARA_ENVIO", "Listo para envío", "El pedido está listo para ser enviado"),
                new EstadoInfo("EN_CAMINO", "En camino", "El pedido está en tránsito"),
                new EstadoInfo("EN_PUNTO_ENTREGA", "En punto de entrega", "El pedido ha llegado al punto de entrega"),
                new EstadoInfo("ENTREGADO", "Entregado", "El pedido ha sido entregado al cliente"),
                new EstadoInfo("CANCELADO", "Cancelado", "El pedido ha sido cancelado")
        );
        
        return ResponseEntity.ok(estados);
    }

    // Métodos auxiliares
    private SeguimientoLogisticaDto toDto(SeguimientoLogistica seguimiento) {
        // Obtener número de factura de la venta
        String numeroFactura = ventaRepository.findById(seguimiento.getVentaId())
                .map(venta -> venta.getNumeroFactura())
                .orElse("N/A");

        return SeguimientoLogisticaDto.builder()
                .id(seguimiento.getId())
                .ventaId(seguimiento.getVentaId())
                .numeroFactura(numeroFactura)
                .estadoLogistica(seguimiento.getEstadoLogistica().name())
                .estadoTitulo(seguimiento.getEstadoLogistica().getTitulo())
                .descripcion(seguimiento.getDescripcion())
                .ubicacion(seguimiento.getUbicacion())
                .responsable(seguimiento.getResponsable())
                .observaciones(seguimiento.getObservaciones())
                .fechaActualizacion(seguimiento.getFechaActualizacion())
                .fechaCreacion(seguimiento.getFechaCreacion())
                .build();
    }

    // Clase interna para información de estados
    @lombok.Data
    @lombok.AllArgsConstructor
    @lombok.NoArgsConstructor
    private static class EstadoInfo {
        private String codigo;
        private String titulo;
        private String descripcion;
    }
}
