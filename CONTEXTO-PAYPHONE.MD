# Documentación Técnica: Cajita de Pagos Payphone (Actualizada 2024)

Este documento contiene la especificación técnica oficial y actualizada para la integración de la **Cajita de Pagos** (Payment Box) de Payphone.

---

## 1. 🧩 Fase de Preparación — Renderizar el Botón
Se requiere inyectar los recursos de Payphone en el `<head>` de la página:

```html
<link rel="stylesheet" href="https://cdn.payphonetodoesposible.com/box/v2.0/payphone-payment-box.css">
<script type="module" src="https://cdn.payphonetodoesposible.com/box/v2.0/payphone-payment-box.js"></script>
```

### Inicialización del Botón (JavaScript)
```javascript
ppb = new PPaymentButtonBox({
    token: 'TOKEN_DE_EMPRENDEDOR', // Generado en Payphone Developer
    clientTransactionId: 'ID_UNICO_LOCAL', 
    amount: 100, // En centavos (e.g., 100 = $1.00)
    amountWithoutTax: 100,
    currency: "USD",
    storeId: "TU_STOREID",
    reference: "Referencia del pago",
    lang: "es"
}).render('pp-button');
```

---

## 2. ✅ Fase de Confirmación (CRÍTICO)
Una vez que el usuario paga, Payphone redirige a tu **URL de Respuesta** con dos parámetros: `id` y `clientTransactionId`.

### 🔗 Endpoint Oficial de Confirmación (Cajita de Pagos)
> **IMPORTANTE:** Para la Cajita de Pagos, se debe usar el subdominio `paymentbox`.

*   **URL:** `https://paymentbox.payphonetodoesposible.com/api/confirm`
*   **Método:** `POST`
*   **Headers:**
    *   `Authorization: Bearer <TOKEN_DE_EMPRENDEDOR>`
    *   `Content-Type: application/json`
*   **Body (JSON):**
    ```json
    {
        "id": 86000000, 
        "clientTxId": "ID_UNICO_LOCAL"
    }
    ```
    *Nota: `id` debe ser un número entero. El campo se llama `clientTxId` en el cuerpo del JSON.*

### 🔙 Reverso Automático
Si no ejecutas esta confirmación en los **primeros 5 minutos** tras el pago, Payphone reversará la transacción automáticamente para proteger al cliente.

---

## 3. 🛡️ Consideraciones de Seguridad y Dominio
1.  **Dominio Autorizado:** La cajita solo carga si el dominio desde el que se llama coincide con el registrado en el portal de Payphone Developer.
2.  **Referrer-Policy:** Se recomienda configurar la política de referer como `origin` o `strict-origin-when-cross-origin` para permitir que Payphone valide el origen de la petición.
3.  **Localhost:** Se permite el uso de `http://localhost` para pruebas sin necesidad de SSL.

---

## 4. 📊 Estados de Respuesta
Al confirmar, recibirás un JSON con el detalle:
- `statusCode: 3` → **Aprobada** (Approved)
- `statusCode: 2` → **Cancelada** (Canceled)
- `transactionStatus`: Texto descriptivo del estado.
- `authorizationCode`: Código bancario si fue aprobada.

---

## 5. 🧪 Entorno de Pruebas
- Todas las transacciones en modo TEST se aprueban automáticamente.
- No se realizan cobros reales a tarjetas bancarias.
- Puedes usar la App de Payphone con usuarios configurados como "Probadores".

---
*Para más detalles, visita la documentación oficial en: [https://docs.payphone.app/cajita-de-pagos-payphone](https://docs.payphone.app/cajita-de-pagos-payphone)*
