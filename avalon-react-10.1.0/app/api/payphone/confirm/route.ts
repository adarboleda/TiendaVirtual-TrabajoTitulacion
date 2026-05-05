import { NextResponse } from 'next/server';

// Función auxiliar para hacer fetch con reintentos
async function fetchWithRetry(url: string, options: RequestInit, retries = 3, timeoutMs = 15000): Promise<Response> {
    for (let attempt = 1; attempt <= retries; attempt++) {
        const controller = new AbortController();
        const timeoutId = setTimeout(() => controller.abort(), timeoutMs);

        try {
            console.log(`[Payphone Confirm] Intento ${attempt}/${retries} → ${url}`);
            const response = await fetch(url, { ...options, signal: controller.signal });
            clearTimeout(timeoutId);
            return response;
        } catch (err: any) {
            clearTimeout(timeoutId);
            const isLastAttempt = attempt === retries;
            const isTimeout = err?.name === 'AbortError' || err?.cause?.code === 'UND_ERR_CONNECT_TIMEOUT';

            console.warn(`[Payphone Confirm] Intento ${attempt} fallido:`, err?.cause?.code || err?.message);

            if (isLastAttempt) throw err;

            // Esperar antes de reintentar (backoff)
            const delay = attempt * 2000; // 2s, 4s, 6s...
            console.log(`[Payphone Confirm] Reintentando en ${delay}ms...`);
            await new Promise(resolve => setTimeout(resolve, delay));
        }
    }
    throw new Error('Todos los reintentos agotados');
}

export async function POST(request: Request) {
    try {
        const body = await request.json();
        const { id, clientTxId } = body;

        console.log('[Payphone Confirm] Parámetros recibidos:', { id, clientTxId });

        if (!id || !clientTxId) {
            return NextResponse.json({ error: 'Faltan parámetros requeridos (id o clientTxId)' }, { status: 400 });
        }

        const token = process.env.NEXT_PUBLIC_PAYPHONE_TOKEN || process.env.PAYPHONE_TOKEN;
        if (!token || token === 'AQUI_PON_TU_TOKEN_DE_PAYPHONE') {
            console.error('[Payphone Confirm] TOKEN no configurado');
            return NextResponse.json({ error: 'Token de Payphone no configurado en el servidor' }, { status: 500 });
        }

        const payphoneBody = {
            id: parseInt(String(id)),
            clientTxId: String(clientTxId)
        };
        console.log('[Payphone Confirm] Enviando a Payphone:', payphoneBody);

        let response: Response;
        try {
            response = await fetchWithRetry(
                "https://pay.payphonetodoesposible.com/api/button/V2/Confirm",
                {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                        "Authorization": `Bearer ${token}`
                    },
                    body: JSON.stringify(payphoneBody)
                },
                3,    // 3 reintentos
                15000 // 15 segundos por intento
            );
        } catch (networkError: any) {
            // No se pudo conectar a Payphone después de todos los reintentos.
            // El pago YA FUE procesado por Payphone (el usuario fue redirigido por Payphone mismo).
            // Payphone revertirá solo si no confirmamos en 5 minutos, pero si el pago
            // ya aparece en el portal de Payphone, podemos registrarlo como aprobado.
            console.error('[Payphone Confirm] Error de red tras reintentos:', networkError?.cause?.code || networkError?.message);
            return NextResponse.json({
                error: 'timeout_confirmacion',
                message: 'No se pudo confirmar con Payphone por un problema de red, pero el pago puede haber sido procesado. Por favor verifica en el portal de Payphone.',
                id: String(id),
                clientTxId: String(clientTxId)
            }, { status: 503 });
        }

        // Leer siempre como texto para evitar errores de parseo
        const responseText = await response.text();
        console.log('[Payphone Confirm] HTTP Status:', response.status);
        console.log('[Payphone Confirm] Body raw:', responseText);

        if (!response.ok) {
            console.error('[Payphone Confirm] Error desde Payphone:', response.status, responseText);
            return NextResponse.json({
                error: 'Error al comunicarse con Payphone',
                details: responseText,
                httpStatus: response.status
            }, { status: response.status });
        }

        // Si Payphone responde 200 con body vacío (común con pagos por App Payphone)
        if (!responseText || responseText.trim() === '') {
            console.warn('[Payphone Confirm] Body vacío con HTTP 200 → Pago aprobado por App Payphone');
            return NextResponse.json({
                statusCode: 3,
                transactionStatus: 'Approved',
                message: 'Pago confirmado correctamente'
            });
        }

        // Intentar parsear como JSON
        try {
            const data = JSON.parse(responseText);
            console.log('[Payphone Confirm] Respuesta JSON:', data);
            return NextResponse.json(data);
        } catch {
            // HTTP 200 pero respuesta no es JSON válido — tratar como éxito
            console.warn('[Payphone Confirm] Respuesta no es JSON pero fue HTTP 200:', responseText);
            return NextResponse.json({
                statusCode: 3,
                transactionStatus: 'Approved',
                message: responseText
            });
        }

    } catch (error) {
        console.error('[Payphone Confirm] Error interno:', error);
        return NextResponse.json({ error: 'Error interno del servidor' }, { status: 500 });
    }
}
