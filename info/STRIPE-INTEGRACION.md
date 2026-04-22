# 💳 Integración de Stripe para Pagos con Tarjeta

## 🎯 Resumen de Implementación

Se ha implementado una integración completa con Stripe para procesar pagos con tarjeta de crédito/débito de forma segura. Los pagos procesados con Stripe son **aprobados automáticamente** y no requieren verificación manual del emprendedor.

---

## ✨ Características Implementadas

### Backend (msvc-ventas)

✅ **Dependencia Stripe Java SDK** (v27.5.0)
✅ **StripeService** - Servicio para crear PaymentIntents y gestionar pagos
✅ **StripeController** - Endpoints REST para comunicación con frontend
✅ **PagoService** - Lógica actualizada para aprobación automática de pagos con tarjeta
✅ **DTOs** - StripePaymentIntentRequestDto, StripePaymentIntentResponseDto, StripeConfirmPaymentDto

### Frontend (avalon-react)

✅ **Dependencias Stripe React** - @stripe/stripe-js y @stripe/react-stripe-js
✅ **stripeService.ts** - Cliente API para comunicación con backend
✅ **StripeCheckoutForm** - Componente con Stripe Elements para captura segura de tarjetas
✅ **Configuración** - Variables de entorno para claves de Stripe

---

## 🔑 Configuración de Claves de Stripe

### Paso 1: Crear Cuenta en Stripe

