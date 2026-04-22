-- Seed usuarios para auth-service
-- Crea 3 usuarios (admin, emprendedor, usuario) con roles si no existen
-- Contraseñas en texto: adminpass, emprendedorpass, usuariopass
-- Las contraseñas se guardan como BCrypt

BEGIN;

-- Usuarios --
-- INSERT usando ON CONFLICT para evitar duplicados por username
INSERT INTO public.usuarios (username, email, nombre, apellido, password, activo)
VALUES
('admin', 'admin@example.com', 'Admin', 'System', '$2a$10$7qQ1q8kNQf7tIYtG1s0qUu2gG6Zc3U5m9KpJx3HqX1zQ8o9sF1B3u', true)
ON CONFLICT (username) DO NOTHING;

INSERT INTO public.usuarios (username, email, nombre, apellido, password, activo)
VALUES
('emprendedor', 'emprendedor@example.com', 'Emprendedor', 'System', '$2a$10$LlOExy4xrjeQrf97migX6ekemzoyHMzseC1bsvt4RCKzedAvvTQrq', true)
ON CONFLICT (username) DO NOTHING;

INSERT INTO public.usuarios (username, email, nombre, apellido, password, activo)
VALUES
('usuario1', 'usuario1@ejemplo.com', 'Usuario', 'Ejemplo', '$2a$10$kywJj9SI7ZW2CWuNlBPY/uFmZjjM9TuDakkeD8srL9TZtma59zsAS', true)
ON CONFLICT (username) DO NOTHING;

-- Obtener ids y asignar roles
-- ROLE_ADMIN al admin
INSERT INTO public.usuario_roles (usuario_id, rol)
SELECT u.id, 'ROLE_ADMIN' FROM public.usuarios u WHERE u.username='admin'
ON CONFLICT DO NOTHING;

-- ROLE_EMP al emprendedor
INSERT INTO public.usuario_roles (usuario_id, rol)
SELECT u.id, 'ROLE_EMP' FROM public.usuarios u WHERE u.username='emprendedor'
ON CONFLICT DO NOTHING;

-- ROLE_USER al usuario1
INSERT INTO public.usuario_roles (usuario_id, rol)
SELECT u.id, 'ROLE_USER' FROM public.usuarios u WHERE u.username='usuario1'
ON CONFLICT DO NOTHING;

COMMIT;
