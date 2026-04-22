# 🔄 Rediseño de Microservicios - Sistema de Emprendedores

## 📋 Descripción General

Este rediseño transforma el sistema para que **cada producto esté relacionado con un emprendedor específico**, permitiendo que cada emprendedor gestione sus propios productos y vea sus pedidos de manera independiente.

## 🎯 Cambios Principales

### 1. **Base de Datos `auth-service`**
- ✅ **Nueva tabla `emprendedores`**: Vincula usuarios con empresas
- ✅ Relación: `Usuario` → `Emprendedor` → `Empresa`
- ✅ Cada emprendedor tiene un usuario con rol `ROLE_EMP`

### 2. **Base de Datos `productos`**
- ✅ **Nuevo campo `emprendedor_id`** en tabla `productos`
- ✅ Cada producto pertenece a un emprendedor específico
- ✅ Mantiene relación con `empresa_id` y `categoria_id`

### 3. **Base de Datos `inventario`**
- ✅ Mejoras en índices para mejor rendimiento
- ✅ Optimización de consultas con índices en campos clave
- ✅ Pool de conexiones aumentado (50 conexiones)

### 4. **Base de Datos `ventas`**
- ✅ **Nuevo campo `emprendedor_id`** en tabla `ventas`
- ✅ **Nuevo campo `emprendedor_id`** en tabla `detalles_venta`
- ✅ **Nueva tabla `pagos`** con soporte para:
  - 💳 Transferencia Bancaria
  - 💳 Tarjeta de Crédito/Débito
  - 💳 Deuna (QR Code)
- ✅ Estados de pago: PENDIENTE, PROCESANDO, APROBADO, RECHAZADO

## 📁 Estructura de Archivos Creados

```
scripts/
├── nuevo-schema-auth-service.sql      # Schema para auth-service
├── nuevo-schema-productos.sql         # Schema para productos
├── nuevo-schema-inventario.sql        # Schema para inventario
├── nuevo-schema-ventas.sql            # Schema para ventas
├── nuevo-seed-auth-service.sql        # Datos iniciales auth-service
├── nuevo-seed-productos.sql           # Datos iniciales productos
├── nuevo-seed-inventario.sql          # Datos iniciales inventario
├── nuevo-seed-ventas.sql              # Datos iniciales ventas
├── recrear-bases-datos-completo.sql   # Script maestro SQL
└── ejecutar-recreacion-bd.ps1         # Script PowerShell automatizado
```

## 🚀 Instrucciones de Instalación

### Opción 1: Usando Script PowerShell (Recomendado)

```powershell
# 1. Navegar al directorio de scripts
cd C:\Users\mycke\Desktop\TrabajoTitulacion-main\TrabajoTitulacion-main\scripts

# 2. Ejecutar el script
.\ejecutar-recreacion-bd.ps1
```

El script realizará:
1. ✅ Verificación de conexión a PostgreSQL
2. ⚠️ Advertencia y confirmación del usuario
3. 🗑️ Eliminación de bases de datos existentes
4. 🆕 Creación de nuevas bases de datos
5. 📋 Aplicación de schemas
6. 📊 Inserción de datos iniciales

### Opción 2: Manual con psql

```bash
# Conectarse a PostgreSQL
psql -U postgres -h localhost -p 5433

# Ejecutar script maestro
\i recrear-bases-datos-completo.sql
```

## 👥 Datos de Prueba Incluidos

### Usuarios y Emprendedores

| Username | Email | Password | Rol | Empresa |
|----------|-------|----------|-----|---------|
| `admin` | admin@feriadigital.com | `adminpass` | ADMIN | - |
| `ultimo_inca` | contacto@ultimoinca.com | `ultimoinca123` | EMPRENDEDOR | El Último Inca |
| `sigcholac` | sigcholac@gmail.com | `sigcholac123` | EMPRENDEDOR | Sigcholac |
| `perla_andina` | perlaandina@gmail.com | `perlaandina123` | EMPRENDEDOR | Perla Andina |
| `grandes_foods` | info@grandesfoods.com | `grandesfoods123` | EMPRENDEDOR | Grandes Foods |
| `cliente1` | cliente@ejemplo.com | `cliente123` | CLIENTE | - |

### Productos por Emprendedor

