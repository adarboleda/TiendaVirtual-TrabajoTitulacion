'use client';

import React from 'react';
import { Card } from 'primereact/card';

const ADMIN_EMAIL = process.env.NEXT_PUBLIC_ADMIN_EMAIL || 'soporte@ecommerce.com';
const ADMIN_PHONE_DISPLAY = '+593 3 271-4242';
const ADMIN_PHONE_TEL = '+593327144242';

/**
 * Página de Ayuda y Soporte, compartida entre los paneles de Emprendedor
 * y Administrador.
 */
export default function AyudaSoporte() {
    return (
        <div className="grid">
            <div className="col-12 lg:col-8 lg:col-offset-2">
                <Card className="shadow-3">
                    <div className="flex align-items-center gap-3 mb-4">
                        <div
                            className="flex align-items-center justify-content-center border-circle text-white flex-shrink-0"
                            style={{ width: '48px', height: '48px', backgroundColor: 'var(--primary-color)' }}
                        >
                            <i className="pi pi-question-circle text-2xl"></i>
                        </div>
                        <h2 className="m-0 text-2xl font-bold text-900">Ayuda y Soporte</h2>
                    </div>

                    <p className="text-600 mb-4">
                        ¿Tienes dudas sobre tu tienda, tus ventas o la configuración de pagos? Contáctanos directamente:
                    </p>

                    <div className="flex flex-column gap-3">
                        <a
                            href={`mailto:${ADMIN_EMAIL}`}
                            className="flex align-items-center gap-3 p-3 border-round no-underline"
                            style={{ backgroundColor: 'var(--surface-100)', color: 'var(--text-color)' }}
                        >
                            <i className="pi pi-envelope text-xl" style={{ color: 'var(--primary-color)' }}></i>
                            <div>
                                <div className="font-semibold">Correo electrónico</div>
                                <div className="text-600 text-sm">{ADMIN_EMAIL}</div>
                            </div>
                        </a>

                        <a
                            href={`tel:${ADMIN_PHONE_TEL}`}
                            className="flex align-items-center gap-3 p-3 border-round no-underline"
                            style={{ backgroundColor: 'var(--surface-100)', color: 'var(--text-color)' }}
                        >
                            <i className="pi pi-phone text-xl" style={{ color: 'var(--primary-color)' }}></i>
                            <div>
                                <div className="font-semibold">Teléfono</div>
                                <div className="text-600 text-sm">{ADMIN_PHONE_DISPLAY}</div>
                            </div>
                        </a>
                    </div>

                    <div
                        className="text-sm text-600 p-3 border-round flex align-items-start gap-2 mt-4"
                        style={{ backgroundColor: 'var(--surface-100)', border: '1px solid var(--surface-border)' }}
                    >
                        <i className="pi pi-info-circle mt-1" style={{ color: 'var(--primary-color)' }}></i>
                        <span>Horario de atención: Lunes a Viernes, 8:00 AM - 5:00 PM.</span>
                    </div>
                </Card>
            </div>
        </div>
    );
}
