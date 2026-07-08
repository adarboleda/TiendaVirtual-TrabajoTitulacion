'use client';

import React, { useState } from 'react';
import { Dialog } from 'primereact/dialog';
import { InputText } from 'primereact/inputtext';
import { Password } from 'primereact/password';
import { Button } from 'primereact/button';
import { Message } from 'primereact/message';
import authService from '../../../../services/authService';

interface RecuperarPasswordModalProps {
    visible: boolean;
    onHide: () => void;
    /** Se invoca cuando la contraseña fue restablecida con éxito */
    onSuccess?: () => void;
}

export default function RecuperarPasswordModal({ visible, onHide, onSuccess }: RecuperarPasswordModalProps) {
    const [username, setUsername] = useState('');
    const [email, setEmail] = useState('');
    const [nuevaPassword, setNuevaPassword] = useState('');
    const [confirmPassword, setConfirmPassword] = useState('');
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState('');
    const [success, setSuccess] = useState('');

    const resetForm = () => {
        setUsername('');
        setEmail('');
        setNuevaPassword('');
        setConfirmPassword('');
        setError('');
        setSuccess('');
    };

    const handleClose = () => {
        resetForm();
        onHide();
    };

    const handleSubmit = async () => {
        setError('');

        if (!username.trim()) {
            setError('El nombre de usuario es requerido');
            return;
        }
        if (!email.trim() || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
            setError('Ingresa el correo electrónico asociado a tu cuenta');
            return;
        }
        if (nuevaPassword.length < 6) {
            setError('La nueva contraseña debe tener al menos 6 caracteres');
            return;
        }
        if (nuevaPassword !== confirmPassword) {
            setError('Las contraseñas no coinciden');
            return;
        }

        setLoading(true);
        try {
            const result = await authService.recuperarPassword(
                username.trim(),
                email.trim().toLowerCase(),
                nuevaPassword
            );

            if (result.success) {
                setSuccess(result.message);
                setTimeout(() => {
                    handleClose();
                    onSuccess?.();
                }, 2500);
            } else {
                setError(result.message);
            }
        } finally {
            setLoading(false);
        }
    };

    const headerElement = (
        <div className="flex align-items-center gap-2">
            <i className="pi pi-key text-primary text-2xl"></i>
            <span className="font-bold text-xl">Recuperar Contraseña</span>
        </div>
    );

    return (
        <Dialog
            header={headerElement}
            visible={visible}
            onHide={handleClose}
            style={{ width: '95vw', maxWidth: '480px' }}
            modal
            className="p-fluid"
            closable={!loading}
        >
            <div className="flex flex-column gap-4 p-3">
                {error && <Message severity="error" text={error} />}
                {success && <Message severity="success" text={success} />}

                <div
                    className="text-sm text-600 p-3 border-round flex align-items-start gap-2"
                    style={{ backgroundColor: 'var(--surface-100)', border: '1px solid var(--surface-border)' }}
                >
                    <i className="pi pi-info-circle mt-1" style={{ color: 'var(--primary-color)' }}></i>
                    <span>
                        Ingresa tu usuario y el correo con el que te registraste para definir una nueva contraseña.
                        Si creaste tu cuenta con Google, simplemente usa el botón <b>Continuar con Google</b> al iniciar sesión.
                    </span>
                </div>

                <div className="field">
                    <label htmlFor="rec-username" className="block text-900 font-semibold mb-2">
                        Nombre de Usuario *
                    </label>
                    <InputText
                        id="rec-username"
                        value={username}
                        onChange={(e) => setUsername(e.target.value)}
                        placeholder="Tu nombre de usuario"
                        disabled={loading || !!success}
                    />
                </div>

                <div className="field">
                    <label htmlFor="rec-email" className="block text-900 font-semibold mb-2">
                        Correo Electrónico *
                    </label>
                    <InputText
                        id="rec-email"
                        type="email"
                        value={email}
                        onChange={(e) => setEmail(e.target.value)}
                        placeholder="ejemplo@correo.com"
                        disabled={loading || !!success}
                    />
                </div>

                <div className="field">
                    <label htmlFor="rec-password" className="block text-900 font-semibold mb-2">
                        Nueva Contraseña *
                    </label>
                    <Password
                        id="rec-password"
                        value={nuevaPassword}
                        onChange={(e) => setNuevaPassword(e.target.value)}
                        placeholder="Mínimo 6 caracteres"
                        toggleMask
                        feedback={false}
                        disabled={loading || !!success}
                    />
                </div>

                <div className="field">
                    <label htmlFor="rec-confirm" className="block text-900 font-semibold mb-2">
                        Confirmar Nueva Contraseña *
                    </label>
                    <Password
                        id="rec-confirm"
                        value={confirmPassword}
                        onChange={(e) => setConfirmPassword(e.target.value)}
                        placeholder="Repite la nueva contraseña"
                        toggleMask
                        feedback={false}
                        disabled={loading || !!success}
                    />
                </div>

                <Button
                    label={loading ? 'Restableciendo…' : 'Restablecer Contraseña'}
                    icon={loading ? 'pi pi-spin pi-spinner' : 'pi pi-key'}
                    onClick={handleSubmit}
                    disabled={loading || !!success}
                />
            </div>
        </Dialog>
    );
}
