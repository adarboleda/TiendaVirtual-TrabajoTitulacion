# Plan Completo de Pruebas - ECommerce Siachos
## Trabajo de Titulación

---

## 📋 Índice
1. [Estrategia General de Pruebas](#estrategia-general)
2. [Pruebas de Usabilidad](#pruebas-de-usabilidad)
3. [Pruebas de Rendimiento](#pruebas-de-rendimiento)
4. [Pruebas de Integración](#pruebas-de-integración)
5. [Cronograma de Ejecución](#cronograma)
6. [Criterios de Aceptación](#criterios-de-aceptación)
7. [Documentación de Resultados](#documentación)

---

## 🎯 Estrategia General de Pruebas

### Objetivos
- ✅ Validar usabilidad del sistema con usuarios reales
- ✅ Verificar rendimiento bajo diferentes cargas
- ✅ Asegurar integración correcta entre componentes
- ✅ Identificar y documentar áreas de mejora
- ✅ Cumplir requisitos para trabajo de titulación

### Alcance
- **Frontend**: Next.js (páginas principales, checkout, historial)
- **Backend**: Microservicios Spring Boot (Ventas, Productos, Inventario)
- **Integraciones**: Stripe, MySQL, Eureka
- **Usuarios**: Clientes, Emprendedores, Administradores

---

## 👥 Pruebas de Usabilidad

### 1. Metodología

#### Tipo de Prueba
- **Enfoque**: Pruebas con usuarios reales (User Testing)
- **Método**: Cuestionario estructurado con Escala de Likert
- **Participantes**: Mínimo 10 usuarios (5 clientes, 3 emprendedores, 2 admin)
- **Duración**: 20-30 minutos por sesión

#### Escala de Likert Utilizada
```
1 = Totalmente en desacuerdo
2 = En desacuerdo
3 = Neutral
4 = De acuerdo
5 = Totalmente de acuerdo
```

---

### 2. Cuestionario de Usabilidad (SUS Adaptado)

#### A. Facilidad de Uso (Ease of Use)

| # | Pregunta | 1 | 2 | 3 | 4 | 5 |
|---|----------|---|---|---|---|---|
| 1 | El sistema es fácil de usar | ☐ | ☐ | ☐ | ☐ | ☐ |
| 2 | La navegación entre páginas es intuitiva | ☐ | ☐ | ☐ | ☐ | ☐ |
| 3 | Encontré rápidamente lo que buscaba | ☐ | ☐ | ☐ | ☐ | ☐ |
| 4 | El proceso de registro es sencillo | ☐ | ☐ | ☐ | ☐ | ☐ |
| 5 | No necesité ayuda para completar tareas | ☐ | ☐ | ☐ | ☐ | ☐ |

#### B. Interfaz y Diseño (UI/UX)

| # | Pregunta | 1 | 2 | 3 | 4 | 5 |
|---|----------|---|---|---|---|---|
| 6 | El diseño visual es atractivo | ☐ | ☐ | ☐ | ☐ | ☐ |
| 7 | Los colores y tipografía son adecuados | ☐ | ☐ | ☐ | ☐ | ☐ |
| 8 | Los botones y enlaces son fáciles de identificar | ☐ | ☐ | ☐ | ☐ | ☐ |
| 9 | La información está bien organizada | ☐ | ☐ | ☐ | ☐ | ☐ |
| 10 | El diseño es consistente en todas las páginas | ☐ | ☐ | ☐ | ☐ | ☐ |

#### C. Funcionalidades Específicas

| # | Pregunta | 1 | 2 | 3 | 4 | 5 |
|---|----------|---|---|---|---|---|
| 11 | El carrito de compras funciona correctamente | ☐ | ☐ | ☐ | ☐ | ☐ |
| 12 | El proceso de pago es claro y seguro | ☐ | ☐ | ☐ | ☐ | ☐ |
| 13 | La búsqueda de productos es efectiva | ☐ | ☐ | ☐ | ☐ | ☐ |
| 14 | El historial de compras es útil y claro | ☐ | ☐ | ☐ | ☐ | ☐ |
| 15 | La descarga de facturas funciona bien | ☐ | ☐ | ☐ | ☐ | ☐ |

#### D. Rendimiento Percibido

| # | Pregunta | 1 | 2 | 3 | 4 | 5 |
|---|----------|---|---|---|---|---|
| 16 | Las páginas cargan rápidamente | ☐ | ☐ | ☐ | ☐ | ☐ |
| 17 | No experimenté errores durante el uso | ☐ | ☐ | ☐ | ☐ | ☐ |
| 18 | El sistema responde rápido a mis acciones | ☐ | ☐ | ☐ | ☐ | ☐ |

#### E. Satisfacción General

| # | Pregunta | 1 | 2 | 3 | 4 | 5 |
|---|----------|---|---|---|---|---|
| 19 | Estoy satisfecho con el sistema en general | ☐ | ☐ | ☐ | ☐ | ☐ |
| 20 | Recomendaría este sistema a otros | ☐ | ☐ | ☐ | ☐ | ☐ |
| 21 | Volvería a usar este sistema | ☐ | ☐ | ☐ | ☐ | ☐ |
| 22 | El sistema cumple mis expectativas | ☐ | ☐ | ☐ | ☐ | ☐ |

#### F. Preguntas Abiertas

```
23. ¿Qué es lo que más te gustó del sistema?
_________________________________________________________________

24. ¿Qué mejorarías del sistema?
_________________________________________________________________

25. ¿Tuviste alguna dificultad? ¿Cuál?
_________________________________________________________________

26. Comentarios adicionales:
_________________________________________________________________
```

---

### 3. Tareas de Usabilidad (Observación)

#### Escenario 1: Cliente - Compra de Producto
```
Usuario: Cliente nuevo
Objetivo: Realizar una compra completa

Tareas:
1. Registrarse en el sistema (tiempo objetivo: <2 min)
2. Buscar un producto específico (tiempo objetivo: <30 seg)
3. Agregar 2 productos al carrito (tiempo objetivo: <1 min)
4. Completar el checkout (tiempo objetivo: <3 min)
5. Realizar pago con tarjeta (tiempo objetivo: <2 min)
6. Descargar factura PDF (tiempo objetivo: <30 seg)

Métricas:
- Tiempo total de completación
- Número de clics necesarios
- Errores cometidos
- Nivel de frustración (observado)
- Tasa de éxito (completa/incompleta)
```

#### Escenario 2: Cliente - Consulta Historial
```
Usuario: Cliente registrado
Objetivo: Revisar compras anteriores

Tareas:
1. Iniciar sesión (tiempo objetivo: <30 seg)
2. Navegar al historial de compras (tiempo objetivo: <20 seg)
3. Ver detalles de una compra (tiempo objetivo: <15 seg)
4. Descargar factura (tiempo objetivo: <20 seg)
5. Verificar estado logístico (si aplica)

Métricas:
- Facilidad para encontrar el historial
- Claridad de la información mostrada
- Satisfacción con el diseño
```

#### Escenario 3: Emprendedor - Gestión Inventario
```
Usuario: Emprendedor
Objetivo: Gestionar productos e inventario

Tareas:
1. Acceder al panel de emprendedor
2. Ver listado de productos propios
3. Actualizar stock de un producto
4. Consultar ventas realizadas
5. Generar reporte (si aplica)

Métricas:
- Intuitividad del panel
- Velocidad de actualización
- Claridad de información
```

---

### 4. Plantilla de Registro de Sesión

```markdown
# Sesión de Prueba de Usabilidad

## Información del Participante
- ID Participante: USR-XXX
- Fecha: DD/MM/YYYY
- Rol: [Cliente / Emprendedor / Admin]
- Edad: ___
- Experiencia previa con e-commerce: [Alta / Media / Baja]
- Dispositivo usado: [Desktop / Móvil / Tablet]

## Observaciones Durante la Prueba

### Escenario 1: [Nombre]
- Tiempo de completación: ___ min
- Tarea completada: [Sí / No / Parcial]
- Errores encontrados:
  - 
  - 
- Comentarios del usuario:
  - 

### Escenario 2: [Nombre]
...

## Resultados Cuestionario Likert
| Categoría | Promedio | Observaciones |
|-----------|----------|---------------|
| Facilidad de Uso | __/5 | |
| Interfaz y Diseño | __/5 | |
| Funcionalidades | __/5 | |
| Rendimiento | __/5 | |
| Satisfacción | __/5 | |

## Conclusiones
- Puntos fuertes:
  - 
- Áreas de mejora:
  - 
- Prioridad de cambios: [Alta / Media / Baja]
```

---

### 5. Análisis de Resultados (SUS Score)

#### Cálculo del SUS Score
```python
# Para cada participante:
# Preguntas impares (1,3,5...): Restar 1 al puntaje
# Preguntas pares (2,4,6...): Restar el puntaje de 5
# Sumar todos los valores
# Multiplicar por 2.5

# Ejemplo:
def calcular_sus_score(respuestas):
    """
    respuestas: lista de 22 valores (preguntas cerradas)
    """
    suma = 0
    for i, resp in enumerate(respuestas[:22]):  # Solo primeras 22
        if (i + 1) % 2 == 1:  # Impar
            suma += (resp - 1)
        else:  # Par
            suma += (5 - resp)
    
    sus_score = suma * 2.5
    return sus_score

# Interpretación:
# < 51: Pobre
# 51-68: OK
# 68-80: Bueno
# 80-90: Excelente
# > 90: Excepcional
```

#### Plantilla Análisis Grupal
```markdown
# Análisis de Resultados - Pruebas de Usabilidad

## Participantes
- Total: 10 usuarios
- Clientes: 5
- Emprendedores: 3
- Administradores: 2

## SUS Score Promedio
- **Score General**: 78.5/100 (Bueno)
- Por rol:
  - Clientes: 82/100
  - Emprendedores: 75/100
  - Admin: 73/100

## Resultados por Categoría (Promedio 1-5)

| Categoría | Promedio | Desv. Est. | Interpretación |
|-----------|----------|------------|----------------|
| Facilidad de Uso | 4.2 | 0.5 | Bueno |
| Interfaz y Diseño | 4.5 | 0.3 | Excelente |
| Funcionalidades | 4.0 | 0.7 | Bueno |
| Rendimiento | 3.8 | 0.9 | Aceptable |
| Satisfacción | 4.3 | 0.4 | Bueno |

## Hallazgos Principales

### Fortalezas
1. Diseño visual atractivo (4.5/5)
2. Proceso de pago claro (4.4/5)
3. Navegación intuitiva (4.2/5)

### Debilidades
1. Velocidad de carga en móviles (3.5/5)
2. Búsqueda de productos limitada (3.7/5)
3. Falta de ayuda contextual (3.6/5)

### Recomendaciones Prioritarias
1. **Alta**: Optimizar carga en móviles
2. **Alta**: Mejorar filtros de búsqueda
3. **Media**: Agregar tooltips explicativos
4. **Baja**: Mejorar mensajes de error
```

---

## ⚡ Pruebas de Rendimiento

### 1. Herramientas a Utilizar

#### Opción 1: Apache JMeter (Recomendado para Java)
```bash
# Instalación
# Descargar de: https://jmeter.apache.org/download_jmeter.cgi
# Ejecutar: jmeter.bat (Windows) o jmeter.sh (Linux)
```

#### Opción 2: k6 (Moderno y scriptable)
```bash
# Instalación Windows
choco install k6

# Instalación Linux/Mac
brew install k6
```

#### Opción 3: Gatling (Scala-based, excelente para Spring Boot)
```bash
# Descargar de: https://gatling.io/open-source/
```

---

### 2. Escenarios de Prueba

#### Escenario 1: Carga Normal (Baseline)
```
Objetivo: Establecer métricas base del sistema

Configuración:
- Usuarios concurrentes: 10
- Duración: 5 minutos
- Ramp-up: 1 minuto
- Requests por usuario: 20

Endpoints a probar:
- GET /api/productos (listado)
- GET /api/productos/{id} (detalle)
- POST /api/ventas (crear venta)
- GET /api/ventas/cliente/{id} (historial)
- POST /api/auth/login

Métricas esperadas:
- Tiempo de respuesta promedio: < 500ms
- Percentil 95: < 1s
- Tasa de error: < 1%
- Throughput: > 100 req/s
```

#### Escenario 2: Carga Pico (Peak Load)
```
Objetivo: Simular tráfico en hora pico

Configuración:
- Usuarios concurrentes: 50
- Duración: 10 minutos
- Ramp-up: 2 minutos
- Requests por usuario: 30

Métricas esperadas:
- Tiempo de respuesta promedio: < 1s
- Percentil 95: < 2s
- Tasa de error: < 5%
- Throughput: > 200 req/s
```

#### Escenario 3: Prueba de Estrés (Stress Test)
```
Objetivo: Encontrar el punto de quiebre

Configuración:
- Usuarios concurrentes: 100 → 500 (incremental)
- Duración: 15 minutos
- Ramp-up: 5 minutos
- Incremento: +50 usuarios cada 3 min

Métricas a observar:
- Punto de degradación del servicio
- Máximo de usuarios soportados
- Comportamiento de recuperación
```

#### Escenario 4: Prueba de Resistencia (Endurance/Soak Test)
```
Objetivo: Detectar memory leaks y degradación gradual

Configuración:
- Usuarios concurrentes: 25 (constante)
- Duración: 2 horas
- Requests por usuario: Continuo

Métricas a monitorear:
- Uso de memoria (JVM heap)
- Uso de CPU
- Conexiones de BD activas
- Degradación de tiempo de respuesta
```

---

### 3. Scripts de Prueba

#### Script k6 - Prueba de Carga Completa

```javascript
// load-test.js
import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate, Trend } from 'k6/metrics';

// Métricas personalizadas
const errorRate = new Rate('errors');
const checkoutDuration = new Trend('checkout_duration');

export const options = {
  stages: [
    { duration: '1m', target: 10 },   // Ramp-up a 10 usuarios
    { duration: '5m', target: 10 },   // Mantener 10 usuarios
    { duration: '1m', target: 50 },   // Subir a 50
    { duration: '5m', target: 50 },   // Mantener 50
    { duration: '1m', target: 100 },  // Subir a 100
    { duration: '3m', target: 100 },  // Mantener 100
    { duration: '2m', target: 0 },    // Ramp-down
  ],
  thresholds: {
    http_req_duration: ['p(95)<2000'], // 95% de requests < 2s
    http_req_failed: ['rate<0.05'],    // < 5% de errores
    errors: ['rate<0.1'],              // < 10% errores de negocio
  },
};

const BASE_URL = 'http://localhost:8083';
const BASE_URL_PRODUCTOS = 'http://localhost:8081';

export function setup() {
  // Login y obtener token (si aplica)
  const loginRes = http.post(`${BASE_URL}/api/auth/login`, JSON.stringify({
    username: 'test@example.com',
    password: 'test123'
  }), {
    headers: { 'Content-Type': 'application/json' },
  });
  
  return { token: loginRes.json('token') };
}

export default function(data) {
  const params = {
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${data.token}`,
    },
  };

  // 1. Listar productos
  let res = http.get(`${BASE_URL_PRODUCTOS}/api/productos`, params);
  check(res, {
    'productos listados': (r) => r.status === 200,
    'tiene productos': (r) => JSON.parse(r.body).length > 0,
  }) || errorRate.add(1);
  
  sleep(1);

  // 2. Ver detalle de producto
  res = http.get(`${BASE_URL_PRODUCTOS}/api/productos/1`, params);
  check(res, {
    'producto obtenido': (r) => r.status === 200,
  }) || errorRate.add(1);
  
  sleep(1);

  // 3. Crear venta (checkout completo)
  const ventaPayload = JSON.stringify({
    clienteId: 1,
    detalles: [
      { productoId: 1, cantidad: 2, precioUnitario: 15.50 },
      { productoId: 2, cantidad: 1, precioUnitario: 23.00 }
    ],
    metodoPago: 'TARJETA'
  });

  const checkoutStart = new Date();
  res = http.post(`${BASE_URL}/api/ventas`, ventaPayload, params);
  const checkoutEnd = new Date();
  
  checkoutDuration.add(checkoutEnd - checkoutStart);
  
  check(res, {
    'venta creada': (r) => r.status === 201,
    'tiene ID': (r) => JSON.parse(r.body).id !== undefined,
  }) || errorRate.add(1);

  const ventaId = res.json('id');
  sleep(2);

  // 4. Consultar historial
  res = http.get(`${BASE_URL}/api/ventas/cliente/1`, params);
  check(res, {
    'historial obtenido': (r) => r.status === 200,
  }) || errorRate.add(1);

  sleep(1);

  // 5. Descargar factura (si la venta fue exitosa)
  if (ventaId) {
    res = http.get(`${BASE_URL}/api/ventas/${ventaId}/factura`, params);
    check(res, {
      'factura generada': (r) => r.status === 200,
      'es PDF': (r) => r.headers['Content-Type'].includes('pdf'),
    }) || errorRate.add(1);
  }

  sleep(2);
}

export function teardown(data) {
  // Limpieza si es necesaria
  console.log('Test completado');
}
```

**Ejecutar:**
```bash
k6 run load-test.js
```

---

#### Script JMeter - Plan de Pruebas XML

```xml
<?xml version="1.0" encoding="UTF-8"?>
<jmeterTestPlan version="1.2" properties="5.0">
  <hashTree>
    <TestPlan guiclass="TestPlanGui" testclass="TestPlan" testname="ECommerce Load Test">
      <stringProp name="TestPlan.comments">Prueba de carga para microservicios</stringProp>
      <boolProp name="TestPlan.functional_mode">false</boolProp>
      <boolProp name="TestPlan.serialize_threadgroups">false</boolProp>
    </TestPlan>
    <hashTree>
      
      <!-- Thread Group - Usuarios -->
      <ThreadGroup guiclass="ThreadGroupGui" testclass="ThreadGroup" testname="Usuarios Concurrentes">
        <stringProp name="ThreadGroup.num_threads">50</stringProp>
        <stringProp name="ThreadGroup.ramp_time">60</stringProp>
        <stringProp name="ThreadGroup.duration">300</stringProp>
        <boolProp name="ThreadGroup.scheduler">true</boolProp>
      </ThreadGroup>
      <hashTree>
        
        <!-- HTTP Request - Listar Productos -->
        <HTTPSamplerProxy guiclass="HttpTestSampleGui" testclass="HTTPSamplerProxy" testname="GET Productos">
          <stringProp name="HTTPSampler.domain">localhost</stringProp>
          <stringProp name="HTTPSampler.port">8081</stringProp>
          <stringProp name="HTTPSampler.path">/api/productos</stringProp>
          <stringProp name="HTTPSampler.method">GET</stringProp>
        </HTTPSamplerProxy>
        <hashTree>
          <ResponseAssertion guiclass="AssertionGui" testclass="ResponseAssertion" testname="Assert 200">
            <collectionProp name="Asserion.test_strings">
              <stringProp name="49586">200</stringProp>
            </collectionProp>
            <stringProp name="Assertion.test_field">Assertion.response_code</stringProp>
          </ResponseAssertion>
        </hashTree>

        <!-- Constant Timer - Pausa -->
        <ConstantTimer guiclass="ConstantTimerGui" testclass="ConstantTimer" testname="Think Time">
          <stringProp name="ConstantTimer.delay">1000</stringProp>
        </ConstantTimer>

        <!-- HTTP Request - Crear Venta -->
        <HTTPSamplerProxy guiclass="HttpTestSampleGui" testclass="HTTPSamplerProxy" testname="POST Venta">
          <stringProp name="HTTPSampler.domain">localhost</stringProp>
          <stringProp name="HTTPSampler.port">8083</stringProp>
          <stringProp name="HTTPSampler.path">/api/ventas</stringProp>
          <stringProp name="HTTPSampler.method">POST</stringProp>
          <boolProp name="HTTPSampler.use_keepalive">true</boolProp>
          <stringProp name="HTTPSampler.postBodyRaw">
            {
              "clienteId": 1,
              "detalles": [
                {"productoId": 1, "cantidad": 2, "precioUnitario": 15.50}
              ],
              "metodoPago": "TARJETA"
            }
          </stringProp>
          <elementProp name="HTTPsampler.Arguments" elementType="Arguments">
            <collectionProp name="Arguments.arguments"/>
          </elementProp>
        </HTTPSamplerProxy>
        <hashTree>
          <HeaderManager guiclass="HeaderPanel" testclass="HeaderManager" testname="Headers">
            <collectionProp name="HeaderManager.headers">
              <elementProp name="" elementType="Header">
                <stringProp name="Header.name">Content-Type</stringProp>
                <stringProp name="Header.value">application/json</stringProp>
              </elementProp>
            </collectionProp>
          </HeaderManager>
        </hashTree>

      </hashTree>

      <!-- Listeners - Resultados -->
      <ResultCollector guiclass="SummaryReport" testclass="ResultCollector" testname="Summary Report"/>
      <ResultCollector guiclass="ViewResultsFullVisualizer" testclass="ResultCollector" testname="View Results Tree"/>
      <ResultCollector guiclass="GraphVisualizer" testclass="ResultCollector" testname="Graph Results"/>
      
    </hashTree>
  </hashTree>
</jmeterTestPlan>
```

---

#### Script Gatling - Simulación Scala

```scala
// ECommerceSimulation.scala
package simulations

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._

class ECommerceSimulation extends Simulation {

  val httpProtocol = http
    .baseUrl("http://localhost:8083")
    .acceptHeader("application/json")
    .contentTypeHeader("application/json")

  val scn = scenario("ECommerce User Journey")
    .exec(
      http("Listar Productos")
        .get("http://localhost:8081/api/productos")
        .check(status.is(200))
    )
    .pause(1.second)
    .exec(
      http("Ver Producto Detalle")
        .get("http://localhost:8081/api/productos/1")
        .check(status.is(200))
        .check(jsonPath("$.nombre").exists)
    )
    .pause(2.seconds)
    .exec(
      http("Crear Venta")
        .post("/api/ventas")
        .body(StringBody("""{
          "clienteId": 1,
          "detalles": [
            {"productoId": 1, "cantidad": 2, "precioUnitario": 15.50}
          ],
          "metodoPago": "TARJETA"
        }"""))
        .check(status.is(201))
        .check(jsonPath("$.id").saveAs("ventaId"))
    )
    .pause(1.second)
    .exec(
      http("Consultar Historial")
        .get("/api/ventas/cliente/1")
        .check(status.is(200))
    )

  setUp(
    scn.inject(
      rampUsers(50) during (2.minutes),
      constantUsersPerSec(10) during (5.minutes)
    )
  ).protocols(httpProtocol)
   .assertions(
     global.responseTime.max.lt(2000),
     global.successfulRequests.percent.gt(95)
   )
}
```

**Ejecutar:**
```bash
mvn gatling:test
```

---

### 4. Métricas a Capturar

#### Métricas de Rendimiento

| Métrica | Descripción | Objetivo | Herramienta |
|---------|-------------|----------|-------------|
| **Response Time (Avg)** | Tiempo promedio de respuesta | < 500ms | k6, JMeter |
| **Response Time (P95)** | 95% requests bajo este tiempo | < 1s | k6, JMeter |
| **Response Time (P99)** | 99% requests bajo este tiempo | < 2s | k6, JMeter |
| **Throughput** | Requests por segundo | > 100 req/s | k6, JMeter |
| **Error Rate** | % de requests fallidos | < 1% | k6, JMeter |
| **Concurrent Users** | Usuarios simultáneos máximo | > 50 | k6, JMeter |
| **CPU Usage** | Uso de CPU del servidor | < 70% | Task Manager, top |
| **Memory Usage** | Uso de RAM | < 80% | Task Manager, top |
| **DB Connections** | Conexiones activas a BD | < 50 | MySQL Workbench |
| **Network Latency** | Latencia de red | < 100ms | ping, tracert |

#### Métricas de Sistema (Monitoreo)

```bash
# Windows - Monitoreo en PowerShell
Get-Counter '\Processor(_Total)\% Processor Time' -Continuous
Get-Counter '\Memory\Available MBytes' -Continuous

# Linux - Monitoreo con top/htop
top -b -n 1 | grep java

# MySQL - Conexiones activas
SHOW STATUS WHERE Variable_name = 'Threads_connected';
```

---

### 5. Plantilla de Reporte de Rendimiento

```markdown
# Reporte de Pruebas de Rendimiento

## Información General
- **Fecha**: DD/MM/YYYY
- **Herramienta**: k6 / JMeter / Gatling
- **Duración**: XX minutos
- **Ambiente**: Desarrollo / Staging / Producción

## Configuración del Servidor
- **CPU**: X cores
- **RAM**: X GB
- **BD**: MySQL 8.0
- **Java**: OpenJDK 17
- **Servicios**: Ventas, Productos, Inventario, Eureka

## Resultados por Escenario

### Escenario 1: Carga Normal (10 usuarios)

| Métrica | Resultado | Objetivo | Estado |
|---------|-----------|----------|--------|
| Avg Response Time | 345ms | < 500ms | ✅ PASS |
| P95 Response Time | 678ms | < 1s | ✅ PASS |
| P99 Response Time | 1.2s | < 2s | ✅ PASS |
| Throughput | 125 req/s | > 100 req/s | ✅ PASS |
| Error Rate | 0.5% | < 1% | ✅ PASS |
| CPU Usage | 45% | < 70% | ✅ PASS |
| Memory Usage | 62% | < 80% | ✅ PASS |

**Gráfico de Respuesta:**
![Response Time Graph](...)

### Escenario 2: Carga Pico (50 usuarios)

| Métrica | Resultado | Objetivo | Estado |
|---------|-----------|----------|--------|
| Avg Response Time | 782ms | < 1s | ✅ PASS |
| P95 Response Time | 1.5s | < 2s | ✅ PASS |
| Throughput | 215 req/s | > 200 req/s | ✅ PASS |
| Error Rate | 2.3% | < 5% | ✅ PASS |

### Escenario 3: Prueba de Estrés (100+ usuarios)

| Métrica | Resultado | Observación |
|---------|-----------|-------------|
| Usuarios máximos soportados | 180 | Degradación notable > 180 |
| Punto de quiebre | 200 usuarios | Error rate > 15% |
| Tiempo recuperación | 45 segundos | Aceptable |

**Gráfico de Estrés:**
![Stress Test Graph](...)

## Cuellos de Botella Identificados

1. **Base de Datos MySQL**
   - Problema: Queries lentos en tabla `detalles_venta`
   - Impacto: +300ms en requests de historial
   - Solución: Agregar índice en `venta_id`

2. **Generación de PDF (Facturas)**
   - Problema: iText bloquea thread durante generación
   - Impacto: Timeout en 5% de requests con >100 usuarios
   - Solución: Mover a procesamiento asíncrono

3. **Feign Client (Comunicación entre servicios)**
   - Problema: Timeout por defecto muy corto (1s)
   - Impacto: Fallos intermitentes bajo carga
   - Solución: Aumentar timeout a 5s y agregar retry

## Recomendaciones

### Alta Prioridad
1. Indexar tabla `detalles_venta` (columna `venta_id`)
2. Implementar generación asíncrona de PDFs
3. Configurar connection pooling en MySQL (max 100)

### Media Prioridad
4. Agregar caché Redis para productos más vendidos
5. Implementar rate limiting (100 req/min por IP)
6. Optimizar queries N+1 en ventas con detalles

### Baja Prioridad
7. Agregar CDN para assets estáticos
8. Implementar lazy loading en frontend
9. Considerar sharding de base de datos (futuro)

## Conclusiones

El sistema soporta adecuadamente hasta **50 usuarios concurrentes** con rendimiento óptimo (< 1s response time, < 1% error rate). 

Con las optimizaciones recomendadas (índices, async PDFs, connection pooling), se estima soportar hasta **100-150 usuarios concurrentes** manteniendo SLA.

Para escalamiento mayor (>200 usuarios), se recomienda:
- Migrar a arquitectura cloud (AWS/Azure)
- Implementar auto-scaling horizontal
- Usar base de datos managed (RDS)
- Agregar load balancer
```

---

## 🔗 Pruebas de Integración

### 1. Tipos de Pruebas de Integración

#### A. Integración entre Microservicios
- **Ventas ↔ Productos**: Validar producto antes de crear venta
- **Ventas ↔ Inventario**: Reducir stock al confirmar venta
- **Ventas ↔ Pagos**: Procesar pago con Stripe
- **Auth ↔ Todos**: Validación de JWT en endpoints

#### B. Integración con Servicios Externos
- **Stripe API**: Crear cargo, confirmar pago
- **MySQL Database**: Persistencia correcta
- **Eureka Server**: Registro y descubrimiento

---

### 2. Herramientas

#### Spring Boot Test
```xml
<!-- pom.xml -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
</dependency>
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-contract-stub-runner</artifactId>
    <scope>test</scope>
</dependency>
```

#### TestContainers (MySQL, Redis, etc.)
```xml
<dependency>
    <groupId>org.testcontainers</groupId>
    <artifactId>testcontainers</artifactId>
    <version>1.19.3</version>
    <scope>test</scope>
</dependency>
<dependency>
    <groupId>org.testcontainers</groupId>
    <artifactId>mysql</artifactId>
    <version>1.19.3</version>
    <scope>test</scope>
</dependency>
```

---

### 3. Ejemplos de Pruebas de Integración

#### Prueba 1: Ventas ↔ Productos (Feign Client)

```java
// VentaProductoIntegrationTest.java
package com.siachos.ventas.integration;

import com.siachos.ventas.application.VentaApplicationService;
import com.siachos.ventas.application.dto.CrearVentaRequest;
import com.siachos.ventas.application.dto.ItemVentaRequest;
import com.siachos.ventas.infrastructure.feign.ProductoClient;
import com.siachos.ventas.infrastructure.feign.dto.ProductoDto;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.context.ActiveProfiles;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.when;

@SpringBootTest
@ActiveProfiles("test")
class VentaProductoIntegrationTest {

    @Autowired
    private VentaApplicationService ventaService;

    @MockBean
    private ProductoClient productoClient;

    @Test
    void deberiaCrearVentaConProductosValidos() {
        // Arrange
        ProductoDto producto = ProductoDto.builder()
                .id(1L)
                .nombre("Artesanía Ecuatoriana")
                .precio(BigDecimal.valueOf(25.50))
                .stock(100)
                .build();

        when(productoClient.obtenerProducto(anyLong()))
                .thenReturn(producto);

        CrearVentaRequest request = new CrearVentaRequest();
        request.setClienteId(1L);
        request.setItems(List.of(
                new ItemVentaRequest(1L, 2)
        ));

        // Act
        var venta = ventaService.crearVenta(request);

        // Assert
        assertThat(venta).isNotNull();
        assertThat(venta.getDetalles()).hasSize(1);
        assertThat(venta.getDetalles().get(0).getNombreProducto())
                .isEqualTo("Artesanía Ecuatoriana");
        assertThat(venta.getTotal()).isEqualByComparingTo(BigDecimal.valueOf(51.00));
    }

    @Test
    void deberiaFallarSiProductoNoExiste() {
        // Arrange
        when(productoClient.obtenerProducto(anyLong()))
                .thenThrow(new RuntimeException("Producto no encontrado"));

        CrearVentaRequest request = new CrearVentaRequest();
        request.setClienteId(1L);
        request.setItems(List.of(
                new ItemVentaRequest(999L, 1)
        ));

        // Act & Assert
        assertThatThrownBy(() -> ventaService.crearVenta(request))
                .isInstanceOf(RuntimeException.class)
                .hasMessageContaining("Producto no encontrado");
    }
}
```

---

#### Prueba 2: Integración con Base de Datos (Repository Test)

```java
// VentaRepositoryIntegrationTest.java
package com.siachos.ventas.infrastructure.persistence;

import com.siachos.ventas.domain.model.Venta;
import com.siachos.ventas.domain.model.DetalleVenta;
import com.siachos.ventas.domain.model.EstadoVenta;
import com.siachos.ventas.domain.model.MetodoPago;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.test.context.ActiveProfiles;
import org.testcontainers.containers.MySQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DataJpaTest
@Testcontainers
@ActiveProfiles("test")
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
class VentaRepositoryIntegrationTest {

    @Container
    static MySQLContainer<?> mysql = new MySQLContainer<>("mysql:8.0")
            .withDatabaseName("testdb")
            .withUsername("test")
            .withPassword("test");

    @Autowired
    private VentaRepository ventaRepository;

    @Autowired
    private DetalleVentaRepository detalleVentaRepository;

    @Autowired
    private TestEntityManager entityManager;

    @Test
    void deberiaGuardarVentaConDetalles() {
        // Arrange
        Venta venta = new Venta();
        venta.setNumeroFactura("FACT-TEST-001");
        venta.setClienteId(1L);
        venta.setSubtotal(BigDecimal.valueOf(100));
        venta.setImpuesto(BigDecimal.valueOf(12));
        venta.setTotal(BigDecimal.valueOf(112));
        venta.setEstado(EstadoVenta.COMPLETADA);
        venta.setMetodoPago(MetodoPago.TARJETA);
        venta.setFechaVenta(LocalDateTime.now());

        DetalleVenta detalle1 = new DetalleVenta();
        detalle1.setProductoId(1L);
        detalle1.setNombreProducto("Producto Test");
        detalle1.setCantidad(2);
        detalle1.setPrecioUnitario(BigDecimal.valueOf(50));
        detalle1.setSubtotal(BigDecimal.valueOf(100));
        detalle1.setVenta(venta);

        venta.setDetalles(List.of(detalle1));

        // Act
        Venta savedVenta = ventaRepository.save(venta);
        entityManager.flush();
        entityManager.clear();

        // Assert
        Venta foundVenta = ventaRepository.findById(savedVenta.getId()).orElseThrow();
        
        assertThat(foundVenta).isNotNull();
        assertThat(foundVenta.getNumeroFactura()).isEqualTo("FACT-TEST-001");
        assertThat(foundVenta.getDetalles()).hasSize(1);
        assertThat(foundVenta.getDetalles().get(0).getNombreProducto())
                .isEqualTo("Producto Test");
    }

    @Test
    void deberiaEncontrarVentasPorCliente() {
        // Arrange
        Venta venta1 = crearVentaTest(1L, "FACT-001");
        Venta venta2 = crearVentaTest(1L, "FACT-002");
        Venta venta3 = crearVentaTest(2L, "FACT-003");

        ventaRepository.saveAll(List.of(venta1, venta2, venta3));
        entityManager.flush();

        // Act
        List<Venta> ventasCliente1 = ventaRepository.findByClienteId(1L);

        // Assert
        assertThat(ventasCliente1).hasSize(2);
        assertThat(ventasCliente1)
                .extracting(Venta::getNumeroFactura)
                .containsExactlyInAnyOrder("FACT-001", "FACT-002");
    }

    private Venta crearVentaTest(Long clienteId, String numeroFactura) {
        Venta venta = new Venta();
        venta.setClienteId(clienteId);
        venta.setNumeroFactura(numeroFactura);
        venta.setSubtotal(BigDecimal.valueOf(50));
        venta.setImpuesto(BigDecimal.valueOf(6));
        venta.setTotal(BigDecimal.valueOf(56));
        venta.setEstado(EstadoVenta.COMPLETADA);
        venta.setMetodoPago(MetodoPago.TARJETA);
        venta.setFechaVenta(LocalDateTime.now());
        return venta;
    }
}
```

---

#### Prueba 3: Integración con Stripe (Mock o Test Mode)

```java
// PagoStripeIntegrationTest.java
package com.siachos.ventas.integration;

import com.siachos.ventas.application.PagoService;
import com.siachos.ventas.application.dto.PagoRequest;
import com.siachos.ventas.application.dto.PagoResponse;
import com.stripe.Stripe;
import com.stripe.exception.StripeException;
import com.stripe.model.Charge;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

import java.math.BigDecimal;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@ActiveProfiles("test")
class PagoStripeIntegrationTest {

    @Autowired
    private PagoService pagoService;

    @Value("${stripe.api.key.test}")
    private String stripeTestKey;

    @BeforeEach
    void setUp() {
        Stripe.apiKey = stripeTestKey; // Usar test key
    }

    @Test
    void deberiaProcesarPagoConTarjetaTest() {
        // Arrange - Tarjeta de prueba de Stripe
        PagoRequest request = new PagoRequest();
        request.setMonto(BigDecimal.valueOf(50.00));
        request.setMoneda("USD");
        request.setTokenTarjeta("tok_visa"); // Token de prueba
        request.setDescripcion("Pago de prueba");

        // Act
        PagoResponse response = pagoService.procesarPago(request);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.isExitoso()).isTrue();
        assertThat(response.getIdTransaccion()).isNotBlank();
        assertThat(response.getMonto()).isEqualByComparingTo(BigDecimal.valueOf(50.00));
    }

    @Test
    void deberiaRechazarTarjetaDeclinada() {
        // Arrange - Tarjeta que será declinada
        PagoRequest request = new PagoRequest();
        request.setMonto(BigDecimal.valueOf(100.00));
        request.setMoneda("USD");
        request.setTokenTarjeta("tok_chargeDeclined"); // Token de prueba para rechazo

        // Act
        PagoResponse response = pagoService.procesarPago(request);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.isExitoso()).isFalse();
        assertThat(response.getMensajeError()).contains("declined");
    }

    @Test
    void deberiaCrearReembolso() throws StripeException {
        // Arrange - Primero crear un cargo exitoso
        PagoRequest pagoRequest = new PagoRequest();
        pagoRequest.setMonto(BigDecimal.valueOf(30.00));
        pagoRequest.setTokenTarjeta("tok_visa");
        
        PagoResponse pagoResponse = pagoService.procesarPago(pagoRequest);
        String chargeId = pagoResponse.getIdTransaccion();

        // Act - Crear reembolso
        var refund = pagoService.crearReembolso(chargeId, BigDecimal.valueOf(30.00));

        // Assert
        assertThat(refund).isNotNull();
        assertThat(refund.getStatus()).isEqualTo("succeeded");
    }
}
```

---

#### Prueba 4: Prueba End-to-End (E2E) con MockMvc

```java
// VentaE2EIntegrationTest.java
package com.siachos.ventas.e2e;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.siachos.ventas.application.dto.CrearVentaRequest;
import com.siachos.ventas.application.dto.ItemVentaRequest;
import com.siachos.ventas.domain.model.EstadoVenta;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import java.util.List;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.hamcrest.Matchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class VentaE2EIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    void flujoCompletoDeCompra() throws Exception {
        // 1. Crear venta
        CrearVentaRequest request = new CrearVentaRequest();
        request.setClienteId(1L);
        request.setItems(List.of(
                new ItemVentaRequest(1L, 2),
                new ItemVentaRequest(2L, 1)
        ));

        MvcResult createResult = mockMvc.perform(post("/api/ventas")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").exists())
                .andExpect(jsonPath("$.numeroFactura").exists())
                .andExpect(jsonPath("$.estado").value(EstadoVenta.PENDIENTE.name()))
                .andReturn();

        String responseBody = createResult.getResponse().getContentAsString();
        Long ventaId = objectMapper.readTree(responseBody).get("id").asLong();

        // 2. Consultar venta creada
        mockMvc.perform(get("/api/ventas/" + ventaId))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(ventaId))
                .andExpect(jsonPath("$.detalles").isArray())
                .andExpect(jsonPath("$.detalles", hasSize(greaterThan(0))));

        // 3. Consultar historial del cliente
        mockMvc.perform(get("/api/ventas/cliente/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$[*].id", hasItem(ventaId.intValue())));

        // 4. Descargar factura PDF
        mockMvc.perform(get("/api/ventas/" + ventaId + "/factura"))
                .andExpect(status().isOk())
                .andExpect(content().contentType("application/pdf"))
                .andExpect(header().exists("Content-Disposition"));
    }

    @Test
    void deberiaValidarDatosDeEntrada() throws Exception {
        // Request inválido - sin cliente ID
        CrearVentaRequest requestInvalido = new CrearVentaRequest();
        requestInvalido.setItems(List.of(
                new ItemVentaRequest(1L, 0) // Cantidad inválida
        ));

        mockMvc.perform(post("/api/ventas")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(requestInvalido)))
                .andExpect(status().isBadRequest());
    }
}
```

---

### 4. Configuración para Pruebas

#### application-test.yml

```yaml
spring:
  datasource:
    url: jdbc:tc:mysql:8.0:///testdb  # TestContainers
    driver-class-name: org.testcontainers.jdbc.ContainerDatabaseDriver
  jpa:
    hibernate:
      ddl-auto: create-drop
    show-sql: true
    properties:
      hibernate:
        format_sql: true

