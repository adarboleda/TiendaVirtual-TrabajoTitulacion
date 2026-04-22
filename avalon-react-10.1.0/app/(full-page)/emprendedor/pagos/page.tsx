'use client';

import React, { useEffect, useState } from 'react';
import PagosEmprendedor from './PagosEmprendedor';

export default function PagosPage() {
    const [emprendedorId, setEmprendedorId] = useState<number | null>(null);

    useEffect(() => {
        // Obtener el emprendedorId del usuario logueado
        // Esto debe venir del contexto de autenticación o localStorage
        const userData = localStorage.getItem('user');
        if (userData) {
            try {
                const user = JSON.parse(userData);
                setEmprendedorId(user.emprendedorId || 1); // Default a 1 para testing
            } catch (error) {
                console.error('Error parsing user data:', error);
                setEmprendedorId(1); // Default para testing
            }
        } else {
            setEmprendedorId(1); // Default para testing
        }
    }, []);

    if (!emprendedorId) {
        return <div>Cargando...</div>;
    }

    return (
        <div className="card">
            <h1 className="text-3xl font-bold mb-4">Gestión de Pagos</h1>
            <p className="text-gray-600 mb-4">
                Aprueba o rechaza los pagos pendientes de tus clientes
            </p>
            <PagosEmprendedor emprendedorId={emprendedorId} />
        </div>
    );
}
