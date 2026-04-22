# 📋 Implementación de Métodos de Pago Múltiples

## ✅ Componentes Creados

### 🎨 Frontend (React + PrimeReact)

#### 1. **Formulario de Tarjeta**
- **Archivo**: `avalon-react-10.1.0/app/(landing)/checkout/components/TarjetaCreditoForm.tsx`
- **Características**:
  - Tarjeta visual interactiva que muestra los datos en tiempo real
  - Detección automática de tipo de tarjeta (Visa, Mastercard, Amex, Discover)
  - Validación en tiempo real de todos los campos
  - Formato automático del número de tarjeta
  - Componentes: InputText, InputMask, Card, Message

#### 2. **Simulación de Pago**
- **Archivo**: `avalon-react-10.1.0/app/(landing)/checkout/components/PaymentSimulation.tsx`
- **Características**:
  - 3 etapas de procesamiento con ProgressBar animado
  - 95% de éxito en la simulación
  - Generación de ID de transacción único
  - Manejo de errores con opción de reintentar
  - Componentes: ProgressBar, Message, Button, Card

#### 3. **Formulario de Deuna**
- **Archivo**: `avalon-react-10.1.0/app/(landing)/checkout/components/DeunaForm.tsx`
- **Características**:
  - Muestra el código QR del emprendedor
  - Instrucciones paso a paso para el cliente
  - Carga dinámica del QR desde el backend
  - Vista previa ampliada del QR
  - Componentes: Image, ProgressSpinner, Message, Card

#### 4. **Panel de Configuración del Emprendedor**
- **Archivo**: `avalon-react-10.1.0/app/(full-page)/emprendedor/configuracion-pagos/page.tsx`
- **Características**:
  - TabView con 2 pestañas (Transferencia y Deuna)
  - Formulario completo de datos bancarios
  - Upload de imagen QR con validación
  - Vista previa del QR guardado
  - Componentes: TabView, Dropdown, InputText, FileUpload, Toast

### 🗄️ Base de Datos

#### 5. **Migración SQL**
- **Archivo**: `configuracion-metodos-pago.sql`
- **Tabla creada**: `configuracion_metodos_pago`
- **Campos**:
  - `emprendedor_id` - ID del usuario emprendedor (UNIQUE)
  - `banco`, `tipo_cuenta`, `numero_cuenta` - Datos bancarios
  - `titular`, `cedula_ruc`, `email` - Información del titular
  - `qr_deuna_url` - URL del código QR
  - `created_at`, `updated_at` - Timestamps automáticos
- **Características**:
  - Constraint UNIQUE por emprendedor
  - Foreign key a tabla usuarios
  - Trigger para actualizar updated_at
  - Seed de ejemplo para usuario emprendedor

### ☕ Backend (Spring Boot)

#### 6. **Entidad JPA**
- **Archivo**: `Microservicios/demo/src/main/java/com/example/demo/domain/model/ConfiguracionMetodosPago.java`
- Mapeo completo de la tabla
- Timestamps automáticos con @PrePersist y @PreUpdate
- Relación ManyToOne con Usuario

#### 7. **Repositorio**
- **Archivo**: `Microservicios/demo/src/main/java/com/example/demo/domain/repository/ConfiguracionMetodosPagoRepository.java`
- Métodos personalizados:
  - `findByEmprendedorId()`
  - `existsByEmprendedorId()`
  - `deleteByEmprendedorId()`

#### 8. **DTOs**
- **DatosBancariosDto.java** - Datos bancarios del emprendedor
- **ConfiguracionPagosDto.java** - Configuración completa con datos bancarios y QR

#### 9. **Servicio**
- **Archivo**: `Microservicios/demo/src/main/java/com/example/demo/domain/service/ConfiguracionPagosService.java`
- **Métodos**:
  - `obtenerConfiguracion()` - Obtener config del emprendedor
  - `guardarDatosBancarios()` - Guardar/actualizar datos bancarios
  - `guardarQrDeuna()` - Subir y guardar imagen QR
  - `eliminarQrDeuna()` - Eliminar QR y archivo
  - `obtenerQrDeuna()` - Obtener QR para clientes
  - `obtenerDatosBancarios()` - Obtener datos bancarios para clientes
- **Características**:
  - Manejo de archivos con UUID único
  - Eliminación de archivos antiguos al actualizar
  - Directorio: `uploads/qr-deuna/`

#### 10. **Controlador REST**
- **Archivo**: `Microservicios/demo/src/main/java/com/example/demo/presentation/controller/ConfiguracionPagosController.java`
- **Endpoints**:
  - `GET /api/emprendedor/configuracion-pagos` - Config del emprendedor autenticado
  - `POST /api/emprendedor/configuracion-pagos/bancarios` - Guardar datos bancarios
  - `POST /api/emprendedor/configuracion-pagos/deuna-qr` - Subir QR (multipart/form-data)
  - `DELETE /api/emprendedor/configuracion-pagos/deuna-qr` - Eliminar QR
  - `GET /api/emprendedor/configuracion-pagos/deuna-qr/{emprendedorId}` - Obtener QR (público)
  - `GET /api/emprendedor/configuracion-pagos/bancarios/{emprendedorId}` - Obtener datos bancarios (público)
