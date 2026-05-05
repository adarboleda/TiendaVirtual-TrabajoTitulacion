# 📚 Documentación Técnica: Payphone Payment Box (White-Label)

Guía completa y oficial de la integración de la **Cajita de Pagos Payphone** para entornos WEB, con ejemplos prácticos orientados a frameworks como Next.js y React.

---

## 1. ¿Qué es Payphone Payment Box?

La **Cajita de Pagos Payphone** es una solución de pago digital diseñada para facilitar transacciones seguras y ágiles entre empresas y clientes. Permite aceptar pagos con:

- 💳 Tarjetas de crédito y débito (Visa y MasterCard)
- 📱 Saldo Payphone (billetera digital)

Utiliza tecnologías estándar como HTML y JavaScript, lo que la hace fácil de integrar en cualquier página web.

---

## 2. Flujo de Integración

La integración se divide en **dos fases**:

### 🧩 Fase 1: Preparación (Frontend)
- Cargar el CSS y el JavaScript SDK de Payphone en la página.
- Inicializar la cajita con los datos de la transacción (monto, impuestos, token, etc.).
- Renderizar el botón de pago en un contenedor `<div>`.

### ✅ Fase 2: Confirmación (URL de Respuesta)
- Payphone redirige al usuario a tu URL de respuesta con parámetros en la URL.
- Tu sistema captura `id` y `clientTransactionId` de la URL.
- Se realiza un `POST` a la API de confirmación de Payphone para obtener el estado final de la transacción.

---

## 3. Requisitos Previos

### 🌐 Plataforma
- Exclusivo para entornos **WEB** (no disponible para apps móviles nativas).
- **Producción:** Requiere dominio con certificado SSL válido (`https://`).
- **Desarrollo/Pruebas:** Se permite `http://localhost` sin SSL.

> ⚠️ **Restricción de Dominio:** El SDK valida que la página que lo carga corresponda exactamente al dominio registrado en el portal. Si el dominio no coincide, se muestra un error de autorización.

