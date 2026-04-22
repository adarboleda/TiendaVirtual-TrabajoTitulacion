# Especificaciones de Servidor para ECommerce Siachos

## 📋 Análisis de Servidor Actual

### Tu Servidor:
```
Memoria RAM:    3.6GB total / 1.4GB disponible
CPUs:           2 cores
Disco:          30GB libres (suficiente)
Sistema:        Linux AlmaLinux
```

### ⚠️ Diagnóstico:
**🔴 CRÍTICO - RAM INSUFICIENTE**

Tu aplicación requiere aproximadamente **3.5-4GB de RAM** solo para los servicios Docker:

| Servicio | RAM Requerida |
|----------|---------------|
| MySQL 8.0 | ~512MB |
| Eureka Server | ~500MB |
| msvc-producto | ~500MB |
| msvc-inventario | ~500MB |
| msvc-ventas + Camunda | ~1GB |
| Frontend Nginx | ~50MB |
| Sistema operativo | ~800MB |
| **TOTAL** | **~4GB** |

Con solo **1.4GB disponible**, el servidor colapsará por falta de memoria (OOM - Out Of Memory).

---

## 🎯 Especificaciones Recomendadas

### Opción 1: Mínimo Viable (Producción Ligera)
```
RAM:            6GB
CPUs:           4 cores (2.4GHz+)
Disco:          50GB SSD
Ancho de banda: 3TB/mes
Sistema:        Ubuntu 22.04 LTS / Debian 12
```

**Capacidad:**
- 30-50 usuarios concurrentes
- 100-200 transacciones/hora
- Adecuado para pruebas de tesis
- Margen de seguridad: 30%

**Costo aproximado:** $20-30/mes

**Proveedores:**
- DigitalOcean Basic Droplet
- Linode Shared 4GB
- Vultr High Frequency 4GB

---

### Opción 2: Recomendado (Producción Estable) ⭐ **IDEAL**
```
RAM:            8GB
CPUs:           4 cores (3.0GHz+)
Disco:          80GB SSD NVMe
Ancho de banda: 5TB/mes
Sistema:        Ubuntu 22.04 LTS
```

**Capacidad:**
- 80-120 usuarios concurrentes
- 500-800 transacciones/hora
- Perfecto para tesis + demo real
- Margen de seguridad: 50%
- Permite monitoreo (Prometheus/Grafana)

**Costo aproximado:** $40-50/mes

**Proveedores:**
- DigitalOcean Premium Droplet 8GB
- AWS EC2 t3.large
- Linode Dedicated 8GB
- Azure B2s (8GB RAM)

---

### Opción 3: Óptimo (Alta Carga/Producción Real)
```
RAM:            16GB
CPUs:           8 cores (3.5GHz+)
Disco:          120GB SSD NVMe
Ancho de banda: 8TB/mes
Sistema:        Ubuntu 22.04 LTS
```

**Capacidad:**
- 200+ usuarios concurrentes
- 2000+ transacciones/hora
- Producción real a largo plazo
- Margen de seguridad: 100%
- Permite escalar microservicios

**Costo aproximado:** $80-100/mes

**Proveedores:**
- DigitalOcean CPU-Optimized
- AWS EC2 t3.xlarge
- Linode Dedicated 16GB

---

## 💰 Comparativa de Proveedores

### 1. DigitalOcean (Recomendado para principiantes)

**Ventajas:**
- ✅ Interfaz muy intuitiva
- ✅ Documentación excelente
- ✅ Backups automáticos (+20%)
- ✅ Snapshots gratis
- ✅ Firewalls incluidos
- ✅ Monitoreo básico gratis
- ✅ Soporte rápido

**Planes:**
```
Basic 4GB:   $24/mes  (4GB RAM, 2 CPUs, 80GB SSD)
Basic 8GB:   $48/mes  (8GB RAM, 4 CPUs, 160GB SSD) ⭐
Premium 8GB: $63/mes  (8GB RAM, 2 CPUs, 50GB NVMe)
```

