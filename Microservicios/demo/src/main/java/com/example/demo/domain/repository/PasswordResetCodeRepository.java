package com.example.demo.domain.repository;

import com.example.demo.domain.model.PasswordResetCode;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface PasswordResetCodeRepository extends JpaRepository<PasswordResetCode, Long> {

    /**
     * Código más reciente solicitado por el usuario (para validar el código
     * ingresado y, luego, el token de restablecimiento).
     */
    Optional<PasswordResetCode> findFirstByUsuarioIdOrderByCreatedAtDesc(Long usuarioId);
}
