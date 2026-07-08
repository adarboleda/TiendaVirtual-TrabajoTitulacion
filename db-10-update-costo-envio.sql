-- ============================================
-- MIGRACIÓN: Cuota de envío configurable por emprendedor
-- Ejecutar sobre una BD existente (para BD nuevas ya está en db-02):
--   docker exec -i mysql-feria-digital mysql -u root -padmin auth_service < db-10-update-costo-envio.sql
-- ============================================

ALTER TABLE configuracion_metodos_pago
    ADD COLUMN costo_envio DECIMAL(10,2) DEFAULT 5.00 AFTER qr_deuna_url;
