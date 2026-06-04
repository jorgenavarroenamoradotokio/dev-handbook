> **Estado:** 🟢 Completo
> **Última actualización:** 2026-06
> **Nivel:** Principiante — se explican los conceptos desde cero

---

- [13. Systemd y Gestión de Servicios](#13-systemd-y-gestión-de-servicios)
  - [Gestión básica de servicios](#gestión-básica-de-servicios)
  - [Targets (equivalente a runlevels)](#targets-equivalente-a-runlevels)
  - [Crear un servicio personalizado](#crear-un-servicio-personalizado)
  - [Apagado y reinicio](#apagado-y-reinicio)
  - [Análisis del arranque](#análisis-del-arranque)
- [14. Logs y Monitorización con journalctl](#14-logs-y-monitorización-con-journalctl)
  - [Consultas básicas](#consultas-básicas)
  - [Filtrar por servicio y tiempo](#filtrar-por-servicio-y-tiempo)
  - [Filtrar por prioridad y otros criterios](#filtrar-por-prioridad-y-otros-criterios)
  - [Gestión del espacio de logs](#gestión-del-espacio-de-logs)
  - [Logs tradicionales en /var/log](#logs-tradicionales-en-varlog)
- [15. Hardening y Seguridad Básica del Sistema](#15-hardening-y-seguridad-básica-del-sistema)
  - [Lista de verificación de seguridad básica](#lista-de-verificación-de-seguridad-básica)
  - [Comprobación rápida del estado de seguridad](#comprobación-rápida-del-estado-de-seguridad)

---

# 13. Systemd y Gestión de Servicios

systemd es el sistema de init moderno (PID 1) presente en todas las distribuciones principales. Gestiona el arranque, los servicios y los logs del sistema.

## Gestión básica de servicios

```bash
sudo systemctl start nginx          # Arrancar un servicio
sudo systemctl stop nginx           # Parar
sudo systemctl restart nginx        # Reiniciar (para + arranca)
sudo systemctl reload nginx         # Recargar configuración sin reiniciar (si el servicio lo soporta)
sudo systemctl enable nginx         # Arrancar automáticamente al boot
sudo systemctl disable nginx        # No arrancar al boot
sudo systemctl status nginx         # Ver estado detallado con logs recientes
sudo systemctl is-active nginx      # ¿Está corriendo? (0=sí, útil en scripts)
sudo systemctl is-enabled nginx     # ¿Está habilitado para el boot?

systemctl --failed                  # Ver todos los servicios que han fallado
systemctl list-units --type=service # Listar todos los servicios
systemctl list-units --type=service --state=running  # Solo los activos
```

## Targets (equivalente a runlevels)

```bash
systemctl get-default                           # Ver el target actual
sudo systemctl set-default multi-user.target    # Servidor sin interfaz gráfica
sudo systemctl set-default graphical.target     # Con interfaz gráfica

# Cambiar de target temporalmente (sin cambiar el por defecto)
sudo systemctl isolate rescue.target            # Ir a modo rescate

# Targets principales:
# poweroff.target   → Apagar el sistema
# rescue.target     → Modo rescate (sin red, solo root)
# multi-user.target → Multiusuario, sin gráficos (servidores)
# graphical.target  → Con escritorio gráfico
# reboot.target     → Reiniciar el sistema
```

## Crear un servicio personalizado

```bash
# Crear el archivo de unit en /etc/systemd/system/
sudo nano /etc/systemd/system/mi_app.service

# Contenido del archivo .service:
[Unit]
Description=Mi Aplicación Web
Documentation=https://mi-app.ejemplo.com/docs
After=network.target          # Arrancar después de que la red esté lista
Wants=network.target

[Service]
Type=simple
User=www-data
WorkingDirectory=/opt/mi_app
ExecStart=/usr/bin/python3 /opt/mi_app/server.py
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure            # Reiniciar automáticamente si falla
RestartSec=5                  # Esperar 5 segundos antes de reiniciar
StandardOutput=journal        # Logs a journald
StandardError=journal

[Install]
WantedBy=multi-user.target    # Se activa en el target multiusuario

# Activar el nuevo servicio
sudo systemctl daemon-reload  # ★ Obligatorio tras crear/modificar un .service
sudo systemctl enable mi_app  # Habilitar en el boot
sudo systemctl start mi_app   # Arrancar ahora
sudo systemctl status mi_app  # Verificar
```

## Apagado y reinicio

```bash
sudo systemctl poweroff         # Apagar el sistema (limpiamente)
sudo systemctl reboot           # Reiniciar el sistema
sudo systemctl suspend          # Suspender a RAM
sudo systemctl hibernate        # Hibernar a disco

sudo shutdown -h now            # Apagar inmediatamente
sudo shutdown -h +30            # Apagar en 30 minutos
sudo shutdown -r now            # Reiniciar inmediatamente
sudo shutdown -r 02:00          # Reiniciar a las 2 AM
sudo shutdown -c                # Cancelar un shutdown programado

# Enviar mensaje a los usuarios conectados antes de apagar
sudo shutdown -h +10 "El servidor se apagará en 10 minutos por mantenimiento."
```

## Análisis del arranque

```bash
systemd-analyze                             # Tiempo total de arranque
systemd-analyze blame | head -20            # Qué servicio tarda más en arrancar
systemd-analyze critical-chain              # Árbol de dependencias críticas del arranque
systemd-analyze plot > arranque.svg         # Generar diagrama SVG del arranque
```

---

# 14. Logs y Monitorización con journalctl

systemd incluye `journald`, un servicio de logging centralizado que almacena logs binarios con metadatos ricos (servicio, usuario, PID, etc.).

## Consultas básicas

```bash
journalctl                              # Ver todos los logs (el más antiguo primero)
journalctl -r                           # Logs en orden inverso (más reciente primero)
journalctl -f                           # ★ Seguir logs en tiempo real (como tail -f)
journalctl -n 50                        # Últimas 50 líneas
journalctl -b                           # Logs del arranque actual
journalctl -b -1                        # Logs del arranque anterior
journalctl -k                           # Solo mensajes del kernel (dmesg)
```

## Filtrar por servicio y tiempo

```bash
journalctl -u nginx                     # Logs del servicio nginx
journalctl -u nginx -f                  # Logs de nginx en tiempo real
journalctl -u nginx -n 100              # Últimas 100 líneas de nginx
journalctl -u nginx --since "1 hour ago"
journalctl -u nginx --since "2026-01-01 10:00" --until "2026-01-01 11:00"
journalctl --since "today"
journalctl --since "yesterday"
journalctl --since "2 hours ago"
```

## Filtrar por prioridad y otros criterios

```bash
# Niveles de prioridad: emerg(0), alert(1), crit(2), err(3), warning(4), notice(5), info(6), debug(7)
journalctl -p err                       # Solo errores y superiores (err, crit, alert, emerg)
journalctl -p warning                   # Warnings y superiores
journalctl -p 3                         # Por número (0-7)

journalctl _UID=1000                    # Logs generados por el usuario con UID 1000
journalctl _PID=1234                    # Logs del proceso 1234
journalctl -u ssh -p err               # Errores del servicio SSH
```

## Gestión del espacio de logs

```bash
journalctl --disk-usage                 # Ver cuánto espacio ocupan los logs
sudo journalctl --vacuum-size=500M      # Reducir hasta que ocupen menos de 500MB
sudo journalctl --vacuum-time=30d       # Eliminar logs con más de 30 días
sudo journalctl --vacuum-files=10       # Mantener solo los últimos 10 archivos de log

# Configurar retención en /etc/systemd/journald.conf
# SystemMaxUse=500M       → Máximo espacio en disco para logs
# MaxRetentionSec=1month  → Máximo tiempo de retención
sudo systemctl restart systemd-journald # Aplicar cambios
```

## Logs tradicionales en /var/log

Además de journald, muchos servicios siguen escribiendo en `/var/log/`:

```bash
/var/log/syslog             # Log general del sistema (Debian/Ubuntu)
/var/log/messages           # Log general del sistema (RHEL/Rocky)
/var/log/auth.log           # Autenticaciones, sudo, SSH (Debian/Ubuntu)
/var/log/secure             # Equivalente en RHEL/Rocky
/var/log/kern.log           # Mensajes del kernel
/var/log/dpkg.log           # Instalaciones de paquetes (Debian/Ubuntu)
/var/log/apt/               # Logs detallados de APT
/var/log/nginx/             # Logs de Nginx (access.log, error.log)
/var/log/apache2/           # Logs de Apache
/var/log/mysql/             # Logs de MySQL

# Rotación de logs (logrotate)
cat /etc/logrotate.conf                 # Configuración global
ls /etc/logrotate.d/                    # Configuraciones por servicio
sudo logrotate -f /etc/logrotate.conf   # Forzar rotación ahora
```

---

# 15. Hardening y Seguridad Básica del Sistema

El hardening es el proceso de reducir la **superficie de ataque** de un servidor. Estos son los pasos esenciales tras una instalación limpia.

## Lista de verificación de seguridad básica

```bash
# 1. ACTUALIZAR EL SISTEMA
sudo apt update && sudo apt upgrade -y  # Debian/Ubuntu
sudo dnf update -y                      # RHEL/Rocky

# 2. DESHABILITAR SERVICIOS INNECESARIOS
systemctl list-units --type=service --state=running   # Ver qué está corriendo
sudo systemctl disable --now telnet                   # Ejemplo: deshabilitar Telnet
sudo systemctl disable --now cups                     # Impresoras (si es un servidor)
sudo systemctl disable --now avahi-daemon             # Descubrimiento de red (si no se usa)

# 3. SSH SEGURO (ver sección 11.2 para detalles completos)
# Cambiar puerto, deshabilitar root, solo claves SSH

# 4. FIREWALL ACTIVO
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 2222/tcp          # Tu puerto SSH personalizado
sudo ufw enable

# 5. FAIL2BAN — Bloquear IPs con demasiados intentos fallidos
sudo apt install fail2ban
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo nano /etc/fail2ban/jail.local
# [sshd]
# enabled = true
# port = 2222
# maxretry = 3
# bantime = 3600
sudo systemctl enable --now fail2ban
sudo fail2ban-client status sshd      # Ver IPs baneadas

# 6. AUDITORÍA DE ARCHIVOS SUID/SGID
find / -perm -4000 -type f 2>/dev/null   # Archivos con SUID
find / -perm -2000 -type f 2>/dev/null   # Archivos con SGID

# 7. CUENTAS DE USUARIO — Principio de mínimo privilegio
# Solo los usuarios necesarios con los grupos necesarios
# Bloquear cuentas de servicio que no necesitan shell
sudo usermod -s /usr/sbin/nologin nombre_servicio

# 8. CONTRASEÑAS SEGURAS
sudo nano /etc/security/pwquality.conf
# minlen = 12        → Mínimo 12 caracteres
# dcredit = -1       → Al menos 1 dígito
# ucredit = -1       → Al menos 1 mayúscula
# lcredit = -1       → Al menos 1 minúscula
# ocredit = -1       → Al menos 1 carácter especial

# 9. LIMITS — Limitar recursos por usuario (protección contra DoS básico)
sudo nano /etc/security/limits.conf
# *  soft  nproc  1024     → Máximo 1024 procesos por usuario
# *  hard  nproc  2048

# 10. VERIFICAR PUERTOS ABIERTOS Y SERVICIOS ESCUCHANDO
ss -tulpn                                     # ¿Qué servicios están escuchando y en qué puertos?
sudo nmap -sV localhost                        # Escaneo local de puertos

# 11. ACTUALIZACIONES DE SEGURIDAD AUTOMÁTICAS (Debian/Ubuntu)
sudo apt install unattended-upgrades
sudo dpkg-reconfigure unattended-upgrades     # Activar actualizaciones automáticas

# 12. MONITORIZAR ACCESOS AL SISTEMA
last                                          # Últimos logins
lastb                                         # Intentos fallidos de login
journalctl -u ssh --since "1 day ago" | grep "Failed"   # Ataques SSH recientes
```

## Comprobación rápida del estado de seguridad

```bash
# Script de verificación rápida de seguridad
echo "=== Estado del Sistema ==="
uname -r                                        # Versión del kernel
echo ""

echo "=== Actualizaciones Pendientes ==="
apt list --upgradable 2>/dev/null | wc -l       # Número de paquetes actualizables

echo "=== Servicios Fallidos ==="
systemctl --failed --no-legend

echo "=== Puertos en Escucha ==="
ss -tulpn | grep LISTEN

echo "=== Últimos 5 Logins ==="
last -5

echo "=== Intentos Fallidos SSH (últimas 24h) ==="
journalctl -u ssh --since "1 day ago" 2>/dev/null | grep "Failed" | wc -l
```

---

<div align="center">

---