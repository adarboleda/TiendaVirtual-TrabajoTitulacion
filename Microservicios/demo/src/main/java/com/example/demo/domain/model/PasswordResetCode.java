package com.example.demo.domain.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * Código temporal de un solo uso para el flujo de recuperación de contraseña.
 * El código y el token de restablecimiento se guardan hasheados (BCrypt),
 * nunca en texto plano.
 */
@Entity
@Table(name = "password_reset_codes")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PasswordResetCode {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "usuario_id", nullable = false)
    private Long usuarioId;

    @Column(name = "codigo_hash", nullable = false, length = 255)
    private String codigoHash;

    @Column(name = "expira_en", nullable = false)
    private LocalDateTime expiraEn;

    @Column(name = "verificado", nullable = false)
    private boolean verificado;

    @Column(name = "reset_token_hash", length = 255)
    private String resetTokenHash;

    @Column(name = "token_expira_en")
    private LocalDateTime tokenExpiraEn;

    @Column(name = "token_usado", nullable = false)
    private boolean tokenUsado;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
}
