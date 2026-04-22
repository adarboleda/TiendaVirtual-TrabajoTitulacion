# Documentación del Proceso BPM - Gestión Completa de Ventas

## Fecha: Febrero 2026
## Motor BPM: Camunda 7.20.0
## Microservicio: msvc-ventas (Puerto 8083)

---

## 📋 Resumen Ejecutivo

Este documento describe la implementación del proceso de negocio **"Gestión Completa de Venta"** utilizando el motor BPM Camunda. El proceso orquesta la interacción entre los microservicios de productos, inventario y ventas para garantizar transacciones consistentes y confiables.

### Objetivos del Proceso

1. **Automatización**: Orquestar automáticamente todas las etapas de una venta
2. **Validación**: Verificar productos e inventario antes de crear la venta
3. **Consistencia**: Garantizar transacciones ACID a través de múltiples microservicios
4. **Compensación**: Revertir cambios en caso de errores (Saga Pattern)
5. **Trazabilidad**: Registrar cada paso del proceso para auditoría

---

## 🏗️ Arquitectura del Proceso

### Microservicios Involucrados

| Microservicio | Puerto | Rol en el Proceso |
|--------------|--------|-------------------|
| **msvc-ventas** | 8083 | Motor BPM, creación de ventas, facturas |
| **msvc-producto** | 8081 | Validación de productos |
| **msvc-inventario** | 8082 | Verificación y actualización de stock |

### Patrón de Diseño

- **Saga Pattern (Orquestación)**: El proceso BPM actúa como orquestador central
- **Compensating Transactions**: Tareas de reversión en caso de error
- **Circuit Breaker**: Implementado en Feign Clients para resiliencia

---

## 📊 Diagrama del Proceso BPMN

```
[Inicio] 
   ↓
[Validar Productos] 
   ↓
{¿Productos Válidos?}
   ↓ Sí                    ↓ No
[Verificar Stock]      [Cancelar Venta] → [Fin Error]
   ↓
{¿Stock Disponible?}
   ↓ Sí                    ↓ No
[Crear Venta]          [Cancelar Venta] → [Fin Error]
   ↓
[Procesar Pago]
   ↓
{¿Pago Exitoso?}
   ↓ Sí                    ↓ No
[Actualizar Stock]     [Revertir Venta] → [Fin Error]
   ↓
[Generar Factura]
   ↓
[Enviar Notificación]
   ↓
[Venta Completada] → [Fin Exitoso]
```

---

## 🔄 Flujo Detallado del Proceso

### 1. Inicio del Proceso

**Evento**: `StartEvent_1`
- **Trigger**: Llamada REST a `/api/bpm/ventas/iniciar`
- **Variables de Entrada**:
  ```json
  {
    "clienteId": 1,
    "items": [
      {
        "productoId": 1,
        "cantidad": 2
      }
    ],
    "metodoPago": "TARJETA"
  }
  ```

---

### 2. Validar Productos

**Tarea**: `Task_ValidarProductos`
- **Tipo**: Service Task
- **Delegate**: `ValidarProductosDelegate`
- **Responsabilidad**: Verificar que todos los productos existen y están activos
- **Llamadas**:
  - `GET /api/productos/{id}` por cada producto
- **Variables de Salida**:
  - `productosValidos` (boolean)
  - `mensajeValidacion` (String)

**Lógica**:
```java
for (item : items) {
    producto = productoClient.obtenerProducto(item.productoId);
    if (producto == null || !producto.activo) {
        productosValidos = false;
    }
}
```

---

### 3. Gateway: ¿Productos Válidos?

**Gateway**: `Gateway_ProductosValidos`
- **Tipo**: Exclusive Gateway
- **Condición Sí**: `${productosValidos == true}` → Continúa a verificar stock
- **Condición No**: `${productosValidos == false}` → Va a cancelación

---

### 4. Verificar Inventario

**Tarea**: `Task_VerificarInventario`
- **Tipo**: Service Task
- **Delegate**: `VerificarInventarioDelegate`
- **Responsabilidad**: Verificar disponibilidad de stock para todos los productos
- **Llamadas**:
  - `GET /api/inventarios/producto/{productoId}` por cada producto