stripe:
  api:
    key:
      test: sk_test_XXXXX  # Clave de prueba de Stripe

eureka:
  client:
    enabled: false  # Desactivar Eureka en tests

logging:
  level:
    com.siachos: DEBUG
    org.hibernate.SQL: DEBUG
```

---

### 5. Plantilla de Checklist de Integración

```markdown
# Checklist de Pruebas de Integración

## Integración entre Microservicios

### Ventas ↔ Productos
- [ ] Obtener producto por ID desde Ventas funciona
- [ ] Manejo de errores cuando producto no existe
- [ ] Timeout y retry configurados correctamente
- [ ] Fallback cuando servicio Productos está caído

### Ventas ↔ Inventario
- [ ] Reducción de stock al crear venta
- [ ] Rollback si venta falla después de reducir stock
- [ ] Manejo de stock insuficiente
- [ ] Concurrencia al actualizar stock

### Ventas ↔ Auth
- [ ] JWT valida correctamente
- [ ] Tokens expirados son rechazados
- [ ] Roles y permisos funcionan
- [ ] CORS configurado correctamente

## Integración con Servicios Externos

### Stripe
- [ ] Crear cargo con tarjeta válida
- [ ] Rechazar tarjeta declinada
- [ ] Crear reembolso
- [ ] Webhooks configurados y funcionando
- [ ] Manejo de errores de red