**Cupón estudiante:** $200 crédito gratis (GitHub Student Pack)

---

### 2. Linode/Akamai (Mejor precio/calidad)

**Ventajas:**
- ✅ Excelente precio
- ✅ Red Akamai (muy rápida)
- ✅ Soporte 24/7
- ✅ Backups automáticos ($2-5/mes)
- ✅ Object Storage S3-compatible

**Planes:**
```
Shared 4GB:     $24/mes  (4GB RAM, 2 CPUs, 80GB SSD)
Dedicated 8GB:  $36/mes  (8GB RAM, 4 CPUs, 160GB SSD) ⭐ MEJOR PRECIO
Dedicated 16GB: $72/mes  (16GB RAM, 8 CPUs, 320GB SSD)
```

---

### 3. AWS EC2 (Más escalable, más complejo)

**Ventajas:**
- ✅ Máxima escalabilidad
- ✅ Integración con otros servicios AWS
- ✅ RDS para base de datos gestionada
- ✅ Load balancers
- ✅ Certificados SSL gratis (ACM)

**Desventajas:**
- ❌ Curva de aprendizaje alta
- ❌ Facturación compleja
- ❌ Costos variables

**Planes (on-demand):**
```
t3.medium:  $30/mes   (4GB RAM, 2 vCPUs)
t3.large:   $60/mes   (8GB RAM, 2 vCPUs) ⭐
t3.xlarge:  $120/mes  (16GB RAM, 4 vCPUs)
```

**Opción ahorro:** Reserved Instances (1 año) = 40% descuento

---

### 4. Contabo (Más barato, Europa)

**Ventajas:**
- ✅ Precio extremadamente bajo
- ✅ Mucho disco incluido
- ✅ Buenas specs por precio

**Desventajas:**
- ❌ Servidores en Alemania/Europa (latencia)
- ❌ Soporte básico
- ❌ Menos documentación

**Planes:**
```
VPS S:  €5/mes   (~$6)   (4GB RAM, 2 CPUs, 100GB SSD)
VPS M:  €7/mes   (~$8)   (8GB RAM, 4 CPUs, 200GB SSD) ⭐ MÁS BARATO
VPS L:  €13/mes  (~$15)  (16GB RAM, 6 CPUs, 400GB SSD)
```

---

### 5. Vultr (Alternativa sólida)

**Ventajas:**
- ✅ Alta velocidad (NVMe)
- ✅ Múltiples ubicaciones
- ✅ Good performance
- ✅ Bare metal disponible

**Planes:**
```
Regular 4GB:        $24/mes  (4GB RAM, 2 CPUs, 80GB SSD)
High Frequency 8GB: $48/mes  (8GB RAM, 4 CPUs, 128GB NVMe) ⭐
Regular 8GB:        $48/mes  (8GB RAM, 4 CPUs, 160GB SSD)
```

---

## 🏆 Mi Recomendación Final

### Para tu Tesis y Puesta en Producción:

**Opción A (Mejor Precio):**
```
Proveedor: Linode Dedicated 8GB
Precio:    $36/mes
Specs:     8GB RAM / 4 CPUs / 160GB SSD
```
✅ Mejor relación precio/calidad  
✅ Suficiente para tesis y producción ligera  
✅ Fácil de configurar

---

**Opción B (Más Fácil):**
```
Proveedor: DigitalOcean Basic 8GB
Precio:    $48/mes ($0 primeros 2 meses con cupón)
Specs:     8GB RAM / 4 CPUs / 160GB SSD
```
✅ Interfaz más amigable  
✅ Mejor documentación  
✅ Crédito gratis estudiante  
✅ Backups automáticos opcionales

---

**Opción C (Presupuesto Extremo):**
```
Proveedor: Contabo VPS M
Precio:    €7/mes (~$8/mes)
Specs:     8GB RAM / 4 CPUs / 200GB SSD
```
✅ Precio imbatible  
⚠️ Latencia mayor desde Ecuador  
⚠️ Soporte limitado

---

