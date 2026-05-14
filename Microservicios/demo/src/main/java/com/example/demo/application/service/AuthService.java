package com.example.demo.application.service;

import com.example.demo.application.dto.LoginRequestDto;
import com.example.demo.application.dto.TokenResponseDto;
import com.example.demo.application.dto.UsuarioResponseDto;
import com.example.demo.domain.model.Usuario;
import com.example.demo.domain.service.UsuarioService;
import com.example.demo.infrastructure.persistence.entity.EmprendedorEntity;
import com.example.demo.infrastructure.persistence.repository.EmprendedorJpaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.oauth2.jose.jws.MacAlgorithm;
import org.springframework.security.oauth2.jwt.JwtClaimsSet;
import org.springframework.security.oauth2.jwt.JwtEncoder;
import org.springframework.security.oauth2.jwt.JwtEncoderParameters;
import org.springframework.security.oauth2.jwt.JwsHeader;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final JwtEncoder jwtEncoder;
    private final UserDetailsService userDetailsService;
    private final UsuarioService usuarioService;
    private final EmprendedorJpaRepository emprendedorRepository;

    public TokenResponseDto login(LoginRequestDto loginRequest) {
        UserDetails userDetails = userDetailsService.loadUserByUsername(loginRequest.getUsername());

        // Obtener usuario completo para información adicional
        Usuario usuario = usuarioService.buscarPorUsername(loginRequest.getUsername())
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        // Buscar empresaId si el usuario es emprendedor
        Long empresaId = null;
        Optional<EmprendedorEntity> emprendedor = emprendedorRepository.findByUsuarioId(usuario.getId());
        if (emprendedor.isPresent() && emprendedor.get().getEmpresaId() != null) {
            empresaId = emprendedor.get().getEmpresaId();
        }

        Authentication authentication = new UsernamePasswordAuthenticationToken(
                userDetails, null, userDetails.getAuthorities());

        return generateToken(authentication, usuario, empresaId);
    }

    private TokenResponseDto generateToken(Authentication authentication, Usuario usuario, Long empresaId) {
        Instant now = Instant.now();
        long expiresIn = 3600; // 1 hora

        String scope = authentication.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .collect(Collectors.joining(" "));

        // Construir claims del JWT
        JwtClaimsSet.Builder claimsBuilder = JwtClaimsSet.builder()
                .issuer("self")
                .issuedAt(now)
                .expiresAt(now.plus(expiresIn, ChronoUnit.SECONDS))
                .subject(authentication.getName())
                .claim("scope", scope)
                .claim("userId", usuario.getId())
                .claim("email", usuario.getEmail())
                .claim("nombre", usuario.getNombre())
                .claim("apellido", usuario.getApellido());

        // Agregar empresaId si existe
        if (empresaId != null) {
            claimsBuilder.claim("empresaId", empresaId);
        }

        JwtClaimsSet claims = claimsBuilder.build();

        // Especificar explícitamente HS256 para que NimbusJwtEncoder seleccione
        // la clave HMAC correcta. Sin esto, usa RS256 por defecto y falla.
        JwsHeader jwsHeader = JwsHeader.with(MacAlgorithm.HS256).build();
        String token = jwtEncoder.encode(JwtEncoderParameters.from(jwsHeader, claims)).getTokenValue();

        // Construir información del usuario en la respuesta
        UsuarioResponseDto usuarioDto = new UsuarioResponseDto();
        usuarioDto.setId(usuario.getId());
        usuarioDto.setUsername(usuario.getUsername());
        usuarioDto.setEmail(usuario.getEmail());
        usuarioDto.setNombre(usuario.getNombre());
        usuarioDto.setApellido(usuario.getApellido());
        usuarioDto.setActivo(usuario.isActivo());
        usuarioDto.setRoles(usuario.getRoles());
        usuarioDto.setEmpresaId(empresaId);

        // Construir respuesta completa
        TokenResponseDto tokenResponse = new TokenResponseDto();
        tokenResponse.setAccessToken(token);
        tokenResponse.setTokenType("Bearer");
        tokenResponse.setExpiresIn(expiresIn);
        tokenResponse.setUsuario(usuarioDto);

        return tokenResponse;
    }
}