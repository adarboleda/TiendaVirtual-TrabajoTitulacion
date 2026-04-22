-- ============================================
-- SEEDS: productos
-- ============================================

USE productos;

-- Insertar categorías
INSERT INTO categorias (nombre, descripcion, activo) VALUES
('Vinos', 'Vinos artesanales de frutas andinas', TRUE),
('Lácteos', 'Productos lácteos frescos y artesanales', TRUE),
('Bebidas', 'Bebidas y jugos naturales', TRUE),
('Snacks', 'Snacks y productos procesados', TRUE),
('Cárnicos', 'Productos cárnicos frescos', TRUE),
('Promociones', 'Combos y paquetes promocionales', TRUE)
ON DUPLICATE KEY UPDATE id=id;

-- Insertar empresas
INSERT INTO empresas (id, nombre, ruc, email, telefono, direccion, activo) VALUES
(1, 'El Último Inca', '1234567890111', 'contacto@ultimoinca.com', '0997279323', 'Barrio: QUINTICUSIG', TRUE),
(2, 'Sigcholac', '1212154849865', 'sigcholac@gmail.com', '0992000198', 'Producción de productos lácteos artesanales', TRUE),
(3, 'Perla Andina', '3213545484645', 'perlaandina@gmail.com', '0993396358', 'Especialidad en vinos premium', TRUE),
(4, 'Grandes Foods', '1792004411001', 'info@grandesfoods.com', '0993665065', 'C. N74-C, Quito 170307', TRUE)
ON DUPLICATE KEY UPDATE id=id;

