# 🐳 Sistema con MySQL en Docker - Configuración Completa

## 📋 Descripción

Sistema completo de microservicios con MySQL 8.0 en Docker. Incluye todas las bases de datos y datos de prueba pre-cargados.

## 🚀 Inicio Rápido

### 1. Iniciar MySQL con Docker

```powershell
# Opción 1: Usar el script automatizado (Recomendado)
.\iniciar-mysql.ps1

# Opción 2: Usar docker-compose directamente
docker-compose up -d
```

### 2. Verificar que MySQL está corriendo

```powershell
docker ps
# Deberías ver: mysql-feria-digital

docker logs mysql-feria-digital
# Verifica que dice "ready for connections"
```

## 🔐 Credenciales

```
Host:       localhost
Puerto:     3306
Usuario:    admin
Contraseña: admin
```

## 📊 Bases de Datos Creadas

- ✅ `auth_service` - Usuarios, roles y emprendedores
- ✅ `productos` - Categorías, empresas y productos
- ✅ `inventario` - Inventarios y movimientos
- ✅ `ventas` - Clientes, ventas, detalles y pagos

## 👥 Usuarios de Prueba

| Usuario | Contraseña | Rol | Empresa |
|---------|-----------|-----|---------|
| `admin` | `admin` | ADMIN | - |
| `ultimo_inca` | `ultimoinca123` | EMPRENDEDOR | El Último Inca |
| `sigcholac` | `sigcholac123` | EMPRENDEDOR | Sigcholac |
| `perla_andina` | `perlaandina123` | EMPRENDEDOR | Perla Andina |
| `grandes_foods` | `grandesfoods123` | EMPRENDEDOR | Grandes Foods |
| `cliente1` | `cliente123` | CLIENTE | - |

## 📦 Datos Incluidos

- **4 Emprendedores** con perfiles completos
- **39 Productos** distribuidos entre emprendedores
  - El Último Inca: 13 vinos artesanales
  - Sigcholac: 10 productos lácteos
  - Perla Andina: 8 vinos premium
  - Grandes Foods: 8 productos variados
- **39 Inventarios** con stock inicial
- **5 Clientes** de prueba

## ⚙️ Configuración de Microservicios

### Paso 1: Actualizar `application.properties`

Actualiza los archivos `application.properties` de cada microservicio:

#### msvc-auth (puerto 8080)
```properties
# Base de datos
spring.datasource.url=jdbc:mysql://localhost:3306/auth_service?useSSL=false&serverTimezone=America/Guayaquil&allowPublicKeyRetrieval=true
spring.datasource.username=admin
spring.datasource.password=admin
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# JPA
spring.jpa.hibernate.ddl-auto=validate
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect
spring.jpa.properties.hibernate.format_sql=true

# HikariCP
spring.datasource.hikari.maximum-pool-size=50
spring.datasource.hikari.minimum-idle=10
spring.datasource.hikari.connection-timeout=60000
spring.datasource.hikari.idle-timeout=300000
spring.datasource.hikari.max-lifetime=600000
```

#### msvc-producto (puerto 8081)
```properties
# Base de datos
spring.datasource.url=jdbc:mysql://localhost:3306/productos?useSSL=false&serverTimezone=America/Guayaquil&allowPublicKeyRetrieval=true
spring.datasource.username=admin
spring.datasource.password=admin
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# JPA
spring.jpa.hibernate.ddl-auto=validate
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect
spring.jpa.properties.hibernate.format_sql=true

# HikariCP
spring.datasource.hikari.maximum-pool-size=50
spring.datasource.hikari.minimum-idle=10
spring.datasource.hikari.connection-timeout=60000
spring.datasource.hikari.idle-timeout=300000
spring.datasource.hikari.max-lifetime=600000
```

#### msvc-inventario (puerto 8082)
```properties
# Base de datos
spring.datasource.url=jdbc:mysql://localhost:3306/inventario?useSSL=false&serverTimezone=America/Guayaquil&allowPublicKeyRetrieval=true
spring.datasource.username=admin
spring.datasource.password=admin
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# JPA
spring.jpa.hibernate.ddl-auto=validate
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect
spring.jpa.properties.hibernate.format_sql=true

# HikariCP
spring.datasource.hikari.maximum-pool-size=50
spring.datasource.hikari.minimum-idle=10
spring.datasource.hikari.connection-timeout=60000
spring.datasource.hikari.idle-timeout=300000
spring.datasource.hikari.max-lifetime=600000
```

