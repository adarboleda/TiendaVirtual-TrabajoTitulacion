# Resumen de Migración a MySQL con Emprendedores

## ✅ Completado

### 1. Base de Datos MySQL en Docker
- **Contenedor**: `mysql-feria-digital` corriendo en puerto 3306
- **Credenciales**: admin/admin (simplificadas para testing)
- **Bases de datos creadas**: 
  - auth_service
  - productos
  - inventario
  - ventas

### 2. Esquemas y Datos
✅ **6 usuarios** insertados:
- admin / admin (ROLE_ADMIN)
- ultimo_inca / ultimoinca123 (ROLE_EMP)
- sigcholac / sigcholac123 (ROLE_EMP)
- perla_andina / perlaandina123 (ROLE_EMP)
- grandes_foods / grandesfoods123 (ROLE_EMP)
- cliente1 / cliente123 (ROLE_USER)

✅ **4 emprendedores** con sus empresas:
- ID 1: Último Inca (13 productos de vino)
- ID 2: Sigcholac (10 productos lácteos)
- ID 3: Perla Andina (8 productos de vino)
- ID 4: Grandes Foods (8 productos variados)

✅ **39 productos** distribuidos entre emprendedores con inventario inicial

✅ **5 clientes** de prueba para realizar compras

### 3. Tabla de Emprendedores (NUEVA)
```sql
CREATE TABLE emprendedores (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    usuario_id BIGINT NOT NULL UNIQUE,
    empresa_id BIGINT NOT NULL,
    descripcion TEXT,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (empresa_id) REFERENCES productos.empresas(id)
);
```

### 4. Tabla de Pagos (NUEVA)
```sql
CREATE TABLE pagos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    venta_id BIGINT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    metodo_pago ENUM('TRANSFERENCIA', 'TARJETA', 'DEUNA') NOT NULL,
    estado_pago ENUM('PENDIENTE', 'PROCESANDO', 'APROBADO', 'RECHAZADO') NOT NULL,
    referencia_transaccion VARCHAR(255),
    comprobante_url TEXT,
    fecha_pago TIMESTAMP,
    FOREIGN KEY (venta_id) REFERENCES ventas(id)
);
```

### 5. Campo emprendedor_id Agregado
✅ En tabla **productos**: Relaciona cada producto con su emprendedor
✅ En tabla **ventas**: Permite filtrar ventas por emprendedor
✅ En tabla **detalles_venta**: Identifica qué emprendedor vende cada item

### 6. Configuración de Microservicios Actualizada

#### application.properties (3 microservicios)
```properties
# msvc-producto, msvc-inventario, msvc-ventas
spring.datasource.url=jdbc:mysql://localhost:3306/[database]?useSSL=false&serverTimezone=America/Guayaquil
spring.datasource.username=admin
spring.datasource.password=admin
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.jpa.hibernate.ddl-auto=validate
spring.jpa.database-platform=org.hibernate.dialect.MySQL8Dialect
```

#### pom.xml (3 microservicios)
```xml
<!-- Cambiado de PostgreSQL a MySQL -->
<dependency>
    <groupId>com.mysql</groupId>
    <artifactId>mysql-connector-j</artifactId>
    <scope>runtime</scope>
</dependency>
```

### 7. Entidades JPA Actualizadas

#### ProductoEntity.java
```java
@Column(name = "emprendedor_id", nullable = false)
private Long emprendedorId;
```

#### VentaEntity.java
```java
@Column(name = "emprendedor_id", nullable = false)
private Long emprendedorId;
```

#### DetalleVentaEntity.java
```java
@Column(name = "emprendedor_id", nullable = false)
private Long emprendedorId;
```

#### PagoEntity.java (NUEVA)
- Entidad completa creada en msvc-ventas
- Incluye MetodoPago enum (TRANSFERENCIA, TARJETA, DEUNA)
- Incluye EstadoPago enum (PENDIENTE, PROCESANDO, APROBADO, RECHAZADO)

---

## 📋 Próximos Pasos Recomendados

