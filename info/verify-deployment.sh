#!/bin/bash

# Script de verificación post-despliegue
# Verifica que todos los servicios estén funcionando correctamente

echo "🔍 Verificando servicios de ECommerce Siachos..."
echo ""

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para verificar servicio
check_service() {
    local service_name=$1
    local url=$2
    local expected_status=${3:-200}
    
    echo -n "Verificando $service_name... "
    
    if curl -s -o /dev/null -w "%{http_code}" "$url" | grep -q "$expected_status"; then
        echo -e "${GREEN}✓ OK${NC}"
        return 0
    else
        echo -e "${RED}✗ FAIL${NC}"
        return 1
        
    fi
}

# Esperar a que los servicios estén listos
echo "Esperando a que los servicios inicien (60s)..."
sleep 60

# Verificar servicios
failed=0

check_service "MySQL" "http://localhost:3306" "000" || ((failed++))
check_service "Eureka Server" "http://localhost:8761" || ((failed++))
check_service "Microservicio Productos" "http://localhost:8081/actuator/health" || ((failed++))
check_service "Microservicio Inventario" "http://localhost:8082/actuator/health" || ((failed++))
check_service "Microservicio Ventas" "http://localhost:8083/actuator/health" || ((failed++))
check_service "Frontend" "http://localhost:3000" || ((failed++))
check_service "Camunda Cockpit" "http://localhost:8083/camunda" || ((failed++))

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $failed -eq 0 ]; then
    echo -e "${GREEN}✓ Todos los servicios están funcionando correctamente${NC}"
    echo ""
    echo "Accesos:"
    echo "  • Frontend: http://localhost:3000"
    echo "  • Camunda: http://localhost:8083/camunda (admin/admin)"
    echo "  • Eureka: http://localhost:8761"
    exit 0
else
    echo -e "${RED}✗ $failed servicio(s) fallaron${NC}"
    echo ""
    echo "Ejecuta: docker-compose logs [servicio] para ver detalles"
    exit 1
fi