- **Variables de Salida**:
  - `stockDisponible` (boolean)
  - `mensajeInventario` (String)

**Lógica**:
```java
for (item : items) {
    inventario = inventarioClient.obtenerInventarioPorProductoId(item.productoId);
    if (inventario.cantidadDisponible < item.cantidad) {
        stockDisponible = false;
    }
}
```

---

### 5. Gateway: ¿Stock Disponible?

**Gateway**: `Gateway_StockDisponible`
- **Tipo**: Exclusive Gateway
- **Condición Sí**: `${stockDisponible == true}` → Continúa a crear venta
- **Condición No**: `${stockDisponible == false}` → Va a cancelación

---

### 6. Crear Venta

**Tarea**: `Task_CrearVenta`
- **Tipo**: Service Task
- **Delegate**: `CrearVentaDelegate`
- **Responsabilidad**: Persistir la venta en la base de datos
- **Operaciones**:
  1. Crear entidad `Venta` con estado PENDIENTE
  2. Crear `VentaDetalle` para cada producto
  3. Calcular subtotal, impuesto y total
  4. Generar número de factura único
- **Variables de Salida**:
  - `ventaId` (Long)
  - `numeroFactura` (String)
  - `totalVenta` (BigDecimal)
  - `ventaCreada` (boolean)

**SQL Generado**:
```sql
INSERT INTO ventas (cliente_id, subtotal, impuesto, total, estado, ...) VALUES (...);
INSERT INTO venta_detalles (venta_id, producto_id, cantidad, ...) VALUES (...);
```

---

### 7. Procesar Pago

**Tarea**: `Task_ProcesarPago`
- **Tipo**: Service Task
- **Delegate**: `ProcesarPagoDelegate`
- **Responsabilidad**: Procesar el pago según el método seleccionado
- **Métodos Soportados**:
  - `TARJETA`: Integración con Stripe (simulado)
  - `TRANSFERENCIA`: Validación de transferencia bancaria
  - `DEUNA`: Gateway de pago DEUNA
- **Variables de Salida**:
  - `pagoExitoso` (boolean)
  - `transaccionId` (String)
  - `mensajePago` (String)

**Nota**: En esta versión, el procesamiento de pago está simulado. En producción, se integraría con APIs reales.

---

### 8. Gateway: ¿Pago Exitoso?

**Gateway**: `Gateway_PagoExitoso`
- **Tipo**: Exclusive Gateway
- **Condición Sí**: `${pagoExitoso == true}` → Continúa a actualizar stock
- **Condición No**: `${pagoExitoso == false}` → Va a reversión

---

### 9. Actualizar Inventario

**Tarea**: `Task_ActualizarInventario`
- **Tipo**: Service Task
- **Delegate**: `ActualizarInventarioDelegate`
- **Responsabilidad**: Descontar el stock vendido del inventario
- **Llamadas**:
  - `PUT /api/inventarios/producto/{productoId}/stock` por cada producto
- **Parámetros**:
  - `cantidad`: -N (negativo para descuento)
  - `tipoMovimiento`: "VENTA"
  - `motivo`: "Venta ID: {ventaId}"
- **Variables de Salida**:
  - `inventarioActualizado` (boolean)

**SQL Generado (en msvc-inventario)**:
```sql
UPDATE inventarios SET cantidad_disponible = cantidad_disponible - N WHERE producto_id = X;
INSERT INTO movimientos_inventario (...) VALUES (...);
```

---

### 10. Generar Factura

**Tarea**: `Task_GenerarFactura`
- **Tipo**: Service Task
- **Delegate**: `GenerarFacturaDelegate`
- **Responsabilidad**: Generar PDF de factura
- **Operaciones**:
  1. Obtener datos de la venta
  2. Generar PDF con iText7
  3. Guardar archivo en `facturas/FACT-{id}.pdf`
- **Variables de Salida**:
  - `facturaGenerada` (boolean)
  - `facturaTamanio` (int)

**Estructura del PDF**:
- Logo de Siachos
- Datos del cliente
- Detalles de productos
- Subtotal, impuesto, total
- Número de factura y fecha

---

### 11. Enviar Notificación