- **Seguridad**: @PreAuthorize("hasRole('EMP')") en endpoints del emprendedor
- **Validaciones**: Tamaño máximo 5MB, solo imágenes

#### 11. **Configuración de Recursos Estáticos**
- **Archivo**: `Microservicios/demo/src/main/java/com/example/demo/infrastructure/config/StaticResourceConfiguration.java`
- Sirve archivos desde `/uploads/qr-deuna/`

### 🔧 Scripts de Utilidad

#### 12. **Script de Migración**
- **Archivo**: `aplicar-migracion-pagos.ps1`
- Aplica la migración SQL a la base de datos
- Verifica el contenedor Docker
- Muestra los datos creados

## 🚀 Pasos para Implementar

### 1. Aplicar Migración de Base de Datos

```powershell
cd TrabajoTitulacion-main
.\aplicar-migracion-pagos.ps1
```

### 2. Reiniciar Microservicio de Auth

El microservicio detectará automáticamente la nueva entidad.

```powershell
cd Microservicios\demo
.\mvnw.cmd spring-boot:run
```

### 3. Probar desde el Frontend

#### Como Emprendedor:
1. Iniciar sesión como emprendedor
2. Ir a "Configuración de Pagos"
3. Configurar datos bancarios en la primera pestaña
4. Subir código QR de Deuna en la segunda pestaña

#### Como Cliente:
1. Agregar productos al carrito
2. Ir al checkout
3. Seleccionar método de pago:
   - **Transferencia**: Ver datos bancarios del emprendedor, subir comprobante
   - **Tarjeta**: Llenar datos de la tarjeta, ver simulación de procesamiento
   - **Deuna**: Escanear QR del emprendedor

## 📦 Estructura de Carpetas

```
TrabajoTitulacion-main/
├── avalon-react-10.1.0/
│   └── app/
│       ├── (landing)/checkout/components/
│       │   ├── PaymentMethodSelector.tsx ✅
│       │   ├── TransferenciaBancariaForm.tsx ✅
│       │   ├── TarjetaCreditoForm.tsx ✅ NUEVO
│       │   ├── PaymentSimulation.tsx ✅ NUEVO
│       │   └── DeunaForm.tsx ✅ NUEVO
│       └── (full-page)/emprendedor/
│           └── configuracion-pagos/
│               └── page.tsx ✅ NUEVO
│
├── Microservicios/demo/src/main/java/com/example/demo/
│   ├── domain/
│   │   ├── model/
│   │   │   └── ConfiguracionMetodosPago.java ✅ NUEVO
│   │   ├── repository/
│   │   │   └── ConfiguracionMetodosPagoRepository.java ✅ NUEVO
│   │   └── service/
│   │       └── ConfiguracionPagosService.java ✅ NUEVO
│   ├── application/dto/
│   │   ├── DatosBancariosDto.java ✅ NUEVO
│   │   └── ConfiguracionPagosDto.java ✅ NUEVO
│   ├── presentation/controller/
│   │   └── ConfiguracionPagosController.java ✅ NUEVO
│   └── infrastructure/config/
│       └── StaticResourceConfiguration.java ✅ NUEVO
│
├── configuracion-metodos-pago.sql ✅ NUEVO
└── aplicar-migracion-pagos.ps1 ✅ NUEVO
```

## 🎯 Próximos Pasos

1. ✅ Formulario de Transferencia Bancaria
2. ✅ Formulario de Tarjeta de Crédito
3. ✅ Formulario de Deuna
4. ✅ Panel de configuración del emprendedor
5. ✅ Backend completo (Base de datos + API)
6. ⏳ Integrar todos los formularios en el checkout
7. ⏳ Crear servicio de pagos en el frontend
8. ⏳ Conectar con el carrito de compras

## 📝 Notas Importantes

- **Seguridad**: Los archivos QR se almacenan en `uploads/qr-deuna/` con nombres únicos (UUID)
- **Validaciones**: Frontend valida formato, backend valida tipo y tamaño
- **Roles**: Solo usuarios con ROLE_EMP pueden configurar métodos de pago
- **APIs Públicas**: Los clientes pueden consultar QR y datos bancarios por emprendedorId
- **Transaccional**: Todas las operaciones de escritura son @Transactional

## 🐛 Solución de Problemas

### Error: "No se pudo obtener el ID del usuario"
- Revisa cómo se almacena el ID en el JWT
- Ajusta el método `obtenerUsuarioId()` en el controlador

### Error: "Cannot create directory"
- Verifica permisos de escritura en el directorio del microservicio
- El directorio `uploads/qr-deuna/` se crea automáticamente

### QR no se muestra
- Verifica que StaticResourceConfiguration esté cargada
- Comprueba que la URL sea accesible: `http://localhost:8080/uploads/qr-deuna/archivo.jpg`