-- Productos de El Último Inca (Emprendedor ID: 1)
INSERT INTO productos (nombre, descripcion, precio, imagen, categoria_id, empresa_id, emprendedor_id, activo) VALUES
('Vino de Mortiño | 165ml', 'Vino artesanal elaborado con mortiño andino, sabor único y frutal.', 2.25, 'https://cdn.zyrosite.com/cdn-cgi/image/format=auto,w=600,fit=crop/cdn-ecommerce/store_01GQQFWQ3ZM7PMRXBNP6HY8WRH%2Fassets%2F1679555028968-MORTI%25C3%2583%25C2%2591O%2520MINI.png', 1, 1, 1, TRUE),
('Vino de Mortiño | 375ml', 'Vino artesanal elaborado con mortiño andino, sabor único y frutal.', 4.25, 'https://cdn.zyrosite.com/cdn-cgi/image/format=auto,w=600,fit=crop/cdn-ecommerce/store_01GQQFWQ3ZM7PMRXBNP6HY8WRH%2Fassets%2F1679555023779-MORTI%25C3%2583%25C2%2591O%2520SMALL.png', 1, 1, 1, TRUE),
('Vino de Mortiño | 750ml', 'Vino artesanal elaborado con mortiño andino, sabor único y frutal.', 7.25, 'https://cdn.zyrosite.com/cdn-cgi/image/format=auto,w=656,fit=crop/cdn-ecommerce/store_01GQQFWQ3ZM7PMRXBNP6HY8WRH%2Fassets%2F1679548183215-MORTI%25C3%2583%25C2%2591O.png', 1, 1, 1, TRUE),
('Vino de Frambuesa | 165ml', 'Vino artesanal elaborado con frambuesa, sabor único y frutal.', 2.50, 'https://cdn.zyrosite.com/cdn-cgi/image/format=auto,w=861,fit=crop/cdn-ecommerce/store_01GQQFWQ3ZM7PMRXBNP6HY8WRH%2Fassets%2F1679555591286-FRAMBUESA%2520MINI.png', 1, 1, 1, TRUE),
('Vino de Frambuesa | 375ml', 'Vino artesanal elaborado con frambuesa, sabor único y frutal.', 4.50, 'https://cdn.zyrosite.com/cdn-cgi/image/format=auto,w=600,fit=crop/cdn-ecommerce/store_01GQQFWQ3ZM7PMRXBNP6HY8WRH%2Fassets%2F1679549878311-FRAMBUESA%2520SMALL.png', 1, 1, 1, TRUE),
('Vino de Frambuesa | 750ml', 'Vino artesanal elaborado con frambuesa, sabor único y frutal.', 8.00, 'https://cdn.zyrosite.com/cdn-cgi/image/format=auto,w=656,fit=crop/cdn-ecommerce/store_01GQQFWQ3ZM7PMRXBNP6HY8WRH%2Fassets%2F1679548692567-FRAMBUESA.png', 1, 1, 1, TRUE),
('Vino de Pitahaya | 165ml', 'Vino artesanal elaborado con Pitahaya, sabor único y frutal.', 2.25, 'https://cdn.zyrosite.com/cdn-cgi/image/format=auto,w=861,fit=crop/cdn-ecommerce/store_01GQQFWQ3ZM7PMRXBNP6HY8WRH%2Fassets%2F1679555424389-PITAHAYA%2520MINI.png', 1, 1, 1, TRUE),
('Vino de Pitahaya | 375ml', 'Vino artesanal elaborado con Pitahaya, sabor único y frutal.', 4.25, 'https://cdn.zyrosite.com/cdn-cgi/image/format=auto,w=861,fit=crop/cdn-ecommerce/store_01GQQFWQ3ZM7PMRXBNP6HY8WRH%2Fassets%2F1679549970343-PITAHAYA%2520SMALL.png', 1, 1, 1, TRUE),
('Vino de Pitahaya | 750ml', 'Vino artesanal elaborado con Pitahaya, sabor único y frutal.', 7.25, 'https://cdn.zyrosite.com/cdn-cgi/image/format=auto,w=861,fit=crop/cdn-ecommerce/store_01GQQFWQ3ZM7PMRXBNP6HY8WRH%2Fassets%2F1679549468568-PITAHAYA.png', 1, 1, 1, TRUE),
('Vino de Maracuyá | 165ml', 'Vino artesanal elaborado con Maracuyá, sabor único y frutal.', 2.25, 'https://cdn.zyrosite.com/cdn-cgi/image/format=auto,w=861,fit=crop/cdn-ecommerce/store_01GQQFWQ3ZM7PMRXBNP6HY8WRH%2Fassets%2F1681336495232-MARACUYA%2520MINI.png', 1, 1, 1, TRUE),
('Vino de Maracuyá | 375ml', 'Vino artesanal elaborado con Maracuyá, sabor único y frutal.', 4.25, 'https://cdn.zyrosite.com/cdn-cgi/image/format=auto,w=861,fit=crop/cdn-ecommerce/store_01GQQFWQ3ZM7PMRXBNP6HY8WRH%2Fassets%2F1681336495232-MARACUYA%2520SMALL.png', 1, 1, 1, TRUE),
('Vino de Maracuyá | 750ml', 'Vino artesanal elaborado con Maracuyá, sabor único y frutal.', 7.25, 'https://cdn.zyrosite.com/cdn-cgi/image/format=auto,w=861,fit=crop/cdn-ecommerce/store_01GQQFWQ3ZM7PMRXBNP6HY8WRH%2Fassets%2F1679548980880-MARACUYA.png', 1, 1, 1, TRUE),
('Vino de Uva | 1L', 'Vino artesanal elaborado con Uva, sabor único y frutal.', 10.00, 'https://cdn.zyrosite.com/cdn-cgi/image/format=auto,w=861,fit=crop/cdn-ecommerce/store_01GQQFWQ3ZM7PMRXBNP6HY8WRH%2Fassets%2F1681336495232-MARACUYA%2520MINI.png', 1, 1, 1, TRUE);

-- Productos de Sigcholac (Emprendedor ID: 2)
INSERT INTO productos (nombre, descripcion, precio, imagen, categoria_id, empresa_id, emprendedor_id, activo) VALUES
('Queso fresco | 500g', 'Queso fresco artesanal, elaborado con leche de alta calidad. Producto 100% natural.', 2.40, 'https://i.imgur.com/ZSJbdcm.png', 2, 2, 2, TRUE),
('Queso mozzarella | 500g', 'Queso mozzarella artesanal, textura cremosa. Ideal para pizzas y gratinados.', 3.40, 'https://i.imgur.com/gJIX6pd.png', 2, 2, 2, TRUE),
('Queso mozzarella | 1000g', 'Queso mozzarella artesanal de 1kg. Sabor suave y textura perfecta.', 6.70, 'https://i.imgur.com/88svWy3.png', 2, 2, 2, TRUE),
('Queso tipo finca | 500g', 'Queso tipo finca, sabor tradicional. Ideal para acompañar comidas.', 2.00, 'https://i.imgur.com/default.png', 2, 2, 2, TRUE),
('Queso tipo finca | 1000g', 'Queso tipo finca de 1kg. Producto artesanal 100% natural.', 4.00, 'https://i.imgur.com/default.png', 2, 2, 2, TRUE),
('Yogurt 0.5 litros', 'Yogurt cremoso y nutritivo. Deliciosos sabores naturales.', 1.00, 'https://i.imgur.com/5NmoEJ1.png', 2, 2, 2, TRUE),
('Yogurt 1 litro', 'Yogurt cremoso de 1 litro. Perfecto para toda la familia.', 1.75, 'https://i.imgur.com/7C6VcDe.png', 2, 2, 2, TRUE),
('Yogurt 2 litros', 'Yogurt de 2 litros. Ideal para compartir.', 3.00, 'https://i.imgur.com/WJPBd3I.png', 2, 2, 2, TRUE),
('Yogurt 4 litros', 'Yogurt de 4 litros. Formato económico familiar.', 5.00, 'https://i.imgur.com/WJPBd3I.png', 2, 2, 2, TRUE),
('GRAN PROMOCIÓN', '1 Queso fresco 500gr | 1 Yogurt 2L | 1 Queso Mozzarella 500g', 10.00, 'https://i.imgur.com/vFaigkD.png', 6, 2, 2, TRUE);

