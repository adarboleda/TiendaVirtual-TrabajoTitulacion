# 📊 Historial de Compras - Documentación

## ✅ Componentes Creados

### 🗄️ Base de Datos

#### 1. **Migración SQL - Información de Pagos**
- **Archivo**: `actualizar-ventas-pagos.sql`
- **Tabla actualizada**: `ventas`
- **Nuevas columnas**:
  - `metodo_pago` VARCHAR(50) - Método: transferencia, tarjeta, deuna
  - `estado_pago` VARCHAR(50) - Estado: PENDIENTE, PROCESANDO, APROBADO, RECHAZADO
  - `comprobante_pago_url` TEXT - URL del comprobante (para transferencias)
  - `referencia_transaccion` VARCHAR(255) - ID o referencia del pago
  - `fecha_pago` TIMESTAMP - Fecha de confirmación del pago
- **Índices creados**:
  - `idx_ventas_cliente` - Para búsquedas rápidas por cliente
  - `idx_ventas_estado_pago` - Para filtrar por estado de pago
- **Script de aplicación**: `aplicar-migracion-ventas-pagos.ps1`

### ☕ Backend (Spring Boot)

#### 2. **Actualización del Modelo Venta**
- **Archivo**: `Microservicios/msvc-ventas/src/main/java/com/example/msvc_ventas/domain/model/Venta.java`
- **Nuevos campos**:
  ```java
  private MetodoPago metodoPago;
  private EstadoPago estadoPago;
  private String comprobantePagoUrl;
  private String referenciaTransaccion;
  private LocalDateTime fechaPago;
  ```
- **Nuevos enums**:
  ```java
  public enum MetodoPago {
      TRANSFERENCIA,
      TARJETA,
      DEUNA
  }
  
  public enum EstadoPago {
      PENDIENTE,
      PROCESANDO,
      APROBADO,
      RECHAZADO
  }
  ```

#### 3. **Actualización de VentaEntity**
- **Archivo**: `Microservicios/msvc-ventas/src/main/java/com/example/msvc_ventas/infrastructure/persistence/entity/VentaEntity.java`
- **Mapeo JPA** de los nuevos campos con anotaciones:
  - `@Enumerated(EnumType.STRING)` para enums
  - Constraints y tipos de columna adecuados

#### 4. **Endpoint Existente** ✅
- **Ya existe**: `GET /api/ventas/cliente/{clienteId}`
- Retorna todas las ventas de un cliente específico
- Incluye detalles de productos
- **Archivo**: `VentaController.java` línea 60

### 🎨 Frontend (React + PrimeReact)

#### 5. **Página de Historial de Compras**
- **Archivo**: `avalon-react-10.1.0/app/(main)/profile/historial-compras/page.tsx`
- **Componentes PrimeReact utilizados**:
  - `DataView` - Lista paginada de compras
  - `Dialog` - Modal con detalle completo
  - `Timeline` - Seguimiento del estado del pedido
  - `Tag` - Badges para estados
  - `Image` - Visualización de comprobantes con preview
  - `Toast` - Notificaciones
  - `ProgressSpinner` - Loading state

#### 6. **Características Principales**:

**Vista de Lista:**
- Card por cada compra con información resumida
- Número de factura
- Fecha de compra
- Estado del pedido (PENDIENTE, COMPLETADA, CANCELADA)
- Estado del pago (PENDIENTE, PROCESANDO, APROBADO, RECHAZADO)
- Método de pago con icono (Transferencia, Tarjeta, Deuna)
- Total con formato de moneda
- Botón "Ver Detalle"
- Paginación (5 compras por página)

**Vista de Detalle (Dialog):**
- **Información General**:
  - Número de factura
  - Fecha de compra
  - Tags de estado del pedido y pago
  
- **Timeline de Seguimiento**:
  - Pedido Realizado
  - Pago Confirmado (si está aprobado)
  - Pedido Completado (si está completado)
  - Iconos y colores diferenciados por etapa
  
- **Información de Pago**:
  - Método de pago con icono
  - Referencia de transacción
  - Comprobante de pago (imagen con preview si existe)
  
- **Lista de Productos**:
  - Nombre del producto
  - Cantidad y precio unitario
  - Subtotal por producto
  
