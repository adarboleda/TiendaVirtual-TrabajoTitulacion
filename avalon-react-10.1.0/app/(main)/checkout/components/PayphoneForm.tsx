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
    totalAmount: number; // Monto total en dólares
    clienteData: any; // Datos del cliente
}

const PayphoneForm: React.FC<PayphoneFormProps> = ({
    onDataChange,
    primaryColor,
    totalAmount,
    clienteData
}) => {
    const [scriptLoaded, setScriptLoaded] = useState(false);
    const [buttonRendered, setButtonRendered] = useState(false);
    const buttonContainerRef = useRef<HTMLDivElement>(null);

    // Leer valores directamente desde las variables de entorno configuradas
    const PAYPHONE_APP_ID = process.env.NEXT_PUBLIC_PAYPHONE_APP_ID || '';
    const PAYPHONE_TOKEN = process.env.NEXT_PUBLIC_PAYPHONE_TOKEN || '';

    useEffect(() => {
        // Marcamos el formulario como "inválido" para el botón "Pagar" principal de Next.js
        // para que el usuario deba hacer clic obligatoriamente en el botón de Payphone.
        onDataChange({ ready: true, method: 'payphone' }, false);

        // Función para cargar el SDK de Payphone
        const loadPayphoneScript = () => {
            // Si ya existe el script, no lo cargamos dos veces
            if (document.getElementById('payphone-script')) {
                setScriptLoaded(true);
                return;
            }

            const script = document.createElement('script');
            script.id = 'payphone-script';
            script.src = `https://pay.payphonetodoesposible.com/api/button/js?appId=${PAYPHONE_APP_ID}`;
            script.type = 'module';
            script.async = true;
            
            script.onload = () => {
                console.log('Script de Payphone cargado exitosamente');
                setScriptLoaded(true);
            };

            script.onerror = () => {
                console.error('Error al cargar el script de Payphone');
            };

            document.body.appendChild(script);
        };

        loadPayphoneScript();
        
        return () => {
            // Opcional: Limpieza al desmontar el componente si se requiere
        };
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, []); // IMPORTANTE: array vacío para evitar bucles infinitos por el cambio de onDataChange

    useEffect(() => {
        // Si el script ya cargó, el objeto window.payphone existe y no hemos renderizado el botón
        if (scriptLoaded && window.payphone && !buttonRendered && buttonContainerRef.current) {
            try {
                // Generar un ID único para la transacción
                const uniqueTxId = `ORD-${Date.now()}`;
                
                // Monto en centavos (ej: $10.00 -> 1000)
                const amountInCents = Math.round(totalAmount * 100);

                window.payphone.Button({
                    token: PAYPHONE_TOKEN,
                    btnHorizontal: true,
                    btnCard: true,
                    responseUrl: window.location.origin + "/checkout/payphone-confirmacion",
                    createOrder: function(txn: any) {
                        return txn.prepare({
                            amount: amountInCents,
                            amountWithoutTax: amountInCents,
                            amountWithTax: 0,
                            tax: 0,
                            service: 0,
                            tip: 0,
                            currency: "USD",
                            clientTransactionId: uniqueTxId,
                            lang: "es",
                            email: clienteData?.email || "correo@ejemplo.com",
                            documentId: clienteData?.documento || "0999999999",
                            phoneNumber: clienteData?.telefono || "0999999999",
                            responseUrl: window.location.origin + "/checkout/payphone-confirmacion",
                            storeId: PAYPHONE_APP_ID // En algunas versiones, pasar el appId como storeId también evita errores.
                        });
                    },
                    onComplete: function(model: any, btn: any) {
                        // Aunque Payphone V2 redirige automáticamente, 
                        // ponemos este callback de respaldo en caso de que la configuración lo requiera.
                        console.log("Pago completado, modelo retornado:", model);
                        if(model && model.id && model.clientTxId) {
                            window.location.href = `/checkout/payphone-confirmacion?id=${model.id}&clientTransactionId=${model.clientTxId}`;
                        }
                    }
                }).render("#pp-button");

                setButtonRendered(true);
            } catch (error) {
                console.error('Error al renderizar el botón de Payphone:', error);
            }
        }
    }, [scriptLoaded, buttonRendered, totalAmount, PAYPHONE_TOKEN]);

    return (
        <Card className="mb-4">
            <div className="p-4 text-center">
                <i className="pi pi-mobile text-6xl mb-3" style={{ color: '#f97316' }}></i>
                <h3 className="text-xl font-semibold mb-2">Pago con Payphone</h3>
                <p className="text-600 mb-4">
                    Haz clic en el botón inferior para abrir la pasarela segura y realizar tu pago.
                </p>

                {/* AQUÍ ES DONDE SE RENDERIZA EL BOTÓN DE PAYPHONE */}
                <div className="flex justify-content-center w-full min-h-4rem mb-3">
                    {!scriptLoaded && (
                        <div className="flex align-items-center flex-column">
                            <ProgressSpinner style={{width: '30px', height: '30px'}} strokeWidth="4" />
                            <small className="mt-2 text-600">Cargando pasarela segura...</small>
                        </div>
                    )}
                    
                    {/* Contenedor oficial requerido por el SDK */}
                    <div id="pp-button" ref={buttonContainerRef} className="w-full max-w-sm"></div>
                </div>

                <div className="mt-4 text-sm text-500">
                    <i className="pi pi-lock mr-1"></i>
                    Tus datos de pago están encriptados y protegidos por Payphone.
                </div>
            </div>
        </Card>
    );
};

export default PayphoneForm;