-- Productos de Perla Andina (Emprendedor ID: 3)  
INSERT INTO productos (nombre, descripcion, precio, imagen, categoria_id, empresa_id, emprendedor_id, activo) VALUES
('Vino de mortiño | 165ml', 'Vino dulce premium de mortiño andino. Edición especial.', 2.25, 'https://i.imgur.com/39teCT3.png', 1, 3, 3, TRUE),
('Vino de mortiño | 375ml', 'Vino dulce de mortiño. Producción artesanal con frutas de páramo.', 5.00, 'https://i.imgur.com/xNInmeg.png', 1, 3, 3, TRUE),
('Vino de mortiño | 750ml', 'Vino dulce de mortiño premium. Sabor único de los Andes.', 7.00, 'https://i.imgur.com/Ae1cuO6.png', 1, 3, 3, TRUE),
('Vino de mortiño seco | 750ml', 'Vino seco de mortiño. Para paladares exigentes.', 10.00, 'https://i.imgur.com/zRafdjv.png', 1, 3, 3, TRUE),
('Vino de mora | 375ml', 'Vino de mora artesanal. Sabor intenso y natural.', 5.00, 'https://i.imgur.com/SmEGeU2.png', 1, 3, 3, TRUE),
('Vino de mora | 750ml', 'Vino de mora premium. Cosecha de climas templados.', 10.00, 'https://i.imgur.com/SrWVz35.png', 1, 3, 3, TRUE),
('Vino de frambuesa | 750ml', 'Vino de frambuesa artesanal. Dulce y aromático.', 10.00, 'https://i.imgur.com/v9oRrJG.png', 1, 3, 3, TRUE),
('Vino de frambuesa PREMIUM | 750ml', 'Vino de frambuesa edición especial. Producción limitada.', 10.00, 'https://i.imgur.com/SmEGeU2_d.png', 1, 3, 3, TRUE);

-- Productos de Grandes Foods (Emprendedor ID: 4)
INSERT INTO productos (nombre, descripcion, precio, imagen, categoria_id, empresa_id, emprendedor_id, activo) VALUES
('Queso fresco | 500g', 'Queso fresco artesanal de alta calidad.', 3.00, 'https://i.imgur.com/eCJ8Ycr.png', 2, 4, 4, TRUE),
('Queso mozzarella | 500g', 'Queso mozzarella premium para cocina.', 4.25, 'https://i.imgur.com/NaoM78G.png', 2, 4, 4, TRUE),
('Yogurt 1 litro', 'Yogurt natural cremoso y nutritivo.', 2.50, 'https://i.imgur.com/67jahHz.png', 2, 4, 4, TRUE),
('Choco | 100g', 'Snack de chocho, alto en proteína vegetal.', 3.00, 'https://i.imgur.com/pwVF7Yg.png', 4, 4, 4, TRUE),
('Salchicha de ternera | 500g', 'Salchicha 100% carne de res. Jugosa y sabrosa.', 4.00, 'https://i.imgur.com/2YTpcjD.png', 5, 4, 4, TRUE),
('Longaniza de Praga', 'Longaniza ahumada estilo tradicional.', 4.50, 'https://i.imgur.com/2HEc13i.png', 5, 4, 4, TRUE),
('Morcilla de sangre | 500g', 'Morcilla artesanal con especias selectas.', 3.00, 'https://i.imgur.com/faQboVz.png', 5, 4, 4, TRUE),
('Salchicha Frankfurt | 500g', 'Salchicha Frankfurt clásica. Ideal para hot dogs.', 3.00, 'https://i.imgur.com/Y9LX4Gq.png', 5, 4, 4, TRUE);
