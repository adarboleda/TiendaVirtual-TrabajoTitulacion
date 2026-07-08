package com.example.demo.infrastructure.mail;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.time.Year;

@Slf4j
@Service
@RequiredArgsConstructor
public class EmailService {

    private final JavaMailSender mailSender;

    @Value("${app.mail.from}")
    private String fromAddress;

    @Value("${app.mail.from-name}")
    private String fromName;

    /**
     * Envía el código temporal de recuperación de contraseña.
     */
    @Async
    public void enviarCodigoRecuperacion(String to, String nombre, String codigo) {
        String subject = "Código para restablecer tu contraseña";
        String body = buildCodigoHtml(nombre, codigo);
        send(to, subject, body);
    }

    @Async
    public void send(String to, String subject, String htmlBody) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            helper.setFrom(fromAddress, fromName);
            helper.setTo(to);
            helper.setSubject(subject);
            helper.setText(htmlBody, true);
            mailSender.send(message);
            log.info("Correo enviado a {}: {}", to, subject);
        } catch (MessagingException e) {
            log.error("Error enviando correo a {}: {}", to, e.getMessage());
        } catch (Exception e) {
            log.error("Error inesperado en envío de correo: {}", e.getMessage());
        }
    }

    private String buildCodigoHtml(String nombre, String codigo) {
        int year = Year.now().getValue();
        String nombreMostrado = (nombre == null || nombre.isBlank()) ? "" : nombre;

        return """
            <!DOCTYPE html>
            <html lang="es">
            <head>
              <meta charSet="UTF-8">
              <meta name="viewport" content="width=device-width, initial-scale=1.0">
            </head>
            <body style="font-family:Arial,sans-serif;background:#f2f5f3;padding:20px;margin:0;">
              <div style="max-width:520px;margin:0 auto;background:#fff;border-radius:12px;overflow:hidden;box-shadow:0 2px 8px rgba(0,0,0,.08);">
                <div style="background:#16a34a;color:#fff;padding:26px 32px;">
                  <p style="margin:0 0 4px;font-size:12px;opacity:.85;letter-spacing:2px;text-transform:uppercase;">Sigchos E-commerce</p>
                  <h1 style="margin:0;font-size:20px;font-weight:700;">Recuperar contraseña</h1>
                </div>
                <div style="padding:32px;">
                  <p style="color:#374151;margin:0 0 8px;">Hola%s,</p>
                  <p style="color:#4b5563;margin:0 0 24px;">Usa el siguiente código para continuar con el restablecimiento de tu contraseña. El código es válido por <strong>15 minutos</strong>.</p>
                  <div style="text-align:center;margin-bottom:24px;">
                    <span style="display:inline-block;background:#ecfdf5;border:2px dashed #16a34a;color:#15803d;font-size:28px;font-weight:700;letter-spacing:8px;padding:14px 26px;border-radius:10px;">%s</span>
                  </div>
                  <p style="color:#9ca3af;font-size:13px;text-align:center;margin:0;">Si no solicitaste este cambio, puedes ignorar este correo — tu contraseña seguirá siendo la misma.</p>
                </div>
                <div style="background:#f9fafb;padding:14px 32px;text-align:center;color:#9ca3af;font-size:12px;">
                  © %d Sigchos E-commerce
                </div>
              </div>
            </body>
            </html>
            """.formatted(nombreMostrado.isBlank() ? "" : " " + nombreMostrado, codigo, year);
    }
}
