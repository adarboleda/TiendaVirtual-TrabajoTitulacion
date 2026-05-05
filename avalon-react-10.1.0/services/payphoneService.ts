export interface PayphoneConfirmRequest {
    id: string;
    clientTxId: string;
}

export interface PayphoneConfirmResponse {
    email?: string;
    cardType?: string;
    amount?: number;
    statusCode?: number; // 3: Aprobado, 2: Cancelado
    transactionStatus?: string;
    transactionId?: number;
    currency?: string;
    message?: string;
    error?: string;
}

class PayphoneService {
    /**
     * Confirma una transacción de Payphone llamando DIRECTAMENTE desde el navegador,
     * tal como indica la documentación oficial de Payphone.
     * El token NEXT_PUBLIC_PAYPHONE_TOKEN ya es público (prefijo NEXT_PUBLIC_).
     */
    async confirmarPago(data: PayphoneConfirmRequest): Promise<PayphoneConfirmResponse> {
        const token = process.env.NEXT_PUBLIC_PAYPHONE_TOKEN;

        if (!token) {
            throw new Error('NEXT_PUBLIC_PAYPHONE_TOKEN no está configurado en .env.local');
        }

        const bodyJSON = {
            id: data.id,           // Se envía como string, tal como llega de la URL
            clientTxId: data.clientTxId
        };

        console.log('[PayphoneService] Confirmando directamente con Payphone:', bodyJSON);

        const response = await fetch("https://pay.payphonetodoesposible.com/api/button/V2/Confirm", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Authorization": `Bearer ${token}`,
                "Referer": document.referrer  // Requerido por Payphone según documentación oficial
            },
            body: JSON.stringify(bodyJSON)
        });

        console.log('[PayphoneService] HTTP Status:', response.status);

        if (!response.ok) {
            const errText = await response.text().catch(() => '');
            console.error('[PayphoneService] Error de Payphone:', response.status, errText);
            throw new Error(`Error al comunicarse con Payphone (HTTP ${response.status}): ${errText}`);
        }

        const responseText = await response.text();
        console.log('[PayphoneService] Respuesta raw:', responseText);

        // Payphone puede responder con body vacío en pagos vía App Payphone
        if (!responseText || responseText.trim() === '') {
            return { statusCode: 3, transactionStatus: 'Approved' };
        }

        return JSON.parse(responseText) as PayphoneConfirmResponse;
    }
}

const payphoneService = new PayphoneService();
export default payphoneService;
