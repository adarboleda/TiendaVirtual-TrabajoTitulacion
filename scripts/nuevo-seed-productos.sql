-- ============================================
-- SCRIPT: Seeds para PRODUCTOS con Emprendedores
-- Descripción: Categorías, empresas y productos vinculados a emprendedores
-- ============================================

BEGIN;

-- ============================================
-- PASO 1: Insertar Categorías
-- ============================================
INSERT INTO public.categorias (nombre, descripcion, activo)
VALUES 
('Vinos', 'Vinos artesanales de frutas andinas', true),
('Lácteos', 'Productos lácteos frescos y artesanales', true),
('Bebidas', 'Bebidas y jugos naturales', true),
('Snacks', 'Snacks y productos procesados', true),
('Cárnicos', 'Productos cárnicos frescos', true),
('Promociones', 'Combos y paquetes promocionales', true)
ON CONFLICT (nombre) DO NOTHING;

-- ============================================
-- PASO 2: Insertar Empresas
-- ============================================
INSERT INTO public.empresas (id, nombre, ruc, email, telefono, direccion, activo)
VALUES 
(1, 'El Último Inca', '1234567890111', 'contacto@ultimoinca.com', '0997279323', 'Barrio: QUINTICUSIG', true),
(2, 'Sigcholac', '1212154849865', 'sigcholac@gmail.com', '0992000198', 'Producción de productos lácteos artesanales', true),
(3, 'Perla Andina', '3213545484645', 'perlaandina@gmail.com', '0993396358', 'Especialidad en vinos premium', true),
(4, 'Grandes Foods', '1792004411001', 'info@grandesfoods.com', '0993665065', 'C. N74-C, Quito 170307', true)
ON CONFLICT (ruc) DO NOTHING;

-- Resetear secuencia
SELECT setval('public.empresas_id_seq', (SELECT MAX(id) FROM public.empresas), true);

-- ============================================
-- PASO 3: Insertar Productos
-- Nota: emprendedor_id debe coincidir con los IDs de emprendedores en auth-service
-- Emprendedor 1 -> El Último Inca (empresa_id: 1)
-- Emprendedor 2 -> Sigcholac (empresa_id: 2)
-- Emprendedor 3 -> Perla Andina (empresa_id: 3)
-- Emprendedor 4 -> Grandes Foods (empresa_id: 4)
-- ============================================

-- Productos de El Último Inca (Emprendedor ID: 1)
INSERT INTO public.productos (nombre, descripcion, precio, imagen, categoria_id, empresa_id, emprendedor_id, activo)
SELECT 
    nombre, descripcion, precio, imagen,
    (SELECT id FROM public.categorias WHERE nombre='Vinos') AS categoria_id,
    1 AS empresa_id,
    1 AS emprendedor_id,
    true
