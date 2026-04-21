'use client';

import React, { useState, useEffect } from 'react';
import { Card } from 'primereact/card';
import { ProgressBar } from 'primereact/progressbar';
import { Message } from 'primereact/message';
import { Button } from 'primereact/button';

interface PaymentSimulationProps {
    paymentMethod: 'transferencia' | 'tarjeta' | 'deuna';
    amount: number;
    onComplete: (success: boolean, transactionId?: string) => void;
    onCancel?: () => void;
}

const PaymentSimulation: React.FC<PaymentSimulationProps> = ({
    paymentMethod,
    amount,
    onComplete,
    onCancel
}) => {
    const [stage, setStage] = useState<'processing' | 'validating' | 'authorizing' | 'success' | 'error'>('processing');
    const [progress, setProgress] = useState(0);
    const [message, setMessage] = useState('Iniciando procesamiento...');
    const [transactionId, setTransactionId] = useState('');

    useEffect(() => {
        simulatePayment();
    }, []);

    const generateTransactionId = () => {
        const timestamp = Date.now();
        const random = Math.random().toString(36).substring(2, 10).toUpperCase();
        return `TXN-${timestamp}-${random}`;
    };

    const simulatePayment = async () => {
        const txnId = generateTransactionId();
        setTransactionId(txnId);

        // Etapa 1: Procesamiento inicial
        setStage('processing');
        setMessage('Procesando información del pago...');
        await animateProgress(0, 33, 1000);

        // Etapa 2: Validación
        setStage('validating');
        setMessage('Validando datos de la tarjeta...');
        await animateProgress(33, 66, 1500);

        // Etapa 3: Autorización
        setStage('authorizing');
        setMessage('Solicitando autorización bancaria...');
        await animateProgress(66, 90, 1500);

        // Simulación de éxito/fallo (95% éxito)
        const isSuccess = Math.random() < 0.95;

        if (isSuccess) {
            setMessage('Autorizando transacción...');
            await animateProgress(90, 100, 500);
            
            setStage('success');
            setMessage('¡Pago procesado exitosamente!');
            
            setTimeout(() => {
                onComplete(true, txnId);
            }, 2000);
        } else {
            setStage('error');
            setMessage('No se pudo procesar el pago. Intenta nuevamente.');
            setProgress(0);
        }
    };

    const animateProgress = (from: number, to: number, duration: number): Promise<void> => {
        return new Promise((resolve) => {
            const start = Date.now();
            const diff = to - from;

            const updateProgress = () => {
                const elapsed = Date.now() - start;
                const progress = Math.min(elapsed / duration, 1);
                const current = from + diff * progress;
                
                setProgress(Math.round(current));

                if (progress < 1) {
                    requestAnimationFrame(updateProgress);
                } else {
                    resolve();
                }
            };

            updateProgress();
        });
    };

    const getStageIcon = () => {
        switch (stage) {
            case 'processing':
                return 'pi-spin pi-spinner';
            case 'validating':
                return 'pi-spin pi-sync';
            case 'authorizing':
                return 'pi-spin pi-clock';
            case 'success':
                return 'pi-check-circle';
            case 'error':
                return 'pi-times-circle';
        }
    };

    const getStageColor = () => {
        switch (stage) {
            case 'success':
                return '#22c55e';
            case 'error':
                return '#ef4444';
            default:
                return '#3b82f6';
        }
    };

    const getStageMessage = () => {
        switch (stage) {
            case 'processing':
                return 'Conectando con el procesador de pagos...';
            case 'validating':
                return 'Verificando los datos de tu tarjeta...';
            case 'authorizing':
                return 'Esperando autorización del banco...';
            case 'success':
                return '¡Tu pago ha sido procesado con éxito!';
            case 'error':
                return 'Hubo un problema al procesar tu pago';
        }
    };

    return (
        <Card className="shadow-4">
            <div className="text-center p-5">
                {/* Icono animado */}
                <div className="mb-4">
                    <div
                        className="inline-flex align-items-center justify-content-center border-circle"
                        style={{
                            width: '120px',
                            height: '120px',
                            backgroundColor: `${getStageColor()}20`,
                            animation: stage === 'success' || stage === 'error' ? 'none' : 'pulse 1.5s ease-in-out infinite'
                        }}
                    >
                        <i
                            className={`pi ${getStageIcon()}`}
                            style={{
                                fontSize: '3rem',
                                color: getStageColor()
                            }}
                        ></i>
                    </div>
                </div>

                {/* Mensaje principal */}
                <h3 className="text-2xl font-bold mb-2" style={{ color: getStageColor() }}>
                    {getStageMessage()}
                </h3>

                <p className="text-600 mb-4">{message}</p>

                {/* Barra de progreso */}
                {stage !== 'success' && stage !== 'error' && (
                    <div className="mb-4">
                        <ProgressBar
                            value={progress}
                            showValue={false}
                            style={{ height: '10px' }}
                            color={getStageColor()}
                        ></ProgressBar>
                        <div className="text-sm text-600 mt-2">{progress}%</div>
                    </div>
                )}

                {/* Información de la transacción */}
                {stage !== 'error' && (
                    <div className="mb-4 p-3 border-round" style={{ backgroundColor: 'var(--surface-50)' }}>
                        <div className="grid text-left">
                            <div className="col-6">
                                <div className="text-xs text-600 mb-1">Monto</div>
                                <div className="font-semibold">${amount.toFixed(2)}</div>
                            </div>
                            <div className="col-6">
                                <div className="text-xs text-600 mb-1">ID Transacción</div>
                                <div className="font-semibold text-sm">{transactionId}</div>
                            </div>
                            <div className="col-12 mt-2">
                                <div className="text-xs text-600 mb-1">Método de pago</div>
                                <div className="font-semibold">
                                    {paymentMethod === 'tarjeta' && 'Tarjeta de Crédito/Débito'}
                                    {paymentMethod === 'transferencia' && 'Transferencia Bancaria'}
                                    {paymentMethod === 'deuna' && 'Deuna'}
                                </div>
                            </div>
                        </div>
                    </div>
                )}

                {/* Mensajes de estado */}
                {stage === 'success' && (
                    <Message
                        severity="success"
                        text="Tu compra se ha completado exitosamente. Recibirás un correo de confirmación en breve."
                        className="w-full justify-content-start"
                    />
                )}

                {stage === 'error' && (
                    <>
                        <Message
                            severity="error"
                            text="El pago no pudo ser procesado. Por favor, verifica los datos e intenta nuevamente."
                            className="w-full justify-content-start mb-3"
                        />
                        <div className="flex gap-2 justify-content-center">
                            <Button
                                label="Reintentar"
                                icon="pi pi-refresh"
                                onClick={() => {
                                    setStage('processing');
                                    setProgress(0);
                                    simulatePayment();
                                }}
                                severity="success"
                            />
                            {onCancel && (
                                <Button
                                    label="Cancelar"
                                    icon="pi pi-times"
                                    onClick={onCancel}
                                    severity="secondary"
                                    outlined
                                />
                            )}
                        </div>
                    </>
                )}

                {/* Mensaje de seguridad */}
                {stage !== 'success' && stage !== 'error' && (
                    <div className="mt-4 text-sm text-600">
                        <i className="pi pi-shield mr-2"></i>
                        Transacción segura y encriptada
                    </div>
                )}
            </div>

            <style jsx global>{`
                @keyframes pulse {
                    0%, 100% {
                        transform: scale(1);
                        opacity: 1;
                    }
                    50% {
                        transform: scale(1.05);
                        opacity: 0.8;
                    }
                }
            `}</style>
        </Card>
    );
};

export default PaymentSimulation;
