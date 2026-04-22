package com.example.msvcventas.infrastructure.bpm.delegates;

import com.example.msvc_ventas.application.client.ProductoClient;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.camunda.bpm.engine.delegate.DelegateExecution;
import org.camunda.bpm.engine.delegate.JavaDelegate;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

@Slf4j
@Component("validarProductosDelegate")
@RequiredArgsConstructor
public class ValidarProductosDelegate implements JavaDelegate {

    private final ProductoClient productoClient;

    @Override
    public void execute(DelegateExecution execution) throws Exception {
        log.info("=== INICIANDO: Validación de Productos ===");
        
        // Obtener items de la venta del contexto del proceso
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> items = (List<Map<String, Object>>) execution.getVariable("items");
        
        boolean todosValidos = true;
        StringBuilder mensajeError = new StringBuilder();

        try {
            for (Map<String, Object> item : items) {
                Long productoId = ((Number) item.get("productoId")).longValue();
                
                // Validar que el producto existe y está activo
                try {
                    var producto = productoClient.obtenerProducto(productoId);
                    if (producto == null) {
                        todosValidos = false;
                        mensajeError.append("Producto ID ").append(productoId).append(" no existe. ");
                    } else if (!producto.getActivo()) {
                        todosValidos = false;
                        mensajeError.append("Producto ID ").append(productoId).append(" no está activo. ");
                    }
                } catch (Exception e) {
                    todosValidos = false;
                    mensajeError.append("Error al validar producto ID ").append(productoId).append(": ").append(e.getMessage()).append(". ");
                }
            }

            // Guardar resultado en variables del proceso
            execution.setVariable("productosValidos", todosValidos);
            execution.setVariable("mensajeValidacion", todosValidos ? "Todos los productos son válidos" : mensajeError.toString());
            
            log.info("Validación de productos: {}", todosValidos ? "EXITOSA" : "FALLIDA - " + mensajeError);
            
        } catch (Exception e) {
            log.error("Error al validar productos", e);
            execution.setVariable("productosValidos", false);
            execution.setVariable("mensajeValidacion", "Error inesperado: " + e.getMessage());
        }
    }
}
