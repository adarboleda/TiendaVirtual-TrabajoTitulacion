# 🎯 Guía de Implementación del Proceso BPM

## ✅ Pasos Completados

### 1. Dependencias Agregadas
- ✅ Camunda BPM Spring Boot Starter REST (7.20.0)
- ✅ Camunda BPM Spring Boot Starter Webapp (7.20.0)

### 2. Archivos Creados

#### Proceso BPMN
- ✅ `src/main/resources/processes/proceso-venta-completa.bpmn`

#### Delegates (Tareas del Proceso)
- ✅ `ValidarProductosDelegate.java` - Valida existencia y estado de productos
- ✅ `VerificarInventarioDelegate.java` - Verifica disponibilidad de stock
- ✅ `CrearVentaDelegate.java` - Crea la venta en la base de datos
- ✅ `ProcesarPagoDelegate.java` - Procesa el pago (simulado)
- ✅ `ActualizarInventarioDelegate.java` - Descuenta stock del inventario
- ✅ `GenerarFacturaDelegate.java` - Genera PDF de factura
- ✅ `EnviarNotificacionDelegate.java` - Envía notificación (simulado)
- ✅ `CancelarVentaDelegate.java` - Cancela venta por validación fallida
- ✅ `RevertirVentaDelegate.java` - Revierte venta por pago fallido

#### Controlador REST
- ✅ `ProcesoVentaBpmController.java` - API para iniciar y consultar procesos

#### Configuración
- ✅ `CamundaConfig.java` - Configuración del motor BPM
- ✅ `application.properties` - Propiedades de Camunda actualizadas

#### Cliente Feign
- ✅ `InventarioClient.java` - Método `actualizarInventario()` agregado

#### Documentación y Pruebas
- ✅ `DOCUMENTACION-PROCESO-BPM.md` - Documentación completa
- ✅ `prueba-proceso-bpm.ps1` - Script de pruebas automatizado

---

## 🚀 Pasos para Ejecutar

### Paso 1: Compilar el Proyecto

```powershell
cd C:\Users\mycke\Desktop\TrabajoTitulacion-main\TrabajoTitulacion-main\Microservicios\msvc-ventas

# Limpiar y compilar
mvn clean install -DskipTests
```

### Paso 2: Iniciar Servicios Dependientes

Asegúrate de que estén corriendo:
1. **MySQL** (puerto 3306)
2. **Eureka Server** (puerto 8761)
3. **msvc-producto** (puerto 8081)
4. **msvc-inventario** (puerto 8082)

```powershell
# Desde la raíz de Microservicios
.\start-all-services.ps1
```

### Paso 3: Iniciar msvc-ventas con Camunda

```powershell
cd msvc-ventas
mvn spring-boot:run
```

**Esperar a ver en logs**:
```
Camunda Platform successfully started
```

### Paso 4: Verificar Despliegue del Proceso

**Acceder a Camunda Cockpit**:
- URL: http://localhost:8083/camunda
- Usuario: `admin`
- Contraseña: `admin`

En Cockpit → Process Definitions, deberías ver:
- ✅ **proceso-venta-completa** (Deployed)

### Paso 5: Ejecutar Pruebas

```powershell
cd C:\Users\mycke\Desktop\TrabajoTitulacion-main\TrabajoTitulacion-main
.\prueba-proceso-bpm.ps1
```

---

## 📡 Endpoints Disponibles

### 1. Iniciar Proceso BPM
```http
POST http://localhost:8083/api/bpm/ventas/iniciar
Content-Type: application/json

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

### 2. Consultar Estado de Proceso
```http
GET http://localhost:8083/api/bpm/ventas/proceso/{processInstanceId}
```

### 3. Listar Procesos Activos
```http
GET http://localhost:8083/api/bpm/ventas/procesos-activos
```

### 4. Camunda REST API
```http
GET http://localhost:8083/engine-rest/process-definition
```

---

## 🔍 Verificación de Implementación

### Checklist de Validación

- [ ] **Compilación exitosa**: `mvn clean install` sin errores
- [ ] **Servicio iniciado**: Puerto 8083 activo
- [ ] **Camunda desplegado**: "Camunda Platform successfully started" en logs
- [ ] **Proceso cargado**: Visible en Cockpit → Process Definitions
- [ ] **Prueba exitosa**: `prueba-proceso-bpm.ps1` con resultados ✅
- [ ] **Base de datos**: Tablas Camunda creadas (`ACT_*`)

### Validar Tablas Camunda en MySQL

```sql
USE ventas;

