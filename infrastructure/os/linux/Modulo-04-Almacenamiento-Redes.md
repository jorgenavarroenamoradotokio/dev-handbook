> **Estado:** 🟢 Completo
> **Última actualización:** 2026-06
> **Nivel:** Principiante — se explican los conceptos desde cero

---

- [10. Almacenamiento y Sistemas de Archivos](#10-almacenamiento-y-sistemas-de-archivos)
  - [10.1 Identificar dispositivos](#101-identificar-dispositivos)
  - [10.2 Particionado de discos](#102-particionado-de-discos)
    - [fdisk — Para discos MBR (y GPT básico)](#fdisk--para-discos-mbr-y-gpt-básico)
    - [gdisk — Para discos GPT](#gdisk--para-discos-gpt)
    - [parted — Herramienta flexible (MBR y GPT)](#parted--herramienta-flexible-mbr-y-gpt)
  - [10.3 Crear sistemas de archivos (mkfs)](#103-crear-sistemas-de-archivos-mkfs)
  - [10.4 Montar y desmontar dispositivos](#104-montar-y-desmontar-dispositivos)
    - [Dispositivos extraíbles y Automontaje](#dispositivos-extraíbles-y-automontaje)
  - [10.5 Montaje permanente con /etc/fstab](#105-montaje-permanente-con-etcfstab)
  - [10.6 LVM — Logical Volume Manager](#106-lvm--logical-volume-manager)
    - [¿Por qué usar LVM?](#por-qué-usar-lvm)
- [11. Redes y Seguridad](#11-redes-y-seguridad)
  - [11.1 Configuración y diagnóstico de red](#111-configuración-y-diagnóstico-de-red)
  - [11.2 SSH seguro](#112-ssh-seguro)
    - [Generar y gestionar claves SSH](#generar-y-gestionar-claves-ssh)
    - [Asegurar el servidor SSH (/etc/ssh/sshd\_config)](#asegurar-el-servidor-ssh-etcsshsshd_config)
    - [SSH Config del cliente (~/.ssh/config)](#ssh-config-del-cliente-sshconfig)
  - [11.3 Gestión de Firewall](#113-gestión-de-firewall)
    - [UFW (Uncomplicated Firewall) — Debian/Ubuntu](#ufw-uncomplicated-firewall--debianubuntu)
    - [firewalld — RHEL/Rocky/Fedora](#firewalld--rhelrockyfedora)
    - [Cheat Sheet — Red y Seguridad](#cheat-sheet--red-y-seguridad)
- [12. Automatización con Bash Scripting](#12-automatización-con-bash-scripting)
  - [12.1 Estructura de un script](#121-estructura-de-un-script)
  - [12.2 Variables y parámetros](#122-variables-y-parámetros)
  - [12.3 Condicionales y bucles](#123-condicionales-y-bucles)
  - [12.4 Funciones y buenas prácticas](#124-funciones-y-buenas-prácticas)
  - [12.5 Cron y Anacron](#125-cron-y-anacron)
    - [cron — El planificador de tareas](#cron--el-planificador-de-tareas)
    - [Sintaxis del crontab](#sintaxis-del-crontab)
    - [Ejemplos de crontab](#ejemplos-de-crontab)
    - [anacron — Para sistemas que no están siempre encendidos](#anacron--para-sistemas-que-no-están-siempre-encendidos)
    - [Cheat Sheet — Bash Scripting y Cron](#cheat-sheet--bash-scripting-y-cron)

---

# 10. Almacenamiento y Sistemas de Archivos

## 10.1 Identificar dispositivos

En Linux, los dispositivos no aparecen como letras de unidad (E:, F:), sino que deben "montarse" en un directorio del árbol de archivos.

```bash
lsblk                           # ★ Vista en árbol de bloques de almacenamiento
lsblk -f                        # Incluye sistema de archivos, UUID y punto de montaje
sudo fdisk -l                   # Listado técnico completo de particiones
ls -l /dev/disk/by-uuid/        # Ver UUIDs (para /etc/fstab, más estable)
ls -l /dev/disk/by-label/       # Ver etiquetas de particiones

# Nombres de dispositivos:
# SATA/USB: /dev/sda, /dev/sdb, /dev/sdc...
# Particiones: /dev/sdb1 (primera partición del segundo disco)
# NVMe: /dev/nvme0n1, /dev/nvme0n1p1 (primera partición)
# Virtual (VM): /dev/vda, /dev/vdb...
```

---

## 10.2 Particionado de discos

- **MBR:** Esquema antiguo. Máximo 4 particiones primarias, discos hasta 2TB.
- **GPT:** Estándar moderno. Hasta 128 particiones, discos >2TB, requerido por UEFI.

### fdisk — Para discos MBR (y GPT básico)

```bash
sudo fdisk /dev/sdb             # Abrir el disco en fdisk
# Comandos dentro de fdisk:
# m → ayuda
# p → mostrar tabla de particiones actual
# n → nueva partición
# d → eliminar partición
# t → cambiar tipo de partición
# w → escribir cambios y salir (DESTRUCTIVO)
# q → salir sin guardar

# Flujo típico para crear una partición:
# sudo fdisk /dev/sdb → n → p → 1 → (enter) → +50G → w
```

### gdisk — Para discos GPT

```bash
sudo gdisk /dev/sdb             # Como fdisk pero para GPT
# Comandos: ? ayuda, n nueva partición, d eliminar, w guardar (DESTRUCTIVO)
```

### parted — Herramienta flexible (MBR y GPT)

```bash
sudo parted /dev/sdb mklabel gpt                   # Crear tabla GPT
sudo parted /dev/sdb mkpart primary ext4 0% 100%   # Una partición de todo el disco
sudo parted /dev/sdb mkpart primary ext4 1MiB 50GiB
sudo parted /dev/sdb print                          # Ver tabla de particiones
sudo parted /dev/sda resizepart 1 100%             # Redimensionar partición (útil en VMs)
```

---

## 10.3 Crear sistemas de archivos (mkfs)

Tras particionar, hay que formatear con un sistema de archivos.

```bash
# EXT4 — El estándar de Linux (robusto, journaling, maduro)
sudo mkfs.ext4 /dev/sdb1
sudo mkfs.ext4 -L "MisDatos" /dev/sdb1             # Con etiqueta

# XFS — Excelente para archivos grandes y alto rendimiento (estándar RHEL/Rocky)
sudo mkfs.xfs /dev/sdb1

# FAT32 / exFAT — Compatibilidad universal con Windows
sudo mkfs.vfat /dev/sdb1                            # FAT32
sudo mkfs.exfat /dev/sdb1                           # exFAT

# NTFS — Compatibilidad total con Windows
sudo mkfs.ntfs /dev/sdb1

# Verificar y reparar sistema de archivos (solo con la partición DESMONTADA)
sudo fsck /dev/sdb1
sudo e2fsck -f /dev/sdb1                            # Verificación forzada para ext4
```

---

## 10.4 Montar y desmontar dispositivos

Para acceder a los archivos de un dispositivo, hay que **montarlo** en un punto de montaje (una carpeta vacía).

```bash
# Crear el punto de montaje
sudo mkdir /mnt/mi_usb              # /mnt para montajes temporales
sudo mkdir /media/usuario/usb       # /media para dispositivos extraíbles

# Montar (mount)
sudo mount /dev/sdb1 /mnt/mi_usb                    # Montaje básico
sudo mount -t ext4 /dev/sdb1 /mnt/mi_usb            # Especificando tipo
sudo mount -o ro /dev/sdb1 /mnt/mi_usb              # Solo lectura
sudo mount -o remount,rw /mnt/mi_usb                # Remontar como lectura-escritura

# Desmontar (umount) — SIEMPRE antes de desconectar el dispositivo
sudo umount /mnt/mi_usb
sudo umount /dev/sdb1               # Por nombre de dispositivo

# Ver dispositivos montados
mount | grep sdb
df -h                               # Con uso de espacio
```

> **Error común:** `target is busy` al intentar desmontar. Ocurre si estás dentro de la carpeta o hay un programa usando un archivo de ahí. Solución: `cd ..` para salir de la carpeta, luego volver a intentarlo.

### Dispositivos extraíbles y Automontaje

En entornos de escritorio (GNOME, KDE), los dispositivos se montan automáticamente en `/media/nombre_usuario/`. En servidores y terminal, los archivos clave son:

- **`/etc/fstab`:** Particiones que se montan automáticamente al arrancar el sistema.
- **`mount -a`:** Monta todos los dispositivos configurados en fstab que no estén montados.

---

## 10.5 Montaje permanente con /etc/fstab

`/etc/fstab` (File System Table) define qué sistemas de archivos se montan automáticamente al arrancar.

```
# <dispositivo>          <punto_montaje>  <tipo>  <opciones>           <dump> <pass>
UUID=abc123-def456        /mnt/datos       ext4    defaults,noatime     0      2
/dev/sdb1                 /mnt/backup      xfs     defaults             0      0
tmpfs                     /tmp             tmpfs   defaults,size=2G     0      0
```

**Columnas:**
1. **Dispositivo:** UUID (preferible, no cambia si el disco se reconecta en otro orden), label o nombre de dispositivo.
2. **Punto de montaje:** Directorio donde se montará.
3. **Tipo:** `ext4`, `xfs`, `btrfs`, `ntfs`, `vfat`, `tmpfs`, `nfs`...
4. **Opciones:** Lista separada por comas (ver tabla abajo).
5. **dump:** `0` = sin backup automático (casi siempre 0).
6. **pass (fsck):** `0` = no verificar, `1` = verificar primero (root), `2` = verificar después.

| Opción | Significado |
|---|---|
| `defaults` | rw, suid, dev, exec, auto, nouser, async |
| `ro` | Solo lectura |
| `noatime` | No actualizar tiempo de acceso (mejora rendimiento en SSD) |
| `noexec` | No ejecutar binarios (seguridad en /tmp) |
| `nosuid` | Ignorar bits SUID/SGID |
| `nofail` | No fallar el boot si el dispositivo no está presente |
| `_netdev` | Esperar a la red antes de montar (para NFS) |

```bash
# Obtener UUID de una partición (para poner en fstab)
sudo blkid /dev/sdb1
# /dev/sdb1: UUID="550e8400-e29b-41d4-a716-446655440000" TYPE="ext4"

# Verificar fstab sin reiniciar
sudo mount -a                   # Monta todo lo que está en fstab y no está montado
sudo findmnt --verify           # Verifica que fstab es correcto

# Formatear y preparar el dispositivo
sudo mkfs.vfat /dev/sdb1        # FAT32 (Universal)
sudo mkfs.ntfs /dev/sdb1        # NTFS (Windows)
sudo mkfs.ext4 /dev/sdb1        # EXT4 (Linux Nativo)
```

**Caso real — Añadir un segundo disco permanentemente:**

```bash
lsblk                               # 1. Identificar el disco
sudo fdisk /dev/sdb                 # 2. Crear partición (n → p → 1 → enter → enter → w)
sudo mkfs.ext4 /dev/sdb1           # 3. Formatear
sudo blkid /dev/sdb1               # 4. Obtener UUID
sudo mkdir /datos                   # 5. Crear punto de montaje
# 6. Añadir a fstab:
echo 'UUID=TU-UUID  /datos  ext4  defaults,noatime  0  2' | sudo tee -a /etc/fstab
sudo mount -a                       # 7. Probar sin reiniciar
df -h /datos                        # 8. Verificar que se montó correctamente
```

---

## 10.6 LVM — Logical Volume Manager

### ¿Por qué usar LVM?

El particionado tradicional tiene un problema: los tamaños son fijos. Si `/var` se llena, no puedes crecer sin reformatear. LVM añade una capa de abstracción que permite **redimensionar, añadir discos y crear snapshots dinámicamente sin tiempo de inactividad**.

```
Discos físicos (/dev/sda, /dev/sdb)
        ↓
PV (Physical Volumes) — Discos preparados para LVM
        ↓
VG (Volume Group) — Pool de almacenamiento unificado
        ↓
LV (Logical Volumes) — "Particiones" virtuales y flexibles
        ↓
Sistemas de archivos (ext4, xfs) montados en los LVs
```

```bash
# Physical Volumes (PV)
sudo pvcreate /dev/sdb /dev/sdc         # Marcar discos para LVM
pvdisplay                                # Información detallada
pvs                                      # Resumen compacto

# Volume Group (VG)
sudo vgcreate datos_vg /dev/sdb /dev/sdc   # Crear VG con los PVs
sudo vgextend datos_vg /dev/sdd            # Añadir disco al VG (ampliar el pool)
vgdisplay
vgs

# Logical Volumes (LV)
sudo lvcreate -L 50G -n web_lv datos_vg    # LV de 50GB llamado "web_lv"
sudo lvcreate -L 100G -n db_lv datos_vg    # LV de 100GB para base de datos
sudo lvcreate -l 100%FREE -n backup_lv datos_vg  # Usar todo el espacio restante
# El dispositivo resultante: /dev/datos_vg/web_lv

# Formatear y montar el LV
sudo mkfs.ext4 /dev/datos_vg/web_lv
sudo mkdir /var/www
sudo mount /dev/datos_vg/web_lv /var/www
lvdisplay
lvs

# ★ Ampliar un LV en caliente (sin desmontar en ext4/xfs)
sudo lvextend -L +20G /dev/datos_vg/web_lv          # Ampliar +20GB
sudo lvextend -l +100%FREE /dev/datos_vg/web_lv     # Usar todo el espacio libre del VG
sudo resize2fs /dev/datos_vg/web_lv                  # Redimensionar FS ext4
sudo xfs_growfs /var/www                             # Redimensionar FS xfs
# Todo en un comando (ext4):
sudo lvextend -L +20G --resizefs /dev/datos_vg/web_lv

# Snapshots — Backups instantáneos (imprescindible antes de actualizaciones arriesgadas)
sudo lvcreate -L 5G -s -n web_snap /dev/datos_vg/web_lv  # Crear snapshot
sudo mount -o ro /dev/datos_vg/web_snap /mnt/snap         # Montar para backup
tar -czf /backup/web_$(date +%Y%m%d).tar.gz /mnt/snap/
sudo umount /mnt/snap
sudo lvremove /dev/datos_vg/web_snap                      # Eliminar snapshot
```

---

# 11. Redes y Seguridad

## 11.1 Configuración y diagnóstico de red

```bash
# ip addr — Ver y gestionar IPs (sucesor de ifconfig)
ip addr show                                # Todas las interfaces
ip addr show eth0                           # Solo eth0
ip addr add 192.168.1.100/24 dev eth0       # Añadir IP a una interfaz
ip addr del 192.168.1.100/24 dev eth0       # Eliminar IP

# ip link — Gestionar interfaces
ip link show
ip link set eth0 up                         # Activar interfaz
ip link set eth0 down                       # Desactivar interfaz

# ip route — Gestión de rutas
ip route show                               # Tabla de rutas
ip route add default via 192.168.1.1        # Añadir gateway por defecto
ip route add 10.0.0.0/8 via 192.168.1.254  # Ruta estática

# ip neigh — Tabla ARP
ip neigh show                               # Equivalente al antiguo arp -n

# Diagnóstico de conectividad
ping -c 4 8.8.8.8                           # Verificar conectividad (4 paquetes)
ping -i 0.5 -c 10 servidor                  # Intervalo 0.5s, 10 paquetes
traceroute google.com                       # Ver el camino de los paquetes
traceroute -n google.com                    # Sin resolver nombres (más rápido)
mtr google.com                              # ★ Ping + traceroute en tiempo real

# DNS
nslookup google.com                         # Resolución DNS básica
nslookup google.com 8.8.8.8                 # Usando un DNS específico
dig google.com                              # Consulta DNS detallada
dig google.com +short                       # Solo la IP (muy útil en scripts)
dig MX google.com                           # Registros de correo
dig -x 8.8.8.8                              # Reverse DNS lookup
host google.com                             # Resolución rápida

# ss — Estado de sockets (sucesor de netstat)
ss -tulpn                                   # TCP+UDP, Listening, con Proceso y Numérico
ss -tulpn | grep :80                        # ¿Quién escucha en el puerto 80?
ss -s                                       # Estadísticas de sockets
netstat -tulpn                              # netstat (antiguo, pero aún disponible)
netstat -rn                                 # Tabla de rutas

# curl y wget
curl -I https://ejemplo.com                 # Solo headers de respuesta HTTP
curl -o /dev/null -w "%{http_code}" https://ejemplo.com  # Solo código de respuesta
wget https://url/archivo.tar.gz             # Descarga simple
wget -c https://url/archivo.tar.gz          # Reanudar descarga interrumpida
```

**Diagnóstico sistemático — Servidor web que no responde:**

```bash
ping -c 3 8.8.8.8               # 1. ¿Tengo red?
ss -tulpn | grep :80            # 2. ¿El servicio está escuchando?
sudo ufw status                 # 3. ¿El firewall permite el tráfico?
systemctl status nginx          # 4. ¿El servicio está corriendo?
tail -50 /var/log/nginx/error.log  # 5. ¿Hay errores en los logs?
curl -I http://localhost        # 6. ¿Conectividad local?
```

---

## 11.2 SSH seguro

### Generar y gestionar claves SSH

```bash
# Generar par de claves (en tu máquina LOCAL)
ssh-keygen -t ed25519 -C "tu@email.com"         # ★ Ed25519: algoritmo moderno y recomendado
ssh-keygen -t rsa -b 4096 -C "tu@email.com"     # RSA 4096: para compatibilidad

# Los archivos generados:
# ~/.ssh/id_ed25519        ← Clave PRIVADA (permisos 600, NUNCA compartas)
# ~/.ssh/id_ed25519.pub    ← Clave PÚBLICA (se copia al servidor)

# Copiar clave pública al servidor (forma recomendada)
ssh-copy-id usuario@servidor
ssh-copy-id -i ~/.ssh/id_ed25519.pub usuario@servidor

# Permisos correctos en el servidor (SSH los rechaza si son incorrectos)
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

# Conexión
ssh usuario@servidor
ssh -p 2222 usuario@servidor                     # Puerto no estándar
ssh -i ~/.ssh/clave_especifica usuario@servidor  # Clave específica
```

### Asegurar el servidor SSH (/etc/ssh/sshd_config)

```bash
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak  # ★ Siempre hacer backup

# Configuración recomendada de seguridad:
Port 2222                           # 1. Cambiar puerto (reduce ataques de bots)
PermitRootLogin no                  # 2. Nunca permitir root por SSH
PasswordAuthentication no           # 3. Solo claves SSH (desactivar contraseñas)
PubkeyAuthentication yes            # 4. Habilitar autenticación por clave
AllowUsers ana carlos               # 5. Solo estos usuarios pueden conectar
MaxAuthTries 3                      # 6. Máximo 3 intentos de autenticación
LoginGraceTime 30                   # 7. 30 segundos para hacer login
ClientAliveInterval 300             # 8. Keepalive cada 5 minutos
X11Forwarding no                    # 9. Desactivar si no necesitas GUI remota

# Aplicar cambios
sudo sshd -t                        # ★ Verificar sintaxis ANTES de reiniciar
sudo systemctl restart sshd         # Reiniciar el servicio
```

### SSH Config del cliente (~/.ssh/config)

```bash
# Simplificar conexiones frecuentes
cat ~/.ssh/config

Host prod
    HostName 10.0.1.50
    User admin
    Port 2222
    IdentityFile ~/.ssh/clave_prod
    ServerAliveInterval 60

# Ahora conectar es:
ssh prod                            # En vez de: ssh -p 2222 -i ~/.ssh/clave_prod admin@10.0.1.50

# Transferencia de archivos
scp archivo.txt usuario@servidor:/ruta/destino/
scp -r carpeta/ usuario@servidor:/ruta/
rsync -avz src/ usuario@servidor:/dst/          # Solo transfiere cambios (eficiente)
rsync -avz --delete /local/ usuario@srv:/backup/ # Sincronización con borrado
```

---

## 11.3 Gestión de Firewall

### UFW (Uncomplicated Firewall) — Debian/Ubuntu

```bash
# Política por defecto (configurar ANTES de habilitar)
sudo ufw default deny incoming              # Denegar todo lo que entra
sudo ufw default allow outgoing            # Permitir todo lo que sale

# Habilitar (ASEGÚRATE de permitir SSH antes para no quedarte fuera)
sudo ufw allow ssh                          # Permitir SSH (puerto 22)
sudo ufw allow 2222/tcp                     # Si usas puerto SSH personalizado
sudo ufw enable                             # Habilitar el firewall

# Añadir reglas
sudo ufw allow 80/tcp                       # HTTP
sudo ufw allow 443/tcp                      # HTTPS
sudo ufw allow 'Nginx Full'                 # Perfil de app (HTTP + HTTPS)
sudo ufw limit ssh                          # Limitar intentos (protege contra fuerza bruta)

# Reglas por IP
sudo ufw allow from 192.168.1.50            # Permitir todo desde esa IP
sudo ufw allow from 10.0.0.0/8 to any port 5432   # Solo esa red puede llegar a PostgreSQL

# Ver y gestionar reglas
sudo ufw status verbose                     # Ver estado y reglas
sudo ufw status numbered                    # Ver reglas con número
sudo ufw delete 3                           # Eliminar regla número 3
sudo ufw delete allow 80/tcp                # Eliminar por descripción
sudo ufw disable                            # Deshabilitar el firewall
sudo ufw reset                              # Borrar TODAS las reglas
```

### firewalld — RHEL/Rocky/Fedora

```bash
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --state

sudo firewall-cmd --get-default-zone
sudo firewall-cmd --list-all                # Ver configuración de la zona

# Añadir servicios/puertos (--permanent = persistente tras reinicio)
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload                  # Aplicar cambios permanentes

sudo firewall-cmd --permanent --remove-service=telnet
```

### Cheat Sheet — Red y Seguridad

| Comando | Función |
|---|---|
| `ip addr show` | Ver IPs de las interfaces |
| `ss -tulpn` | Puertos en escucha con proceso |
| `mtr host` | Traceroute dinámico en tiempo real |
| `dig host +short` | Resolver DNS rápidamente |
| `ssh-keygen -t ed25519` | Generar par de claves SSH |
| `ssh-copy-id user@host` | Copiar clave pública al servidor |
| `sudo sshd -t` | Verificar sintaxis de sshd_config |
| `sudo ufw allow 80/tcp` | Abrir puerto en firewall |
| `sudo ufw status numbered` | Ver reglas con números |
| `rsync -avz src/ user@host:/dst/` | Sincronización eficiente |

---

# 12. Automatización con Bash Scripting

## 12.1 Estructura de un script

```bash
#!/usr/bin/env bash
# ==========================================
# Nombre: mi_script.sh
# Descripción: Ejemplo de estructura profesional
# Autor: Admin
# Fecha: 2025-01-01
# Uso: ./mi_script.sh [argumento1] [argumento2]
# ==========================================

# ★ Opciones de seguridad — añadir SIEMPRE
set -euo pipefail
# -e: Salir si un comando falla (exit on error)
# -u: Tratar variables no definidas como error
# -o pipefail: Si falla cualquier parte de un pipe, el pipe falla

# Constantes al principio
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_FILE="/var/log/mi_script.log"
readonly FECHA=$(date +%Y-%m-%d)

# Función de logging reutilizable
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

# Función de limpieza (se ejecuta al salir, con éxito o error)
cleanup() {
    log "INFO: Limpiando archivos temporales..."
    rm -f /tmp/mi_script_temp_*
}
trap cleanup EXIT       # trap captura señales; EXIT = al terminar el script

# Verificar que se ejecuta como root
if [[ $EUID -ne 0 ]]; then
    echo "ERROR: Este script debe ejecutarse como root." >&2
    exit 1
fi

# Función principal
main() {
    log "INFO: Iniciando script..."
    # Tu código aquí
    log "INFO: Script completado con éxito."
}

main "$@"       # $@ pasa todos los argumentos al script
```

```bash
chmod +x mi_script.sh       # Hacer ejecutable
./mi_script.sh              # Ejecutar
bash mi_script.sh           # Ejecutar explícitamente con bash
```

---

## 12.2 Variables y parámetros

```bash
#!/usr/bin/env bash

# Variables
NOMBRE="Linux"
NUMERO=42
RESULTADO=$(comando)            # Capturar salida de un comando (preferida)
RESULTADO=`comando`             # Forma antigua (no recomendada)

# Usar variables (siempre entre comillas dobles)
echo "Hola, $NOMBRE"
echo "El número es: ${NUMERO}"     # Las llaves clarifican el final de la variable

# Aritmética
SUMA=$((5 + 3))
RESTA=$((10 - 4))
MULT=$((3 * 4))
DIV=$((10 / 3))                 # División entera
MOD=$((10 % 3))                 # Módulo
echo $((2 ** 10))               # Potencia: 1024

# Variables especiales (solo lectura)
echo $0         # Nombre del script
echo $1 $2 $3  # Argumentos posicionales
echo $@         # Todos los argumentos como lista
echo $#         # Número de argumentos
echo $?         # Código de salida del último comando (0=éxito)
echo $$         # PID del script actual

# Manipulación de strings
CADENA="Hola Mundo"
echo ${#CADENA}                     # Longitud: 10
echo ${CADENA:5}                    # Desde posición 5: "Mundo"
echo ${CADENA:5:3}                  # 3 chars desde posición 5: "Mun"
echo ${CADENA^^}                    # Mayúsculas: "HOLA MUNDO"
echo ${CADENA,,}                    # Minúsculas: "hola mundo"
echo ${CADENA/Hola/Adiós}           # Reemplazar: "Adiós Mundo"
echo ${VAR:-"valor por defecto"}    # Si VAR está vacía, usar valor por defecto
echo ${VAR:="valor asignado"}       # Si VAR está vacía, ASIGNAR valor

# Arrays
FRUTAS=("manzana" "naranja" "plátano")
echo ${FRUTAS[0]}                   # Primer elemento
echo ${FRUTAS[@]}                   # Todos los elementos
echo ${#FRUTAS[@]}                  # Número de elementos
FRUTAS+=("uva")                     # Añadir elemento

for fruta in "${FRUTAS[@]}"; do
    echo "Fruta: $fruta"
done
```

---

## 12.3 Condicionales y bucles

```bash
#!/usr/bin/env bash

# IF / ELIF / ELSE
if [ condición ]; then
    # código
elif [ otra_condición ]; then
    # código
else
    # código
fi

# Operadores para STRINGS
[ "$VAR" = "valor" ]        # Igual
[ "$VAR" != "valor" ]       # Distinto
[ -z "$VAR" ]               # Vacía o no definida
[ -n "$VAR" ]               # No vacía

# Operadores para NÚMEROS
[ "$NUM" -eq 0 ]            # Igual a 0
[ "$NUM" -ne 0 ]            # Distinto de 0
[ "$NUM" -gt 10 ]           # Mayor que 10
[ "$NUM" -lt 10 ]           # Menor que 10
[ "$NUM" -ge 10 ]           # Mayor o igual
[ "$NUM" -le 10 ]           # Menor o igual

# Operadores de ARCHIVOS
[ -f "/ruta/archivo" ]      # Existe y es un archivo regular
[ -d "/ruta/dir" ]          # Existe y es un directorio
[ -e "/ruta" ]              # Existe (cualquier tipo)
[ -r "/ruta" ]              # Existe y es legible
[ -w "/ruta" ]              # Existe y tiene escritura
[ -x "/ruta" ]              # Existe y es ejecutable
[ -s "/ruta" ]              # Existe y no está vacío

# Operadores lógicos
[ cond1 ] && [ cond2 ]      # AND
[ cond1 ] || [ cond2 ]      # OR
! [ condición ]             # NOT

# [[ ]] (bash) — Más potente que [ ]
[[ "$VAR" == *"patrón"* ]]          # Coincidencia de patrón glob
[[ "$VAR" =~ ^[0-9]+$ ]]            # Coincidencia de regex

# CASE — Múltiples condiciones
case "$OPCION" in
    start)
        echo "Iniciando servicio..."
        ;;
    stop)
        echo "Parando servicio..."
        ;;
    restart|reload)
        echo "Reiniciando servicio..."
        ;;
    *)
        echo "Uso: $0 {start|stop|restart|reload}"
        exit 1
        ;;
esac

# BUCLES

# FOR sobre lista
for i in {1..10}; do echo $i; done

# FOR con paso
for i in {0..100..10}; do echo $i; done  # De 0 a 100, de 10 en 10

# FOR estilo C
for ((i=0; i<10; i++)); do
    echo "Iteración: $i"
done

# FOR sobre archivos
for archivo in /var/log/*.log; do
    echo "Procesando: $archivo"
    wc -l "$archivo"
done

# WHILE — Leer un archivo línea a línea
while IFS= read -r linea; do
    echo "Línea: $linea"
done < archivo.txt

# WHILE con contador
CONTADOR=0
while [ $CONTADOR -lt 10 ]; do
    echo "Contador: $CONTADOR"
    ((CONTADOR++))
done
```

**Script completo — Gestor de backups con validaciones:**

```bash
#!/usr/bin/env bash
set -euo pipefail

ORIGEN="/home"
DESTINO="/backup"
DIAS_RETENER=7
FECHA=$(date +%Y%m%d_%H%M%S)
ARCHIVO_BACKUP="${DESTINO}/home_backup_${FECHA}.tar.gz"
LOG="${DESTINO}/backup.log"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG"; }

[[ $EUID -ne 0 ]] && { echo "Error: Ejecutar como root."; exit 1; }
[[ ! -d "$ORIGEN" ]] && { log "ERROR: $ORIGEN no existe."; exit 1; }

mkdir -p "$DESTINO"

log "INFO: Iniciando backup de $ORIGEN"
if tar -czf "$ARCHIVO_BACKUP" "$ORIGEN" 2>>"$LOG"; then
    TAMANO=$(du -sh "$ARCHIVO_BACKUP" | cut -f1)
    log "INFO: Backup completado: $ARCHIVO_BACKUP (${TAMANO})"
else
    log "ERROR: Falló la creación del backup."
    exit 1
fi

log "INFO: Eliminando backups con más de $DIAS_RETENER días..."
find "$DESTINO" -name "home_backup_*.tar.gz" -mtime +"$DIAS_RETENER" -delete
log "INFO: Proceso completado."
```

---

## 12.4 Funciones y buenas prácticas

```bash
#!/usr/bin/env bash

# Definición de función
nombre_funcion() {
    local VAR_LOCAL="solo visible aquí"     # 'local' limita el scope
    echo "Argumento 1: $1"
    return 0    # 0 = éxito, otro = error
}

# Llamar y capturar retorno
nombre_funcion "valor1"
resultado=$(nombre_funcion "arg")

# Buenas prácticas:

# 1. Validar número de argumentos
if [[ $# -lt 2 ]]; then
    echo "Uso: $0 <usuario> <directorio>" >&2
    exit 1
fi

# 2. Usar 'local' en variables de funciones
mi_funcion() {
    local resultado="valor"     # Solo existe dentro de la función
    echo "$resultado"
}

# 3. Enviar errores a stderr (no a stdout)
echo "ERROR: archivo no encontrado" >&2

# 4. Validar entradas
validar_numero() {
    local num="$1"
    if ! [[ "$num" =~ ^[0-9]+$ ]]; then
        echo "ERROR: '$num' no es un número válido" >&2
        return 1
    fi
}

# 5. Usar rutas absolutas en scripts
readonly BINARIO="/usr/bin/python3"   # No depender del PATH del sistema
```

---

## 12.5 Cron y Anacron

### cron — El planificador de tareas

```bash
crontab -e                      # Editar el crontab del usuario actual
crontab -l                      # Listar crons actuales
crontab -r                      # Eliminar TODOS los crons (¡cuidado!)
sudo crontab -e                 # Editar crontab de root

ls /etc/cron.daily/             # Scripts que se ejecutan una vez al día
ls /etc/cron.weekly/            # Una vez a la semana
ls /etc/cron.monthly/           # Una vez al mes
ls /etc/cron.hourly/            # Una vez por hora
ls /etc/cron.d/                 # Scripts adicionales con formato completo
```

### Sintaxis del crontab

```
# ┌───── Minuto (0-59)
# │ ┌───── Hora (0-23)
# │ │ ┌───── Día del mes (1-31)
# │ │ │ ┌───── Mes (1-12)
# │ │ │ │ ┌───── Día de la semana (0=Dom, 1=Lun ... 7=Dom)
# │ │ │ │ │
# * * * * *  comando

# Caracteres especiales:
# *    = cualquier valor
# ,    = lista de valores (1,3,5)
# -    = rango (1-5)
# /    = paso (*/5 = cada 5 unidades)
# @reboot  = al arrancar
# @daily   = equivale a 0 0 * * *
# @weekly  = equivale a 0 0 * * 0
# @monthly = equivale a 0 0 1 * *
```

### Ejemplos de crontab

```bash
# Backup diario a las 2:30 AM
30 2 * * * /usr/local/bin/backup.sh >> /var/log/backup.log 2>&1

# Limpiar /tmp cada domingo a las 3 AM
0 3 * * 0 find /tmp -type f -mtime +7 -delete

# Ejecutar script cada 5 minutos
*/5 * * * * /usr/local/bin/check_service.sh

# Solo días laborables (L-V) a las 8 AM
0 8 * * 1-5 /usr/local/bin/inicio_laboral.sh

# El primer día de cada mes a medianoche
0 0 1 * * /usr/local/bin/facturacion_mensual.sh

# Cada 6 horas
0 */6 * * * systemctl restart mi_servicio

# Al arrancar el sistema
@reboot /usr/local/bin/iniciar_servicio.sh

# ★ REGLAS DE ORO PARA CRON:
# 1. Usar siempre RUTAS ABSOLUTAS (cron tiene un PATH limitado)
# 2. Redirigir stdout y stderr: >> /var/log/job.log 2>&1
# 3. Probar el comando manualmente antes de añadirlo al cron
# 4. Usar 'crontab -e' como el usuario que debe ejecutar el job
```

### anacron — Para sistemas que no están siempre encendidos

`cron` requiere que el sistema esté encendido en el momento exacto. `anacron` ejecuta tareas "al menos una vez" en un período, ideal para portátiles o servidores que se reinician.

```bash
cat /etc/anacrontab
# Formato: período  delay  identificador  comando
# período = 1 (diario), 7 (semanal), @monthly
# delay = minutos de espera tras arrancar (evita que todo arranque a la vez)

# Ejemplo de /etc/anacrontab
1    5    backup_diario    /usr/local/bin/backup.sh
7    10   limpieza_semanal /usr/local/bin/limpieza.sh
```

### Cheat Sheet — Bash Scripting y Cron

| Concepto | Sintaxis |
|---|---|
| Shebang + opciones seguras | `#!/usr/bin/env bash` + `set -euo pipefail` |
| Verificar si es root | `[[ $EUID -ne 0 ]] && exit 1` |
| Capturar salida | `VAR=$(comando)` |
| Verificar archivo | `[ -f "/ruta" ]` |
| Verificar directorio | `[ -d "/ruta" ]` |
| Bucle sobre archivos | `for f in /ruta/*.log; do ... done` |
| Leer archivo línea a línea | `while IFS= read -r line; do ... done < archivo` |
| Variable local | `local var="valor"` |
| Editar crontab | `crontab -e` |
| Cron cada hora | `0 * * * * comando` |
| Cron todos los días a las 2 AM | `0 2 * * * comando` |
| Cron al inicio del sistema | `@reboot comando` |

---