-- ============================================
-- MIGRACIÓN: Códigos temporales de recuperación de contraseña
-- Ejecutar sobre la BD auth_service:
--   docker exec -i mysql-feria-digital mysql -u root -padmin auth_service < db-11-password-reset-codes.sql
-- ============================================

CREATE TABLE IF NOT EXISTS password_reset_codes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    usuario_id BIGINT NOT NULL,
    codigo_hash VARCHAR(255) NOT NULL,
    expira_en TIMESTAMP NOT NULL,
    verificado BOOLEAN NOT NULL DEFAULT FALSE,
    reset_token_hash VARCHAR(255),
    token_expira_en TIMESTAMP NULL,
    token_usado BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_password_reset_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios(id) ON DELETE CASCADE,
    INDEX idx_password_reset_usuario (usuario_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
