'use client';

import React, { useState, useEffect } from 'react';
import { Card } from 'primereact/card';
import { InputText } from 'primereact/inputtext';
import { InputMask } from 'primereact/inputmask';
import { Message } from 'primereact/message';
import { Divider } from 'primereact/divider';
import { ProgressBar } from 'primereact/progressbar';

export interface CardData {
    cardNumber: string;
    cardName: string;
    cardExpiry: string;
    cardCvv: string;
}

interface TarjetaCreditoFormProps {
    onDataChange: (data: CardData, isValid: boolean) => void;
    primaryColor?: string;
}

const TarjetaCreditoForm: React.FC<TarjetaCreditoFormProps> = ({
    onDataChange,
    primaryColor = 'var(--primary-color)'
}) => {
    const [cardNumber, setCardNumber] = useState('');
    const [cardName, setCardName] = useState('');
    const [cardExpiry, setCardExpiry] = useState('');
    const [cardCvv, setCardCvv] = useState('');
    const [errors, setErrors] = useState<any>({});
    const [cardType, setCardType] = useState<'visa' | 'mastercard' | 'amex' | 'discover' | null>(null);

    useEffect(() => {
        detectCardType(cardNumber);
        validateForm();
    }, [cardNumber, cardName, cardExpiry, cardCvv]);

    const detectCardType = (number: string) => {
        const cleaned = number.replace(/\s/g, '');
        
        if (/^4/.test(cleaned)) {
            setCardType('visa');
        } else if (/^5[1-5]/.test(cleaned) || /^2[2-7]/.test(cleaned)) {
            setCardType('mastercard');
        } else if (/^3[47]/.test(cleaned)) {
            setCardType('amex');
        } else if (/^6(?:011|5)/.test(cleaned)) {
            setCardType('discover');
        } else {
            setCardType(null);
        }
    };

    const validateForm = () => {
        const newErrors: any = {};
        let isValid = true;

        // Validar número de tarjeta
        const cleanedNumber = cardNumber.replace(/\s/g, '');
        if (!cleanedNumber || cleanedNumber.length < 13 || cleanedNumber.length > 19) {
            newErrors.cardNumber = 'Número de tarjeta inválido';
            isValid = false;
        }

        // Validar nombre
        if (!cardName || cardName.trim().length < 3) {
            newErrors.cardName = 'Ingresa el nombre como aparece en la tarjeta';
            isValid = false;
        }

        // Validar fecha de expiración
        if (!cardExpiry || cardExpiry.length < 5) {
            newErrors.cardExpiry = 'Fecha inválida';
            isValid = false;
        } else {
            const [month, year] = cardExpiry.split('/');
            const currentYear = new Date().getFullYear() % 100;
            const currentMonth = new Date().getMonth() + 1;
            
            if (parseInt(month) < 1 || parseInt(month) > 12) {
                newErrors.cardExpiry = 'Mes inválido';
                isValid = false;
            } else if (parseInt(year) < currentYear || (parseInt(year) === currentYear && parseInt(month) < currentMonth)) {
                newErrors.cardExpiry = 'Tarjeta vencida';
                isValid = false;
            }
        }

        // Validar CVV
        if (!cardCvv || (cardCvv.length !== 3 && cardCvv.length !== 4)) {
            newErrors.cardCvv = 'CVV inválido';
            isValid = false;
        }

        setErrors(newErrors);

        onDataChange(
            {
                cardNumber,
                cardName,
                cardExpiry,
                cardCvv
            },
            isValid
        );
    };

    const formatCardNumber = (value: string) => {
        const cleaned = value.replace(/\s/g, '');
        const chunks = cleaned.match(/.{1,4}/g) || [];
        return chunks.join(' ');
    };

    const handleCardNumberChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const value = e.target.value.replace(/\s/g, '');
        if (value.length <= 19 && /^\d*$/.test(value)) {
            setCardNumber(formatCardNumber(value));
        }
    };

    const getCardIcon = () => {
        switch (cardType) {
            case 'visa':
                return 'pi-credit-card';
            case 'mastercard':
                return 'pi-credit-card';
            case 'amex':
                return 'pi-credit-card';
            case 'discover':
                return 'pi-credit-card';
            default:
                return 'pi-credit-card';
        }
    };

    const getCardColor = () => {
        switch (cardType) {
            case 'visa':
                return '#1A1F71';
            case 'mastercard':
                return '#EB001B';
            case 'amex':
                return '#006FCF';
            case 'discover':
                return '#FF6000';
            default:
                return '#3b82f6';
        }
    };

    return (
        <Card
            className="mt-4 shadow-3"
            style={{
                backgroundColor: 'var(--surface-card)',
                border: `1px solid ${primaryColor}20`
            }}
        >
            <div className="p-4">
                <div className="flex align-items-center mb-4">
                    <div
                        className="flex align-items-center justify-content-center border-circle mr-3"
                        style={{
                            backgroundColor: '#3b82f620',
                            color: '#3b82f6',
                            width: '40px',
                            height: '40px'
                        }}
                    >
                        <i className="pi pi-credit-card text-lg"></i>
                    </div>
                    <h4 className="text-xl font-bold m-0" style={{ color: '#3b82f6' }}>
                        Datos de la Tarjeta
                    </h4>
                </div>

                <Message
                    severity="success"
                    text="Tu información está protegida con encriptación de extremo a extremo"
                    className="mb-4 w-full"
                    icon="pi pi-shield"
                />

                {/* Tarjeta visual */}
                <div className="mb-4">
                    <div
                        className="border-round-xl p-4 shadow-4 relative overflow-hidden"
                        style={{
                            background: `linear-gradient(135deg, ${getCardColor()} 0%, ${getCardColor()}dd 100%)`,
                            minHeight: '200px',
                            color: 'white'
                        }}
                    >
                        {/* Chip de la tarjeta */}
                        <div className="mb-3">
                            <div
                                className="border-round"
                                style={{
                                    width: '50px',
                                    height: '40px',
                                    background: 'linear-gradient(135deg, #FFD700 0%, #FFA500 100%)',
                                    boxShadow: 'inset 0 2px 4px rgba(0,0,0,0.3)'
                                }}
                            ></div>
                        </div>

                        {/* Número de tarjeta */}
                        <div className="text-2xl font-mono mb-3 letter-spacing-2">
                            {cardNumber || '•••• •••• •••• ••••'}
                        </div>

                        {/* Nombre y fecha */}
                        <div className="flex justify-content-between align-items-end">
                            <div>
                                <div className="text-xs opacity-70 mb-1">TITULAR</div>
                                <div className="font-semibold text-sm">
                                    {cardName?.toUpperCase() || 'NOMBRE DEL TITULAR'}
                                </div>
                            </div>
                            <div>
                                <div className="text-xs opacity-70 mb-1">VENCE</div>
                                <div className="font-semibold text-sm">
                                    {cardExpiry || 'MM/AA'}
                                </div>
                            </div>
                        </div>

                        {/* Logo de la tarjeta */}
                        {cardType && (
                            <div
                                className="absolute"
                                style={{
                                    top: '20px',
                                    right: '20px',
                                    fontSize: '2rem',
                                    opacity: 0.9
                                }}
                            >
                                <i className={`pi ${getCardIcon()}`}></i>
                            </div>
                        )}

                        {/* Patrón decorativo */}
                        <div
                            className="absolute opacity-10"
                            style={{
                                bottom: '-30px',
                                right: '-30px',
                                fontSize: '150px'
                            }}
                        >
                            <i className="pi pi-credit-card"></i>
                        </div>
                    </div>
                </div>

                <Divider />

                {/* Formulario */}
                <div className="grid">
                    {/* Número de tarjeta */}
                    <div className="col-12">
                        <label htmlFor="cardNumber" className="block font-semibold mb-2">
                            <i className="pi pi-credit-card mr-2"></i>
                            Número de tarjeta *
                        </label>
                        <InputText
                            id="cardNumber"
                            value={cardNumber}
                            onChange={handleCardNumberChange}
                            placeholder="1234 5678 9012 3456"
                            className={`w-full ${errors.cardNumber ? 'p-invalid' : ''}`}
                            maxLength={23}
                        />
                        {errors.cardNumber && (
                            <small className="p-error block mt-1">
                                <i className="pi pi-exclamation-circle mr-1"></i>
                                {errors.cardNumber}
                            </small>
                        )}
                        {cardType && !errors.cardNumber && (
                            <small className="block mt-1" style={{ color: getCardColor() }}>
                                <i className="pi pi-check-circle mr-1"></i>
                                {cardType.toUpperCase()} detectada
                            </small>
                        )}
                    </div>

                    {/* Nombre del titular */}
                    <div className="col-12">
                        <label htmlFor="cardName" className="block font-semibold mb-2">
                            <i className="pi pi-user mr-2"></i>
                            Nombre del titular *
                        </label>
                        <InputText
                            id="cardName"
                            value={cardName}
                            onChange={(e) => setCardName(e.target.value.toUpperCase())}
                            placeholder="JUAN PEREZ"
                            className={`w-full ${errors.cardName ? 'p-invalid' : ''}`}
                            maxLength={50}
                        />
                        {errors.cardName && (
                            <small className="p-error block mt-1">
                                <i className="pi pi-exclamation-circle mr-1"></i>
                                {errors.cardName}
                            </small>
                        )}
                        <small className="block mt-1 text-600">
                            Ingresa el nombre exactamente como aparece en tu tarjeta
                        </small>
                    </div>

                    {/* Fecha de expiración */}
                    <div className="col-12 md:col-6">
                        <label htmlFor="cardExpiry" className="block font-semibold mb-2">
                            <i className="pi pi-calendar mr-2"></i>
                            Fecha de expiración *
                        </label>
                        <InputMask
                            id="cardExpiry"
                            value={cardExpiry}
                            onChange={(e) => setCardExpiry(e.value || '')}
                            mask="99/99"
                            placeholder="MM/AA"
                            className={`w-full ${errors.cardExpiry ? 'p-invalid' : ''}`}
                        />
                        {errors.cardExpiry && (
                            <small className="p-error block mt-1">
                                <i className="pi pi-exclamation-circle mr-1"></i>
                                {errors.cardExpiry}
                            </small>
                        )}
                    </div>

                    {/* CVV */}
                    <div className="col-12 md:col-6">
                        <label htmlFor="cardCvv" className="block font-semibold mb-2">
                            <i className="pi pi-lock mr-2"></i>
                            CVV / CVC *
                        </label>
                        <InputMask
                            id="cardCvv"
                            value={cardCvv}
                            onChange={(e) => setCardCvv(e.value || '')}
                            mask={cardType === 'amex' ? '9999' : '999'}
                            placeholder={cardType === 'amex' ? '1234' : '123'}
                            className={`w-full ${errors.cardCvv ? 'p-invalid' : ''}`}
                        />
                        {errors.cardCvv && (
                            <small className="p-error block mt-1">
                                <i className="pi pi-exclamation-circle mr-1"></i>
                                {errors.cardCvv}
                            </small>
                        )}
                        <small className="block mt-1 text-600">
                            <i className="pi pi-info-circle mr-1"></i>
                            {cardType === 'amex' 
                                ? '4 dígitos en el frente de la tarjeta' 
                                : '3 dígitos en la parte posterior'}
                        </small>
                    </div>
                </div>

                {/* Mensaje de seguridad */}
                <div className="mt-4 p-3 border-round" style={{ backgroundColor: '#3b82f610' }}>
                    <div className="flex align-items-start">
                        <i className="pi pi-shield text-xl mr-3" style={{ color: '#3b82f6' }}></i>
                        <div>
                            <div className="font-semibold mb-1" style={{ color: '#3b82f6' }}>
                                Pago 100% seguro
                            </div>
                            <div className="text-sm text-600">
                                Tu información está protegida con cifrado SSL de 256 bits. 
                                No almacenamos los datos de tu tarjeta.
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </Card>
    );
};

export default TarjetaCreditoForm;