FROM (VALUES
    ('Vino de Mortiño | 165ml', 'Vino artesanal elaborado con mortiño andino, sabor único y frutal.', 2.25, 'https://cdn.zyrosite.com/cdn-cgi/image/format=auto,w=600,fit=crop/cdn-ecommerce/store_01GQQFWQ3ZM7PMRXBNP6HY8WRH%2Fassets%2F1679555028968-MORTI%25C3%2583%25C2%2591O%2520MINI.png'),
    ('Vino de Mortiño | 375ml', 'Vino artesanal elaborado con mortiño andino, sabor único y frutal.', 4.25, 'https://cdn.zyrosite.com/cdn-cgi/image/format=auto,w=600,fit=crop/cdn-ecommerce/store_01GQQFWQ3ZM7PMRXBNP6HY8WRH%2Fassets%2F1679555023779-MORTI%25C3%2583%25C2%2591O%2520SMALL.png'),
    ('Vino de Mortiño | 750ml', 'Vino artesanal elaborado con mortiño andino, sabor único y frutal.', 7.25, 'https://cdn.zyrosite.com/cdn-cgi/image/format=auto,w=656,fit=crop/cdn-ecommerce/store_01GQQFWQ3ZM7PMRXBNP6HY8WRH%2Fassets%2F1679548183215-MORTI%25C3%2583%25C2%2591O.png'),
    ('Vino de Frambuesa | 165ml', 'Vino artesanal elaborado con frambuesa, sabor único y frutal.', 2.50, 'https://cdn.zyrosite.com/cdn-cgi/image/format=auto,w=861,fit=crop/cdn-ecommerce/store_01GQQFWQ3ZM7PMRXBNP6HY8WRH%2Fassets%2F1679555591286-FRAMBUESA%2520MINI.png'),
    ('Vino de Frambuesa | 375ml', 'Vino artesanal elaborado con frambuesa, sabor único y frutal.', 4.50, 'https://cdn.zyrosite.com/cdn-cgi/image/format=auto,w=600,fit=crop/cdn-ecommerce/store_01GQQFWQ3ZM7PMRXBNP6HY8WRH%2Fassets%2F1679549878311-FRAMBUESA%2520SMALL.png'),
    ('Vino de Frambuesa | 750ml', 'Vino artesanal elaborado con frambuesa, sabor único y frutal.', 8.00, 'https://cdn.zyrosite.com/cdn-cgi/image/format=auto,w=656,fit=crop/cdn-ecommerce/store_01GQQFWQ3ZM7PMRXBNP6HY8WRH%2Fassets%2F1679548692567-FRAMBUESA.png'),
    ('Vino de Pitahaya | 165ml', 'Vino artesanal elaborado con Pitahaya, sabor único y frutal.', 2.25, 'https://cdn.zyrosite.com/cdn-cgi/image/format=auto,w=861,fit=crop/cdn-ecommerce/store_01GQQFWQ3ZM7PMRXBNP6HY8WRH%2Fassets%2F1679555424389-PITAHAYA%2520MINI.png'),
    ('Vino de Pitahaya | 375ml', 'Vino artesanal elaborado con Pitahaya, sabor único y frutal.', 4.25, 'https://cdn.zyrosite.com/cdn-cgi/image/format=auto,w=861,fit=crop/cdn-ecommerce/store_01GQQFWQ3ZM7PMRXBNP6HY8WRH%2Fassets%2F1679549970343-PITAHAYA%2520SMALL.png'),
    ('Vino de Pitahaya | 750ml', 'Vino artesanal elaborado con Pitahaya, sabor único y frutal.', 7.25, 'https://cdn.zyrosite.com/cdn-cgi/image/format=auto,w=861,fit=crop/cdn-ecommerce/store_01GQQFWQ3ZM7PMRXBNP6HY8WRH%2Fassets%2F1679549468568-PITAHAYA.png'),
    ('Vino de Maracuyá | 165ml', 'Vino artesanal elaborado con Maracuyá, sabor único y frutal.', 2.25, 'https://cdn.zyrosite.com/cdn-cgi/image/format=auto,w=861,fit=crop/cdn-ecommerce/store_01GQQFWQ3ZM7PMRXBNP6HY8WRH%2Fassets%2F1681336495232-MARACUYA%2520MINI.png'),
    ('Vino de Maracuyá | 375ml', 'Vino artesanal elaborado con Maracuyá, sabor único y frutal.', 4.25, 'https://cdn.zyrosite.com/cdn-cgi/image/format=auto,w=861,fit=crop/cdn-ecommerce/store_01GQQFWQ3ZM7PMRXBNP6HY8WRH%2Fassets%2F1681336495232-MARACUYA%2520SMALL.png'),
    ('Vino de Maracuyá | 750ml', 'Vino artesanal elaborado con Maracuyá, sabor único y frutal.', 7.25, 'https://cdn.zyrosite.com/cdn-cgi/image/format=auto,w=861,fit=crop/cdn-ecommerce/store_01GQQFWQ3ZM7PMRXBNP6HY8WRH%2Fassets%2F1679548980880-MARACUYA.png'),
    ('Vino de Uva | 1L', 'Vino artesanal elaborado con Uva, sabor único y frutal.', 10.00, 'https://cdn.zyrosite.com/cdn-cgi/image/format=auto,w=861,fit=crop/cdn-ecommerce/store_01GQQFWQ3ZM7PMRXBNP6HY8WRH%2Fassets%2F1681336495232-MARACUYA%2520MINI.png')
) AS datos(nombre, descripcion, precio, imagen);

