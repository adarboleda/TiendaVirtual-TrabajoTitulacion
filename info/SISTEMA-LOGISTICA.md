# 📦 Sistema de Logística y Seguimiento de Pedidos

## 🎯 Descripción General

Se ha implementado un sistema completo de logística que permite al emprendedor gestionar el seguimiento de pedidos desde la aprobación del pago hasta la entrega al cliente.

## ✅ Componentes Implementados

### 🗄️ Base de Datos

#### Tabla: `seguimiento_logistica`
**Ubicación:** Base de datos `ventas`

**Campos:**
- `id`: BIGINT AUTO_INCREMENT PRIMARY KEY
- `venta_id`: BIGINT NOT NULL (FK a ventas)
- `estado_logistica`: ENUM con 7 estados
- `descripcion`: TEXT (opcional)
- `ubicacion`: VARCHAR(255) (opcional)
- `responsable`: VARCHAR(100) (opcional)
- `observaciones`: TEXT (opcional)
- `fecha_actualizacion`: TIMESTAMP
- `fecha_creacion`: TIMESTAMP

**Estados Disponibles:**
1. `PAGO_APROBADO` - Pago aprobado
2. `EN_PREPARACION` - En preparación
3. `LISTO_PARA_ENVIO` - Listo para envío
4. `EN_CAMINO` - En camino
5. `EN_PUNTO_ENTREGA` - En punto de entrega
6. `ENTREGADO` - Entregado
7. `CANCELADO` - Cancelado

**Script de Migración:**
- Archivo: `scripts/crear-tabla-seguimiento-logistica.sql`
- Script PowerShell: `aplicar-migracion-logistica.ps1`

---

### ☕ Backend (Spring Boot - msvc-ventas)

#### 1. Modelo de Dominio
**`SeguimientoLogistica.java`**
```java
com.example.msvc_ventas.domain.model.SeguimientoLogistica
```
- Modelo de dominio con enum `EstadoLogistica`
- Cada estado incluye título y descripción por defecto

#### 2. Entidad JPA
**`SeguimientoLogisticaEntity.java`**
```java
com.example.msvc_ventas.infrastructure.persistence.entity.SeguimientoLogisticaEntity
```
- Mapeo completo a la tabla
- Anotaciones `@PrePersist` y `@PreUpdate` para timestamps automáticos

#### 3. Repositorio JPA
**`JpaSeguimientoLogisticaRepository.java`**
- Métodos personalizados:
  - `findByVentaIdOrderByFechaCreacionAsc()` - Historial ordenado
  - `findUltimoEstadoByVentaId()` - Último estado
  - `findByEmprendedorId()` - Seguimientos por emprendedor
  - `findByEmprendedorIdAndEstado()` - Filtrado por emprendedor y estado

#### 4. Repositorio de Dominio
**`SeguimientoLogisticaRepository.java`** (interfaz)
**`SeguimientoLogisticaRepositoryImpl.java`** (implementación)
- Implementa patrón Repository
- Usa mapper para conversión entidad ↔ dominio

#### 5. Mapper
**`SeguimientoLogisticaMapper.java`**
- Conversión bidireccional entre entidades y modelos de dominio

#### 6. Servicio de Dominio
**`SeguimientoLogisticaService.java`**
```java
com.example.msvc_ventas.domain.service.SeguimientoLogisticaService
```

**Métodos principales:**
- `crearSeguimiento()` - Crear nuevo registro
- `actualizarEstado()` - Actualizar estado del pedido
- `obtenerHistorialPorVenta()` - Obtener historial completo
- `obtenerUltimoEstado()` - Obtener último estado
- `obtenerSeguimientosPorEmprendedor()` - Seguimientos del emprendedor
- `inicializarSeguimientoPorPagoAprobado()` - Inicializar automáticamente
- `cancelarPedido()` - Marcar como cancelado

#### 7. DTOs
**`SeguimientoLogisticaDto.java`**
```java
com.example.msvc_ventas.application.dto.SeguimientoLogisticaDto
```
- DTO para respuestas con información completa

**`ActualizarSeguimientoDto.java`**
```java
com.example.msvc_ventas.application.dto.ActualizarSeguimientoDto
```
- DTO para requests de actualización
- Validaciones con Jakarta Validation

#### 8. Controlador REST
**`SeguimientoLogisticaController.java`**
```java
com.example.msvc_ventas.presentation.controller.SeguimientoLogisticaController
```

**Endpoints:**

