> **Estado:** 🟢 Completo
> **Última actualización:** 2026-05


- [Módulo 02: Instalación, Estructura de Directorios y Arranque](#módulo-02-instalación-estructura-de-directorios-y-arranque)
- [2.1 Requisitos Previos: JDK Compatible por Versión](#21-requisitos-previos-jdk-compatible-por-versión)
  - [Verificación del entorno](#verificación-del-entorno)
- [2.2 Métodos de Instalación](#22-métodos-de-instalación)
  - [2.2.1 Instalación desde binario (.zip / .tar.gz) — Recomendado para producción](#221-instalación-desde-binario-zip--targz--recomendado-para-producción)
    - [Linux / macOS](#linux--macos)
    - [Windows](#windows)
  - [2.2.2 Instalación via gestor de paquetes (apt/yum) — Solo desarrollo/testing](#222-instalación-via-gestor-de-paquetes-aptyum--solo-desarrollotesting)
  - [2.2.3 Instalación via Docker — Entornos containerizados](#223-instalación-via-docker--entornos-containerizados)
- [2.3 Estructura de Directorios Completa](#23-estructura-de-directorios-completa)
- [2.4 Separación CATALINA\_HOME vs CATALINA\_BASE](#24-separación-catalina_home-vs-catalina_base)
  - [Estructura para múltiples instancias](#estructura-para-múltiples-instancias)
  - [Script de arranque para instancia específica](#script-de-arranque-para-instancia-específica)
- [2.5 El Archivo setenv.sh / setenv.bat](#25-el-archivo-setenvsh--setenvbat)
  - [setenv.sh (Linux/macOS) — Configuración de producción completa](#setenvsh-linuxmacos--configuración-de-producción-completa)
  - [setenv.bat (Windows)](#setenvbat-windows)
- [2.6 Scripts de Arranque y Control](#26-scripts-de-arranque-y-control)
  - [2.6.1 Comandos principales](#261-comandos-principales)
  - [2.6.2 Integración con systemd (Linux — Producción)](#262-integración-con-systemd-linux--producción)
  - [2.6.3 Variable CATALINA\_PID](#263-variable-catalina_pid)
- [2.7 Configuración Inicial de Seguridad Post-Instalación](#27-configuración-inicial-de-seguridad-post-instalación)
  - [2.7.1 Eliminar aplicaciones por defecto](#271-eliminar-aplicaciones-por-defecto)
  - [2.7.2 Configurar tomcat-users.xml para Manager](#272-configurar-tomcat-usersxml-para-manager)
  - [2.7.3 Restringir acceso al Manager por IP](#273-restringir-acceso-al-manager-por-ip)
- [2.8 Verificación del Arranque](#28-verificación-del-arranque)
  - [2.8.1 Verificación via logs](#281-verificación-via-logs)
  - [2.8.2 Verificación via curl](#282-verificación-via-curl)
  - [2.8.3 Verificación de la JVM y Tomcat en ejecución](#283-verificación-de-la-jvm-y-tomcat-en-ejecución)
- [2.9 Gestión de Logs: JULI (Java Util Logging Implementation)](#29-gestión-de-logs-juli-java-util-logging-implementation)
  - [Configuración de logging.properties](#configuración-de-loggingproperties)
- [2.10 Tabla de Puertos por Defecto y su Función](#210-tabla-de-puertos-por-defecto-y-su-función)
- [Puntos Clave del Módulo 02](#puntos-clave-del-módulo-02)

---

## Módulo 02: Instalación, Estructura de Directorios y Arranque

## 2.1 Requisitos Previos: JDK Compatible por Versión

Antes de instalar Tomcat es imprescindible verificar la compatibilidad entre la versión de Tomcat y el JDK instalado. Usar un JDK inferior al mínimo requerido produce errores de arranque inmediatos.

| Tomcat | JDK Mínimo | JDK Recomendado (Producción) | JDK Máximo Verificado |
|--------|------------|------------------------------|-----------------------|
| 8.0    | Java 7     | Java 8 LTS                   | Java 11               |
| 8.5    | Java 7     | Java 11 LTS                  | Java 17               |
| 9.0    | Java 8     | Java 11 LTS / Java 17 LTS    | Java 21               |
| 10.0   | Java 8     | Java 11 LTS / Java 17 LTS    | Java 21               |
| 10.1   | Java 11    | Java 17 LTS / Java 21 LTS    | Java 21               |
| 11.0   | Java 17    | Java 21 LTS                  | Java 21+              |

### Verificación del entorno

```bash
# Verificar versión de Java instalada
java -version
javac -version

# Verificar JAVA_HOME
echo $JAVA_HOME          # Linux/macOS
echo %JAVA_HOME%         # Windows CMD

# Verificar que apunta al JDK y no solo al JRE
ls $JAVA_HOME/bin/javac  # Debe existir
```

---

## 2.2 Métodos de Instalación

### 2.2.1 Instalación desde binario (.zip / .tar.gz) — Recomendado para producción

Es el método más controlado y portable. Permite tener múltiples instancias y versiones coexistiendo.

#### Linux / macOS

```bash
# 1. Definir variables de entorno
export TOMCAT_VERSION=10.1.20
export TOMCAT_MAJOR=10
export INSTALL_DIR=/opt

# 2. Descargar desde Apache (verificar siempre la firma GPG)
cd /tmp
wget https://downloads.apache.org/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz
wget https://downloads.apache.org/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz.asc
wget https://downloads.apache.org/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz.sha512

# 3. Verificar integridad SHA-512
sha512sum -c apache-tomcat-${TOMCAT_VERSION}.tar.gz.sha512

# 4. Verificar firma GPG (recomendado en producción)
gpg --import https://downloads.apache.org/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/KEYS
gpg --verify apache-tomcat-${TOMCAT_VERSION}.tar.gz.asc

# 5. Descomprimir e instalar
tar -xzf apache-tomcat-${TOMCAT_VERSION}.tar.gz -C ${INSTALL_DIR}
ln -s ${INSTALL_DIR}/apache-tomcat-${TOMCAT_VERSION} ${INSTALL_DIR}/tomcat

# 6. Crear usuario dedicado (nunca ejecutar Tomcat como root)
useradd -r -m -U -d /opt/tomcat -s /bin/false tomcat
chown -R tomcat:tomcat ${INSTALL_DIR}/apache-tomcat-${TOMCAT_VERSION}
chmod -R 750 ${INSTALL_DIR}/apache-tomcat-${TOMCAT_VERSION}

# 7. Permisos específicos para scripts de arranque
chmod +x ${INSTALL_DIR}/tomcat/bin/*.sh

# 8. Configurar variables de entorno del sistema
cat >> /etc/environment << 'EOF'
JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
CATALINA_HOME=/opt/tomcat
CATALINA_BASE=/opt/tomcat
EOF

source /etc/environment
```

#### Windows

```batch
REM 1. Descargar apache-tomcat-10.1.20-windows-x64.zip desde https://tomcat.apache.org

REM 2. Descomprimir en C:\opt\tomcat

REM 3. Configurar variables de entorno (como Administrador)
setx JAVA_HOME "C:\Program Files\Eclipse Adoptium\jdk-17.0.9.9-hotspot" /M
setx CATALINA_HOME "C:\opt\tomcat" /M

REM 4. Instalar como servicio Windows (usando service.bat incluido)
cd C:\opt\tomcat\bin
service.bat install TomcatService

REM 5. Arrancar el servicio
net start TomcatService
```

---

### 2.2.2 Instalación via gestor de paquetes (apt/yum) — Solo desarrollo/testing

```bash
# Ubuntu/Debian — Tomcat 10
sudo apt update
sudo apt install -y tomcat10 tomcat10-admin

# CentOS/RHEL/Rocky Linux — Tomcat 9 (el disponible en repos oficiales varía)
sudo dnf install -y tomcat

# Verificar instalación
sudo systemctl status tomcat10
```

> ⚠️ **Advertencia:** Los paquetes de los gestores de distribución suelen ir con versiones desactualizadas y con una estructura de directorios diferente a la instalación oficial. **No recomendado para producción.**

---

### 2.2.3 Instalación via Docker — Entornos containerizados

```dockerfile
# Dockerfile para Tomcat 10.1 con Java 17
FROM tomcat:10.1.20-jdk17-temurin

# Eliminar aplicaciones por defecto (seguridad)
RUN rm -rf /usr/local/tomcat/webapps/ROOT \
           /usr/local/tomcat/webapps/examples \
           /usr/local/tomcat/webapps/docs \
           /usr/local/tomcat/webapps/host-manager \
           /usr/local/tomcat/webapps/manager

# Copiar configuración personalizada
COPY conf/server.xml /usr/local/tomcat/conf/server.xml
COPY conf/context.xml /usr/local/tomcat/conf/context.xml
COPY conf/catalina.properties /usr/local/tomcat/conf/catalina.properties
COPY conf/logging.properties /usr/local/tomcat/conf/logging.properties

# Copiar aplicación
COPY target/myapp.war /usr/local/tomcat/webapps/myapp.war

# Configurar usuario no root
RUN groupadd -r tomcat && useradd -r -g tomcat tomcat
RUN chown -R tomcat:tomcat /usr/local/tomcat
USER tomcat

# Variables de entorno de JVM
ENV JAVA_OPTS="-Xms512m -Xmx1024m -XX:+UseG1GC \
               -Djava.security.egd=file:/dev/./urandom \
               -Dfile.encoding=UTF-8"

EXPOSE 8080 8443
CMD ["catalina.sh", "run"]
```

```yaml
# docker-compose.yml para entorno completo
version: '3.8'

services:
  tomcat:
    build: .
    container_name: tomcat-app
    ports:
      - "8080:8080"
      - "8443:8443"
    volumes:
      - tomcat-logs:/usr/local/tomcat/logs
      - tomcat-work:/usr/local/tomcat/work
    environment:
      - JAVA_OPTS=-Xms512m -Xmx2g -XX:+UseG1GC
      - TZ=Europe/Madrid
    restart: unless-stopped
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

La instalación estándar de Tomcat produce la siguiente estructura. Comprender cada directorio es esencial para operar el servidor correctamente.

```
$CATALINA_HOME/
├── bin/                        ← Scripts de control y arranque
│   ├── catalina.sh             ← Script principal (Linux/macOS)
│   ├── catalina.bat            ← Script principal (Windows)
│   ├── startup.sh              ← Atajo: arranca Tomcat en background
│   ├── shutdown.sh             ← Atajo: detiene Tomcat
│   ├── version.sh              ← Muestra versión de Tomcat y Java
│   ├── digest.sh               ← Genera hashes de passwords para Realms
│   ├── tool-wrapper.sh         ← Wrapper genérico para herramientas Tomcat
│   ├── setenv.sh               ← ⭐ CREADO POR EL ADMIN: variables de entorno
│   ├── tomcat-juli.jar         ← Librería de logging de Tomcat (JULI)
│   └── bootstrap.jar           ← Bootstrap de arranque de Tomcat
│
├── conf/                       ← Archivos de configuración
│   ├── server.xml              ← ⭐ Configuración principal del servidor
│   ├── web.xml                 ← Configuración global de Servlets/Filtros
│   ├── context.xml             ← Configuración global de Context
│   ├── tomcat-users.xml        ← Usuarios para Manager/MemoryRealm
│   ├── catalina.properties     ← Propiedades del sistema y ClassLoader
│   ├── catalina.policy         ← Política de seguridad Java (SecurityManager)
│   ├── jaspic-providers.xml    ← Proveedores JASPIC (Jakarta Auth)
│   ├── logging.properties      ← Configuración de logging JULI
│   └── Catalina/               ← Configuración por Engine/Host
│       └── localhost/          ← Descriptores de Context individuales
│           ├── myapp.xml       ← Context descriptor para /myapp
│           └── ROOT.xml        ← Context descriptor para /
│
├── lib/                        ← Librerías del Common ClassLoader
│   ├── catalina.jar            ← Core de Tomcat Catalina
│   ├── catalina-ant.jar        ← Tareas Ant para Tomcat
│   ├── catalina-ha.jar         ← High Availability / Clustering
│   ├── catalina-ssi.jar        ← Server Side Includes
│   ├── catalina-storeconfig.jar← Persistencia de configuración
│   ├── catalina-tribes.jar     ← Comunicación en cluster (Tribes)
│   ├── ecj-X.X.X.jar          ← Compilador Eclipse para JSPs
│   ├── el-api.jar              ← API Expression Language
│   ├── jasper.jar              ← Motor JSP (Jasper)
│   ├── jasper-el.jar           ← EL para Jasper
│   ├── jsp-api.jar             ← API JSP
│   ├── servlet-api.jar         ← API Servlet (javax.* o jakarta.*)
│   ├── websocket-api.jar       ← API WebSocket
│   ├── tomcat-api.jar          ← API interna de Tomcat
│   ├── tomcat-coyote.jar       ← Coyote (conectores HTTP/AJP)
│   ├── tomcat-dbcp.jar         ← Pool de conexiones DBCP2
│   ├── tomcat-jdbc.jar         ← Pool de conexiones Tomcat JDBC
│   ├── tomcat-jni.jar          ← JNI para APR/Native
│   ├── tomcat-util.jar         ← Utilidades de Tomcat
│   └── tomcat-websocket.jar    ← Implementación WebSocket
│
├── logs/                       ← Archivos de log
│   ├── catalina.out            ← Log principal de stdout/stderr
│   ├── catalina.YYYY-MM-DD.log ← Log del servidor (rotado diariamente)
│   ├── localhost.YYYY-MM-DD.log← Log del host virtual
│   ├── manager.YYYY-MM-DD.log  ← Log de la app Manager
│   ├── host-manager.YYYY-MM-DD.log ← Log del Host Manager
│   └── localhost_access_log.YYYY-MM-DD.txt ← Access log HTTP
│
├── temp/                       ← Archivos temporales de la JVM
│
├── webapps/                    ← Directorio de despliegue (appBase del Host)
│   ├── ROOT/                   ← Aplicación raíz (path "/")
│   ├── docs/                   ← Documentación de Tomcat (eliminar en prod)
│   ├── examples/               ← Ejemplos Servlet/JSP (eliminar en prod)
│   ├── host-manager/           ← App de gestión de Virtual Hosts
│   ├── manager/                ← App de gestión de aplicaciones
│   └── myapp/                  ← Tu aplicación desplegada
│       ├── WEB-INF/
│       │   ├── web.xml
│       │   ├── classes/
│       │   └── lib/
│       └── index.html
│
└── work/                       ← Clases compiladas de JSPs y trabajo interno
    └── Catalina/
        └── localhost/
            └── myapp/
                └── org/apache/jsp/  ← JSPs compilados a .class
```

---

## 2.4 Separación CATALINA_HOME vs CATALINA_BASE

Este es uno de los conceptos más importantes para gestionar múltiples instancias de Tomcat en el mismo servidor (multitenancy).

| Variable        | Descripción                                                         |
|-----------------|---------------------------------------------------------------------|
| `CATALINA_HOME` | Directorio de la **instalación binaria** de Tomcat (solo lectura)  |
| `CATALINA_BASE` | Directorio de la **instancia específica** (configuración + datos)  |

Cuando son el mismo directorio (instalación simple), Tomcat los trata como uno. Cuando se separan, se permite reutilizar los binarios con múltiples configuraciones.

### Estructura para múltiples instancias

```
/opt/tomcat-binaries/          ← CATALINA_HOME (compartido, solo lectura)
├── bin/
└── lib/

/opt/instances/
├── instance-app1/             ← CATALINA_BASE de la instancia 1
│   ├── conf/
│   │   ├── server.xml         ← Puerto 8080
│   │   ├── web.xml
│   │   ├── context.xml
│   │   └── tomcat-users.xml
│   ├── logs/
│   ├── temp/
│   ├── webapps/
│   │   └── app1.war
│   └── work/
│
└── instance-app2/             ← CATALINA_BASE de la instancia 2
    ├── conf/
    │   ├── server.xml         ← Puerto 8090
    │   ├── web.xml
    │   ├── context.xml
    │   └── tomcat-users.xml
    ├── logs/
    ├── temp/
    ├── webapps/
    │   └── app2.war
    └── work/
```

### Script de arranque para instancia específica

```bash
#!/bin/bash
# /opt/instances/instance-app1/bin/start.sh

export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export CATALINA_HOME=/opt/tomcat-binaries
export CATALINA_BASE=/opt/instances/instance-app1

# JVM options específicas para esta instancia
export CATALINA_OPTS="-Xms512m -Xmx2g -XX:+UseG1GC \
  -XX:MaxGCPauseMillis=200 \
  -Dapp.environment=production \
  -Dapp.instance=app1"

$CATALINA_HOME/bin/startup.sh
```

---

## 2.5 El Archivo setenv.sh / setenv.bat

Es el lugar **correcto y oficial** para definir variables de entorno de Tomcat. Tomcat lo carga automáticamente desde `$CATALINA_BASE/bin/setenv.sh` si existe. **Nunca modificar `catalina.sh` directamente.**

### setenv.sh (Linux/macOS) — Configuración de producción completa

```bash
#!/bin/bash
# $CATALINA_BASE/bin/setenv.sh
# Tomcat Environment Configuration — Producción
# ================================================

# --- JVM Memory Settings ---
CATALINA_OPTS="$CATALINA_OPTS -Xms1g"                    # Heap inicial
CATALINA_OPTS="$CATALINA_OPTS -Xmx4g"                    # Heap máximo
CATALINA_OPTS="$CATALINA_OPTS -XX:MetaspaceSize=256m"    # Metaspace inicial
CATALINA_OPTS="$CATALINA_OPTS -XX:MaxMetaspaceSize=512m" # Metaspace máximo

# --- Garbage Collector (G1GC — Java 9+ default, recomendado) ---
CATALINA_OPTS="$CATALINA_OPTS -XX:+UseG1GC"
CATALINA_OPTS="$CATALINA_OPTS -XX:MaxGCPauseMillis=200"
CATALINA_OPTS="$CATALINA_OPTS -XX:G1HeapRegionSize=16m"
CATALINA_OPTS="$CATALINA_OPTS -XX:G1NewSizePercent=20"
CATALINA_OPTS="$CATALINA_OPTS -XX:G1MaxNewSizePercent=40"
CATALINA_OPTS="$CATALINA_OPTS -XX:InitiatingHeapOccupancyPercent=45"

# --- GC Logging (Java 9+ unified logging) ---
CATALINA_OPTS="$CATALINA_OPTS -Xlog:gc*:file=${CATALINA_BASE}/logs/gc.log:time,uptime,level,tags:filecount=10,filesize=20m"

# --- JVM Performance ---
CATALINA_OPTS="$CATALINA_OPTS -server"
CATALINA_OPTS="$CATALINA_OPTS -XX:+OptimizeStringConcat"
CATALINA_OPTS="$CATALINA_OPTS -XX:+UseStringDeduplication"

# --- Encoding ---
CATALINA_OPTS="$CATALINA_OPTS -Dfile.encoding=UTF-8"
CATALINA_OPTS="$CATALINA_OPTS -Dsun.jnu.encoding=UTF-8"

# --- Timezone ---
CATALINA_OPTS="$CATALINA_OPTS -Duser.timezone=Europe/Madrid"

# --- Seguridad: deshabilitar DNS caching agresivo ---
CATALINA_OPTS="$CATALINA_OPTS -Dsun.net.inetaddr.ttl=60"
CATALINA_OPTS="$CATALINA_OPTS -Dsun.net.inetaddr.negative.ttl=10"

# --- Generador de números aleatorios (evita bloqueos en Linux) ---
CATALINA_OPTS="$CATALINA_OPTS -Djava.security.egd=file:/dev/./urandom"

# --- JMX Remoto (para monitorización con JConsole/VisualVM) ---
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote"
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.port=9090"
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.ssl=false"
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.authenticate=true"
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.password.file=${CATALINA_BASE}/conf/jmxremote.password"
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.access.file=${CATALINA_BASE}/conf/jmxremote.access"

# --- Heap Dump en OutOfMemoryError ---
CATALINA_OPTS="$CATALINA_OPTS -XX:+HeapDumpOnOutOfMemoryError"
CATALINA_OPTS="$CATALINA_OPTS -XX:HeapDumpPath=${CATALINA_BASE}/logs/heapdump.hprof"

# --- Acción post-OOM: reiniciar el proceso ---
CATALINA_OPTS="$CATALINA_OPTS -XX:OnOutOfMemoryError='kill -9 %p'"

# --- Variables de aplicación ---
CATALINA_OPTS="$CATALINA_OPTS -Dapp.environment=production"
CATALINA_OPTS="$CATALINA_OPTS -Dapp.config.dir=/opt/config/myapp"

export CATALINA_OPTS
```

### setenv.bat (Windows)

```batch
@echo off
REM %CATALINA_BASE%\bin\setenv.bat

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

```bash
# Arrancar Tomcat en background (logs → catalina.out)
$CATALINA_HOME/bin/startup.sh

# Arrancar en foreground (útil para debugging, Docker)
$CATALINA_HOME/bin/catalina.sh run

# Detener Tomcat limpiamente
$CATALINA_HOME/bin/shutdown.sh

# Detener con timeout (esperar 10s y forzar si no responde)
$CATALINA_HOME/bin/shutdown.sh 10 -force

# Ver versión
$CATALINA_HOME/bin/version.sh

# Generar hash de password para tomcat-users.xml
$CATALINA_HOME/bin/digest.sh -a SHA-256 -h org.apache.catalina.realm.MessageDigestCredentialHandler mipassword
```

### 2.6.2 Integración con systemd (Linux — Producción)

```ini
# /etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat 10 Web Application Server
After=network.target
Wants=network-online.target

[Service]
Type=forking
User=tomcat
Group=tomcat

# Variables de entorno
Environment="JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_BASE=/opt/tomcat"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512m -Xmx2g -XX:+UseG1GC \
  -Dfile.encoding=UTF-8 \
  -Djava.security.egd=file:/dev/./urandom"

# Scripts de arranque y parada
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh 30 -force

# Tiempo de espera para parada limpia
TimeoutStopSec=30

# Reinicio automático en fallo
Restart=on-failure
RestartSec=10s

# Límites del proceso
LimitNOFILE=65536
LimitNPROC=4096

# Seguridad adicional
NoNewPrivileges=true
ProtectSystem=strict
ReadWritePaths=/opt/tomcat/logs /opt/tomcat/work /opt/tomcat/temp /opt/tomcat/webapps

[Install]
WantedBy=multi-user.target
```

```bash
# Habilitar e iniciar el servicio
sudo systemctl daemon-reload
sudo systemctl enable tomcat
sudo systemctl start tomcat

# Verificar estado
sudo systemctl status tomcat

# Ver logs en tiempo real
sudo journalctl -u tomcat -f

# Reiniciar
sudo systemctl restart tomcat
```

### 2.6.3 Variable CATALINA_PID

Permite a Tomcat gestionar correctamente el PID del proceso para operaciones de shutdown.

```bash
# Añadir en setenv.sh
export CATALINA_PID="$CATALINA_BASE/temp/tomcat.pid"
```

---

## 2.7 Configuración Inicial de Seguridad Post-Instalación

Inmediatamente después de instalar Tomcat, se deben aplicar estas medidas de seguridad antes de arrancar en producción.

### 2.7.1 Eliminar aplicaciones por defecto

```bash
cd $CATALINA_HOME/webapps

# Eliminar completamente en producción
rm -rf docs/
rm -rf examples/
rm -rf ROOT/           # Si no usas la app raíz

# Mantener manager y host-manager SOLO si son necesarios
# y con IPs restringidas en context.xml
```

### 2.7.2 Configurar tomcat-users.xml para Manager

```xml
<!-- conf/tomcat-users.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<tomcat-users xmlns="http://tomcat.apache.org/xml"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"
              version="1.0">

  <!-- Roles disponibles para Manager -->
  <role rolename="manager-gui"/>     <!-- Acceso a la interfaz web -->
  <role rolename="manager-script"/>  <!-- Acceso vía API REST/Ant -->
  <role rolename="manager-jmx"/>     <!-- Acceso vía JMX proxy -->
  <role rolename="manager-status"/>  <!-- Solo lectura de estado -->
  <role rolename="admin-gui"/>       <!-- Host Manager web UI -->
  <role rolename="admin-script"/>    <!-- Host Manager script -->

  <!-- Usuario con password hasheado (SHA-256) -->
  <!-- Hash generado con: bin/digest.sh -a SHA-256 -h org.apache.catalina.realm.MessageDigestCredentialHandler admin123 -->
  <user username="tomcat-admin"
        password="8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918"
        roles="manager-gui,manager-status,admin-gui"/>

  <user username="deployer"
        password="5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8"
        roles="manager-script"/>

</tomcat-users>
```

### 2.7.3 Restringir acceso al Manager por IP

```xml
<!-- webapps/manager/META-INF/context.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<Context antiResourceLocking="false" privileged="true">

  <!-- Permitir solo acceso desde localhost y red interna -->
  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|192\.168\.1\.\d+|10\.0\.0\.\d+"
         denyStatus="403"/>

  <!-- Evitar que la cookie del manager sea accesible desde JS -->
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

```bash
# Seguir el log principal de arranque
tail -f $CATALINA_BASE/logs/catalina.out

# Líneas clave que deben aparecer en un arranque correcto:
# INFO: Server version name: Apache Tomcat/10.1.20
# INFO: Starting service [Catalina]
# INFO: Starting Servlet engine: [Apache Tomcat/10.1.20]
# INFO: Deployment of web application directory [.../webapps/ROOT] has finished
# INFO: Starting ProtocolHandler ["http-nio-8080"]
# INFO: Server startup in [XXXX] milliseconds
```

### 2.8.2 Verificación via curl

```bash
# Verificar que responde en HTTP
curl -v http://localhost:8080/

# Verificar código de respuesta
curl -o /dev/null -s -w "%{http_code}" http://localhost:8080/

# Verificar HTTPS (ignorar certificado self-signed en pruebas)
curl -k -v https://localhost:8443/

# Verificar estado via Manager API
curl -u deployer:password http://localhost:8080/manager/text/list

# Verificar que el puerto está escuchando
ss -tlnp | grep 8080
netstat -tlnp | grep 8080
```

### 2.8.3 Verificación de la JVM y Tomcat en ejecución

```bash
# Ver proceso Tomcat
ps aux | grep catalina

# Ver parámetros JVM con los que arrancó
ps -ef | grep java | grep tomcat

# Ver puertos abiertos por Tomcat
lsof -i -P -n | grep java

# Ver versión exacta de Tomcat
$CATALINA_HOME/bin/version.sh
```

Salida esperada de `version.sh`:

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

---

## 2.9 Gestión de Logs: JULI (Java Util Logging Implementation)

Tomcat utiliza su propia implementación de `java.util.logging` llamada **JULI** (Java Util Logging Implementation), que añade soporte para `FileHandler` por aplicación y rotación de logs.

### Configuración de logging.properties

```properties
# $CATALINA_BASE/conf/logging.properties

# Handlers globales
handlers = 1catalina.org.apache.juli.AsyncFileHandler, \
           2localhost.org.apache.juli.AsyncFileHandler, \
           3manager.org.apache.juli.AsyncFileHandler, \
           java.util.logging.ConsoleHandler

# Nivel global
.level = INFO

# --- Handler: catalina (log del servidor) ---
1catalina.org.apache.juli.AsyncFileHandler.level     = FINE
1catalina.org.apache.juli.AsyncFileHandler.directory = ${catalina.base}/logs
1catalina.org.apache.juli.AsyncFileHandler.prefix    = catalina.
1catalina.org.apache.juli.AsyncFileHandler.suffix    = .log
1catalina.org.apache.juli.AsyncFileHandler.maxDays   = 90
1catalina.org.apache.juli.AsyncFileHandler.encoding  = UTF-8
1catalina.org.apache.juli.AsyncFileHandler.bufferSize = 8192

# --- Handler: localhost (log del host) ---
2localhost.org.apache.juli.AsyncFileHandler.level     = FINE
2localhost.org.apache.juli.AsyncFileHandler.directory = ${catalina.base}/logs
2localhost.org.apache.juli.AsyncFileHandler.prefix    = localhost.
2localhost.org.apache.juli.AsyncFileHandler.suffix    = .log
2localhost.org.apache.juli.AsyncFileHandler.maxDays   = 90
2localhost.org.apache.juli.AsyncFileHandler.encoding  = UTF-8

# --- Handler: manager ---
3manager.org.apache.juli.AsyncFileHandler.level     = FINE
3manager.org.apache.juli.AsyncFileHandler.directory = ${catalina.base}/logs
3manager.org.apache.juli.AsyncFileHandler.prefix    = manager.
3manager.org.apache.juli.AsyncFileHandler.suffix    = .log
3manager.org.apache.juli.AsyncFileHandler.maxDays   = 30

# --- Consola (para Docker/systemd journald) ---
java.util.logging.ConsoleHandler.level     = FINE
java.util.logging.ConsoleHandler.formatter = org.apache.juli.OneLineFormatter
java.util.logging.ConsoleHandler.encoding  = UTF-8

# --- Loggers por componente ---
org.apache.catalina.core.ContainerBase.[Catalina].[localhost].level   = INFO
org.apache.catalina.core.ContainerBase.[Catalina].[localhost].handlers = 2localhost.org.apache.juli.AsyncFileHandler

org.apache.catalina.core.ContainerBase.[Catalina].[localhost].[/manager].level   = INFO
org.apache.catalina.core.ContainerBase.[Catalina].[localhost].[/manager].handlers = 3manager.org.apache.juli.AsyncFileHandler

# Reducir verbosidad de componentes específicos
org.apache.coyote.level = WARNING
org.apache.tomcat.util.net.level = WARNING
```

---

## 2.10 Tabla de Puertos por Defecto y su Función

| Puerto | Protocolo | Componente          | Descripción                                      |
|--------|-----------|---------------------|--------------------------------------------------|
| 8005   | TCP       | Server shutdown     | Recibe el comando de apagado (deshabilitar en prod) |
| 8080   | HTTP/1.1  | Connector HTTP      | Tráfico web no cifrado                           |
| 8443   | HTTPS     | Connector HTTPS     | Tráfico web cifrado (TLS)                        |
| 8009   | AJP/1.3   | Connector AJP       | Comunicación con Apache httpd (mod_jk/mod_proxy_ajp) |
| 9090   | RMI/JMX   | JMX Remote          | Monitorización remota vía JMX                    |

> ⚠️ **AJP en Tomcat 9.0.31+:** Tras la vulnerabilidad **Ghostcat (CVE-2020-1938)**, el conector AJP está **deshabilitado por defecto** en Tomcat 9.0.31+, 8.5.51+ y versiones posteriores. Si se necesita, configurar obligatoriamente `requiredSecret` o restringir la dirección de escucha.

```xml
<!-- AJP seguro — solo si es necesario -->
<Connector protocol="AJP/1.3"
           address="127.0.0.1"
           port="8009"
           redirectPort="8443"
           requiredSecret="mi-secreto-ajp-seguro"
           secretRequired="true"/>
```

---

## Puntos Clave del Módulo 02

- Verificar siempre la compatibilidad **JDK ↔ Tomcat** antes de instalar. Tomcat 11 requiere Java 17 como mínimo.
- Usar siempre la **instalación desde binario oficial** en producción, verificando la firma SHA-512 y GPG.
- **Nunca ejecutar Tomcat como root.** Crear siempre un usuario dedicado sin shell interactivo.
- Separar `CATALINA_HOME` y `CATALINA_BASE` para gestionar múltiples instancias con un único binario.
- Todo ajuste de JVM va en **`setenv.sh`**, nunca en `catalina.sh`.
- Eliminar `docs/`, `examples/` y restringir el acceso a `manager/` y `host-manager/` inmediatamente tras la instalación.
- El conector **AJP debe deshabilitarse** si no se usa, especialmente en versiones anteriores a los parches de Ghostcat.
- Usar **systemd** para gestionar el ciclo de vida en producción Linux, con `TimeoutStopSec` configurado para paradas limpias.
