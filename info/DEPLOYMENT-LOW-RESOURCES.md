# 🚨 Guía de Despliegue para Servidores con Recursos Limitados

## Tu Servidor
- **RAM:** 1.4GB disponible (3.6GB total)
- **CPU:** 2 cores
- **Disco:** 30GB libres

## ⚠️ Análisis de Recursos

Tu configuración actual necesita **~3.5GB RAM** pero solo tienes **1.4GB disponible**.

### Opciones de Solución

---

## ✅ OPCIÓN 1: Configuración Light (RECOMENDADA)

Usa `docker-compose.light.yml` que optimiza el uso de RAM:

### Cambios aplicados:
- ❌ **Sin Eureka Server** (ahorra ~500MB)
- ✅ **Límites de memoria estrictos** en cada contenedor
- ✅ **JVM optimizada** con heap reducido
- ✅ **MySQL optimizado** (innodb_buffer_pool_size=256M)

### Uso estimado: ~2.4GB RAM

| Servicio | RAM Límite | RAM Reservada |
|----------|------------|---------------|
| MySQL | 512M | 256M |
| msvc-producto | 400M | 256M |
| msvc-inventario | 400M | 256M |
| msvc-ventas | 800M | 512M |
| Frontend | 128M | 64M |
| **TOTAL** | **2.24GB** | **1.34GB** |

### Desplegar:

```bash
# 1. Configurar swap (aumenta memoria virtual)
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# 2. Verificar swap
free -h

# 3. Configurar variables
cp .env.example .env
nano .env

# 4. Levantar con configuración light
docker-compose -f docker-compose.light.yml up -d --build
```

### ⚠️ Limitaciones:
- Sin Eureka (service discovery deshabilitado)
- Rendimiento reducido bajo alta carga
- Puede usar swap en picos de tráfico

---

## 💰 OPCIÓN 2: Upgrade del Servidor (MEJOR SOLUCIÓN)

### Recomendación: Servidor con 4GB RAM mínimo

Costos estimados mensuales:
- **DigitalOcean:** Droplet 4GB RAM - $24/mes
- **AWS EC2:** t3.medium (2 vCPU, 4GB) - ~$30/mes
- **Linode:** 4GB RAM - $24/mes
- **Hetzner:** CX21 (2 vCPU, 4GB) - ~€5/mes (~$6)

Con 4GB RAM podrás usar la configuración completa con Eureka.

---

## 🔧 OPCIÓN 3: Despliegue Parcial

Levantar solo servicios esenciales:

```yaml
# Comentar servicios no críticos en docker-compose.yml
# services:
#   eureka-server:  # Comentar
#   msvc-inventario:  # Si no usas inventario ahora
```

---

## 📊 Monitoreo de Recursos

### Ver uso en tiempo real:
```bash
# Recursos de contenedores
docker stats

# Memoria del sistema
free -h
watch -n 2 free -h

# Procesos que más consumen
top
htop  # si está instalado
```

### Configurar alertas:
```bash
# Script simple de monitoreo
cat > /usr/local/bin/check-memory.sh << 'EOF'
#!/bin/bash
MEM_AVAILABLE=$(free -m | awk 'NR==2{print $7}')
if [ $MEM_AVAILABLE -lt 200 ]; then
    echo "ALERTA: Solo ${MEM_AVAILABLE}MB RAM disponible"
    # Opcional: reiniciar contenedores pesados
    docker-compose restart msvc-ventas
fi
EOF

chmod +x /usr/local/bin/check-memory.sh

# Ejecutar cada 5 minutos
(crontab -l 2>/dev/null; echo "*/5 * * * * /usr/local/bin/check-memory.sh") | crontab -
```

---

## 🐌 Si el Sistema se Vuelve Lento

### 1. Liberar memoria caché:
```bash
sudo sync
sudo sysctl -w vm.drop_caches=3
```

### 2. Reiniciar contenedor más pesado:
```bash
docker-compose restart msvc-ventas
```

### 3. Ver logs de OOM (Out of Memory):
```bash
dmesg | grep -i "out of memory"
docker logs msvc-ventas --tail 100
```

---

## 🎯 Optimizaciones Adicionales

### 1. Reducir logs:
```bash
# En docker-compose.light.yml, agregar a cada servicio:
logging:
  driver: "json-file"
  options:
    max-size: "5m"
    max-file: "2"
```

### 2. Desactivar servicios innecesarios del servidor:
```bash
# Ver servicios activos
systemctl list-units --type=service --state=running

# Desactivar servicios no usados (ejemplo)
sudo systemctl stop apache2
sudo systemctl disable apache2
```

### 3. Programar reinicios nocturnos:
```bash
# Reiniciar contenedores a las 3 AM
(crontab -l 2>/dev/null; echo "0 3 * * * cd /ruta/proyecto && docker-compose restart") | crontab -
```

---

## ✅ Checklist para Despliegue Light

- [ ] Configurar swap de 2GB
- [ ] Verificar `free -h` muestra swap activo
- [ ] Copiar `.env.example` a `.env`
- [ ] Configurar claves de Stripe en `.env`
- [ ] Desplegar con `docker-compose.light.yml`
- [ ] Verificar con `docker stats` que no supera límites
- [ ] Configurar monitoreo de memoria
- [ ] Probar funcionalidad completa
- [ ] Configurar backup automático de BD

---

## 🚨 Señales de que Necesitas Más RAM

- Contenedores se reinician solos (OOMKilled)
- Sistema muy lento o "se congela"
- Error: "Cannot allocate memory"
- Swap al 100% constantemente
- Respuestas HTTP > 5 segundos

**→ En ese caso, debes hacer upgrade del servidor**

---

## 📞 Soporte

Si tienes problemas con el despliegue, revisa:
1. `docker-compose logs [servicio]`
2. `free -h` para ver memoria disponible
3. `docker stats` para ver uso de contenedores

---

## 🎓 Nota para tu Tesis

Documenta las limitaciones del servidor y las optimizaciones aplicadas:
- Configuración light sin Eureka
- Límites de memoria por contenedor
- Uso de swap para memoria virtual
- Trade-offs: rendimiento vs recursos

Esto demuestra consideración de restricciones reales en producción.

---

*Última actualización: Febrero 2026*
