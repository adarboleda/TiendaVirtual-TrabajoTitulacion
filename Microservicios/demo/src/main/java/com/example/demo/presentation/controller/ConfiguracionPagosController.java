package com.example.demo.presentation.controller;

import com.example.demo.application.dto.ConfiguracionPagosDto;
import com.example.demo.application.dto.DatosBancariosDto;
import com.example.demo.domain.service.ConfiguracionPagosService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/emprendedor/configuracion-pagos")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class ConfiguracionPagosController {

    private final ConfiguracionPagosService configuracionPagosService;

    /**
     * Obtener configuración completa del emprendedor autenticado
     */
    @GetMapping
    @PreAuthorize("hasRole('EMP')")
    public ResponseEntity<ConfiguracionPagosDto> obtenerConfiguracion(Authentication authentication) {
        Long emprendedorId = obtenerUsuarioId(authentication);
        
        return configuracionPagosService.obtenerConfiguracion(emprendedorId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * Guardar datos bancarios del emprendedor
     */
    @PostMapping("/bancarios")
    @PreAuthorize("hasRole('EMP')")
    public ResponseEntity<ConfiguracionPagosDto> guardarDatosBancarios(
            @RequestBody DatosBancariosDto datosBancarios,
            Authentication authentication) {
        
        Long emprendedorId = obtenerUsuarioId(authentication);
        ConfiguracionPagosDto config = configuracionPagosService.guardarDatosBancarios(emprendedorId, datosBancarios);
        
        return ResponseEntity.ok(config);
    }

    /**
     * Subir QR de Deuna
     */
    @PostMapping("/deuna-qr")
    @PreAuthorize("hasRole('EMP')")
    public ResponseEntity<?> subirQrDeuna(
            @RequestParam("qrImage") MultipartFile archivo,
            Authentication authentication) {
        
        Long emprendedorId = obtenerUsuarioId(authentication);
        
        // Validar archivo
        if (archivo.isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("error", "Archivo vacío"));
        }
        
        if (!archivo.getContentType().startsWith("image/")) {
            return ResponseEntity.badRequest().body(Map.of("error", "Solo se permiten imágenes"));
        }
        
        if (archivo.getSize() > 5 * 1024 * 1024) { // 5MB
            return ResponseEntity.badRequest().body(Map.of("error", "Imagen muy grande (máximo 5MB)"));
        }
        
        try {
            ConfiguracionPagosDto config = configuracionPagosService.guardarQrDeuna(emprendedorId, archivo);
            
            Map<String, String> response = new HashMap<>();
            response.put("qrUrl", config.getQrDeunaUrl());
            response.put("message", "QR de Deuna guardado exitosamente");
            
            return ResponseEntity.ok(response);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Error al guardar el archivo: " + e.getMessage()));
        }
    }

    /**
     * Eliminar QR de Deuna
     */
    @DeleteMapping("/deuna-qr")
    @PreAuthorize("hasRole('EMP')")
    public ResponseEntity<?> eliminarQrDeuna(Authentication authentication) {
        Long emprendedorId = obtenerUsuarioId(authentication);
        configuracionPagosService.eliminarQrDeuna(emprendedorId);
        
        return ResponseEntity.ok(Map.of("message", "QR eliminado exitosamente"));
    }

    /**
     * Obtener QR de Deuna de un emprendedor (para clientes)
     * Este endpoint es público o puede requerir autenticación según tu lógica
     */
    @GetMapping("/deuna-qr/{emprendedorId}")
    public ResponseEntity<?> obtenerQrDeunaPorEmprendedor(@PathVariable Long emprendedorId) {
        return configuracionPagosService.obtenerQrDeuna(emprendedorId)
                .map(qrUrl -> ResponseEntity.ok(Map.of("qrUrl", qrUrl)))
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * Obtener datos bancarios de un emprendedor (para clientes)
     */
    @GetMapping("/bancarios/{emprendedorId}")
    public ResponseEntity<DatosBancariosDto> obtenerDatosBancariosPorEmprendedor(@PathVariable Long emprendedorId) {
        return configuracionPagosService.obtenerDatosBancarios(emprendedorId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * Extraer ID del usuario autenticado
     */
    private Long obtenerUsuarioId(Authentication authentication) {
        // Ajusta esto según cómo almacenas el ID en el token JWT
        // Puede ser authentication.getName() si guardas el ID como string
        // O puedes obtenerlo de los claims del JWT
        
        try {
            return Long.parseLong(authentication.getName());
        } catch (NumberFormatException e) {
            // Si getName() devuelve el username, necesitarás buscar el usuario por username
            // y obtener su ID desde la base de datos
            throw new RuntimeException("No se pudo obtener el ID del usuario autenticado");
        }
    }
}
