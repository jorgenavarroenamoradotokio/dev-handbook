> **Estado:** 🟢 Completo
> **Última actualización:** 2026-08
> **Nivel:** Principiante — se explican los conceptos desde cero

---
- [1. Instalar Redis](#1-instalar-redis)
- [2. Arquitectura](#2-arquitectura)
  - [Qué instala cada método](#qué-instala-cada-método)
  - [Windows: por qué no hay binario nativo](#windows-por-qué-no-hay-binario-nativo)
  - [MAL](#mal)
  - [BIEN](#bien)
- [3. Implementación Paso a Paso (Hands-On)](#3-implementación-paso-a-paso-hands-on)
  - [Linux — Ubuntu / Debian](#linux--ubuntu--debian)
  - [Linux — RHEL / CentOS / Rocky / Alma (dnf)](#linux--rhel--centos--rocky--alma-dnf)
  - [Endurecimiento post-instalación (Linux) — no opcional](#endurecimiento-post-instalación-linux--no-opcional)
  - [macOS (Homebrew)](#macos-homebrew)
  - [Windows (vía WSL2)](#windows-vía-wsl2)
  - [Docker — versión de tutorial vs. versión production-ready](#docker--versión-de-tutorial-vs-versión-production-ready)
  - [Instalar Valkey en lugar de Redis (Linux, vía paquete oficial)](#instalar-valkey-en-lugar-de-redis-linux-vía-paquete-oficial)
- [4. Errores Comunes y Buenas Prácticas](#4-errores-comunes-y-buenas-prácticas)
  
---

## 1. Instalar Redis 

Instalar Redis "para que funcione" tarda dos minutos. Instalar Redis de forma que **sobreviva un reinicio del contenedor sin perder datos, no exponga el puerto 6379 sin autenticación a toda la red, y no consuma memoria hasta hacer caer el host** es un ejercicio distinto, y es el que de verdad importa en producción.

Este módulo cubre ambos niveles: la instalación rápida por sistema operativo (útil para desarrollo local) y la configuración correcta para cualquier entorno que vaya a tocar datos reales.

**Analogía:** instalar Redis con `docker run redis` a secas es como comprar una caja fuerte y dejarla en la acera con la puerta abierta — técnicamente "tienes una caja fuerte". Este módulo es la parte de anclarla al suelo, cerrarla y quedarte con la llave.

También decides aquí **qué binario instalas**: Redis (AGPLv3/SSPL/RSAL, ver Módulo 00) o **Valkey** (fork BSD-3 mantenido por Linux Foundation, compatible en protocolo y comandos hasta el punto del fork). Para la mayoría de proyectos nuevos sin restricciones legales específicas, Redis 8.x es la opción con más funcionalidad reciente (vector sets, Query Engine). Si tu organización tiene una política que prohíbe SSPL/RSAL/AGPL, Valkey es la ruta sin fricción legal.

---

## 2. Arquitectura

### Qué instala cada método

| Método | Qué obtienes | Cuándo usarlo |
|---|---|---|
| Paquete del gestor de paquetes del SO (`apt`, `dnf`) | Binario + servicio `systemd` + `redis.conf` gestionado por el SO | Servidores dedicados, VMs, bare-metal |
| Docker / Docker Compose | Contenedor aislado, sin dependencias del host | Desarrollo local, entornos efímeros, orquestación (Kubernetes) |
| Compilación desde fuente | Control total de flags de compilación (ej. jemalloc vs. libc malloc) | Casos de optimización extrema, contribución al proyecto |
| Servicio gestionado (AWS ElastiCache, Azure Cache for Redis, GCP Memorystore) | Redis/Valkey operado por el proveedor cloud | Producción, cuando no quieres operar el motor tú mismo |

Este módulo cubre las dos primeras en detalle (son las que necesitas dominar como ingeniero, incluso si en producción terminas usando un servicio gestionado). Los servicios gestionados delegan la instalación, pero sigues siendo responsable de las decisiones de la sección 3.3.

### Windows: por qué no hay binario nativo

Redis no publica binarios nativos para Windows desde hace años (el port de Microsoft Open Tech quedó descontinuado). Las opciones reales son:

- **WSL2** (recomendado para desarrollo): ejecutas una distro Linux real dentro de Windows, instalas Redis como en Linux nativo.
- **Docker Desktop** (recomendado si ya usas contenedores): evita la capa de WSL2 manual, Docker Desktop la gestiona internamente.
- **Memurai**: implementación comercial *Redis-compatible* nativa para Windows, pensada para quien necesita un servicio Windows real (no un contenedor) — típico en entornos corporativos con stacks .NET que no quieren WSL en producción.

### MAL

> Instalar una versión de Redis "para Windows" de un repositorio no oficial de GitHub sin mantenimiento desde 2016 (el error más común al buscar "redis windows install").

### BIEN

> WSL2 para desarrollo, Docker para entornos reproducibles, Memurai si el requisito es un servicio Windows nativo en producción.

---

## 3. Implementación Paso a Paso (Hands-On)

### Linux — Ubuntu / Debian

```bash
sudo apt update
sudo apt install redis-server redis-tools -y

# Verificar que el servicio está activo
sudo systemctl status redis-server

# Habilitar arranque automático
sudo systemctl enable redis-server

# Conexión de prueba
redis-cli ping   # debe responder: PONG
```

### Linux — RHEL / CentOS / Rocky / Alma (dnf)

```bash
sudo dnf install epel-release -y
sudo dnf install redis -y

sudo systemctl enable --now redis
sudo systemctl status redis

redis-cli ping
```

> `yum` sigue funcionando como alias de `dnf` en distros recientes, pero `dnf` es el gestor actual — úsalo directamente en vez de la sintaxis legacy.

### Endurecimiento post-instalación (Linux) — no opcional

Recién instalado, Redis en Linux escucha en `127.0.0.1` por defecto y sin contraseña. Antes de exponerlo a cualquier red, edita `/etc/redis/redis.conf`:

```conf
# Autenticación obligatoria — nunca lo dejes vacío en ningún entorno
requirepass "usa-un-valor-desde-tu-gestor-de-secretos-no-lo-escribas-aqui"

# Límite explícito de memoria + política de desalojo (ver Módulo 07)
maxmemory 2gb
maxmemory-policy allkeys-lru

# Enlazar solo a las interfaces necesarias — nunca 0.0.0.0 sin firewall delante
bind 127.0.0.1 -::1

# Deshabilitar comandos peligrosos en producción si no los necesitas
rename-command FLUSHALL ""
rename-command FLUSHDB ""
```

```bash
sudo systemctl restart redis-server
redis-cli -a "tu-password" ping
```

### macOS (Homebrew)

```bash
brew install redis

# Arrancar como servicio en background (persiste entre reinicios de sesión)
brew services start redis

# O en primer plano, solo para la sesión actual
redis-server /opt/homebrew/etc/redis.conf
```

### Windows (vía WSL2)

```powershell
# Desde PowerShell como administrador, si WSL no está instalado
wsl --install
```

Reinicia, abre la distro Linux instalada (Ubuntu por defecto) y sigue los pasos de la **sección 3.1** dentro de esa terminal WSL. A partir de aquí, es Linux — no hay diferencia de comandos.

### Docker — versión de tutorial vs. versión production-ready

**❌ MAL** — lo que encontrarás en la mayoría de tutoriales, y lo que traía la guía original de este repo:

```bash
docker run --name redis -p 6379:6379 -d redis
```

Problemas concretos: sin volumen (pierdes todo al recrear el contenedor), sin contraseña (cualquiera con acceso a la red del host lee y escribe), sin límite de memoria (puede consumir toda la RAM del host y provocar OOM-kill del propio contenedor), sin política de reinicio (si el proceso muere, se queda muerto).

**✅ BIEN** — `docker-compose.yml` con lo mínimo defendible para un entorno que va a persistir datos reales:

```yaml
services:
  redis:
    image: redis:8-alpine
    container_name: redis
    restart: unless-stopped
    command: >
      redis-server
      --requirepass ${REDIS_PASSWORD}
      --maxmemory 2gb
      --maxmemory-policy allkeys-lru
      --appendonly yes
    ports:
      - "127.0.0.1:6379:6379"   # solo localhost del host, no 0.0.0.0
    volumes:
      - redis-data:/data
    healthcheck:
      test: ["CMD", "redis-cli", "-a", "${REDIS_PASSWORD}", "ping"]
      interval: 10s
      timeout: 3s
      retries: 3
    deploy:
      resources:
        limits:
          memory: 2.5g   # margen sobre maxmemory para overhead del proceso

volumes:
  redis-data:
```

```bash
# La contraseña nunca va hardcodeada en el compose ni en el repo
echo "REDIS_PASSWORD=$(openssl rand -base64 32)" > .env

docker compose up -d
docker compose exec redis redis-cli -a "$REDIS_PASSWORD" ping
```

Diferencias clave frente al ejemplo de tutorial: `--requirepass` vía variable de entorno (nunca en texto plano en el repo), `--maxmemory` con política de desalojo explícita, `--appendonly yes` para persistencia (Módulo 03), volumen nombrado, `restart: unless-stopped`, puerto publicado solo a `127.0.0.1` (si otro servicio del mismo host necesita conectarse, comparte la red de Docker en vez de publicar el puerto al host).

### Instalar Valkey en lugar de Redis (Linux, vía paquete oficial)

```bash
sudo apt install curl gpg -y
curl -fsSL https://download.valkey.io/valkey-keyring.gpg | sudo tee /usr/share/keyrings/valkey-archive-keyring.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/valkey-archive-keyring.gpg] https://download.valkey.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/valkey.list

sudo apt update
sudo apt install valkey -y

valkey-cli ping   # PONG — misma CLI, mismo protocolo
```

> Verifica siempre la URL y la clave GPG oficial en `valkey.io` antes de ejecutar esto — el repositorio exacto puede cambiar; no copies claves de terceros no verificados.

---

## 4. Errores Comunes y Buenas Prácticas

- ❌ **Publicar el puerto 6379 a `0.0.0.0` "porque es más fácil para conectarme desde fuera".** Redis no fue diseñado para estar expuesto directamente a Internet ni siquiera con contraseña (el protocolo RESP no tiene protecciones contra fuerza bruta a nivel de aplicación por defecto). Usa redes privadas/VPC, `bind` restrictivo, y si necesitas acceso externo, un túnel SSH o un proxy con TLS delante.

- ❌ **Dejar la contraseña de Redis en el `docker-compose.yml` versionado en Git.** Usa `.env` (con `.gitignore`), Docker secrets, o un gestor de secretos (Vault, AWS Secrets Manager, etc.) según el entorno.

- ❌ **No fijar `maxmemory`.** Sin límite explícito, Redis intentará usar toda la memoria disponible del sistema. En un contenedor con límites de cgroup, esto termina en `OOM killed` sin previo aviso legible; en un host compartido, se lleva por delante a otros procesos.

- ✅ **Fija siempre `maxmemory` por debajo del límite real de memoria del contenedor/VM**, dejando margen para el overhead del propio proceso Redis (conexiones, buffers de replicación, fragmentación) — como regla de partida, 15-20% de margen.

- ✅ **Verifica la versión instalada inmediatamente después de instalar**, no asumas:
```bash
redis-cli info server | grep redis_version
```

- ✅ **Decide Redis vs. Valkey antes de escribir una sola línea de infraestructura como código**, no después. Migrar de uno a otro más adelante es sencillo a nivel de comandos (son compatibles), pero revisar contratos de soporte, imágenes base en tus pipelines de CI/CD, y políticas de licencia ya desplegadas, no lo es.