📚 Manual Maestro de Integración: Payphone Payment Box (v2026)Este documento es una compilación exhaustiva de la documentación técnica de Payphone para la implementación de la White-Label Payment Box en entornos WEB, optimizada para frameworks como Next.js.1. Requisitos y Configuración de EntornoRequisitos AdministrativosCuenta Business: Es obligatorio tener una cuenta activa en Payphone Business. Rol de Desarrollador: Dentro de la cuenta Business, se debe crear un usuario con el rol de "Developer". Este usuario tendrá acceso exclusivo a las configuraciones técnicas y generación de credenciales. Conocimientos Básicos: Se requiere manejo de peticiones HTTP, formato JSON y autenticación mediante tokens o API keys. Configuración de Seguridad y DominiosEntorno WEB: La Payment Box está diseñada exclusivamente para entornos WEB (no disponible para apps móviles nativas directamente). Producción: Es indispensable contar con un dominio con certificado SSL válido (https://). Desarrollo/Pruebas: Se permite el uso de http://localhost sin certificado SSL. Restricción de Dominio: El sistema vincula la pasarela al dominio exacto configurado. Si se intenta ejecutar desde un dominio no autorizado, se mostrará un error de autorización. 2. Configuración en el Portal de DesarrolladoresPara obtener las credenciales, acceda a Payphone Developer y siga estos pasos: Crear Aplicación: Haga clic en "+ Add" y complete el formulario. Plataforma de Desarrollo: Seleccione la opción más similar (ej. PHP o Python) si Next.js no aparece. Tipo de Aplicación: Seleccione WEB para integrar la Payment Box. URL de Respuesta: Es la dirección a la que Payphone redirigirá al cliente tras el pago (ej. https://tudominio.com/pago/confirmacion). Credenciales: En la sección "Credentials", obtendrá el TOKEN (Bearer Token) y el StoreID. Ambos son necesarios para autenticar las peticiones a la API. 3. Implementación del Frontend (Fase de Preparación)Dependencias y ContenedoresPara incorporar el botón de pago, se requieren tres elementos: CSS: payphone-payment-box.css para el diseño visual. JavaScript SDK: payphone-payment-box.js para la lógica y control. HTML: Un tag <div> (normalmente con id="pp-button") donde aparecerá la pasarela. Diccionario de Parámetros de InicializaciónParámetroTipoReq.DescripcióntokenString✅Credencial Bearer Token generada en el portal. amountInt✅Valor total en centavos (ej: 1000 = $10.00). amountWithoutTaxInt✅Valor base que no graba impuestos. amountWithTaxInt❌Valor base que sí graba impuestos. taxInt❌Valor del impuesto aplicado. serviceInt❌Valor asociado al servicio prestado. tipInt❌Valor de la propina. clientTransactionIdString✅ID único de su sistema para seguimiento (máx. 50 caracteres). currencyString❌Código ISO 4217 (ej: "USD"). langString❌Idioma del formulario: "en" o "es" (por defecto). ⚠️ Advertencia de Seguridad: Los campos phoneNumber, email y documentId deben contener datos reales del tarjetahabiente para cada transacción. El uso de datos estáticos ("quemados") o falsos causa bloqueos de cuenta y rechazos por sospecha de fraude. 4. Fase de Confirmación (Backend Obligatorio)Tras el pago, el usuario es redirigido a la URL de Respuesta con dos parámetros en la query string: id (ID de Payphone) y clientTransactionId. El Flujo de Confirmación:Captura de Parámetros: El sistema debe leer el id y clientTransactionId de la URL. Petición POST: Se debe realizar una solicitud al método Confirm: URL: https://pay.payphonetodoesposible.com/api/button/V2/Confirm. Headers: Authorization: bearer YOUR_TOKEN y Content-type: application/json. Body (JSON): {"id": 12345, "clientTxId": "UNIQUE_ID"}. ‼️ Regla Crítica: Reversión Automática de 5 MinutosSi el sistema del comercio no ejecuta la confirmación dentro de los 5 minutos posteriores al pago, Payphone realizará una reversión automática de la transacción para evitar cargos indebidos o procesos incompletos. Códigos de Respuesta (statusCode):3: Transacción Aprobada. 2: Transacción Cancelada. 5. Reversiones (Devoluciones)Las reversiones permiten retornar los fondos al cliente en caso de errores o solicitudes de reembolso. Condiciones: Solo se pueden realizar el mismo día de la transacción, hasta las 20:00 horas (Ecuador). Seguridad: Se debe usar exactamente el mismo TOKEN con el que se creó la transacción original. Métodos de API:Por ID de Payphone: POST https://pay.payphonetodoesposible.com/api/Reverse con el body {"id": 33107661}. Por ID del Comercio: POST https://pay.payphonetodoesposible.com/api/Reverse/Client con el body {"clientId": "TU_ID"}. 6. Personalización de la Payment BoxSe pueden ajustar parámetros de visualización para adaptar la experiencia: defaultMethod: "card" (tarjetas) o "payphone" (billetera Payphone). showCardPayment / showPayphonePayment: true/false para mostrar u ocultar métodos específicos. showMainButton: Si se establece en false, se debe usar un botón externo vinculado mediante customButtonId. Esto permite que la pasarela deshabilite su botón personalizado mientras la transacción está en curso para evitar duplicidad. 7. Comparativa de EntornosCaracterísticaEntorno de Pruebas (TEST)Entorno de ProducciónPropósitoDesarrollo seguro sin cargos reales. Transacciones reales y transferencia de dinero. AprobaciónSiempre aprobadas (simulación). Conectadas directamente al sistema bancario real. TarjetasDatos ficticios o tarjetas reales (sin cargo). Solo datos reales del titular vinculados al banco. TestersPermite invitar usuarios para simular pagos desde la App. Abierto al público general.8. Ejemplos de Código (Consolidado)Confirmación con Fetch (JavaScript/Next.js)JavaScriptconst id = getQueryVariable('id'); // Función para extraer de la URL
const clientTxId = getQueryVariable('clientTransactionId');

const headers = {
"Content-Type": "application/json",
"Authorization": "Bearer YOUR_TOKEN",
"Referer": document.referrer
};

fetch("https://pay.payphonetodoesposible.com/api/button/V2/Confirm", {
method: "POST",
headers: headers,
body: JSON.stringify({ "id": id, "clientTxId": clientTxId })
})
.then(res => res.json())
.then(data => console.log(data)) // Procesar statusCode 3 o 2
.catch(error => console.error(error));
Respuesta Exitosa (JSON resumido)JSON{
"email": "[email protected]",
"cardType": "Credit",
"amount": 315,
"statusCode": 3,
"transactionStatus": "Approved",
"transactionId": 23178284,
"currency": "USD"
}
Reversión con jQueryJavaScript$.ajax({
url: "https://pay.payphonetodoesposible.com/api/Reverse",
type: "POST",
headers: {
"Content-Type": "application/json",
"Authorization": "Bearer YOUR_TOKEN"
},
data: JSON.stringify({ "id": 33107661 }),
success: function (response) { console.log(response); } // Devuelve true si es exitoso
});
