const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8083/api';

export interface SeguimientoLogistica {
    id: number;
    ventaId: number;
    numeroFactura: string;
    estadoLogistica: string;
    estadoTitulo: string;
    descripcion: string;
    ubicacion?: string;
    responsable?: string;
    observaciones?: string;
    fechaActualizacion: string;
    fechaCreacion: string;
}

export interface ActualizarSeguimientoRequest {
    ventaId: number;
    estadoLogistica: string;
    descripcion?: string;
    ubicacion?: string;
    responsable?: string;
    observaciones?: string;
}

export interface EstadoLogistico {
    codigo: string;
    titulo: string;
    descripcion: string;
}

/**
 * Obtiene el historial completo de seguimiento de una venta
 */
export const obtenerHistorialPorVenta = async (ventaId: number): Promise<SeguimientoLogistica[]> => {
    const response = await fetch(`${API_BASE_URL}/seguimiento-logistica/venta/${ventaId}`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
        },
    });

    if (!response.ok) {
        throw new Error('Error al obtener historial de seguimiento');
    }

    return response.json();
};

/**
 * Obtiene el último estado de seguimiento de una venta
 */
export const obtenerUltimoEstado = async (ventaId: number): Promise<SeguimientoLogistica> => {
    const response = await fetch(`${API_BASE_URL}/seguimiento-logistica/venta/${ventaId}/ultimo`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
        },
    });

    if (!response.ok) {
        throw new Error('Error al obtener último estado de seguimiento');
    }

    return response.json();
};

/**
 * Crea una nueva actualización de seguimiento
 */
export const crearSeguimiento = async (request: ActualizarSeguimientoRequest): Promise<SeguimientoLogistica> => {
    const response = await fetch(`${API_BASE_URL}/seguimiento-logistica`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(request),
    });

    if (!response.ok) {
        const error = await response.text();
        throw new Error(error || 'Error al crear seguimiento');
    }

    return response.json();
};

/**
 * Actualiza el estado de seguimiento de un pedido
 */
export const actualizarEstadoSeguimiento = async (request: ActualizarSeguimientoRequest): Promise<SeguimientoLogistica> => {
    const response = await fetch(`${API_BASE_URL}/seguimiento-logistica`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(request),
    });

    if (!response.ok) {
        const error = await response.text();
        throw new Error(error || 'Error al actualizar seguimiento');
    }

    return response.json();
};

/**
 * Obtiene todos los seguimientos de un emprendedor
 */
export const obtenerSeguimientosPorEmprendedor = async (emprendedorId: number): Promise<SeguimientoLogistica[]> => {
    const response = await fetch(`${API_BASE_URL}/seguimiento-logistica/emprendedor/${emprendedorId}`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
        },
    });

    if (!response.ok) {
        throw new Error('Error al obtener seguimientos del emprendedor');
    }

    return response.json();
};

/**
 * Obtiene seguimientos de un emprendedor en un estado específico
 */
export const obtenerSeguimientosPorEmprendedorYEstado = async (
    emprendedorId: number, 
    estado: string
): Promise<SeguimientoLogistica[]> => {
    const response = await fetch(`${API_BASE_URL}/seguimiento-logistica/emprendedor/${emprendedorId}/estado/${estado}`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
        },
    });

    if (!response.ok) {
        throw new Error('Error al obtener seguimientos por estado');
    }

    return response.json();
};

/**
 * Obtiene la lista de todos los estados logísticos disponibles
 */
export const obtenerEstadosDisponibles = async (): Promise<EstadoLogistico[]> => {
    const response = await fetch(`${API_BASE_URL}/seguimiento-logistica/estados`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
        },
    });

    if (!response.ok) {
        throw new Error('Error al obtener estados disponibles');
    }

    return response.json();
};

/**
 * Mapea el código del estado a un severity para PrimeReact Tag
 */
export const getEstadoSeverity = (estado: string): 'success' | 'info' | 'warning' | 'danger' => {
    switch (estado) {
        case 'ENTREGADO':
            return 'success';
        case 'EN_CAMINO':
        case 'EN_PUNTO_ENTREGA':
            return 'info';
        case 'PAGO_APROBADO':
        case 'EN_PREPARACION':
        case 'LISTO_PARA_ENVIO':
            return 'warning';
        case 'CANCELADO':
            return 'danger';
        default:
            return 'info';
    }
};

/**
 * Mapea el código del estado a un ícono para PrimeReact
 */
export const getEstadoIcon = (estado: string): string => {
    switch (estado) {
        case 'PAGO_APROBADO':
            return 'pi-check-circle';
        case 'EN_PREPARACION':
            return 'pi-box';
        case 'LISTO_PARA_ENVIO':
            return 'pi-calendar-plus';
        case 'EN_CAMINO':
            return 'pi-truck';
        case 'EN_PUNTO_ENTREGA':
            return 'pi-map-marker';
        case 'ENTREGADO':
            return 'pi-verified';
        case 'CANCELADO':
            return 'pi-times-circle';
        default:
            return 'pi-circle';
    }
};
