# Resumen Completo: Integración de Payphone en TiendaVirtual

Este documento detalla todos los archivos creados y modificados, los errores encontrados y las decisiones de implementación tomadas para integrar la pasarela de pagos **Payphone Payment Box** en el proyecto `avalon-react-10.1.0`.

---

## 1. Variables de Entorno

### Archivo: `avalon-react-10.1.0/.env.local`

Se añadieron las siguientes variables con el prefijo `NEXT_PUBLIC_` para que Next.js las exponga al cliente sin necesidad de quemar credenciales en el código fuente:

```env
NEXT_PUBLIC_PAYPHONE_APP_ID=<Identificador de Aplicación del portal>
NEXT_PUBLIC_PAYPHONE_TOKEN=<Bearer Token del portal>
```

> ⚠️ **Sobre el App ID:** El `NEXT_PUBLIC_PAYPHONE_APP_ID` es el **Identificador de Aplicación corto** que aparece en el portal de Payphone Developer. **No es el UUID largo** (`xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`). El UUID es el StoreId, que va en el parámetro `storeId` de la inicialización del botón. Si se usa el UUID en la URL del script, el SDK no carga y muestra error de red.

> ⚠️ **Seguridad:** Nunca subas este archivo a Git. Está en `.gitignore` por defecto en Next.js.

---

## 2. Archivos Creados (Nuevos)

### A. Página de Confirmación — URL de Respuesta
**Ruta:** `avalon-react-10.1.0/app/(main)/checkout/payphone-confirmacion/page.tsx`

Página a la que Payphone redirige al usuario tras el pago. Recibe `id` y `clientTransactionId` de la URL, llama al servicio de confirmación directamente desde el navegador y muestra éxito, cancelación o error.

- `statusCode === 3` → Pago aprobado: muestra pantalla verde y vacía el carrito.
- `statusCode === 2` → Pago cancelado: muestra pantalla amarilla.
- Otro caso → Error en la verificación.

### B. Componente del Botón de Payphone
**Ruta:** `avalon-react-10.1.0/app/(main)/checkout/components/PayphoneForm.tsx`

Componente React que se renderiza cuando el usuario selecciona "Payphone" en el checkout. Carga dinámicamente el SDK y renderiza el widget oficial.

### C. Servicio de Confirmación (Frontend)
**Ruta:** `avalon-react-10.1.0/services/payphoneService.ts`

Llama **directamente desde el navegador** al endpoint de confirmación de Payphone, incluyendo el header `Referer: document.referrer` que es requerido por Payphone.

### D. Endpoint de Backend (Respaldo, no utilizado en flujo principal)
**Ruta:** `avalon-react-10.1.0/app/api/payphone/confirm/route.ts`

Route Handler de Next.js con reintentos y logs de diagnóstico. No se usa en el flujo principal (la confirmación se hace desde el cliente), pero está disponible como referencia o para otros usos futuros.

---

## 3. Archivos Modificados

### A. Selector de Métodos de Pago
**Ruta:** `avalon-react-10.1.0/app/(main)/checkout/components/PaymentMethodSelector.tsx`
- Se añadió `'payphone'` al tipo TypeScript `PaymentMethod`.
- Se agregó la opción visual de Payphone con icono naranja y descripción.

### B. Página Principal de Checkout
**Ruta:** `avalon-react-10.1.0/app/(main)/checkout/page.tsx`
- Se importó `<PayphoneForm />` y se configuró para renderizarse cuando `selectedPaymentMethod === 'payphone'`.
- Se pasa `clienteData` al componente para tener acceso a los datos del cliente.
- El botón genérico "Pagar" del checkout queda deshabilitado con Payphone (el usuario usa el widget oficial).

---

## 4. Errores Encontrados y Soluciones

