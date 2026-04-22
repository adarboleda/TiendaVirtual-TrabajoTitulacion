package com.example.msvcventas.infrastructure.bpm.delegates;

import com.example.msvc_ventas.domain.service.VentaService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.camunda.bpm.engine.delegate.DelegateExecution;
import org.camunda.bpm.engine.delegate.JavaDelegate;
import org.springframework.stereotype.Component;

@Slf4j
@Component("revertirVentaDelegate")
@RequiredArgsConstructor
public class RevertirVentaDelegate implements JavaDelegate {

    private final VentaService ventaService;

    @Override
    public void execute(DelegateExecution execution) throws Exception {
        log.info("=== INICIANDO: Reversión de Venta (Compensación) ===");
        
        try {
            Long ventaId = ((Number) execution.getVariable("ventaId")).longValue();
            String motivoReversion = "Pago fallido: " + execution.getVariable("mensajePago");
            
            // Cancelar la venta en la base de datos
            ventaService.cancelarVenta(ventaId);
            
            execution.setVariable("ventaRevertida", true);
            execution.setVariable("motivoReversion", motivoReversion);
            
            log.warn("🔄 Venta revertida: VentaID={}, Motivo={}", ventaId, motivoReversion);
            
        } catch (Exception e) {
            log.error("Error al revertir venta", e);
            execution.setVariable("ventaRevertida", false);
            execution.setVariable("errorReversion", e.getMessage());
        }
    }
}