### Base de Datos MySQL
- [ ] CRUD completo de Ventas
- [ ] CRUD completo de DetalleVenta
- [ ] Relaciones @OneToMany funcionan
- [ ] Queries con JOIN optimizados
- [ ] Índices creados correctamente
- [ ] Transacciones ACID funcionan

### Eureka Server
- [ ] Servicios se registran correctamente
- [ ] Heartbeat funciona
- [ ] Descubrimiento de servicios activo
- [ ] Failover cuando instancia cae

## Pruebas End-to-End

### Flujo de Compra Completo
- [ ] Cliente puede registrarse
- [ ] Cliente puede buscar productos
- [ ] Cliente puede agregar al carrito
- [ ] Cliente puede completar checkout
- [ ] Cliente puede pagar con Stripe
- [ ] Cliente recibe confirmación
- [ ] Cliente puede descargar factura
- [ ] Cliente puede ver historial

### Flujo de Emprendedor
- [ ] Emprendedor puede agregar producto
- [ ] Emprendedor puede actualizar inventario
- [ ] Emprendedor puede ver ventas
- [ ] Emprendedor puede generar reportes

## Resultados

- **Total Pruebas**: XX
- **Pasadas**: XX
- **Falladas**: XX
- **Cobertura**: XX%
- **Estado**: ✅ PASS / ❌ FAIL
```

---

## 📅 Cronograma de Ejecución

### Semana 1: Preparación
- **Días 1-2**: Configurar herramientas (k6, JMeter, TestContainers)
- **Días 3-4**: Escribir scripts de pruebas de rendimiento
- **Día 5**: Escribir pruebas de integración básicas

### Semana 2: Pruebas de Usabilidad
- **Días 1-2**: Reclutar participantes (10 usuarios)
- **Días 3-5**: Ejecutar sesiones de usabilidad (2-3 por día)
- **Día 6-7**: Analizar resultados y calcular SUS score

### Semana 3: Pruebas de Rendimiento
- **Día 1**: Ejecutar prueba de carga normal
- **Día 2**: Ejecutar prueba de pico
- **Día 3**: Ejecutar prueba de estrés
- **Día 4**: Ejecutar prueba de resistencia (2 horas)
- **Día 5**: Analizar métricas y generar reporte
- **Día 6-7**: Implementar optimizaciones críticas

### Semana 4: Pruebas de Integración
- **Días 1-2**: Ejecutar pruebas unitarias de integración
- **Día 3**: Ejecutar pruebas E2E
- **Día 4**: Pruebas de integración con Stripe
- **Día 5**: Pruebas de BD y persistencia
- **Día 6-7**: Consolidar reportes y documentación

---

## ✅ Criterios de Aceptación

### Usabilidad
- **SUS Score**: ≥ 70 (Bueno)
- **Tasa de completación tareas**: ≥ 85%
- **Tiempo promedio por tarea**: Dentro de objetivo ± 20%
- **Satisfacción general**: ≥ 4.0/5.0

### Rendimiento
- **Usuarios concurrentes**: ≥ 50 sin degradación
- **Response time (P95)**: < 1 segundo
- **Error rate**: < 1% en carga normal
- **Throughput**: > 100 req/s
- **Disponibilidad**: > 99.5%

### Integración
- **Cobertura de pruebas**: ≥ 80%
- **Todas las integraciones críticas**: PASS
- **Tiempo de ejecución suite**: < 10 minutos
- **Zero fallos en flujos principales**

---

## 📊 Documentación de Resultados

### Estructura de Carpetas
```
pruebas/
├── usabilidad/
│   ├── cuestionarios/
│   │   ├── usuario_001.pdf
│   │   └── usuario_002.pdf
│   ├── grabaciones/
│   └── analisis_resultados.md
├── rendimiento/
│   ├── scripts/
│   │   ├── load-test.js
│   │   └── stress-test.jmx
│   ├── reportes/
│   │   ├── reporte_carga_normal.html
│   │   └── reporte_estres.html
│   └── graficos/
│       ├── response_time.png
│       └── throughput.png
├── integracion/
│   ├── src/test/java/
│   ├── reportes/
│   │   └── jacoco/
│   └── resultados_tests.xml
└── documentacion/
    ├── PLAN_PRUEBAS.md
    ├── RESULTADOS_FINALES.md
    └── RECOMENDACIONES.md
