'use client';

import React, { useEffect, useState, useRef } from 'react';
import { Card } from 'primereact/card';
import { ProgressSpinner } from 'primereact/progressspinner';

// Para TypeScript, definimos globalmente el objeto payphone
declare global {
    interface Window {
        payphone: any;
    }
}

interface PayphoneFormProps {
    onDataChange: (data: any, isValid: boolean) => void;
    primaryColor: string;
    totalAmount: number;
    clienteData: any;
    cartItems: any[];
}

const PayphoneForm: React.FC<PayphoneFormProps> = ({
    onDataChange,
    primaryColor,
    totalAmount,
    clienteData,
    cartItems
}) => {
    const [scriptLoaded, setScriptLoaded] = useState(false);
    const [buttonRendered, setButtonRendered] = useState(false);
    const [errorMsg, setErrorMsg] = useState('');
    const buttonContainerRef = useRef<HTMLDivElement>(null);
    const renderAttempted = useRef(false);

    // Lógica para asignar los tokens del emprendedor correspondiente
    const [payphoneAppId, setPayphoneAppId] = useState('');
    const [payphoneToken, setPayphoneToken] = useState('');
    const [loadingTokens, setLoadingTokens] = useState(true);

    useEffect(() => {
        const fetchTokens = async () => {
            try {
                // Determinar el emprendedor_id (empresa.id). En tu seed coinciden.
                const emprendedorId = cartItems.length > 0 ? cartItems[0].producto?.empresa?.id : null;
                
                if (emprendedorId) {
                    const res = await fetch(`http://localhost:8084/api/emprendedor/configuracion-pagos/payphone/${emprendedorId}`);
                    if (res.ok) {
                        const data = await res.json();
                        if (data.payphoneAppId && data.payphoneToken) {
                            setPayphoneAppId(data.payphoneAppId);
                            setPayphoneToken(data.payphoneToken);
                            console.log(`[Payphone] Tokens obtenidos para el emprendedor ${emprendedorId}`);
                        }
                    }
                }
            } catch (error) {
                console.error('[Payphone] Error obteniendo tokens dinámicos:', error);
            } finally {
                setLoadingTokens(false);
            }
        };

        fetchTokens();
    }, [cartItems]);

    // Notificar al checkout que el método payphone está activo
    useEffect(() => {
        onDataChange({ ready: true, method: 'payphone' }, false);
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, []);

    // Respaldar datos del cliente en localStorage para la página de confirmación
    useEffect(() => {
        if (clienteData && Object.keys(clienteData).length > 0) {
            const saveLocal = async () => {
                const service = (await import('../../../../services/clientesService')).default;
                service.guardarDatosClienteLocal(clienteData);
                console.log('[PayphoneForm] Datos del cliente respaldados para confirmación');
            };
            saveLocal();
        }
    }, [clienteData]);

    // Cargar el script del SDK de Payphone
    useEffect(() => {
        if (loadingTokens) return;

        if (!payphoneAppId) {
            setErrorMsg('El App ID de Payphone no está configurado para este emprendedor. Contacta al administrador.');
            return;
        }

        const existingScript = document.getElementById('payphone-script');
        if (existingScript) {
            if (window.payphone) {
                setScriptLoaded(true);
            } else {
                const timer = setTimeout(() => setScriptLoaded(true), 500);
                return () => clearTimeout(timer);
            }
            return;
        }

        // ⚠️ CRÍTICO: NO usar type="module". Los scripts tipo "module" tienen
        // scope propio y NO exponen window.payphone globalmente.
        const script = document.createElement('script');
        script.id = 'payphone-script';
        script.src = `https://pay.payphonetodoesposible.com/api/button/js?appId=${payphoneAppId}`;
        // NO se pone script.type = 'module' — eso rompe el scope global

        script.onload = () => {
            // Dar margen para que el SDK inicialice window.payphone
            setTimeout(() => {
                console.log('[Payphone] Script cargado. window.payphone disponible:', !!window.payphone);
                setScriptLoaded(true);
            }, 300);
        };

        script.onerror = () => {
            setErrorMsg('No se pudo cargar el SDK de Payphone. Verifica tu conexión o el App ID.');
        };

        document.body.appendChild(script);
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, [payphoneAppId, loadingTokens]);

    // Renderizar el botón cuando el script esté listo
    useEffect(() => {
        if (!scriptLoaded || buttonRendered || renderAttempted.current) return;
        if (!buttonContainerRef.current) return;

        if (!window.payphone) {
            setErrorMsg('El SDK de Payphone cargó pero no inicializó. Recarga la página.');
            return;
        }

        if (!payphoneToken) {
            setErrorMsg('El Token de Payphone no está configurado para este emprendedor. Contacta al administrador.');
            return;
        }

        renderAttempted.current = true;

        try {
            const uniqueTxId = `ORD-${Date.now()}`;
            const amountInCents = Math.round(totalAmount * 100);
            const responseUrl = `${window.location.origin}/checkout/payphone-confirmacion`;

            console.log('[Payphone] Inicializando botón:', { amount: amountInCents, responseUrl });

            window.payphone.Button({
                token: payphoneToken,
                btnHorizontal: true,
                btnCard: true,
                createOrder: function(actions: any) {
                    return actions.prepare({
                        amount: amountInCents,
                        amountWithoutTax: amountInCents,
                        amountWithTax: 0,
                        tax: 0,
                        service: 0,
                        tip: 0,
                        currency: 'USD',
                        clientTransactionId: uniqueTxId,
                        lang: 'es',
                        responseUrl: responseUrl,
                    });
                },
                onComplete: function(model: any) {
                    if (model && model.id && model.clientTxId) {
                        window.location.href = `/checkout/payphone-confirmacion?id=${model.id}&clientTransactionId=${model.clientTxId}`;
                    }
                },
                onError: function(err: any) {
                    console.error('[Payphone] Error en el pago:', err);
                }
            }).render('#pp-button');

            setButtonRendered(true);
        } catch (error: any) {
            console.error('[Payphone] Error al renderizar el botón:', error);
            setErrorMsg(`Error al inicializar Payphone: ${error?.message || error}`);
            renderAttempted.current = false;
        }
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, [scriptLoaded, buttonRendered]);

    return (
        <Card className="mb-4">
            <div className="p-4 text-center">
                <i className="pi pi-mobile text-6xl mb-3" style={{ color: '#f97316' }}></i>
                <h3 className="text-xl font-semibold mb-2">Pago con Payphone</h3>
                <p className="text-600 mb-4">
                    Selecciona tu forma de pago para continuar con la compra de forma segura.
                </p>

                {/* Estado: Cargando */}
                {!scriptLoaded && !errorMsg && (
                    <div className="flex align-items-center justify-content-center flex-column py-3">
                        <ProgressSpinner style={{ width: '35px', height: '35px' }} strokeWidth="4" />
                        <small className="mt-2 text-600">Cargando pasarela segura de Payphone...</small>
                    </div>
                )}

                {/* Estado: Error */}
                {errorMsg && (
                    <div className="p-3 border-round text-sm" style={{ background: '#fff3f3', border: '1px solid #f5c6cb', color: '#721c24' }}>
                        <i className="pi pi-exclamation-triangle mr-2"></i>
                        {errorMsg}
                    </div>
                )}

                {/* Contenedor oficial del SDK — siempre en el DOM */}
                <div
                    id="pp-button"
                    ref={buttonContainerRef}
                    className="flex justify-content-center w-full mt-2"
                    style={{ minHeight: scriptLoaded && !errorMsg ? '60px' : '0px' }}
                ></div>

                <div className="mt-4 text-sm text-500">
                    <i className="pi pi-lock mr-1"></i>
                    Tus datos de pago están encriptados y protegidos por Payphone.
                </div>
            </div>
        </Card>
    );
};

export default PayphoneForm;