### 1. Compilar los Microservicios
```powershell
cd Microservicios/msvc-producto
./mvnw clean package -DskipTests

cd ../msvc-inventario
./mvnw clean package -DskipTests

cd ../msvc-ventas
./mvnw clean package -DskipTests
```

### 2. Crear Repositorios para Nuevas Entidades
- **PagoRepository** en msvc-ventas
- **EmprendedorRepository** en msvc-auth (si se crea el microservicio)

### 3. Actualizar DTOs
Agregar campo `emprendedorId` a:
- ProductoDto
- VentaDto
- DetalleVentaDto
- Crear PagoDto

### 4. Crear Servicios para Emprendedores
```java
// ProductoService
List<Producto> obtenerProductosPorEmprendedor(Long emprendedorId);

// VentaService
List<Venta> obtenerVentasPorEmprendedor(Long emprendedorId);
BigDecimal calcularTotalVentasEmprendedor(Long emprendedorId);
```

### 5. Crear Controllers REST
- **/api/emprendedores/{id}/productos** - Productos de un emprendedor
- **/api/emprendedores/{id}/ventas** - Ventas de un emprendedor
- **/api/emprendedores/{id}/estadisticas** - Estadísticas del emprendedor
- **/api/pagos** - CRUD de pagos

### 6. Frontend (avalon-react)
Actualizar servicios para incluir:
```typescript
// emprendedorService.ts
export const obtenerMisProductos = async () => {
  const emprendedorId = getCurrentEmprendedorId();
  return await fetch(`/api/emprendedores/${emprendedorId}/productos`);
};

export const obtenerMisVentas = async () => {
  const emprendedorId = getCurrentEmprendedorId();
  return await fetch(`/api/emprendedores/${emprendedorId}/ventas`);
};
```

---

## 🔧 Comandos Útiles

### Docker MySQL
```powershell
# Ver logs del contenedor
docker logs mysql-feria-digital

# Conectar a MySQL CLI
docker exec -it mysql-feria-digital mysql -u admin -padmin

# Detener contenedor
docker-compose down

# Reiniciar contenedor
docker-compose restart

# Ver bases de datos
docker exec -it mysql-feria-digital mysql -u admin -padmin -e "SHOW DATABASES;"
```

### Verificar Datos
```sql
-- Ver emprendedores
USE auth_service;
SELECT e.id, u.username, em.nombre 
FROM emprendedores e 
JOIN usuarios u ON e.usuario_id = u.id 
JOIN productos.empresas em ON e.empresa_id = em.id;

-- Ver productos por emprendedor
USE productos;
SELECT emprendedor_id, COUNT(*) as total_productos 
FROM productos 
GROUP BY emprendedor_id;

-- Ver inventario
USE inventario;
SELECT i.id, p.nombre, i.cantidad 
FROM inventarios i 
JOIN productos.productos p ON i.producto_id = p.id 
LIMIT 10;
```

---

## ⚠️ Notas Importantes

1. **spring.jpa.hibernate.ddl-auto=validate**: Se cambió a `validate` para que Hibernate NO modifique las tablas. Las tablas ya están creadas por los scripts SQL.

2. **Passwords BCrypt**: Los usuarios tienen passwords hasheadas con BCrypt. El frontend debe usar el mismo algoritmo para autenticación.

3. **Timezone**: Se configuró `serverTimezone=America/Guayaquil` en las URLs de conexión.

4. **Connection Pool**: HikariCP configurado con 50 conexiones máximas para evitar problemas de pool exhaustion.

5. **Pagos Separados**: La tabla `pagos` es independiente de `ventas` para mejor tracking y evitar problemas de procesamiento asíncrono.

---

## 📊 Estadísticas del Sistema

- **Bases de datos**: 4
- **Tablas totales**: ~15
- **Usuarios seed**: 6
- **Emprendedores**: 4
- **Productos**: 39
- **Empresas**: 4
- **Categorías**: 6
- **Clientes**: 5

---

**Fecha de migración**: 2025-01-23
**Sistema**: MySQL 8.0 en Docker
**Microservicios actualizados**: 3 (producto, inventario, ventas)