## 🔧 Por Qué Estas Especificaciones

### RAM (8GB recomendado):
- **MySQL:** 1GB para base de datos con índices y cache
- **Eureka:** 512MB para registro de servicios
- **msvc-producto:** 500MB + overhead para catálogo
- **msvc-inventario:** 500MB + transacciones concurrentes
- **msvc-ventas + Camunda:** 1-1.5GB (BPM consume memoria)
- **Frontend Nginx:** 100MB (estático + proxy)
- **Sistema Ubuntu:** 1GB base + buffers
- **Buffer picos:** 1-2GB para tráfico alto
- **Monitoreo (opcional):** 500MB para logs/métricas

**Total mínimo:** 5.5GB usado  
**Con 8GB:** Margen 45% para escalabilidad

---

### CPUs (4 cores recomendado):
- Spring Boot es **multi-thread** por naturaleza
- Camunda BPM procesa workflows en paralelo
- MySQL necesita CPU para:
  - Queries complejas (JOINs)
  - Índices
  - Transacciones concurrentes
- Frontend puede servir múltiples usuarios simultáneamente
- Docker overhead (~10% CPU)

**2 CPUs = bottleneck bajo carga**  
**4 CPUs = balance adecuado**  
**8 CPUs = óptimo para producción**

#### 🔍 Análisis Detallado: ¿Son Suficientes 2 CPUs?

**Respuesta Corta:** Sí, PUEDE funcionar con 2 cores, pero con limitaciones importantes.

##### ✅ Con 2 CPUs funcionará SI:
- **Tráfico bajo:** Máximo 5-15 usuarios simultáneos
- **Sin pruebas de carga intensivas:** No stress testing con JMeter > 30 usuarios virtuales
- **Operaciones simples:** Navegación, búsqueda, compras ocasionales
- **Uso para demos:** Presentar funcionalidad para tesis/demostración
- **Tolerancia a lentitud:** Aceptas tiempos de respuesta de 2-4 segundos en picos

##### ⚠️ Problemas Esperados con 2 CPUs:

**Rendimiento:**
- **Lentitud en picos:** Cuando Camunda procesa workflows + MySQL hace queries + varios usuarios = 100% CPU constante
- **Timeouts ocasionales:** Requests pueden tardar 3-5 segundos bajo carga moderada (10+ usuarios)
- **Latencia perceptible:** Navegación "poco fluida" cuando hay actividad concurrente

**Desarrollo/Testing:**
- **Compilation lenta:** `docker-compose build` tardará 15-20 minutos (vs 5-8 min con 4 cores)
- **Pruebas JMeter limitadas:** Solo podrás simular 20-30 usuarios virtuales sin saturar el servidor
- **Documentación limitada:** Difícil obtener métricas de performance impresionantes para tu tesis

**Producción:**
- **Sin margen de crecimiento:** Sistema al límite con tráfico normal
- **Vulnerable a picos:** Un proceso pesado (generación masiva de facturas, backup) puede tumbar el servicio

##### 📊 Distribución Real de CPU Esperada:

```
┌─────────────────────────────────────────────────────────┐
│ ESCENARIO 1: Sistema en Reposo (sin usuarios activos)  │
└─────────────────────────────────────────────────────────┘
MySQL:                    20-30% de 1 core
Eureka Server:            5-8% de CPU
msvc-producto:            8-10% de CPU
msvc-inventario:          8-10% de CPU
msvc-ventas + Camunda:    15-20% de CPU
Frontend Nginx:           2-5% de CPU
Sistema operativo:        10-15% de CPU
─────────────────────────────────────────────────────────
TOTAL:                    ~68-98% de 2 cores

┌─────────────────────────────────────────────────────────┐
│ ESCENARIO 2: Tráfico Moderado (10 usuarios activos)    │
└─────────────────────────────────────────────────────────┘
MySQL (queries concurrentes):        50-70% de 1 core
msvc-ventas (BPM workflows):         40-50% de CPU
msvc-producto + inventario:          30-40% de CPU
Frontend (serving):                  10-15% de CPU
Sistema + overhead:                  15-20% de CPU
─────────────────────────────────────────────────────────
TOTAL:                    ~145-195% → 90-100% de 2 cores
                          ⚠️ Sistema al límite, colas de espera

┌─────────────────────────────────────────────────────────┐
│ ESCENARIO 3: Alta Carga (20-30 usuarios simultáneos)   │
└─────────────────────────────────────────────────────────┘
MySQL (conexiones saturadas):        80-100% de 1 core
Microservicios (requests en cola):   90-120% de CPU
Camunda (workflows paralelos):       40-60% de CPU
Frontend + Sistema:                  20-30% de CPU
─────────────────────────────────────────────────────────
TOTAL:                    ~230-310% → 100% constante
                          🔴 Saturación total, timeouts frecuentes
```

