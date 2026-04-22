-- ============================================
-- SCRIPT MAESTRO: Recrear todas las bases de datos
-- Descripción: Elimina y recrea todas las bases de datos con el nuevo esquema
-- ADVERTENCIA: Este script ELIMINARÁ TODOS LOS DATOS EXISTENTES
-- ============================================

-- ============================================
-- IMPORTANTE: Ejecutar este script como superusuario de PostgreSQL
-- Comando: psql -U postgres -h localhost -p 5433 -f recrear-bases-datos-completo.sql
-- ============================================

\echo '============================================'
\echo 'INICIANDO RECREACIÓN DE BASES DE DATOS'
\echo '============================================'
\echo ''

-- ============================================
-- PASO 1: Eliminar bases de datos existentes
-- ============================================
\echo 'PASO 1: Eliminando bases de datos existentes...'
\echo ''

-- Terminar conexiones activas
SELECT pg_terminate_backend(pid) 
FROM pg_stat_activity 
WHERE datname IN ('auth-service', 'productos', 'inventario', 'ventas')
  AND pid <> pg_backend_pid();

-- Eliminar bases de datos
DROP DATABASE IF EXISTS "auth-service";
DROP DATABASE IF EXISTS "productos";
DROP DATABASE IF EXISTS "inventario";
DROP DATABASE IF EXISTS "ventas";

\echo 'Bases de datos eliminadas.'
\echo ''

-- ============================================
-- PASO 2: Crear bases de datos nuevas
-- ============================================
\echo 'PASO 2: Creando bases de datos nuevas...'
\echo ''

CREATE DATABASE "auth-service" 
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Spanish_Ecuador.1252'
    LC_CTYPE = 'Spanish_Ecuador.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

CREATE DATABASE "productos" 
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Spanish_Ecuador.1252'
    LC_CTYPE = 'Spanish_Ecuador.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

CREATE DATABASE "inventario" 
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Spanish_Ecuador.1252'
    LC_CTYPE = 'Spanish_Ecuador.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

CREATE DATABASE "ventas" 
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Spanish_Ecuador.1252'
    LC_CTYPE = 'Spanish_Ecuador.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

\echo 'Bases de datos creadas.'
\echo ''

-- ============================================
-- PASO 3: Aplicar schemas
-- ============================================
\echo 'PASO 3: Aplicando schemas...'
\echo ''

\echo '  >> Aplicando schema auth-service...'
\connect "auth-service"
\i nuevo-schema-auth-service.sql

\echo '  >> Aplicando schema productos...'
\connect productos
\i nuevo-schema-productos.sql

\echo '  >> Aplicando schema inventario...'
\connect inventario
\i nuevo-schema-inventario.sql

\echo '  >> Aplicando schema ventas...'
\connect ventas
\i nuevo-schema-ventas.sql

\echo 'Schemas aplicados.'
\echo ''

-- ============================================
-- PASO 4: Insertar datos iniciales (seeds)
-- ============================================
\echo 'PASO 4: Insertando datos iniciales...'
\echo ''

\echo '  >> Insertando datos en auth-service...'
\connect "auth-service"
\i nuevo-seed-auth-service.sql

\echo '  >> Insertando datos en productos...'
\connect productos
\i nuevo-seed-productos.sql

\echo '  >> Insertando datos en inventario...'
\connect inventario
\i nuevo-seed-inventario.sql

\echo '  >> Insertando datos en ventas...'
\connect ventas
\i nuevo-seed-ventas.sql

\echo 'Datos iniciales insertados.'
\echo ''

-- ============================================
-- FINALIZADO
-- ============================================
\echo '============================================'
\echo 'RECREACIÓN DE BASES DE DATOS COMPLETADA'
\echo '============================================'
\echo ''
\echo 'Resumen:'
\echo '  - auth-service: Usuarios, roles y emprendedores'
\echo '  - productos: Categorías, empresas y productos con emprendedor_id'
\echo '  - inventario: Inventarios y movimientos'
\echo '  - ventas: Clientes (sin ventas iniciales)'
\echo ''
\echo 'Próximos pasos:'
\echo '  1. Reiniciar los microservicios'
\echo '  2. Verificar conectividad con las nuevas bases de datos'
\echo '  3. Probar el flujo de compra completo'
\echo ''