```

### Formato Reporte Final

```markdown
# Reporte Final de Pruebas - ECommerce Siachos

## Resumen Ejecutivo

| Tipo de Prueba | Estado | Puntuación | Observaciones |
|----------------|--------|------------|---------------|
| Usabilidad | ✅ PASS | 78/100 SUS | Bueno, algunas mejoras UX |
| Rendimiento | ✅ PASS | 85% | Soporta 50 usuarios concurrentes |
| Integración | ✅ PASS | 92% cobertura | Todas críticas OK |

### Veredicto General
**✅ SISTEMA LISTO PARA PRODUCCIÓN** con implementación de recomendaciones de prioridad alta.

## Detalles por Tipo

[Incluir secciones detalladas de cada tipo de prueba]

## Recomendaciones Finales

### Críticas (Antes de producción)
1. Implementar índice en `detalles_venta.venta_id`
2. Aumentar timeout de Feign a 5 segundos
3. Configurar connection pool MySQL (max 100)

### Importantes (Primeros 30 días)
4. Agregar caché Redis para productos
5. Implementar rate limiting
6. Mejorar mensajes de error en frontend

### Opcionales (Mejora continua)
7. Agregar tooltips de ayuda
8. Implementar lazy loading
9. Optimizar bundle size de frontend

## Anexos
- Cuestionarios completos de usabilidad
- Gráficos de rendimiento
- Logs de pruebas de integración
- Código fuente de tests
```

---

## 🛠️ Herramientas Complementarias

### Monitoreo en Tiempo Real
- **Grafana + Prometheus**: Métricas de sistema
- **Sentry**: Error tracking
- **New Relic / Datadog**: APM (Application Performance Monitoring)

### Análisis de Código
- **SonarQube**: Calidad de código
- **JaCoCo**: Cobertura de tests
- **OWASP Dependency Check**: Vulnerabilidades

### CI/CD Integration
```yaml
# .github/workflows/tests.yml
name: Run All Tests

on: [push, pull_request]

jobs:
  integration-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Set up JDK 17
        uses: actions/setup-java@v3
        with:
          java-version: '17'
      - name: Run Integration Tests
        run: mvn verify
      - name: Upload Coverage
        uses: codecov/codecov-action@v3

  performance-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run k6 Load Tests
        run: k6 run pruebas/rendimiento/scripts/load-test.js
```

---

**Documento preparado para**: Trabajo de Titulación  
**Proyecto**: ECommerce Siachos  
**Fecha**: Enero 2026  
**Versión**: 1.0
