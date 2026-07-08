'use client';

import React, { useEffect, useState } from 'react';
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
    /** Precarga el usuario (p. ej. cuando se abre desde "Mi cuenta" ya autenticado) */
    initialUsername?: string;
}

type Paso = 'usuario' | 'codigo' | 'nueva-password' | 'listo';

export default function RecuperarPasswordModal({ visible, onHide, onSuccess, initialUsername }: RecuperarPasswordModalProps) {
    const [paso, setPaso] = useState<Paso>('usuario');
    const [username, setUsername] = useState('');

    useEffect(() => {
        if (visible && initialUsername) {
            setUsername(initialUsername);
        }
    }, [visible, initialUsername]);
    const [codigo, setCodigo] = useState('');
    const [resetToken, setResetToken] = useState('');
    const [nuevaPassword, setNuevaPassword] = useState('');
    const [confirmPassword, setConfirmPassword] = useState('');
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState('');
    const [info, setInfo] = useState('');

    const resetForm = () => {
        setPaso('usuario');
        setUsername('');
        setCodigo('');
        setResetToken('');
        setNuevaPassword('');
        setConfirmPassword('');
        setError('');
        setInfo('');
    };

    const handleClose = () => {
        resetForm();
        onHide();
    };

    // Paso 1: solicitar código al correo registrado
    const handleSolicitarCodigo = async () => {
        setError('');
        if (!username.trim()) {
            setError('El nombre de usuario es requerido');
            return;
        }

        setLoading(true);
        try {
            const result = await authService.solicitarCodigoRecuperacion(username.trim());
            if (result.success) {
                // Se avanza igual exista o no la cuenta (no revelamos esa información)
                setInfo(result.message || 'Si el usuario existe, se envió un código a su correo registrado.');
                setPaso('codigo');
            } else {
                // Falla real (p. ej. sin conexión con el servidor): no avanzar
                setError(result.message);
            }
        } finally {
            setLoading(false);
        }
    };

    // Paso 2: verificar el código de 6 dígitos recibido por correo
    const handleVerificarCodigo = async () => {
        setError('');
        if (!/^\d{6}$/.test(codigo.trim())) {
            setError('Ingresa el código de 6 dígitos que recibiste por correo');
            return;
        }

        setLoading(true);
        try {
            const result = await authService.verificarCodigoRecuperacion(username.trim(), codigo.trim());
            if (result.success && result.resetToken) {
                setResetToken(result.resetToken);
                setInfo('');
                setPaso('nueva-password');
            } else {
                setError(result.message);
            }
        } finally {
            setLoading(false);
        }
    };

    // Paso 3: definir la nueva contraseña usando el token emitido en el paso anterior
    const handleRestablecer = async () => {
        setError('');
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
            const result = await authService.restablecerPasswordConToken(username.trim(), resetToken, nuevaPassword);
            if (result.success) {
                setPaso('listo');
                setTimeout(() => {
                    handleClose();
                    onSuccess?.();
                }, 2200);
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
                {info && paso === 'codigo' && <Message severity="success" text={info} />}

                {paso === 'usuario' && (
                    <>
                        <div
                            className="text-sm text-600 p-3 border-round flex align-items-start gap-2"
                            style={{ backgroundColor: 'var(--surface-100)', border: '1px solid var(--surface-border)' }}
                        >
                            <i className="pi pi-info-circle mt-1" style={{ color: 'var(--primary-color)' }}></i>
                            <span>
                                Ingresa tu nombre de usuario y te enviaremos un código temporal a tu correo registrado.
                                Si creaste tu cuenta con Google, usa el botón <b>Continuar con Google</b> al iniciar sesión.
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
                                disabled={loading}
                                onKeyDown={(e) => e.key === 'Enter' && handleSolicitarCodigo()}
                            />
                        </div>

                        <Button
                            label={loading ? 'Enviando…' : 'Enviar código'}
                            icon={loading ? 'pi pi-spin pi-spinner' : 'pi pi-send'}
                            onClick={handleSolicitarCodigo}
                            disabled={loading}
                        />
                    </>
                )}

                {paso === 'codigo' && (
                    <>
                        <div className="field">
                            <label htmlFor="rec-codigo" className="block text-900 font-semibold mb-2">
                                Código de verificación *
                            </label>
                            <InputText
                                id="rec-codigo"
                                value={codigo}
                                onChange={(e) => setCodigo(e.target.value.replace(/\D/g, '').slice(0, 6))}
                                placeholder="000000"
                                inputMode="numeric"
                                maxLength={6}
                                disabled={loading}
                                style={{ textAlign: 'center', letterSpacing: '0.4rem', fontSize: '1.3rem', fontWeight: 700 }}
                                onKeyDown={(e) => e.key === 'Enter' && handleVerificarCodigo()}
                            />
                            <small className="text-600">Válido por 15 minutos.</small>
                        </div>

                        <Button
                            label={loading ? 'Verificando…' : 'Verificar código'}
                            icon={loading ? 'pi pi-spin pi-spinner' : 'pi pi-check'}
                            onClick={handleVerificarCodigo}
                            disabled={loading}
                        />
                        <Button
                            label="Reenviar código"
                            icon="pi pi-refresh"
                            className="p-button-text p-button-sm"
                            onClick={handleSolicitarCodigo}
                            disabled={loading}
                        />
                    </>
                )}

                {paso === 'nueva-password' && (
                    <>
                        <Message severity="success" text="Código verificado. Ahora define tu nueva contraseña." />

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
                                disabled={loading}
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
                                disabled={loading}
                                onKeyDown={(e) => e.key === 'Enter' && handleRestablecer()}
                            />
                        </div>

                        <Button
                            label={loading ? 'Restableciendo…' : 'Restablecer Contraseña'}
                            icon={loading ? 'pi pi-spin pi-spinner' : 'pi pi-key'}
                            onClick={handleRestablecer}
                            disabled={loading}
                        />
                    </>
                )}

                {paso === 'listo' && (
                    <Message severity="success" text="¡Contraseña actualizada! Ya puedes iniciar sesión." />
                )}
            </div>
        </Dialog>
    );
}
