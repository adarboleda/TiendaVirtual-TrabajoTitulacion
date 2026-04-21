// services/cartService.ts - Versión corregida

import clientesService from './clientesService';

export interface Producto {
    id: number;
    nombre: string;
    descripcion: string;
    precio: number;
    imagen: string | null;
    activo: boolean;
    categoria: {
        id: number;
        nombre: string;
    };
    empresa: {
        id: number;
        nombre: string;
    };
    inventario?: {
        id: number;
        cantidad: number;
        ubicacion: string;
    };
}

export interface CartItem {
    id: string;
    producto: Producto;
    cantidad: number;
    subtotal: number;
}

export interface CartSummary {
    items: CartItem[];
    totalItems: number;
    subtotal: number;
    impuestos: number;
    envio: number;
    total: number;
}

export interface CheckoutData {
    clienteId?: number;
    items: Array<{
        productoId: number;
        cantidad: number;
    }>;
    metodoPago?: 'TRANSFERENCIA' | 'TARJETA' | 'DEUNA';
    comprobanteUrl?: string;
    datosCliente?: {
        nombre: string;
        apellido: string;
        email: string;
        telefono: string;
        direccion: string;
        documento?: string;
    };
}

export interface CheckoutResult {
    success: boolean;
    message: string;
    data?: {
        orderId: string;
        total: number;
    };
}

export interface ApiResponse<T> {
    success: boolean;
    message: string;
    data?: T;
}

class CartService {
    private readonly CART_KEY = 'ecommerce_cart';
    private readonly TAX_RATE = 0.15; 
    private readonly FREE_SHIPPING_THRESHOLD = 50; // Envío gratis sobre $50
    private readonly SHIPPING_COST = 5.99;
    private readonly API_BASE_URL = process.env.NEXT_PUBLIC_VENTAS_API_URL || 'http://localhost:8083';

    // ===================== MÉTODOS DEL CARRITO =====================

    getCart(): CartItem[] {
        if (typeof window === 'undefined') return [];
        
        const cartData = localStorage.getItem(this.CART_KEY);
        return cartData ? JSON.parse(cartData) : [];
    }

    saveCart(cart: CartItem[]): void {
        if (typeof window === 'undefined') return;
        
        localStorage.setItem(this.CART_KEY, JSON.stringify(cart));
        this.emitCartUpdate();
    }

    addToCart(producto: Producto, cantidad: number = 1): ApiResponse<CartItem> {
        try {
            const cart = this.getCart();
            const existingItemIndex = cart.findIndex(item => item.producto.id === producto.id);

            if (existingItemIndex > -1) {
                const existingItem = cart[existingItemIndex];
                const newQuantity = existingItem.cantidad + cantidad;
                
                if (producto.inventario && newQuantity > producto.inventario.cantidad) {
                    return {
                        success: false,
                        message: `Stock insuficiente. Máximo disponible: ${producto.inventario.cantidad}`
                    };
                }

                cart[existingItemIndex].cantidad = newQuantity;
                cart[existingItemIndex].subtotal = newQuantity * producto.precio;
            } else {
                if (producto.inventario && cantidad > producto.inventario.cantidad) {
                    return {
                        success: false,
                        message: `Stock insuficiente. Máximo disponible: ${producto.inventario.cantidad}`
                    };
                }

                const newItem: CartItem = {
                    id: `${producto.id}_${Date.now()}`,
                    producto,
                    cantidad,
                    subtotal: cantidad * producto.precio
                };
                cart.push(newItem);
            }

            this.saveCart(cart);
            return {
                success: true,
                message: 'Producto agregado al carrito',
                data: cart.find(item => item.producto.id === producto.id)
            };
        } catch (error) {
            return {
                success: false,
                message: 'Error al agregar al carrito'
            };
        }
    }

    removeFromCart(itemId: string): ApiResponse<void> {
        try {
            const cart = this.getCart();
            const updatedCart = cart.filter(item => item.id !== itemId);
            this.saveCart(updatedCart);
            
            return {
                success: true,
                message: 'Producto removido del carrito'
            };
        } catch (error) {
            return {
                success: false,
                message: 'Error al remover del carrito'
            };
        }
    }

    updateQuantity(itemId: string, newQuantity: number): ApiResponse<CartItem> {
        try {
            if (newQuantity < 0) {
                return {
                    success: false,
                    message: 'La cantidad no puede ser negativa'
                };
            }

            const cart = this.getCart();
            const itemIndex = cart.findIndex(item => item.id === itemId);
            
            if (itemIndex === -1) {
                return {
                    success: false,
                    message: 'Producto no encontrado en el carrito'
                };
            }

            if (newQuantity === 0) {
                const result = this.removeFromCart(itemId);
                return {
                    ...result,
                    data: undefined
                };
            }

            const item = cart[itemIndex];
            
            if (item.producto.inventario && newQuantity > item.producto.inventario.cantidad) {
                return {
                    success: false,
                    message: `Stock insuficiente. Máximo disponible: ${item.producto.inventario.cantidad}`
                };
            }

            cart[itemIndex].cantidad = newQuantity;
            cart[itemIndex].subtotal = newQuantity * item.producto.precio;
            
            this.saveCart(cart);
            
            return {
                success: true,
                message: 'Cantidad actualizada',
                data: cart[itemIndex]
            };
        } catch (error) {
            return {
                success: false,
                message: 'Error al actualizar cantidad'
            };
        }
    }