-- Productos de Sigcholac (Emprendedor ID: 2)
INSERT INTO public.productos (nombre, descripcion, precio, imagen, categoria_id, empresa_id, emprendedor_id, activo)
SELECT 
    nombre, descripcion, precio, imagen,
    (SELECT id FROM public.categorias WHERE nombre='Lácteos') AS categoria_id,
    2 AS empresa_id,
    2 AS emprendedor_id,
    true
FROM (VALUES
    ('Queso fresco | 500g', 'Queso fresco artesanal, elaborado con leche de alta calidad. Producto 100% natural.', 2.40, 'https://i.imgur.com/ZSJbdcm.png'),
    ('Queso mozzarella | 500g', 'Queso mozzarella artesanal, textura cremosa. Ideal para pizzas y gratinados.', 3.40, 'https://i.imgur.com/gJIX6pd.png'),
    ('Queso mozzarella | 1000g', 'Queso mozzarella artesanal de 1kg. Sabor suave y textura perfecta.', 6.70, 'https://i.imgur.com/88svWy3.png'),
    ('Queso tipo finca | 500g', 'Queso tipo finca, sabor tradicional. Ideal para acompañar comidas.', 2.00, 'https://i.imgur.com/default.png'),
    ('Queso tipo finca | 1000g', 'Queso tipo finca de 1kg. Producto artesanal 100% natural.', 4.00, 'https://i.imgur.com/default.png'),
    ('Yogurt 0.5 litros', 'Yogurt cremoso y nutritivo. Deliciosos sabores naturales.', 1.00, 'https://i.imgur.com/5NmoEJ1.png'),
    ('Yogurt 1 litro', 'Yogurt cremoso de 1 litro. Perfecto para toda la familia.', 1.75, 'https://i.imgur.com/7C6VcDe.png'),
    ('Yogurt 2 litros', 'Yogurt de 2 litros. Ideal para compartir.', 3.00, 'https://i.imgur.com/WJPBd3I.png'),
    ('Yogurt 4 litros', 'Yogurt de 4 litros. Formato económico familiar.', 5.00, 'https://i.imgur.com/WJPBd3I.png'),
    ('GRAN PROMOCIÓN', '1 Queso fresco 500gr | 1 Yogurt 2L | 1 Queso Mozzarella 500g', 10.00, 'https://i.imgur.com/vFaigkD.png')
) AS datos(nombre, descripcion, precio, imagen);

-- Productos de Perla Andina (Emprendedor ID: 3)
INSERT INTO public.productos (nombre, descripcion, precio, imagen, categoria_id, empresa_id, emprendedor_id, activo)
SELECT 
    nombre, descripcion, precio, imagen,
    (SELECT id FROM public.categorias WHERE nombre='Vinos') AS categoria_id,
    3 AS empresa_id,
    3 AS emprendedor_id,
    true
