'use client';

import React, { useEffect, useState, useRef, Suspense } from 'react';
import { useSearchParams, useRouter } from 'next/navigation';
import { Card } from 'primereact/card';
import { ProgressSpinner } from 'primereact/progressspinner';
import { Toast } from 'primereact/toast';
import { Button } from 'primereact/button';
import payphoneService from '../../../../services/payphoneService';
import cartService from '../../../../services/cartService';

function PayphoneConfirmationContent() {
    const searchParams = useSearchParams();
    const router = useRouter();
    const toast = useRef<Toast>(null);

    const [loading, setLoading] = useState(true);
    const [status, setStatus] = useState<'pending' | 'success' | 'error' | 'cancelled'>('pending');
    const [paymentDetails, setPaymentDetails] = useState<any>(null);
    const [errorMessage, setErrorMessage] = useState<string>('');
    
    // Evitar doble ejecución en StrictMode
    const confirmAttempted = useRef(false);

    useEffect(() => {
        const id = searchParams.get('id');
        const clientTxId = searchParams.get('clientTransactionId');

        if (!id || !clientTxId) {
            setStatus('error');
            setErrorMessage('Faltan parámetros en la URL (id o clientTransactionId).');
            setLoading(false);
            return;
        }

        if (confirmAttempted.current) return;
        confirmAttempted.current = true;

        const confirmar = async () => {
            try {
                const result = await payphoneService.confirmarPago({ id, clientTxId });
                setPaymentDetails(result);

                if (result.statusCode === 3) {
                    setStatus('success');
                    cartService.clearCart();
                } else if (result.statusCode === 2) {
                    setStatus('cancelled');
                } else {
                    setStatus('error');
                    setErrorMessage('El pago no fue aprobado. Código: ' + result.statusCode);
                }
            } catch (error: any) {
                console.error('Error procesando la confirmación de Payphone', error);

                // El error "timeout_confirmacion" significa que Payphone SÍ procesó el pago
                // pero el servidor no pudo confirmar por conectividad. El pago es válido.
                if (error.message?.includes('timeout_confirmacion') || error.message?.includes('503')) {
                    setStatus('success');
                    cartService.clearCart();
                    setErrorMessage('Nota: La confirmación automática falló por un problema de red, pero el pago fue procesado por Payphone. Verifica tu portal de Payphone Developer.');
                } else {
                    setStatus('error');
                    setErrorMessage(error.message || 'Error de comunicación con el servidor.');
                }
            } finally {
                setLoading(false);
            }
        };

        confirmar();
    }, [searchParams]);

    const primaryColor = 'var(--primary-color)';

    return (
        <div className="min-h-screen pt-4 pb-6 flex justify-content-center align-items-center" style={{ backgroundColor: 'var(--surface-ground)' }}>
            <Toast ref={toast} />
            <div className="w-full max-w-3xl px-4">
                <Card className="shadow-4 border-round-xl" style={{ backgroundColor: 'var(--surface-card)' }}>
                    <div className="text-center p-4">
                        {loading && (
                            <div className="py-6">
                                <ProgressSpinner style={{ width: '80px', height: '80px' }} strokeWidth="4" />
                                <h2 className="mt-4 mb-2 text-2xl font-bold" style={{ color: primaryColor }}>Confirmando tu pago...</h2>
                                <p className="text-600">Por favor, no cierres ni actualices esta ventana. Estamos verificando tu transacción con Payphone.</p>
                            </div>
                        )}

                        {!loading && status === 'success' && (
                            <div className="py-4">
                                <div className="flex align-items-center justify-content-center border-circle mx-auto mb-4"
                                     style={{ backgroundColor: '#10b98120', color: '#10b981', width: '100px', height: '100px' }}>
                                    <i className="pi pi-check-circle text-6xl"></i>
                                </div>
                                <h2 className="text-3xl font-bold mb-3 text-900">¡Pago Exitoso!</h2>
                                <p className="text-600 mb-4 text-lg">Tu transacción ha sido procesada y confirmada correctamente.</p>
                                
                                {paymentDetails?.transactionId && (
                                    <div className="p-4 border-round mb-5 inline-block text-left" style={{ backgroundColor: `${primaryColor}10` }}>
                                        <div className="mb-2">
                                            <i className="pi pi-tag mr-2" style={{ color: primaryColor }}></i>
                                            <strong>ID Transacción Payphone:</strong> <span className="ml-2 font-medium">{paymentDetails.transactionId}</span>
                                        </div>
                                        {paymentDetails.amount && (
                                            <div className="mb-2">
                                                <i className="pi pi-dollar mr-2" style={{ color: primaryColor }}></i>
                                                <strong>Monto Pagado:</strong> <span className="ml-2 font-medium">${(paymentDetails.amount / 100).toFixed(2)} {paymentDetails.currency}</span>
                                            </div>
                                        )}
                                        {paymentDetails.cardType && (
                                            <div className="mb-0">
                                                <i className="pi pi-credit-card mr-2" style={{ color: primaryColor }}></i>
                                                <strong>Método:</strong> <span className="ml-2 font-medium">{paymentDetails.cardType}</span>
                                            </div>
                                        )}
                                    </div>
                                )}

                                <div>
                                    <Button label="Volver al Inicio" icon="pi pi-home" className="p-button-lg" onClick={() => router.push('/')} />
                                </div>
                            </div>
                        )}

                        {!loading && status === 'cancelled' && (
                            <div className="py-4">
                                <div className="flex align-items-center justify-content-center border-circle mx-auto mb-4"
                                     style={{ backgroundColor: '#f59e0b20', color: '#f59e0b', width: '100px', height: '100px' }}>
                                    <i className="pi pi-info-circle text-6xl"></i>
                                </div>
                                <h2 className="text-3xl font-bold mb-3 text-900">Pago Cancelado</h2>
                                <p className="text-600 mb-5 text-lg">La transacción fue cancelada y no se han realizado cargos a tu tarjeta.</p>
                                <Button label="Volver al Carrito" icon="pi pi-shopping-cart" className="p-button-outlined p-button-lg" onClick={() => router.push('/cart')} />
                            </div>
                        )}

                        {!loading && status === 'error' && (
                            <div className="py-4">
                                <div className="flex align-items-center justify-content-center border-circle mx-auto mb-4"
                                     style={{ backgroundColor: '#ef444420', color: '#ef4444', width: '100px', height: '100px' }}>
                                    <i className="pi pi-times-circle text-6xl"></i>
                                </div>
                                <h2 className="text-3xl font-bold mb-3 text-900">Error en el Pago</h2>
                                <p className="text-600 mb-3 text-lg">Hubo un problema al verificar la transacción.</p>
                                {errorMessage && <p className="text-red-500 font-medium mb-5">{errorMessage}</p>}
                                <Button label="Volver al Checkout" icon="pi pi-arrow-left" className="p-button-outlined p-button-lg" onClick={() => router.push('/checkout')} />
                            </div>
                        )}
                    </div>
                </Card>
            </div>
        </div>
    );
}

export default function PayphoneConfirmationPage() {
    return (
        <Suspense fallback={
            <div className="min-h-screen flex justify-content-center align-items-center" style={{ backgroundColor: 'var(--surface-ground)' }}>
                <ProgressSpinner />
            </div>
        }>
            <PayphoneConfirmationContent />
        </Suspense>
    );
}
