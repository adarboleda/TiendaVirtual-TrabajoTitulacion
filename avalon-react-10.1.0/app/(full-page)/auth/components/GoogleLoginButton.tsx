'use client';

import React, { useEffect, useRef, useState } from 'react';

const GOOGLE_CLIENT_ID = process.env.NEXT_PUBLIC_GOOGLE_CLIENT_ID || '';
const GSI_SCRIPT_SRC = 'https://accounts.google.com/gsi/client';

interface GoogleLoginButtonProps {
    /** Recibe el idToken (credential) emitido por Google */
    onCredential: (idToken: string) => void;
    /** Se invoca si Google no está configurado o falla la carga */
    onError?: (message: string) => void;
}

declare global {
    interface Window {
        google?: any;
    }
}

/**
 * Botón oficial de Google Identity Services.
 * Requiere NEXT_PUBLIC_GOOGLE_CLIENT_ID en las variables de entorno.
 */
const GoogleLoginButton: React.FC<GoogleLoginButtonProps> = ({ onCredential, onError }) => {
    const buttonRef = useRef<HTMLDivElement>(null);
    const [scriptReady, setScriptReady] = useState(false);

    useEffect(() => {
        if (!GOOGLE_CLIENT_ID) {
            return;
        }

        // Cargar el script de GSI una sola vez
        const existing = document.querySelector(`script[src="${GSI_SCRIPT_SRC}"]`) as HTMLScriptElement | null;
        if (existing) {
            if (window.google?.accounts?.id) {
                setScriptReady(true);
            } else {
                existing.addEventListener('load', () => setScriptReady(true));
            }
            return;
        }

        const script = document.createElement('script');
        script.src = GSI_SCRIPT_SRC;
        script.async = true;
        script.defer = true;
        script.onload = () => setScriptReady(true);
        script.onerror = () => onError?.('No se pudo cargar Google Identity Services');
        document.head.appendChild(script);
    }, [onError]);

    useEffect(() => {
        if (!scriptReady || !buttonRef.current || !window.google?.accounts?.id) {
            return;
        }

        try {
            window.google.accounts.id.initialize({
                client_id: GOOGLE_CLIENT_ID,
                callback: (response: { credential?: string }) => {
                    if (response?.credential) {
                        onCredential(response.credential);
                    } else {
                        onError?.('Google no devolvió una credencial válida');
                    }
                }
            });

            window.google.accounts.id.renderButton(buttonRef.current, {
                theme: 'outline',
                size: 'large',
                width: 320,
                text: 'continue_with',
                locale: 'es'
            });
        } catch (e) {
            console.error('Error inicializando Google Sign-In:', e);
            onError?.('Error inicializando Google Sign-In');
        }
    }, [scriptReady, onCredential, onError]);

    if (!GOOGLE_CLIENT_ID) {
        // Sin client id configurado no se muestra el botón
        return null;
    }

    return (
        <div className="flex justify-content-center w-full">
            <div ref={buttonRef}></div>
        </div>
    );
};

export default GoogleLoginButton;
