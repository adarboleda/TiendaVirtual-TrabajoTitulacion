'use client';
import { useEffect } from 'react';
import { LayoutProvider } from '../layout/context/layoutcontext';
import { PrimeReactProvider } from 'primereact/api';
import '../styles/layout/layout.scss';
import 'primeflex/primeflex.css';
import 'primeicons/primeicons.css';
import 'primereact/resources/primereact.css';
import '../styles/demo/Demos.scss';

export default function RootLayout({ children }: { children: React.ReactNode }) {
    useEffect(() => {
        // Intercept standard runtime errors related to chunk loading
        const handleError = (event: ErrorEvent) => {
            const message = event.message || '';
            if (
                message.includes('ChunkLoadError') ||
                message.includes('Loading chunk') ||
                message.includes('failed to load')
            ) {
                console.warn('ChunkLoadError detected by Antigravity Recovery System. Reloading page...');
                event.preventDefault();
                window.location.reload();
            }
        };

        // Intercept unhandled promise rejections (often how chunk load failures present)
        const handleRejection = (event: PromiseRejectionEvent) => {
            const reason = event.reason;
            if (
                reason &&
                (reason.name === 'ChunkLoadError' ||
                 (reason.message && reason.message.includes('Loading chunk')))
            ) {
                console.warn('Unhandled Promise ChunkLoadError detected. Reloading page...');
                event.preventDefault();
                window.location.reload();
            }
        };

        window.addEventListener('error', handleError);
        window.addEventListener('unhandledrejection', handleRejection);

        return () => {
            window.removeEventListener('error', handleError);
            window.removeEventListener('unhandledrejection', handleRejection);
        };
    }, []);

    return (
        <html lang="en" suppressHydrationWarning>
            <head>
                <link id="theme-link" href={`/theme/theme-light/purple/theme.css`} rel="stylesheet"></link>
            </head>
            <body suppressHydrationWarning>
                <PrimeReactProvider>
                    <LayoutProvider>{children}</LayoutProvider>
                </PrimeReactProvider>
            </body>
        </html>
    );
}

