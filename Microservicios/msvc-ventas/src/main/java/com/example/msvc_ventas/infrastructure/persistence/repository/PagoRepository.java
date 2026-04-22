package com.example.msvc_ventas.infrastructure.persistence.repository;

import com.example.msvc_ventas.infrastructure.persistence.entity.PagoEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PagoRepository extends JpaRepository<PagoEntity, Long> {
    
    Optional<PagoEntity> findByVentaId(Long ventaId);
    
    List<PagoEntity> findByEstadoPago(PagoEntity.EstadoPago estadoPago);
    
    @Query("SELECT p FROM PagoEntity p JOIN p.venta v WHERE v.emprendedorId = :emprendedorId")
    List<PagoEntity> findByEmprendedorId(@Param("emprendedorId") Long emprendedorId);
    
    @Query("SELECT p FROM PagoEntity p JOIN p.venta v WHERE v.emprendedorId = :emprendedorId AND p.estadoPago = :estadoPago")
    List<PagoEntity> findByEmprendedorIdAndEstadoPago(
        @Param("emprendedorId") Long emprendedorId, 
        @Param("estadoPago") PagoEntity.EstadoPago estadoPago
    );
}