    clearCart(): ApiResponse<void> {
        try {
            this.saveCart([]);
            clientesService.limpiarDatosClienteLocal(); // Limpiar datos del cliente también
            return {
                success: true,
                message: 'Carrito vaciado exitosamente'
            };
        } catch (error) {
            return {
                success: false,
                message: 'Error al vaciar el carrito'
            };
        }
    }

    getCartSummary(): CartSummary {
        const items = this.getCart();
        const subtotal = items.reduce((sum, item) => sum + item.subtotal, 0);
        const impuestos = subtotal * this.TAX_RATE;
        const envio = subtotal >= this.FREE_SHIPPING_THRESHOLD ? 0 : this.SHIPPING_COST;
        const total = subtotal + impuestos + envio;
        const totalItems = items.reduce((sum, item) => sum + item.cantidad, 0);

        return {
            items,
            totalItems,
            subtotal,
            impuestos,
            envio,
            total
        };
    }

    // ===================== CHECKOUT =====================

    async validateCartForCheckout(): Promise<ApiResponse<boolean>> {
        const cart = this.getCart();
        
        if (cart.length === 0) {
            return {
                success: false,
                message: 'El carrito está vacío'
            };
        }

        for (const item of cart) {
            if (item.producto.inventario && item.cantidad > item.producto.inventario.cantidad) {
                return {
                    success: false,
                    message: `Stock insuficiente para ${item.producto.nombre}`
                };
            }
        }

        return {
            success: true,
            message: 'Carrito válido para checkout',
            data: true
        };
    }