**Tarea**: `Task_EnviarNotificacion`
- **Tipo**: Service Task
- **Delegate**: `EnviarNotificacionDelegate`
- **Responsabilidad**: Notificar al cliente sobre la venta completada
- **Canales** (simulados):
  - Email con factura adjunta
  - SMS con número de orden
- **Variables de Salida**:
  - `notificacionEnviada` (boolean)

**Nota**: En producción, se integraría con servicios de email (SendGrid, SES) y SMS (Twilio).

---

### 12. Fin Exitoso

**Evento**: `EndEvent_Exitoso`
- **Nombre**: "Venta Completada"
- **Estado Final**: Proceso termina exitosamente
- **Estado de Venta**: Actualizado a COMPLETADO

---

## ❌ Flujos de Error y Compensación

### Camino de Error 1: Productos Inválidos

**Flujo**: `Gateway_ProductosValidos` → `Task_CancelarVentaProductos` → `EndEvent_ErrorProductos`

**Tarea de Cancelación**: `CancelarVentaDelegate`
- No se crea ninguna venta
- Se registra el motivo en logs
- Se retorna error al cliente

**Código de Error**: `PRODUCTOS_INVALIDOS`

---

### Camino de Error 2: Stock Insuficiente

**Flujo**: `Gateway_StockDisponible` → `Task_CancelarVentaStock` → `EndEvent_ErrorStock`

**Tarea de Cancelación**: `CancelarVentaDelegate`
- No se crea ninguna venta
- Se registra productos con stock insuficiente
- Se retorna error detallado

**Código de Error**: `STOCK_INSUFICIENTE`

---

### Camino de Error 3: Pago Fallido (Compensación)

**Flujo**: `Gateway_PagoExitoso` → `Task_RevertirVenta` → `EndEvent_ErrorPago`

**Tarea de Reversión**: `RevertirVentaDelegate`
- **Acción**: Cancelar la venta creada
- **SQL**: `UPDATE ventas SET estado = 'CANCELADO' WHERE id = ?`
- **Importante**: El inventario NO ha sido descontado aún, por lo que no requiere reversión

**Código de Error**: `PAGO_FALLIDO`

**Patrón Saga**:
```
[Crear Venta] ✅
    ↓
[Procesar Pago] ❌
    ↓
[Compensar: Cancelar Venta] ✅
```

---

## 🔧 Configuración Técnica

### Dependencias Maven

```xml
<dependency>
    <groupId>org.camunda.bpm.springboot</groupId>
    <artifactId>camunda-bpm-spring-boot-starter-rest</artifactId>
    <version>7.20.0</version>
</dependency>
<dependency>
    <groupId>org.camunda.bpm.springboot</groupId>
    <artifactId>camunda-bpm-spring-boot-starter-webapp</artifactId>
    <version>7.20.0</version>
</dependency>
```

### Configuración (application.properties)

```properties
# Camunda BPM Admin User
camunda.bpm.admin-user.id=admin
camunda.bpm.admin-user.password=admin
camunda.bpm.admin-user.firstName=Admin
camunda.bpm.admin-user.lastName=User
camunda.bpm.admin-user.email=admin@siachos.com

# Camunda Settings
camunda.bpm.filter.create=All tasks
camunda.bpm.auto-deployment-enabled=true
camunda.bpm.deployment-resource-pattern=classpath*:**/*.bpmn
camunda.bpm.database.schema-update=true
camunda.bpm.history-level=full
camunda.bpm.id-generator=strong
camunda.bpm.job-execution.enabled=true
camunda.bpm.job-execution.deployment-aware=true
```

### Ubicación del Archivo BPMN

```
src/main/resources/processes/proceso-venta-completa.bpmn
```

El proceso se despliega automáticamente al iniciar el microservicio.

---

## 📡 API REST del Proceso

### 1. Iniciar Proceso de Venta

**Endpoint**: `POST /api/bpm/ventas/iniciar`

**Request Body**:
```json
{
  "clienteId": 1,
  "items": [
    {
      "productoId": 1,
      "cantidad": 2
    },
    {
      "productoId": 2,
      "cantidad": 1
    }
  ],
  "metodoPago": "TARJETA"
}
```