| Método | Ruta | Descripción |
|--------|------|-------------|
| POST | `/api/seguimiento-logistica` | Crear nuevo seguimiento |
| PUT | `/api/seguimiento-logistica` | Actualizar estado |
| GET | `/api/seguimiento-logistica/venta/{ventaId}` | Historial de venta |
| GET | `/api/seguimiento-logistica/venta/{ventaId}/ultimo` | Último estado |
| GET | `/api/seguimiento-logistica/emprendedor/{id}` | Seguimientos del emprendedor |
| GET | `/api/seguimiento-logistica/emprendedor/{id}/estado/{estado}` | Filtrar por estado |
| GET | `/api/seguimiento-logistica/estados` | Lista de estados disponibles |

#### 9. Integración con PagoService
**Modificación en `PagoService.aprobarPago()`:**
```java
// Cuando se aprueba un pago, se inicializa automáticamente el seguimiento
seguimientoLogisticaService.inicializarSeguimientoPorPagoAprobado(
    venta.getId(), 
    "Emprendedor ID: " + emprendedorId
);
```

---

### 🎨 Frontend (React + TypeScript + PrimeReact)

#### 1. Servicio de Logística
**`services/logisticaService.ts`**

**Interfaces:**
```typescript
interface SeguimientoLogistica
interface ActualizarSeguimientoRequest
interface EstadoLogistico
```

**Funciones:**
- `obtenerHistorialPorVenta()` - Historial completo
- `obtenerUltimoEstado()` - Último estado
- `crearSeguimiento()` - Crear seguimiento
- `actualizarEstadoSeguimiento()` - Actualizar estado
- `obtenerSeguimientosPorEmprendedor()` - Seguimientos del emprendedor
- `obtenerEstadosDisponibles()` - Lista de estados
- `getEstadoSeverity()` - Mapeo a severity de PrimeReact
- `getEstadoIcon()` - Mapeo a íconos

#### 2. Panel del Emprendedor
**`app/(full-page)/emprendedor/logistica/LogisticaEmprendedor.tsx`**

**Características:**
- ✅ DataTable con todos los pedidos con seguimiento
- ✅ Vista de último estado de cada pedido
- ✅ Botón para ver historial completo (Timeline)
- ✅ Formulario de actualización de estado
- ✅ Dropdown con estados disponibles
- ✅ Campos opcionales: descripción, ubicación, responsable, observaciones
- ✅ Validaciones en tiempo real
- ✅ Toast notifications para feedback
- ✅ Dialog para historial con Timeline animado
- ✅ Tags de colores según estado
- ✅ Íconos específicos por estado

**Componentes utilizados:**
- DataTable, Column, Button, Tag
- Dialog, Dropdown, InputTextarea, InputText
- Toast, Card, Timeline, Divider

#### 3. Vista del Cliente (Historial de Compras)
**`app/(main)/profile/historial-compras/page.tsx`**

**Mejoras implementadas:**
- ✅ Integración con servicio de logística
- ✅ Carga automática de historial al ver detalle
- ✅ Timeline interactivo con todos los estados
- ✅ Mostrar solo si el pago está APROBADO
- ✅ Indicador de carga mientras obtiene seguimiento
- ✅ Diseño alternado (alternate) para timeline
- ✅ Tarjetas con información detallada de cada estado:
  - Estado con tag de color
  - Descripción
  - Ubicación (si existe)
  - Responsable (si existe)
  - Fecha y hora
- ✅ Mensaje informativo si no hay seguimiento aún
- ✅ Marcadores de color según estado
- ✅ Vista móvil responsive

---

## 🔄 Flujo Completo

### 1. Cliente Realiza Compra
- Cliente completa el checkout
- Se crea la venta en estado `PENDIENTE`
- Se crea el pago en estado `PENDIENTE`

### 2. Emprendedor Aprueba Pago
**En panel de pagos (`/emprendedor/pagos`):**
- Emprendedor revisa y aprueba el pago
- Backend actualiza:
  - Pago → `APROBADO`
  - Venta → `COMPLETADA`
  - **Se crea automáticamente** el primer registro de seguimiento: `PAGO_APROBADO`

### 3. Emprendedor Gestiona Logística
**En panel de logística (`/emprendedor/logistica`):**
- Ve todos los pedidos con seguimiento
- Puede actualizar el estado progresivamente:
  1. `PAGO_APROBADO` (automático)
  2. `EN_PREPARACION`
  3. `LISTO_PARA_ENVIO`
  4. `EN_CAMINO`
  5. `EN_PUNTO_ENTREGA`
  6. `ENTREGADO`

### 4. Cliente Consulta Seguimiento
**En historial de compras (`/profile/historial-compras`):**
- Abre el detalle de su compra
- Ve el timeline completo con todos los estados
- Información actualizada en tiempo real

---

## 📊 Características Técnicas