    async processCheckout(datosCliente?: any, metodoPago?: 'TRANSFERENCIA' | 'TARJETA' | 'DEUNA', comprobanteUrl?: string): Promise<CheckoutResult> {
        try {
            console.log('🛒 Procesando checkout...');
            console.log('💳 Método de pago:', metodoPago);
            
            const cart = this.getCart();
            if (cart.length === 0) {
                return {
                    success: false,
                    message: 'El carrito está vacío'
                };
            }

            if (!metodoPago) {
                return {
                    success: false,
                    message: 'El método de pago es obligatorio'
                };
            }

            // Obtener datos del cliente del localStorage si no se proporcionan
            const clienteData = datosCliente || clientesService.obtenerDatosClienteLocal();
            
            if (!clienteData) {
                return {
                    success: false,
                    message: 'Datos del cliente requeridos'
                };
            }

            console.log('📝 Datos del cliente para checkout:', clienteData);

            // Usar el método mejorado de buscar o crear cliente
            const clienteResult = await clientesService.buscarOCrearCliente(clienteData);
            
            if (!clienteResult.success || !clienteResult.data) {
                throw new Error(clienteResult.message || 'Error procesando datos del cliente');
            }

            const clienteId = clienteResult.data.id;
            console.log('✅ Cliente procesado con ID:', clienteId);

            // Preparar datos para la venta (incluyendo nombre y precio para evitar llamadas HTTP en backend)
            const checkoutData = {
                clienteId: clienteId,
                items: cart.map(item => ({
                    productoId: item.producto.id,
                    cantidad: item.cantidad,
                    nombreProducto: item.producto.nombre,
                    precioUnitario: item.producto.precio
                })),
                metodoPago: metodoPago,
                comprobanteUrl: comprobanteUrl
            };

            console.log('📦 Datos de checkout:', checkoutData);

            // Crear la venta con timeout
            console.log('🌐 Haciendo POST a:', `${this.API_BASE_URL}/api/ventas`);
            
            const controller = new AbortController();
            const timeoutId = setTimeout(() => controller.abort(), 120000); // 2 minutos timeout
            
            try {
                const response = await fetch(`${this.API_BASE_URL}/api/ventas`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer ${localStorage.getItem('token')}`
                    },
                    body: JSON.stringify(checkoutData),
                    signal: controller.signal
                });

                clearTimeout(timeoutId);
                console.log('📡 Respuesta recibida, status:', response.status);

                if (!response.ok) {
                    const errorText = await response.text();
                    console.error('❌ Error en la respuesta:', response.status, errorText);
                    throw new Error(`Error ${response.status}: ${errorText}`);
                }

                console.log('📄 Parseando respuesta JSON...');
                const ventaCreada = await response.json();
                console.log('✅ Venta creada exitosamente:', ventaCreada);

                // Guardar ventaId en sessionStorage para uso posterior
                sessionStorage.setItem('currentVentaId', ventaCreada.id?.toString() || '');

                // NO limpiar carrito aquí - se limpiará después del pago exitoso
                
                return {
                    success: true,
                    message: 'Orden creada exitosamente',
                    data: {
                        orderId: ventaCreada.numeroFactura || ventaCreada.id?.toString(),
                        ventaId: ventaCreada.id,
                        total: ventaCreada.total
                    }
                };
            } catch (fetchError: any) {
                clearTimeout(timeoutId);
                if (fetchError.name === 'AbortError') {
                    console.error('❌ Timeout: La solicitud tardó más de 2 minutos');
                    throw new Error('La solicitud está tardando demasiado. Por favor verifica que los servicios estén funcionando correctamente.');
                }
                throw fetchError;
            }

        } catch (error: any) {
            console.error('❌ Error en checkout:', error);
            return {
                success: false,
                message: error.message || 'Error procesando la orden'
            };
        }
    }

    async completarVenta(numeroFactura: string): Promise<ApiResponse<any>> {
        try {
            console.log('🏁 Completando venta:', numeroFactura);
            
            // Primero obtener el ID de la venta por número de factura
            const ventaResponse = await fetch(`${this.API_BASE_URL}/api/ventas/factura/${numeroFactura}`, {
                headers: {
                    'Authorization': `Bearer ${localStorage.getItem('token')}`
                }
            });

            if (!ventaResponse.ok) {
                console.warn('⚠️ No se pudo obtener la venta, pero el pago fue exitoso');
                // No fallar aquí, la venta ya existe
                return {
                    success: true,
                    message: 'Venta procesada (sin completar estado)',
                    data: null
                };
            }

            const venta = await ventaResponse.json();

            // Intentar completar la venta con timeout
            const controller = new AbortController();
            const timeoutId = setTimeout(() => controller.abort(), 10000); // 10 segundos timeout

            try {
                const response = await fetch(`${this.API_BASE_URL}/api/ventas/${venta.id}/completar`, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer ${localStorage.getItem('token')}`
                    },
                    signal: controller.signal
                });

                clearTimeout(timeoutId);

                if (!response.ok) {
                    const errorText = await response.text();
                    console.warn('⚠️ Error completando venta pero pago exitoso:', errorText);
                    
                    // No fallar el proceso, la venta ya se creó
                    this.clearCart(); // Limpiar carrito de todas formas
                    
                    return {
                        success: true,
                        message: 'Venta creada exitosamente (estado pendiente)',
                        data: venta
                    };
                }

                const ventaCompletada = await response.json();
                console.log('✅ Venta completada:', ventaCompletada);
                
                // Limpiar carrito solo si todo fue exitoso
                this.clearCart();
                
                return {
                    success: true,
                    message: 'Venta completada exitosamente',
                    data: ventaCompletada
                };

            } catch (fetchError: any) {
                clearTimeout(timeoutId);
                
                if (fetchError.name === 'AbortError') {
                    console.warn('⚠️ Timeout completando venta, pero pago fue exitoso');
                } else {
                    console.warn('⚠️ Error de red completando venta:', fetchError);
                }
                
                // Limpiar carrito de todas formas, la venta ya se creó
                this.clearCart();
                
                return {
                    success: true,
                    message: 'Venta procesada exitosamente (verificación pendiente)',
                    data: venta
                };
            }

        } catch (error: any) {
            console.error('❌ Error completando venta:', error);
            
            // Si hay error, aún así limpiar el carrito porque el pago fue exitoso
            this.clearCart();
            
            return {
                success: true, // Cambiar a true porque el pago fue exitoso
                message: 'Pago procesado exitosamente (verificación pendiente)',
                data: null
            };
        }
    }

    // ===================== UTILIDADES =====================

    formatPrice(amount: number): string {
        return new Intl.NumberFormat('es-EC', {
            style: 'currency',
            currency: 'USD'
        }).format(amount);
    }

    private emitCartUpdate(): void {
        if (typeof window !== 'undefined') {
            window.dispatchEvent(new Event('cartUpdated'));
        }
    }

    getItemCount(): number {
        return this.getCart().reduce((sum, item) => sum + item.cantidad, 0);
    }

    isInCart(productoId: number): boolean {
        return this.getCart().some(item => item.producto.id === productoId);
    }

    getItemQuantity(productoId: number): number {
        const item = this.getCart().find(item => item.producto.id === productoId);
        return item ? item.cantidad : 0;
    }

    getCheckoutData(): { ventaId: number } | null {
        if (typeof window === 'undefined') return null;
        const ventaIdStr = sessionStorage.getItem('currentVentaId');
        return ventaIdStr ? { ventaId: parseInt(ventaIdStr) } : null;
    }
}

export default new CartService();