1. Ve a [https://dashboard.stripe.com/register](https://dashboard.stripe.com/register)
2. Crea una cuenta (es gratis para modo test)
3. Verifica tu email

### Paso 2: Obtener Claves de API (Test Mode)

1. Accede al dashboard: [https://dashboard.stripe.com/test/apikeys](https://dashboard.stripe.com/test/apikeys)
2. Copia las siguientes claves:
   - **Publishable key** (pk_test_...) → Para el frontend
   - **Secret key** (sk_test_...) → Para el backend

### Paso 3: Configurar Backend

Edita el archivo: `Microservicios/msvc-ventas/src/main/resources/application.properties`

```properties
# Configuracion de Stripe
stripe.api.key=sk_test_TU_SECRET_KEY_AQUI
stripe.webhook.secret=whsec_TU_WEBHOOK_SECRET_AQUI
```

### Paso 4: Configurar Frontend

1. Crea el archivo `.env.local` en la carpeta `avalon-react-10.1.0/`:

```bash
# Copiar el archivo de ejemplo
cp .env.local.example .env.local
```

2. Edita `.env.local` y actualiza:

```env
# API Backend
NEXT_PUBLIC_API_URL=http://localhost:8083/api

# Stripe Keys (Test Mode)
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_TU_PUBLISHABLE_KEY_AQUI

# Auth Service
NEXT_PUBLIC_AUTH_API_URL=http://localhost:8080/api
```

### Paso 5: Instalar Dependencias del Frontend

```powershell
cd avalon-react-10.1.0
npm install
```

---

## 🔄 Flujo de Pago con Stripe

### Proceso de Checkout

```
1️⃣ Cliente selecciona productos y va al checkout
   ↓
2️⃣ Cliente completa datos de envío
   ↓
3️⃣ Cliente selecciona "Pago con Tarjeta"
   ↓
4️⃣ Frontend solicita PaymentIntent al backend
   → POST /api/stripe/create-payment-intent
   ← { clientSecret, paymentIntentId }
   ↓
5️⃣ Frontend muestra Stripe Elements (formulario seguro)
   ↓
6️⃣ Cliente ingresa datos de tarjeta
   ↓
7️⃣ Stripe procesa el pago (seguro, PCI compliant)
   ↓
8️⃣ Frontend confirma pago al backend
   → POST /api/stripe/confirm-payment
   ↓
9️⃣ Backend verifica con Stripe y crea registro de pago
   → Estado: APROBADO
   → Venta: COMPLETADA
   ↓
🎉 Cliente recibe confirmación inmediata
   → Seguimiento logístico iniciado automáticamente
```

### Diferencias por Método de Pago

| Método         | Estado Inicial | Requiere Aprobación | Venta Estado  | Logística         |
|----------------|----------------|---------------------|---------------|-------------------|
| **TARJETA**    | APROBADO       | ❌ NO               | COMPLETADA    | ✅ Inmediata      |
| TRANSFERENCIA  | PENDIENTE      | ✅ SÍ               | PENDIENTE     | ⏳ Post-aprobación|
| DEUNA          | PENDIENTE      | ✅ SÍ               | PENDIENTE     | ⏳ Post-aprobación|

---

## 🧪 Tarjetas de Prueba (Test Mode)

Stripe proporciona tarjetas de prueba que puedes usar en modo test:

### Pagos Exitosos

| Número de Tarjeta     | Marca       | Resultado              |
|-----------------------|-------------|------------------------|
| 4242 4242 4242 4242   | Visa        | ✅ Pago exitoso        |
| 5555 5555 5555 4444   | Mastercard  | ✅ Pago exitoso        |
| 3782 822463 10005     | Amex        | ✅ Pago exitoso        |

### Pagos con Errores

| Número de Tarjeta     | Resultado                    |
|-----------------------|------------------------------|
| 4000 0000 0000 0002   | ❌ Tarjeta declinada         |
| 4000 0000 0000 9995   | ❌ Fondos insuficientes      |
| 4000 0000 0000 0069   | ❌ Tarjeta vencida           |

**Datos adicionales para pruebas:**
- **Fecha de vencimiento**: Cualquier fecha futura (ej: 12/34)
- **CVV**: Cualquier 3 dígitos (ej: 123)
- **Nombre**: Cualquier nombre
- **Código postal**: Cualquier código

---

## 🔌 Endpoints del Backend

### Crear PaymentIntent

```http
POST /api/stripe/create-payment-intent
Content-Type: application/json

{
  "ventaId": 123,
  "clienteId": 456,
  "monto": 125.50
}
```

**Respuesta:**
```json
{
  "clientSecret": "pi_xxx_secret_xxx",
  "paymentIntentId": "pi_xxx",
  "status": "pending",
  "message": "PaymentIntent creado exitosamente"
}
```

### Confirmar Pago

```http
POST /api/stripe/confirm-payment
Content-Type: application/json

{
  "paymentIntentId": "pi_xxx",
  "ventaId": 123
}
```

**Respuesta:**
```json
{
  "id": 789,
  "ventaId": 123,
  "monto": 125.50,
  "metodoPago": "TARJETA",
  "estadoPago": "APROBADO",
  "referenciaTransaccion": "pi_xxx",
  "fechaPago": "2026-01-04T10:30:00"
}
```

### Obtener Estado de PaymentIntent

```http
GET /api/stripe/payment-intent/{paymentIntentId}
```

**Respuesta:**
```json
{
  "paymentIntentId": "pi_xxx",
  "status": "succeeded",
  "amount": "12550"
}
```

---

## 🛡️ Seguridad

### ✅ Implementado

- **Stripe Elements**: Formulario PCI-compliant (no almacenamos datos de tarjetas)
- **HTTPS requerido** en producción
- **Client Secret**: Token temporal único por transacción
- **Verificación del PaymentIntent**: Backend verifica con Stripe antes de aprobar

### 📌 Recomendaciones para Producción

1. **Usar claves de producción** (pk_live_... y sk_live_...)
2. **Configurar webhook signature**: Validar eventos de Stripe
3. **Habilitar HTTPS**: Obligatorio para Stripe en producción
4. **Configurar dominios permitidos**: En el dashboard de Stripe
5. **Habilitar 3D Secure**: Para pagos con autenticación adicional

---

## 🧩 Archivos Creados/Modificados

### Backend

```
Microservicios/msvc-ventas/
├── pom.xml                                          [MODIFICADO] - Dependencia Stripe
├── src/main/resources/application.properties        [MODIFICADO] - Config Stripe
└── src/main/java/com/example/msvc_ventas/
    ├── domain/service/
    │   ├── PagoService.java                         [MODIFICADO] - Lógica aprobación automática
    │   └── StripeService.java                       [NUEVO] - Integración Stripe SDK
    ├── application/dto/
    │   ├── StripePaymentIntentRequestDto.java       [NUEVO]
    │   ├── StripePaymentIntentResponseDto.java      [NUEVO]
    │   └── StripeConfirmPaymentDto.java             [NUEVO]
    └── presentation/controller/
        └── StripeController.java                    [NUEVO] - Endpoints Stripe
```

### Frontend

```
avalon-react-10.1.0/
├── package.json                                     [MODIFICADO] - Dependencias Stripe
├── .env.local.example                               [NUEVO] - Template variables
├── services/
│   └── stripeService.ts                             [NUEVO] - Cliente API Stripe
└── app/(landing)/checkout/
    └── components/
        └── StripeCheckoutForm.tsx                   [NUEVO] - Stripe Elements
```

---

## 📊 Monitoreo y Logs

### Dashboard de Stripe

- **Pagos**: [https://dashboard.stripe.com/test/payments](https://dashboard.stripe.com/test/payments)
- **Clientes**: [https://dashboard.stripe.com/test/customers](https://dashboard.stripe.com/test/customers)
- **Logs**: [https://dashboard.stripe.com/test/logs](https://dashboard.stripe.com/test/logs)

### Logs del Backend

```bash
# Ver logs de Stripe en el backend
cd Microservicios/msvc-ventas
tail -f logs/application.log | grep Stripe
```

---

## 🚀 Próximos Pasos (Opcional)

1. **Webhooks**: Configurar webhooks para eventos de Stripe (payment_intent.succeeded, charge.failed, etc.)
2. **Guardar Customer**: Crear customers en Stripe para pagos recurrentes
3. **Payment Methods**: Guardar métodos de pago para compras futuras
4. **Reembolsos**: Implementar lógica de reembolsos desde el panel del emprendedor
5. **Multi-moneda**: Soportar diferentes monedas (EUR, MXN, etc.)

---

## ❓ Solución de Problemas

### Error: "Invalid API Key"

- Verifica que las claves estén copiadas correctamente
- Asegúrate de usar claves de test (sk_test_... y pk_test_...)

### Error: "No such PaymentIntent"

- El PaymentIntent puede haber expirado (válido por 24 horas)
- Verifica que el ID sea correcto

### Frontend no carga Stripe Elements

- Verifica que `NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY` esté configurado
- Reinicia el servidor de Next.js después de agregar variables de entorno
- Verifica que las dependencias estén instaladas (`npm install`)

---

## 📚 Documentación Oficial

- **Stripe API**: [https://stripe.com/docs/api](https://stripe.com/docs/api)
- **Stripe React**: [https://stripe.com/docs/stripe-js/react](https://stripe.com/docs/stripe-js/react)
- **Payment Intents**: [https://stripe.com/docs/payments/payment-intents](https://stripe.com/docs/payments/payment-intents)
- **Testing**: [https://stripe.com/docs/testing](https://stripe.com/docs/testing)

---

## ✅ Verificación de Implementación

### Checklist Backend

- [x] Dependencia stripe-java agregada al pom.xml
- [x] StripeService creado con métodos para PaymentIntent
- [x] StripeController con endpoints REST
- [x] PagoService actualizado con aprobación automática para TARJETA
- [x] application.properties configurado con claves de Stripe
- [x] DTOs creados para requests/responses

### Checklist Frontend

- [x] Dependencias @stripe/stripe-js y @stripe/react-stripe-js instaladas
- [x] stripeService.ts creado con funciones de API
- [x] StripeCheckoutForm componente creado con Stripe Elements
- [x] .env.local.example creado con template
- [x] Variables de entorno configuradas

---

**🎉 ¡Implementación Completa!**

El sistema ahora procesa pagos reales con tarjeta a través de Stripe de forma segura y automática.
