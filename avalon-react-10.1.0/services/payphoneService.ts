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
    async confirmarPago(data: PayphoneConfirmRequest & { emprendedorId?: string }): Promise<PayphoneConfirmResponse> {
        console.log('[PayphoneService] Confirmando a través de nuestra API interna:', data);

        const response = await fetch("/api/payphone/confirm", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                id: data.id,
                clientTxId: data.clientTxId,
                emprendedorId: data.emprendedorId
            })
        });

        console.log('[PayphoneService] HTTP Status API interna:', response.status);

        if (!response.ok) {
            const errJson = await response.json().catch(() => ({}));
            console.error('[PayphoneService] Error detallado de la API:', {
                status: response.status,
                error: errJson.error,
                details: errJson.details,
                fullResponse: errJson
            });
            throw new Error(errJson.error || `Error al confirmar el pago (HTTP ${response.status})`);
        }


        return await response.json() as PayphoneConfirmResponse;
    }

}

const payphoneService = new PayphoneService();
export default payphoneService;
