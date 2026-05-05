import { NextResponse } from 'next/server';

export async function POST(request: Request) {
    try {
        const body = await request.json();
        const { id, clientTxId } = body;

        if (!id || !clientTxId) {
            return NextResponse.json({ error: 'Faltan parámetros requeridos (id o clientTxId)' }, { status: 400 });
        }

        const token = process.env.NEXT_PUBLIC_PAYPHONE_TOKEN || process.env.PAYPHONE_TOKEN;
        if (!token || token === 'AQUI_PON_TU_TOKEN_DE_PAYPHONE') {
            console.error('ERROR: El TOKEN de Payphone no está configurado en .env.local');
            return NextResponse.json({ error: 'Token de Payphone no configurado en el servidor' }, { status: 500 });
        }

        // Petición a Payphone para confirmar el pago
        const response = await fetch("https://pay.payphonetodoesposible.com/api/button/V2/Confirm", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Authorization": `Bearer ${token}`
            },
            body: JSON.stringify({ 
                id: parseInt(id), 
                clientTxId: clientTxId 
            })
        });

        if (!response.ok) {
            const errorData = await response.json().catch(() => null);
            console.error('Error desde Payphone:', response.status, errorData);
            return NextResponse.json({ 
                error: 'Error al comunicarse con Payphone', 
                details: errorData 
            }, { status: response.status });
        }

        const data = await response.json();
        return NextResponse.json(data);
        
    } catch (error) {
        console.error('Error al procesar la confirmación de Payphone:', error);
        return NextResponse.json({ error: 'Error interno del servidor' }, { status: 500 });
    }
}
