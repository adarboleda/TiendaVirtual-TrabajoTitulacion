-- Script SQL para crear las bases de datos necesarias
-- Ejecuta esto en pgAdmin o desde psql

-- Crear las bases de datos
CREATE DATABASE "auth-service";
CREATE DATABASE productos;
CREATE DATABASE inventario;
CREATE DATABASE ventas;

-- Verificar que se crearon
SELECT datname FROM pg_database WHERE datname IN ('auth-service', 'productos', 'inventario', 'ventas');