- **Totales**:
  - Subtotal
  - Impuesto (IVA)
  - Total general

#### 7. **Integración con Perfil de Usuario**
- **Archivo actualizado**: `avalon-react-10.1.0/app/(landing)/components/MiCuentaModal.tsx`
- **Cambio realizado**:
  - Agregado botón "Ver Historial de Compras" con gradiente
  - Redirección a `/profile/historial-compras`
  - Divider para separar secciones

### 🎨 Diseño y UX

**Colores por Estado:**
- 🟢 **APROBADO/COMPLETADA**: Verde (`success`)
- 🔵 **PROCESANDO**: Azul (`info`)
- 🟡 **PENDIENTE**: Amarillo (`warning`)
- 🔴 **RECHAZADO/CANCELADA**: Rojo (`danger`)

**Iconos por Método de Pago:**
- 🏦 **Transferencia**: `pi-building`
- 💳 **Tarjeta**: `pi-credit-card`
- 📱 **Deuna**: `pi-qrcode`

**Timeline Colors:**
- 🟣 Pedido Realizado: Purple (`#9C27B0`)
- 🟢 Pago Confirmado: Green (`#4CAF50`)
- 🟢 Pedido Completado: Green (`#4CAF50`)

## 🚀 Cómo Implementar

### 1. Aplicar Migración de Base de Datos

```powershell
cd TrabajoTitulacion-main
.\aplicar-migracion-ventas-pagos.ps1
```

Este script:
- Verifica que el contenedor Docker esté corriendo
- Aplica el SQL a la base de datos `ventas`
- Agrega las 5 nuevas columnas
- Crea índices para optimización
- Actualiza registros existentes con valores por defecto
- Muestra los primeros 10 registros

### 2. Reiniciar Microservicio de Ventas

```powershell
cd Microservicios\msvc-ventas
.\mvnw.cmd spring-boot:run
```

El microservicio detectará automáticamente las nuevas columnas gracias a los cambios en las entidades JPA.

### 3. Acceder al Historial desde el Frontend

**Opción 1: Desde el Modal de Mi Cuenta**
1. Click en el icono de usuario en el navbar
2. Click en "Ver Historial de Compras"
3. Redirige a `/profile/historial-compras`

**Opción 2: URL Directa**
- Navegar a: `http://localhost:3000/profile/historial-compras`

## 📊 Estructura de Datos

### Venta con Información de Pago

```typescript
interface Venta {
    id: number;
    numeroFactura: string;
    clienteId: number;
    subtotal: number;
    impuesto: number;
    total: number;
    estado: 'PENDIENTE' | 'COMPLETADA' | 'CANCELADA';
    
    // Nuevos campos de pago
    metodoPago: 'TRANSFERENCIA' | 'TARJETA' | 'DEUNA';
    estadoPago: 'PENDIENTE' | 'PROCESANDO' | 'APROBADO' | 'RECHAZADO';
    comprobantePagoUrl?: string;
    referenciaTransaccion?: string;
    fechaVenta: string;
    fechaPago?: string;
    
    detalles: DetalleVenta[];
}
```

## 🔄 Flujo de Uso

### Para el Cliente:

1. **Realizar una compra**:
   - Agregar productos al carrito
   - Ir al checkout
   - Seleccionar método de pago
   - Completar el pago
   - La venta se crea con `estadoPago: PENDIENTE` y `metodoPago` seleccionado

2. **Ver historial**:
   - Click en perfil → "Ver Historial de Compras"
   - Ver lista de todas las compras
   - Click en "Ver Detalle" para información completa
   - Ver estado del pago y del pedido
   - Descargar/ver comprobante si existe

3. **Seguimiento**:
   - Ver timeline con estados:
     - Pedido Realizado
     - Pago Confirmado (cuando `estadoPago` = APROBADO)
     - Pedido Completado (cuando `estado` = COMPLETADA)

### Para el Emprendedor:

1. **Recibir orden**:
   - Cliente completa la compra
   - Venta creada con `estadoPago: PENDIENTE`

2. **Confirmar pago**:
   - Revisar comprobante (si es transferencia)
   - Actualizar `estadoPago` a APROBADO
   - Actualizar `fechaPago`

