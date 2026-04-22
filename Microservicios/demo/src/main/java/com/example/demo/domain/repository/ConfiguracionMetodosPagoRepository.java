package com.example.demo.domain.repository;

import com.example.demo.domain.model.ConfiguracionMetodosPago;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ConfiguracionMetodosPagoRepository extends JpaRepository<ConfiguracionMetodosPago, Long> {
    
    /**
     * Buscar configuración por ID del emprendedor
     */
    Optional<ConfiguracionMetodosPago> findByEmprendedorId(Long emprendedorId);
    
    /**
     * Verificar si existe configuración para un emprendedor
     */
    boolean existsByEmprendedorId(Long emprendedorId);
    
    /**
     * Eliminar configuración por ID del emprendedor
     */
    void deleteByEmprendedorId(Long emprendedorId);
}
