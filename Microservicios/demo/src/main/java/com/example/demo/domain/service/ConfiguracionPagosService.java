package com.example.demo.domain.service;

import com.example.demo.application.dto.ConfiguracionPagosDto;
import com.example.demo.application.dto.DatosBancariosDto;
import com.example.demo.application.dto.PayphoneDto;
import com.example.demo.domain.model.ConfiguracionMetodosPago;
import com.example.demo.domain.repository.ConfiguracionMetodosPagoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ConfiguracionPagosService {

    private final ConfiguracionMetodosPagoRepository configuracionRepository;

    // Directorio donde se guardarán las imágenes de QR
    private final String uploadDir = "uploads/qr-deuna/";

    // Cuota fija de envío por defecto ($5.00)
    public static final BigDecimal COSTO_ENVIO_POR_DEFECTO = new BigDecimal("5.00");

    /**
     * Obtener configuración de pagos del emprendedor
     */
    @Transactional(readOnly = true)
    public Optional<ConfiguracionPagosDto> obtenerConfiguracion(Long emprendedorId) {
        return configuracionRepository.findByEmprendedorId(emprendedorId)
                .map(this::convertirADto);
    }

    /**
     * Guardar o actualizar datos bancarios
     */
    @Transactional
    public ConfiguracionPagosDto guardarDatosBancarios(Long emprendedorId, DatosBancariosDto datosBancarios) {
        ConfiguracionMetodosPago config = configuracionRepository.findByEmprendedorId(emprendedorId)
                .orElse(new ConfiguracionMetodosPago());
        
        config.setEmprendedorId(emprendedorId);
        config.setBanco(datosBancarios.getBanco());
        config.setTipoCuenta(datosBancarios.getTipoCuenta());
        config.setNumeroCuenta(datosBancarios.getNumeroCuenta());
        config.setTitular(datosBancarios.getTitular());
        config.setCedulaRuc(datosBancarios.getCedulaRuc());
        config.setEmail(datosBancarios.getEmail());
        
        config = configuracionRepository.save(config);
        return convertirADto(config);
    }

    /**
     * Guardar o actualizar datos de Payphone
     */
    @Transactional
    public ConfiguracionPagosDto guardarPayphone(Long emprendedorId, PayphoneDto payphoneDto) {
        ConfiguracionMetodosPago config = configuracionRepository.findByEmprendedorId(emprendedorId)
                .orElse(new ConfiguracionMetodosPago());
        
        config.setEmprendedorId(emprendedorId);
        config.setPayphoneAppId(payphoneDto.getPayphoneAppId());
        config.setPayphoneToken(payphoneDto.getPayphoneToken());
        
        config = configuracionRepository.save(config);
        return convertirADto(config);
    }

    /**
     * Guardar la cuota de envío del emprendedor (solo rol EMP puede invocarlo)
     */
    @Transactional
    public ConfiguracionPagosDto guardarCostoEnvio(Long emprendedorId, BigDecimal costoEnvio) {
        ConfiguracionMetodosPago config = configuracionRepository.findByEmprendedorId(emprendedorId)
                .orElse(new ConfiguracionMetodosPago());

        config.setEmprendedorId(emprendedorId);
        config.setCostoEnvio(costoEnvio);

        config = configuracionRepository.save(config);
        return convertirADto(config);
    }

    /**
     * Obtener la cuota de envío vigente de un emprendedor (para clientes en el checkout).
     * Si el emprendedor no la configuró, se devuelve la cuota fija de $5.00.
     */
    @Transactional(readOnly = true)
    public BigDecimal obtenerCostoEnvio(Long emprendedorId) {
        return configuracionRepository.findByEmprendedorId(emprendedorId)
                .map(ConfiguracionMetodosPago::getCostoEnvio)
                .filter(valor -> valor != null && valor.compareTo(BigDecimal.ZERO) >= 0)
                .orElse(COSTO_ENVIO_POR_DEFECTO);
    }

    /**
     * Guardar QR de Deuna
     */
    @Transactional
    public ConfiguracionPagosDto guardarQrDeuna(Long emprendedorId, MultipartFile archivo) throws IOException {
        // Crear directorio si no existe
        Path uploadPath = Paths.get(uploadDir);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        // Generar nombre único para el archivo
        String nombreArchivo = emprendedorId + "_" + UUID.randomUUID() + "_" + archivo.getOriginalFilename();
        Path rutaArchivo = uploadPath.resolve(nombreArchivo);

        // Guardar archivo
        Files.copy(archivo.getInputStream(), rutaArchivo, StandardCopyOption.REPLACE_EXISTING);

        // Obtener o crear configuración
        ConfiguracionMetodosPago config = configuracionRepository.findByEmprendedorId(emprendedorId)
                .orElse(new ConfiguracionMetodosPago());
        
        // Eliminar QR anterior si existe
        if (config.getQrDeunaUrl() != null && !config.getQrDeunaUrl().isEmpty()) {
            eliminarArchivoQr(config.getQrDeunaUrl());
        }

        config.setEmprendedorId(emprendedorId);
        config.setQrDeunaUrl("/uploads/qr-deuna/" + nombreArchivo);
        
        config = configuracionRepository.save(config);
        return convertirADto(config);
    }

    /**
     * Eliminar QR de Deuna
     */
    @Transactional
    public void eliminarQrDeuna(Long emprendedorId) {
        configuracionRepository.findByEmprendedorId(emprendedorId)
                .ifPresent(config -> {
                    if (config.getQrDeunaUrl() != null) {
                        eliminarArchivoQr(config.getQrDeunaUrl());
                        config.setQrDeunaUrl(null);
                        configuracionRepository.save(config);
                    }
                });
    }

    /**
     * Obtener QR de Deuna de un emprendedor específico (para clientes)
     */
    @Transactional(readOnly = true)
    public Optional<String> obtenerQrDeuna(Long emprendedorId) {
        return configuracionRepository.findByEmprendedorId(emprendedorId)
                .map(ConfiguracionMetodosPago::getQrDeunaUrl);
    }

    /**
     * Obtener datos bancarios de un emprendedor (para clientes)
     */
    @Transactional(readOnly = true)
    public Optional<DatosBancariosDto> obtenerDatosBancarios(Long emprendedorId) {
        return configuracionRepository.findByEmprendedorId(emprendedorId)
                .map(config -> {
                    DatosBancariosDto dto = new DatosBancariosDto();
                    dto.setBanco(config.getBanco());
                    dto.setTipoCuenta(config.getTipoCuenta());
                    dto.setNumeroCuenta(config.getNumeroCuenta());
                    dto.setTitular(config.getTitular());
                    dto.setCedulaRuc(config.getCedulaRuc());
                    dto.setEmail(config.getEmail());
                    return dto;
                });
    }

    /**
     * Convertir entidad a DTO
     */
    private ConfiguracionPagosDto convertirADto(ConfiguracionMetodosPago config) {
        ConfiguracionPagosDto dto = new ConfiguracionPagosDto();
        dto.setId(config.getId());
        dto.setEmprendedorId(config.getEmprendedorId());
        dto.setQrDeunaUrl(config.getQrDeunaUrl());
        dto.setCostoEnvio(config.getCostoEnvio() != null ? config.getCostoEnvio() : COSTO_ENVIO_POR_DEFECTO);
        
        if (config.getBanco() != null) {
            DatosBancariosDto datosBancarios = new DatosBancariosDto();
            datosBancarios.setBanco(config.getBanco());
            datosBancarios.setTipoCuenta(config.getTipoCuenta());
            datosBancarios.setNumeroCuenta(config.getNumeroCuenta());
            datosBancarios.setTitular(config.getTitular());
            datosBancarios.setCedulaRuc(config.getCedulaRuc());
            datosBancarios.setEmail(config.getEmail());
            dto.setDatosBancarios(datosBancarios);
        }
        
        if (config.getPayphoneAppId() != null || config.getPayphoneToken() != null) {
            PayphoneDto payphone = new PayphoneDto();
            payphone.setPayphoneAppId(config.getPayphoneAppId());
            payphone.setPayphoneToken(config.getPayphoneToken());
            dto.setPayphone(payphone);
        }
        
        return dto;
    }

    /**
     * Eliminar archivo físico de QR
     */
    private void eliminarArchivoQr(String qrUrl) {
        try {
            if (qrUrl != null && qrUrl.startsWith("/uploads/qr-deuna/")) {
                String nombreArchivo = qrUrl.replace("/uploads/qr-deuna/", "");
                Path rutaArchivo = Paths.get(uploadDir + nombreArchivo);
                Files.deleteIfExists(rutaArchivo);
            }
        } catch (IOException e) {
            // Log error pero no fallar
            System.err.println("Error al eliminar archivo QR: " + e.getMessage());
        }
    }
}