##### 💡 Casos de Uso por Tipo de CPU:

| Configuración | Ideal Para | No Apto Para |
|---------------|------------|--------------|
| **2 CPUs** | • Demos cortas<br>• Desarrollo local<br>• Tesis sin métricas de performance<br>• Presupuesto muy limitado | • Pruebas de carga<br>• Producción real<br>• Múltiples usuarios concurrentes<br>• Documentar escalabilidad |
| **4 CPUs** ⭐ | • Producción ligera-media<br>• Pruebas JMeter (50-100 usuarios)<br>• Tesis con métricas profesionales<br>• Balance precio/rendimiento | • Tráfico masivo (500+ usuarios)<br>• Aplicaciones críticas 24/7 |
| **8 CPUs** | • Producción real<br>• Alta concurrencia<br>• Aplicaciones enterprise<br>• Escalabilidad futura | • Proyectos estudiantiles<br>• Si presupuesto es prioridad |

##### 🎯 Recomendación Final sobre CPUs:

**Si tu presupuesto es MUY limitado:**
- **Opción: 2 CPUs + 6-8GB RAM**
- Costo: ~$20-25/mes (Contabo VPS S, DigitalOcean Basic 4GB)
- **Sirve para:** Presentar tesis, demos, validar funcionalidad
- **NO sirve para:** Impresionar con métricas de performance

**Si puedes invertir $10-15 más/mes:** (RECOMENDADO)
- **Opción: 4 CPUs + 8GB RAM** ⭐
- Costo: ~$36-48/mes (Linode Dedicated, DigitalOcean Basic 8GB)
- **Beneficios adicionales:**
  - Sistema responde rápido incluso con carga
  - Puedes hacer pruebas de carga para tu tesis
  - Documentar gráficas impresionantes (CPU al 40-60% bajo carga vs 100% constantemente)
  - Margen para imprevistos (backup, mantenimiento, picos de tráfico)

**Comparación de Valor:**

```
Servidor 2 CPUs:  $24/mes = $0.80/día
Servidor 4 CPUs:  $36/mes = $1.20/día

Diferencia: $0.40/día = precio de 1 café cada 3 días

Beneficio: Sistema profesional, métricas documentables,
           sin preocupaciones de performance
```

##### 📈 Impacto en tu Tesis:

**Con 2 CPUs:**
- ❌ Gráficas mostrarán CPU al 100% constantemente
- ❌ Tiempos de respuesta variables (1-5 segundos)
- ❌ Limitado a probar con pocos usuarios (< 20)
- ⚠️ Posibles comentarios del tribunal: "¿Por qué tan lento?"

**Con 4 CPUs:**
- ✅ Gráficas mostrarán uso de CPU eficiente (40-70%)
- ✅ Tiempos de respuesta consistentes (< 1 segundo)
- ✅ Puedes probar con 50-100 usuarios virtuales
- ✅ Métricas profesionales para documentar escalabilidad
- ✅ Impresiona al tribunal con performance real

**Conclusión:** Si esta tesis es importante para ti y quieres documentar un sistema que se vea profesional, **los 4 CPUs valen cada centavo extra**.

---