- **El Último Inca** (ID: 1): 13 vinos artesanales (mortiño, frambuesa, pitahaya, maracuyá, uva)
- **Sigcholac** (ID: 2): 10 productos lácteos (quesos, yogurt)
- **Perla Andina** (ID: 3): 8 vinos premium (mortiño, mora, frambuesa)
- **Grandes Foods** (ID: 4): 8 productos (lácteos, snacks, cárnicos)

## 🔧 Próximos Pasos (Código Java)

### 1. Actualizar Entidades JPA

#### msvc-auth: Crear entidad `Emprendedor`

```java
@Entity
@Table(name = "emprendedores")
public class Emprendedor {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @OneToOne
    @JoinColumn(name = "usuario_id", nullable = false, unique = true)
    private Usuario usuario;
    
    @Column(name = "empresa_id")
    private Long empresaId;  // Referencia a empresa en microservicio productos
    
    @Column(columnDefinition = "TEXT")
    private String descripcion;
    
    private Boolean activo = true;
    
    @Column(name = "fecha_creacion")
    private LocalDateTime fechaCreacion;
    
    @Column(name = "fecha_actualizacion")
    private LocalDateTime fechaActualizacion;
    
    // Getters y Setters
}
```

#### msvc-producto: Agregar campo `emprendedorId`

```java
@Entity
@Table(name = "productos")
public class Producto {
    // ... campos existentes ...
    
    @Column(name = "emprendedor_id", nullable = false)
    private Long emprendedorId;  // Referencia a emprendedor en auth-service
    
    // Getters y Setters
}
```

#### msvc-ventas: Agregar campo `emprendedorId`

```java
@Entity
@Table(name = "ventas")
public class Venta {
    // ... campos existentes ...
    
    @Column(name = "emprendedor_id", nullable = false)
    private Long emprendedorId;
    
    // Getters y Setters
}

@Entity
@Table(name = "detalles_venta")
public class DetalleVenta {
    // ... campos existentes ...
    
    @Column(name = "emprendedor_id", nullable = false)
    private Long emprendedorId;
    
    // Getters y Setters
}
```

#### msvc-ventas: Crear entidad `Pago`

```java
@Entity
@Table(name = "pagos")
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
    private String numeroCuenta;
    private String titularCuenta;
    private String numeroTransaccion;
    private String numeroTarjetaParcial;
    
    @Column(columnDefinition = "TEXT")
    private String qrCode;
    
    @Column(nullable = false)
    private BigDecimal monto;
    
    private LocalDateTime fechaPago;
    private LocalDateTime fechaCreacion;
    private LocalDateTime fechaActualizacion;
    
    // Getters y Setters
}
```

### 2. Crear Servicios para Emprendedores

#### EmprendedorService (msvc-auth)

```java
public interface EmprendedorService {
    Emprendedor obtenerPorUsuarioId(Long usuarioId);
    Emprendedor obtenerPorId(Long id);
    List<Emprendedor> listarTodos();
    Emprendedor actualizar(Long id, Emprendedor emprendedor);
}
```

#### ProductoService - Agregar método

```java
List<Producto> obtenerProductosPorEmprendedor(Long emprendedorId);
```

#### VentaService - Agregar métodos

```java
List<Venta> obtenerVentasPorEmprendedor(Long emprendedorId);
List<DetalleVenta> obtenerDetallesPorEmprendedor(Long emprendedorId);
BigDecimal calcularTotalVentasPorEmprendedor(Long emprendedorId);
```

### 3. Actualizar DTOs

Agregar campo `emprendedorId` en:
- `ProductoDto` (msvc-producto)
- `VentaRequestDto` y `VentaResponseDto` (msvc-ventas)
- `DetalleVentaDto` (msvc-ventas)
- Crear `PagoDto` para la nueva entidad

### 4. Actualizar Controllers

#### EmprendedorController (msvc-auth)

```java
@RestController
@RequestMapping("/api/emprendedores")
public class EmprendedorController {
    
    @GetMapping("/usuario/{usuarioId}")
    public ResponseEntity<Emprendedor> obtenerPorUsuario(@PathVariable Long usuarioId);
    
    @GetMapping("/{id}")
    public ResponseEntity<Emprendedor> obtenerPorId(@PathVariable Long id);
    
    @GetMapping
    public ResponseEntity<List<Emprendedor>> listarTodos();
}
```

#### ProductoController - Agregar endpoint

```java
@GetMapping("/emprendedor/{emprendedorId}")
public ResponseEntity<List<ProductoDto>> obtenerProductosPorEmprendedor(@PathVariable Long emprendedorId);
```

#### VentaController - Agregar endpoints