-- Ver tablas de Camunda (deben existir ~40 tablas)
SHOW TABLES LIKE 'ACT_%';

-- Ver proceso desplegado
SELECT * FROM ACT_RE_PROCDEF WHERE KEY_ = 'proceso-venta-completa';

-- Ver instancias de proceso
SELECT * FROM ACT_RU_EXECUTION;
```

---

## 🐛 Solución de Problemas

### Error: "Delegate not found"

**Síntoma**: `org.camunda.bpm.engine.ProcessEngineException: Unknown property used in expression: ${validarProductosDelegate}`

**Solución**: Verificar que los delegates tienen `@Component` con el nombre correcto:
```java
@Component("validarProductosDelegate")
public class ValidarProductosDelegate implements JavaDelegate { ... }
```

### Error: "Process definition not found"

**Síntoma**: Al iniciar proceso: `Unknown process definition with key 'proceso-venta-completa'`

**Solución**:
1. Verificar que el archivo `.bpmn` está en `src/main/resources/processes/`
2. Limpiar y recompilar: `mvn clean install`
3. Verificar logs de despliegue al iniciar Spring Boot

### Error de Compilación: "Cannot resolve symbol"

**Síntoma**: Imports en rojo en los delegates

**Solución**: Ejecutar `mvn clean compile` para generar clases necesarias

### Error: FeignException al llamar a otros microservicios

**Síntoma**: `FeignException: Connection refused`

**Solución**: Verificar que msvc-producto y msvc-inventario están corriendo:
```powershell
netstat -ano | findstr ":8081"
netstat -ano | findstr ":8082"
```

---

## 📊 Monitoreo en Tiempo Real

### Ver Logs del Proceso

```powershell
# Filtrar solo logs del proceso BPM
mvn spring-boot:run | Select-String "proceso-venta-completa|INICIANDO:|Delegate"
```

### Camunda Cockpit - Vista de Instancia

1. Ir a http://localhost:8083/camunda
2. Cockpit → Process Instances
3. Click en instancia activa
4. Ver:
   - **Diagrama**: Tareas completadas (verde), activas (amarillo)
   - **Variables**: Valores de todas las variables del proceso
   - **Incidents**: Errores si los hay

---

## 🎯 Casos de Uso de Prueba

### Caso 1: Venta Exitosa (Happy Path)

**Request**:
```json
{
  "clienteId": 1,
  "items": [{"productoId": 1, "cantidad": 1}],
  "metodoPago": "TARJETA"
}
```

**Resultado Esperado**:
- ✅ Productos válidos
- ✅ Stock disponible
- ✅ Venta creada (ID en respuesta)
- ✅ Pago procesado
- ✅ Inventario actualizado
- ✅ Factura generada
- ✅ Notificación enviada
- Estado: `COMPLETADO`

---

### Caso 2: Producto Inexistente

**Request**:
```json
{
  "clienteId": 1,
  "items": [{"productoId": 99999, "cantidad": 1}],
  "metodoPago": "TARJETA"
}
```

**Resultado Esperado**:
- ❌ Productos inválidos
- Estado: `CANCELADO`
- Motivo: "Producto ID 99999 no existe"
- **NO** se crea venta en BD

---

### Caso 3: Stock Insuficiente

**Request**:
```json
{
  "clienteId": 1,
  "items": [{"productoId": 1, "cantidad": 10000}],
  "metodoPago": "TRANSFERENCIA"
}
```

**Resultado Esperado**:
- ✅ Productos válidos
- ❌ Stock insuficiente
- Estado: `CANCELADO`
- Motivo: "solicitado=10000, disponible=X"
- **NO** se crea venta en BD

---

## 📦 Archivos Generados

### Base de Datos

**Tablas Camunda** (auto-creadas):
- `ACT_RE_*`: Definiciones de procesos
- `ACT_RU_*`: Runtime (instancias activas)
- `ACT_HI_*`: Histórico (auditoría)
- `ACT_GE_*`: General

**Tablas de Aplicación**:
- `ventas`: Nuevas ventas creadas por el proceso
- `venta_detalles`: Items de cada venta

### Archivos Locales

**Facturas PDF**:
- Ubicación: `facturas/FACT-{id}.pdf`
- Generadas al completar venta exitosa

---

## 🔄 Flujo de Datos

```
1. Cliente → POST /api/bpm/ventas/iniciar
           ↓