### Disco (80GB SSD recomendado):
- **Imágenes Docker:** 8-12GB (base + layers)
- **Base de datos MySQL:**
  - Inicial: 500MB
  - Crecimiento: 2-5GB/año (productos, ventas, usuarios)
- **PDFs Facturas:** 100KB/factura × 10,000 = 1GB
- **Logs aplicación:** 2-5GB (con rotación)
- **Sistema operativo:** 8-10GB (Ubuntu)
- **Backups locales:** 10-15GB (opcional)
- **Buffer:** 20GB libre para operaciones

**50GB = justo**  
**80GB = cómodo** ⭐  
**120GB = ideal para crecimiento**

---

## 🚀 Pasos para Migrar a Nuevo Servidor

### 1. Contratar Servidor (DigitalOcean ejemplo)

```bash
# Crear cuenta en DigitalOcean
# Usar GitHub Student Pack para $200 crédito gratis
# https://education.github.com/pack

# Crear Droplet:
# - Imagen: Ubuntu 22.04 LTS
# - Plan: Basic 8GB / 4 CPUs
# - Datacenter: New York 1 (más cercano a Ecuador)
# - SSH Key: Agregar tu llave pública
```

### 2. Configuración Inicial del Servidor

```bash
# Conectar por SSH
ssh root@tu_ip_servidor

# Actualizar sistema
apt update && apt upgrade -y

# Instalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Instalar Docker Compose
apt install docker-compose-plugin -y

# Verificar instalación
docker --version
docker compose version

# Crear usuario no-root
adduser deploy
usermod -aG sudo deploy
usermod -aG docker deploy

# Configurar firewall
ufw allow OpenSSH
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 3000/tcp
ufw enable
```

### 3. Transferir Proyecto

```bash
# En tu máquina local
scp -r TrabajoTitulacion-main root@tu_ip:/home/deploy/

# O usar Git
ssh deploy@tu_ip
cd /home/deploy
git clone tu_repositorio
cd TrabajoTitulacion-main
```

### 4. Configurar Variables de Entorno

```bash
# En el servidor
cd /home/deploy/TrabajoTitulacion-main
cp .env.example .env
nano .env

# Configurar:
STRIPE_API_KEY=sk_live_tu_clave_real
STRIPE_WEBHOOK_SECRET=whsec_tu_webhook_real
```

### 5. Desplegar Aplicación

```bash
# Construir y levantar servicios
docker compose up -d --build

# Monitorear logs
docker compose logs -f

# Verificar servicios
docker compose ps
```

### 6. Configurar Dominio (Opcional)

```bash
# Si tienes dominio (ejemplo: siachos.com)
# 1. Apuntar DNS A record a tu IP servidor
# 2. Instalar Nginx reverse proxy
apt install nginx certbot python3-certbot-nginx

# 3. Configurar SSL con Let's Encrypt
certbot --nginx -d siachos.com -d www.siachos.com

# 4. Certificado se renueva automáticamente
```

---

## 📊 Monitoreo y Mantenimiento

### Comandos Útiles

```bash
# Ver uso de recursos en tiempo real
docker stats

# Ver logs de un servicio específico
docker compose logs -f msvc-ventas

# Reiniciar servicio con problemas
docker compose restart msvc-ventas

# Backup de base de datos
docker exec mysql-ecommerce-siachos mysqldump -u admin -padmin --all-databases > backup_$(date +%Y%m%d).sql

# Ver espacio en disco
df -h

# Ver RAM disponible
free -h

# Ver procesos top CPU/RAM
top
```

### Automatizar Backups (Cron)

```bash
# Editar crontab
crontab -e

# Agregar backup diario a las 3 AM
0 3 * * * docker exec mysql-ecommerce-siachos mysqldump -u admin -padmin --all-databases > /home/deploy/backups/backup_$(date +\%Y\%m\%d).sql

# Limpiar backups antiguos (>7 días)
0 4 * * * find /home/deploy/backups -name "backup_*.sql" -mtime +7 -delete
```

---

