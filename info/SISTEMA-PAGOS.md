# Sistema de Pagos con Aprobación de Emprendedor

## 🎯 Flujo de Pago Actualizado

### Métodos de Pago Disponibles

1. **TARJETA** (Simulado)
   - El cliente ingresa datos de tarjeta
   - Se simula el procesamiento del pago
   - Estado inicial: PENDIENTE
   - **Requiere aprobación del emprendedor**

2. **TRANSFERENCIA**
   - El cliente sube comprobante de transferencia
   - Estado inicial: PENDIENTE
   - **Requiere aprobación del emprendedor**

3. **DEUNA** (Simulado)
   - Procesamiento simulado de pago
   - Estado inicial: PENDIENTE
   - **Requiere aprobación del emprendedor**

### Estados del Pago

- **PENDIENTE**: Pago creado, esperando aprobación
- **PROCESANDO**: (Futuro) Pago en verificación automática
- **APROBADO**: Emprendedor aprobó el pago → Venta COMPLETADA
- **RECHAZADO**: Emprendedor rechazó el pago → Venta CANCELADA

---

## 🏗️ Arquitectura Backend

### Entidad PagoEntity

```java
@Entity
@Table(name = "pagos")
public class PagoEntity {
    private Long id;
    private VentaEntity venta;
    private BigDecimal monto;
    private MetodoPago metodoPago; // TRANSFERENCIA, TARJETA, DEUNA
    private EstadoPago estadoPago; // PENDIENTE, PROCESANDO, APROBADO, RECHAZADO
    private String referenciaTransaccion;
    private String comprobanteUrl;
    private LocalDateTime fechaPago;
    private LocalDateTime fechaCreacion;
    private LocalDateTime fechaActualizacion;
}
```

### PagoRepository

```java
@Repository
public interface PagoRepository extends JpaRepository<PagoEntity, Long> {
    Optional<PagoEntity> findByVentaId(Long ventaId);
    List<PagoEntity> findByEstadoPago(EstadoPago estadoPago);
    
    @Query("SELECT p FROM PagoEntity p JOIN p.venta v WHERE v.emprendedorId = :emprendedorId")
    List<PagoEntity> findByEmprendedorId(@Param("emprendedorId") Long emprendedorId);
    
    @Query("SELECT p FROM PagoEntity p JOIN p.venta v 
            WHERE v.emprendedorId = :emprendedorId AND p.estadoPago = :estadoPago")
    List<PagoEntity> findByEmprendedorIdAndEstadoPago(
        @Param("emprendedorId") Long emprendedorId, 
        @Param("estadoPago") EstadoPago estadoPago
    );
}
```

### PagoService - Métodos Principales

#### Crear Pago
```java
public PagoEntity crearPago(Long ventaId, MetodoPago metodoPago, String comprobanteUrl) {
    // Crea pago en estado PENDIENTE
    // Asociado a la venta
}
```

#### Aprobar Pago
```java
public PagoEntity aprobarPago(Long pagoId, Long emprendedorId) {
    // Verifica que el pago pertenece al emprendedor
    // Cambia estado a APROBADO
    // Actualiza la venta a COMPLETADA
    // Registra fechaPago
}
```

#### Rechazar Pago
```java
public PagoEntity rechazarPago(Long pagoId, Long emprendedorId) {
    // Verifica que el pago pertenece al emprendedor
    // Cambia estado a RECHAZADO
    // Actualiza la venta a CANCELADA
}
```

---

## 🌐 API Endpoints

### POST /api/pagos
**Crear un nuevo pago**
```json
{
  "ventaId": 1,
  "metodoPago": "TRANSFERENCIA",
  "comprobanteUrl": "https://bucket.s3.com/comprobante.jpg"
}
```

### GET /api/pagos/{id}
**Obtener pago por ID**

### GET /api/pagos/venta/{ventaId}
**Obtener pago de una venta**

### POST /api/pagos/{id}/aprobar
**Aprobar pago (solo emprendedor)**
```json
{
  "emprendedorId": 1,
  "observaciones": "Comprobante verificado"
}
```

### POST /api/pagos/{id}/rechazar
**Rechazar pago (solo emprendedor)**
```json
{
  "emprendedorId": 1,
  "observaciones": "Comprobante no válido"
}
```

### POST /api/pagos/{id}/comprobante
**Subir comprobante (cliente)**
```json
{
  "comprobanteUrl": "https://bucket.s3.com/comprobante2.jpg"
}
```

### GET /api/pagos/emprendedor/{emprendedorId}/pendientes
**Listar pagos pendientes del emprendedor**

### GET /api/pagos/emprendedor/{emprendedorId}
**Listar todos los pagos del emprendedor**

### GET /api/pagos/estado/{estado}
**Listar pagos por estado**

---

## 💻 Frontend

### Servicio de Pagos (pagoService.ts)

