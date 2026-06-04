> **Estado:** 🟢 Completo
> **Última actualización:** 2026-06
> **Nivel:** Principiante — se explican los conceptos desde cero

---

- [7. Procesos y Recursos del Sistema](#7-procesos-y-recursos-del-sistema)
  - [7.1 ¿Qué es un proceso?](#71-qué-es-un-proceso)
  - [7.2 Monitoreo en tiempo real](#72-monitoreo-en-tiempo-real)
    - [top — El monitor clásico](#top--el-monitor-clásico)
    - [htop — La evolución de top](#htop--la-evolución-de-top)
    - [ps — Snapshot de procesos](#ps--snapshot-de-procesos)
    - [lsof — Archivos abiertos](#lsof--archivos-abiertos)
    - [Comandos de diagnóstico adicionales](#comandos-de-diagnóstico-adicionales)
  - [7.3 Señales de Procesos](#73-señales-de-procesos)
  - [7.4 Background, Foreground y Multiplexores](#74-background-foreground-y-multiplexores)
    - [Jobs — Gestión de tareas](#jobs--gestión-de-tareas)
    - [tmux — El multiplexor moderno (recomendado)](#tmux--el-multiplexor-moderno-recomendado)
    - [screen — Multiplexor clásico](#screen--multiplexor-clásico)
  - [7.5 Prioridades: nice y renice](#75-prioridades-nice-y-renice)
    - [Cheat Sheet — Procesos](#cheat-sheet--procesos)
- [8. Gestión de Paquetes y Librerías](#8-gestión-de-paquetes-y-librerías)
  - [8.1 Conceptos y formatos](#81-conceptos-y-formatos)
  - [8.2 APT (Debian/Ubuntu)](#82-apt-debianubuntu)
  - [8.3 DNF/YUM (RHEL/Rocky/Fedora)](#83-dnfyum-rhelrockyfedora)
  - [8.4 Pacman (Arch Linux)](#84-pacman-arch-linux)
  - [8.5 Instalación manual de paquetes](#85-instalación-manual-de-paquetes)
    - [Instalación de paquetes .deb](#instalación-de-paquetes-deb)
    - [Instalación desde código fuente](#instalación-desde-código-fuente)
  - [8.6 Paquetes Universales](#86-paquetes-universales)
  - [8.7 Repositorios externos y GPG](#87-repositorios-externos-y-gpg)
    - [Agregar Repositorios PPA](#agregar-repositorios-ppa)
    - [Gestión de Claves GPG](#gestión-de-claves-gpg)
- [9. Archivado y Compresión de Ficheros](#9-archivado-y-compresión-de-ficheros)
  - [9.1 Compresión básica: gzip, bzip2, xz](#91-compresión-básica-gzip-bzip2-xz)
  - [9.2 tar — El archivador estándar](#92-tar--el-archivador-estándar)
  - [9.3 zip / unzip](#93-zip--unzip)
  - [9.4 Técnicas avanzadas de archivado](#94-técnicas-avanzadas-de-archivado)

---

# 7. Procesos y Recursos del Sistema

## 7.1 ¿Qué es un proceso?

Un proceso es un programa en ejecución. Cada proceso tiene un **PID** (Process ID) único, un estado, un propietario y consume recursos. Los procesos se organizan en jerarquía padre-hijo (el padre de casi todos es systemd, PID 1).

**Estados de un proceso:**

| Estado | Símbolo en `ps` | Descripción |
|---|---|---|
| Running | `R` | Ejecutándose o en la cola de la CPU |
| Sleeping | `S` | Esperando un evento (IO, señal) |
| Uninterruptible sleep | `D` | Esperando IO de disco (no puede ser interrumpido) |
| Stopped | `T` | Pausado (Ctrl+Z o SIGSTOP) |
| Zombie | `Z` | Terminó pero su padre no recogió el resultado |

---

## 7.2 Monitoreo en tiempo real

### top — El monitor clásico

```bash
top                         # Abrir top

# Interpretando la cabecera:
# top - 14:32:01 up 5 days, 3:21, 2 users, load average: 0.15, 0.20, 0.18
#   └─ Hora       └─ Uptime   └─ Usuarios  └─ Carga 1, 5 y 15 minutos
#
# Load average: si supera el nº de CPUs, hay sobrecarga
# %Cpu: us=usuario, sy=kernel, id=idle, wa=I/O wait (alto = cuello de botella en disco)
# KiB Mem: buff/cache es memoria recuperable (no preocuparse si está alto)

# Atajos dentro de top:
# M → Ordenar por uso de Memoria
# P → Ordenar por uso de CPU
# k → Matar proceso (pide PID)
# r → Cambiar prioridad (renice)
# 1 → Mostrar cada CPU por separado
# q → Salir
```

### htop — La evolución de top

```bash
sudo apt install htop
htop

# Ventajas sobre top:
# - Barras de CPU por core y de RAM visuales y con color
# - Navegación con teclado y ratón
# - Árbol de procesos (F5)
# - Filtrado en tiempo real (F4)
# F2=Configurar, F3=Buscar, F4=Filtrar, F5=Árbol, F9=Señal/Kill, F10=Salir
```

### ps — Snapshot de procesos

```bash
ps aux                                  # ★ Todos los procesos, formato Unix
# USER PID %CPU %MEM VSZ RSS TTY STAT START TIME COMMAND
# VSZ=Memoria virtual, RSS=Memoria física real usada

ps -ef                                  # Todos, formato estándar
ps -u usuario                           # Procesos de un usuario específico
ps aux | grep nginx                     # Buscar proceso específico
ps aux --sort=-%mem | head              # Ordenar por uso de memoria
ps -eo pid,ppid,cmd,%cpu,%mem --sort=-%cpu | head  # Columnas personalizadas

pstree                                  # Árbol de procesos en texto
pstree -p                               # Con PIDs
```

### lsof — Archivos abiertos

En Linux todo es un archivo. `lsof` (List Open Files) te dice qué sockets, pipes y archivos tiene abiertos cada proceso.

```bash
lsof /var/log/syslog                    # ¿Qué procesos tienen abierto este archivo?
lsof -u usuario                         # Archivos abiertos por un usuario
lsof -p 1234                            # Archivos abiertos por el proceso 1234
lsof -i                                 # Todas las conexiones de red
lsof -i :80                             # ¿Qué proceso usa el puerto 80?
lsof -i :22                             # ¿Quién usa SSH?
lsof +D /var/log/                       # Todo lo abierto en ese directorio

# Caso real: "El puerto 8080 ya está en uso"
sudo lsof -i :8080
# COMMAND  PID  USER  ...  NAME
# java    1234  www   ...  *:8080 (LISTEN)
```

### Comandos de diagnóstico adicionales

```bash
free -h                     # RAM y swap con unidades legibles
vmstat 1 10                 # Estadísticas del sistema cada 1s (10 veces)
iostat -x 1                 # Estadísticas de I/O de disco por segundo
df -h                       # Espacio en disco por sistema de archivos
du -sh /var/log/*           # Tamaño de subdirectorios
uptime                      # Uptime y carga del sistema
dmesg | tail -20            # Mensajes del kernel (hardware, drivers)
```

---

## 7.3 Señales de Procesos

Las señales son interrupciones software enviadas a procesos. Un proceso puede capturar/ignorar casi todas, excepto SIGKILL y SIGSTOP.

```bash
# Señales más importantes:
# SIGTERM (15): "Por favor, termina limpiamente" — el proceso puede limpiar antes de morir
# SIGKILL  (9): "Muere ahora" — no puede ser ignorada, el kernel lo mata directamente
# SIGHUP   (1): "Recarga tu configuración" — muy usado en servicios
# SIGSTOP (19): Pausar proceso (no puede ignorarse)
# SIGCONT (18): Continuar proceso pausado
# SIGINT   (2): Ctrl+C desde terminal

# kill — Enviar señal por PID
kill -15 1234               # SIGTERM (por defecto)
kill 1234                   # Igual que kill -15
kill -9 1234                # SIGKILL: matar incondicionalmente
kill -1 1234                # SIGHUP: recargar configuración

# pkill — Matar por nombre
pkill nginx                 # Envía SIGTERM a todos los procesos llamados "nginx"
pkill -9 proceso_colgado    # SIGKILL a todos con ese nombre
pkill -u usuario            # Matar todos los procesos de un usuario

# killall
killall nginx

# Recargar configuración sin reiniciar (el método correcto en producción)
sudo kill -HUP $(cat /var/run/nginx.pid)
# Equivalente moderno:
sudo systemctl reload nginx

kill -l                     # Listar todas las señales disponibles
```

**Caso real — Proceso completamente bloqueado:**

```bash
# 1. Intentar terminar limpiamente primero
kill -15 $(pgrep proceso_bloqueado)
sleep 3
# 2. Si sigue vivo, matar sin contemplaciones
kill -9 $(pgrep proceso_bloqueado)
# 3. Verificar
ps aux | grep proceso_bloqueado
```

---

## 7.4 Background, Foreground y Multiplexores

### Jobs — Gestión de tareas

```bash
comando &                   # Lanzar proceso en background (muestra [job] PID)
jobs                        # Listar jobs activos
fg %1                       # Traer job 1 al foreground
bg %1                       # Reanudar job 1 en background
Ctrl+Z                      # Suspender el proceso en foreground (SIGSTOP)

# nohup — Ejecutar inmune a SIGHUP (no muere al cerrar la terminal)
nohup ./script_largo.sh &
nohup ./script.sh > /var/log/proceso.log 2>&1 &

# disown — Desasociar proceso ya en ejecución de la shell
./proceso_largo &
disown %1                   # Ahora sobrevive aunque cierres la terminal
```

### tmux — El multiplexor moderno (recomendado)

```bash
tmux                        # Abrir nueva sesión
tmux new -s servidor        # Crear sesión con nombre "servidor"
tmux ls                     # Listar sesiones
tmux attach -t servidor     # Reconectarse a sesión "servidor"
tmux kill-session -t sesion # Matar sesión

# Dentro de tmux (prefijo: Ctrl+B):
# Ctrl+B d  → Detach (deja la sesión corriendo en background)
# Ctrl+B c  → Nueva ventana
# Ctrl+B n/p → Siguiente/anterior ventana
# Ctrl+B %  → Dividir panel verticalmente
# Ctrl+B "  → Dividir panel horizontalmente
# Ctrl+B ←/→/↑/↓ → Moverse entre paneles
# Ctrl+B z  → Zoom al panel actual (toggle)
# Ctrl+B [  → Modo scroll (q para salir)
```

### screen — Multiplexor clásico

```bash
screen                      # Abrir nueva sesión
screen -S nombre_sesion     # Crear sesión con nombre
screen -ls                  # Listar sesiones activas
screen -r nombre_sesion     # Reanudar sesión

# Dentro de screen (prefijo: Ctrl+A):
# Ctrl+A d  → Detach
# Ctrl+A c  → Crear nueva ventana
# Ctrl+A n/p → Siguiente/anterior ventana
# Ctrl+A k  → Matar ventana actual
```

> **Caso real (crítico):** Vas a ejecutar una migración de base de datos que tardará horas por SSH. Si la conexión cae, el proceso muere. Solución:
> ```bash
> ssh admin@servidor-produccion
> tmux new -s migracion_db
> # Dentro de tmux lanzas la migración...
> ./migrar_db.sh > /var/log/migracion_$(date +%Y%m%d).log 2>&1
> # Ctrl+B d  → Detach y la migración SIGUE aunque cierres el SSH
> # Para volver:
> tmux attach -t migracion_db
> ```

---

## 7.5 Prioridades: nice y renice

El valor `nice` va de **-20** (máxima prioridad) a **+19** (mínima prioridad). Por defecto: 0. Solo root puede establecer valores negativos.

```bash
# nice — Iniciar proceso con prioridad específica
nice -n 10 ./proceso_pesado.sh          # Lanzar con baja prioridad (+10)
nice -n -5 ./proceso_critico            # Alta prioridad (-5, requiere root)
sudo nice -n -20 ./urgente             # Máxima prioridad posible

# renice — Cambiar prioridad de proceso YA en ejecución
renice +15 -p 1234                      # Bajar prioridad del proceso 1234
sudo renice -5 -p 1234                  # Subir prioridad (requiere root)
renice +10 -u www-data                  # Bajar prioridad de todos los procesos de un usuario

# Ver prioridades
ps -eo pid,ni,cmd | head                # NI = nice value
top                                     # Columna NI
```

> **Caso real:** Backup nocturno que no debe afectar al servidor web:
> ```bash
> nice -n 19 tar -czf /backup/completo.tar.gz /var/ &
> # nice +19 = mínima prioridad posible. La operación tardará más, pero el servidor web no se resiente.
> ```

### Cheat Sheet — Procesos

| Comando | Función |
|---|---|
| `ps aux` | Listar todos los procesos |
| `htop` | Monitor interactivo visual |
| `kill -9 PID` | Matar proceso incondicionalmente |
| `pkill nombre` | Matar procesos por nombre |
| `lsof -i :80` | ¿Qué proceso usa el puerto 80? |
| `jobs` | Ver jobs en background |
| `fg %1` / `bg %1` | Traer/enviar job al foreground/background |
| `nohup cmd &` | Ejecutar inmune al cierre de terminal |
| `tmux new -s nombre` | Nueva sesión tmux |
| `tmux attach -t nombre` | Reconectarse a sesión tmux |
| `nice -n 19 cmd` | Lanzar con mínima prioridad |
| `renice +10 -p PID` | Bajar prioridad de proceso existente |

---

# 8. Gestión de Paquetes y Librerías

La gestión de paquetes es el corazón de la administración de software en Linux. Un paquete es un contenedor que incluye:

- **Binarios y librerías:** El código ejecutable.
- **Metadatos:** Información sobre el autor, versión y arquitectura (x64, ARM).
- **Dependencias:** Lista de otros paquetes necesarios.
- **Scripts:** Instrucciones para configurar el software automáticamente tras la instalación.

## 8.1 Conceptos y formatos

| Familia | Formato | Gestor (CLI) | Distribuciones Populares |
|---|---|---|---|
| Debian | `.deb` | `apt`, `dpkg` | Ubuntu, Mint, Kali, Debian |
| Red Hat | `.rpm` | `dnf`, `yum` | Fedora, RHEL, Rocky Linux |
| Arch | `pkg.tar.zst` | `pacman` | Arch Linux, Manjaro |
| SUSE | `.rpm` | `zypper` | openSUSE |
| Universal | — | `snap`, `flatpak` | Todas las distribuciones |

---

## 8.2 APT (Debian/Ubuntu)

```bash
# Sincronización y actualización
sudo apt update                         # Actualizar lista de paquetes disponibles
sudo apt upgrade                        # Instalar actualizaciones disponibles
sudo apt full-upgrade                   # Actualización completa (puede eliminar paquetes)
sudo apt dist-upgrade                   # Sinónimo de full-upgrade

# Gestión de aplicaciones
apt search <nombre>                     # Buscar software por nombre o descripción
apt show <nombre>                       # Ver información detallada del paquete
sudo apt install <nombre>               # Instalar
sudo apt install paquete1 paquete2      # Instalar varios a la vez
sudo apt remove <nombre>                # Eliminar (mantiene la configuración)
sudo apt purge <nombre>                 # Eliminar + borrar configuración
sudo apt autoremove                     # Eliminar dependencias no usadas
sudo apt autoclean                      # Limpiar caché de paquetes descargados
sudo apt -f install                     # Corregir dependencias rotas

> Consejo: Revisar paquetes actualizables con `apt list --upgradable` antes de actualizar.

# Información y diagnóstico
apt list --installed                    # Listar paquetes instalados
apt list --upgradable                   # Ver qué se puede actualizar
dpkg -l | grep nginx                    # Verificar si está instalado
dpkg -L paquete                         # Ver qué archivos instaló un paquete
dpkg -S /usr/bin/vim                    # ¿A qué paquete pertenece este archivo?
```

---

## 8.3 DNF/YUM (RHEL/Rocky/Fedora)

```bash
sudo dnf update                         # Actualizar todo el sistema
sudo dnf install paquete                # Instalar
sudo dnf remove paquete                 # Desinstalar
sudo dnf search nombre                  # Buscar
sudo dnf info paquete                   # Información detallada
sudo dnf list installed                 # Listar instalados
sudo dnf history                        # Historial de transacciones
sudo dnf history undo last              # Deshacer la última transacción

# Grupos de paquetes
sudo dnf group list
sudo dnf group install "Development Tools"

# Repositorios
ls /etc/yum.repos.d/                    # Archivos de repositorios
sudo dnf config-manager --add-repo URL
```

---

## 8.4 Pacman (Arch Linux)

```bash
sudo pacman -Syu                        # Actualizar sistema completo
sudo pacman -S paquete                  # Instalar
sudo pacman -R paquete                  # Eliminar
sudo pacman -Rs paquete                 # Eliminar + dependencias no usadas
sudo pacman -Ss nombre                  # Buscar en repositorios
pacman -Qs nombre                       # Buscar en instalados
pacman -Qi paquete                      # Información del paquete
pacman -Ql paquete                      # Archivos de un paquete
```

---

## 8.5 Instalación manual de paquetes

### Instalación de paquetes .deb

```bash
sudo dpkg -i nombre_paquete.deb
sudo apt install -f                     # Corrige dependencias faltantes
```

### Instalación desde código fuente

Cuando el software no está empaquetado, se usa el flujo tradicional:

```bash
tar -xzvf fuente.tar.gz                 # 1. Descomprimir
cd directorio_fuente/
./configure                             # 2. Configurar (comprueba dependencias)
make                                    # 3. Compilar (convierte código en binario)
sudo make install                       # 4. Instalar (mueve a carpetas del sistema)
```

> ⚠️ No gestiona dependencias automáticamente y no queda registrado en el gestor de paquetes. Prefer usar paquetes del repositorio siempre que sea posible.

---

## 8.6 Paquetes Universales

Para evitar problemas de dependencias entre distribuciones:

- **Flatpak:** Enfocado en aplicaciones de escritorio con aislamiento (sandboxing).
  ```bash
  flatpak install flathub nombre
  flatpak list
  flatpak update
  ```

- **Snap:** Muy común en servidores y Ubuntu. Incluye todas las dependencias.
  ```bash
  sudo snap install nombre
  sudo snap list
  sudo snap refresh
  ```

- **AppImage:** No requiere instalación. Un solo archivo ejecutable portable.
  ```bash
  chmod +x aplicacion.AppImage
  ./aplicacion.AppImage
  ```

---

## 8.7 Repositorios externos y GPG

### Agregar Repositorios PPA

Los Personal Package Archives (PPA) permiten obtener software más actualizado.

```bash
sudo add-apt-repository ppa:usuario/repositorio
sudo apt update

# También se puede editar directamente:
/etc/apt/sources.list
/etc/apt/sources.list.d/
```

### Gestión de Claves GPG

Para garantizar que el software no ha sido manipulado, Linux usa claves GPG.

```bash
sudo apt install gnupg
curl -fsSL URL_CLAVE | sudo gpg --dearmor -o /usr/share/keyrings/repositorio.gpg

# Ejemplo: añadir repositorio de Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

> Al añadir repositorios modernos, siempre importar la clave pública del autor mediante `gpg --import` o añadiéndola a `/usr/share/keyrings/`

---

# 9. Archivado y Compresión de Ficheros

En Linux, **archivar** y **comprimir** son conceptos distintos:
- **Archivar:** Agrupar varios archivos en uno solo (`tar`)
- **Comprimir:** Reducir el peso usando algoritmos matemáticos (`gzip`, `bzip2`, `xz`)

## 9.1 Compresión básica: gzip, bzip2, xz

| Herramienta | Extensión | Velocidad | Ratio de compresión | Uso recomendado |
|---|---|---|---|---|
| `gzip` | `.gz` | ★★★★★ | ★★★ | Logs, uso general |
| `bzip2` | `.bz2` | ★★★ | ★★★★ | Mejor ratio que gzip |
| `xz` | `.xz` | ★★ | ★★★★★ | Máxima compresión, distribución de software |

```bash
# gzip
gzip archivo.txt                    # Genera archivo.txt.gz y ELIMINA el original
gzip -k archivo.txt                 # Comprime pero mantiene el original (-k = keep)
gunzip archivo.txt.gz               # Descomprimir
zcat archivo.txt.gz                 # Ver contenido sin descomprimir

# bzip2
bzip2 archivo.txt                   # Genera archivo.txt.bz2
bunzip2 archivo.txt.bz2             # Descomprimir
bzcat archivo.txt.bz2               # Ver sin descomprimir

# xz
xz archivo.txt                      # Genera archivo.txt.xz (más lento, mejor ratio)
unxz archivo.txt.xz                 # Descomprimir
xzcat archivo.txt.xz                # Ver sin descomprimir
```

---

## 9.2 tar — El archivador estándar

`tar` (Tape Archiver) no comprime por sí solo; empaqueta múltiples archivos en uno. Lo más común es combinar tar con compresión.

**Opciones principales:**
- `-c` → Crear (Create)
- `-x` → Extraer (eXtract)
- `-v` → Ver progreso (Verbose)
- `-f` → Especificar nombre del archivo (File) — siempre al final de las opciones
- `-z` → Compresión gzip
- `-j` → Compresión bzip2
- `-J` → Compresión xz
- `-t` → Listar contenido sin extraer

```bash
# Crear archivos
tar -cvf backup.tar /home/usuario/documentos         # Solo archivar
tar -czvf backup.tar.gz /home/usuario/              # Archivar + gzip
tar -cjvf backup.tar.bz2 /home/usuario/             # Archivar + bzip2
tar -cJvf backup.tar.xz /home/usuario/              # Archivar + xz

# Extraer
tar -xvf backup.tar                                  # Extraer en directorio actual
tar -xvf backup.tar.gz -C /destino/                 # Extraer en directorio específico
tar -xvf backup.tar.gz archivo_especifico           # Extraer solo un archivo

# Listar contenido sin extraer
tar -tvf backup.tar.gz

# Verificar integridad
tar -tvf backup.tar.gz > /dev/null && echo "OK" || echo "CORRUPTO"
```

---

## 9.3 zip / unzip

`zip` es muy popular para compatibilidad con Windows, ya que archiva y comprime en un solo paso.

```bash
sudo apt install zip unzip              # Instalar si no está disponible

zip -r backup.zip carpeta/             # El -r es vital para incluir subcarpetas
zip -re secure.zip carpeta/            # Proteger con contraseña
unzip archivo.zip                      # Descomprimir
unzip -l archivo.zip                   # Ver contenido sin extraer
unzip -t backup.zip                    # Test de integridad
```

---

## 9.4 Técnicas avanzadas de archivado

```bash
# Excluir ficheros al comprimir
tar --exclude='node_modules' --exclude='.git' -czvf proyecto.tar.gz ./mi_proyecto/

# Comprimir por bloques (split) — Para archivos muy grandes
tar -cvf - /data | split -b 100m - backup.tar.   # Divide en partes de 100MB
# Reconstruir: cat backup.tar.* | tar -xvf -

# Comprimir a través de la red (SSH) — Sin archivo temporal local
tar -czf - /home/usuario | ssh usuario@servidor "cat > /backup/home_$(date +%Y%m%d).tar.gz"

# Backup incremental con snapshot
tar --listed-incremental=snapshot.snar -czvf backup_$(date +%Y%m%d).tar.gz /home/

# Verificar integridad de archivos
tar -tvf backup.tar.gz          # Listar contenido y comprobar
unzip -t backup.zip             # Test de integridad zip

# Cifrado con GPG
tar -czvf backup.tar.gz /home/usuario
gpg -c backup.tar.gz            # Cifrar con contraseña simétrica
# Extraer y descifrar:
gpg -d backup.tar.gz.gpg | tar -xzvf -
```

> **Consejos:**
> - Elegir `gzip` para velocidad, `bzip2` para mejor ratio, `xz` para máxima compresión.
> - Siempre verificar integridad y permisos antes de transferir backups.
> - Comprimir a través de SSH permite backups remotos sin ocupar espacio local.
> - Usar exclusiones para no incluir carpetas temporales o irrelevantes como `node_modules`.

---