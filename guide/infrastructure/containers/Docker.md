> **Estado:** 🟢 Completo
> **Última actualización:** 2026-06
> **Nivel:** Principiante — se explican los conceptos desde cero

---

- [1. Introducción](#1-introducción)
  - [Conceptos Clave](#conceptos-clave)
  - [Docker y DevOps](#docker-y-devops)
  - [Docker y CI/CD](#docker-y-cicd)
- [2. Instalación de Docker](#2-instalación-de-docker)
  - [Windows](#windows)
  - [macOS](#macos)
  - [Linux (Ubuntu/Debian)](#linux-ubuntudebian)
- [3. Arquitectura de Docker](#3-arquitectura-de-docker)
  - [Docker Client](#docker-client)
  - [Docker Daemon (dockerd)](#docker-daemon-dockerd)
  - [Docker Objects (Objetos)](#docker-objects-objetos)
  - [Docker Registry](#docker-registry)
  - [Arquitectura interna (Linux)](#arquitectura-interna-linux)
  - [Docker vs Máquinas Virtuales](#docker-vs-máquinas-virtuales)
  - [Docker y Orquestación](#docker-y-orquestación)
  - [EXPOSE vs ports](#expose-vs-ports)
- [4. Imagen](#4-imagen)
  - [Características](#características)
  - [Imagen vs. Contenedor](#imagen-vs-contenedor)
  - [Comandos](#comandos)
  - [Cómo se crea una imagen](#cómo-se-crea-una-imagen)
    - [Desde un Dockerfile](#desde-un-dockerfile)
    - [CMD vs ENTRYPOINT (y cómo combinarlos)](#cmd-vs-entrypoint-y-cómo-combinarlos)
    - [Multi-stage build](#multi-stage-build)
    - [A partir de un contenedor existente](#a-partir-de-un-contenedor-existente)
  - [Errores Comunes en Imágenes](#errores-comunes-en-imágenes)
- [5. Contenedores](#5-contenedores)
  - [Características](#características-1)
  - [Ciclo de vida de un contenedor](#ciclo-de-vida-de-un-contenedor)
  - [Comandos](#comandos-1)
  - [Variables de `docker run`](#variables-de-docker-run)
  - [Seguridad en Contenedores](#seguridad-en-contenedores)
    - [No ejecutar como root](#no-ejecutar-como-root)
    - [Limitar capacidades del kernel (`--cap-drop`)](#limitar-capacidades-del-kernel---cap-drop)
    - [Filesystem de solo lectura](#filesystem-de-solo-lectura)
    - [Escaneo de vulnerabilidades en imágenes](#escaneo-de-vulnerabilidades-en-imágenes)
    - [Gestión de secretos](#gestión-de-secretos)
- [6. Volumen](#6-volumen)
  - [Contenedor vs Volumen](#contenedor-vs-volumen)
  - [Tipos de almacenamiento](#tipos-de-almacenamiento)
  - [Comandos](#comandos-2)
  - [Errores Comunes en Volúmenes](#errores-comunes-en-volúmenes)
- [7. Network](#7-network)
  - [Tipos de redes](#tipos-de-redes)
  - [Comandos](#comandos-3)
  - [Troubleshooting de Red](#troubleshooting-de-red)
- [8. Registry](#8-registry)
  - [Tipos de Registry](#tipos-de-registry)
  - [Comandos](#comandos-4)
- [9. Docker Compose](#9-docker-compose)
  - [Instalación](#instalación)
    - [Windows](#windows-1)
    - [macOS](#macos-1)
    - [Linux](#linux)
  - [Docker Compose moderno vs legacy](#docker-compose-moderno-vs-legacy)
  - [Diferencias entre Docker CLI y Docker Compose](#diferencias-entre-docker-cli-y-docker-compose)
  - [Estructura de un `docker-compose.yml`](#estructura-de-un-docker-composeyml)
  - [`.env` y variables de entorno](#env-y-variables-de-entorno)
  - [`depends_on` y `healthcheck`](#depends_on-y-healthcheck)
  - [Seguridad y Límites de Recursos en Compose](#seguridad-y-límites-de-recursos-en-compose)
  - [Comandos](#comandos-5)
  - [Errores Comunes en Docker Compose](#errores-comunes-en-docker-compose)
- [10. Límites de Recursos y Resiliencia (docker run)](#10-límites-de-recursos-y-resiliencia-docker-run)
  - [Limitar CPU y memoria](#limitar-cpu-y-memoria)
  - [Políticas de reinicio](#políticas-de-reinicio)
  - [Healthcheck en runtime (sin Dockerfile)](#healthcheck-en-runtime-sin-dockerfile)
- [11. Troubleshooting General de Docker](#11-troubleshooting-general-de-docker)
  - [Gestión de espacio en disco](#gestión-de-espacio-en-disco)
- [12. Archivos clave](#12-archivos-clave)
  - [`.dockerignore`](#dockerignore)
- [Resumen ejecutivo de buenas prácticas (checklist final)](#resumen-ejecutivo-de-buenas-prácticas-checklist-final)

---

# 1. Introducción

**Docker es una plataforma de virtualización ligera basada en contenedores** que permite empaquetar una aplicación junto con todo lo que necesita para ejecutarse (código, dependencias, librerías, runtime) en una unidad estándar llamada **contenedor**, garantizando que funcione igual en tu laptop, en el servidor de staging y en producción.

**¿Por qué importa esto en el mundo real?** El problema que Docker resuelve no es nuevo: *"en mi máquina funciona"*. Antes de los contenedores, una app podía fallar en producción por tener una versión distinta de una librería, una variable de entorno mal configurada o un sistema operativo diferente. Docker elimina esa variable al empaquetar el entorno completo junto con el código.

> **Analogía:** Piensa en un contenedor de carga marítimo. No importa si el barco es japonés, el puerto es de Países Bajos o el camión que lo recoge es alemán — el contenedor estándar se mueve igual en cualquier infraestructura. Docker hace lo mismo con el software: empaqueta tu app en una "caja estándar" que corre igual en cualquier servidor con Docker instalado.

Un contenedor incluye:
- **Código** de la aplicación
- **Dependencias** (librerías de terceros)
- **Runtime** (el intérprete o motor: Node.js, JVM, Python, etc.)
- **Variables de entorno**
- **Configuración del sistema** mínima necesaria

> **Nota técnica:** Docker no virtualiza hardware como una VM. Comparte el **kernel** del sistema operativo host. Esto es precisamente lo que lo hace más rápido y ligero — y también su principal diferencia arquitectónica frente a una máquina virtual (lo veremos en detalle en la sección 3.6).

## Conceptos Clave

| Concepto | Descripción |
|----------|-------------|
| **Imagen** | Plantilla inmutable de solo lectura con el "molde" de la aplicación |
| **Contenedor** | Una imagen en ejecución; instancia viva y aislada |
| **Dockerfile** | Receta en texto que define cómo se construye una imagen |
| **Volumen** | Mecanismo de persistencia de datos, independiente del ciclo de vida del contenedor |
| **Network** | Capa de comunicación entre contenedores y con el exterior |
| **Registry** | Repositorio remoto o local donde se almacenan y distribuyen imágenes |

## Docker y DevOps

Docker no es solo una herramienta de desarrollo: es un habilitador de cultura DevOps porque:

- **Entornos reproducibles:** Dev, QA y Producción ejecutan exactamente la misma imagen — se elimina la deriva de configuración ("configuration drift").
- **Automatización:** Una imagen se puede construir, testear y desplegar sin intervención manual.
- **Escalabilidad:** Levantar una réplica más de un servicio es tan simple como ejecutar el mismo contenedor N veces.
- **Menos fricción entre equipos:** Desarrollo entrega una imagen, no un manual de instalación de 15 pasos.

## Docker y CI/CD

Docker se integra de forma nativa en pipelines de CI/CD. La imagen se convierte en el **artefacto de entrega** (el "build" versionado) que viaja desde el commit hasta producción sin modificarse.

Flujo típico:
```text
Commit → Build imagen → Test (dentro del contenedor) → Push a Registry → Deploy
```

> **Punto crítico de producción:** La imagen que pasa los tests debe ser **exactamente la misma** que se despliega (mismo `tag`, mismo `SHA256` de capas). Si reconstruyes la imagen entre el test y el deploy, pierdes la garantía de reproducibilidad — es uno de los errores de pipeline más comunes y más difíciles de detectar.

# 2. Instalación de Docker

## Windows

**Requisitos previos:**
- Windows 10/11 (64-bit)
- Virtualización habilitada en BIOS/UEFI
- WSL2 habilitado (recomendado y obligatorio en Windows Home)

**Pasos:**
1. Descarga Docker Desktop: https://www.docker.com/products/docker-desktop
2. Ejecuta el instalador y marca la opción **"Use WSL 2 instead of Hyper-V"**.
3. Reinicia el sistema si se solicita.
4. Verifica la instalación:

```bash
docker -v
docker info
```

> **Nota:** En Windows Home, WSL2 es obligatorio (no hay opción Hyper-V). En Windows Pro/Enterprise puedes elegir, pero WSL2 ofrece mejor rendimiento de I/O en disco para proyectos con bind mounts.

## macOS

**Requisitos previos:**
- macOS 11 o superior
- Procesador Intel o Apple Silicon (M1/M2/M3)

**Pasos:**
1. Descarga Docker Desktop: https://www.docker.com/products/docker-desktop
2. Instala el `.dmg` y mueve Docker a `Applications`.
3. Inicia Docker Desktop.
4. Verifica la instalación:

```bash
docker -v
docker info
```

> **Nota para Apple Silicon:** Si trabajas con imágenes que solo existen para `linux/amd64` (x86), necesitarás emulación vía `--platform linux/amd64` o reconstruir la imagen para `arm64`. Esto puede impactar el rendimiento — no es un detalle menor en equipos M1/M2/M3.

## Linux (Ubuntu/Debian)

```bash
# 1. Actualizar el sistema
sudo apt update
sudo apt upgrade -y

# 2. Instalar dependencias necesarias para añadir repositorios HTTPS
sudo apt install -y ca-certificates curl gnupg lsb-release

# 3. Agregar la clave GPG oficial de Docker
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# 4. Agregar el repositorio oficial de Docker
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list

# 5. Instalar Docker Engine + plugin de Compose
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 6. Habilitar Docker al inicio del sistema
sudo systemctl enable docker
sudo systemctl start docker

# 7. Ejecutar Docker sin sudo (recomendado para desarrollo)
sudo usermod -aG docker $USER
newgrp docker

# 8. Verificar instalación
docker -v
docker run hello-world
```

> **🚨 Advertencia de seguridad:** Añadir tu usuario al grupo `docker` (paso 7) es equivalente a darle privilegios de **root** sobre el host. El daemon de Docker corre como root, y cualquier usuario en el grupo `docker` puede montar el filesystem completo del host dentro de un contenedor (`docker run -v /:/host alpine`). En servidores compartidos o de producción, evalúa usar **rootless mode** (`dockerd-rootless`) en lugar de este paso.

# 3. Arquitectura de Docker

La arquitectura de Docker sigue un **modelo cliente-servidor**: tú (o tu script de CI) hablas con un **cliente**, el cliente le pide cosas a un **daemon**, y el daemon es quien realmente crea y gestiona los **objetos** (imágenes, contenedores, redes, volúmenes), pudiendo traer o enviar imágenes a un **Registry**.

```text
Cliente (CLI) → API REST → Daemon (dockerd) → Objetos (imágenes/contenedores/redes/volúmenes)
                                    ↕
                                Registry
```

> **Analogía:** El **Client** es como el mostrador de un restaurante donde pides tu comanda. El **Daemon** es la cocina: recibe el pedido y realmente cocina (crea contenedores, gestiona recursos). El **Registry** es el proveedor de ingredientes al que la cocina recurre cuando no tiene algo en stock (`docker pull`).

## Docker Client

Es la herramienta de línea de comandos (CLI) con la que interactúas directamente. Cuando escribes `docker run`, el cliente traduce ese comando en una petición a la **API REST** del daemon. Un cliente puede comunicarse con un daemon local o con uno remoto (útil para gestionar Docker en un servidor desde tu laptop).

```bash
docker build
docker pull
docker run
docker ps
```

## Docker Daemon (dockerd)

Es el proceso en segundo plano (background) que realmente hace el trabajo pesado.

- **Función:** Escucha peticiones de la API de Docker y gestiona el ciclo de vida completo de imágenes, contenedores, redes y volúmenes.
- **Comunicación:** Puede comunicarse con otros daemons para gestionar servicios de forma distribuida (relevante en Swarm/orquestación).

> **Punto clave para entrevistas técnicas:** El daemon corre con privilegios elevados. Si comprometen el socket de Docker (`/var/run/docker.sock`), comprometen el host completo — no solo un contenedor.

## Docker Objects (Objetos)

Son los elementos que creas y gestionas día a día:

- **Imágenes:** Plantillas de solo lectura con las instrucciones para crear un contenedor. Suelen basarse en otra imagen (ej. una imagen de Python parte de una base Debian/Alpine). Se construyen por **capas (layers)**:

```text
Base OS
 └── Runtime (Java, Python, Node)
      └── Dependencias
           └── Aplicación
```

- **Contenedores:** Instancias ejecutables de una imagen. Son procesos aislados que corren sobre el kernel del host, no máquinas independientes.
- **Volúmenes:** Permiten que los datos persistan aunque el contenedor se elimine. Críticos para bases de datos y archivos compartidos.
- **Redes (Networks):** Permiten la comunicación entre contenedores y con el exterior.
  - `bridge` (por defecto)
  - `host`
  - `none`
  - `overlay` (Swarm/clusters)

## Docker Registry

Es el repositorio donde se almacenan y distribuyen las imágenes.

- **Docker Hub:** Registro público por defecto donde cualquiera puede publicar imágenes.
- **Flujo:** `docker pull` descarga una imagen del registro hacia tu daemon local. `docker push` sube tu imagen al registro.

> Profundizamos en tipos de registry (público, privado, local) en la sección de Registry más adelante en esta guía.

## Arquitectura interna (Linux)

Docker no inventa virtualización nueva: se apoya en funcionalidades que ya existen en el kernel de Linux desde hace años.

| Mecanismo | Qué hace | Analogía |
|-----------|----------|----------|
| **Namespaces** (`PID`, `NET`, `MNT`, `IPC`, `UTS`, `USER`) | Aíslan lo que un proceso puede *ver*: sus propios PIDs, su propia red, su propio filesystem | Es como ponerle a cada inquilino de un edificio una llave que solo abre su apartamento — viven en el mismo edificio (kernel) pero no se ven entre sí |
| **cgroups** (control groups) | Limitan lo que un proceso puede *consumir*: CPU, RAM, I/O | Es el medidor de luz y agua de cada apartamento: pones un límite de consumo aunque comparten la misma red eléctrica del edificio |
| **Union File Systems** (OverlayFS) | Permiten apilar capas de solo lectura + una capa de escritura encima | Como hojas de papel transparente apiladas: cada capa añade algo, pero solo la última (de arriba) se puede escribir |

> **Por qué importa:** Esto explica por qué Docker en Linux es nativo y eficiente, mientras que en Windows/macOS necesita una VM ligera (la que gestiona Docker Desktop) para tener un kernel Linux disponible.

## Docker vs Máquinas Virtuales

| Característica | Docker (Contenedores) | Máquinas Virtuales |
|---|---|---|
| Kernel | Comparte el del host | Kernel propio por VM |
| Peso | Ligero (MBs) | Pesado (GBs) |
| Arranque | Segundos (o menos) | Minutos |
| Aislamiento | A nivel de proceso (namespaces/cgroups) | A nivel de hardware virtualizado (hypervisor) |
| Caso de uso ideal | Microservicios, apps cloud-native | SO completos, cargas que requieren aislamiento total de kernel |

> **Matiz importante para nivel senior:** El aislamiento de Docker es **más débil** que el de una VM, porque comparten kernel. Una vulnerabilidad de "container escape" (fuga del contenedor) compromete el host directamente. Una VM, al tener su propio kernel, añade una capa extra de aislamiento. Esto es relevante en entornos multi-tenant: por eso existen soluciones híbridas como **Kata Containers** o **gVisor**, que dan aislamiento tipo VM con la velocidad de un contenedor.

## Docker y Orquestación

Cuando pasas de "un contenedor en mi laptop" a "cientos de contenedores en producción, en varios servidores", necesitas un **orquestador**:

- **Docker Swarm** (nativo de Docker, más simple, menos adoptado en la industria)
- **Kubernetes** (el estándar de facto de la industria; más complejo, pero con un ecosistema mucho mayor)

> No profundizamos en orquestación en esta guía — es un tema independiente que merece su propia guía dedicada.

## EXPOSE vs ports

| `EXPOSE` (Dockerfile) | `-p` / `ports` (runtime) |
|---|---|
| Documenta qué puerto usa la app | Publica realmente el puerto hacia el host |
| Vive en la **imagen** | Se aplica en **runtime** (`docker run` o Compose) |
| No abre nada por sí solo | Sin esto, el puerto no es accesible desde fuera del contenedor |

> **Error común:** Pensar que `EXPOSE 3000` en el Dockerfile hace que tu app sea accesible desde el host. **No es así.** `EXPOSE` es metadata informativa (útil para otras herramientas y para quien lea el Dockerfile). El puerto solo se publica realmente con `-p host:contenedor` en `docker run`, o con `ports:` en Compose.

# 4. Imagen

**Una imagen Docker es una plantilla inmutable de solo lectura** que contiene todo lo necesario para ejecutar una aplicación: sistema base, runtime, dependencias, código, y las instrucciones de cómo arrancarla.

> **Analogía:** La imagen es la **receta de cocina**. El contenedor es **el plato ya cocinado**. Puedes cocinar el mismo plato (contenedor) cien veces a partir de la misma receta (imagen), y cada plato es independiente — si uno se quema, no afecta a la receta original.

Incluye:
- Sistema de archivos base ligero (ej. Alpine, Debian slim, Ubuntu)
- Runtime (Java, Python, Node, etc.)
- Librerías y dependencias
- Código de la aplicación
- Instrucciones de ejecución (`CMD` / `ENTRYPOINT`)

> Una imagen **no se ejecuta**: sirve como plantilla para crear contenedores. Un contenedor es una **instancia en ejecución** de una imagen.

## Características

- **Inmutable:** una vez creada, no se modifica. Si necesitas un cambio, construyes una nueva imagen (con un nuevo `tag`).
- **Basada en capas (layers):** Docker reutiliza capas no modificadas para ahorrar espacio en disco y acelerar tanto descargas como builds.

```text
Capa 1: Sistema base (Ubuntu)
Capa 2: Runtime (Python)
Capa 3: Dependencias
Capa 4: Código de la aplicación
```

> **Por qué importa en producción:** Si cambias solo tu código (capa 4) pero no tus dependencias (capa 3), Docker reutiliza las capas 1-3 desde caché. Esto es la base de builds rápidos en CI/CD — y la razón por la que el **orden de instrucciones en tu Dockerfile** afecta directamente la velocidad de tu pipeline (ver sección 4.4.1).

## Imagen vs. Contenedor

| Característica | Imagen | Contenedor |
|---|---|---|
| Estado | Estática (archivo en disco) | Viva (proceso en ejecución) |
| Mutabilidad | Inmutable | Mutable (capa de escritura propia) |
| Analogía | La receta de cocina | El plato ya cocinado |

## Comandos

```bash
# Ver imágenes locales (repository, tag, image id, size)
docker images
docker image ls

# Descargar una imagen
docker pull nginx
docker pull nginx:1.25

# Construir una imagen desde un Dockerfile en el directorio actual
docker build -t miapp:1.0 .
docker build --no-cache -t miapp:1.0 .   # ignora caché, fuerza rebuild completo

# Etiquetar una imagen (tag)
docker tag miapp:1.0 miusuario/miapp:1.0

# Eliminar una imagen
docker rmi miapp:1.0
docker rmi 3f2c1a
docker rmi -f miapp:1.0          # fuerza eliminación aunque haya contenedores parados usándola
docker image prune               # elimina imágenes "dangling" (sin tag, huérfanas)
docker image prune -a            # elimina TODAS las imágenes no usadas por ningún contenedor

# Inspeccionar una imagen: capas, env vars, CMD/ENTRYPOINT, arquitectura
docker inspect nginx

# Historial de capas: tamaño e instrucciones del Dockerfile que la generaron
docker history nginx

# Ejecutar una imagen (la descarga si no existe localmente, crea el contenedor y arranca el proceso)
docker run nginx
```

> **Cuidado con `docker image prune -a`:** elimina cualquier imagen no usada activamente, incluidas las que descargaste para usar "más tarde". En CI/CD compártelo con el equipo antes de automatizarlo en un cron — puede borrar imágenes base que otro pipeline necesita en caché.

## Cómo se crea una imagen

### Desde un Dockerfile

Un **Dockerfile** es un archivo de texto plano (sin extensión, literalmente se llama `Dockerfile`) con una serie de instrucciones que Docker ejecuta en orden para construir una imagen.

**El contexto de construcción (Build Context):**
Cuando ejecutas `docker build .`, Docker envía **todos los archivos de esa carpeta** al daemon antes de empezar a construir. Si tienes carpetas pesadas que no necesitas dentro de la imagen (`node_modules`, `.git`), debes excluirlas con un `.dockerignore` — si no, tu build será más lento y tu imagen innecesariamente pesada.

**El orden importa (caché de capas):**
Docker es inteligente: si no cambiaste `package.json`, Docker reutiliza la capa cacheada de `RUN npm install` en lugar de reinstalar todo. Por eso la convención es **copiar primero los archivos de dependencias, instalar, y copiar el código después.**

**Inmutabilidad:**
Una vez que el build termina, la imagen resultante no cambia. Si modificas una línea de código, debes volver a ejecutar `docker build` para generar una **nueva** imagen (idealmente con un nuevo tag).

**Para qué sirve:**
- Crear imágenes reproducibles
- Automatizar instalaciones
- Versionar infraestructura como código
- Eliminar configuraciones manuales ("works on my machine")
- Garantizar comportamiento idéntico en cualquier entorno

**Funcionamiento interno:**
1. Docker lee el Dockerfile línea por línea.
2. Ejecuta cada instrucción en orden.
3. Cada instrucción genera una **capa nueva**.
4. Si una capa no cambió respecto al build anterior, se reutiliza desde caché.
5. Al final, todas las capas se ensamblan en la imagen final.

> **Nota crítica:** Si una instrucción cambia, **todas las capas siguientes se invalidan y se reconstruyen**, aunque no hayan cambiado. Por eso el orden de las instrucciones no es estético: es una decisión de rendimiento.

**Estructura básica de un Dockerfile (comentado):**

```dockerfile
# 1. Imagen base oficial de Node.js, versión 18 (fijar versión exacta evita sorpresas)
FROM node:18

# 2. Crea (si no existe) y establece el directorio de trabajo dentro del contenedor
WORKDIR /usr/src/app

# 3. Copiamos SOLO los archivos de dependencias primero
#    Así, si el código cambia pero las dependencias no, Docker reutiliza la capa de "npm install" desde caché
COPY package*.json ./

# 4. Instalamos las dependencias (esta capa se cachea mientras package*.json no cambie)
RUN npm install

# 5. Copiamos el resto del código de la aplicación
COPY . .

# 6. Documentamos que la app escucha en el puerto 3000 (no lo publica, ver sección 3.8)
EXPOSE 3000

# 7. Comando que arranca la app cuando el contenedor inicia
CMD ["node", "app.js"]
```

> Cada instrucción crea una capa nueva en la imagen final.

**Referencia rápida de instrucciones:**

| Instrucción | Qué hace | Detalle clave |
|---|---|---|
| `FROM` | Define la imagen base | Obligatoria (salvo `FROM scratch`). Puede repetirse en multi-stage builds. |
| `WORKDIR` | Define el directorio de trabajo | Evita usar `cd`. Se crea automáticamente si no existe. |
| `COPY` | Copia archivos del host a la imagen | Solo puede copiar desde el build context. |
| `ADD` | Similar a `COPY`, pero además descomprime archivos y puede descargar URLs | **Menos recomendado**: su "magia" es impredecible. Usa `COPY` salvo que necesites explícitamente esas funciones. |
| `RUN` | Ejecuta comandos durante el build | Crea una capa nueva. Ideal para instalar dependencias del sistema. |
| `CMD` | Comando por defecto al iniciar el contenedor | Sobrescribible desde `docker run` (ver 4.4.2). |
| `ENTRYPOINT` | Comando fijo de ejecución | No se sobrescribe con un argumento simple; ideal para imágenes "ejecutable". |
| `EXPOSE` | Documenta el puerto usado | No publica el puerto (ver 3.8). |
| `ENV` | Define variables de entorno | Disponibles en build y en runtime. |
| `ARG` | Variables solo disponibles durante el build | No persisten en la imagen final ni en el contenedor. |
| `VOLUME` | Declara un punto de montaje | No crea un volumen con nombre en el host; Docker crea uno anónimo si no se especifica otro en runtime. |
| `USER` | Cambia el usuario de ejecución | **Crítico en seguridad** — evita ejecutar como root (ver 4.5). |
| `HEALTHCHECK` | Define cómo verificar si el contenedor está sano | Docker marca el contenedor como `healthy` / `unhealthy` (ver ejemplo abajo). |

**Ejemplo de `HEALTHCHECK` (lo que el documento original solo mencionaba sin código):**

```dockerfile
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1
```
- `--interval`: cada cuánto se ejecuta el chequeo.
- `--timeout`: tiempo máximo de espera antes de considerar el chequeo fallido.
- `--start-period`: periodo de gracia inicial (útil si tu app tarda en arrancar).
- `--retries`: fallos consecutivos antes de marcar `unhealthy`.

### CMD vs ENTRYPOINT (y cómo combinarlos)

| | `CMD` | `ENTRYPOINT` |
|---|---|---|
| Rol | Comando/argumentos **por defecto** | Comando **principal**, fijo |
| Sobrescritura | Se sobrescribe fácilmente (`docker run imagen otro-comando`) | No se sobrescribe con un argumento simple (requiere `--entrypoint`) |
| Caso de uso típico | Apps donde el usuario podría querer cambiar el comportamiento | Imágenes pensadas como "binarios ejecutables" |

> **Lo que casi ninguna guía explica bien — el patrón combinado:** en producción, lo más habitual no es elegir uno u otro, sino **combinarlos**. `ENTRYPOINT` fija el binario, `CMD` provee los argumentos por defecto que el usuario puede sobrescribir:

```dockerfile
ENTRYPOINT ["node", "app.js"]
CMD ["--port=3000"]
```

Con esto:
```bash
docker run miapp                  # ejecuta: node app.js --port=3000
docker run miapp --port=8080      # ejecuta: node app.js --port=8080 (CMD se sobrescribe, ENTRYPOINT no)
```

### Multi-stage build

**Qué es y por qué importa:** un multi-stage build usa **varios `FROM`** en el mismo Dockerfile para separar la fase de *compilación* de la fase de *ejecución*. El resultado final solo contiene lo que la app necesita para correr — no el compilador, no las herramientas de build, no el código fuente intermedio.

> **Analogía:** Es como construir un mueble en un taller lleno de herramientas, sierras y restos de madera, y luego entregar **solo el mueble terminado** al cliente — no le envías el taller entero.

**Ejemplo real con Node.js (build de TypeScript → imagen final mínima):**

```dockerfile
# ---- Etapa 1: build ----
# Esta etapa tiene TODO lo necesario para compilar, pero no viajará a producción
FROM node:18 AS builder

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build      # genera /app/dist (TypeScript compilado a JS)

# ---- Etapa 2: producción ----
# Partimos de una imagen base mucho más ligera (alpine)
FROM node:18-alpine AS production

WORKDIR /app

# Copiamos SOLO lo necesario desde la etapa "builder", no el código fuente ni node_modules de dev
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./

# Instalamos solo dependencias de producción (sin devDependencies)
RUN npm install --omit=dev

USER node
EXPOSE 3000
CMD ["node", "dist/app.js"]
```

**Beneficio medible:** una imagen que con un único `FROM node:18` podría pesar 1.2 GB (con todo el toolchain de build incluido) puede bajar a 150-200 MB usando este patrón con `node:18-alpine` en la etapa final. Menos peso significa: despliegues más rápidos, menos superficie de ataque, menos costo de almacenamiento en el registry.

### A partir de un contenedor existente

```bash
docker commit contenedor imagen_nueva
```

> **No recomendado en producción.** Esta imagen no es reproducible: nadie puede saber qué pasos exactos la generaron, a diferencia de un Dockerfile versionado en Git. Útil únicamente para debugging puntual o capturar un estado exploratorio.

## Errores Comunes en Imágenes

| Problema | Causa típica | Solución |
|---|---|---|
| La imagen pesa varios GB sin razón aparente | No usar multi-stage, copiar `node_modules`/`.git`, no usar `.dockerignore` | Aplicar multi-stage build (4.4.3) + `.dockerignore` completo |
| Cada cambio de código reconstruye TODO desde cero | `COPY . .` antes de instalar dependencias | Copiar primero los manifiestos de dependencias (`package.json`, `requirements.txt`, `pom.xml`), instalar, y copiar el código después |
| El contenedor corre como `root` | No se especifica `USER` en el Dockerfile | Añadir `USER node` (o un usuario no privilegiado) antes del `CMD`/`ENTRYPOINT` |
| `docker build` falla con "no space left on device" | Acumulación de capas e imágenes intermedias sin limpiar | `docker system df` para ver consumo, `docker system prune -a` para limpiar (ver sección global de Troubleshooting) |
| La imagen funciona en tu Mac M1 pero falla en el servidor | Diferencia de arquitectura (`arm64` vs `amd64`) | Construir con `docker buildx build --platform linux/amd64,linux/arm64` para multi-arquitectura |
| Secretos (API keys, contraseñas) quedan visibles con `docker history` | Se pasan como `ARG` o se hace `RUN echo $SECRET > file` | Usar `RUN --mount=type=secret` (BuildKit) o gestionarlos en runtime, nunca en build time |

> **🔒 Nota de seguridad ampliada:** Ejecutar contenedores como `root` (el comportamiento por defecto si no defines `USER`) significa que si un atacante logra ejecutar código dentro del contenedor, tiene privilegios de root *dentro* de ese namespace — y un "container escape" exitoso le daría root en el host. Definir un usuario no privilegiado con `USER` es una de las medidas de seguridad más baratas y más frecuentemente ignoradas.

# 5. Contenedores

**Un contenedor Docker es una instancia en ejecución de una imagen.** Es un proceso aislado en tu sistema operativo que se comporta como una máquina independiente, pero comparte el núcleo (kernel) del host.

> **Analogía:** Si la imagen es la receta, el contenedor es el plato servido y caliente en la mesa — puedes "ensuciarlo" (modificar archivos dentro), pero eso no afecta a la receta original. Y si tiras el plato a la basura (`docker rm`), la receta sigue intacta para cocinar otro igual.

**Sus 3 pilares:**

- **Aislamiento:** lo que pasa dentro del contenedor no afecta al host ni a otros contenedores (vía namespaces, ver 3.5).
- **Eficiencia:** arranca en segundos porque no inicia un sistema operativo completo, solo un proceso sobre un kernel que ya está corriendo.
- **Volatilidad:** por defecto, si borras el contenedor, los datos creados dentro desaparecen — a menos que uses volúmenes (sección 6).

> **Nota:** Imagen = plantilla (estática, no se ejecuta). Contenedor = imagen + ejecución + estado.

Un contenedor:
- Ejecuta uno o más procesos.
- Está aislado del sistema host (a nivel de proceso, no de kernel).
- Comparte el kernel del sistema operativo.
- Es ligero y rápido de crear/destruir.
- Tiene un ciclo de vida explícito: se crea, se inicia, se detiene, se elimina.

## Características

- **Aislamiento** vía namespaces:
  - `PID` (procesos — el contenedor solo ve sus propios procesos, no los del host)
  - `NET` (red — su propia interfaz, IP y tabla de rutas)
  - `MNT` (filesystem — su propio árbol de montajes)
  - `IPC`, `UTS`, `USER`
- **Control de recursos** vía cgroups:
  - CPU
  - Memoria
  - I/O de disco y red
- **Sistema de archivos**:
  - Capas de solo lectura (heredadas de la imagen)
  - Una capa de escritura propia del contenedor (efímera)

> **Nota:** los cambios hechos dentro del contenedor (archivos creados, logs, datos de una app) se pierden al eliminarlo, salvo que estén en un volumen o bind mount.

## Ciclo de vida de un contenedor

```text
docker create → docker start → running → docker stop → docker rm
```

| Estado | Comando que lo provoca | Qué significa |
|---|---|---|
| Created | `docker create` | El contenedor existe pero no ha arrancado el proceso principal |
| Running | `docker start` / `docker run` | El proceso principal está activo |
| Paused | `docker pause` | Procesos congelados (vía cgroups freezer), pero memoria intacta |
| Stopped (Exited) | `docker stop` | El proceso principal terminó; el contenedor sigue existiendo en disco |
| Removed | `docker rm` | El contenedor y su capa de escritura desaparecen definitivamente |

> **Diferencia clave entre `docker stop` y `docker kill`:** `stop` envía `SIGTERM` y espera (por defecto 10s) a que la app cierre limpio antes de forzar `SIGKILL`. `kill` envía `SIGKILL` inmediatamente, sin gracia. Usa `stop` siempre que puedas — apps con conexiones a base de datos o colas en proceso pueden corromper datos si se matan en seco.

## Comandos

```bash
# Crear y ejecutar
docker run ubuntu
docker run -it ubuntu bash          # modo interactivo con terminal

# Ejecutar en segundo plano (detached)
docker run -d nginx

# Asignar nombre al contenedor
docker run --name mi_nginx nginx

# Listar contenedores
docker ps          # solo los que están corriendo
docker ps -a       # incluye detenidos

# Detener, iniciar y reiniciar
docker stop mi_nginx
docker start mi_nginx
docker restart mi_nginx

# Logs
docker logs mi_nginx
docker logs -f mi_nginx              # en tiempo real (follow)
docker logs --tail 100 mi_nginx      # solo las últimas 100 líneas
docker logs --since 30m mi_nginx     # logs de los últimos 30 minutos

# Ejecutar comandos dentro de un contenedor activo
docker exec -it mi_nginx bash
docker exec mi_nginx ls /usr/share/nginx/html

# Inspeccionar: IP, volúmenes, variables de entorno, estado
docker inspect mi_nginx

# Eliminar contenedores
docker rm mi_nginx
docker rm -f mi_nginx              # fuerza eliminación aunque esté corriendo
docker container prune             # elimina TODOS los contenedores detenidos

# Ver consumo de recursos en tiempo real: CPU, RAM, red, I/O
docker stats

# Copiar archivos entre host y contenedor
docker cp archivo.txt mi_nginx:/tmp/
docker cp mi_nginx:/tmp/archivo.txt .

# Pausar y reanudar (congela los procesos sin detenerlos)
docker pause mi_nginx
docker unpause mi_nginx

# Contenedores efímeros (se autodestruyen al salir, ideal para pruebas rápidas)
docker run --rm alpine echo "Hola Docker"
```

> **🚨 Cuidado:** `docker container prune` elimina **todos** los contenedores detenidos sin pedir confirmación detallada de cada uno. En un servidor compartido, esto puede borrar el contenedor de un compañero que lo detuvo temporalmente para debug. Verifica con `docker ps -a` antes de ejecutarlo en entornos no personales.

## Variables de `docker run`

| Opción | Descripción |
|---|---|
| `-d` | Segundo plano (detached) |
| `-it` | Modo interactivo + pseudo-TTY |
| `--name` | Nombre del contenedor |
| `-p` | Publica puertos (`host:contenedor`) |
| `-v` | Monta volúmenes o bind mounts |
| `-e` | Define variables de entorno |
| `--rm` | Elimina el contenedor automáticamente al detenerse |

> `--rm` es ideal para pruebas o tareas temporales — evita acumular contenedores "fantasma" detenidos que luego hay que limpiar manualmente.

## Seguridad en Contenedores

Esta sección no existía en el documento original y es, en la práctica, donde más errores de producción se cometen.

### No ejecutar como root

Por defecto, si no se especifica `USER` en el Dockerfile, el proceso dentro del contenedor corre como `root`. Esto no te da privilegios de root sobre el **host** automáticamente (gracias a los namespaces), pero sí amplifica el daño si hay una vulnerabilidad de "container escape" o si el contenedor tiene montado algo sensible del host.

```bash
# Verificar con qué usuario corre un contenedor
docker exec mi_contenedor whoami

# Forzar un usuario distinto en runtime (si la imagen no lo define)
docker run -u 1000:1000 miapp
```

### Limitar capacidades del kernel (`--cap-drop`)

Por defecto, Docker concede un conjunto de "capabilities" de Linux al contenedor (no es root completo, pero es más de lo que casi ninguna app necesita).

```bash
# Eliminar TODAS las capabilities y añadir solo las estrictamente necesarias
docker run --cap-drop=ALL --cap-add=NET_BIND_SERVICE nginx
```

> **Por qué importa:** si tu app web no necesita capacidad de cambiar la hora del sistema, manipular interfaces de red o montar filesystems, no se la das. Reduce drásticamente la superficie de ataque ante un proceso comprometido dentro del contenedor.

### Filesystem de solo lectura

```bash
docker run --read-only --tmpfs /tmp nginx
```

Esto impide que un atacante escriba binarios maliciosos en el filesystem del contenedor (un patrón de ataque común). `--tmpfs /tmp` provee un espacio de escritura temporal en memoria para lo que la app sí necesite escribir (cachés, archivos temporales).

### Escaneo de vulnerabilidades en imágenes

Antes de llevar una imagen a producción, escanéala:

```bash
docker scout cves miapp:1.0
```

> `docker scout` viene integrado en versiones recientes de Docker Desktop/CLI. Herramientas equivalentes ampliamente usadas en la industria: **Trivy** (Aqua Security) y **Grype** (Anchore). El objetivo es el mismo: detectar CVEs conocidos en las dependencias del sistema base antes de que lleguen a producción.

### Gestión de secretos

**Nunca** hagas esto:
```dockerfile
# ❌ MAL: el secreto queda grabado en una capa de la imagen, visible con `docker history`
ENV DB_PASSWORD=supersecreto123
```

```bash
# ✅ BIEN: inyectar en runtime, nunca en build time
docker run -e DB_PASSWORD=supersecreto123 miapp
```

O mejor aún, usar un gestor de secretos externo (Vault, AWS Secrets Manager, Docker Secrets en Swarm) y que la app los lea desde ahí en el arranque.

# 6. Volumen

**Un volumen en Docker es el mecanismo diseñado para persistir datos** generados o utilizados por contenedores, independientemente del ciclo de vida del contenedor que los usa.

Por defecto, los contenedores son **efímeros**: si borras un contenedor, todo lo que se creó dentro de él desaparece. Los volúmenes resuelven esto.

> **Analogía:** El contenedor es como una habitación de hotel — cuando te vas (lo eliminas), la limpian y queda como nueva, sin rastro de tu estancia. El volumen es tu **maleta**: la traes contigo, la sacas de la habitación, y tus cosas (los datos) siguen existiendo aunque cambies de habitación (de contenedor).

- Los datos persisten aunque el contenedor se elimine.
- Pueden compartirse entre múltiples contenedores.
- Son independientes del sistema de archivos del contenedor — evitan que los cambios se pierdan.
- **Regla práctica:** si los datos deben sobrevivir a reinicios, destrucción o actualización del contenedor (típicamente: bases de datos), usa volúmenes.

## Contenedor vs Volumen

| Datos dentro del contenedor | Volumen Docker |
|---|---|
| Se pierden al eliminar el contenedor | Persisten después de eliminar el contenedor |
| Parte de la capa de escritura (writable) | Independiente de la capa del contenedor |
| Difícil de compartir entre contenedores | Fácil de compartir entre contenedores |

## Tipos de almacenamiento

| Tipo | Gestionado por | Persistencia | Caso de uso típico |
|---|---|---|---|
| **Volumes** | Docker | Sí, portable | Bases de datos, datos que Docker debe gestionar completamente |
| **Bind mounts** | El usuario (ruta del host) | Sí, pero atada a esa ruta exacta del host | Desarrollo local (montar tu código fuente en vivo) |
| **tmpfs** | Memoria RAM | No, se borra al detener el contenedor | Datos sensibles temporales, cachés de muy corta vida |

> **Cuándo usar cada uno — criterio práctico:** Si necesitas que Docker gestione el almacenamiento de forma portable y sin atarte a una ruta específica del host → **volumen**. Si estás desarrollando localmente y quieres ver cambios de código en vivo sin rebuild → **bind mount**. Si el dato es sensible y no debe tocar disco nunca (ej. claves temporales) → **tmpfs**.

## Comandos

```bash
# Crear un volumen
docker volume create mi_volumen
docker volume create --driver local mi_volumen

# Listar volúmenes
docker volume ls

# Inspeccionar un volumen (ruta real en el host, driver, etc.)
docker volume inspect mi_volumen

# Eliminar un volumen
docker volume rm mi_volumen
docker volume prune          # elimina TODOS los volúmenes no usados por ningún contenedor
```

> **🚨 Advertencia:** `docker volume rm` y `docker volume prune` eliminan datos de forma **irreversible**. No hay papelera de reciclaje. Antes de ejecutar `prune` en un servidor con bases de datos, verifica con `docker volume ls` y `docker inspect` qué contenedores los usan.

```bash
# Asociar un volumen con nombre a un contenedor (caso típico: base de datos)
docker run -d \
  --name mi_db \
  -v mi_volumen:/var/lib/mysql \
  mysql:8

# Crear un volumen anónimo "al vuelo" (sin especificar nombre)
docker run -d \
  --name web \
  -v /app/data \
  nginx
```

> **Nota:** sin un nombre explícito, Docker crea un volumen anónimo en `/var/lib/docker/volumes/`. Es funcionalmente igual a uno con nombre, pero mucho más difícil de identificar y gestionar después — en producción, **siempre nombra tus volúmenes explícitamente**.

```bash
# Bind mount: ruta específica del host → ruta dentro del contenedor
docker run -d \
  --name web \
  -v /home/usuario/html:/usr/share/nginx/html \
  nginx

# Compartir un mismo volumen entre dos contenedores
docker run -d --name app1 -v mi_volumen:/data alpine
docker run -d --name app2 -v mi_volumen:/data alpine
```

> **🚨 Error común con bind mounts:** problemas de permisos. Si el proceso dentro del contenedor corre como un UID distinto al propietario de la carpeta en el host, obtendrás `Permission denied` al escribir. Soluciónalo igualando el UID del usuario del contenedor (`USER 1000` en el Dockerfile) con el propietario real de la carpeta en el host, o ajustando permisos con `chown` antes de montar.

## Errores Comunes en Volúmenes

| Problema | Causa típica | Solución |
|---|---|---|
| Los datos desaparecen tras `docker compose down` | Se usó `docker compose down -v` sin querer, o nunca se declaró un volumen con nombre | Usar volúmenes con nombre explícito; usar `down` sin `-v` salvo que realmente quieras borrar datos |
| `Permission denied` al escribir en un bind mount | UID del proceso del contenedor ≠ propietario de la carpeta en el host | Igualar UID/GID, o usar `chown` en el host antes de montar |
| El volumen ocupa espacio pero no sabes de qué contenedor es | Volumen anónimo (sin nombre) | Nombrar siempre los volúmenes explícitamente; usar `docker volume inspect` y `docker ps -a --filter volume=` para auditar |
| Datos de un volumen no se ven entre dos contenedores que deberían compartirlos | Cada contenedor monta un volumen con nombre *distinto*, aunque parezca el mismo dato | Verificar que ambos `-v` usan el mismo nombre de volumen exacto |

# 7. Network

**Una network (red) de Docker es un entorno de comunicación aislado** donde los contenedores pueden enviarse y recibir datos entre sí y, opcionalmente, con el exterior.

> **Analogía:** Piensa en una red Docker como el **WiFi de una oficina**. Los dispositivos conectados al mismo WiFi (contenedores en la misma red) se ven y pueden comunicarse por su nombre, como si fuera un DNS interno. Un dispositivo en el WiFi del edificio de al lado (otra red, u otro host) no puede verlos a menos que abras una puerta específica hacia el exterior (publicar un puerto).

Características:
- Permite comunicación entre contenedores sin necesidad de conocer IPs fijas (Docker resuelve por nombre del contenedor).
- Aísla contenedores de otras redes o del host, si así se desea.
- Si no especificas nada, Docker conecta el contenedor a la red `bridge` por defecto.
- Un contenedor puede estar conectado a una o más redes simultáneamente.
- Las redes pueden ser **user-defined** (creadas explícitamente por ti) o **built-in** (las que trae Docker por defecto).

> **Punto que el documento original no explicaba y es clave en producción:** en la red `bridge` **por defecto** (la que existe sin que la crees), los contenedores **no se resuelven por nombre entre sí** — solo por IP. Si creas una red **user-defined** (`docker network create`), Docker activa resolución DNS automática por nombre de contenedor. Esta es la razón principal por la que casi nadie usa la red `bridge` por defecto en proyectos reales: siempre se crea una red propia.

## Tipos de redes

| Tipo | Descripción | Uso típico |
|---|---|---|
| **bridge** | Red privada por defecto para contenedores en el mismo host | Comunicación local entre contenedores de una misma app |
| **host** | El contenedor comparte directamente la pila de red del host (sin aislamiento de red) | Rendimiento máximo, cuando el aislamiento de red no es prioridad |
| **none** | Sin red, aislamiento total | Contenedores batch que no necesitan comunicarse con nada |
| **overlay** | Conecta contenedores entre múltiples hosts físicos | Clústeres (Swarm/Kubernetes) |
| **macvlan** | Asigna una MAC e IP propia y real al contenedor, visible en la red física | Integración con infraestructura de red existente (poco común fuera de casos avanzados) |

## Comandos

```bash
# Listar redes: NETWORK ID, NAME, DRIVER, SCOPE
docker network ls

# Inspeccionar una red: contenedores conectados, subred, gateway, driver
docker network inspect nombre_red

# Crear una red user-defined (recomendado: habilita DNS por nombre de contenedor)
docker network create --driver bridge mi_red

# Conectar un contenedor existente a una red
docker run -d --name web nginx
docker network connect mi_red web
```

> Una vez conectado, `web` puede comunicarse con cualquier otro contenedor en `mi_red` usando su **nombre** como hostname (ej. `ping web` desde otro contenedor en la misma red).

```bash
# Desconectar un contenedor de una red
docker network disconnect mi_red mi_contenedor

# Eliminar una red (solo si no tiene contenedores conectados)
docker network rm mi_red

# Publicar un puerto del contenedor hacia el host
docker run -d -p 8080:80 --name web nginx
```

> **Diferencia que genera confusión constante:** `docker network connect` conecta contenedores **entre sí** (comunicación interna). `-p host:contenedor` publica un puerto **hacia afuera**, hacia tu máquina/red externa. Son mecanismos distintos para problemas distintos — no son intercambiables.

## Troubleshooting de Red

| Síntoma | Causa probable | Solución |
|---|---|---|
| `docker run -p 8080:80` falla con "port is already allocated" | Otro proceso (o contenedor) ya usa el puerto 8080 en el host | `sudo lsof -i :8080` (Linux/Mac) o `netstat -ano \| findstr :8080` (Windows) para identificar el proceso; cambia el puerto o libéralo |
| Un contenedor no puede resolver el nombre de otro (`ping: unknown host`) | Ambos están en la red `bridge` por defecto, que no tiene DNS interno | Crear y usar una red user-defined (`docker network create`) y conectar ambos contenedores a ella |
| La app responde dentro del contenedor (`docker exec ... curl localhost`) pero no desde el host | Falta `-p` al ejecutar, o la app escucha en `127.0.0.1` en vez de `0.0.0.0` dentro del contenedor | Verificar que la app escuche en `0.0.0.0`; añadir `-p host:contenedor` |
| Dos contenedores en redes distintas no se ven | Cada uno está en una red Docker diferente y nunca se conectaron | Conectar ambos a una red común con `docker network connect` |
| Cambios de IP rompen la conexión entre servicios | Se está usando la IP del contenedor en vez de su nombre | Nunca hardcodees IPs de contenedores — usa siempre el nombre del servicio/contenedor como hostname dentro de una red user-defined |

# 8. Registry

**Un Docker Registry es un almacén centralizado** donde se guardan y distribuyen las imágenes Docker.

> **Analogía:** Si Docker es el sistema de mensajería que mueve contenedores entre sitios, el Registry es el **centro logístico**. Sin él, no podrías compartir tus imágenes con otros desarrolladores ni desplegarlas en servidores de producción de forma sistemática — tendrías que copiar archivos manualmente, perdiendo versionado y trazabilidad.

El flujo de trabajo se basa en tres acciones principales:
- **Login:** te identificas ante el registro.
- **Push:** subes una imagen local desde tu máquina al registro.
- **Pull:** descargas una imagen del registro a tu máquina.

**El concepto de "Tagging" (etiquetado):**
Para subir una imagen, su nombre debe seguir un formato específico para que Docker sepa exactamente a dónde enviarla:

```text
[usuario_o_url_servidor]/[nombre_imagen]:[etiqueta]
```

## Tipos de Registry

| Tipo | Descripción | Ejemplo |
|---|---|---|
| **Público** | Accesible para todos | Docker Hub |
| **Privado** | Solo accesible a tu organización | Harbor, AWS ECR, GCP Artifact Registry, Azure ACR |
| **Local** | Registry corriendo en tu propia máquina o red interna | `docker run -d -p 5000:5000 registry` |

> **Criterio de decisión para producción:** Docker Hub público está bien para proyectos open source o personales. En entornos empresariales, usa siempre un registry **privado** (ECR/ACR/GCP Artifact Registry/Harbor) — entre otras razones, porque Docker Hub aplica **rate limits** de pull para cuentas no autenticadas y planes gratuitos, lo cual puede romper despliegues en CI/CD si no estás autenticado o excedes el límite.

## Comandos

```bash
# Iniciar sesión
docker login
docker login registry.example.com

# Cerrar sesión
docker logout

# Buscar imágenes en Docker Hub (nombre, descripción, stars, si es oficial)
docker search mysql

# Descargar imágenes
docker pull nginx
docker pull usuario/miapp:1.0

# Etiquetar y subir una imagen propia
docker tag miapp:1.0 usuario/miapp:1.0
docker push usuario/miapp:1.0

# Etiquetar apuntando a un registry privado específico
docker tag miapp:1.0 registry.example.com/usuario/miapp:1.0

# Listar / eliminar imágenes locales
docker images
docker rmi miapp:1.0

# Levantar un Registry local (útil para testing o redes internas)
docker run -d -p 5000:5000 --name registry registry:2
docker tag miapp:1.0 localhost:5000/miapp:1.0
docker push localhost:5000/miapp:1.0
docker pull localhost:5000/miapp:1.0
```

> **🚨 Buena práctica de versionado que el documento original no mencionaba:** **nunca uses solo `latest` en producción.** `docker pull miapp:latest` no garantiza qué versión exacta obtienes — `latest` es simplemente un tag más, no un puntero especial a "la versión más reciente y estable". Usa versionado semántico explícito (`miapp:1.4.2`) o el SHA del commit (`miapp:a3f9c21`) para que cada despliegue sea reproducible y auditable.

# 9. Docker Compose

**Docker Compose es una herramienta que permite definir y ejecutar aplicaciones multi-contenedor** mediante un único archivo de configuración declarativo: `docker-compose.yml`.

> **Analogía:** Si `docker run` es dar instrucciones a un solo cocinero para un solo plato, Compose es el **menú completo del restaurante**: defines todos los platos (servicios), cómo se relacionan entre sí (redes), de dónde sacan los ingredientes (volúmenes) y en qué orden se preparan (`depends_on`) — y con una sola orden ("¡a cocinar!" = `docker compose up`) todo el restaurante se pone en marcha de forma coordinada.

**Ventajas:**
- Define múltiples contenedores en un solo archivo versionable en Git.
- Configura volúmenes, redes y dependencias entre contenedores de forma declarativa.
- Levanta toda la aplicación con un solo comando.
- Ideal para desarrollo, pruebas, y entornos locales (en producción a gran escala se suele migrar a Kubernetes/Swarm, pero Compose sigue siendo perfectamente válido para producción de escala pequeña-mediana en un solo host).

Un `docker-compose.yml` describe:
- **Servicios** (qué contenedores se crean)
- **Imágenes** a usar, o **Dockerfiles** para construir
- **Volúmenes**
- **Redes**
- **Puertos**

Compose lee el archivo y crea toda la infraestructura descrita de una sola vez.

```bash
docker compose up
docker compose down
```

## Instalación

### Windows

**Requisitos:**
- Windows 10/11 Pro, Enterprise o Education (o Home con WSL2)
- Docker Desktop instalado

Docker Compose viene **incluido** en Docker Desktop — no se instala por separado.

```bash
docker-compose --version   # versión legacy (si existe)
docker compose version     # versión moderna (plugin)
```

> **Nota:** No es necesario instalar Compose de forma independiente en Windows si usas Docker Desktop.

### macOS

**Requisitos:**
- macOS 11 o superior
- Docker Desktop instalado (Intel o Apple Silicon)

Igual que en Windows, Compose viene incluido en Docker Desktop.

```bash
docker compose version
```

> Si prefieres instalar Compose de forma independiente (sin Docker Desktop), sigue los mismos pasos que en Linux, descargando el binario desde el repositorio oficial de GitHub.

### Linux

**Requisitos:**
- Docker Engine instalado (sección 2.3)

```bash
# Instalar el plugin de Compose
sudo apt install -y docker-compose-plugin

# Verificar instalación
docker compose version
```

> **Nota:** en distribuciones recientes de Ubuntu/Debian, el plugin `docker-compose-plugin` se instala automáticamente junto con Docker Engine (ver paso 5 de la sección 2.3), por lo que `docker compose` (sin guion) ya está disponible sin pasos extra.

Para versiones antiguas de Docker que no incluyen el plugin:

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
```

## Docker Compose moderno vs legacy

| Legacy | Moderno |
|---|---|
| `docker-compose` (con guion) | `docker compose` (subcomando) |
| Binario Python independiente | Plugin nativo de Docker CLI (Go) |
| Obsoleto, sin nuevas features | Recomendado — única opción con soporte activo |

> A partir de aquí, esta guía usa siempre la sintaxis moderna `docker compose` (sin guion). Si tu entorno solo tiene la versión legacy, el comportamiento es funcionalmente equivalente para los comandos que veremos.

## Diferencias entre Docker CLI y Docker Compose

| Docker CLI | Docker Compose |
|---|---|
| Gestiona un contenedor a la vez | Gestiona múltiples contenedores como un conjunto coherente |
| Configuración manual vía flags (`docker run -p -v -e ...`) | Configuración declarativa en `docker-compose.yml` |
| Difícil de reproducir exactamente (flags se olvidan o varían) | Reproducible y versionable en Git |
| Comandos dispersos por cada contenedor | Un solo comando (`up`/`down`) orquesta todo |

## Estructura de un `docker-compose.yml`

| Clave | Qué define |
|---|---|
| `services` | Los contenedores que se van a crear |
| `build` | Ruta a un Dockerfile para construir la imagen del servicio |
| `image` | Una imagen ya existente (en lugar de construir) |
| `ports` | Mapeo `host:contenedor` |
| `volumes` (dentro de un servicio) | Persistencia de datos del servicio |
| `networks` (dentro de un servicio) | A qué red(es) pertenece el contenedor |
| `volumes:` / `networks:` (a nivel raíz, fuera de `services`) | Declaran los recursos compartidos que los servicios pueden referenciar |

> **Nota sobre `version:`:** en versiones recientes de Docker Compose (v2+), el campo `version: "3.9"` al inicio del archivo es **obsoleto y se ignora silenciosamente** — Compose detecta automáticamente las capacidades disponibles. Se puede omitir por completo en archivos nuevos; lo mantenemos en el ejemplo solo como referencia de compatibilidad con archivos antiguos.

**Ejemplo corregido y comentado** *(el original tenía un error de indentación: `depends_on` estaba al mismo nivel que los servicios en lugar de estar dentro de `web` — un YAML inválido que Compose rechazaría al ejecutarlo)*:

```yaml
services:
  web:
    build: ./web                    # construye desde el Dockerfile en ./web
    ports:
      - "8080:80"                   # host:contenedor
    volumes:
      - ./web:/usr/share/nginx/html # bind mount para desarrollo
    networks:
      - app_net
    depends_on:                     # ✅ CORRECTO: depends_on va DENTRO del servicio "web"
      db:
        condition: service_healthy  # espera a que "db" esté healthy, no solo "running"

  db:
    image: mysql:8
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}   # ✅ leído desde .env, nunca hardcodeado
    volumes:
      - db_data:/var/lib/mysql
    networks:
      - app_net
    healthcheck:                    # necesario para que "condition: service_healthy" funcione
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  db_data:

networks:
  app_net:
```

> **🚨 Por qué el error del original es grave:** sin `healthcheck` en `db`, la condición `service_healthy` en `depends_on` **nunca se cumpliría** — Compose esperaría indefinidamente o fallaría, porque MySQL no tiene un healthcheck definido para reportar ese estado. `depends_on` con `condition: service_healthy` y `healthcheck` van siempre **juntos**: uno sin el otro no funciona como se espera.

> **❌ MAL — contraseña hardcodeada en el YAML** (como tenía el documento original con `MYSQL_ROOT_PASSWORD: ejemplo123`): queda versionada en Git en texto plano, visible para cualquiera con acceso al repositorio.
> **✅ BIEN:** usar `${MYSQL_ROOT_PASSWORD}` y definir el valor real en un archivo `.env` que **nunca** se sube a Git (añádelo a `.gitignore`).

## `.env` y variables de entorno

Docker Compose permite centralizar configuración sensible o variable en un archivo `.env`, leído automáticamente si está en el mismo directorio que el `docker-compose.yml`.

```env
MYSQL_ROOT_PASSWORD=secret
APP_PORT=8080
```

```yaml
services:
  web:
    ports:
      - "${APP_PORT}:80"
```

> **🔒 Buena práctica obligatoria:** añade `.env` a tu `.gitignore`. Mantén un `.env.example` (sin valores reales, solo las claves) versionado en Git para que el equipo sepa qué variables necesita definir.

## `depends_on` y `healthcheck`

- **`depends_on`:** controla el **orden de arranque** de los servicios.
  - Sin `condition`, solo espera a que el contenedor dependiente esté *iniciado* (no necesariamente *listo*).
  - Con `condition: service_healthy`, espera a que el `healthcheck` del servicio dependiente reporte `healthy`.
- **`healthcheck`:** verifica el estado **real** del servicio (no solo que el proceso esté corriendo, sino que responda correctamente).

```yaml
services:
  api:
    build: ./api
    depends_on:
      db:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 15s
      timeout: 5s
      start_period: 10s
      retries: 3
```

> **Error muy común que el original no advertía:** asumir que `depends_on` (sin `condition`) garantiza que el servicio dependiente ya puede recibir tráfico. Solo garantiza que el contenedor **arrancó**, no que la app dentro ya inicializó (ej. una base de datos que tarda 5-10s en aceptar conexiones tras arrancar el proceso). Por eso siempre se combina con `healthcheck` + `condition: service_healthy` cuando el orden real de disponibilidad importa.

## Seguridad y Límites de Recursos en Compose

Sección no presente en el documento original.

```yaml
services:
  web:
    build: ./web
    user: "1000:1000"            # evita ejecutar como root
    read_only: true              # filesystem de solo lectura
    tmpfs:
      - /tmp                     # espacio de escritura temporal en memoria
    cap_drop:
      - ALL                      # elimina todas las capabilities por defecto
    deploy:
      resources:
        limits:
          cpus: "0.50"           # máximo 50% de un núcleo de CPU
          memory: 256M           # máximo 256MB de RAM
        reservations:
          cpus: "0.25"
          memory: 128M
    restart: unless-stopped      # reinicia automáticamente salvo detención manual explícita
```

> **Por qué los límites de recursos importan en producción:** sin `limits`, un contenedor con una fuga de memoria (memory leak) puede consumir toda la RAM del host y afectar a **otros** contenedores y servicios que comparten esa máquina. `deploy.resources` es la forma declarativa de Compose de aplicar lo que en `docker run` equivaldría a `--memory` y `--cpus`.

> **`restart` — políticas disponibles:**
> - `no` (por defecto): nunca reinicia automáticamente.
> - `always`: reinicia siempre, incluso tras un `docker stop` manual al reiniciar el daemon.
> - `on-failure`: solo reinicia si el contenedor termina con código de error.
> - `unless-stopped`: reinicia automáticamente salvo que se haya detenido manualmente — **la más usada en producción**, porque sobrevive a reinicios del host sin pelear contra paradas intencionales.

## Comandos

```bash
# Levantar la aplicación
docker compose up
docker compose up -d              # en segundo plano

# Detener y eliminar contenedores y redes creadas
docker compose down
docker compose down -v            # además elimina los volúmenes (⚠️ borra datos persistentes)

# Construir imágenes definidas con "build"
docker compose build

# Reiniciar servicios
docker compose restart

# Parar servicios sin eliminarlos
docker compose stop

# Listar contenedores gestionados por este Compose
docker compose ps

# Ejecutar comandos dentro de un servicio
docker compose exec web bash

# Ver logs
docker compose logs
docker compose logs -f            # tiempo real
docker compose logs -f web        # solo del servicio "web"

# Escalar un servicio a N réplicas (requiere no fijar "container_name" ni puertos fijos en conflicto)
docker compose up -d --scale web=3
```

> **🚨 Advertencia sobre `docker compose down -v`:** elimina también los volúmenes con nombre asociados a los servicios. Si `db_data` contiene tu base de datos de desarrollo con horas de trabajo, este comando la borra sin posibilidad de recuperación. Resérvalo para cuando realmente quieras un entorno limpio desde cero.

## Errores Comunes en Docker Compose

| Problema | Causa típica | Solución |
|---|---|---|
| `depends_on` con `condition: service_healthy` nunca se cumple / timeout | El servicio dependiente no tiene `healthcheck` definido | Definir siempre un `healthcheck` en cualquier servicio referenciado con `condition: service_healthy` |
| YAML inválido / Compose no arranca | Indentación incorrecta (ej. una clave de servicio fuera del nivel correcto, como en el bug corregido en 9.4) | Validar con `docker compose config` antes de `up` — muestra el YAML final interpretado y falla claramente si hay errores de sintaxis |
| `docker compose up --scale web=3` falla | El servicio tiene `ports` fijos (`"8080:80"`) o `container_name` fijo — no pueden coexistir 3 réplicas con el mismo puerto/nombre | Quitar `container_name`; usar rangos de puertos o dejar que Compose asigne automáticamente, o anteponer un balanceador (nginx/Traefik) delante de las réplicas |
| Variables de `.env` no se aplican | El archivo `.env` no está en el mismo directorio que `docker-compose.yml`, o se nombró distinto | Verificar ubicación exacta; usar `docker compose config` para confirmar qué valores se están resolviendo realmente |
| Contraseñas u otros secretos visibles en el repositorio Git | Se hardcodean directamente en `docker-compose.yml` | Usar `${VARIABLE}` + `.env` (excluido de Git vía `.gitignore`) |

# 10. Límites de Recursos y Resiliencia (docker run)

Esta sección no existía en el documento original. Complementa lo visto en Compose (9.7) para cuando se usa `docker run` directamente, sin Compose.

## Limitar CPU y memoria

```bash
docker run -d \
  --name miapp \
  --memory=256m \
  --memory-swap=256m \
  --cpus="0.5" \
  miapp:1.0
```

| Flag | Qué hace |
|---|---|
| `--memory` | Límite duro de RAM. Si el contenedor lo excede, el kernel lo mata (`OOMKilled`) |
| `--memory-swap` | Límite combinado de RAM + swap. Igualarlo a `--memory` desactiva el swap para ese contenedor |
| `--cpus` | Límite de núcleos de CPU (acepta decimales: `0.5` = medio núcleo) |

> **Por qué esto es obligatorio en producción multi-tenant:** sin estos límites, un único contenedor con una fuga de memoria o un bucle infinito de CPU puede degradar **todos** los demás servicios del mismo host. Es la diferencia entre un incidente contenido y una caída general.

## Políticas de reinicio

```bash
docker run -d --restart=unless-stopped miapp:1.0
```

| Política | Comportamiento |
|---|---|
| `no` | Nunca reinicia automáticamente (default) |
| `always` | Reinicia siempre, incluso después de reiniciar el host |
| `on-failure[:N]` | Reinicia solo si sale con código de error; opcionalmente limita a N intentos |
| `unless-stopped` | Reinicia automáticamente excepto si se detuvo manualmente — la más recomendada en producción |

## Healthcheck en runtime (sin Dockerfile)

Si no defines `HEALTHCHECK` en el Dockerfile, puedes inyectarlo en `docker run`:

```bash
docker run -d \
  --health-cmd="curl -f http://localhost:3000/health || exit 1" \
  --health-interval=30s \
  --health-retries=3 \
  miapp:1.0
```

# 11. Troubleshooting General de Docker

Tabla de diagnóstico consolidada — problemas que no son específicos de imágenes, volúmenes, redes o Compose (ya cubiertos en sus respectivas secciones), sino del entorno Docker en general.

| Síntoma | Diagnóstico | Solución |
|---|---|---|
| `docker: command not found` tras instalar | El PATH no se actualizó, o la instalación falló a mitad | Reinicia la terminal; verifica con `which docker`; reinstala si persiste |
| `Cannot connect to the Docker daemon` | El daemon (`dockerd`) no está corriendo | Linux: `sudo systemctl start docker`. Desktop: abre la app y espera a que el ícono indique "running" |
| `permission denied while trying to connect to the Docker daemon socket` | Tu usuario no está en el grupo `docker` (Linux) | `sudo usermod -aG docker $USER && newgrp docker` (ver advertencia de seguridad en sección 2.3) |
| `no space left on device` durante un build o pull | Acumulación de imágenes, contenedores parados, volúmenes huérfanos y caché de build | Ver sección 11.1 (gestión de espacio en disco) |
| Un contenedor muere inmediatamente después de iniciar (`Exited (1)`) | El proceso principal (`CMD`/`ENTRYPOINT`) falla o termina solo | `docker logs nombre_contenedor` para ver el error real; verifica que el proceso principal no termine (Docker detiene el contenedor cuando el PID 1 termina) |
| El contenedor está `unhealthy` pero la app "parece" funcionar | El comando del `HEALTHCHECK` está mal escrito, o la app responde en una ruta/puerto distinta a la chequeada | `docker inspect --format='{{json .State.Health}}' nombre_contenedor` para ver el detalle exacto del fallo |
| Build extremadamente lento incluso sin cambios | No se está usando BuildKit, o el `.dockerignore` no excluye carpetas pesadas | Activar BuildKit (`DOCKER_BUILDKIT=1`, activado por defecto en versiones recientes); revisar `.dockerignore` (sección 12) |
| Cambios en el código no se reflejan al rebuildear | Caché de capas reutilizando una capa antigua por error, o se está usando `image:` en vez de `build:` en Compose | `docker build --no-cache`; verificar que Compose esté usando `build:` y no una imagen vieja con el mismo tag |

## Gestión de espacio en disco

Docker acumula con el tiempo: imágenes intermedias, contenedores detenidos, volúmenes huérfanos, caché de build. Esto **no se limpia solo**.

```bash
# Ver cuánto espacio ocupa cada categoría
docker system df

# Ver detalle por imagen/contenedor/volumen
docker system df -v

# Limpieza completa: contenedores detenidos + redes no usadas + imágenes dangling + caché de build
docker system prune

# Limpieza agresiva: incluye TODAS las imágenes no usadas por ningún contenedor (no solo dangling)
docker system prune -a

# Incluir también volúmenes no usados (⚠️ irreversible, revisa antes con docker volume ls)
docker system prune -a --volumes
```

> **🚨 Antes de automatizar `prune` en un cron job de servidor:** `prune -a --volumes` es la opción más agresiva posible. En un servidor compartido por varios equipos, puede eliminar imágenes en caché que otro pipeline necesita, o volúmenes que alguien pensaba usar "más tarde". Recomendación: empieza con `docker system df` para entender qué se está acumulando, y aplica `prune` de forma incremental (sin `-a` primero) antes de la versión agresiva.

# 12. Archivos clave

## `.dockerignore`

Evita copiar archivos innecesarios al **build context**, acelerando el build y reduciendo el tamaño final de la imagen (relacionado directamente con lo explicado en la sección 4.4.1 sobre el contexto de construcción).

**Ejemplo ampliado** (el original solo tenía 3 líneas; esta versión cubre los casos reales más comunes):

```dockerignore
# Dependencias (se reinstalan dentro del contenedor, no se copian del host)
node_modules
vendor/
__pycache__/
*.pyc

# Control de versiones
.git
.gitignore

# Variables de entorno y secretos — NUNCA deben terminar dentro de una imagen
.env
.env.*
*.pem
*.key

# Archivos de build/artefactos locales que se regeneran en el build
dist/
build/
*.log

# Archivos de IDE y sistema operativo
.vscode/
.idea/
.DS_Store
Thumbs.db

# Documentación y archivos que no afectan el runtime
README.md
docs/
```

> **Por qué `.env` en `.dockerignore` es crítico:** aunque ya recomendamos no commitear `.env` a Git (sección 9.5), si **no** está en `.dockerignore` y existe en tu carpeta local al momento del build, `COPY . .` lo copiaría dentro de la imagen — exponiendo secretos a cualquiera con acceso a esa imagen, incluso si nunca tocó tu repositorio Git.


# Resumen ejecutivo de buenas prácticas (checklist final)

Antes de llevar cualquier imagen/proyecto Docker a producción, verifica:

- [ ] La imagen usa multi-stage build si hay un paso de compilación (sección 4.4.3)
- [ ] El contenedor corre con un `USER` no privilegiado, nunca root por defecto (5.5.1)
- [ ] Se aplican `--cap-drop=ALL` + solo las capabilities estrictamente necesarias (5.5.2)
- [ ] La imagen fue escaneada con `docker scout`/Trivy antes de publicarse (5.5.4)
- [ ] Ningún secreto está hardcodeado en `Dockerfile`, `docker-compose.yml`, ni copiado por accidente vía `.dockerignore` mal configurado (5.5.5, 9.4, 12.1)
- [ ] Los servicios con dependencias de arranque usan `healthcheck` + `depends_on: condition: service_healthy` correctamente emparejados (9.6)
- [ ] Existen límites de `--memory`/`--cpus` (o `deploy.resources` en Compose) en todo servicio de producción (10.1, 9.7)
- [ ] La política de `restart` está definida explícitamente (`unless-stopped` recomendado) (10.2)
- [ ] El versionado de imágenes usa tags semánticos o SHA — nunca solo `latest` (8.2)
- [ ] Se valida el YAML con `docker compose config` antes de cada `up` en CI/CD (9.9)