## ⚠️ Solución Temporal para Tu Servidor Actual (3.6GB)

Si **NO puedes** actualizar el servidor inmediatamente, aquí una configuración de emergencia:

### Modificar docker-compose.yml

Agregar límites de memoria estrictos:

```yaml
services:
  mysql:
    # ... (configuración existente)
    environment:
      MYSQL_INNODB_BUFFER_POOL_SIZE: 256M
    deploy:
      resources:
        limits:
          memory: 512M

  eureka-server:
    # ... (configuración existente)
    environment:
      JAVA_OPTS: -Xms128m -Xmx256m -XX:MaxMetaspaceSize=128m
    deploy:
      resources:
        limits:
          memory: 384M

  msvc-producto:
    # ... (configuración existente)
    environment:
      JAVA_OPTS: -Xms128m -Xmx384m -XX:MaxMetaspaceSize=128m
    deploy:
      resources:
        limits:
          memory: 512M

  msvc-inventario:
    # ... (configuración existente)
    environment:
      JAVA_OPTS: -Xms128m -Xmx384m -XX:MaxMetaspaceSize=128m
    deploy:
      resources:
        limits:
          memory: 512M

  msvc-ventas:
    # ... (configuración existente)
    environment:
      JAVA_OPTS: -Xms256m -Xmx512m -XX:MaxMetaspaceSize=128m
    deploy:
      resources:
        limits:
          memory: 768M

  frontend:
    # ... (configuración existente)
    deploy:
      resources:
        limits:
          memory: 128M
```

**Total configuración ajustada:** ~3GB

### ⚠️ Advertencias de Esta Configuración:

❌ Sistema **muy lento** bajo carga  
❌ Posibles **crashes** con más de 10 usuarios concurrentes  
❌ **No apto** para pruebas de carga  
❌ **No apto** para producción real  
✅ Solo para **demos cortas** y **desarrollo**

---

## ✅ Checklist de Migración

- [ ] Contratar servidor con 8GB RAM mínimo
- [ ] Instalar Ubuntu 22.04 LTS
- [ ] Instalar Docker + Docker Compose
- [ ] Configurar firewall (UFW)
- [ ] Transferir código del proyecto
- [ ] Configurar variables de entorno (.env)
- [ ] Configurar claves de Stripe reales
- [ ] Hacer build de imágenes Docker
- [ ] Levantar servicios con docker compose
- [ ] Verificar que todos los servicios estén healthy
- [ ] Probar flujo completo de compra
- [ ] Configurar backups automáticos
- [ ] Configurar dominio y SSL (opcional)
- [ ] Documentar credenciales y accesos
- [ ] Hacer pruebas de carga

---

## 📞 Soporte y Recursos

### Documentación Oficial:
- [DigitalOcean Docs](https://docs.digitalocean.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Nginx](https://nginx.org/en/docs/)
- [Let's Encrypt](https://letsencrypt.org/getting-started/)

### Comunidades:
- [Stack Overflow](https://stackoverflow.com/)
- [Docker Forums](https://forums.docker.com/)
- [DigitalOcean Community](https://www.digitalocean.com/community)

---

## 🎓 Recomendación Final para Tesis

Para tu trabajo de titulación, te recomiendo:

**Servidor: DigitalOcean Basic 8GB ($48/mes)**
- Usa el cupón de GitHub Student Pack ($200 gratis = 4+ meses)
- Documenta el proceso de despliegue en tu tesis
- Captura screenshots del sistema funcionando
- Realiza pruebas de carga con JMeter
- Incluye métricas de performance (RAM, CPU, tiempos de respuesta)

**Presupuesto total para 6 meses de tesis:**
- Con cupón: $0 primeros 4 meses, $96 últimos 2 meses
- Sin cupón: $288 total

**Alternativa económica:**
- Linode 8GB: $216 (6 meses)
- Contabo VPS M: $48 (6 meses) - pero con latencia

---

*Documento generado: Febrero 2026*  
*Para proyecto: ECommerce Siachos - Trabajo de Titulación*