### 🏢 Cuenta y Credenciales
- Cuenta **Payphone Business** activa.
- Usuario con rol de **Desarrollador** creado dentro de la cuenta Business.
- Credenciales obtenidas desde el [portal de desarrolladores de Payphone](https://developer.payphone.app/):
  - **TOKEN** — Bearer Token de autenticación.
  - **StoreId** — Identificador de la tienda.
  - **Identificador de Aplicación** — ID corto usado en la URL del script JS del SDK.

### 💻 Entorno de Desarrollo
- Editor de código (VSCode, WebStorm, etc.)
- Navegador actualizado con DevTools
- Conocimientos básicos de HTML, JavaScript y APIs REST

---

## 4. Implementación del Frontend

### 4.1 Dependencias (en el `<head>`)

```html
<link rel="stylesheet" href="https://cdn.payphonetodoesposible.com/box/v1.1/payphone-payment-box.css">
<script type="module" src="https://cdn.payphonetodoesposible.com/box/v1.1/payphone-payment-box.js"></script>
```

> ⚠️ **IMPORTANTE para React/Next.js:** El script del SDK (`payphone-payment-box.js`) usa `type="module"` cuando se referencia desde un `<link>` HTML estático, pero al cargarlo **dinámicamente con JavaScript** (`document.createElement('script')`), **NO se debe usar `type="module"`**. Los scripts de módulo tienen scope propio y no exponen `window.payphone` globalmente, lo que rompe la inicialización del botón.

### 4.2 Contenedor HTML

```html
<div id="pp-button"></div>
```

### 4.3 Script de Inicialización

```javascript
window.addEventListener('DOMContentLoaded', () => {
    ppb = new PPaymentButtonBox({
        token: 'YOUR_TOKEN',               // ❌ Requerido
        clientTransactionId: 'ORD-001',    // ❌ Requerido — Máx. 50 chars
        amount: 315,                       // ❌ Requerido — Total en centavos
        amountWithoutTax: 200,             // ❌ Requerido
        amountWithTax: 100,                // ✅ Opcional
        tax: 15,                           // ✅ Opcional
        service: 0,                        // ✅ Opcional
        tip: 0,                            // ✅ Opcional
        currency: "USD",                   // ✅ Opcional
        storeId: "YOUR_STORE_ID",          // ✅ Opcional
        reference: "Factura #001",         // ✅ Opcional — Máx. 100 chars
        lang: "es",                        // ✅ Opcional — "es" | "en"
        defaultMethod: "card",             // ✅ Opcional — "card" | "payphone"
        timeZone: -5,                      // ✅ Opcional
        lat: "-1.831239",                  // ✅ Opcional
        lng: "-78.183406",                 // ✅ Opcional
        // Datos del titular (opcionales pero recomendados — NO usar datos falsos)
        phoneNumber: "+593999999999",
        email: "cliente@correo.com",
        documentId: "1234567890",
        identificationType: 1              // 1=Cédula, 2=RUC, 3=Pasaporte
    }).render('pp-button');
});
```

### 4.4 Tabla de Parámetros de Inicialización

| Parámetro | Tipo | Req. | Descripción |
|-----------|------|------|-------------|
| `token` | String | ❌ | Bearer Token del portal Payphone Developer |
| `amount` | Int | ❌ | Total en centavos (ej: 1000 = $10.00). Suma de todos los demás montos |
| `amountWithoutTax` | Int | ❌ | Monto no sujeto a impuestos |
| `amountWithTax` | Int | ✅ | Base imponible (sin incluir el impuesto) |
| `tax` | Int | ✅ | Valor del impuesto aplicado |
| `service` | Int | ✅ | Monto del servicio |
| `tip` | Int | ✅ | Propina |
| `currency` | String | ✅ | ISO 4217, ej: "USD" |
| `clientTransactionId` | String | ❌ | ID único de tu sistema. Máx. 50 caracteres |
| `storeId` | String | ✅ | Identificador de tienda del portal |
| `reference` | String | ✅ | Referencia del pago. Máx. 100 caracteres |
| `phoneNumber` | String | ✅ | Teléfono del titular (formato: `+593999999999`) |
| `email` | String | ✅ | Correo del titular |
| `documentId` | String | ✅ | Número de identificación del titular |
| `identificationType` | Int | ✅ | 1=Cédula, 2=RUC, 3=Pasaporte |
| `lang` | String | ✅ | Idioma: "es" o "en" |
| `defaultMethod` | String | ✅ | Método por defecto: "card" o "payphone" |
| `timeZone` | Int | ✅ | Zona horaria (ej: -5) |
| `lat` / `lng` | String | ✅ | Coordenadas en formato decimal |

> 🛑 **Advertencia de Datos del Titular:** `phoneNumber`, `email` y `documentId` deben contener datos **reales del tarjetahabiente** para cada transacción. El uso de datos estáticos ("quemados") o falsos puede causar rechazos de transacciones y bloqueos de cuenta por sospecha de fraude.

### 4.5 Estructura HTML Completa

```html
<!DOCTYPE html>
<html lang="es">
<head>
    <link href="https://cdn.payphonetodoesposible.com/box/v1.1/payphone-payment-box.css" rel="stylesheet">
    <script type="module" src="https://cdn.payphonetodoesposible.com/box/v1.1/payphone-payment-box.js"></script>
</head>
<body>
    <div id="pp-button"></div>
    <script>
        window.addEventListener('DOMContentLoaded', () => {
            ppb = new PPaymentButtonBox({
                token: 'YOUR_TOKEN',
                clientTransactionId: 'UNIQUE_ID_X_TRANSACCION-001',
                amount: 315,
                amountWithoutTax: 200,
                amountWithTax: 100,
                tax: 15,
                currency: "USD",
                storeId: "YOUR_STOREID",
                reference: "Payment reference Fact#001"
            }).render('pp-button');
        });
    </script>
</body>
</html>
```

### 4.6 Consideraciones del Formulario

> ⏱️ **Duración:** Cada formulario tiene una validez de **10 minutos** desde que se carga. Si el usuario no paga en ese tiempo, el formulario caduca y debe generarse uno nuevo.

> 🔒 **Autorización por dominio:** El formulario solo funciona si se carga desde el dominio registrado en el portal. Si se accede desde otro dominio o con identidad oculta, la autorización será denegada.

---

## 5. Personalización (White-Label)

### 5.1 Parámetros de Visualización

| Parámetro | Tipo | Por defecto | Descripción |
|-----------|------|-------------|-------------|
| `defaultMethod` | String | `"card"` | Método visible al abrir: `"card"` o `"payphone"` |
| `showCardPayment` | Boolean | `true` | Muestra/oculta el pago con tarjeta |
| `showPayphonePayment` | Boolean | `true` | Muestra/oculta el pago con billetera Payphone |
| `showPaymentMethodSelector` | Boolean | `true` | Muestra/oculta el selector de método de pago |
| `showMainButton` | Boolean | `true` | Muestra/oculta el botón "Pagar" interno |
| `customButtonId` | String | — | ID del botón externo (solo si `showMainButton: false`) |
| `showFooter` | Boolean | `true` | Muestra/oculta el footer con logos |

### 5.2 Botón Personalizado

Si quieres controlar totalmente el botón de pago desde tu propio UI:

```html
<div id="pp-button"></div>
<button type="button" id="btnProcess">Pagar Ahora</button>
```

```javascript
const ppb = new PPaymentButtonBox({
    token: 'YOUR_TOKEN',
    clientTransactionId: 'UNIQUE-ID',
    storeId: 'YOUR_STOREID',
    amount: 315,
    amountWithoutTax: 315,
    showMainButton: false,      // Oculta el botón interno
    customButtonId: 'btnProcess' // Vincula tu botón externo
}).render('pp-button');

document.getElementById('btnProcess').addEventListener('click', () => {
    ppb.startProcessPayment();
});
```

### 5.3 Selector de Método Personalizado

```javascript
document.getElementById('btnCard').addEventListener('click', () => {
    ppb.changePaymentMethod('card');
});

document.getElementById('btnPayphone').addEventListener('click', () => {
    ppb.changePaymentMethod('payphone');
});
```

---

## 6. Confirmación de Pago (URL de Respuesta)

### 6.1 Parámetros en la URL de Respuesta

Tras el pago, Payphone redirige al usuario a tu URL de respuesta con dos parámetros:

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `id` | String/Int | ID único de la transacción asignado por Payphone |
| `clientTransactionId` | String | El mismo ID que enviaste en la inicialización |

Ejemplo de URL recibida:
```
https://tudominio.com/checkout/payphone-confirmacion?id=23178284&clientTransactionId=ORD-001
```

### 6.2 Endpoint de Confirmación

**⚠️ CRÍTICO:** La confirmación se debe ejecutar dentro de los **5 minutos** posteriores al pago. Si no se confirma, Payphone realiza una **reversión automática** de la transacción.

```
POST https://pay.payphonetodoesposible.com/api/button/V2/Confirm
```

**Headers requeridos:**
```
Content-Type: application/json
Authorization: Bearer YOUR_TOKEN
Referer: <URL de la página actual>
```

**Body (JSON):**
```json
{
    "id": "23178284",
    "clientTxId": "ORD-001"
}
```

> 📌 **Nota importante:** El campo `id` se envía como **string** (tal como llega de la URL). No es necesario convertirlo a número entero.

> 📌 **Nota sobre el Referer:** El header `Referer: document.referrer` es requerido por Payphone. Esto explica por qué la confirmación **debe hacerse desde el navegador (cliente)**, no desde un servidor de backend (que no tiene `document.referrer`).

### 6.3 Ejemplo de Confirmación con Fetch (JavaScript/Cliente)

```javascript
function getQueryVariable(variable) {
    var query = window.location.search.substring(1);
    var vars = query.split("&");
    for (var i = 0; i < vars.length; i++) {
        var pair = vars[i].split("=");
        if (pair[0] == variable) return pair[1];
    }
    return "0";
}

const id = getQueryVariable('id');
const clientTxId = getQueryVariable('clientTransactionId');

const headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer YOUR_TOKEN",
    "Referer": document.referrer  // ← Requerido
};

const bodyJSON = { "id": id, "clientTxId": clientTxId };

fetch("https://pay.payphonetodoesposible.com/api/button/V2/Confirm", {
    method: "POST",
    headers: headers,
    body: JSON.stringify(bodyJSON)
})
.then(res => res.json())
.then(data => {
    if (data.statusCode === 3) {
        console.log("✅ Pago aprobado:", data);
    } else if (data.statusCode === 2) {
        console.log("❌ Pago cancelado");
    }
})
.catch(error => console.error("Error:", error));
```

### 6.4 Respuesta Exitosa de Confirmación

```json
{
    "email": "aloy@mail.com",
    "cardType": "Credit",
    "bin": "530219",
    "lastDigits": "XX17",
    "cardBrand": "Mastercard Produbanco/Promerica",
    "amount": 315,
    "clientTransactionId": "UNIQUE_ID_X_TRANSACTION-001",
    "phoneNumber": "593999999999",
    "statusCode": 3,
    "transactionStatus": "Approved",
    "authorizationCode": "W23178284",
    "transactionId": 23178284,
    "document": "1234567890",
    "currency": "USD",
    "reference": "Payment for sale Fact#001",
    "storeName": "Payphone Store",
    "date": "2023-10-10T11:57:26.367",
    "regionIso": "EC",
    "transactionType": "Classic"
}
```

### 6.5 Tabla de Parámetros de Respuesta

| Campo | Descripción |
|-------|-------------|
| `statusCode` | **3** = Aprobada, **2** = Cancelada |
| `transactionStatus` | `"Approved"` o `"Cancelled"` |
| `transactionId` | ID de la transacción en Payphone |
| `clientTransactionId` | Tu ID enviado en la inicialización |
| `authorizationCode` | Código de autorización bancaria |
| `amount` | Total pagado (en centavos) |
| `cardType` | `"Credit"` o `"Debit"` |
| `cardBrand` | Marca y banco emisor (ej: "Mastercard Produbanco") |
| `bin` | Primeros 6 dígitos de la tarjeta |
| `lastDigits` | Últimos dígitos de la tarjeta |
| `email` | Correo registrado en el formulario |
| `phoneNumber` | Teléfono registrado en el formulario |
| `document` | Número de identificación registrado |
| `currency` | Moneda utilizada |
| `reference` | Referencia de la transacción |
| `storeName` | Nombre de la tienda |
| `date` | Fecha en formato ISO 8601 |
| `regionIso` | Código de país ISO 3166-1 (ej: "EC") |
| `deferred` | `true` si se usó diferido |
| `deferredCode` | Código de diferido |
| `message` | Mensaje de error, si aplica |
| `messageCode` | Código de mensaje |
| `optionalParameter4` | Nombre del titular (si pagó con tarjeta) |

---

## 7. Reversiones (Devoluciones)

Permite retornar los fondos al cliente en casos de error o reembolso.

**Condiciones:**
- Solo el mismo día de la transacción, hasta las **20:00 horas (Ecuador)**.
- Debe usarse exactamente el mismo TOKEN con el que se creó la transacción.

**Por ID de Payphone:**
```
POST https://pay.payphonetodoesposible.com/api/Reverse
Body: { "id": 33107661 }
```

**Por ID del Comercio:**
```
POST https://pay.payphonetodoesposible.com/api/Reverse/Client
Body: { "clientId": "TU_ID" }
```

---

## 8. Comparativa de Entornos

| Característica | Pruebas (TEST) | Producción (LIVE) |
|----------------|---------------|------------------|
| Propósito | Desarrollo sin cargos reales | Transacciones reales |
| Aprobaciones | Siempre aprobadas (simulación) | Conectado al sistema bancario real |
| Tarjetas | Ficticias o reales (sin cargo) | Solo datos reales del titular |
| Acceso | Permite invitar usuarios probadores | Abierto al público |
| SSL | No requerido (`localhost`) | Requerido (`https://`) |
