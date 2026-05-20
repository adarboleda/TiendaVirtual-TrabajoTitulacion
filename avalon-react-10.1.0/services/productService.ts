// services/productService.ts - CON FALLBACK RÁPIDO

export interface ProductoResponse {
    id: number;
    nombre: string;
    descripcion: string;
    precio: number;
    imagen: string;
    categoria: Categoria;
    empresa: Empresa;
    inventario?: Inventario | null;
    fechaCreacion: string;
    fechaActualizacion: string;
}

export interface Inventario {
    id: number;
    productoId: number;
    cantidad: number;
    activo: boolean;
    ubicacion: string;
    fechaCreacion: string;
    fechaActualizacion: string;
}

export interface Categoria {
    id: number;
    nombre: string;
    descripcion: string;
    fechaCreacion: string;
    fechaActualizacion: string;
}

export interface Empresa {
    id: number;
    nombre: string;
    descripcion: string;
    contacto: string;
    fechaCreacion: string;
    fechaActualizacion: string;
}

export interface ApiResponse<T> {
    success: boolean;
    data?: T;
    message: string;
}

class ProductService {
    private readonly PRODUCTOS_URL = process.env.NEXT_PUBLIC_PRODUCTOS_API_URL || 'http://localhost:8081/api';
    private readonly INVENTARIO_URL = process.env.NEXT_PUBLIC_INVENTARIO_API_URL 
        ? `${process.env.NEXT_PUBLIC_INVENTARIO_API_URL}/api/inventarios` 
        : 'http://localhost:8082/api/inventarios';
    private cache: Map<string, { data: any; timestamp: number }> = new Map();
    private stockCache: Map<number, number> = new Map(); // Cache específico para stock
    private readonly CACHE_DURATION = 2 * 60 * 1000; // 2 minutos

    /**
     * ✅ OBTENER STOCK DE UN PRODUCTO (con mejor manejo de errores)
     */
    private async obtenerStockProducto(productoId: number): Promise<number> {
        try {
            // Verificar cache primero
            if (this.stockCache.has(productoId)) {
                return this.stockCache.get(productoId)!;
            }

            console.log(`🔍 Consultando CANTIDAD para producto ${productoId}...`);
            
            // ✅ ENDPOINT QUE SOLO DEVUELVE UN NÚMERO
            const response = await fetch(`${this.INVENTARIO_URL}/cantidad/producto/${productoId}`, {
                method: 'GET',
                headers: { 'Content-Type': 'application/json' },
                signal: AbortSignal.timeout(3000) // 3 segundos
            });

            if (response.ok) {
                // ✅ LA RESPUESTA ES DIRECTAMENTE UN NÚMERO: 40, 7, 20, etc.
                const cantidad = await response.json();
                console.log(`📦 Cantidad directa producto ${productoId}: ${cantidad}`);
                
                // ✅ VALIDACIÓN ROBUSTA
                let stockFinal = 0;
                if (typeof cantidad === 'number' && !isNaN(cantidad) && cantidad >= 0) {
                    stockFinal = cantidad;
                } else if (typeof cantidad === 'string' && !isNaN(parseInt(cantidad))) {
                    stockFinal = parseInt(cantidad);
                } else {
                    console.log(`⚠️ Respuesta inválida para producto ${productoId}: ${cantidad}, usando 0`);
                    stockFinal = 0;
                }
                
                console.log(`✅ Stock producto ${productoId}: ${stockFinal}`);
                this.stockCache.set(productoId, stockFinal);
                return stockFinal;
                
            } else if (response.status === 404) {
                console.log(`⚠️ Producto ${productoId} no tiene inventario registrado`);
                this.stockCache.set(productoId, 0);
                return 0;
            } else {
                console.log(`⚠️ Error ${response.status} consultando cantidad producto ${productoId}`);
                this.stockCache.set(productoId, 0);
                return 0;
            }
        } catch (error: any) {
            if (error.name === 'AbortError') {
                console.log(`⏰ Timeout consultando cantidad producto ${productoId} - usando 0`);
            } else if (error.name === 'TypeError' && error.message.includes('fetch')) {
                console.log(`🔌 Sin conexión al inventario para producto ${productoId} - usando 0`);
            } else {
                console.log(`⚠️ Error consultando cantidad producto ${productoId}: ${error.message} - usando 0`);
            }
            
            // ✅ SIEMPRE GUARDAR EN CACHE AUNQUE SEA 0
            this.stockCache.set(productoId, 0);
            return 0;
        }
    }

