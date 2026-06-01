> **Estado:** 🟢 Completo
> **Última actualización:** 2026-05
> **Nivel:** Principiante — se explican los conceptos desde cero

---

# Módulo 02: Instalación, Estructura de Directorios y Arranque

- [Módulo 02: Instalación, Estructura de Directorios y Arranque](#módulo-02-instalación-estructura-de-directorios-y-arranque)
  - [2.1 Requisitos Previos: JDK Compatible por Versión](#21-requisitos-previos-jdk-compatible-por-versión)
    - [¿Qué es el JDK y por qué importa?](#qué-es-el-jdk-y-por-qué-importa)
    - [Verificación del entorno](#verificación-del-entorno)
  - [2.2 Métodos de Instalación](#22-métodos-de-instalación)
    - [2.2.1 Instalación desde binario (.zip / .tar.gz) — Recomendado para producción](#221-instalación-desde-binario-zip--targz--recomendado-para-producción)
      - [Linux / macOS](#linux--macos)
      - [Windows](#windows)
    - [2.2.2 Instalación via gestor de paquetes (apt/yum) — Solo desarrollo/testing](#222-instalación-via-gestor-de-paquetes-aptyum--solo-desarrollotesting)
    - [2.2.3 Instalación via Docker — Entornos containerizados](#223-instalación-via-docker--entornos-containerizados)
  - [2.3 Estructura de Directorios Completa](#23-estructura-de-directorios-completa)
    - [¿Por qué es importante conocer los directorios?](#por-qué-es-importante-conocer-los-directorios)
  - [2.4 Separación CATALINA\_HOME vs CATALINA\_BASE](#24-separación-catalina_home-vs-catalina_base)
    - [El problema que resuelve](#el-problema-que-resuelve)
    - [Estructura para múltiples instancias](#estructura-para-múltiples-instancias)
    - [Script de arranque para una instancia específica](#script-de-arranque-para-una-instancia-específica)
  - [2.5 El Archivo setenv.sh / setenv.bat](#25-el-archivo-setenvsh--setenvbat)
    - [¿Qué es y por qué existe?](#qué-es-y-por-qué-existe)
    - [setenv.sh (Linux/macOS) — Configuración de producción completa](#setenvsh-linuxmacos--configuración-de-producción-completa)
    - [setenv.bat (Windows)](#setenvbat-windows)
  - [2.6 Scripts de Arranque y Control](#26-scripts-de-arranque-y-control)
    - [2.6.1 Comandos principales](#261-comandos-principales)
    - [2.6.2 Integración con systemd (Linux — Producción)](#262-integración-con-systemd-linux--producción)
    - [2.6.3 Variable CATALINA\_PID](#263-variable-catalina_pid)
  - [2.7 Configuración Inicial de Seguridad Post-Instalación](#27-configuración-inicial-de-seguridad-post-instalación)
    - [¿Por qué este paso es crítico?](#por-qué-este-paso-es-crítico)
    - [2.7.1 Eliminar aplicaciones por defecto](#271-eliminar-aplicaciones-por-defecto)
    - [2.7.2 Configurar tomcat-users.xml para Manager](#272-configurar-tomcat-usersxml-para-manager)
    - [2.7.3 Restringir acceso al Manager por IP](#273-restringir-acceso-al-manager-por-ip)
  - [2.8 Verificación del Arranque](#28-verificación-del-arranque)
    - [2.8.1 Verificación via logs](#281-verificación-via-logs)
    - [2.8.2 Verificación via curl](#282-verificación-via-curl)
    - [2.8.3 Verificación de la JVM y Tomcat en ejecución](#283-verificación-de-la-jvm-y-tomcat-en-ejecución)
  - [2.9 Gestión de Logs: JULI (Java Util Logging Implementation)](#29-gestión-de-logs-juli-java-util-logging-implementation)
    - [¿Qué es JULI y por qué Tomcat tiene su propio sistema de logging?](#qué-es-juli-y-por-qué-tomcat-tiene-su-propio-sistema-de-logging)
    - [Configuración de logging.properties](#configuración-de-loggingproperties)
  - [2.10 Tabla de Puertos por Defecto y su Función](#210-tabla-de-puertos-por-defecto-y-su-función)
  - [Puntos Clave](#puntos-clave)

---

## 2.1 Requisitos Previos: JDK Compatible por Versión

### ¿Qué es el JDK y por qué importa?

Tomcat es una aplicación Java. Para ejecutarla necesitas tener instalado el **JDK** (Java Development Kit) en el servidor. El JDK incluye la máquina virtual de Java (JVM) que ejecuta el código, además de herramientas de compilación.

> 💡 **JDK vs JRE:** El JRE (Java Runtime Environment) solo ejecuta aplicaciones Java ya compiladas. El JDK incluye el JRE más herramientas de desarrollo (compilador `javac`, etc.). Para ejecutar Tomcat en producción bastaría técnicamente con un JRE, pero en la práctica se recomienda instalar el JDK completo porque Tomcat usa `javac` internamente para compilar JSPs.

Cada versión de Tomcat requiere **como mínimo** una versión concreta de Java. Si instalas Tomcat 11 con Java 11, no arrancará porque el requisito mínimo es Java 17. La tabla siguiente te ayuda a elegir la combinación correcta:

| Tomcat | JDK Mínimo | JDK Recomendado (Producción) | JDK Máximo Verificado |
|--------|------------|------------------------------|-----------------------|
| 8.0    | Java 7     | Java 8 LTS                   | Java 11               |
| 8.5    | Java 7     | Java 11 LTS                  | Java 17               |
| 9.0    | Java 8     | Java 11 LTS / Java 17 LTS    | Java 21               |
| 10.0   | Java 8     | Java 11 LTS / Java 17 LTS    | Java 21               |
| 10.1   | Java 11    | Java 17 LTS / Java 21 LTS    | Java 21               |
| 11.0   | Java 17    | Java 21 LTS                  | Java 21+              |

> 💡 **¿Qué es LTS?** Las versiones LTS (Long-Term Support) de Java son las que reciben actualizaciones de seguridad durante muchos años. Las versiones no-LTS solo duran 6 meses. Para producción, usa siempre una versión LTS: Java 11, Java 17 o Java 21.

### Verificación del entorno

Antes de instalar Tomcat, comprueba que tienes Java instalado correctamente y que la variable `JAVA_HOME` apunta al directorio correcto. `JAVA_HOME` es la forma estándar de decirle a Tomcat (y a otras herramientas Java) dónde está instalado el JDK.

```bash
# Ver qué versión de Java tienes instalada.
# La salida debe decir algo como: openjdk version "17.0.9"
java -version
javac -version

# Ver el valor de JAVA_HOME (Linux/macOS)
# Debe ser algo como: /usr/lib/jvm/java-17-openjdk-amd64
echo $JAVA_HOME

# En Windows CMD:
echo %JAVA_HOME%

# Verificar que apunta al JDK completo y no solo al JRE.
# Este comando debe devolver la ruta al compilador (no "no such file").
ls $JAVA_HOME/bin/javac
```

Si `JAVA_HOME` está vacío o apunta a un lugar incorrecto, Tomcat no arrancará. Para configurarlo:

```bash
# Linux/macOS: añadir al final de ~/.bashrc o /etc/environment
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
```

---

## 2.2 Métodos de Instalación

Hay tres formas de instalar Tomcat. Cada una tiene sus casos de uso:

### 2.2.1 Instalación desde binario (.zip / .tar.gz) — Recomendado para producción

Este método consiste en descargar el archivo comprimido directamente desde la web oficial de Apache y descomprimirlo manualmente. Es el más recomendado para producción porque:

- Tienes **control total** sobre la versión exacta instalada
- Puedes tener **varias versiones** de Tomcat coexistiendo en el mismo servidor
- La estructura de directorios es **exactamente la oficial** (no la modificada por los distribuidores de Linux)
- Puedes **verificar la integridad** del archivo antes de usarlo

#### Linux / macOS

Cada paso está explicado con su propósito:

```bash
# 1. Definir la versión que queremos instalar como variables,
#    así solo cambiamos un número si queremos otra versión.
export TOMCAT_VERSION=10.1.20
export TOMCAT_MAJOR=10
export INSTALL_DIR=/opt

# 2. Descargar el archivo desde los servidores oficiales de Apache.
#    También descargamos el archivo .sha512 (checksum) y .asc (firma GPG)
#    para verificar que el archivo no está corrupto ni manipulado.
cd /tmp
wget https://downloads.apache.org/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz
wget https://downloads.apache.org/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz.asc
wget https://downloads.apache.org/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz.sha512

# 3. Verificar integridad SHA-512.
#    Este comando calcula el hash del archivo descargado y lo compara
#    con el hash publicado por Apache. Si son iguales, el archivo es auténtico.
#    Debes ver: apache-tomcat-X.X.X.tar.gz: OK
sha512sum -c apache-tomcat-${TOMCAT_VERSION}.tar.gz.sha512

# 4. Verificar firma GPG (recomendado en producción).
#    La firma GPG garantiza que el archivo fue firmado por los desarrolladores
#    de Apache, no solo que el archivo no está corrupto.
gpg --import https://downloads.apache.org/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/KEYS
gpg --verify apache-tomcat-${TOMCAT_VERSION}.tar.gz.asc

# 5. Descomprimir el archivo en /opt y crear un enlace simbólico.
#    El enlace simbólico "tomcat" apunta a la versión instalada.
#    Así, cuando actualices, solo cambia el enlace y no tienes que
#    actualizar todas las rutas en tus scripts.
tar -xzf apache-tomcat-${TOMCAT_VERSION}.tar.gz -C ${INSTALL_DIR}
ln -s ${INSTALL_DIR}/apache-tomcat-${TOMCAT_VERSION} ${INSTALL_DIR}/tomcat

# 6. Crear un usuario dedicado para ejecutar Tomcat.
#    NUNCA se debe ejecutar Tomcat como root (el superusuario).
#    Si Tomcat fuera comprometido por un atacante, tener su propio
#    usuario sin privilegios limita el daño que puede hacer.
#    La opción "-s /bin/false" evita que ese usuario pueda hacer login SSH.
useradd -r -m -U -d /opt/tomcat -s /bin/false tomcat

# Asignar los archivos de Tomcat al usuario "tomcat"
chown -R tomcat:tomcat ${INSTALL_DIR}/apache-tomcat-${TOMCAT_VERSION}

# Permisos restrictivos: solo el usuario tomcat puede leer/escribir/ejecutar
chmod -R 750 ${INSTALL_DIR}/apache-tomcat-${TOMCAT_VERSION}

# 7. Los scripts .sh necesitan permiso de ejecución explícito
chmod +x ${INSTALL_DIR}/tomcat/bin/*.sh

# 8. Configurar las variables de entorno a nivel de sistema
#    para que estén disponibles en cualquier sesión
cat >> /etc/environment << 'EOF'
JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
CATALINA_HOME=/opt/tomcat
CATALINA_BASE=/opt/tomcat
EOF

source /etc/environment
```

#### Windows

```batch
REM 1. Descargar apache-tomcat-10.1.20-windows-x64.zip
REM    desde https://tomcat.apache.org/download-10.cgi

REM 2. Descomprimir en C:\opt\tomcat (puedes usar el Explorador de Windows)

REM 3. Configurar las variables de entorno a nivel de sistema.
REM    El modificador /M las establece para todos los usuarios de la máquina.
REM    Abre un CMD como Administrador para ejecutar estos comandos.
setx JAVA_HOME "C:\Program Files\Eclipse Adoptium\jdk-17.0.9.9-hotspot" /M
setx CATALINA_HOME "C:\opt\tomcat" /M

REM 4. Instalar Tomcat como servicio de Windows.
REM    Esto permite que Tomcat arranque automáticamente al iniciar Windows
REM    y que se gestione desde el panel de Servicios.
cd C:\opt\tomcat\bin
service.bat install TomcatService

REM 5. Arrancar el servicio
net start TomcatService
```

---

### 2.2.2 Instalación via gestor de paquetes (apt/yum) — Solo desarrollo/testing

Los gestores de paquetes como `apt` (Ubuntu/Debian) o `dnf` (RHEL/Rocky Linux) permiten instalar Tomcat con un solo comando:

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install -y tomcat10 tomcat10-admin

# CentOS/RHEL/Rocky Linux
sudo dnf install -y tomcat

# Verificar que el servicio está activo
sudo systemctl status tomcat10
```

**¿Por qué NO usar esto en producción?**

Los paquetes de los repositorios de Linux tienen dos problemas:
1. **Versión desactualizada:** Los mantenedores de Ubuntu o RHEL publican versiones de Tomcat con semanas o meses de retraso. Podrías instalar una versión con vulnerabilidades de seguridad ya conocidas y parcheadas en la versión oficial.
2. **Estructura diferente:** El paquete reorganiza los directorios de Tomcat de una forma que no coincide con la documentación oficial, lo que hace más difícil seguir guías o solucionar problemas.

> ✅ **Úsalo para:** desarrollo local rápido, entornos de CI/CD temporales, cuando la versión exacta no importa.
> ❌ **No lo uses para:** entornos de producción ni staging.

---

### 2.2.3 Instalación via Docker — Entornos containerizados

Docker permite empaquetar Tomcat junto con tu aplicación y su configuración en un **contenedor**: una unidad autocontenida y reproducible que funciona igual en cualquier máquina.

La imagen oficial de Tomcat en Docker Hub incluye el JDK y Tomcat preinstalados. Solo necesitas añadir tu configuración y tu aplicación:

```dockerfile
# Dockerfile para Tomcat 10.1 con Java 17
# "FROM" indica la imagen base de la que partimos.
# "tomcat:10.1.20-jdk17-temurin" es la imagen oficial con Tomcat 10.1.20 y JDK 17 Temurin.
FROM tomcat:10.1.20-jdk17-temurin

# Eliminar las aplicaciones que vienen por defecto en Tomcat.
# No las necesitas en producción y representan una superficie de ataque innecesaria.
RUN rm -rf /usr/local/tomcat/webapps/ROOT \
           /usr/local/tomcat/webapps/examples \
           /usr/local/tomcat/webapps/docs \
           /usr/local/tomcat/webapps/host-manager \
           /usr/local/tomcat/webapps/manager

# Copiar tu configuración personalizada de server.xml, context.xml, etc.
# "COPY origen destino" copia archivos desde tu máquina al contenedor.
COPY conf/server.xml /usr/local/tomcat/conf/server.xml
COPY conf/context.xml /usr/local/tomcat/conf/context.xml
COPY conf/catalina.properties /usr/local/tomcat/conf/catalina.properties
COPY conf/logging.properties /usr/local/tomcat/conf/logging.properties

# Copiar el archivo WAR de tu aplicación
COPY target/myapp.war /usr/local/tomcat/webapps/myapp.war

# Crear un usuario sin privilegios para ejecutar Tomcat dentro del contenedor
RUN groupadd -r tomcat && useradd -r -g tomcat tomcat
RUN chown -R tomcat:tomcat /usr/local/tomcat
USER tomcat

# Variables de entorno de la JVM.
# -Xms512m: la JVM arranca con al menos 512 MB de heap
# -Xmx1024m: la JVM nunca usará más de 1024 MB de heap
# -XX:+UseG1GC: usa el recolector de basura G1 (recomendado para servidores)
# -Djava.security.egd: generador de números aleatorios más rápido en Linux
ENV JAVA_OPTS="-Xms512m -Xmx1024m -XX:+UseG1GC \
               -Djava.security.egd=file:/dev/./urandom \
               -Dfile.encoding=UTF-8"

# Indicar qué puertos expone este contenedor
EXPOSE 8080 8443

# Comando por defecto al arrancar el contenedor
CMD ["catalina.sh", "run"]
```

Para orquestar el contenedor de Tomcat junto con otros servicios (base de datos, proxy, etc.) se usa `docker-compose`:

```yaml
# docker-compose.yml
# Define todos los servicios de tu aplicación y cómo se conectan
version: '3.8'

services:
  tomcat:
    build: .                    # Construir la imagen usando el Dockerfile de este directorio
    container_name: tomcat-app
    ports:
      - "8080:8080"             # Mapear puerto 8080 del host al 8080 del contenedor
      - "8443:8443"
    volumes:
      # Volúmenes: permiten que los datos persistan aunque el contenedor se reinicie.
      # Los logs quedarán en el host aunque el contenedor sea destruido.
      - tomcat-logs:/usr/local/tomcat/logs
      - tomcat-work:/usr/local/tomcat/work
    environment:
      - JAVA_OPTS=-Xms512m -Xmx2g -XX:+UseG1GC
      - TZ=Europe/Madrid        # Zona horaria para que los logs tengan la hora correcta
    restart: unless-stopped     # Reiniciar automáticamente salvo que se detenga manualmente
    networks:
      - app-network

volumes:
  tomcat-logs:
  tomcat-work:

networks:
  app-network:
    driver: bridge
```

---

## 2.3 Estructura de Directorios Completa

### ¿Por qué es importante conocer los directorios?

Cuando algo falla en Tomcat, la primera pregunta siempre es: "¿dónde está el log?". La segunda: "¿dónde está el archivo de configuración que debo cambiar?". Conocer la estructura de directorios te permite responder estas preguntas sin tener que buscar.

```
$CATALINA_HOME/
├── bin/                        ← Scripts para arrancar, parar y controlar Tomcat
│   ├── catalina.sh             ← El script principal de control (Linux/macOS)
│   ├── catalina.bat            ← El script principal de control (Windows)
│   ├── startup.sh              ← Atajo que llama a catalina.sh start (arranca en background)
│   ├── shutdown.sh             ← Atajo que llama a catalina.sh stop (para Tomcat)
│   ├── version.sh              ← Muestra la versión de Tomcat y de la JVM
│   ├── digest.sh               ← Genera hashes de contraseñas para los archivos de usuarios
│   ├── tool-wrapper.sh         ← Script genérico para herramientas internas de Tomcat
│   ├── setenv.sh               ← ⭐ TÚ LO CREAS: variables de entorno y opciones de JVM
│   ├── tomcat-juli.jar         ← Librería del sistema de logging de Tomcat (JULI)
│   └── bootstrap.jar           ← El punto de entrada que arranca todo el proceso de Tomcat
│
├── conf/                       ← Todos los archivos de configuración del servidor
│   ├── server.xml              ← ⭐ LA CONFIGURACIÓN PRINCIPAL: conectores, hosts, contexts
│   ├── web.xml                 ← Configuración global de Servlets y filtros para todas las apps
│   ├── context.xml             ← Configuración global de Context (aplicable a todas las apps)
│   ├── tomcat-users.xml        ← Usuarios y contraseñas para el Manager y MemoryRealm
│   ├── catalina.properties     ← Propiedades del sistema y rutas del ClassLoader
│   ├── catalina.policy         ← Política de seguridad Java (si se usa SecurityManager)
│   ├── jaspic-providers.xml    ← Configuración de proveedores de autenticación JASPIC
│   ├── logging.properties      ← Configuración del sistema de logs JULI
│   └── Catalina/               ← Subdirectorio con configuración por Engine y Host
│       └── localhost/          ← Descriptores XML de cada Context (aplicación)
│           ├── myapp.xml       ← Configuración del Context de /myapp (recomendado)
│           └── ROOT.xml        ← Configuración del Context de la app raíz "/"
│
├── lib/                        ← Librerías JAR del Common ClassLoader
│   │                              (visibles para Tomcat y para todas las aplicaciones)
│   ├── servlet-api.jar         ← La API Servlet (javax.* o jakarta.* según versión)
│   ├── jsp-api.jar             ← La API JSP
│   ├── el-api.jar              ← La API Expression Language
│   ├── websocket-api.jar       ← La API WebSocket
│   ├── jasper.jar              ← El motor JSP de Tomcat (compila JSPs a Java)
│   ├── catalina.jar            ← El núcleo de Tomcat Catalina
│   ├── tomcat-coyote.jar       ← Coyote: implementación de los conectores HTTP/AJP
│   ├── tomcat-dbcp.jar         ← Pool de conexiones a base de datos (DBCP2)
│   ├── tomcat-jdbc.jar         ← Pool de conexiones alternativo (Tomcat JDBC Pool)
│   ├── catalina-ha.jar         ← Soporte de High Availability y clúster
│   └── ...                     ← Resto de librerías internas
│
├── logs/                       ← Todos los archivos de log de Tomcat
│   ├── catalina.out            ← ⭐ LOG PRINCIPAL: stdout y stderr del proceso Java
│   │                              (primera parada cuando algo falla al arrancar)
│   ├── catalina.YYYY-MM-DD.log ← Log del servidor, rotado diariamente
│   ├── localhost.YYYY-MM-DD.log← Log del host virtual "localhost"
│   ├── manager.YYYY-MM-DD.log  ← Log de la aplicación Manager
│   ├── host-manager.YYYY-MM-DD.log ← Log del Host Manager
│   └── localhost_access_log.YYYY-MM-DD.txt ← Registro de todas las peticiones HTTP
│
├── temp/                       ← Archivos temporales de la JVM (normalmente vacío)
│
├── webapps/                    ← ⭐ AQUÍ VAN TUS APLICACIONES
│   │                              (directorio appBase del Host por defecto)
│   ├── ROOT/                   ← Aplicación raíz: se sirve en http://servidor:8080/
│   ├── docs/                   ← Documentación de Tomcat (eliminar en producción)
│   ├── examples/               ← Ejemplos de Servlet y JSP (eliminar en producción)
│   ├── host-manager/           ← App web para gestionar Virtual Hosts
│   ├── manager/                ← App web para gestionar aplicaciones (deploy/undeploy)
│   └── myapp/                  ← Tu aplicación desplegada (descomprimida del WAR)
│       ├── WEB-INF/
│       │   ├── web.xml         ← Descriptor de despliegue de la aplicación
│       │   ├── classes/        ← Clases Java compiladas de la aplicación
│       │   └── lib/            ← JARs de dependencias de la aplicación
│       └── index.html          ← Archivos estáticos de la aplicación
│
└── work/                       ← Directorio de trabajo interno de Tomcat
    └── Catalina/               ← Clases Java generadas al compilar los JSPs
        └── localhost/
            └── myapp/
                └── org/apache/jsp/   ← Cada JSP se convierte en un .java y se compila aquí
```

> 💡 **El directorio `work/` y los JSPs:** Cuando un usuario accede por primera vez a una página JSP, Tomcat la convierte en código Java, la compila y guarda el resultado en `work/`. Las siguientes peticiones usan directamente el `.class` compilado, por eso la primera petición a un JSP es más lenta que las siguientes. Si borras `work/`, Tomcat recompilará todos los JSPs en la próxima petición.

---

## 2.4 Separación CATALINA_HOME vs CATALINA_BASE

### El problema que resuelve

Imagina que tienes un servidor y necesitas ejecutar dos aplicaciones en él: una en el puerto 8080 y otra en el 8090, cada una con su propia configuración. La solución obvia sería instalar Tomcat dos veces. Pero eso significa tener dos copias idénticas de todos los binarios y librerías, lo que complica las actualizaciones (tendrías que actualizar en dos sitios).

La separación `CATALINA_HOME` / `CATALINA_BASE` resuelve esto: los **binarios se instalan una sola vez** y cada **instancia tiene su propio directorio** de configuración y datos.

| Variable        | Qué representa                                                             |
|-----------------|----------------------------------------------------------------------------|
| `CATALINA_HOME` | El directorio donde están los **binarios de Tomcat** (solo lectura, compartido) |
| `CATALINA_BASE` | El directorio de **esta instancia concreta** (configuración, logs, apps)   |

Cuando ambas variables apuntan al mismo directorio (instalación simple con una sola instancia), Tomcat funciona exactamente igual que antes. Solo tiene sentido separarlas cuando necesitas múltiples instancias.

### Estructura para múltiples instancias

```
/opt/tomcat-binaries/          ← CATALINA_HOME (un único directorio, solo lectura)
├── bin/                          Solo contiene los binarios y librerías de Tomcat.
└── lib/                          Ninguna instancia lo modifica.

/opt/instances/
├── instance-app1/             ← CATALINA_BASE de la instancia 1
│   ├── conf/
│   │   ├── server.xml         ← Puerto 8080, configuración específica de app1
│   │   ├── web.xml
│   │   ├── context.xml
│   │   └── tomcat-users.xml
│   ├── logs/                  ← Los logs de app1 van aquí (separados de app2)
│   ├── temp/
│   ├── webapps/
│   │   └── app1.war
│   └── work/
│
└── instance-app2/             ← CATALINA_BASE de la instancia 2
    ├── conf/
    │   ├── server.xml         ← Puerto 8090, configuración específica de app2
    │   └── ...
    ├── logs/                  ← Los logs de app2 van aquí
    ├── webapps/
    │   └── app2.war
    └── work/
```

### Script de arranque para una instancia específica

```bash
#!/bin/bash
# /opt/instances/instance-app1/bin/start.sh
# Este script arranca solo la instancia 1, usando los binarios compartidos.

export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# Apuntar a los binarios compartidos
export CATALINA_HOME=/opt/tomcat-binaries

# Apuntar a los datos y configuración de ESTA instancia
export CATALINA_BASE=/opt/instances/instance-app1

# Opciones de JVM específicas para esta instancia
# (pueden ser diferentes a las de la instancia 2)
export CATALINA_OPTS="-Xms512m -Xmx2g -XX:+UseG1GC \
  -XX:MaxGCPauseMillis=200 \
  -Dapp.environment=production \
  -Dapp.instance=app1"

# Arranca usando los scripts de CATALINA_HOME pero con datos de CATALINA_BASE
$CATALINA_HOME/bin/startup.sh
```

---

## 2.5 El Archivo setenv.sh / setenv.bat

### ¿Qué es y por qué existe?

Cuando arrancas Tomcat, el script `catalina.sh` se ejecuta y pone en marcha la JVM con una serie de opciones (cuánta memoria usar, qué recolector de basura activar, etc.). Esas opciones se pueden definir en un archivo llamado `setenv.sh` que Tomcat carga automáticamente si existe.

**¿Por qué no poner las opciones directamente en `catalina.sh`?**

Porque `catalina.sh` pertenece a la distribución de Tomcat: cuando actualices Tomcat, ese archivo se sobrescribirá y perderás tus personalizaciones. `setenv.sh`, en cambio, lo creas tú y no se toca en las actualizaciones.

> ⚠️ **Regla de oro:** Todo lo que configures sobre la JVM va en `setenv.sh`. Nunca edites `catalina.sh` directamente.

### setenv.sh (Linux/macOS) — Configuración de producción completa

Cada opción está explicada con su propósito:

```bash
#!/bin/bash
# $CATALINA_BASE/bin/setenv.sh
# Este archivo lo creas tú. Tomcat lo carga automáticamente al arrancar.

# --- Configuración de memoria del Heap ---
# El "Heap" es la zona de memoria donde Java aloja los objetos de tu aplicación.
# -Xms: tamaño inicial del Heap (reservado al arrancar). Ponerlo igual a -Xmx
#       evita que la JVM tenga que crecer el Heap bajo carga (más predecible).
# -Xmx: tamaño máximo. Si tu app necesita más, lanzará OutOfMemoryError.
CATALINA_OPTS="$CATALINA_OPTS -Xms1g"
CATALINA_OPTS="$CATALINA_OPTS -Xmx4g"

# --- Metaspace ---
# El Metaspace guarda los metadatos de las clases cargadas (definiciones, nombres, etc.).
# Es diferente al Heap. Sin límite puede crecer indefinidamente y consumir toda la RAM.
CATALINA_OPTS="$CATALINA_OPTS -XX:MetaspaceSize=256m"     # Tamaño inicial
CATALINA_OPTS="$CATALINA_OPTS -XX:MaxMetaspaceSize=512m"  # Límite máximo

# --- Recolector de Basura (Garbage Collector) ---
# Java gestiona la memoria automáticamente. Cuando un objeto ya no se usa,
# el "recolector de basura" (GC) lo elimina para liberar memoria.
# G1GC es el recomendado para servidores desde Java 9.
# MaxGCPauseMillis: intenta que las pausas del GC no superen 200ms.
CATALINA_OPTS="$CATALINA_OPTS -XX:+UseG1GC"
CATALINA_OPTS="$CATALINA_OPTS -XX:MaxGCPauseMillis=200"
CATALINA_OPTS="$CATALINA_OPTS -XX:G1HeapRegionSize=16m"
CATALINA_OPTS="$CATALINA_OPTS -XX:G1NewSizePercent=20"
CATALINA_OPTS="$CATALINA_OPTS -XX:G1MaxNewSizePercent=40"
CATALINA_OPTS="$CATALINA_OPTS -XX:InitiatingHeapOccupancyPercent=45"

# --- Log del Recolector de Basura ---
# Registra en un archivo cada vez que el GC actúa.
# Esencial para diagnosticar problemas de rendimiento o memory leaks.
# filecount=10: guarda los últimos 10 archivos de log, luego sobreescribe
# filesize=20m: cada archivo de log tiene máximo 20 MB
CATALINA_OPTS="$CATALINA_OPTS -Xlog:gc*:file=${CATALINA_BASE}/logs/gc.log:time,uptime,level,tags:filecount=10,filesize=20m"

# --- Rendimiento General ---
# -server: activa optimizaciones de la JVM orientadas a procesos de larga duración
CATALINA_OPTS="$CATALINA_OPTS -server"
CATALINA_OPTS="$CATALINA_OPTS -XX:+OptimizeStringConcat"
CATALINA_OPTS="$CATALINA_OPTS -XX:+UseStringDeduplication"

# --- Codificación de caracteres ---
# Asegura que todos los textos se traten como UTF-8 (imprescindible para
# caracteres no ingleses: ñ, á, ü, etc.)
CATALINA_OPTS="$CATALINA_OPTS -Dfile.encoding=UTF-8"
CATALINA_OPTS="$CATALINA_OPTS -Dsun.jnu.encoding=UTF-8"

# --- Zona horaria ---
# Fija la zona horaria para que los logs muestren la hora local correcta.
CATALINA_OPTS="$CATALINA_OPTS -Duser.timezone=Europe/Madrid"

# --- DNS Caching ---
# Por defecto Java cachea las resoluciones DNS indefinidamente.
# Esto es un problema si una IP cambia (ej: failover de base de datos).
# ttl=60: re-resolver DNS cada 60 segundos
# negative.ttl=10: si un nombre no existe, volver a intentarlo a los 10s
CATALINA_OPTS="$CATALINA_OPTS -Dsun.net.inetaddr.ttl=60"
CATALINA_OPTS="$CATALINA_OPTS -Dsun.net.inetaddr.negative.ttl=10"

# --- Generador de números aleatorios ---
# Java usa /dev/random para generar tokens de sesión seguros. En Linux,
# /dev/random puede bloquearse si el sistema no tiene suficiente "entropía".
# /dev/./urandom es una alternativa no bloqueante con seguridad equivalente
# para este uso. La barra extra (/dev/./) es intencional para evitar un bug.
CATALINA_OPTS="$CATALINA_OPTS -Djava.security.egd=file:/dev/./urandom"

# --- Monitorización remota vía JMX ---
# JMX permite conectar herramientas como JConsole o VisualVM al proceso de
# Tomcat en ejecución para ver métricas en tiempo real (uso de memoria,
# número de hilos, estadísticas de sesiones, etc.).
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote"
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.port=9090"
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.ssl=false"
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.authenticate=true"
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.password.file=${CATALINA_BASE}/conf/jmxremote.password"
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.access.file=${CATALINA_BASE}/conf/jmxremote.access"

# --- Heap Dump en OutOfMemoryError ---
# Si la JVM se queda sin memoria, genera automáticamente un archivo "heap dump"
# que puedes analizar después con herramientas como Eclipse MAT o VisualVM
# para descubrir qué objetos estaban consumiendo la memoria.
CATALINA_OPTS="$CATALINA_OPTS -XX:+HeapDumpOnOutOfMemoryError"
CATALINA_OPTS="$CATALINA_OPTS -XX:HeapDumpPath=${CATALINA_BASE}/logs/heapdump.hprof"

# --- Acción post-OutOfMemoryError ---
# Después de un OOM, el proceso Java puede quedar en estado inconsistente.
# Esta opción mata el proceso para que systemd (u otro gestor) lo reinicie limpiamente.
CATALINA_OPTS="$CATALINA_OPTS -XX:OnOutOfMemoryError='kill -9 %p'"

# --- Variables de configuración de tu aplicación ---
# Puedes pasar propiedades del sistema a tu aplicación Java desde aquí.
# Accesibles en código con: System.getProperty("app.environment")
CATALINA_OPTS="$CATALINA_OPTS -Dapp.environment=production"
CATALINA_OPTS="$CATALINA_OPTS -Dapp.config.dir=/opt/config/myapp"

export CATALINA_OPTS
```

### setenv.bat (Windows)

```batch
@echo off
REM %CATALINA_BASE%\bin\setenv.bat
REM En Windows, las variables se construyen acumulando con %CATALINA_OPTS%

set CATALINA_OPTS=-Xms1g -Xmx4g
set CATALINA_OPTS=%CATALINA_OPTS% -XX:+UseG1GC -XX:MaxGCPauseMillis=200
set CATALINA_OPTS=%CATALINA_OPTS% -Dfile.encoding=UTF-8
set CATALINA_OPTS=%CATALINA_OPTS% -Duser.timezone=Europe/Madrid
set CATALINA_OPTS=%CATALINA_OPTS% -Djava.security.egd=file:/dev/./urandom
set CATALINA_OPTS=%CATALINA_OPTS% -XX:+HeapDumpOnOutOfMemoryError
set CATALINA_OPTS=%CATALINA_OPTS% -XX:HeapDumpPath=%CATALINA_BASE%\logs\heapdump.hprof
```

---

## 2.6 Scripts de Arranque y Control

### 2.6.1 Comandos principales

Tomcat incluye varios scripts en la carpeta `bin/` para controlarlo. Son los siguientes:

```bash
# Arrancar Tomcat en segundo plano (background).
# El proceso queda corriendo aunque cierres el terminal.
# Toda la salida del proceso va a logs/catalina.out.
$CATALINA_HOME/bin/startup.sh

# Arrancar Tomcat en primer plano (foreground).
# El proceso ocupa el terminal y lo puedes parar con Ctrl+C.
# Útil para depurar problemas de arranque (ves los errores directamente)
# y es el modo recomendado para Docker (el contenedor "vive" mientras vive el proceso).
$CATALINA_HOME/bin/catalina.sh run

# Detener Tomcat limpiamente.
# Envía el comando de shutdown y espera a que Tomcat termine las peticiones en curso.
$CATALINA_HOME/bin/shutdown.sh

# Detener con timeout de seguridad.
# Espera 10 segundos y, si Tomcat no se ha parado, lo fuerza.
# Útil cuando hay peticiones que tardan mucho o hilos bloqueados.
$CATALINA_HOME/bin/shutdown.sh 10 -force

# Ver la versión exacta de Tomcat y de la JVM.
# Muy útil para confirmar qué tienes instalado y para reportar bugs.
$CATALINA_HOME/bin/version.sh

# Generar un hash de una contraseña para usar en tomcat-users.xml.
# Las contraseñas no deben guardarse en texto plano.
# Este comando genera el hash SHA-256 de "mipassword".
$CATALINA_HOME/bin/digest.sh -a SHA-256 -h org.apache.catalina.realm.MessageDigestCredentialHandler mipassword
```

### 2.6.2 Integración con systemd (Linux — Producción)

En producción en Linux, no se gestiona Tomcat manualmente con `startup.sh`. En su lugar se usa **systemd**, el gestor de servicios del sistema operativo. Systemd se encarga de:

- **Arrancar Tomcat automáticamente** cuando el servidor se enciende
- **Reiniciarlo automáticamente** si el proceso muere inesperadamente
- **Pararlo limpiamente** cuando el servidor se apaga
- **Recoger los logs** del proceso de forma centralizada

Para integrar Tomcat con systemd se crea un archivo `.service`:

```ini
# /etc/systemd/system/tomcat.service
# Este archivo le dice a systemd cómo gestionar el proceso de Tomcat.

[Unit]
Description=Apache Tomcat 10 Web Application Server
# Indica que Tomcat debe arrancarse DESPUÉS de que la red esté disponible.
# (Necesario porque Tomcat abre puertos de red)
After=network.target
Wants=network-online.target

[Service]
# "forking" significa que startup.sh lanza un proceso hijo y el padre termina.
# systemd rastreará el proceso hijo usando CATALINA_PID.
Type=forking

# Usuario y grupo con el que se ejecuta Tomcat (nunca root)
User=tomcat
Group=tomcat

# Variables de entorno disponibles para el proceso de Tomcat
Environment="JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_BASE=/opt/tomcat"
# CATALINA_PID: archivo donde Tomcat guarda su PID (Process ID).
# systemd lo usa para saber cuándo el proceso ha arrancado y para pararlo.
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512m -Xmx2g -XX:+UseG1GC \
  -Dfile.encoding=UTF-8 \
  -Djava.security.egd=file:/dev/./urandom"

# Comandos de arranque y parada
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh 30 -force

# Cuántos segundos esperar a que Tomcat se pare limpiamente.
# Pasado ese tiempo, systemd lo matará forzosamente.
TimeoutStopSec=30

# Si el proceso falla (sale con código de error), systemd lo reiniciará
# automáticamente esperando 10 segundos entre intentos.
Restart=on-failure
RestartSec=10s

# Límites del proceso: número máximo de ficheros abiertos simultáneamente.
# El valor por defecto del sistema (1024) puede ser insuficiente para
# un servidor web con muchas conexiones activas.
LimitNOFILE=65536
LimitNPROC=4096

# Medidas de seguridad adicionales del sistema operativo
NoNewPrivileges=true     # El proceso no puede ganar más privilegios
ProtectSystem=strict     # El sistema de archivos es de solo lectura excepto los paths siguientes
ReadWritePaths=/opt/tomcat/logs /opt/tomcat/work /opt/tomcat/temp /opt/tomcat/webapps

[Install]
WantedBy=multi-user.target  # Activar este servicio cuando el sistema esté en modo multiusuario
```

Comandos para gestionar el servicio:

```bash
# Recargar la configuración de systemd después de crear o modificar el .service
sudo systemctl daemon-reload

# Habilitar el servicio: se arrancará automáticamente al iniciar el sistema
sudo systemctl enable tomcat

# Arrancar el servicio ahora mismo
sudo systemctl start tomcat

# Ver el estado actual del servicio (si está activo, PID, últimas líneas de log)
sudo systemctl status tomcat

# Ver los logs del servicio en tiempo real
sudo journalctl -u tomcat -f

# Reiniciar el servicio (parar + arrancar)
sudo systemctl restart tomcat
```

### 2.6.3 Variable CATALINA_PID

`CATALINA_PID` es la ruta a un archivo donde Tomcat escribe su PID (identificador de proceso del sistema operativo) al arrancar. Sirve para que:

- `shutdown.sh` sepa exactamente a qué proceso enviar la señal de parada
- systemd pueda rastrear el proceso correctamente con `Type=forking`

```bash
# Añadir en setenv.sh
export CATALINA_PID="$CATALINA_BASE/temp/tomcat.pid"
```

---

## 2.7 Configuración Inicial de Seguridad Post-Instalación

### ¿Por qué este paso es crítico?

Tomcat viene de fábrica con aplicaciones de demostración y herramientas de administración expuestas. Si instalas Tomcat y lo pones en producción sin hacer nada más, un atacante podría:

- Ver los ejemplos de JSP y deducir la versión exacta de Tomcat (para buscar vulnerabilidades conocidas)
- Acceder a la aplicación Manager y desplegar aplicaciones maliciosas (si adivina la contraseña)
- Acceder a la documentación incluida y obtener información útil para un ataque

Los siguientes pasos son **obligatorios** antes de exponer Tomcat a Internet o a una red no confiable.

### 2.7.1 Eliminar aplicaciones por defecto

```bash
cd $CATALINA_HOME/webapps

# Eliminar completamente en producción:
# - docs/: documentación de Tomcat (innecesaria en producción)
# - examples/: demostraciones de Servlet y JSP (revelan la versión y son un riesgo)
# - ROOT/: la aplicación raíz con la página de bienvenida de Tomcat
#           (eliminar solo si tienes tu propia aplicación ROOT o no necesitas la raíz)
rm -rf docs/
rm -rf examples/
rm -rf ROOT/

# manager/ y host-manager/ son útiles para administración,
# pero solo con acceso restringido por IP (ver sección 2.7.3).
# Si no los necesitas, elimínalos también:
# rm -rf manager/
# rm -rf host-manager/
```

### 2.7.2 Configurar tomcat-users.xml para Manager

Si mantienes las aplicaciones `manager` y `host-manager`, debes configurar usuarios con contraseñas seguras. Las contraseñas **nunca** deben estar en texto plano en el archivo.

Primero, genera el hash de tu contraseña:

```bash
# Este comando genera el hash SHA-256 de "admin123".
# Copia la salida (el hash) para usarla en el XML.
$CATALINA_HOME/bin/digest.sh -a SHA-256 -h org.apache.catalina.realm.MessageDigestCredentialHandler admin123
```

Luego, edita `conf/tomcat-users.xml`:

```xml
<!-- conf/tomcat-users.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<tomcat-users xmlns="http://tomcat.apache.org/xml"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"
              version="1.0">

  <!-- Los "roles" son permisos que se asignan a los usuarios.
       Cada rol da acceso a una parte diferente del Manager. -->
  <role rolename="manager-gui"/>      <!-- Interfaz web del Manager (navegador) -->
  <role rolename="manager-script"/>   <!-- API REST del Manager (scripts de despliegue) -->
  <role rolename="manager-jmx"/>      <!-- Proxy JMX del Manager -->
  <role rolename="manager-status"/>   <!-- Solo ver el estado, sin poder hacer cambios -->
  <role rolename="admin-gui"/>        <!-- Interfaz web del Host Manager -->
  <role rolename="admin-script"/>     <!-- API del Host Manager -->

  <!-- Usuario de administración con acceso a la interfaz web.
       La contraseña es el hash SHA-256, no el texto plano.
       Si alguien lee este archivo, no podrá recuperar la contraseña original. -->
  <user username="tomcat-admin"
        password="8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918"
        roles="manager-gui,manager-status,admin-gui"/>

  <!-- Usuario específico para scripts de despliegue automático (CI/CD).
       Solo tiene acceso a la API REST, no a la interfaz web. -->
  <user username="deployer"
        password="5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8"
        roles="manager-script"/>

</tomcat-users>
```

### 2.7.3 Restringir acceso al Manager por IP

Aunque tengas contraseñas seguras, lo mejor es que el Manager solo sea accesible desde IPs conocidas (tu máquina de administración o tu red interna). Esto se configura en el `context.xml` de cada aplicación de administración:

```xml
<!-- webapps/manager/META-INF/context.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<Context antiResourceLocking="false" privileged="true">

  <!-- RemoteAddrValve: filtro de acceso por IP de origen.
       "allow" es una expresión regular. Solo IPs que coincidan pueden acceder.
       Cualquier otra IP recibe un error 403 (Forbidden).

       Ejemplos de patrones:
       127\.\d+\.\d+\.\d+   → cualquier IP que empiece por 127 (localhost)
       192\.168\.1\.\d+      → cualquier IP de la red 192.168.1.x
       10\.0\.0\.\d+         → cualquier IP de la red 10.0.0.x
  -->
  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|192\.168\.1\.\d+|10\.0\.0\.\d+"
         denyStatus="403"/>

  <!-- Configuración de cookies más segura: SameSite=strict previene
       ataques CSRF (Cross-Site Request Forgery) desde otros dominios -->
  <CookieProcessor className="org.apache.tomcat.util.http.Rfc6265CookieProcessor"
                   sameSiteCookies="strict"/>
</Context>
```

```xml
<!-- webapps/host-manager/META-INF/context.xml — misma restricción -->
<?xml version="1.0" encoding="UTF-8"?>
<Context antiResourceLocking="false" privileged="true">
  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|192\.168\.1\.\d+"
         denyStatus="403"/>
</Context>
```

---

## 2.8 Verificación del Arranque

### 2.8.1 Verificación via logs

El primer lugar donde mirar cuando hay un problema de arranque es `logs/catalina.out`. Este archivo recoge toda la salida estándar del proceso de Tomcat:

```bash
# Ver el log en tiempo real mientras Tomcat arranca
tail -f $CATALINA_BASE/logs/catalina.out
```

Un arranque correcto produce estas líneas clave (el orden y el texto exacto pueden variar según la versión):

```
INFO: Server version name: Apache Tomcat/10.1.20
INFO: Starting service [Catalina]
INFO: Starting Servlet engine: [Apache Tomcat/10.1.20]
INFO: Deployment of web application directory [.../webapps/ROOT] has finished
INFO: Starting ProtocolHandler ["http-nio-8080"]
INFO: Server startup in [XXXX] milliseconds    ← Esta línea confirma el arranque exitoso
```

Si el arranque falla, busca líneas con `SEVERE` o `ERROR` en el log: te indicarán la causa.

### 2.8.2 Verificación via curl

Una vez que los logs indican que Tomcat ha arrancado, puedes verificar que responde a peticiones HTTP desde la línea de comandos:

```bash
# Hacer una petición HTTP y ver la respuesta completa con cabeceras
curl -v http://localhost:8080/

# Ver solo el código de respuesta HTTP (200 = OK, 404 = no encontrado, etc.)
curl -o /dev/null -s -w "%{http_code}" http://localhost:8080/

# Probar HTTPS (el parámetro -k ignora el error de certificado self-signed en pruebas)
curl -k -v https://localhost:8443/

# Listar las aplicaciones desplegadas vía API del Manager
# (requiere tener el Manager instalado y configurado)
curl -u deployer:mipassword http://localhost:8080/manager/text/list

# Verificar que el puerto 8080 está escuchando conexiones
ss -tlnp | grep 8080
netstat -tlnp | grep 8080
```

### 2.8.3 Verificación de la JVM y Tomcat en ejecución

```bash
# Ver si el proceso de Tomcat está corriendo y su PID
ps aux | grep catalina

# Ver todos los parámetros JVM con los que arrancó
# (útil para confirmar que setenv.sh se cargó correctamente)
ps -ef | grep java | grep tomcat

# Ver qué puertos ha abierto el proceso Java de Tomcat
lsof -i -P -n | grep java

# Ver la versión exacta de Tomcat instalada
$CATALINA_HOME/bin/version.sh
```

La salida de `version.sh` debe mostrar algo similar a esto:

```
Server version: Apache Tomcat/10.1.20
Server built:   Jan 15 2024 12:00:00 UTC
Server number:  10.1.20.0
OS Name:        Linux
OS Version:     5.15.0-91-generic
Architecture:   amd64
JVM Version:    17.0.9+9
JVM Vendor:     Eclipse Adoptium
```

Esta información es esencial para reportar bugs o buscar vulnerabilidades conocidas para tu versión exacta.

---

## 2.9 Gestión de Logs: JULI (Java Util Logging Implementation)

### ¿Qué es JULI y por qué Tomcat tiene su propio sistema de logging?

Java incluye su propio sistema de logging llamado `java.util.logging` (JUL). Sin embargo, JUL tiene una limitación importante para un servidor de aplicaciones: es un sistema global para toda la JVM. Esto significa que no puede tener configuraciones de logging diferentes por aplicación.

**JULI** (Java Util Logging Implementation) es la extensión que Tomcat desarrolló para resolver esto. Añade dos características críticas:
- **Logging por aplicación:** cada aplicación puede tener su propio archivo de log y su propio nivel de verbosidad, sin interferir con las demás
- **Rotación automática de logs:** los archivos se rotan diariamente y se pueden limpiar automáticamente pasados N días

### Configuración de logging.properties

```properties
# $CATALINA_BASE/conf/logging.properties
# Este archivo define qué "handlers" (destinos de log) existen y cómo se comportan.

# Lista de handlers globales activos.
# Cada número antes del nombre es solo un prefijo para poder definir
# múltiples instancias del mismo tipo de handler.
handlers = 1catalina.org.apache.juli.AsyncFileHandler, \
           2localhost.org.apache.juli.AsyncFileHandler, \
           3manager.org.apache.juli.AsyncFileHandler, \
           java.util.logging.ConsoleHandler

# Nivel global de log: solo mensajes de nivel INFO o superior se procesan.
# Niveles de menor a mayor detalle: FINEST < FINER < FINE < CONFIG < INFO < WARNING < SEVERE
# En producción, INFO o WARNING son los más usados.
.level = INFO

# --- Handler 1: Log del servidor (catalina) ---
# Este archivo recoge los mensajes del propio Tomcat (arranque, parada, errores del servidor).
1catalina.org.apache.juli.AsyncFileHandler.level     = FINE       # Nivel de este handler
1catalina.org.apache.juli.AsyncFileHandler.directory = ${catalina.base}/logs
1catalina.org.apache.juli.AsyncFileHandler.prefix    = catalina.  # Nombre: catalina.FECHA.log
1catalina.org.apache.juli.AsyncFileHandler.suffix    = .log
1catalina.org.apache.juli.AsyncFileHandler.maxDays   = 90         # Borrar logs de más de 90 días
1catalina.org.apache.juli.AsyncFileHandler.encoding  = UTF-8
1catalina.org.apache.juli.AsyncFileHandler.bufferSize = 8192      # Buffer de escritura en bytes

# --- Handler 2: Log del host virtual (localhost) ---
# Recoge mensajes relacionados con el host "localhost" y sus aplicaciones.
2localhost.org.apache.juli.AsyncFileHandler.level     = FINE
2localhost.org.apache.juli.AsyncFileHandler.directory = ${catalina.base}/logs
2localhost.org.apache.juli.AsyncFileHandler.prefix    = localhost.
2localhost.org.apache.juli.AsyncFileHandler.suffix    = .log
2localhost.org.apache.juli.AsyncFileHandler.maxDays   = 90
2localhost.org.apache.juli.AsyncFileHandler.encoding  = UTF-8

# --- Handler 3: Log de la aplicación Manager ---
3manager.org.apache.juli.AsyncFileHandler.level     = FINE
3manager.org.apache.juli.AsyncFileHandler.directory = ${catalina.base}/logs
3manager.org.apache.juli.AsyncFileHandler.prefix    = manager.
3manager.org.apache.juli.AsyncFileHandler.suffix    = .log
3manager.org.apache.juli.AsyncFileHandler.maxDays   = 30    # El Manager rota más rápido

# --- Handler de consola ---
# Escribe en la salida estándar (stdout). Aparece en catalina.out y en journald si usas systemd.
# Útil para Docker (los contenedores leen stdout directamente).
java.util.logging.ConsoleHandler.level     = FINE
java.util.logging.ConsoleHandler.formatter = org.apache.juli.OneLineFormatter  # Una línea por mensaje
java.util.logging.ConsoleHandler.encoding  = UTF-8

# --- Asociar loggers con handlers ---
# Esto define qué handler recoge los mensajes de cada parte del sistema.
# El nombre del logger sigue la jerarquía de componentes de Tomcat.

# Mensajes del host "localhost" → van al handler 2 (localhost.FECHA.log)
org.apache.catalina.core.ContainerBase.[Catalina].[localhost].level   = INFO
org.apache.catalina.core.ContainerBase.[Catalina].[localhost].handlers = 2localhost.org.apache.juli.AsyncFileHandler

# Mensajes de la app /manager → van al handler 3 (manager.FECHA.log)
org.apache.catalina.core.ContainerBase.[Catalina].[localhost].[/manager].level   = INFO
org.apache.catalina.core.ContainerBase.[Catalina].[localhost].[/manager].handlers = 3manager.org.apache.juli.AsyncFileHandler

# Reducir el nivel de verbosidad de los conectores y de la red.
# Por defecto producen muchos mensajes de nivel INFO que no son útiles en producción.
org.apache.coyote.level = WARNING
org.apache.tomcat.util.net.level = WARNING
```

> 💡 **AsyncFileHandler vs FileHandler:** Tomcat usa `AsyncFileHandler` en lugar del `FileHandler` estándar de Java. La diferencia es que `AsyncFileHandler` escribe en disco en un hilo separado, de modo que las operaciones de logging no bloquean los hilos que procesan peticiones HTTP. Esto mejora el rendimiento bajo carga alta.

---

## 2.10 Tabla de Puertos por Defecto y su Función

Tomcat abre varios puertos al arrancar. Es importante saber para qué sirve cada uno y cuáles son riesgos de seguridad si quedan expuestos:

| Puerto | Protocolo | Componente          | Para qué sirve                                                    | Seguridad                        |
|--------|-----------|---------------------|-------------------------------------------------------------------|----------------------------------|
| 8005   | TCP       | Server shutdown     | Recibe la cadena "SHUTDOWN" para apagar Tomcat limpiamente        | ⚠️ Deshabilitar en producción (`port="-1"`) |
| 8080   | HTTP/1.1  | Connector HTTP      | Tráfico web sin cifrar (lo que ve el navegador)                   | ✅ Puerto público estándar        |
| 8443   | HTTPS     | Connector HTTPS     | Tráfico web cifrado con TLS (recomendado para producción)         | ✅ Puerto público estándar        |
| 8009   | AJP/1.3   | Connector AJP       | Comunicación entre Tomcat y Apache httpd (como reverse proxy)     | ⚠️ Deshabilitado por defecto en versiones modernas |
| 9090   | RMI/JMX   | JMX Remote          | Monitorización remota con JConsole, VisualVM, etc.                | ⚠️ Solo accesible desde red interna |

> ⚠️ **AJP y la vulnerabilidad Ghostcat (CVE-2020-1938):** En 2020 se descubrió una vulnerabilidad crítica en el conector AJP de Tomcat que permitía a un atacante leer archivos arbitrarios del servidor. Fue tan grave que recibió un nombre propio: "Ghostcat". Como resultado, el conector AJP está **deshabilitado por defecto** en Tomcat 9.0.31+, 8.5.51+ y versiones posteriores. Si necesitas usarlo (por ejemplo para integrarte con Apache httpd), actívalo solo en localhost y con autenticación:

```xml
<!-- AJP seguro — solo si es estrictamente necesario -->
<!-- address="127.0.0.1": solo acepta conexiones desde la misma máquina -->
<!-- requiredSecret: contraseña que debe incluir el cliente AJP en cada petición -->
<Connector protocol="AJP/1.3"
           address="127.0.0.1"
           port="8009"
           redirectPort="8443"
           requiredSecret="mi-secreto-ajp-seguro"
           secretRequired="true"/>
```

---

## Puntos Clave

- **Verificar siempre JDK ↔ Tomcat** antes de instalar. Tomcat 11 requiere Java 17 como mínimo. Un JDK incompatible produce errores de arranque inmediatos que pueden confundir.

- **Instalación desde binario oficial** en producción, verificando la firma SHA-512 y GPG. Los paquetes de `apt`/`dnf` suelen estar desactualizados.

- **Nunca ejecutar Tomcat como root.** Crear siempre un usuario dedicado (`useradd -r -s /bin/false tomcat`). Si Tomcat fuera comprometido, limita el daño posible.

- **Separar `CATALINA_HOME` y `CATALINA_BASE`** cuando necesites múltiples instancias en un servidor. Permite compartir binarios y actualizar en un solo punto.

- **Todo ajuste de JVM va en `setenv.sh`**, nunca en `catalina.sh`. Así tus configuraciones sobreviven a las actualizaciones de Tomcat.

- **Eliminar `docs/`, `examples/`** y restringir el acceso a `manager/` y `host-manager/` por IP inmediatamente tras la instalación. Son la primera superficie de ataque que buscan los escáneres automáticos.

- **El conector AJP debe deshabilitarse** si no se usa. Si se usa, configurar `address="127.0.0.1"` y `requiredSecret` para mitigar la vulnerabilidad Ghostcat (CVE-2020-1938).

- **Usar systemd en producción** con `TimeoutStopSec` configurado: garantiza paradas limpias, arranques automáticos tras reinicios del servidor y reinicio automático en caso de fallo del proceso.

- **Primer lugar para buscar errores:** `logs/catalina.out`. Busca líneas con `SEVERE` o `ERROR`. Si el arranque fue exitoso, la última línea importante es `Server startup in [XXXX] milliseconds`.