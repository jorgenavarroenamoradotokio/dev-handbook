> **Estado:** 🟢 Completo
> **Última actualización:** 2026-06
> **Nivel:** Principiante — se explican los conceptos desde cero

---

- [1. Redirecciones y Pipelines](#1-redirecciones-y-pipelines)
  - [Los tres flujos estándar](#los-tres-flujos-estándar)
  - [Operadores de redirección](#operadores-de-redirección)
  - [El Pipe y combinaciones avanzadas](#el-pipe-y-combinaciones-avanzadas)
    - [Cheat Sheet — Redirecciones](#cheat-sheet--redirecciones)
- [2. Procesamiento de Texto Avanzado](#2-procesamiento-de-texto-avanzado)
  - [grep — Búsqueda de patrones](#grep--búsqueda-de-patrones)
  - [sed — Editor de flujo](#sed--editor-de-flujo)
  - [awk — Procesador estructurado](#awk--procesador-estructurado)
  - [cut, sort, uniq, tr](#cut-sort-uniq-tr)
    - [Pipelines de poder — Casos reales](#pipelines-de-poder--casos-reales)
  - [Expresiones Regulares](#expresiones-regulares)
    - [Metacaracteres Fundamentales](#metacaracteres-fundamentales)
    - [Corchetes y Rangos](#corchetes-y-rangos)
    - [Cuantificadores](#cuantificadores)
    - [BRE vs ERE](#bre-vs-ere)
    - [Clases de Caracteres POSIX](#clases-de-caracteres-posix)
    - [Ejemplos prácticos con regex](#ejemplos-prácticos-con-regex)
- [3. Permisos de Usuario](#3-permisos-de-usuario)
  - [Archivos críticos del sistema](#archivos-críticos-del-sistema)
    - [Anatomía de /etc/passwd](#anatomía-de-etcpasswd)
  - [El Sistema de Permisos (rwx)](#el-sistema-de-permisos-rwx)
    - [Representación y Notación](#representación-y-notación)
  - [Notación octal y simbólica](#notación-octal-y-simbólica)
    - [Conversión a Notación Octal (Numérica)](#conversión-a-notación-octal-numérica)
    - [Cambiar Propietario y Grupo](#cambiar-propietario-y-grupo)
  - [Máscaras de permisos (umask)](#máscaras-de-permisos-umask)
  - [Permisos Especiales: SUID, SGID y Sticky Bit](#permisos-especiales-suid-sgid-y-sticky-bit)
    - [SUID (Set User ID) — Bit 4000](#suid-set-user-id--bit-4000)
    - [SGID (Set Group ID) — Bit 2000](#sgid-set-group-id--bit-2000)
    - [Sticky Bit — Bit 1000](#sticky-bit--bit-1000)
    - [Tabla resumen de bits especiales](#tabla-resumen-de-bits-especiales)
  - [Listas de Control de Acceso (ACLs)](#listas-de-control-de-acceso-acls)
  - [Gestión de Usuarios y Grupos](#gestión-de-usuarios-y-grupos)
  - [El Usuario Root](#el-usuario-root)
  - [Elevación de Privilegios: sudo y su](#elevación-de-privilegios-sudo-y-su)
    - [sudo — La forma correcta y auditable](#sudo--la-forma-correcta-y-auditable)
    - [su — Cambiar de usuario](#su--cambiar-de-usuario)
    - [sudo vs su](#sudo-vs-su)
  - [Gestión de Sesiones](#gestión-de-sesiones)
- [4. Comandos Permisos y Usuarios](#4-comandos-permisos-y-usuarios)

---

# 1. Redirecciones y Pipelines

## Los tres flujos estándar

En Linux, cada proceso tiene tres flujos de datos conectados por defecto:

```
stdin  (0) ← Entrada estándar  → Por defecto: teclado
stdout (1) → Salida estándar   → Por defecto: terminal
stderr (2) → Salida de errores → Por defecto: terminal
```

## Operadores de redirección

```bash
# STDOUT — Redirigir la salida
echo "Hola Mundo" > archivo.txt         # Redirige a archivo (SOBRESCRIBE)
echo "Segunda línea" >> archivo.txt     # Redirige a archivo (AÑADE al final)

# STDERR — Redirigir errores
ls /no_existe 2> errores.log            # Redirige solo errores al archivo
comando > salida.log 2> errores.log     # Separa stdout y stderr
comando > todo.log 2>&1                 # Redirige stderr al mismo destino que stdout
comando &> todo.log                     # Forma abreviada (bash moderno)

# /dev/null — El agujero negro (descartar salida)
comando > /dev/null                     # Descartar stdout
comando > /dev/null 2>&1               # Descartar TODO (stdout y stderr)

# STDIN — Leer desde archivo
sort < lista_desordenada.txt            # sort lee del archivo en vez del teclado
grep "error" < /var/log/syslog

# Here Document — Texto multilínea como entrada
cat <<EOF > /etc/motd
Bienvenido al servidor de producción.
Acceso restringido. Todos los accesos son monitorizados.
EOF

# tee — Copiar salida a archivo Y mostrar en pantalla al mismo tiempo
apt upgrade 2>&1 | tee /tmp/upgrade.log
tail -f /var/log/nginx/access.log | tee -a registros_hoy.log
```

## El Pipe y combinaciones avanzadas

El pipe `|` conecta el stdout de un comando con el stdin del siguiente. Es la herramienta más poderosa de la CLI Unix.

```bash
# Sintaxis: comando1 | comando2 | comando3

ls -la | grep ".log"                            # Filtrar listado
cat /var/log/auth.log | grep "Failed" | wc -l  # Contar intentos fallidos de login
ps aux | grep nginx | grep -v grep             # Buscar proceso (excluyendo el propio grep)
du -sh /var/log/* | sort -rh | head -10        # Top 10 archivos más grandes

# Casos reales de SysAdmin

# 1. Guardar la salida de apt con errores separados
sudo apt upgrade > /tmp/upgrade.log 2> /tmp/upgrade_errors.log

# 2. Top 10 IPs con más intentos fallidos de SSH
grep "Failed password" /var/log/auth.log \
  | grep -oE "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" \
  | sort | uniq -c | sort -rn | head -10

# 3. Redirigir proceso largo al log con fecha
./backup.sh > /var/log/backup_$(date +%Y%m%d).log 2>&1 &
```

### Cheat Sheet — Redirecciones

| Operador | Función |
|---|---|
| `>` | Redirige stdout a archivo (sobrescribe) |
| `>>` | Redirige stdout a archivo (añade) |
| `2>` | Redirige stderr a archivo |
| `2>&1` | Redirige stderr al mismo destino que stdout |
| `&>` | Redirige stdout y stderr juntos |
| `\|` | Conecta stdout de un comando al stdin del siguiente |
| `tee` | Copia stdout a archivo Y lo muestra en pantalla |
| `> /dev/null` | Descarta la salida |

# 2. Procesamiento de Texto Avanzado

## grep — Búsqueda de patrones

`grep` (Global Regular Expression Print) busca líneas que coincidan con un patrón.

```bash
grep "error" /var/log/syslog            # Buscar líneas con "error"
grep -i "Error" /var/log/syslog         # Ignorar mayúsculas/minúsculas
grep -r "password" /etc/               # Recursivo en directorio
grep -v "comentario" archivo.conf       # Invertir (mostrar lo que NO coincide)
grep -n "error" archivo.log             # Mostrar número de línea
grep -c "error" archivo.log             # Contar coincidencias (no mostrar líneas)
grep -l "error" /var/log/*.log          # Solo nombres de archivos con coincidencias
grep -A 3 "ERROR" archivo.log           # 3 líneas DESPUÉS de la coincidencia
grep -B 2 "ERROR" archivo.log           # 2 líneas ANTES
grep -C 2 "ERROR" archivo.log           # 2 líneas de contexto (antes y después)
grep -E "patrón" archivo                # Expresiones regulares extendidas (ERE)
grep -w "root" /etc/passwd              # Coincidencia de palabra completa

# Ejemplos con regex
grep -E "^[0-9]{3}" archivo.txt                         # Líneas que empiezan con 3 dígitos
grep -E "ERROR|WARN|CRITICAL" app.log                   # Múltiples patrones
grep -E "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" access.log  # Encontrar IPs
grep -oE "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" access.log   # Extraer solo la IP (-o)
```

## sed — Editor de flujo

`sed` procesa texto línea por línea aplicando transformaciones. El rey de las sustituciones en batch.

```bash
# Sustitución básica: s/patrón/sustitución/flags
sed 's/viejo/nuevo/' archivo.txt        # Sustituye la PRIMERA aparición en cada línea
sed 's/viejo/nuevo/g' archivo.txt       # Global: sustituye TODAS las apariciones
sed 's/viejo/nuevo/gi' archivo.txt      # Global + ignorar mayúsculas
sed -i 's/viejo/nuevo/g' archivo.txt    # Modifica el archivo IN PLACE
sed -i.bak 's/viejo/nuevo/g' archivo   # Modifica y crea backup .bak

# Operaciones con líneas
sed '5d' archivo.txt                    # Borrar la línea 5
sed '/patrón/d' archivo.txt            # Borrar líneas que contienen el patrón
sed -n '10,20p' archivo.txt            # Mostrar solo líneas 10 a 20
sed '/^#/d; /^$/d' archivo.conf        # Eliminar comentarios y líneas vacías

# Casos reales de SysAdmin
# Cambiar IP en archivo de configuración
sed -i 's/192\.168\.1\.100/10\.0\.0\.50/g' /etc/hosts

# Desactivar login de root en SSH
sed -i 's/^PermitRootLogin yes/#PermitRootLogin yes\nPermitRootLogin no/' /etc/ssh/sshd_config

# Transformar fecha de YYYY-MM-DD a DD/MM/YYYY
echo "2026-01-15" | sed -E 's/([0-9]{4})-([0-9]{2})-([0-9]{2})/\3\/\2\/\1/'
# Salida: 15/01/2026
```

## awk — Procesador estructurado

`awk` es prácticamente un lenguaje de programación. Diseñado para trabajar con texto en columnas.

```bash
# Variables especiales de awk:
# $0  = Línea completa
# $1, $2 = Primer, segundo campo (columna)
# NF  = Número de campos en la línea actual
# NR  = Número de línea (record) actual
# FS  = Separador de campos (por defecto: espacio/tab)

# Imprimir la primera y tercera columna de /etc/passwd (separado por :)
awk -F ":" '{ print $1, $3 }' /etc/passwd

# Imprimir usuario y directorio home
awk -F: '{print $1 ":" $6}' /etc/passwd

# Imprimir solo la línea 5
awk 'NR==5' archivo.txt

# Imprimir líneas donde el campo 3 es mayor que 1000 (UIDs de usuarios reales)
awk -F: '$3 >= 1000 {print $1, $3, $6}' /etc/passwd

# Bloques BEGIN y END
awk 'BEGIN {print "=== Usuarios ==="} -F: {print $1} END {print "=== Fin ==="}' /etc/passwd

# Calcular suma de una columna numérica
awk -F: '{sum += $3} END {print "Suma de UIDs:", sum}' /etc/passwd

# Analizar access.log: Top 10 IPs con más peticiones
awk '{print $1}' /var/log/nginx/access.log | sort | uniq -c | sort -rn | head -10
```

## cut, sort, uniq, tr

```bash
# cut — Extraer columnas
cut -d: -f1 /etc/passwd             # Separador ':', campo 1 (nombres de usuario)
cut -d: -f1,3 /etc/passwd           # Campos 1 y 3
cut -d: -f1-3 /etc/passwd           # Campos del 1 al 3
cut -c1-10 archivo.txt              # Primeros 10 caracteres de cada línea

# sort — Ordenar
sort archivo.txt                    # Orden alfabético
sort -n numeros.txt                 # Orden numérico
sort -r archivo.txt                 # Orden inverso
sort -k2 -t: archivo.txt            # Ordenar por campo 2, separado por ':'
sort -rn -k3 archivo.txt            # Numérico inverso por campo 3
sort -u archivo.txt                 # Ordenar y eliminar duplicados

# uniq — Deduplicar (trabaja con líneas ADYACENTES, usar siempre tras sort)
sort archivo.txt | uniq             # Eliminar duplicados
sort archivo.txt | uniq -c          # Contar ocurrencias de cada línea
sort archivo.txt | uniq -d          # Mostrar solo líneas DUPLICADAS
sort archivo.txt | uniq -u          # Mostrar solo líneas ÚNICAS

# tr — Traducir/eliminar caracteres
tr 'a-z' 'A-Z' < archivo.txt        # Convertir a mayúsculas
tr -d '\r' < windows.txt > unix.txt # Eliminar retornos de carro de Windows
tr -s ' ' < archivo.txt             # Comprimir espacios múltiples en uno
tr -d '[:digit:]' < archivo.txt     # Eliminar todos los dígitos
```

### Pipelines de poder — Casos reales

```bash
# ★ Top 10 IPs con más intentos fallidos de SSH
grep "Failed password" /var/log/auth.log \
  | grep -oE "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" \
  | sort | uniq -c | sort -rn | head -10

# ★ Extraer usuarios del sistema con UID >= 1000 (usuarios reales)
awk -F: '$3 >= 1000 {print $1, $3, $6}' /etc/passwd | sort -k2 -n

# ★ Limpiar un archivo de configuración (quitar comentarios y líneas vacías)
grep -v "^#" /etc/ssh/sshd_config | grep -v "^$"

# ★ Analizar un CSV — ranking de valores en la columna 3
cat ventas.csv | cut -d',' -f3 | sort | uniq -c | sort -rn | head -10

# ★ Top 10 directorios que más espacio ocupan en /var/log
du -sh /var/log/* 2>/dev/null | sort -rh | head -10

# ★ Contar palabras únicas en un documento
cat documento.txt | tr ' ' '\n' | tr -d '[:punct:]' | sort | uniq -c | sort -rn | head -20
```

## Expresiones Regulares

Una expresión regular (regex) es un patrón para describir conjuntos de texto. Usadas por `grep`, `sed`, `awk` y muchos otros.

### Metacaracteres Fundamentales

| Símbolo | Significado | Ejemplo |
|---|---|---|
| `.` | Cualquier carácter (excepto newline) | `c.sa` → "casa", "cosa" |
| `^` | Inicio de línea | `^root` → líneas que empiezan con "root" |
| `$` | Fin de línea | `bash$` → líneas que terminan en "bash" |
| `*` | 0 o más del anterior | `lo*g` → "lg", "log", "looog" |
| `+` | 1 o más (ERE) | `lo+g` → "log", "looog" (no "lg") |
| `?` | 0 o 1 (ERE) | `colo?r` → "color" o "colour" |
| `\|` | OR lógico (ERE) | `cat\|dog` → "cat" o "dog" |
| `[]` | Conjunto de caracteres | `[aeiou]` → cualquier vocal |
| `[^]` | Negación de conjunto | `[^0-9]` → cualquier no-dígito |
| `{n,m}` | Entre n y m repeticiones (ERE) | `a{2,4}` → "aa","aaa","aaaa" |
| `\` | Escapar metacarácter | `\.` → punto literal |

### Corchetes y Rangos

```bash
grep "[A-Z][0-9]" archivo.txt           # Mayúscula seguida de dígito
grep "[aeiou]" archivo.txt              # Cualquier vocal
grep "[^0-9]" archivo.txt              # Cualquier carácter no-dígito
```

### Cuantificadores

| Cuantificador | Significado | Tipo |
|---|---|---|
| `*` | 0 o más veces | Básico (BRE) |
| `?` | 0 o 1 vez | Extendido (ERE) |
| `+` | 1 o más veces | Extendido (ERE) |
| `{n}` | Exactamente n veces | Extendido (ERE) |
| `{n,m}` | Entre n y m veces | Extendido (ERE) |

```bash
grep -E "a{2,4}" archivo.txt            # Coincide con 'aa', 'aaa' o 'aaaa'
```

### BRE vs ERE

```bash
# BRE (grep por defecto): metacaracteres necesitan escape
grep "^\(hola\|adios\)" archivo.txt

# ERE (grep -E): más limpio y potente
grep -E "^(hola|adios)" archivo.txt
```

### Clases de Caracteres POSIX

```bash
[[:alpha:]]     # Letras [a-zA-Z]
[[:digit:]]     # Dígitos [0-9]
[[:alnum:]]     # Alfanuméricos
[[:space:]]     # Espacios y tabuladores
[[:upper:]]     # Mayúsculas
[[:lower:]]     # Minúsculas
[[:punct:]]     # Signos de puntuación

# Alternancia y agrupación (ERE)
grep -E "rojo|azul" archivo.txt
grep -E "(video)(juego|teca)" archivo.txt   # → "videojuego" o "videoteca"
```

### Ejemplos prácticos con regex

```bash
grep -E "^([0-9]{1,3}\.){3}[0-9]{1,3}$" ips.txt          # Validar formato IP
grep -E "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" emails.txt  # Encontrar emails
grep -oE "https?://[^ ]+" access.log                       # Extraer URLs
grep -E "[0-9]{4}-[0-9]{2}-[0-9]{2}" log.txt              # Buscar fechas YYYY-MM-DD
```

# 3. Permisos de Usuario

Linux es un sistema multiusuario. El modelo de permisos es la primera línea de defensa de seguridad.

## Archivos críticos del sistema

El sistema gestiona la identidad mediante tres archivos de texto en `/etc/`:

- **`/etc/passwd`:** Contiene información de los usuarios (UID, shell, directorio home). Visible por todos, pero **sin contraseñas**.
- **`/etc/shadow`:** Almacena las contraseñas cifradas y políticas de expiración. Accesible **solo por root**.
- **`/etc/group`:** Define los grupos y sus miembros.
- **`/etc/gshadow`:** Contraseñas de grupos (solo root).
- **`/etc/sudoers`:** Configuración de permisos sudo.

### Anatomía de /etc/passwd

```
usuario:x:1001:1001:Nombre Completo:/home/usuario:/bin/bash
  │      │  │    │        │              │             │
  │      │  │    │        │              │             └─ Shell de login
  │      │  │    │        │              └─ Directorio home
  │      │  │    │        └─ Información GECOS (nombre real)
  │      │  │    └─ GID primario
  │      │  └─ UID (User ID)
  │      └─ 'x' = contraseña está en /etc/shadow
  └─ Nombre de usuario
```

```bash
cat /etc/passwd | grep -v "nologin\|false"   # Solo usuarios con shell real
sudo cat /etc/shadow | head -5               # Ver estructura (necesita root)
getent passwd usuario                        # Consultar base de datos de usuarios
getent group sudo                            # Ver miembros de un grupo
id usuario                                   # UID, GID y grupos del usuario
```

## El Sistema de Permisos (rwx)

Cada archivo/directorio tiene tres permisos básicos que se aplican a tres categorías:

| Permiso | Símbolo | Valor | En archivo | En directorio |
|---|---|---|---|---|
| Lectura | `r` | 4 | Ver el contenido | Listar el contenido (`ls`) |
| Escritura | `w` | 2 | Modificar el archivo | Crear/borrar archivos dentro |
| Ejecución | `x` | 1 | Ejecutar como programa | Entrar con `cd` |

| Categoría | Símbolo | Descripción |
|---|---|---|
| Propietario | `u` (user) | El usuario dueño del archivo |
| Grupo | `g` (group) | El grupo dueño del archivo |
| Otros | `o` (others) | Cualquier otro usuario del sistema |

### Representación y Notación

```bash
ls -l /etc/hosts
# -rw-r--r-- 1 root root 221 Jan 15 12:30 /etc/hosts
# │││││││││
# │││││││└┘ Permisos para "otros" (r--)
# ││││└┘└── Permisos para "grupo" (r--)
# │└┘└───── Permisos para "propietario" (rw-)
# └──────── Tipo: - archivo, d directorio, l symlink, c char device, b block

ls -l archivo   # ver permisos detallados
stat archivo    # información completa incluyendo octal (Access: 0644/...)
```

## Notación octal y simbólica

### Conversión a Notación Octal (Numérica)

Es la forma más rápida de asignar permisos:
- **4** = Lectura (r)
- **2** = Escritura (w)
- **1** = Ejecución (x)

> Ejemplo: `chmod 755` → Propietario (4+2+1=**7**), Grupo (4+0+1=**5**), Otros (4+0+1=**5**)

```bash
# chmod numérico
chmod 755 script.sh         # rwxr-xr-x: propietario todo, grupo/otros leer+ejecutar
chmod 644 archivo.txt       # rw-r--r--: propietario leer+escribir, resto solo leer
chmod 600 clave.pem         # rw-------: solo propietario lee/escribe (clave SSH)
chmod 700 directorio/       # rwx------: directorio privado
chmod 777 /tmp/shared/      # rwxrwxrwx: todos tienen control total (peligroso, evitar)

# chmod simbólico
chmod u+x script.sh         # Añadir ejecución al propietario
chmod g-w archivo           # Quitar escritura al grupo
chmod o=r archivo           # Establecer otros a solo lectura
chmod a+x script.sh         # a = all (todos): añadir ejecución a todos
chmod u+x,g-w archivo       # Múltiples cambios a la vez
chmod +x script.sh          # Añade ejecución a todos

# Aplicar a directorios recursivamente (mejor práctica)
find /var/www/html -type f -exec chmod 644 {} \;    # Solo archivos: 644
find /var/www/html -type d -exec chmod 755 {} \;    # Solo directorios: 755
```

### Cambiar Propietario y Grupo

```bash
# chown — Cambiar propietario (y opcionalmente grupo)
sudo chown usuario archivo          # Cambia solo el dueño
sudo chown usuario:grupo archivo    # Cambia dueño y grupo simultáneamente
sudo chown :grupo archivo           # Cambia solo el grupo
sudo chown -R usuario:grupo carpeta # Cambia todo el contenido de forma recursiva

# chgrp — Cambiar solo el grupo
sudo chgrp grupo archivo
sudo chgrp -R www-data /var/www/html/   # El servidor web Nginx/Apache usa www-data

# Caso real: desplegar aplicación web
sudo chown -R www-data:www-data /var/www/miapp/
sudo chmod -R 755 /var/www/miapp/
sudo chmod 640 /var/www/miapp/.env      # El .env solo lo lee el servidor
```

## Máscaras de permisos (umask)

Define los permisos por defecto de archivos y directorios nuevos. Es una máscara que se **resta** de los permisos máximos.

```bash
umask                   # Ver la umask actual (ej: 0022)
umask 022               # Archivos nuevos: 666-022=644, Directorios: 777-022=755
umask 027               # Más restrictivo: archivos 640, directorios 750

# Máximos sin umask:
# Archivos: 666 (rw-rw-rw-)
# Directorios: 777 (rwxrwxrwx)
# Con umask 022: 666-022=644, 777-022=755

# Para hacer la umask permanente, añadir a ~/.bashrc o /etc/profile
echo "umask 027" >> ~/.bashrc
```

## Permisos Especiales: SUID, SGID y Sticky Bit

### SUID (Set User ID) — Bit 4000

Cuando un ejecutable tiene SUID, se ejecuta con los privilegios del **propietario del archivo**, no del usuario que lo ejecuta.

- **Ejemplo clásico:** `/usr/bin/passwd` tiene SUID de root. Así, cualquier usuario puede cambiar su propia contraseña aunque `/etc/shadow` solo lo puede escribir root.

```bash
ls -la /usr/bin/passwd
# -rwsr-xr-x 1 root root ... /usr/bin/passwd
#     ↑ La 's' en lugar de 'x' indica SUID activo

chmod u+s /ruta/ejecutable      # Activar SUID
chmod 4755 /ruta/ejecutable     # Notación octal: 4 + permisos normales

# Auditoría de seguridad: encontrar todos los archivos con SUID
find / -perm -4000 -type f 2>/dev/null
```

> ⚠️ NUNCA apliques SUID a scripts de shell. El kernel lo ignora precisamente por seguridad.

### SGID (Set Group ID) — Bit 2000

- En **ejecutables:** Funciona como SUID pero con el grupo propietario.
- En **directorios:** ★ Todos los archivos creados dentro heredan el **grupo del directorio**, no el del usuario. Ideal para trabajo colaborativo en equipo.

```bash
ls -la /usr/bin/write
# -rwxr-sr-x  ← La 's' en el campo de grupo indica SGID

# Caso de uso: directorio compartido de equipo
sudo mkdir /proyectos/webapp
sudo chown root:devteam /proyectos/webapp
sudo chmod 2775 /proyectos/webapp   # SGID + rwxrwxr-x
# Ahora todos los archivos creados por cualquier miembro de devteam pertenecerán a devteam

chmod g+s /directorio/          # Activar SGID simbólico
chmod 2755 /directorio/         # Activar SGID octal
find / -perm -2000 -type d 2>/dev/null  # Auditoría de directorios con SGID
```

### Sticky Bit — Bit 1000

En directorios de escritura pública (como `/tmp`), garantiza que **solo el propietario del archivo puede borrarlo**, aunque otros tengan permiso de escritura en el directorio.

```bash
ls -la / | grep tmp
# drwxrwxrwt  ← La 't' al final indica Sticky Bit activo

chmod +t /directorio_compartido/     # Activar Sticky Bit simbólico
chmod 1777 /directorio_compartido/   # Activar Sticky Bit octal

# Caso real: directorio de subida compartida
sudo mkdir /uploads
sudo chmod 1777 /uploads    # Todos pueden subir, nadie puede borrar archivos ajenos
```

### Tabla resumen de bits especiales

| Bit | Valor | En ejecutable | En directorio | En `ls -l` |
|---|---|---|---|---|
| SUID | 4000 | Ejecuta como propietario | (sin efecto) | `s` en `x` del owner |
| SGID | 2000 | Ejecuta como grupo | Archivos heredan el grupo | `s` en `x` del grupo |
| Sticky | 1000 | (obsoleto) | Solo el dueño puede borrar | `t` en `x` de otros |

## Listas de Control de Acceso (ACLs)

El sistema rwx solo permite definir permisos para un usuario y un grupo. Las ACLs permiten permisos granulares para usuarios adicionales sin cambiar el grupo.

```bash
sudo apt install acl                        # Instalar herramientas ACL

# Ver ACLs de un archivo
getfacl archivo.txt
# # file: archivo.txt
# # owner: juan
# # group: devteam
# user::rw-            ← permisos del propietario
# group::r--           ← permisos del grupo
# other::---           ← permisos de otros
# user:carlos:r--      ← ACL específica para el usuario carlos

# Establecer ACLs
setfacl -m u:carlos:r-- archivo.txt         # Usuario carlos puede leer
setfacl -m u:carlos:rwx directorio/         # Carlos tiene control total
setfacl -m g:marketing:r-x reports/         # Grupo marketing puede leer y ejecutar
setfacl -d -m u:carlos:rw directorio/       # -d = ACL por defecto (heredada por nuevos archivos)

# Eliminar ACLs
setfacl -x u:carlos archivo.txt             # Eliminar ACL de carlos
setfacl -b archivo.txt                      # Eliminar TODAS las ACLs

# Nota: cuando hay ACLs, ls -l muestra un '+' al final
# -rw-r--r--+ 1 juan devteam ← el '+' indica ACLs adicionales
```

> **Caso real:** El equipo de marketing necesita leer informes en `/var/reports/` sin ser parte del grupo `finance`:
> ```bash
> sudo setfacl -m g:marketing:r-x /var/reports/
> sudo setfacl -d -m g:marketing:r-x /var/reports/  # Los nuevos archivos también
> ```

## Gestión de Usuarios y Grupos

```bash
# Crear usuarios
sudo useradd -m -s /bin/bash usuario                # Con home y shell bash
sudo useradd -m -s /bin/bash -G sudo usuario        # Y añadido al grupo sudo
sudo adduser usuario                                 # Interfaz interactiva (Debian/Ubuntu)

# Contraseñas
sudo passwd usuario                                  # Cambiar/establecer contraseña
sudo passwd -l usuario                               # Bloquear cuenta (lock)
sudo passwd -u usuario                               # Desbloquear cuenta (unlock)
sudo passwd -e usuario                               # Expirar contraseña (fuerza cambio)
sudo chage -l usuario                                # Ver política de expiración
sudo chage -M 90 usuario                             # Contraseña expira cada 90 días

# Modificar usuarios
sudo usermod -aG docker usuario                     # AÑADIR al grupo (¡-a es vital!)
sudo usermod -s /bin/zsh usuario                    # Cambiar shell
sudo usermod -l nuevo_nombre viejo_nombre           # Renombrar usuario
sudo usermod -L usuario                             # Bloquear cuenta

# ⚠️ PELIGRO: Sin -a, usermod -G reemplaza TODOS los grupos del usuario
# usermod -G docker usuario   ← BORRA todos los grupos anteriores
# usermod -aG docker usuario  ← AÑADE docker, conserva los anteriores

# Eliminar usuarios
sudo userdel usuario                                 # Solo elimina el usuario
sudo userdel -r usuario                              # Elimina usuario Y su home
sudo deluser usuario                                 # Forma alternativa (Debian)

# Grupos
sudo groupadd nombre_grupo                           # Crear grupo
sudo groupadd -g 2000 nombre_grupo                  # Con GID específico
sudo groupdel nombre_grupo                           # Eliminar grupo
sudo groupmod -n nuevo_nombre viejo_nombre           # Renombrar grupo

# Ver membresía
groups usuario                                       # Grupos de un usuario
id usuario                                           # UID, GID y grupos secundarios
getent group docker                                  # Miembros de un grupo
```

**Caso real — Incorporar un nuevo desarrollador:**

```bash
# 1. Crear usuario con home y shell
sudo useradd -m -s /bin/bash -c "Ana García, Dev Backend" ana

# 2. Establecer contraseña temporal y forzar cambio
sudo passwd ana
sudo chage -d 0 ana          # Fuerza cambio en el primer login

# 3. Añadir a grupos necesarios
sudo usermod -aG sudo,docker,devteam ana

# 4. Verificar
id ana
groups ana
```

## El Usuario Root

El usuario root (UID 0) es la cuenta con **privilegios ilimitados** en el sistema.

- **Poder absoluto:** Puede leer, escribir o borrar cualquier archivo, independientemente de los permisos definidos.
- **Riesgo:** Un error como root (`rm -rf /`) puede destruir el sistema operativo instantáneamente.
- **Uso moderno:** En Ubuntu, la cuenta root está "bloqueada" (sin contraseña) para obligar al uso de `sudo`. En RHEL/Rocky, root tiene contraseña pero se recomienda igualmente usar `sudo`.

## Elevación de Privilegios: sudo y su

### sudo — La forma correcta y auditable

```bash
sudo comando                        # Ejecutar un único comando como root
sudo -u otro_usuario comando        # Ejecutar como otro usuario específico
sudo -i                             # Abrir shell interactiva de root (como su -)
sudo !!                             # Repetir el último comando con sudo (muy útil)
sudo -l                             # Ver qué puede hacer el usuario actual con sudo

# Configurar sudo (SIEMPRE usar visudo, nunca editar /etc/sudoers directamente)
sudo visudo

# Ejemplos de reglas en /etc/sudoers:
# ana ALL=(ALL:ALL) ALL                     → Acceso total con contraseña
# ana ALL=(ALL) NOPASSWD: ALL              → Acceso total SIN contraseña (peligroso)
# ana ALL=(ALL) /usr/bin/systemctl         → Ana solo puede usar systemctl
# %devteam ALL=(ALL) /usr/bin/docker       → El grupo devteam puede usar docker
```

### su — Cambiar de usuario

```bash
su usuario                          # Cambiar de usuario (mantiene el entorno actual)
su - usuario                        # ★ Simula un login completo (carga entorno del destino)
su -                                # Entrar como root (necesita contraseña de root)
su - root
```

### sudo vs su

| Característica | `su` | `sudo` |
|---|---|---|
| Contraseña requerida | La del usuario destino (root) | La del usuario actual |
| Auditoría | Difícil de rastrear quién hizo qué | Los comandos se registran en `/var/log/auth.log` |
| Control | Acceso total o nada | Permite restringir comandos específicos en sudoers |

## Gestión de Sesiones

Para verificar quién eres y gestionar la sesión:

```bash
whoami          # Muestra el nombre de usuario actual
id              # Muestra el UID, GID y los grupos del usuario actual
groups          # Lista los grupos a los que perteneces
who             # Ver quién está conectado al sistema ahora mismo
w               # Ver usuarios conectados y qué están haciendo
last            # Historial de logins (quién conectó y cuándo)
lastfail        # Intentos de login fallidos
exit            # Cierra la sesión del usuario actual y vuelve al anterior
```

# 4. Comandos Permisos y Usuarios

| Comando | Función |
|---|---|
| `ls -la` | Ver permisos incluyendo ocultos |
| `chmod 755 archivo` | Permisos rwxr-xr-x |
| `chmod u+s ejecutable` | Activar SUID |
| `chmod g+s directorio` | Activar SGID |
| `chmod +t directorio` | Activar Sticky Bit |
| `chown usuario:grupo archivo` | Cambiar propietario y grupo |
| `getfacl archivo` | Ver ACLs |
| `setfacl -m u:user:rwx archivo` | Establecer ACL para usuario |
| `useradd -m -s /bin/bash user` | Crear usuario con home y bash |
| `usermod -aG grupo user` | Añadir usuario a grupo (sin borrar otros) |
| `chage -M 90 usuario` | Contraseña expira en 90 días |
| `sudo visudo` | Editar configuración sudo de forma segura |
| `sudo -l` | Ver qué puede hacer el usuario con sudo |