    /**
     * ✅ OBTENER STOCK BATCH (endpoint súper simple)
     */
    private async obtenerStockBatch(productosIds: number[]): Promise<Map<number, number>> {
        const stockMap = new Map<number, number>();
        
        try {
            console.log(`🔄 Consultando CANTIDADES BATCH para ${productosIds.length} productos...`);
            
            // ✅ ENDPOINT BATCH SIMPLE
            const response = await fetch(`${this.INVENTARIO_URL}/cantidad/batch`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(productosIds),
                signal: AbortSignal.timeout(3000) // 3 segundos para batch
            });

            if (response.ok) {
                const cantidadesResponse = await response.json();
                console.log(`📦 Respuesta cantidades batch:`, cantidadesResponse);
                
                // ✅ CONVERTIR DE {"1": 40, "2": 7, "3": 20} A MAP
                Object.entries(cantidadesResponse).forEach(([productIdStr, cantidad]) => {
                    const productId = parseInt(productIdStr);
                    const stock = typeof cantidad === 'number' ? cantidad : 0;
                    stockMap.set(productId, stock);
                    this.stockCache.set(productId, stock); // Guardar en cache también
                });
                
                console.log(`✅ Cantidades batch obtenidas para ${stockMap.size} productos`);
                return stockMap;
            } else {
                console.log(`⚠️ Endpoint cantidades batch falló (${response.status}), usando consultas individuales...`);
            }
        } catch (error: any) {
            console.log(`⚠️ Error en cantidades batch, usando consultas individuales:`, error.message);
        }
        
        // ✅ FALLBACK: Consultas individuales si el batch falla
        console.log(`🔄 Fallback: consultando cantidades individualmente...`);
        
        for (const productoId of productosIds) {
            try {
                const stock = await this.obtenerStockProducto(productoId);
                stockMap.set(productoId, stock);
                
                // Pequeña pausa para no saturar
                await new Promise(resolve => setTimeout(resolve, 50));
            } catch (error) {
                console.log(`❌ Error consultando cantidad producto ${productoId}, usando 0`);
                stockMap.set(productoId, 0);
            }
        }
        
