'use client';

import React, { useEffect, useState } from 'react';
import { Card } from 'primereact/card';
import { Button } from 'primereact/button';
import { Divider } from 'primereact/divider';
import authService from '../../../services/authService';
import RecuperarPasswordModal from '../auth/components/RecuperarPasswordModal';

interface CuentaPerfilProps {
    /** Etiqueta mostrada como rol (p. ej. "Emprendedor" o "Administrador") */
    rolLabel: string;
}

/**
 * Vista de "Mi Perfil / Información de la Cuenta", compartida entre los
 * paneles de Emprendedor y Administrador. Muestra los datos del usuario
 * autenticado y permite cambiar la contraseña (reutiliza el mismo flujo
 * seguro de código temporal que la recuperación desde el login).
 */
export default function CuentaPerfil({ rolLabel }: CuentaPerfilProps) {
    const [usuario, setUsuario] = useState<ReturnType<typeof authService.getUserInfo>>(null);
    const [cambiarPasswordVisible, setCambiarPasswordVisible] = useState(false);
    const [passwordActualizada, setPasswordActualizada] = useState(false);

    useEffect(() => {
        setUsuario(authService.getUserInfo());
    }, []);

    const iniciales = (usuario?.nombre?.[0] || usuario?.username?.[0] || '?').toUpperCase();

    return (
        <div className="grid">
            <div className="col-12 lg:col-8 lg:col-offset-2">
                <Card className="shadow-3">
                    <div className="flex align-items-center gap-3 mb-4">
                        <div
                            className="flex align-items-center justify-content-center border-circle text-white font-bold text-2xl flex-shrink-0"
                            style={{ width: '64px', height: '64px', backgroundColor: 'var(--primary-color)' }}
                        >
                            {iniciales}
                        </div>
                        <div>
                            <h2 className="m-0 text-2xl font-bold text-900">
                                {usuario?.nombre ? `${usuario.nombre} ${usuario.apellido || ''}` : usuario?.username || 'Mi Perfil'}
                            </h2>
                            <span className="text-600">{rolLabel}</span>
                        </div>
                    </div>

                    <Divider />

                    <h3 className="text-lg font-semibold text-900 mb-3">Información de la Cuenta</h3>
                    <div className="grid">
                        <div className="col-12 md:col-6">
                            <label className="block text-600 text-sm mb-1">Nombre de usuario</label>
                            <div className="text-900 font-medium p-3 border-round" style={{ backgroundColor: 'var(--surface-100)' }}>
                                {usuario?.username || '—'}
                            </div>
                        </div>
                        <div className="col-12 md:col-6">
                            <label className="block text-600 text-sm mb-1">Correo electrónico</label>
                            <div className="text-900 font-medium p-3 border-round" style={{ backgroundColor: 'var(--surface-100)' }}>
                                {usuario?.email || '—'}
                            </div>
                        </div>
                        <div className="col-12 md:col-6">
                            <label className="block text-600 text-sm mb-1">Nombre completo</label>
                            <div className="text-900 font-medium p-3 border-round" style={{ backgroundColor: 'var(--surface-100)' }}>
                                {usuario?.nombre || usuario?.apellido ? `${usuario?.nombre || ''} ${usuario?.apellido || ''}`.trim() : '—'}
                            </div>
                        </div>
                        <div className="col-12 md:col-6">
                            <label className="block text-600 text-sm mb-1">Rol</label>
                            <div className="text-900 font-medium p-3 border-round" style={{ backgroundColor: 'var(--surface-100)' }}>
                                {rolLabel}
                            </div>
                        </div>
                    </div>

                    <Divider />

                    <h3 className="text-lg font-semibold text-900 mb-3">Seguridad</h3>
                    {passwordActualizada && (
                        <div
                            className="p-3 mb-3 border-round text-green-700"
                            style={{ backgroundColor: '#ecfdf5', border: '1px solid #16a34a' }}
                        >
                            Tu contraseña fue actualizada exitosamente.
                        </div>
                    )}
                    <p className="text-600 mb-3">
                        Por seguridad, cambiar tu contraseña requiere verificar un código enviado a tu correo registrado.
                    </p>
                    <Button
                        label="Cambiar Contraseña"
                        icon="pi pi-key"
                        className="p-button-outlined"
                        onClick={() => setCambiarPasswordVisible(true)}
                    />
                </Card>
            </div>

            <RecuperarPasswordModal
                visible={cambiarPasswordVisible}
                onHide={() => setCambiarPasswordVisible(false)}
                initialUsername={usuario?.username}
                onSuccess={() => setPasswordActualizada(true)}
            />
        </div>
    );
}
