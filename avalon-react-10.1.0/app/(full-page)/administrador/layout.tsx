'use client';

import { useEffect, useState } from 'react';
import AdministradorSidebar from './components/AdministradorSidebar';
import AdminHeader from './components/AdminHeader';

export default function AdministradorLayout({
    children,
}: {
    children: React.ReactNode;
}) {
    const [loading, setLoading] = useState(true);
    const [tieneToken, setTieneToken] = useState(false);
    const [sidebarActive, setSidebarActive] = useState(false);

    useEffect(() => {
        const verificarToken = () => {
            try {
                const token = localStorage.getItem('auth_token');
                const usuario = localStorage.getItem('user_info');
                
                if (token && usuario) {
                    setTieneToken(true);
                } else {
                    setTieneToken(false);
                }
                
                setLoading(false);
            } catch (error) {
                console.error('Error verificando token:', error);
                setTieneToken(false);
                setLoading(false);
            }
        };

        verificarToken();
    }, []);

    if (loading) {
        return (
            <div 
                className="min-h-screen flex align-items-center justify-content-center"
                style={{ backgroundColor: 'var(--surface-ground)' }}
            >
                <div className="text-center">
                    <i 
                        className="pi pi-spin pi-spinner text-4xl mb-3"
                        style={{ color: 'var(--primary-color)' }}
                    ></i>
                    <div style={{ color: 'var(--text-color)' }}>
                        Cargando panel...
                    </div>
                </div>
            </div>
        );
    }

    if (!tieneToken) {
        return (
            <div 
                className="min-h-screen flex align-items-center justify-content-center"
                style={{ backgroundColor: 'var(--surface-ground)' }}
            >
                <div className="text-center">
                    <i className="pi pi-lock text-6xl text-red-500 mb-4"></i>
                    <div className="text-xl font-bold text-900 mb-2">Sesión requerida</div>
                    <div className="text-600 mb-4">Necesitas iniciar sesión para acceder</div>
                    <a href="/(full-page)/auth/login2" className="p-button p-button-primary">
                        Ir a Login
                    </a>
                </div>
            </div>
        );
    }

    const toggleSidebar = () => setSidebarActive((prev) => !prev);
    const closeSidebar = () => setSidebarActive(false);

    return (
        <div className="admin-layout-wrapper">
            {/* Botón para abrir sidebar en móvil */}
            <button
                className="admin-sidebar-toggle"
                onClick={toggleSidebar}
                aria-label="Abrir menú"
            >
                <i className="pi pi-bars"></i>
            </button>

            {/* Overlay para cerrar sidebar en móvil */}
            <div
                className={`admin-sidebar-overlay ${sidebarActive ? 'active' : ''}`}
                onClick={closeSidebar}
            ></div>

            {/* Sidebar */}
            <div className={`admin-sidebar ${sidebarActive ? 'active' : ''}`}>
                <AdministradorSidebar onNavigate={closeSidebar} />
            </div>

            {/* Contenido principal */}
            <div className="admin-content-wrapper">
                <div className="admin-topbar">
                    <AdminHeader />
                </div>

                <div className="admin-main">
                    <div className="admin-main-content">
                        {children}
                    </div>
                </div>
            </div>
        </div>
    );
}