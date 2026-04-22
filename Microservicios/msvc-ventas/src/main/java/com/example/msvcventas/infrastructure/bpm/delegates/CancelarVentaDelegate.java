package com.example.msvcventas.infrastructure.bpm.delegates;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.camunda.bpm.engine.delegate.DelegateExecution;
import org.camunda.bpm.engine.delegate.JavaDelegate;
import org.springframework.stereotype.Component;

@Slf4j
@Component("cancelarVentaDelegate")
@RequiredArgsConstructor
public class CancelarVentaDelegate implements JavaDelegate {

    @Override
    public void execute(DelegateExecution execution) throws Exception {
        log.info("=== INICIANDO: Cancelación de Venta ===");
        
        try {
            String motivo = "";
            
            // Determinar motivo de cancelación
            if (execution.getVariable("productosValidos") == Boolean.FALSE) {
                motivo = "Productos inválidos: " + execution.getVariable("mensajeValidacion");
            } else if (execution.getVariable("stockDisponible") == Boolean.FALSE) {
                motivo = "Stock insuficiente: " + execution.getVariable("mensajeInventario");
            }
            
            execution.setVariable("ventaCancelada", true);
            execution.setVariable("motivoCancelacion", motivo);
            
            log.warn("❌ Venta cancelada: {}", motivo);
            
        } catch (Exception e) {
            log.error("Error al cancelar venta", e);
        }
    }
}
