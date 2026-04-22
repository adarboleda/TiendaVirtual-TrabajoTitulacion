package com.example.msvcventas.infrastructure.bpm.delegates;

import com.example.msvc_ventas.application.client.InventarioClient;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.camunda.bpm.engine.delegate.DelegateExecution;
import org.camunda.bpm.engine.delegate.JavaDelegate;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

@Slf4j
@Component("actualizarInventarioDelegate")
@RequiredArgsConstructor
public class ActualizarInventarioDelegate implements JavaDelegate {

    private final InventarioClient inventarioClient;

    @Override
    public void execute(DelegateExecution execution) throws Exception {
        log.info("=== INICIANDO: Actualización de Inventario ===");
        
        try {
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> items = (List<Map<String, Object>>) execution.getVariable("items");
            Long ventaId = ((Number) execution.getVariable("ventaId")).longValue();
            
            boolean actualizacionExitosa = true;
            StringBuilder mensajeError = new StringBuilder();
            
            for (Map<String, Object> item : items) {
                Long productoId = ((Number) item.get("productoId")).longValue();
                Integer cantidad = ((Number) item.get("cantidad")).intValue();
                
                try {
                    // Descontar del inventario (cantidad negativa)
                    inventarioClient.actualizarInventario(
                        productoId, 
                        -cantidad, 
                        "VENTA", 
                        "Venta ID: " + ventaId
                    );
                    log.info("Inventario actualizado: ProductoID={}, Cantidad descontada={}", productoId, cantidad);
                } catch (Exception e) {
                    actualizacionExitosa = false;
                    mensajeError.append("Error al actualizar producto ID ")
                               .append(productoId).append(": ").append(e.getMessage()).append(". ");
                    log.error("Error al actualizar inventario del producto {}", productoId, e);
                }
            }
            
            execution.setVariable("inventarioActualizado", actualizacionExitosa);
            execution.setVariable("mensajeInventarioActualizado", 
                    actualizacionExitosa ? "Inventario actualizado correctamente" : mensajeError.toString());
            
            log.info("Actualización de inventario: {}", actualizacionExitosa ? "EXITOSA" : "FALLIDA");
            
        } catch (Exception e) {
            log.error("Error al actualizar inventario", e);
            execution.setVariable("inventarioActualizado", false);
            execution.setVariable("mensajeInventarioActualizado", "Error inesperado: " + e.getMessage());
        }
    }
}