```java
@GetMapping("/emprendedor/{emprendedorId}")
public ResponseEntity<List<VentaResponseDto>> obtenerVentasPorEmprendedor(@PathVariable Long emprendedorId);

@GetMapping("/emprendedor/{emprendedorId}/estadisticas")
public ResponseEntity<Map<String, Object>> obtenerEstadisticasEmprendedor(@PathVariable Long emprendedorId);
```

## 🔍 Validaciones Importantes

1. ✅ Al crear un producto, validar que `emprendedorId` existe en auth-service
2. ✅ Al crear una venta, extraer `emprendedorId` de cada producto
3. ✅ Si una venta tiene productos de múltiples emprendedores:
   - Crear múltiples ventas (una por emprendedor), O
   - Dejar `emprendedor_id` en NULL en la venta principal
   - Mantener `emprendedor_id` en cada `detalle_venta`
4. ✅ Validar que un emprendedor solo puede modificar sus propios productos
5. ✅ Validar que un emprendedor solo puede ver sus propias ventas

## 🐛 Solución a Problemas Anteriores

### Problema: Connection Pool Exhaustion

**Causa**: El pool de conexiones (10) era insuficiente para las consultas simultáneas.

**Solución**:
```properties
# application.properties (msvc-inventario y msvc-ventas)
spring.datasource.hikari.maximum-pool-size=50
spring.datasource.hikari.minimum-idle=10
spring.datasource.hikari.connection-timeout=60000
spring.datasource.hikari.idle-timeout=300000
spring.datasource.hikari.max-lifetime=600000
spring.datasource.hikari.leak-detection-threshold=60000
```

### Problema: Datos inconsistentes en ventas

**Causa**: Falta de validación y tracking por emprendedor.

**Solución**:
- Campo `emprendedor_id` en ventas y detalles
- Tabla `pagos` separada con estados claros
- Índices en campos clave para mejor rendimiento

## 📊 Diagrama de Relaciones

```
┌─────────────────────┐
│   auth-service      │
├─────────────────────┤
│ usuarios            │──┐
│ usuario_roles       │  │
│ emprendedores  ←────┘  │ 1:1
│   └─ empresa_id ────┐  │
└─────────────────────┘  │
                         │
                         │ Referencia
                         ↓
┌─────────────────────┐  │
│   productos         │  │
├─────────────────────┤  │
│ categorias          │  │
│ empresas       ←────┘  │
│ productos               │
│   ├─ empresa_id         │
│   └─ emprendedor_id ────┘ Referencia
└─────────────────────┘

┌─────────────────────┐
│   inventario        │
├─────────────────────┤
│ inventarios         │
│   └─ producto_id ───┐ Referencia
│ movimientos         │
└─────────────────────┘

┌─────────────────────┐
│   ventas            │
├─────────────────────┤
│ clientes            │
│ ventas              │
│   └─ emprendedor_id ──┐ Referencia
│ detalles_venta        │
│   ├─ producto_id ─────┘
│   └─ emprendedor_id ───┘
│ pagos               │
│   └─ venta_id       │
└─────────────────────┘
```

## 📞 Soporte

Si encuentras problemas durante la migración:

1. Verifica que PostgreSQL esté corriendo en puerto 5433
2. Asegúrate de que la contraseña sea `tesis123`
3. Revisa los logs de los microservicios después de reiniciarlos
4. Verifica que las entidades JPA coincidan con el nuevo schema

## ✅ Checklist de Implementación

- [x] Crear schemas SQL nuevos
- [x] Crear seeds con datos de prueba
- [x] Crear script maestro de migración
- [x] Crear script PowerShell automatizado
- [ ] Actualizar entidad Emprendedor en msvc-auth
- [ ] Actualizar entidad Producto en msvc-producto
- [ ] Actualizar entidades Venta y DetalleVenta en msvc-ventas
- [ ] Crear entidad Pago en msvc-ventas
- [ ] Actualizar DTOs
- [ ] Crear servicios para consultas por emprendedor
- [ ] Actualizar controllers con nuevos endpoints
- [ ] Actualizar frontend para mostrar productos por emprendedor
- [ ] Actualizar frontend para panel de emprendedor
- [ ] Probar flujo de compra completo
- [ ] Validar métodos de pago (Transferencia, Tarjeta, Deuna)

---

**Fecha de creación**: 21 de Noviembre de 2025  
**Versión**: 2.0  
**Autor**: Sistema de Rediseño Automático