```typescript
export const aprobarPago = async (pagoId: number, request: AprobarPagoRequest): Promise<PagoResponse> => {
    const response = await fetch(`${API_BASE_URL}/pagos/${pagoId}/aprobar`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(request),
    });
    return response.json();
};

export const procesarPagoSimulado = async (metodoPago: 'TARJETA' | 'DEUNA'): Promise<{
    success: boolean;
    transactionId: string;
    message: string;
}> => {
    await new Promise(resolve => setTimeout(resolve, 1500));
    return {
        success: true,
        transactionId: `${metodoPago}_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
        message: `Pago con ${metodoPago} procesado exitosamente (simulado)`
    };
};
```

### Componente de Gestión de Pagos

**Ruta**: `/emprendedor/pagos`

**Componente**: `PagosEmprendedor.tsx`

**Funcionalidades**:
- ✅ Lista de pagos pendientes con badge de contador
- ✅ Tabla de historial completo de pagos
- ✅ Botones de aprobar/rechazar
- ✅ Ver comprobantes de transferencia
- ✅ Dialog de confirmación
- ✅ Toast notifications
- ✅ Filtrado por emprendedor automático
- ✅ Actualización automática después de acciones

---

## 🔄 Flujo Completo de Compra

### 1. Cliente Crea Orden
```typescript
const ventaRequest = {
    clienteId: 1,
    items: [{ productoId: 5, cantidad: 2 }],
    metodoPago: 'TRANSFERENCIA',
    comprobanteUrl: 'https://...'
};
```

### 2. Backend Crea Venta y Pago
```java
// VentaApplicationService.crearVenta()
Venta ventaCreada = ventaService.crearVenta(venta);
PagoEntity pago = pagoService.crearPago(ventaCreada.getId(), metodoPago, comprobanteUrl);
// Estado: Venta = PENDIENTE, Pago = PENDIENTE
```

### 3. Emprendedor Revisa Pago
- Accede a `/emprendedor/pagos`
- Ve lista de pagos pendientes
- Puede ver comprobante (si es transferencia)

### 4. Emprendedor Aprueba/Rechaza

#### Si APRUEBA:
```java
pagoService.aprobarPago(pagoId, emprendedorId);
// Pago → APROBADO
// Venta → COMPLETADA
// Se registra fechaPago
```

#### Si RECHAZA:
```java
pagoService.rechazarPago(pagoId, emprendedorId);
// Pago → RECHAZADO
// Venta → CANCELADA
```

---

## 📋 Cambios en VentaRequestDto

```java
public class VentaRequestDto {
    private Long clienteId;
    private List<VentaItemRequestDto> items;
    
    @NotNull(message = "El método de pago es obligatorio")
    private String metodoPago; // TRANSFERENCIA, TARJETA, DEUNA
    
    private String comprobanteUrl; // Opcional, requerido solo para TRANSFERENCIA
}
```

---

## ✅ Validaciones Implementadas

1. **Verificar Propiedad del Pago**
   - Solo el emprendedor dueño del producto puede aprobar/rechazar
   ```java
   if (!pago.getVenta().getEmprendedorId().equals(emprendedorId)) {
       throw new IllegalStateException("El pago no pertenece a este emprendedor");
   }
   ```

2. **Validar Estado del Pago**
   - Solo se pueden aprobar/rechazar pagos en estado PENDIENTE
   ```java
   if (pago.getEstadoPago() != EstadoPago.PENDIENTE) {
       throw new IllegalStateException("Solo se pueden aprobar pagos en estado PENDIENTE");
   }
   ```

3. **Validar Método de Pago para Comprobante**
   - Solo transferencias pueden subir comprobante
   ```java
   if (pago.getMetodoPago() != MetodoPago.TRANSFERENCIA) {
       throw new IllegalStateException("Solo se puede subir comprobante para pagos por transferencia");
   }
   ```

---

## 🎨 Componentes UI

### PagosEmprendedor.tsx

**Features**:
- DataTable con pagos pendientes
- DataTable con historial completo
- Iconos por método de pago
- Tags de colores por estado
- Botones de acción
- Dialog de confirmación
- Toast para feedback

**Templates Personalizados**:
```typescript
const metodoPagoTemplate = (rowData) => {
    const config = {
        TRANSFERENCIA: { icon: 'pi-money-bill', color: 'info' },
        TARJETA: { icon: 'pi-credit-card', color: 'success' },
        DEUNA: { icon: 'pi-wallet', color: 'warning' }
    };
    // ...
};

const estadoPagoTemplate = (rowData) => {
    const config = {
        PENDIENTE: { severity: 'warning' },
        APROBADO: { severity: 'success' },
        RECHAZADO: { severity: 'danger' }
    };
    // ...
};
```

---

## 🔐 Seguridad

1. **Verificación de Propiedad**: Solo el emprendedor dueño puede aprobar/rechazar
2. **Validación de Estados**: Transiciones de estado controladas
3. **Token JWT**: (Futuro) Autenticación en endpoints
4. **CORS**: Configurado para localhost:3000

---

## 📊 Base de Datos

### Tabla pagos

```sql
CREATE TABLE pagos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    venta_id BIGINT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    metodo_pago ENUM('TRANSFERENCIA', 'TARJETA', 'DEUNA') NOT NULL,
    estado_pago ENUM('PENDIENTE', 'PROCESANDO', 'APROBADO', 'RECHAZADO') NOT NULL DEFAULT 'PENDIENTE',
    referencia_transaccion VARCHAR(255),
    comprobante_url TEXT,
    fecha_pago TIMESTAMP NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (venta_id) REFERENCES ventas(id) ON DELETE CASCADE,
    INDEX idx_estado_pago (estado_pago),
    INDEX idx_venta_id (venta_id)
);
```

---

## 🚀 Próximos Pasos

1. **Notificaciones**
   - Email al emprendedor cuando hay pago pendiente
   - Email al cliente cuando pago es aprobado/rechazado

2. **Subida de Archivos**
   - Integrar S3 o storage para comprobantes
   - Validación de formato de imágenes

3. **Dashboard de Estadísticas**
   - Pagos aprobados vs rechazados
   - Tiempo promedio de aprobación
   - Método de pago más usado

4. **Filtros Avanzados**
   - Por rango de fechas
   - Por cliente
   - Por monto

5. **Webhooks**
   - Integración real con DEUNA
   - Callbacks de confirmación automática

---

**Fecha**: 2025-11-23  
**Sistema**: MySQL 8.0 + Spring Boot + Next.js + PrimeReact  
**Estado**: ✅ Implementado y Listo para Pruebas
