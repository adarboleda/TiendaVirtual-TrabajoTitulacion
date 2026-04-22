# Guía de Inicio - Microservicios

## Prerrequisitos

1. **Java 17** instalado
   - Verifica con: `java -version`
   
2. **Maven** (opcional, el proyecto incluye Maven Wrapper)
   - Los archivos `mvnw.cmd` permiten ejecutar sin Maven instalado

3. **PostgreSQL** instalado y corriendo
   - Asegúrate de tener las bases de datos necesarias creadas
   - Verifica las credenciales en los archivos `application.properties` de cada servicio

## Orden de Inicio

Los microservicios deben iniciarse en el siguiente orden:

1. **Eureka Server** (puerto 8761) - PRIMERO, siempre
2. **Auth Service** (demo)
3. **Producto Service** (msvc-producto)
4. **Inventario Service** (msvc-inventario)
5. **Ventas Service** (msvc-ventas)

## Métodos para Iniciar

### Opción 1: Script Automático (Recomendado)

Ejecuta el script que inicia todos los servicios automáticamente:

```powershell
cd Microservicios
.\start-all-services.ps1
```

Este script:
- Abre una ventana nueva para cada servicio
- Inicia Eureka Server primero y espera 30 segundos
- Inicia los demás servicios secuencialmente
- Cada servicio corre en su propia ventana de PowerShell

### Opción 2: Manual (Uno por uno)

Abre una terminal para cada servicio y ejecuta:

**Terminal 1 - Eureka Server:**
```powershell
cd Microservicios\eureka-server
.\mvnw.cmd spring-boot:run
```
Espera a que inicie completamente (verás "Eureka Server started")

**Terminal 2 - Auth Service:**
```powershell
cd Microservicios\demo
.\mvnw.cmd spring-boot:run
```

**Terminal 3 - Producto Service:**
```powershell
cd Microservicios\msvc-producto
.\mvnw.cmd spring-boot:run
```

**Terminal 4 - Inventario Service:**
```powershell
cd Microservicios\msvc-inventario
.\mvnw.cmd spring-boot:run
```

**Terminal 5 - Ventas Service:**
```powershell
cd Microservicios\msvc-ventas
.\mvnw.cmd spring-boot:run
```

## Verificación

1. **Eureka Dashboard**: http://localhost:8761
   - Aquí verás todos los microservicios registrados
   - Todos deben aparecer con status "UP"

2. **Swagger/OpenAPI** (si está configurado):
   - Cada servicio debería tener su documentación API
   - Revisa los archivos application.properties para los puertos

## Detener los Servicios

### Usando el script:
```powershell
cd Microservicios
.\stop-all-services.ps1
```

### Manual:
Presiona `Ctrl+C` en cada terminal donde está corriendo un servicio

## Solución de Problemas

### Error: "Puerto ya en uso"
- Algún servicio ya está corriendo en ese puerto
- Usa el script `stop-all-services.ps1` o cierra manualmente

### Error: "Cannot connect to database"
- Verifica que PostgreSQL esté corriendo
- Verifica las credenciales en `application.properties`
- Asegúrate de que las bases de datos existan

### Error: "Cannot register with Eureka"
- Asegúrate de que Eureka Server esté corriendo primero
- Espera unos segundos, los servicios reintentarán automáticamente

### Compilación lenta la primera vez
- La primera ejecución descargará todas las dependencias Maven
- Puede tomar varios minutos dependiendo de tu conexión

## Puertos por Defecto

Verifica en cada `application.properties` los puertos configurados:
- Eureka Server: 8761 (típicamente)
- Auth Service: (revisar configuración)
- Producto Service: (revisar configuración)
- Inventario Service: (revisar configuración)
- Ventas Service: (revisar configuración)
