package com.example.msvcventas.infrastructure.bpm.delegates;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.camunda.bpm.engine.delegate.DelegateExecution;
import org.camunda.bpm.engine.delegate.JavaDelegate;
import org.springframework.stereotype.Component;

@Slf4j
@Component("enviarNotificacionDelegate")
@RequiredArgsConstructor
public class EnviarNotificacionDelegate implements JavaDelegate {

    @Override
    public void execute(DelegateExecution execution) throws Exception {
        log.info("=== INICIANDO: Envío de Notificación ===");
        
        try {
            Long ventaId = ((Number) execution.getVariable("ventaId")).longValue();
            String numeroFactura = (String) execution.getVariable("numeroFactura");
            Long clienteId = ((Number) execution.getVariable("clienteId")).longValue();
            
            // Aquí se implementaría el envío de email/SMS
            // Por ahora solo registramos en log
            log.info("📧 Notificación enviada al cliente ID={}: Venta completada. Factura={}, VentaID={}", 
                    clienteId, numeroFactura, ventaId);
            
            execution.setVariable("notificacionEnviada", true);
            execution.setVariable("mensajeNotificacion", "Notificación enviada exitosamente");
            
        } catch (Exception e) {
            log.error("Error al enviar notificación", e);
            execution.setVariable("notificacionEnviada", false);
            execution.setVariable("mensajeNotificacion", "Error: " + e.getMessage());
        }
    }
}
