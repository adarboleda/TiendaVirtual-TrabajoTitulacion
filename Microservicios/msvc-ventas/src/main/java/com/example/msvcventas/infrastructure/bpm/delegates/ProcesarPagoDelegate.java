package com.example.msvcventas.infrastructure.bpm.delegates;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.camunda.bpm.engine.delegate.DelegateExecution;
import org.camunda.bpm.engine.delegate.JavaDelegate;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;

@Slf4j
@Component("procesarPagoDelegate")
@RequiredArgsConstructor
public class ProcesarPagoDelegate implements JavaDelegate {

    @Override
    public void execute(DelegateExecution execution) throws Exception {
        log.info("=== INICIANDO: Procesamiento de Pago ===");
        
        try {
            String metodoPago = (String) execution.getVariable("metodoPago");
            BigDecimal totalVenta = (BigDecimal) execution.getVariable("totalVenta");
            Long ventaId = ((Number) execution.getVariable("ventaId")).longValue();
            
            log.info("Procesando pago: Método={}, Monto={}, VentaID={}", metodoPago, totalVenta, ventaId);
            
            // Simular procesamiento de pago
            // En producción, aquí se integraría con Stripe, PayPal, etc.
            boolean pagoExitoso = true;
            String transaccionId = "TXN-" + System.currentTimeMillis();
            
            // Simulación de validación según método de pago
            switch (metodoPago.toUpperCase()) {
                case "TARJETA":
                    // Aquí iría la integración con Stripe
                    log.info("Procesando pago con tarjeta...");
                    pagoExitoso = true;
                    break;
                case "TRANSFERENCIA":
                    log.info("Verificando transferencia bancaria...");
                    pagoExitoso = true;
                    break;
                case "DEUNA":
                    log.info("Procesando pago con DEUNA...");
                    pagoExitoso = true;
                    break;
                default:
                    log.warn("Método de pago no reconocido: {}", metodoPago);
                    pagoExitoso = false;
            }
            
            // Guardar resultado en el proceso
            execution.setVariable("pagoExitoso", pagoExitoso);
            execution.setVariable("transaccionId", transaccionId);
            execution.setVariable("mensajePago", pagoExitoso ? "Pago procesado exitosamente" : "Error al procesar pago");
            
            log.info("Resultado del pago: {}, TransacciónID={}", pagoExitoso ? "EXITOSO" : "FALLIDO", transaccionId);
            
        } catch (Exception e) {
            log.error("Error al procesar pago", e);
            execution.setVariable("pagoExitoso", false);
            execution.setVariable("mensajePago", "Error inesperado: " + e.getMessage());
        }
    }
}