FROM (VALUES
    ('Vino de mortiño | 165ml', 'Vino dulce premium de mortiño andino. Edición especial.', 2.25, 'https://i.imgur.com/39teCT3.png'),
    ('Vino de mortiño | 375ml', 'Vino dulce de mortiño. Producción artesanal con frutas de páramo.', 5.00, 'https://i.imgur.com/xNInmeg.png'),
    ('Vino de mortiño | 750ml', 'Vino dulce de mortiño premium. Sabor único de los Andes.', 7.00, 'https://i.imgur.com/Ae1cuO6.png'),
    ('Vino de mortiño seco | 750ml', 'Vino seco de mortiño. Para paladares exigentes.', 10.00, 'https://i.imgur.com/zRafdjv.png'),
    ('Vino de mora | 375ml', 'Vino de mora artesanal. Sabor intenso y natural.', 5.00, 'https://i.imgur.com/SmEGeU2.png'),
    ('Vino de mora | 750ml', 'Vino de mora premium. Cosecha de climas templados.', 10.00, 'https://i.imgur.com/SrWVz35.png'),
    ('Vino de frambuesa | 750ml', 'Vino de frambuesa artesanal. Dulce y aromático.', 10.00, 'https://i.imgur.com/v9oRrJG.png'),
    ('Vino de frambuesa | 750ml PREMIUM', 'Vino de frambuesa edición especial. Producción limitada.', 10.00, 'https://i.imgur.com/SmEGeU2_d.png')
) AS datos(nombre, descripcion, precio, imagen);

-- Productos de Grandes Foods (Emprendedor ID: 4)
INSERT INTO public.productos (nombre, descripcion, precio, imagen, categoria_id, empresa_id, emprendedor_id, activo)
SELECT 
    nombre, descripcion, precio, imagen, categoria_id, 
    4 AS empresa_id,
    4 AS emprendedor_id,
    true
FROM (VALUES
    ('Queso fresco | 500g', 'Queso fresco artesanal de alta calidad.', 3.00, 'https://i.imgur.com/eCJ8Ycr.png', (SELECT id FROM public.categorias WHERE nombre='Lácteos')),
    ('Queso mozzarella | 500g', 'Queso mozzarella premium para cocina.', 4.25, 'https://i.imgur.com/NaoM78G.png', (SELECT id FROM public.categorias WHERE nombre='Lácteos')),
    ('Yogurt 1 litro', 'Yogurt natural cremoso y nutritivo.', 2.50, 'https://i.imgur.com/67jahHz.png', (SELECT id FROM public.categorias WHERE nombre='Lácteos')),
    ('Choco | 100g', 'Snack de chocho, alto en proteína vegetal.', 3.00, 'https://i.imgur.com/pwVF7Yg.png', (SELECT id FROM public.categorias WHERE nombre='Snacks')),
    ('Salchicha de ternera | 500g', 'Salchicha 100% carne de res. Jugosa y sabrosa.', 4.00, 'https://i.imgur.com/2YTpcjD.png', (SELECT id FROM public.categorias WHERE nombre='Cárnicos')),
    ('Longaniza de Praga', 'Longaniza ahumada estilo tradicional.', 4.50, 'https://i.imgur.com/2HEc13i.png', (SELECT id FROM public.categorias WHERE nombre='Cárnicos')),
    ('Morcilla de sangre | 500g', 'Morcilla artesanal con especias selectas.', 3.00, 'https://i.imgur.com/faQboVz.png', (SELECT id FROM public.categorias WHERE nombre='Cárnicos')),
    ('Salchicha Frankfurt | 500g', 'Salchicha Frankfurt clásica. Ideal para hot dogs.', 3.00, 'https://i.imgur.com/Y9LX4Gq.png', (SELECT id FROM public.categorias WHERE nombre='Cárnicos'))
) AS datos(nombre, descripcion, precio, imagen, categoria_id);

COMMIT;

-- ============================================
-- VERIFICACIÓN
-- ============================================
SELECT 'Categorías creadas:' AS info;
SELECT id, nombre FROM public.categorias;

SELECT 'Empresas creadas:' AS info;
SELECT id, nombre, ruc FROM public.empresas;

SELECT 'Productos por emprendedor:' AS info;
SELECT 
    e.nombre AS empresa,
    p.emprendedor_id,
    COUNT(*) AS total_productos
FROM public.productos p
JOIN public.empresas e ON p.empresa_id = e.id
GROUP BY e.nombre, p.emprendedor_id
ORDER BY p.emprendedor_id;
