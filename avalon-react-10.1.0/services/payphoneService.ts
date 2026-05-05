export interface PayphoneConfirmRequest {
    id: number | string;
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
     * Confirma una transacción de Payphone llamando a la API de Next.js
     * @param data Datos de la transacción (id y clientTxId)
     */
    async confirmarPago(data: PayphoneConfirmRequest): Promise<PayphoneConfirmResponse> {
        try {
            const response = await fetch('/api/payphone/confirm', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(data),
            });

            const result = await response.json();

            if (!response.ok) {
                throw new Error(result.error || 'Error al confirmar el pago en el servidor local');
            }

            return result;
        } catch (error) {
            console.error('Error en PayphoneService.confirmarPago:', error);
            throw error;
        }
    }
}

const payphoneService = new PayphoneService();
export default payphoneService;