#### msvc-ventas (puerto 8083)
```properties
# Base de datos
spring.datasource.url=jdbc:mysql://localhost:3306/ventas?useSSL=false&serverTimezone=America/Guayaquil&allowPublicKeyRetrieval=true
spring.datasource.username=admin
spring.datasource.password=admin
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# JPA
spring.jpa.hibernate.ddl-auto=validate
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect
spring.jpa.properties.hibernate.format_sql=true

# HikariCP
spring.datasource.hikari.maximum-pool-size=50
spring.datasource.hikari.minimum-idle=10
spring.datasource.hikari.connection-timeout=60000
spring.datasource.hikari.idle-timeout=300000
spring.datasource.hikari.max-lifetime=600000
```

### Paso 2: Actualizar `pom.xml`

Asegúrate de tener el driver de MySQL en todos los microservicios:

```xml
<dependency>
    <groupId>com.mysql</groupId>
    <artifactId>mysql-connector-j</artifactId>
    <scope>runtime</scope>
</dependency>
```

Si usabas PostgreSQL, **ELIMINA** esta dependencia:
```xml
<!-- ELIMINAR -->
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <scope>runtime</scope>
</dependency>
```

## 🔧 Actualizar Entidades JPA

### msvc-auth: Crear entidad Emprendedor

```java
@Entity
@Table(name = "emprendedores")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Emprendedor {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @OneToOne
    @JoinColumn(name = "usuario_id", nullable = false, unique = true)
    private Usuario usuario;
    
    @Column(name = "empresa_id")
    private Long empresaId;
    
    @Column(columnDefinition = "TEXT")
    private String descripcion;
    
    @Column(nullable = false)
    private Boolean activo = true;
    
    @Column(name = "fecha_creacion", updatable = false)
    private LocalDateTime fechaCreacion;
    
    @Column(name = "fecha_actualizacion")
    private LocalDateTime fechaActualizacion;
    
    @PrePersist
    protected void onCreate() {
        fechaCreacion = LocalDateTime.now();
        fechaActualizacion = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        fechaActualizacion = LocalDateTime.now();
    }
}
```

### msvc-producto: Actualizar entidad Producto

Agregar campo:
```java
@Column(name = "emprendedor_id", nullable = false)
private Long emprendedorId;
```

### msvc-ventas: Actualizar entidades Venta y DetalleVenta

**Venta:**
```java
@Column(name = "emprendedor_id", nullable = false)
private Long emprendedorId;
```

**DetalleVenta:**
```java
@Column(name = "emprendedor_id", nullable = false)
private Long emprendedorId;
```

**Crear nueva entidad Pago:**
```java
@Entity
@Table(name = "pagos")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Pago {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "venta_id", nullable = false)
    private Venta venta;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "metodo_pago", nullable = false)
    private MetodoPago metodoPago;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "estado_pago", nullable = false)
    private EstadoPago estadoPago = EstadoPago.PENDIENTE;
    
    private String banco;
    
    @Column(name = "numero_cuenta")
    private String numeroCuenta;
    
    @Column(name = "titular_cuenta")
    private String titularCuenta;
    
    @Column(name = "numero_transaccion")
    private String numeroTransaccion;
    
    @Column(name = "numero_tarjeta_parcial")
    private String numeroTarjetaParcial;
    
    @Column(name = "qr_code", columnDefinition = "TEXT")
    private String qrCode;
    
    @Column(nullable = false)
    private BigDecimal monto;
    
    @Column(name = "fecha_pago")
    private LocalDateTime fechaPago;
    
    @Column(name = "fecha_creacion", updatable = false)
    private LocalDateTime fechaCreacion;
    
    @Column(name = "fecha_actualizacion")
    private LocalDateTime fechaActualizacion;
    
    @PrePersist
    protected void onCreate() {
        fechaCreacion = LocalDateTime.now();
        fechaActualizacion = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        fechaActualizacion = LocalDateTime.now();
    }
}

enum MetodoPago {
    TRANSFERENCIA, TARJETA, DEUNA
}

enum EstadoPago {
    PENDIENTE, PROCESANDO, APROBADO, RECHAZADO
}
```

## 🎯 Probar la Configuración