### Seguridad
- ✅ CORS configurado para localhost:3000
- ✅ Validación de pertenencia del pedido al emprendedor
- ✅ Solo emprendedores pueden actualizar estados
- ✅ Endpoints públicos solo para consulta (clientes)

### Validaciones
- ✅ Estado logístico obligatorio
- ✅ Venta debe existir
- ✅ Solo se puede actualizar si existe seguimiento previo
- ✅ Validación de estados válidos

### Performance
- ✅ Índices en venta_id, estado_logistica, fecha_actualizacion
- ✅ Query optimizadas con JOIN
- ✅ Paginación en tablas frontend
- ✅ Carga lazy de seguimiento (solo al abrir detalle)

### UX/UI
- ✅ Colores consistentes por estado
- ✅ Íconos descriptivos
- ✅ Feedback inmediato con Toast
- ✅ Loading states apropiados
- ✅ Diseño responsive
- ✅ Timeline visualmente atractivo

---

## 🚀 Instrucciones de Uso

### Aplicar Migración

```powershell
cd TrabajoTitulacion-main
.\aplicar-migracion-logistica.ps1
```

### Reiniciar Microservicio

```powershell
cd Microservicios\msvc-ventas
.\mvnw.cmd spring-boot:run
```

### Acceder al Sistema

**Panel del Emprendedor:**
```
http://localhost:3000/emprendedor/logistica
```

**Vista del Cliente:**
```
http://localhost:3000/profile/historial-compras
```

---

## 📝 Próximos Pasos Recomendados

1. **Notificaciones por Email**
   - Enviar email al cliente cuando cambia el estado
   - Notificar al emprendedor de nuevos pedidos

2. **Integración con Mensajería**
   - WhatsApp Business API
   - SMS notifications

3. **Tracking en Tiempo Real**
   - WebSockets para actualizaciones automáticas
   - Mapa con ubicación actual del pedido

4. **Reportes y Estadísticas**
   - Tiempo promedio por estado
   - Estados más frecuentes de cancelación
   - Métricas de entrega

5. **Integración con Transportistas**
   - API de empresas de courier
   - Generación de guías automáticas
   - Tracking externo

6. **App Móvil**
   - Escáner QR para actualizaciones rápidas
   - Notificaciones push

---

## 🐛 Solución de Problemas

### Error: Tabla no existe
```bash
# Verificar que la migración se aplicó
docker exec mysql-feria-digital mysql -uadmin -padmin -e "USE ventas; SHOW TABLES LIKE 'seguimiento_logistica';"
```

### Error: No se crea seguimiento al aprobar pago
- Verificar que PagoService tiene la inyección de SeguimientoLogisticaService
- Revisar logs del microservicio para ver excepciones

### Frontend no muestra seguimiento
- Verificar que el endpoint está disponible: `http://localhost:8083/api/seguimiento-logistica/estados`
- Revisar CORS en el backend
- Verificar que el pago está APROBADO (solo ahí se muestra seguimiento)

---

## 📦 Archivos Creados/Modificados

### Scripts SQL
- `scripts/crear-tabla-seguimiento-logistica.sql`
- `aplicar-migracion-logistica.ps1`

### Backend (msvc-ventas)
- `domain/model/SeguimientoLogistica.java` ✨ NUEVO
- `infrastructure/persistence/entity/SeguimientoLogisticaEntity.java` ✨ NUEVO
- `infrastructure/persistence/repository/JpaSeguimientoLogisticaRepository.java` ✨ NUEVO
- `domain/repository/SeguimientoLogisticaRepository.java` ✨ NUEVO
- `infrastructure/persistence/impl/SeguimientoLogisticaRepositoryImpl.java` ✨ NUEVO
- `infrastructure/persistence/mapper/SeguimientoLogisticaMapper.java` ✨ NUEVO
- `domain/service/SeguimientoLogisticaService.java` ✨ NUEVO
- `application/dto/SeguimientoLogisticaDto.java` ✨ NUEVO
- `application/dto/ActualizarSeguimientoDto.java` ✨ NUEVO
- `presentation/controller/SeguimientoLogisticaController.java` ✨ NUEVO
- `domain/service/PagoService.java` 🔧 MODIFICADO

### Frontend
- `services/logisticaService.ts` ✨ NUEVO
- `app/(full-page)/emprendedor/logistica/LogisticaEmprendedor.tsx` ✨ NUEVO
- `app/(full-page)/emprendedor/logistica/page.tsx` ✨ NUEVO
- `app/(main)/profile/historial-compras/page.tsx` 🔧 MODIFICADO

---

**Fecha de Implementación:** 2026-01-04  
**Sistema:** MySQL 8.0 + Spring Boot 3.4.5 + Next.js + PrimeReact  
**Estado:** ✅ Completamente Implementado y Listo para Pruebas
