package com.example.msvcventas.infrastructure.bpm.delegates;

import com.example.msvc_ventas.domain.model.Venta;
import com.example.msvc_ventas.domain.model.DetalleVenta;
import com.example.msvc_ventas.domain.service.VentaService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.camunda.bpm.engine.delegate.DelegateExecution;
import org.camunda.bpm.engine.delegate.JavaDelegate;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Slf4j
@Component("crearVentaDelegate")
@RequiredArgsConstructor
public class CrearVentaDelegate implements JavaDelegate {

    private final VentaService ventaService;

    @Override
    public void execute(DelegateExecution execution) throws Exception {
        log.info("=== INICIANDO: Creación de Venta ===");
        
        try {
            // Obtener datos del proceso
            Long clienteId = ((Number) execution.getVariable("clienteId")).longValue();
            String metodoPago = (String) execution.getVariable("metodoPago");
            
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> itemsMap = (List<Map<String, Object>>) execution.getVariable("items");
            
            // Convertir a detalles de venta
            List<DetalleVenta> detalles = new ArrayList<>();
            for (Map<String, Object> itemMap : itemsMap) {
                DetalleVenta detalle = new DetalleVenta();
                detalle.setProductoId(((Number) itemMap.get("productoId")).longValue());
                detalle.setCantidad(((Number) itemMap.get("cantidad")).intValue());
                detalles.add(detalle);
            }
            
            // Crear entidad de venta
            Venta venta = new Venta();
            venta.setCliente(new com.example.msvc_ventas.domain.model.Cliente());
            venta.getCliente().setId(clienteId);
            venta.setDetalles(detalles);
            venta.setMetodoPago(Venta.MetodoPago.valueOf(metodoPago.toUpperCase()));
            venta.setEstado(Venta.EstadoVenta.PENDIENTE);
            venta.setEstadoPago(Venta.EstadoPago.PENDIENTE);
            
            // Crear venta
            venta = ventaService.crearVenta(venta);
            
            // Guardar ID de venta en el proceso
            execution.setVariable("ventaId", venta.getId());
            execution.setVariable("numeroFactura", venta.getNumeroFactura());
            execution.setVariable("totalVenta", venta.getTotal());
            execution.setVariable("ventaCreada", true);
            
            log.info("Venta creada exitosamente: ID={}, Factura={}, Total={}", 
                    venta.getId(), venta.getNumeroFactura(), venta.getTotal());
            
        } catch (Exception e) {
            log.error("Error al crear venta", e);
            execution.setVariable("ventaCreada", false);
            execution.setVariable("errorCreacion", e.getMessage());
            throw e;
        }
    }
}
