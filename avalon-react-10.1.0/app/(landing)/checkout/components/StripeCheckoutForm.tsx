'use client';

import React, { useState } from 'react';
import { loadStripe } from '@stripe/stripe-js';
import { Elements, PaymentElement, useStripe, useElements } from '@stripe/react-stripe-js';
import { Card } from 'primereact/card';
import { Button } from 'primereact/button';
import { ProgressSpinner } from 'primereact/progressspinner';
import { Message } from 'primereact/message';

// Inicializar Stripe con tu clave pública
const stripePromise = loadStripe(process.env.NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY || 'pk_test_YOUR_KEY');

interface StripeCheckoutFormProps {
    clientSecret: string;
    onSuccess: (paymentIntentId: string) => void;
    onError: (error: string) => void;
    monto: number;
}

const CheckoutForm: React.FC<{
    onSuccess: (paymentIntentId: string) => void;
    onError: (error: string) => void;
    monto: number;
}> = ({ onSuccess, onError, monto }) => {
    const stripe = useStripe();
    const elements = useElements();
    const [loading, setLoading] = useState(false);
    const [errorMessage, setErrorMessage] = useState<string | null>(null);

    const handleSubmit = async (event: React.FormEvent) => {
        event.preventDefault();

        if (!stripe || !elements) {
            return;
        }

        setLoading(true);
        setErrorMessage(null);

        try {
            const { error, paymentIntent } = await stripe.confirmPayment({
                elements,
                redirect: 'if_required',
            });

            if (error) {
                setErrorMessage(error.message || 'Error al procesar el pago');
                onError(error.message || 'Error desconocido');
            } else if (paymentIntent && paymentIntent.status === 'succeeded') {
                onSuccess(paymentIntent.id);
            }
        } catch (err: any) {
            setErrorMessage('Error inesperado al procesar el pago');
            onError(err.message || 'Error inesperado');
        } finally {
            setLoading(false);
        }
    };

    return (
        <form onSubmit={handleSubmit}>
            <Card className="mb-4">
                <div className="mb-4">
                    <h3 className="text-xl font-semibold mb-2">Información de Pago</h3>
                    <p className="text-600">
                        Total a pagar: <strong className="text-2xl">${monto.toFixed(2)}</strong>
                    </p>
                </div>

                {errorMessage && (
                    <Message severity="error" text={errorMessage} className="mb-3 w-full" />
                )}

                <PaymentElement />

                <div className="mt-4">
                    <Button
                        type="submit"
                        label={loading ? 'Procesando...' : `Pagar $${monto.toFixed(2)}`}
                        icon={loading ? 'pi pi-spin pi-spinner' : 'pi pi-credit-card'}
                        className="w-full p-button-lg"
                        disabled={!stripe || loading}
                    />
                </div>

                <div className="mt-3 text-center text-sm text-500">
                    <i className="pi pi-lock mr-1"></i>
                    Pago seguro procesado por Stripe
                </div>
            </Card>
        </form>
    );
};

const StripeCheckoutForm: React.FC<StripeCheckoutFormProps> = ({
    clientSecret,
    onSuccess,
    onError,
    monto
}) => {
    const options = {
        clientSecret,
        appearance: {
            theme: 'stripe' as const,
            variables: {
                colorPrimary: '#6366f1',
            },
        },
    };

    return (
        <Elements stripe={stripePromise} options={options}>
            <CheckoutForm onSuccess={onSuccess} onError={onError} monto={monto} />
        </Elements>
    );
};

export default StripeCheckoutForm;