3. **Completar orden**:
   - Preparar productos
   - Actualizar `estado` a COMPLETADA
   - Cliente ve todo el timeline completado

## 🎯 Mejoras Futuras Sugeridas

### Backend:
- [ ] Endpoint para actualizar estado de pago: `PUT /api/ventas/{id}/pago`
- [ ] Endpoint para subir comprobante: `POST /api/ventas/{id}/comprobante`
- [ ] Notificaciones por email cuando cambia el estado
- [ ] Webhook para notificar a emprendedores de nuevas ventas

### Frontend:
- [ ] Filtros por estado de pago
- [ ] Filtros por método de pago
- [ ] Búsqueda por número de factura
- [ ] Rango de fechas
- [ ] Exportar historial a PDF
- [ ] Botón para recomprar (agregar mismo pedido al carrito)
- [ ] Botón para descargar factura
- [ ] Chat de soporte por pedido

### Integraciones:
- [ ] Integración real con Kushki para tarjetas
- [ ] Integración real con Deuna
- [ ] Confirmación automática de transferencias vía API bancaria
- [ ] Sistema de puntos/recompensas por compras

## 📝 Notas Importantes

### Seguridad:
- ✅ El endpoint `/api/ventas/cliente/{clienteId}` debe validar que el usuario autenticado corresponda al clienteId
- ✅ Solo el cliente propietario debe ver sus compras
- ⚠️ Implementar autenticación JWT en el componente frontend
- ⚠️ Validar roles antes de mostrar información sensible

### Performance:
- ✅ Índices creados en `cliente_id` y `estado_pago`
- ✅ Paginación implementada en el DataView (5 items por página)
- ✅ Fetch lazy de detalles solo cuando se abre el Dialog
- ⚠️ Considerar caché en cliente para reduce requests
- ⚠️ Implementar lazy loading de imágenes de comprobantes

### Testing:
- [ ] Crear ventas de prueba con diferentes estados
- [ ] Probar con diferentes métodos de pago
- [ ] Validar que los filtros y paginación funcionan
- [ ] Verificar responsive en móviles
- [ ] Probar con muchas compras (performance)

## 🐛 Troubleshooting

### Error: "No se pudieron cargar las compras"
- Verificar que el microservicio msvc-ventas esté corriendo (puerto 8083)
- Verificar que la migración se aplicó correctamente
- Revisar logs del backend para errores de mapeo JPA

### Compras no muestran método de pago
- Ejecutar script de migración: `.\aplicar-migracion-ventas-pagos.ps1`
- Verificar que las columnas existen en la BD
- Reiniciar microservicio

### Modal no se cierra
- Verificar que el estado `dialogVisible` se actualiza
- Revisar console del navegador para errores de React

### Timeline vacío
- Verificar que las fechas están en formato correcto
- Revisar que `estadoPago` y `estado` tienen valores válidos

## 📦 Archivos Modificados/Creados

```
TrabajoTitulacion-main/
├── actualizar-ventas-pagos.sql ✅ NUEVO
├── aplicar-migracion-ventas-pagos.ps1 ✅ NUEVO
│
├── avalon-react-10.1.0/
│   └── app/
│       ├── (main)/profile/
│       │   └── historial-compras/
│       │       └── page.tsx ✅ NUEVO
│       └── (landing)/components/
│           └── MiCuentaModal.tsx ✏️ MODIFICADO
│
└── Microservicios/msvc-ventas/src/main/java/com/example/msvc_ventas/
    ├── domain/model/
    │   └── Venta.java ✏️ MODIFICADO
    └── infrastructure/persistence/entity/
        └── VentaEntity.java ✏️ MODIFICADO
```

## 🎉 Resultado Final

El cliente ahora puede:
- ✅ Ver todas sus compras en un listado paginado
- ✅ Ver el estado del pedido y del pago
- ✅ Ver detalle completo de cada compra
- ✅ Hacer seguimiento del proceso con timeline visual
- ✅ Ver el método de pago utilizado
- ✅ Ver comprobantes de pago (si existen)
- ✅ Identificar fácilmente pagos pendientes o rechazados
- ✅ Acceder rápidamente desde el modal de perfil

Todo usando exclusivamente componentes de **PrimeReact** con diseño moderno y responsive! 🚀