### 1. Conectarse a MySQL

```bash
# Desde terminal
mysql -h localhost -P 3306 -u admin -padmin

# O usando Docker
docker exec -it mysql-feria-digital mysql -u admin -padmin
```

### 2. Verificar bases de datos

```sql
SHOW DATABASES;
USE auth_service;
SHOW TABLES;
SELECT COUNT(*) FROM usuarios;
SELECT COUNT(*) FROM emprendedores;

USE productos;
SELECT COUNT(*) FROM productos;
SELECT * FROM productos LIMIT 5;

USE inventario;
SELECT COUNT(*) FROM inventarios;

USE ventas;
SELECT COUNT(*) FROM clientes;
```

### 3. Iniciar Microservicios

```powershell
cd Microservicios
.\start-all-services.ps1
```

Verificar que todos los servicios se registren en Eureka:
- http://localhost:8761

## 📝 Comandos Docker Útiles

```powershell
# Ver logs en tiempo real
docker logs -f mysql-feria-digital

# Detener el contenedor
docker-compose down

# Detener y eliminar volúmenes (BORRA TODOS LOS DATOS)
docker-compose down -v

# Reiniciar el contenedor
docker-compose restart

# Ver información del contenedor
docker inspect mysql-feria-digital

# Ejecutar comandos SQL
docker exec -it mysql-feria-digital mysql -u admin -padmin -e "SHOW DATABASES;"
```

## 🔍 Solución de Problemas

### Problema: "Can't connect to MySQL server"

**Solución:**
```powershell
# Verificar que el contenedor está corriendo
docker ps

# Si no está, iniciarlo
docker-compose up -d

# Esperar 10-15 segundos para que MySQL inicie completamente
Start-Sleep -Seconds 15
```

### Problema: "Access denied for user 'admin'"

**Solución:**
Verifica que las credenciales en `application.properties` sean:
- username: `admin`
- password: `admin`

### Problema: "Unknown database 'auth_service'"

**Solución:**
Las bases de datos se crean automáticamente al iniciar el contenedor por primera vez. Si no existen:

```powershell
# Eliminar contenedor y volumen
docker-compose down -v

# Volver a crear
docker-compose up -d
```

### Problema: "Table doesn't exist"

**Solución:**
Verifica que `spring.jpa.hibernate.ddl-auto=validate` en `application.properties`. Si las tablas no existen, cambia temporalmente a `create` para la primera ejecución:

```properties
spring.jpa.hibernate.ddl-auto=create
```

**⚠️ IMPORTANTE:** Después de la primera ejecución, cambia de vuelta a `validate` para evitar perder datos.

## 📊 Estructura de Carpetas

```
TrabajoTitulacion-main/
├── docker-compose.yml
├── iniciar-mysql.ps1
├── scripts/
│   └── mysql-init/
│       ├── 01-create-databases.sql
│       ├── 02-schema-auth-service.sql
│       ├── 03-schema-productos.sql
│       ├── 04-schema-inventario.sql
│       ├── 05-schema-ventas.sql
│       ├── 06-seed-auth-service.sql
│       ├── 07-seed-productos.sql
│       ├── 08-seed-inventario.sql
│       └── 09-seed-ventas.sql
└── Microservicios/
    ├── msvc-auth/
    ├── msvc-producto/
    ├── msvc-inventario/
    └── msvc-ventas/
```

## ✅ Checklist de Configuración

- [ ] Docker Desktop instalado y corriendo
- [ ] Ejecutar `.\iniciar-mysql.ps1`
- [ ] Verificar que MySQL está activo con `docker ps`
- [ ] Actualizar `application.properties` en todos los microservicios
- [ ] Actualizar `pom.xml` con driver de MySQL
- [ ] Crear entidad `Emprendedor` en msvc-auth
- [ ] Agregar campo `emprendedorId` en `Producto`
- [ ] Agregar campo `emprendedorId` en `Venta` y `DetalleVenta`
- [ ] Crear entidad `Pago` en msvc-ventas
- [ ] Iniciar microservicios
- [ ] Probar login con usuarios de prueba
- [ ] Probar creación de producto
- [ ] Probar flujo de compra completo

---

**Fecha de creación:** 23 de Noviembre de 2025  
**Versión:** 3.0 - MySQL en Docker  
**Base de Datos:** MySQL 8.0
