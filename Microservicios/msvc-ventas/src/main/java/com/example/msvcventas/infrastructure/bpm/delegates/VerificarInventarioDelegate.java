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
@Component("verificarInventarioDelegate")
@RequiredArgsConstructor
public class VerificarInventarioDelegate implements JavaDelegate {

    private final InventarioClient inventarioClient;

    @Override
    public void execute(DelegateExecution execution) throws Exception {
        log.info("=== INICIANDO: Verificación de Inventario ===");
        
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> items = (List<Map<String, Object>>) execution.getVariable("items");
        
        boolean stockSuficiente = true;
        StringBuilder mensajeError = new StringBuilder();

        try {
            for (Map<String, Object> item : items) {
                Long productoId = ((Number) item.get("productoId")).longValue();
                Integer cantidadSolicitada = ((Number) item.get("cantidad")).intValue();
                
                try {
                    var inventario = inventarioClient.obtenerInventarioPorProductoId(productoId);
                    
                    if (inventario == null || inventario.getCantidadDisponible() < cantidadSolicitada) {
                        stockSuficiente = false;
                        int disponible = inventario != null ? inventario.getCantidadDisponible() : 0;
                        mensajeError.append("Producto ID ").append(productoId)
                                   .append(": solicitado=").append(cantidadSolicitada)
                                   .append(", disponible=").append(disponible).append(". ");
                    }
                } catch (Exception e) {
                    stockSuficiente = false;
                    mensajeError.append("Error al verificar inventario de producto ID ")
                               .append(productoId).append(": ").append(e.getMessage()).append(". ");
                }
            }

            execution.setVariable("stockDisponible", stockSuficiente);
            execution.setVariable("mensajeInventario", stockSuficiente ? "Stock suficiente" : mensajeError.toString());
            
            log.info("Verificación de inventario: {}", stockSuficiente ? "EXITOSA" : "FALLIDA - " + mensajeError);
            
        } catch (Exception e) {
            log.error("Error al verificar inventario", e);
            execution.setVariable("stockDisponible", false);
            execution.setVariable("mensajeInventario", "Error inesperado: " + e.getMessage());
        }
    }
}
