package com.example.msvcventas.infrastructure.bpm.delegates;

import com.example.msvc_ventas.domain.service.FacturaService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.camunda.bpm.engine.delegate.DelegateExecution;
import org.camunda.bpm.engine.delegate.JavaDelegate;
import org.springframework.stereotype.Component;

import java.io.File;

@Slf4j
@Component("generarFacturaDelegate")
@RequiredArgsConstructor
public class GenerarFacturaDelegate implements JavaDelegate {

    private final FacturaService facturaService;

    @Override
    public void execute(DelegateExecution execution) throws Exception {
        log.info("=== INICIANDO: Generación de Factura ===");
        
        try {
            Long ventaId = ((Number) execution.getVariable("ventaId")).longValue();
            
            // Generar factura PDF (retorna File, no byte[])
            File facturaPdf = facturaService.obtenerFacturaPDF(ventaId);
            
            // Guardar resultado
            execution.setVariable("facturaGenerada", true);
            execution.setVariable("facturaTamanio", facturaPdf.length());
            execution.setVariable("facturaPath", facturaPdf.getAbsolutePath());
            
            log.info("Factura generada exitosamente: VentaID={}, Tamaño={}bytes", ventaId, facturaPdf.length());
            
        } catch (Exception e) {
            log.error("Error al generar factura", e);
            execution.setVariable("facturaGenerada", false);
            execution.setVariable("errorFactura", e.getMessage());
        }
    }
}
