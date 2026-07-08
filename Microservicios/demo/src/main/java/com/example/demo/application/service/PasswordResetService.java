package com.example.demo.application.service;

import com.example.demo.domain.model.PasswordResetCode;
import com.example.demo.domain.model.Usuario;
import com.example.demo.domain.repository.PasswordResetCodeRepository;
import com.example.demo.domain.repository.UsuarioRepository;
import com.example.demo.infrastructure.mail.EmailService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.Optional;

/**
 * Flujo seguro de recuperación de contraseña en 3 pasos:
 * 1) solicitarCodigo   -> genera un código de 6 dígitos, lo envía por correo (código hasheado en BD)
 * 2) verificarCodigo   -> valida el código y emite un token de restablecimiento de un solo uso
 * 3) restablecerPassword -> consume el token y define la nueva contraseña
 */
@Service
@RequiredArgsConstructor
public class PasswordResetService {

    private static final int CODIGO_VIGENCIA_MINUTOS = 15;
    private static final int TOKEN_VIGENCIA_MINUTOS = 10;

    private final UsuarioRepository usuarioRepository;
    private final PasswordResetCodeRepository passwordResetCodeRepository;
    private final PasswordEncoder passwordEncoder;
    private final EmailService emailService;
    private final SecureRandom secureRandom = new SecureRandom();

    /**
     * Genera y envía un código temporal al correo registrado del usuario.
     * Responde igual exista o no el usuario, para no filtrar qué cuentas existen.
     */
    @Transactional
    public void solicitarCodigo(String username) {
        Optional<Usuario> usuarioOpt = usuarioRepository.findByUsername(username);
        if (usuarioOpt.isEmpty()) {
            return; // no revelar si el usuario existe
        }

        Usuario usuario = usuarioOpt.get();
        String codigo = generarCodigoNumerico();

        PasswordResetCode reset = new PasswordResetCode();
        reset.setUsuarioId(usuario.getId());
        reset.setCodigoHash(passwordEncoder.encode(codigo));
        reset.setExpiraEn(LocalDateTime.now().plusMinutes(CODIGO_VIGENCIA_MINUTOS));
        reset.setVerificado(false);
        reset.setTokenUsado(false);
        passwordResetCodeRepository.save(reset);

        if (usuario.getEmail() != null && !usuario.getEmail().isBlank()) {
            emailService.enviarCodigoRecuperacion(usuario.getEmail(), usuario.getNombre(), codigo);
        }
    }

    /**
     * Valida el código ingresado contra el más reciente solicitado por el usuario.
     * Si es válido, emite un token de restablecimiento (un solo uso, vigencia corta).
     * @return el token de restablecimiento en texto plano, para que el frontend lo use en el siguiente paso
     */
    @Transactional
    public String verificarCodigo(String username, String codigo) {
        Usuario usuario = usuarioRepository.findByUsername(username)
                .orElseThrow(() -> new IllegalArgumentException("Código inválido o expirado"));

        PasswordResetCode reset = passwordResetCodeRepository
                .findFirstByUsuarioIdOrderByCreatedAtDesc(usuario.getId())
                .orElseThrow(() -> new IllegalArgumentException("Código inválido o expirado"));

        if (reset.isVerificado() || reset.getExpiraEn().isBefore(LocalDateTime.now())) {
            throw new IllegalArgumentException("Código inválido o expirado");
        }

        if (!passwordEncoder.matches(codigo, reset.getCodigoHash())) {
            throw new IllegalArgumentException("Código inválido o expirado");
        }

        String resetToken = generarTokenAleatorio();
        reset.setVerificado(true);
        reset.setResetTokenHash(passwordEncoder.encode(resetToken));
        reset.setTokenExpiraEn(LocalDateTime.now().plusMinutes(TOKEN_VIGENCIA_MINUTOS));
        passwordResetCodeRepository.save(reset);

        return resetToken;
    }

    /**
     * Consume el token de restablecimiento (emitido por verificarCodigo) y actualiza la contraseña.
     */
    @Transactional
    public void restablecerPassword(String username, String resetToken, String nuevaPassword) {
        Usuario usuario = usuarioRepository.findByUsername(username)
                .orElseThrow(() -> new IllegalArgumentException("Token inválido o expirado"));

        PasswordResetCode reset = passwordResetCodeRepository
                .findFirstByUsuarioIdOrderByCreatedAtDesc(usuario.getId())
                .orElseThrow(() -> new IllegalArgumentException("Token inválido o expirado"));

        if (!reset.isVerificado() || reset.isTokenUsado()
                || reset.getResetTokenHash() == null
                || reset.getTokenExpiraEn() == null
                || reset.getTokenExpiraEn().isBefore(LocalDateTime.now())) {
            throw new IllegalArgumentException("Token inválido o expirado");
        }

        if (!passwordEncoder.matches(resetToken, reset.getResetTokenHash())) {
            throw new IllegalArgumentException("Token inválido o expirado");
        }

        usuario.setPassword(passwordEncoder.encode(nuevaPassword));
        usuarioRepository.save(usuario);

        reset.setTokenUsado(true);
        passwordResetCodeRepository.save(reset);
    }

    private String generarCodigoNumerico() {
        int codigo = secureRandom.nextInt(1_000_000);
        return String.format("%06d", codigo);
    }

    private String generarTokenAleatorio() {
        byte[] bytes = new byte[24];
        secureRandom.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }
}
