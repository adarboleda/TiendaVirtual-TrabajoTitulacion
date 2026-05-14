package com.example.demo.infrastructure.persistence.repository;

import com.example.demo.infrastructure.persistence.entity.EmprendedorEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface EmprendedorJpaRepository extends JpaRepository<EmprendedorEntity, Long> {
    Optional<EmprendedorEntity> findByUsuarioId(Long usuarioId);
    Optional<EmprendedorEntity> findByEmpresaId(Long empresaId);
}
