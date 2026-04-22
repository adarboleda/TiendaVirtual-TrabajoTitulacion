# ECommerce Siachos - Guía de Despliegue con Docker

## 🚀 Despliegue Rápido

### Prerrequisitos
- Docker 20.10+
- Docker Compose 2.0+
- 4GB RAM mínimo (8GB recomendado)
- 10GB espacio en disco

### Pasos para Producción

1. **Clonar el repositorio**
```bash
git clone <tu-repo>
cd TrabajoTitulacion-main
```

2. **Configurar variables de entorno**
```bash
cp .env.example .env
# Editar .env con tus claves de Stripe reales
nano .env
```

3. **Construir y levantar servicios**
```bash
docker-compose up -d --build
```

4. **Verificar estado de servicios**
```bash
docker-compose ps
docker-compose logs -f
```

5. **Acceder a la aplicación**
- Frontend: http://localhost:3000
- Camunda Cockpit: http://localhost:8083/camunda (admin/admin)
- Eureka Dashboard: http://localhost:8761

---

## 📦 Servicios Incluidos

| Servicio | Puerto | Descripción |
|----------|--------|-------------|
| MySQL | 3306 | Base de datos |
| Eureka Server | 8761 | Service Discovery |
| msvc-producto | 8081 | Microservicio de productos |
| msvc-inventario | 8082 | Microservicio de inventario |
| msvc-ventas | 8083 | Microservicio de ventas + Camunda |
| Frontend | 3000 | Aplicación React/Next.js |

---

## 🔧 Comandos Útiles

### Iniciar servicios
```bash
docker-compose up -d
```

### Detener servicios
```bash
docker-compose down
```

### Ver logs en tiempo real
```bash
docker-compose logs -f [nombre-servicio]
```

### Reiniciar un servicio específico
```bash
docker-compose restart msvc-ventas
```

### Reconstruir un servicio
```bash
docker-compose up -d --build msvc-ventas
```

### Limpiar todo (incluyendo volúmenes)
```bash
docker-compose down -v
```

---

## 🗄️ Gestión de Base de Datos

### Backup
```bash
docker exec mysql-ecommerce-siachos mysqldump -u admin -padmin --all-databases > backup.sql
```

### Restore
```bash
docker exec -i mysql-ecommerce-siachos mysql -u admin -padmin < backup.sql
```

### Acceder a MySQL
```bash
docker exec -it mysql-ecommerce-siachos mysql -u admin -padmin
```

---

## 🔍 Monitoreo y Troubleshooting

### Ver recursos utilizados
```bash
docker stats
```

### Inspeccionar un contenedor
```bash
docker inspect msvc-ventas
```

### Ver logs de un servicio
```bash
docker-compose logs --tail=100 msvc-ventas
```

### Entrar a un contenedor
```bash
docker exec -it msvc-ventas sh
```

---

## 🌐 Configuración para Producción

### 1. Variables de Entorno Críticas

Actualizar en `.env`:
```env
STRIPE_API_KEY=sk_live_tu_clave_real
STRIPE_WEBHOOK_SECRET=whsec_tu_webhook_real
```

### 2. Configurar Dominio

Actualizar `nginx.conf` del frontend:
```nginx
server_name tu-dominio.com;
```

### 3. SSL/HTTPS (recomendado)

Agregar servicio reverse proxy (Nginx o Traefik) con Let's Encrypt:
```yaml
nginx-proxy:
  image: nginxproxy/nginx-proxy
  ports:
    - "80:80"
    - "443:443"
  volumes:
    - /var/run/docker.sock:/tmp/docker.sock:ro
    - certs:/etc/nginx/certs
```

### 4. Limits de Recursos

Agregar a cada servicio en `docker-compose.yml`:
```yaml
deploy:
  resources:
    limits:
      cpus: '1'
      memory: 1G
    reservations:
      cpus: '0.5'
      memory: 512M
```

---

## 📊 Health Checks

Todos los servicios tienen health checks configurados:

```bash
# Ver estado de salud
docker inspect --format='{{.State.Health.Status}}' msvc-ventas
```

---

## 🔐 Seguridad

### Cambiar Credenciales por Defecto

1. **MySQL**
```yaml
environment:
  MYSQL_ROOT_PASSWORD: <tu_password_seguro>
  MYSQL_USER: <tu_usuario>
  MYSQL_PASSWORD: <tu_password>
```

2. **Camunda**
```yaml
environment:
  CAMUNDA_BPM_ADMIN_USER_PASSWORD: <tu_password_seguro>
```

### Firewall

Cerrar puertos innecesarios:
```bash
# Solo exponer frontend (3000) públicamente
# Puertos internos: 8761, 8081, 8082, 8083, 3306
```

---

## 🚨 Troubleshooting

### Problema: Servicios no inician
```bash
# Verificar logs
docker-compose logs mysql
docker-compose logs eureka-server

# Verificar health checks
docker ps
```

### Problema: Error de conexión a BD
```bash
# Verificar que MySQL está healthy
docker inspect mysql-ecommerce-siachos | grep Health

# Esperar a que termine de inicializar (primera vez tarda ~60s)
```

### Problema: Puertos ocupados
```bash
# Cambiar puertos en docker-compose.yml
ports:
  - "8084:8083"  # Puerto externo diferente
```

### Problema: Sin espacio en disco
```bash
# Limpiar imágenes no usadas
docker system prune -a

# Limpiar volúmenes no usados
docker volume prune
```

---

## 📈 Escalado

### Horizontal (múltiples instancias)
```bash
docker-compose up -d --scale msvc-producto=3
```

### Vertical (más recursos)
Actualizar `deploy.resources` en docker-compose.yml

---

## 🔄 Actualización de Código

```bash
# 1. Detener servicios
docker-compose down

# 2. Actualizar código
git pull

# 3. Reconstruir imágenes
docker-compose build

# 4. Reiniciar
docker-compose up -d
```

---

## 📝 Logs Persistentes

Configurar log rotation en `/etc/docker/daemon.json`:
```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
```

---

## ✅ Checklist Pre-Producción

- [ ] Variables de entorno configuradas (`.env`)
- [ ] Claves de Stripe reales configuradas
- [ ] Credenciales de BD cambiadas
- [ ] SSL/HTTPS configurado
- [ ] Firewall configurado
- [ ] Backup automático configurado
- [ ] Monitoreo configurado (opcional: Prometheus/Grafana)
- [ ] Logs persistentes configurados
- [ ] Domain/DNS apuntando al servidor

---

## 📧 Soporte

Para problemas o consultas: [tu-email@example.com]

*Última actualización: Febrero 2026*
