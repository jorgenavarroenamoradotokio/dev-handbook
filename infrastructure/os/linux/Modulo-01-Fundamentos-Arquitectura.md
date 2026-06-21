> **Estado:** 🟢 Completo
> **Última actualización:** 2026-06
> **Nivel:** Principiante — se explican los conceptos desde cero

---

- [1. ¿Qué es Linux?](#1-qué-es-linux)
  - [Distribuciones populares](#distribuciones-populares)
  - [El Kernel vs. El Espacio de Usuario](#el-kernel-vs-el-espacio-de-usuario)
    - [¿Por qué importa esta distinción?](#por-qué-importa-esta-distinción)
  - [Estándar de Jerarquía de Archivos (FHS)](#estándar-de-jerarquía-de-archivos-fhs)
    - [Directorios críticos en detalle](#directorios-críticos-en-detalle)
    - [Cheat Sheet — FHS](#cheat-sheet--fhs)
  - [El Proceso de Boot](#el-proceso-de-boot)
    - [Fase 1: BIOS / UEFI](#fase-1-bios--uefi)
    - [Fase 2: GRUB](#fase-2-grub)
    - [Fase 3: Kernel e initramfs](#fase-3-kernel-e-initramfs)
    - [Fase 4: systemd (PID 1)](#fase-4-systemd-pid-1)
- [2. Manejo de Ficheros y Directorios](#2-manejo-de-ficheros-y-directorios)
  - [Sistema de ficheros y rutas](#sistema-de-ficheros-y-rutas)
  - [Tipos de ficheros](#tipos-de-ficheros)
  - [Navegación esencial](#navegación-esencial)
  - [Creación y Visualización de Ficheros](#creación-y-visualización-de-ficheros)
    - [Creación rápida](#creación-rápida)
    - [Visualización de contenido](#visualización-de-contenido)
  - [Editores de Texto](#editores-de-texto)
  - [Manipulación de Ficheros y Directorios](#manipulación-de-ficheros-y-directorios)
  - [Búsqueda de ficheros](#búsqueda-de-ficheros)
    - [Cheat Sheet — Ficheros](#cheat-sheet--ficheros)
- [3. La Shell y el Entorno](#3-la-shell-y-el-entorno)
  - [¿Qué es la Shell?](#qué-es-la-shell)
  - [Variables de Entorno](#variables-de-entorno)
  - [Archivos de configuración de Bash](#archivos-de-configuración-de-bash)
  - [Aliases y Funciones](#aliases-y-funciones)
- [4. Comandos](#4-comandos)

---

# 1. ¿Qué es Linux?

Linux es un sistema operativo **libre y de código abierto**, basado en Unix, creado por Linus Torvalds en 1991. A diferencia de Windows o macOS, Linux es el núcleo (kernel) del sistema; lo que solemos llamar "Linux" es en realidad una distribución: el kernel Linux empaquetado con herramientas GNU, un gestor de paquetes y software adicional.

Sus pilares son:
- **Libre y de código abierto:** Cualquiera puede ver, modificar y distribuir el código fuente.
- **Multiusuario y multitarea:** Diseñado desde el principio para múltiples usuarios y procesos simultáneos.
- **Estabilidad y seguridad:** Base de la mayoría de servidores, supercomputadoras, dispositivos embebidos y la nube.
- **Portabilidad:** Funciona desde relojes inteligentes hasta mainframes.

## Distribuciones populares

Una distribución (distro) es el kernel Linux empaquetado con un ecosistema de software. Elegir la distro correcta es una decisión de arquitectura.

| Distribución | Gestor de Paquetes | Familia | Uso Principal |
|---|---|---|---|
| **Ubuntu / Debian** | `apt` (`.deb`) | Debian | Servidores, escritorio, cloud |
| **RHEL / Rocky Linux** | `dnf` (`.rpm`) | Red Hat | Servidores empresariales |
| **Fedora** | `dnf` (`.rpm`) | Red Hat | Desarrollo, bleeding-edge |
| **Arch Linux** | `pacman` | Arch | Power users, rolling release |
| **Kali Linux** | `apt` (`.deb`) | Debian | Seguridad y pentesting |
| **Alpine Linux** | `apk` | Independiente | Contenedores Docker (mínimo) |
| **openSUSE** | `zypper` (`.rpm`) | SUSE | Corporativo |

> **Consejo SysAdmin:** Para servidores en producción, **Ubuntu LTS** (5 años de soporte) o **Rocky Linux** (compatibilidad RHEL) son los estándares más usados. Para contenedores Docker, **Alpine** minimiza la superficie de ataque al máximo.

## El Kernel vs. El Espacio de Usuario

### ¿Por qué importa esta distinción?

Linux está dividido en dos capas que no se mezclan. Esta separación es la base de la **estabilidad y seguridad**: un programa de usuario mal escrito no puede corromper el núcleo del sistema.

```
┌─────────────────────────────────────────────────────┐
│                ESPACIO DE USUARIO                   │
│   Aplicaciones: bash, nginx, python, vim, etc.      │
│   Librerías:    glibc, libssl, libpthread...        │
├──────────────────────────┬──────────────────────────┤
│   Llamadas al sistema    │  syscalls: read, write,  │
│   (interfaz segura)      │  open, fork, exec, mmap  │
├──────────────────────────┴──────────────────────────┤
│                    KERNEL SPACE                     │
│   Gestión de memoria, procesos, dispositivos, FS    │
│   Scheduler de CPU, pila TCP/IP, drivers            │
├─────────────────────────────────────────────────────┤
│                    HARDWARE                         │
│   CPU, RAM, Disco, Tarjeta de Red, USB...           │
└─────────────────────────────────────────────────────┘
```

**El Kernel** se ejecuta en modo privilegiado (ring 0) con acceso directo al hardware. Sus responsabilidades son gestión de procesos, memoria, dispositivos, sistema de archivos y red.

**El Espacio de Usuario** son todos los programas que no son el kernel. No pueden acceder directamente al hardware; deben pedírselo al kernel mediante **syscalls**.

```bash
uname -r                    # Ver versión del kernel en ejecución
uname -a                    # Información completa del sistema
strace ls /tmp              # Ver las syscalls que hace un comando (diagnóstico)
lsmod                       # Módulos del kernel cargados (drivers)
cat /proc/version           # Versión detallada del kernel
```

> **Caso de uso real:** Un proceso consume RAM de forma anormal. Con `strace -p <PID>` ves exactamente qué syscalls hace, qué archivos abre y si está en un bucle de `malloc()`. Diagnóstico sin tocar el código fuente.

## Estándar de Jerarquía de Archivos (FHS)

El *Filesystem Hierarchy Standard* es el contrato que define dónde va cada tipo de archivo en Linux. Gracias a él, un script escrito para Ubuntu funciona en Rocky Linux con mínimas modificaciones.

```
/                   → Raíz. El origen de todo.
├── bin/            → Binarios esenciales (ls, cp, bash). Enlace a /usr/bin en sistemas modernos.
├── boot/           → Archivos de arranque: kernel (vmlinuz), initramfs, GRUB.
├── dev/            → Archivos de dispositivos. En Linux, TODO es un archivo.
├── etc/            → ★ Configuración del sistema. Solo texto plano. Aquí vive el SysAdmin.
├── home/           → Directorios personales (/home/ana, /home/juan).
├── lib/            → Librerías compartidas para los binarios de /bin y /sbin.
├── media/          → Punto de montaje automático para dispositivos extraíbles (USB, CD).
├── mnt/            → Punto de montaje temporal para el administrador.
├── opt/            → Software de terceros instalado manualmente (/opt/google/chrome).
├── proc/           → ★ Sistema de archivos VIRTUAL. Ventana al kernel en tiempo real.
├── root/           → Home del usuario root (separado de /home por seguridad).
├── run/            → Datos de runtime (PIDs, sockets). Se borra en cada reinicio.
├── sbin/           → Binarios de administración del sistema (fdisk, iptables).
├── srv/            → Datos servidos por el sistema (web, FTP).
├── sys/            → ★ Sistema de archivos VIRTUAL. Interfaz con el hardware.
├── tmp/            → Archivos temporales. Se limpia en cada reinicio.
├── usr/            → ★ Programas de usuario. La mayor parte del software instalado.
│   ├── bin/        → Comandos de usuario (python3, vim, git).
│   ├── lib/        → Librerías de los programas en /usr/bin.
│   ├── local/      → Software compilado manualmente (prioridad sobre /usr).
│   └── share/      → Archivos independientes de arquitectura (docs, iconos, fuentes).
└── var/            → ★ Datos variables en tiempo de ejecución.
    ├── log/        → Logs del sistema (/var/log/syslog, /var/log/auth.log).
    ├── lib/        → Datos persistentes de aplicaciones (MySQL, dpkg).
    ├── spool/      → Colas de impresión, correo pendiente.
    └── www/        → Raíz web por convención (Apache, Nginx).
```

### Directorios críticos en detalle

**`/etc` — El cerebro de la configuración**

```bash
/etc/passwd         # Base de datos de usuarios (sin contraseñas)
/etc/shadow         # Contraseñas cifradas (solo root)
/etc/group          # Base de datos de grupos
/etc/fstab          # Sistemas de archivos montados al boot
/etc/hosts          # Resolución de nombres local (antes que DNS)
/etc/hostname       # Nombre de esta máquina
/etc/resolv.conf    # Servidores DNS configurados
/etc/crontab        # Tareas programadas del sistema
/etc/sudoers        # Quién puede usar sudo y con qué comandos
/etc/ssh/           # Configuración del servidor SSH
/etc/apt/           # Configuración APT y repositorios (Debian/Ubuntu)
/etc/systemd/       # Units de systemd del administrador
```

**`/proc` — La ventana al kernel (virtual)**

`/proc` no existe en disco. El kernel lo genera en memoria en tiempo real.

```bash
cat /proc/cpuinfo           # Información detallada de la CPU
cat /proc/meminfo           # Estado de RAM y swap en tiempo real
cat /proc/uptime            # Segundos desde el último arranque
cat /proc/loadavg           # Carga del sistema (1, 5 y 15 min)
cat /proc/net/dev           # Estadísticas de interfaces de red
ls /proc/                   # Cada número = PID de un proceso en ejecución
cat /proc/12345/cmdline     # Comando exacto del proceso 12345
cat /proc/12345/environ     # Variables de entorno del proceso 12345
```

**`/sys` — Interfaz con el hardware (sysfs)**

```bash
cat /sys/class/net/eth0/speed              # Velocidad de la interfaz en Mbps
cat /sys/class/thermal/thermal_zone0/temp  # Temperatura (en milligrados Celsius)
ls /sys/block/                             # Discos reconocidos por el kernel
cat /sys/block/sda/size                    # Tamaño del disco en sectores de 512B
```

**`/var` — Datos que crecen y cambian**

```bash
tail -f /var/log/syslog         # Log general del sistema (Debian/Ubuntu)
tail -f /var/log/auth.log       # Intentos de login, uso de sudo
tail -f /var/log/kern.log       # Mensajes del kernel
journalctl -f                   # En sistemas systemd: log unificado en tiempo real
du -sh /var/log/*               # Ver qué logs ocupan más espacio
```

> **Caso real — diagnóstico rápido de servidor lento (30 segundos):**
> ```bash
> cat /proc/loadavg        # ¿Sistema sobrecargado?
> free -h                  # ¿Hay RAM? ¿Usa swap?
> tail -50 /var/log/nginx/error.log  # ¿Errores en el servidor web?
> df -h                    # ¿Se llenó el disco?
> ```

### Cheat Sheet — FHS

| Directorio | Contenido | ¿Se modifica? |
|---|---|---|
| `/etc` | Configuración del sistema | Sí, por el admin |
| `/var/log` | Logs del sistema y servicios | Sí, por el sistema |
| `/proc` | Estado del kernel en tiempo real | Virtual, lectura |
| `/sys` | Interfaz hardware/drivers | Algunos parámetros |
| `/tmp` | Archivos temporales | Sí, se limpia al reiniciar |
| `/opt` | Software de terceros | Sí, manual |
| `/usr/local` | Software compilado localmente | Sí, por el admin |

## El Proceso de Boot

Entender el boot es fundamental: cuando un servidor no arranca, este conocimiento es lo único que te salva.

```
BIOS/UEFI → Bootloader (GRUB) → Kernel → initramfs → systemd → Target
```

### Fase 1: BIOS / UEFI

- **BIOS:** Firmware clásico. Usa MBR (primeros 512 bytes del disco). Limitado a discos de 2TB y 4 particiones primarias.
- **UEFI:** Firmware moderno. Usa GPT y una partición ESP (`/boot/efi`). Soporta discos >2TB, Secure Boot y arranque más rápido.

```bash
ls /sys/firmware/efi        # Si existe, arrancó en modo UEFI. Si no, BIOS legado.
efibootmgr -v               # Lista las entradas de boot UEFI
```

### Fase 2: GRUB

GRUB es el menú que aparece antes de que Linux cargue. Permite elegir entre kernels o sistemas operativos, y es la última línea de defensa para rescatar un sistema roto.

```bash
cat /etc/default/grub           # ★ Aquí se edita la configuración de GRUB
sudo update-grub                # Regenerar grub.cfg (Debian/Ubuntu)
sudo grub2-mkconfig -o /boot/grub2/grub.cfg  # RHEL/Rocky

# Parámetros clave de /etc/default/grub:
# GRUB_TIMEOUT=5              → Segundos que espera antes de arrancar
# GRUB_DEFAULT=0              → Entrada del menú por defecto
# GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"  → Parámetros para el kernel
```

### Fase 3: Kernel e initramfs

El kernel necesita montar el sistema de archivos raíz, pero los drivers están en el disco. El **initramfs** resuelve este problema: un sistema de archivos mínimo en RAM con lo justo para montar el disco real.

```bash
ls -lh /boot/               # Ver kernel (vmlinuz-*) e initramfs (initrd.img-*)
sudo update-initramfs -u    # Reconstruir initramfs (Debian/Ubuntu)
sudo dracut --force         # Reconstruir initramfs (RHEL/Rocky)
```

### Fase 4: systemd (PID 1)

systemd es el proceso con PID 1, padre de todos los demás. Arranca todos los servicios en paralelo y organiza el arranque en **targets** (equivalente a los runlevels de SysV).

```bash
ps -p 1                         # Ver que PID 1 es systemd
systemctl get-default           # Ver el target de arranque actual
sudo systemctl set-default multi-user.target  # Servidor sin gráficos

# Targets principales:
# poweroff.target   → Apagado
# rescue.target     → Modo rescate (sin red)
# multi-user.target → Multiusuario sin gráficos (servidores)
# graphical.target  → Con escritorio
# reboot.target     → Reinicio

systemd-analyze blame | head -20        # Qué servicio tarda más en arrancar
systemd-analyze critical-chain          # Árbol de dependencias crítico del arranque
```

# 2. Manejo de Ficheros y Directorios

## Sistema de ficheros y rutas

A diferencia de Windows, Linux no usa letras de unidad (C:, D:). Todo cuelga de la raíz `/` en un árbol único. Los dispositivos físicos se "montan" en directorios de ese árbol.

- **Case sensitive:** `Archivo.txt` y `archivo.txt` son dos archivos **distintos**.
- **Ficheros ocultos:** Cualquier archivo cuyo nombre empieza por `.` (ej: `.bashrc`).
- **Ruta absoluta:** Desde la raíz, siempre empieza por `/` → `/home/usuario/documentos/notas.txt`
- **Ruta relativa:** Desde donde estás actualmente.

```bash
pwd                     # ¿Dónde estoy? (Print Working Directory)
cd /etc/network         # Ruta absoluta
cd ../Descargas         # Ruta relativa: un nivel arriba, luego Descargas
cd -                    # Volver al directorio anterior (como botón Atrás)
cd ~                    # Ir al home del usuario actual
cd ~otro_usuario        # Ir al home de otro usuario

# Atajos de navegación:
# .   → Directorio actual
# ..  → Directorio padre (un nivel arriba)
# ~   → Directorio home del usuario
# -   → Último directorio visitado
```

## Tipos de ficheros

En Linux, absolutamente todo es un archivo. Los tipos son:

| Símbolo | Tipo | Descripción |
|---|---|---|
| `-` | Regular | Documentos, scripts, binarios, imágenes |
| `d` | Directorio | Contenedor de ficheros |
| `l` | Enlace simbólico | Como un acceso directo. Si borras el original, se rompe |
| `c` | Dispositivo de caracteres | Terminales, teclado (`/dev/tty`) |
| `b` | Dispositivo de bloques | Discos duros (`/dev/sda`) |
| `p` | Pipe nombrada | Comunicación entre procesos |
| `s` | Socket | Comunicación de red entre procesos |

```bash
file /usr/bin/bash              # Identificar tipo real de un archivo
file imagen.jpg                 # "JPEG image data, JFIF..."
ls -la /dev/ | head -20         # Ver tipos de archivos de dispositivos

# Crear enlaces
ln -s /ruta/original /ruta/enlace_simbolico   # Enlace simbólico (como acceso directo)
ln /ruta/original /ruta/enlace_duro           # Enlace duro: comparte inodo con el original
readlink -f enlace_simbolico                  # Ver a dónde apunta un enlace simbólico
```

> **Diferencia entre enlace simbólico y duro:** Si borras el archivo original, el enlace simbólico se rompe (apunta a la nada). El enlace duro sigue funcionando porque el archivo real (el inodo) solo se elimina cuando se borran **todos** sus enlaces.


## Navegación esencial

```bash
# Listar archivos
ls                      # Listado simple
ls -l                   # Listado largo: permisos, propietario, tamaño, fecha
ls -lh                  # Con tamaños legibles (KB, MB, GB)
ls -la                  # Incluye archivos ocultos (los que empiezan por .)
ls -lS                  # Ordenado por tamaño (mayor primero)
ls -lt                  # Ordenado por fecha (más reciente primero)
ls -ltr                 # Más antiguo primero (útil para logs)
ls -R                   # Listado recursivo de todos los subdirectorios
ls /var/log/*.log       # Solo archivos .log en /var/log

# Comodines (globbing)
ls *.log                # Todos los archivos que terminan en .log
ls archivo?.txt         # archivo1.txt, archivo2.txt... (? = 1 carácter cualquiera)
ls [0-9]*               # Archivos que empiezan por dígito
```

## Creación y Visualización de Ficheros

### Creación rápida

```bash
touch archivo.txt               # Crear fichero vacío (o actualizar fecha si existe)
touch archivo1 archivo2 archivo3  # Crear varios a la vez
mkdir directorio                # Crear directorio
mkdir -p /ruta/a/directorio/nuevo  # Crear toda la ruta si no existe (-p = parents)
mkdir -m 700 directorio_privado    # Crear con permisos específicos
```

### Visualización de contenido

```bash
cat archivo.txt                 # Mostrar todo el contenido de golpe (archivos cortos)
cat -n archivo.txt              # Con números de línea
cat archivo1 archivo2           # Concatenar y mostrar varios archivos

less archivo.txt                # ★ Paginador interactivo (el mejor para archivos largos)
# En less: Espacio=pág siguiente, b=anterior, /patrón=buscar, q=salir, G=final, g=inicio

more archivo.txt                # Paginador básico (solo hacia adelante)

head archivo.txt                # Primeras 10 líneas
head -n 50 archivo.txt          # Primeras 50 líneas

tail archivo.txt                # Últimas 10 líneas
tail -n 100 archivo.txt         # Últimas 100 líneas
tail -f /var/log/syslog         # ★ Seguir el archivo en tiempo real (esencial para logs)
tail -f -n 0 /var/log/syslog    # Esperar solo nuevas líneas

# Comparar archivos
diff archivo1.txt archivo2.txt          # Ver diferencias línea a línea
diff -u archivo1.txt archivo2.txt       # Formato unificado (como git diff)

# Contar
wc -l archivo.txt               # Contar líneas
wc -w archivo.txt               # Contar palabras
wc -c archivo.txt               # Contar bytes
```

## Editores de Texto

Existen dos mundos principales en la terminal:

**Nano — Sencillo e intuitivo**
```bash
nano archivo.conf               # Abrir archivo
# Comandos visibles en la parte inferior:
# Ctrl+O → Guardar (Write Out)
# Ctrl+X → Salir
# Ctrl+W → Buscar
# Ctrl+K → Cortar línea
# Ctrl+U → Pegar línea
```

**Vim — El estándar profesional (editor modal)**
```bash
vim archivo.conf                # Abrir archivo

# Vim tiene MODOS. Empieza en Modo Comando:
# i      → Entrar en Modo Inserción (para escribir)
# Esc    → Volver al Modo Comando
# :w     → Guardar
# :q     → Salir (si no hay cambios)
# :wq    → Guardar y salir
# :q!    → Salir SIN guardar (forzado)
# :x     → Guardar y salir (equivale a :wq)

# En Modo Comando (sin inserción):
# dd     → Borrar línea completa
# yy     → Copiar línea
# p      → Pegar
# u      → Deshacer (undo)
# Ctrl+R → Rehacer (redo)
# /patrón → Buscar hacia adelante
# n      → Siguiente coincidencia
# :%s/viejo/nuevo/g → Reemplazar en todo el archivo

vimtutor                        # Tutorial interactivo oficial de vim (¡muy recomendado!)
```

## Manipulación de Ficheros y Directorios

```bash
# COPIAR
cp origen destino               # Copiar archivo
cp -r carpeta/ destino/         # Copiar directorio recursivamente
cp -p archivo destino           # Preservar permisos, propietario y fechas
cp -a carpeta/ destino/         # Archive: copia preservando todo (recursivo + metadatos)
cp -u origen destino            # Solo copia si origen es más nuevo (backups)
cp -v origen destino            # Verbose: muestra lo que copia

# MOVER / RENOMBRAR
mv archivo.txt /ruta/destino/   # Mover archivo
mv antiguo_nombre.txt nuevo.txt # Renombrar (mismo directorio)
mv -i origen destino            # Interactivo: pregunta antes de sobrescribir
mv -n origen destino            # No sobrescribe si ya existe

# ELIMINAR (¡No hay papelera en la CLI!)
rm archivo.txt                  # Eliminar archivo
rm -i archivo.txt               # Interactivo: pide confirmación
rm -f archivo.txt               # Force: sin confirmación aunque sea solo lectura
rm -r directorio/               # Recursivo: directorio y todo su contenido
rm -rf directorio/              # ★ El más peligroso. NUNCA: rm -rf / o rm -rf /*
rm *.tmp                        # Eliminar todos los archivos .tmp del directorio actual

| Comando | Acción | Ejemplo |
|---------|--------|---------|
| `cp` | Copiar | `cp -r origen/ destino/` |
| `mv` | Mover o renombrar | `mv viejo.txt nuevo.txt` |
| `rm` | Eliminar | `rm -rf carpeta/` |
| `ln` | Crear enlace | `ln -s origen enlace` |
```

---

## Búsqueda de ficheros

**`find` — Búsqueda en tiempo real (el más potente)**

```bash
find /home -name "*.pdf"                    # Buscar por nombre con comodín
find /var/log -name "*.log" -type f         # Solo archivos (no directorios)
find / -type d -name "node_modules"         # Solo directorios con ese nombre
find . -mtime -7                            # Modificados en los últimos 7 días
find . -mtime +30                           # Modificados hace más de 30 días
find / -size +100M                          # Archivos mayores de 100MB
find /etc -user root -perm 644              # De root con permisos 644
find . -name "*.sh" -exec chmod +x {} \;   # Buscar Y ejecutar comando sobre cada resultado
find . -name "*.log" -delete               # Buscar y borrar (¡cuidado!)

# Combinación potente: find + grep
find /etc -type f -exec grep -l "PasswordAuthentication" {} \; 2>/dev/null
```

**`locate` — Búsqueda instantánea (base de datos)**

```bash
sudo updatedb                   # Actualizar la base de datos primero
locate archivo.txt              # Búsqueda instantánea (puede estar desactualizada)
```

**`which` / `whereis` — Localizar binarios**

```bash
which python3                   # Ruta del ejecutable que se usará
whereis nginx                   # Binario + código fuente + página man
type ls                         # Distingue si es alias, función o binario
```

### Cheat Sheet — Ficheros

| Comando | Función |
|---|---|
| `ls -lah` | Listado completo con ocultos y tamaños legibles |
| `tail -f /var/log/syslog` | Seguir log en tiempo real |
| `find . -name "*.log" -mtime +7` | Archivos .log con más de 7 días |
| `cp -a src/ dst/` | Copiar preservando todos los atributos |
| `diff -u file1 file2` | Ver diferencias entre archivos |
| `wc -l archivo` | Contar líneas de un archivo |

# 3. La Shell y el Entorno

## ¿Qué es la Shell?

La shell es el intérprete de comandos: el programa que lee lo que escribes, lo interpreta y se lo pasa al sistema operativo. Las más comunes son:

- **bash** (Bourne Again Shell): La shell por defecto en la mayoría de distribuciones.
- **zsh**: Más potente e interactiva (por defecto en macOS, popular en desarrolladores).
- **sh**: Shell POSIX básica, compatible con todos los sistemas Unix.
- **fish**: Shell moderna con autocompletado inteligente.

```bash
echo $SHELL                 # Ver tu shell actual
cat /etc/shells             # Ver todas las shells instaladas en el sistema
chsh -s /bin/zsh            # Cambiar tu shell por defecto
```

## Variables de Entorno

```bash
env                         # Ver todas las variables de entorno
printenv PATH               # Ver una variable específica
echo $HOME                  # Mostrar valor de una variable
echo $USER                  # Usuario actual
echo $SHELL                 # Shell en uso
echo $PATH                  # Rutas donde la shell busca ejecutables
echo $LANG                  # Idioma/locale del sistema

# Variables más importantes:
# PATH  → Rutas donde se buscan los ejecutables
# HOME  → Directorio personal del usuario
# USER  → Nombre del usuario actual
# PS1   → Cómo se ve el prompt (lo que aparece antes del cursor)
# TERM  → Tipo de terminal

# Definir variables
MI_VAR="hola mundo"                     # Variable local (solo en la shell actual)
export MI_VAR="hola mundo"              # Variable de entorno (disponible en procesos hijos)
export PATH="$PATH:/opt/miapp/bin"      # Añadir ruta al PATH

# Hacer variables permanentes (añadir al archivo de configuración)
echo 'export PATH="$PATH:/opt/miapp/bin"' >> ~/.bashrc
source ~/.bashrc                        # Recargar la config sin reiniciar la shell
. ~/.bashrc                             # Forma abreviada de source
```

## Archivos de configuración de Bash

```bash
~/.bashrc           # Se ejecuta en cada shell interactiva no-login (nueva pestaña)
~/.bash_profile     # Se ejecuta en shells de login (SSH, su -)
~/.bash_aliases     # Convención para guardar aliases (se importa desde .bashrc)
~/.bash_history     # Historial de comandos
/etc/bash.bashrc    # Configuración global de bash para todos los usuarios
/etc/profile        # Variables de entorno globales para todos los usuarios
/etc/profile.d/     # Scripts que se ejecutan al login (un archivo por aplicación)
```

## Aliases y Funciones

```bash
# Aliases — atajos de comandos
alias ll='ls -lah'
alias la='ls -A'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias update='sudo apt update && sudo apt upgrade -y'
alias logs='journalctl -f'
alias myip='curl -s ifconfig.me'

alias                           # Ver todos los aliases definidos
unalias ll                      # Eliminar un alias (solo en la sesión actual)

# Para que sean permanentes, añadirlos a ~/.bashrc o ~/.bash_aliases

# Funciones — más potentes que aliases, aceptan argumentos
mcd() {
    mkdir -p "$1" && cd "$1"
}
# Uso: mcd /nueva/ruta/directorio  → la crea y entra en ella

# Función para buscar en el historial con fzf
hg() {
    history | grep "$1"
}
```

# 4. Comandos

```bash
history                         # Ver el historial completo
history 20                      # Ver los últimos 20 comandos
!!                              # Repetir el último comando
!n                              # Repetir el comando número n del historial
!nginx                          # Repetir el último comando que empezó con "nginx"
sudo !!                         # Repetir el último comando con sudo (muy útil)
Ctrl+R                          # Búsqueda inversa interactiva en el historial

history | grep "apt install"    # Buscar en el historial

# Configurar el historial en ~/.bashrc
HISTSIZE=10000                  # Comandos guardados en memoria
HISTFILESIZE=20000              # Comandos guardados en el archivo ~/.bash_history
HISTCONTROL=ignoredups:erasedups  # No guardar duplicados consecutivos
HISTTIMEFORMAT="%d/%m/%Y %H:%M:%S "  # Guardar fecha y hora en el historial
```