        return stockMap;
    }

    /**
     * ✅ MÉTODO PRINCIPAL: Obtener productos CON fallback inteligente
     */
    async obtenerProductos(): Promise<ApiResponse<ProductoResponse[]>> {
        const cacheKey = 'productos_base';
        const cached = this.cache.get(cacheKey);
        
        // Usar caché si existe
        if (cached && (Date.now() - cached.timestamp) < this.CACHE_DURATION) {
            console.log('📦 Productos desde caché');
            return {
                success: true,
                data: cached.data,
                message: 'Productos desde caché'
            };
        }

        try {
            console.log('🚀 Cargando productos con fallback...');
            
            // ✅ PASO 1: Intentar endpoint optimizado primero
            let productos: ProductoResponse[] = [];
            
            try {
                const responseOptimizado = await fetch(`${this.PRODUCTOS_URL}/productos/listado`, {
                    method: 'GET',
                    headers: { 'Content-Type': 'application/json' },
                    signal: AbortSignal.timeout(2000) // 2 segundos máximo
                });

                if (responseOptimizado.ok) {
                    const productosDto = await responseOptimizado.json();
                    console.log(`✅ Endpoint optimizado funcionó: ${productosDto.length} productos`);
                    
                    productos = productosDto.map((dto: any) => ({
                        id: dto.id,
                        nombre: dto.nombre,
                        descripcion: dto.descripcion,
                        precio: dto.precio,
                        imagen: dto.imagen || 'https://via.placeholder.com/400x290?text=Producto',
                        categoria: {
                            id: 0,
                            nombre: dto.categoriaNombre || 'Sin categoría',
                            descripcion: '',
                            fechaCreacion: '',
                            fechaActualizacion: ''
                        },
                        empresa: {
                            id: dto.empresaId || 0,
                            nombre: dto.empresaNombre || 'Sin empresa',
                            descripcion: '',
                            contacto: '',
                            fechaCreacion: '',
                            fechaActualizacion: ''
                        },
                        inventario: {
                            id: 0,
                            productoId: dto.id,
                            cantidad: dto.inventarioCantidad || 0,
                            activo: (dto.inventarioCantidad || 0) > 0,
                            ubicacion: (dto.inventarioCantidad || 0) > 0 ? 'Disponible' : 'Sin stock',
                            fechaCreacion: '',
                            fechaActualizacion: ''
                        },
                        fechaCreacion: '',
                        fechaActualizacion: ''
                    }));
                }
            } catch (error) {
                console.log('⚠️ Endpoint optimizado falló, intentando endpoint básico...');
            }

            // ✅ PASO 2: Si falla, usar endpoint básico
            if (productos.length === 0) {
                try {
                    const responseBasico = await fetch(`${this.PRODUCTOS_URL}/productos`, {
                        method: 'GET',
                        headers: { 'Content-Type': 'application/json' },
                        signal: AbortSignal.timeout(3000)
                    });

                    if (responseBasico.ok) {
                        const productosBasicos: ProductoResponse[] = await responseBasico.json();
                        console.log(`✅ Endpoint básico funcionó: ${productosBasicos.length} productos`);
                        
                        // Agregar inventario por defecto
                        productos = productosBasicos.map(producto => ({
                            ...producto,
                            inventario: producto.inventario || {
                                id: 0,
                                productoId: producto.id,
                                cantidad: 0, // Por defecto 0, se actualizará después
                                activo: false,
                                ubicacion: 'Consultando...',
                                fechaCreacion: '',
                                fechaActualizacion: ''
                            }
                        }));
                    }
                } catch (error) {
                    console.log('⚠️ Endpoint básico también falló');
                }
            }

            if (productos.length === 0) {
                return {
                    success: false,
                    data: [],
                    message: 'No se pudo conectar con el servidor de productos'
                };
            }

            // ✅ PASO 3: Actualizar stock para TODOS los productos (no solo 3)
            if (productos.length > 0) {
                console.log(`🔄 Iniciando actualización de stock para ${productos.length} productos...`);
                
                // ✅ NO LIMITAR A 3 - Procesar TODOS
                this.actualizarStockEnSegundoPlano(productos);
            }

            console.log(`✅ Productos cargados (${productos.length}), actualizando stock en segundo plano...`);
            
            // Guardar en caché
            this.cache.set(cacheKey, {
                data: productos,
                timestamp: Date.now()
            });
            
            return {
                success: true,
                data: productos,
                message: 'Productos cargados exitosamente'
            };

        } catch (error: any) {
            console.error('❌ Error general cargando productos:', error);
            
            // Intentar fallback con caché expirado
            const cachedFallback = this.cache.get(cacheKey);
            if (cachedFallback) {
                console.log('📦 Usando caché expirado como fallback');
                return {
                    success: true,
                    data: cachedFallback.data,
                    message: 'Productos desde caché (sin conexión)'
                };
            }
            
            return {
                success: false,
                data: [],
                message: 'Error de conexión - verifique que los servicios estén activos'
            };
        }
    }

    /**
     * ✅ ACTUALIZAR STOCK EN SEGUNDO PLANO (más robusto, para TODOS los productos)
     */
    private async actualizarStockEnSegundoPlano(productos: ProductoResponse[]) {
        try {
            console.log(`🔄 Actualizando stock en segundo plano para ${productos.length} productos...`);
            
            // ✅ PROCESAR TODOS LOS PRODUCTOS (no solo 3)
            const actualizacionesPromises = productos.map(async (producto, index) => {
                try {
                    // Pequeña pausa progresiva para no saturar el servidor
                    await new Promise(resolve => setTimeout(resolve, index * 100));
                    
                    const stock = await this.obtenerStockProducto(producto.id);
                    
                    if (producto.inventario) {
                        const stockAnterior = producto.inventario.cantidad;
                        producto.inventario.cantidad = stock;
                        producto.inventario.activo = stock > 0;
                        producto.inventario.ubicacion = stock > 0 ? 'Disponible' : 'No disponible';
                        
                        console.log(`🔄 Stock actualizado para ${producto.nombre}: ${stockAnterior} → ${stock}`);
                        
                        // ✅ FORZAR RE-RENDER
                        window.dispatchEvent(new CustomEvent('stockUpdated', {
                            detail: { productoId: producto.id, stock, producto }
                        }));
                    }
                } catch (error) {
                    console.log(`❌ Error actualizando stock para ${producto.nombre}, usando 0:`, error);
                    
                    // ✅ SI HAY ERROR, SETEAR EN 0 Y CONTINUAR
                    if (producto.inventario) {
                        producto.inventario.cantidad = 0;
                        producto.inventario.activo = false;
                        producto.inventario.ubicacion = 'No disponible';
                        
                        window.dispatchEvent(new CustomEvent('stockUpdated', {
                            detail: { productoId: producto.id, stock: 0, producto }
                        }));
                    }
                }
            });
            
            // ✅ ESPERAR A QUE TODAS LAS ACTUALIZACIONES TERMINEN
            await Promise.allSettled(actualizacionesPromises);
            console.log(`✅ Stock actualizado para todos los ${productos.length} productos`);
            
        } catch (error) {
            console.log('⚠️ Error general actualizando stock en segundo plano:', error);
        }
    }

    /**
     * ✅ VALIDACIONES DE STOCK SIMPLIFICADAS
     */
    tieneStock(producto: ProductoResponse): boolean {
        const cantidad = this.getCantidadDisponible(producto);
        return cantidad > 0;
    }

    getCantidadDisponible(producto: ProductoResponse): number {
        if (!producto.inventario) return 0;
        if (typeof producto.inventario.cantidad !== 'number') return 0;
        return Math.max(0, producto.inventario.cantidad);
    }

    getNivelStock(producto: ProductoResponse): 'sin-stock' | 'bajo' | 'normal' | 'alto' {
        const cantidad = this.getCantidadDisponible(producto);
        
        if (cantidad === 0) return 'sin-stock';
        if (cantidad <= 5) return 'bajo';
        if (cantidad <= 20) return 'normal';
        return 'alto';
    }

    getMensajeStock(producto: ProductoResponse): string {
        const cantidad = this.getCantidadDisponible(producto);
        
        if (cantidad === 0) return 'No disponible';
        if (cantidad <= 5) return `¡Solo ${cantidad} disponibles!`;
        return `${cantidad} disponibles`;
    }

    puedeAgregarAlCarrito(producto: ProductoResponse, cantidadDeseada: number): { puede: boolean; mensaje: string } {
        const cantidad = this.getCantidadDisponible(producto);
        
        if (cantidad === 0) {
            return { puede: false, mensaje: 'Producto no disponible' };
        }

        if (cantidadDeseada > cantidad) {
            return { puede: false, mensaje: `Solo hay ${cantidad} unidades disponibles` };
        }

        return { puede: true, mensaje: 'Producto disponible' };
    }

    /**
     * ✅ OBTENER CATEGORÍAS
     */
    async obtenerCategorias(): Promise<ApiResponse<Categoria[]>> {
        const cacheKey = 'categorias';
        const cached = this.cache.get(cacheKey);
        
        if (cached && (Date.now() - cached.timestamp) < this.CACHE_DURATION) {
            return { success: true, data: cached.data, message: 'Categorías desde caché' };
        }

        try {
            const response = await fetch(`${this.PRODUCTOS_URL}/categorias`, {
                signal: AbortSignal.timeout(2000)
            });
            
            if (response.ok) {
                const categorias: Categoria[] = await response.json();
                this.cache.set(cacheKey, { data: categorias, timestamp: Date.now() });
                return { success: true, data: categorias, message: 'Categorías obtenidas' };
            } else {
                return { success: false, data: [], message: 'Error obteniendo categorías' };
            }
        } catch (error: any) {
            console.error('❌ Error obteniendo categorías:', error);
            return { success: false, data: [], message: 'Error de conexión' };
        }
    }

    /**
     * ✅ OBTENER EMPRESAS
     */
    async obtenerEmpresas(): Promise<ApiResponse<Empresa[]>> {
        const cacheKey = 'empresas';
        const cached = this.cache.get(cacheKey);
        
        if (cached && (Date.now() - cached.timestamp) < this.CACHE_DURATION) {
            return { success: true, data: cached.data, message: 'Empresas desde caché' };
        }

        try {
            const response = await fetch(`${this.PRODUCTOS_URL}/empresas`, {
                signal: AbortSignal.timeout(2000)
            });
            
            if (response.ok) {
                const empresas: Empresa[] = await response.json();
                this.cache.set(cacheKey, { data: empresas, timestamp: Date.now() });
                return { success: true, data: empresas, message: 'Empresas obtenidas' };
            } else {
                return { success: false, data: [], message: 'Error obteniendo empresas' };
            }
        } catch (error: any) {
            console.error('❌ Error obteniendo empresas:', error);
            return { success: false, data: [], message: 'Error de conexión' };
        }
    }

    /**
     * ✅ UTILIDADES
     */
    filtrarProductos(productos: ProductoResponse[], termino: string): ProductoResponse[] {
        if (!termino || !termino.trim()) return productos;
        
        const terminoLower = termino.toLowerCase().trim();
        return productos.filter(producto => 
            producto.nombre.toLowerCase().includes(terminoLower) ||
            producto.descripcion.toLowerCase().includes(terminoLower) ||
            producto.categoria.nombre.toLowerCase().includes(terminoLower) ||
            producto.empresa.nombre.toLowerCase().includes(terminoLower)
        );
    }

    formatearPrecio(precio: number): string {
        if (typeof precio !== 'number' || isNaN(precio)) return '$0.00';
        
        return new Intl.NumberFormat('es-EC', {
            style: 'currency',
            currency: 'USD'
        }).format(precio);
    }

    clearCache(): void {
        this.cache.clear();
        this.stockCache.clear();
        console.log('🗑️ Cache limpiado');
    }
}

export default new ProductService();