**Response Exitosa**:
```json
{
  "success": true,
  "processInstanceId": "abc123-456-def",
  "processDefinitionId": "proceso-venta-completa:1:xyz789",
  "estadoProceso": "COMPLETADO",
  "mensaje": "Proceso de venta iniciado exitosamente",
  "ventaId": 38,
  "numeroFactura": "FACT-1769990676627",
  "total": 34.50
}
```

**Response con Error**:
```json
{
  "success": true,
  "processInstanceId": "def456-789-ghi",
  "estadoProceso": "CANCELADO",
  "mensaje": "Proceso de venta iniciado exitosamente",
  "motivo": "Stock insuficiente: Producto ID 1: solicitado=10000, disponible=50"
}
```

---

### 2. Consultar Estado de Proceso

**Endpoint**: `GET /api/bpm/ventas/proceso/{processInstanceId}`

**Response**:
```json
{
  "existe": true,
  "processInstanceId": "abc123-456-def",
  "activo": false,
  "suspendido": false,
  "variables": {
    "clienteId": 1,
    "ventaId": 38,
    "productosValidos": true,
    "stockDisponible": true,
    "pagoExitoso": true,
    "ventaCreada": true
  }
}
```

---

### 3. Listar Procesos Activos

**Endpoint**: `GET /api/bpm/ventas/procesos-activos`

**Response**:
```json
{
  "totalProcesos": 2,
  "procesos": [
    {
      "processInstanceId": "abc123-456-def",
      "businessKey": null,
      "suspendido": false
    },
    {
      "processInstanceId": "ghi789-012-jkl",
      "businessKey": null,
      "suspendido": false
    }
  ]
}
```

---

## 🎯 Camunda Cockpit (Interfaz Web)

### Acceso

**URL**: http://localhost:8083/camunda

**Credenciales**:
- **Usuario**: admin
- **Contraseña**: admin

### Funcionalidades

1. **Dashboard**: Vista general de procesos activos, completados y fallidos
2. **Process Definitions**: Lista de procesos desplegados
3. **Process Instances**: Instancias de procesos en ejecución
4. **Diagrama BPMN**: Visualización gráfica del proceso
5. **Variables**: Inspección de variables de proceso
6. **Incidents**: Errores y excepciones en procesos
7. **History**: Auditoría completa de ejecuciones pasadas

---

## 🧪 Pruebas del Proceso

### Script de Prueba Automatizado

Ejecutar: `.\prueba-proceso-bpm.ps1`

**Casos de Prueba**:

1. ✅ **Venta Exitosa**: Producto válido, stock suficiente, pago exitoso
2. ❌ **Producto Inexistente**: Debe fallar en validación
3. ❌ **Stock Insuficiente**: Debe fallar en verificación de inventario
4. ✅ **Venta Múltiple**: Varios productos en una sola venta
5. ℹ️ **Listar Procesos**: Consultar procesos activos

### Prueba Manual con cURL

```bash
curl -X POST http://localhost:8083/api/bpm/ventas/iniciar \
  -H "Content-Type: application/json" \
  -d '{
    "clienteId": 1,
    "items": [{"productoId": 1, "cantidad": 2}],
    "metodoPago": "TARJETA"
  }'
```

---

## 📊 Métricas y Monitoreo

### Logs del Proceso

Cada tarea registra logs estructurados:

```
2026-02-01 19:04:30 INFO  [proceso-venta-completa] === INICIANDO: Validación de Productos ===
2026-02-01 19:04:30 INFO  [ValidarProductosDelegate] Validación de productos: EXITOSA
2026-02-01 19:04:31 INFO  [proceso-venta-completa] === INICIANDO: Verificación de Inventario ===
2026-02-01 19:04:31 INFO  [VerificarInventarioDelegate] Verificación de inventario: EXITOSA
2026-02-01 19:04:32 INFO  [proceso-venta-completa] === INICIANDO: Creación de Venta ===
2026-02-01 19:04:33 INFO  [CrearVentaDelegate] Venta creada exitosamente: ID=38, Factura=FACT-1769990676627
...
```

### Variables de Proceso (Auditoría)

Todas las variables se almacenan en la tabla `ACT_RU_VARIABLE` de Camunda:

- `clienteId`
- `items`
- `metodoPago`
- `productosValidos`
- `stockDisponible`
- `ventaId`
- `pagoExitoso`
- `inventarioActualizado`
- `facturaGenerada`
- `notificacionEnviada`

---

## 🔒 Consideraciones de Seguridad

1. **Autenticación**: Camunda Cockpit protegido con credenciales
2. **Autorización**: Solo usuarios autenticados pueden iniciar procesos
3. **Validación**: Todas las entradas validadas con Bean Validation
4. **Transacciones**: Cada tarea ejecuta en transacción separada
5. **Rollback**: Compensación automática en caso de error

---

## 🚀 Mejoras Futuras

### Corto Plazo

1. **Integración Real de Pagos**: Conectar con Stripe API
2. **Notificaciones Reales**: SendGrid para emails, Twilio para SMS
3. **Retry Logic**: Reintentos automáticos en tareas críticas
4. **Timeouts**: Configurar tiempos máximos de ejecución

### Mediano Plazo

1. **Procesos Paralelos**: Ejecutar validación y verificación en paralelo
2. **Escalabilidad**: Cluster de Camunda con múltiples nodos
3. **Métricas Avanzadas**: Integración con Prometheus/Grafana
4. **Alertas**: Notificaciones automáticas de procesos fallidos

### Largo Plazo

1. **IA/ML**: Predicción de fallos en procesos
2. **Optimización**: Análisis de cuellos de botella
3. **Multi-tenancy**: Soporte para múltiples empresas

---

## 📚 Referencias

- **Camunda Documentation**: https://docs.camunda.org/
- **BPMN 2.0 Specification**: https://www.omg.org/spec/BPMN/2.0/
- **Saga Pattern**: https://microservices.io/patterns/data/saga.html
- **Spring Boot Camunda**: https://docs.camunda.org/manual/latest/user-guide/spring-boot-integration/

---

## 👥 Equipo de Desarrollo

**Autor**: Proyecto de Titulación  
**Fecha**: Febrero 2026  
**Versión**: 1.0

---

## Anexo: Variables del Proceso Completo

| Variable | Tipo | Descripción | Origen |
|----------|------|-------------|--------|
| `clienteId` | Long | ID del cliente | Input |
| `items` | List<Map> | Lista de productos a comprar | Input |
| `metodoPago` | String | TARJETA/TRANSFERENCIA/DEUNA | Input |
| `productosValidos` | Boolean | Resultado de validación | ValidarProductosDelegate |
| `mensajeValidacion` | String | Detalle de validación | ValidarProductosDelegate |
| `stockDisponible` | Boolean | Hay stock suficiente | VerificarInventarioDelegate |
| `mensajeInventario` | String | Detalle de stock | VerificarInventarioDelegate |
| `ventaId` | Long | ID de venta creada | CrearVentaDelegate |
| `numeroFactura` | String | Número de factura | CrearVentaDelegate |
| `totalVenta` | BigDecimal | Monto total | CrearVentaDelegate |
| `ventaCreada` | Boolean | Venta persistida | CrearVentaDelegate |
| `pagoExitoso` | Boolean | Pago completado | ProcesarPagoDelegate |
| `transaccionId` | String | ID de transacción de pago | ProcesarPagoDelegate |
| `mensajePago` | String | Detalle del pago | ProcesarPagoDelegate |
| `inventarioActualizado` | Boolean | Stock descontado | ActualizarInventarioDelegate |
| `facturaGenerada` | Boolean | PDF creado | GenerarFacturaDelegate |
| `facturaTamanio` | Integer | Bytes del PDF | GenerarFacturaDelegate |
| `notificacionEnviada` | Boolean | Email/SMS enviado | EnviarNotificacionDelegate |
| `ventaCancelada` | Boolean | Proceso cancelado | CancelarVentaDelegate |
| `motivoCancelacion` | String | Razón de cancelación | CancelarVentaDelegate |
| `ventaRevertida` | Boolean | Compensación ejecutada | RevertirVentaDelegate |
| `motivoReversion` | String | Razón de reversión | RevertirVentaDelegate |

---

**FIN DEL DOCUMENTO**