| # | Error | Causa Raíz | Solución Aplicada |
|---|-------|-----------|------------------|
| 1 | `c.warning is not a function` al presionar botón VISA | El script se cargaba con `type="module"`, lo que crea un scope aislado y no expone `window.payphone` globalmente | Se eliminó `script.type = 'module'` del elemento script dinámico en `PayphoneForm.tsx` |
| 2 | `Expected url to be http or https, got ""` al presionar botón App Payphone | Consecuencia del error #1: el SDK no recibía la `responseUrl` correctamente porque `window.payphone` no estaba inicializado | Se resolvió al corregir el tipo de script |
| 3 | `Maximum update depth exceeded` (bucle infinito de React) | El `useEffect` de notificación al padre incluía `onDataChange` como dependencia, que es una función nueva en cada render | Se separó en un `useEffect` independiente con array vacío `[]` |
| 4 | SDK no cargaba (error de red en script) | El `NEXT_PUBLIC_PAYPHONE_APP_ID` tenía el UUID/StoreId en lugar del Identificador de Aplicación corto que usa la URL del script CDN | Se verificó en el portal y se corrigió el valor en `.env.local` |
| 5 | `ConnectTimeoutError` en la ruta `/api/payphone/confirm` | La ruta de servidor de Next.js no podía conectarse a Payphone. La documentación oficial indica que la confirmación debe hacerse desde el navegador (incluye `Referer: document.referrer`) | Se migró la confirmación al frontend directamente en `payphoneService.ts`, tal como indica la documentación oficial de Payphone |
| 6 | La pantalla mostraba "Error en el Pago" aunque el pago sí se procesó | Consecuencia del error #5: la llamada fallaba y se mostraba error genérico | Resuelto con la migración al cliente; el pago se confirmó y apareció "¡Pago Exitoso!" |

---

## 5. Decisión Arquitectónica Clave: Confirmación desde el Cliente

La documentación oficial de Payphone muestra que la confirmación se hace **directamente desde el navegador**, no desde un servidor. Esto es por dos razones:

1. **El header `Referer: document.referrer` es requerido** — Solo el navegador tiene este dato.
2. **Payphone puede bloquear IPs de servidores** en entorno TEST.

Por eso el `payphoneService.ts` llama directamente a `https://pay.payphonetodoesposible.com/api/button/V2/Confirm` desde el cliente, usando el `NEXT_PUBLIC_PAYPHONE_TOKEN` (que ya es público por el prefijo `NEXT_PUBLIC_`).

---

## 6. Flujo Completo de Pago

```
[Checkout - Paso Pago]
         │
         ▼
  Usuario selecciona "Payphone"
         │
         ▼
  PayphoneForm.tsx carga el SDK desde CDN
  (sin type="module" para exponer window.payphone)
         │
         ▼
  Se renderiza el widget oficial (VISA / App Payphone)
         │
         ▼
  Usuario paga e ingresa sus datos en el widget
         │
         ▼
  Payphone procesa el pago en sus servidores
         │
         ▼
  Payphone redirige a:
  /checkout/payphone-confirmacion?id=X&clientTransactionId=Y
         │
         ▼
  payphoneService.ts llama DIRECTAMENTE a Payphone
  desde el navegador con Referer header (⏱ dentro de 5 min)
         │
      ┌──┴──┐
  ✅ Éxito    ❌ Error
  Vacía       Muestra
  carrito     mensaje
  Muestra     de error
  pantalla
  verde
```

---

## 7. Configuración en el Portal de Payphone Developer

Para que la integración funcione, verifica lo siguiente en [https://developer.payphone.app/](https://developer.payphone.app/):

| Campo | Desarrollo | Producción |
|-------|-----------|------------|
| **URL de Respuesta** | `http://localhost:3000/checkout/payphone-confirmacion` | `https://tudominio.com/checkout/payphone-confirmacion` |
| **Dominio permitido** | `localhost` | `https://tudominio.com` |
| **Entorno** | TEST | LIVE |

---

## 8. Archivos de Documentación del Proyecto

| Archivo | Descripción |
|---------|-------------|
| `CONTEXTO-PAYPHONE.MD` | Documentación técnica oficial completa de Payphone (parámetros, flujo, ejemplos, personalización) |
| `RESUMEN_INTEGRACION_PAYPHONE.md` | Este archivo — historial de implementación, errores resueltos y decisiones tomadas |