2. ProcesoVentaBpmController → RuntimeService.startProcessInstanceByKey()
           ↓
3. Camunda Engine → Ejecuta proceso-venta-completa.bpmn
           ↓
4. Task: Validar Productos → ValidarProductosDelegate
           ↓ (Feign)
5. msvc-producto → GET /api/productos/{id}
           ↓ (respuesta)
6. Task: Verificar Inventario → VerificarInventarioDelegate
           ↓ (Feign)
7. msvc-inventario → GET /api/inventarios/producto/{id}
           ↓ (respuesta)
8. Task: Crear Venta → CrearVentaDelegate
           ↓ (SQL)
9. MySQL ventas → INSERT INTO ventas, venta_detalles
           ↓
10. Task: Procesar Pago → ProcesarPagoDelegate (simulado)
           ↓
11. Task: Actualizar Inventario → ActualizarInventarioDelegate
           ↓ (Feign)
12. msvc-inventario → PUT /api/inventarios/producto/{id}/stock
           ↓
13. Task: Generar Factura → GenerarFacturaDelegate
           ↓ (iText7)
14. Filesystem → facturas/FACT-{id}.pdf
           ↓
15. Task: Enviar Notificación → EnviarNotificacionDelegate (simulado)
           ↓
16. Proceso Completo → Response al Cliente
```

---

## 📚 Documentación Adicional

- **Documentación Completa**: [DOCUMENTACION-PROCESO-BPM.md](./DOCUMENTACION-PROCESO-BPM.md)
- **Script de Pruebas**: [prueba-proceso-bpm.ps1](./prueba-proceso-bpm.ps1)
- **Resultados JMeter**: [RESULTADOS-PRUEBAS-ESTRES.md](./RESULTADOS-PRUEBAS-ESTRES.md)

---

## ✨ Características Implementadas

- ✅ **Orquestación de Microservicios**: Camunda coordina productos, inventario y ventas
- ✅ **Saga Pattern**: Compensación automática en caso de error
- ✅ **Validación en Capas**: Productos → Stock → Pago
- ✅ **Trazabilidad Completa**: Todos los pasos registrados en BD Camunda
- ✅ **Interfaz Web**: Camunda Cockpit para monitoreo visual
- ✅ **REST API**: Control programático del proceso
- ✅ **Generación de Facturas**: PDF automático al completar venta
- ✅ **Manejo de Errores**: 3 caminos de error con mensajes descriptivos

---

## 🎓 Para Tu Tesis

### Conceptos Clave

1. **BPM (Business Process Management)**: Gestión de procesos de negocio
2. **BPMN 2.0**: Notación estándar para modelado de procesos
3. **Camunda**: Motor de ejecución de procesos Open Source
4. **Saga Pattern**: Patrón para transacciones distribuidas
5. **Orquestación**: Coordinación centralizada vs. coreografía descentralizada
6. **Compensating Transactions**: Reversión de operaciones en caso de error

### Beneficios Demostrados

- **Visibilidad**: Diagrama BPMN documenta el proceso visualmente
- **Mantenibilidad**: Cambios en el flujo sin modificar código Java
- **Auditoría**: Histórico completo de todas las ejecuciones
- **Monitoreo**: Dashboard en tiempo real de procesos activos
- **Resiliencia**: Manejo automático de errores y compensación

---

**Implementado por**: Proyecto de Titulación  
**Fecha**: Febrero 2026  
**Estado**: ✅ COMPLETO Y LISTO PARA PRUEBAS
