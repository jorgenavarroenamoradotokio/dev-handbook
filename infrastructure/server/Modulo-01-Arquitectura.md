> **Estado:** 🟢 Completo
> **Última actualización:** 2026-05


- [Módulo 01: Arquitectura Interna y Componentes del](#módulo-01-arquitectura-interna-y-componentes-del)
- [1.1 Visión General de la Arquitectura](#11-visión-general-de-la-arquitectura)
  - [Evolución de especificaciones por versión](#evolución-de-especificaciones-por-versión)
- [1.2 Modelo Jerárquico de Componentes](#12-modelo-jerárquico-de-componentes)
  - [Representación en `server.xml`](#representación-en-serverxml)
- [1.3 Descripción Detallada de Cada Componente](#13-descripción-detallada-de-cada-componente)
  - [1.3.1 Server](#131-server)
  - [1.3.2 Service](#132-service)
  - [1.3.3 Connector](#133-connector)
  - [1.3.4 Engine](#134-engine)
  - [1.3.5 Host](#135-host)
  - [1.3.6 Context](#136-context)
  - [1.3.7 Wrapper](#137-wrapper)
- [1.4 Pipelines, Valves y la Cadena de Procesamiento](#14-pipelines-valves-y-la-cadena-de-procesamiento)
  - [Valves más importantes](#valves-más-importantes)
  - [Ejemplo: Configuración de Valves avanzada](#ejemplo-configuración-de-valves-avanzada)
  - [Archivo `rewrite.config` (para RewriteValve)](#archivo-rewriteconfig-para-rewritevalve)
- [1.5 El Cargador de Clases (ClassLoader) de Tomcat](#15-el-cargador-de-clases-classloader-de-tomcat)
  - [Reglas de visibilidad](#reglas-de-visibilidad)
  - [Configuración en `conf/catalina.properties`](#configuración-en-confcatalinaproperties)
- [1.6 Ciclo de Vida de los Componentes (Lifecycle)](#16-ciclo-de-vida-de-los-componentes-lifecycle)
  - [Estados del ciclo de vida](#estados-del-ciclo-de-vida)
  - [Eventos del Lifecycle](#eventos-del-lifecycle)
  - [Listeners incluidos en Tomcat por defecto](#listeners-incluidos-en-tomcat-por-defecto)
- [1.7 Componentes de Soporte: Realm, Manager y Store](#17-componentes-de-soporte-realm-manager-y-store)
  - [1.7.1 Realm (Seguridad)](#171-realm-seguridad)
  - [1.7.2 Manager (Gestión de Sesiones)](#172-manager-gestión-de-sesiones)
- [1.8 Resumen Visual de la Arquitectura Completa](#18-resumen-visual-de-la-arquitectura-completa)
- [1.9 Diferencias Arquitectónicas entre Versiones](#19-diferencias-arquitectónicas-entre-versiones)
- [Puntos Clave del Módulo 01](#puntos-clave-del-módulo-01)

---

## Módulo 01: Arquitectura Interna y Componentes del 

## 1.1 Visión General de la Arquitectura

Apache Tomcat es un **contenedor de Servlets** y **servidor web** de código abierto mantenido por la Apache Software Foundation. Su arquitectura está diseñada sobre un modelo jerárquico de componentes anidados que se comunican a través de interfaces bien definidas.

A diferencia de servidores de aplicaciones completos (WildFly, WebLogic), Tomcat es un contenedor ligero: implementa las especificaciones de **Servlet, JSP, EL y WebSocket**, pero no implementa EJB, JMS ni otras APIs de Jakarta EE completo.

### Evolución de especificaciones por versión

| Tomcat | Servlet | JSP | EL  | WebSocket | Java mínimo | Namespace API         |
|--------|---------|-----|-----|-----------|-------------|-----------------------|
| 8.0    | 3.1     | 2.3 | 3.0 | 1.0       | Java 7      | `javax.*`             |
| 8.5    | 3.1     | 2.3 | 3.0 | 1.1       | Java 7      | `javax.*`             |
| 9.0    | 4.0     | 2.3 | 3.0 | 1.1       | Java 8      | `javax.*`             |
| 10.0   | 5.0     | 3.0 | 4.0 | 2.0       | Java 8      | `jakarta.*`           |
| 10.1   | 6.0     | 3.1 | 5.0 | 2.1       | Java 11     | `jakarta.*`           |
| 11.0   | 6.1     | 4.0 | 6.0 | 2.2       | Java 17     | `jakarta.*`           |

> ⚠️ **Punto crítico de migración:** A partir de Tomcat 10.0, el namespace de las APIs cambia de `javax.*` a `jakarta.*`. Las aplicaciones compiladas contra `javax.servlet.*` NO son compatibles con Tomcat 10+ sin recompilación o uso de la herramienta **Migration Tool for Jakarta EE**.

---

## 1.2 Modelo Jerárquico de Componentes

La arquitectura de Tomcat se estructura como un árbol de componentes definidos en `server.xml`. Cada componente tiene un rol específico y se anida dentro de otro siguiendo una jerarquía estricta.

```
Server
└── Service
    ├── Connector (HTTP/1.1)
    ├── Connector (HTTP/2 / AJP)
    └── Engine
        └── Host (VirtualHost)
            ├── Context (WebApp 1)
            │   ├── Wrapper (Servlet 1)
            │   └── Wrapper (Servlet 2)
            └── Context (WebApp 2)
                └── Wrapper (Servlet N)
```

### Representación en `server.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Server port="8005" shutdown="SHUTDOWN">

  <Service name="Catalina">

    <!-- Conector HTTP/1.1 NIO -->
    <Connector port="8080"
               protocol="org.apache.coyote.http11.Http11NioProtocol"
               connectionTimeout="20000"
               redirectPort="8443"
               maxThreads="200"
               minSpareThreads="10"/>

    <!-- Conector HTTPS (TLS) -->
    <Connector port="8443"
               protocol="org.apache.coyote.http11.Http11NioProtocol"
               SSLEnabled="true"
               maxThreads="150"
               scheme="https"
               secure="true">
      <SSLHostConfig>
        <Certificate certificateKeystoreFile="conf/keystore.jks"
                     certificateKeystorePassword="changeit"
                     type="RSA"/>
      </SSLHostConfig>
    </Connector>

    <Engine name="Catalina" defaultHost="localhost">

      <Host name="localhost"
            appBase="webapps"
            unpackWARs="true"
            autoDeploy="true">

        <Context path="/myapp"
                 docBase="/opt/apps/myapp"
                 reloadable="false">
        </Context>

      </Host>

    </Engine>
  </Service>
</Server>
```

---

## 1.3 Descripción Detallada de Cada Componente

### 1.3.1 Server

Es el componente raíz. Representa la instancia completa de Tomcat. Solo puede existir **un único elemento `<Server>`** por instancia.

**Atributos clave:**

| Atributo   | Descripción                                                        | Valor por defecto |
|------------|--------------------------------------------------------------------|-------------------|
| `port`     | Puerto donde escucha el comando de shutdown via socket TCP         | `8005`            |
| `shutdown`  | Cadena de texto que Tomcat espera para apagarse limpiamente        | `SHUTDOWN`        |
| `address`  | Dirección IP en la que escucha el comando de shutdown              | `localhost`       |

> ⚠️ **Seguridad:** En producción se recomienda establecer `port="-1"` para deshabilitar el puerto de shutdown por socket, y usar scripts de control del sistema operativo (`systemd`) en su lugar.

```xml
<!-- Producción: puerto shutdown deshabilitado -->
<Server port="-1" shutdown="SHUTDOWN">
```

---

### 1.3.2 Service

Agrupa uno o más **Connectors** con un único **Engine**. El nombre más común es `Catalina`. Se pueden definir múltiples `<Service>` dentro de un `<Server>` para aislar grupos de conectores con sus propios engines.

```xml
<Service name="Catalina">
  <!-- Conectores y Engine aquí -->
</Service>
```

---

### 1.3.3 Connector

Es el punto de entrada de las peticiones HTTP/HTTPS/AJP. Gestiona las conexiones de red a bajo nivel. En Tomcat 8+ existen tres implementaciones principales del protocolo:

| Implementación                                          | Descripción                                     | Disponible desde |
|---------------------------------------------------------|-------------------------------------------------|------------------|
| `org.apache.coyote.http11.Http11NioProtocol`            | NIO (Non-blocking I/O) — **recomendado**        | Tomcat 6+        |
| `org.apache.coyote.http11.Http11Nio2Protocol`           | NIO2 (Asynchronous I/O)                         | Tomcat 8.0+      |
| `org.apache.coyote.http11.Http11AprProtocol`            | APR/Native (usa librerías nativas OpenSSL)      | Tomcat 5.5+      |
| `org.apache.coyote.http11.Http11BioProtocol`            | BIO (Blocking I/O) — **eliminado en Tomcat 9**  | Hasta Tomcat 8.5 |

> ⚠️ **BIO eliminado:** El protocolo `Http11BioProtocol` fue **deprecado en Tomcat 8.5** y **eliminado en Tomcat 9.0**. Si migras desde Tomcat 8.0 con BIO, debes actualizar a NIO o NIO2.

**Atributos de rendimiento del Connector:**

```xml
<Connector port="8080"
           protocol="org.apache.coyote.http11.Http11NioProtocol"
           connectionTimeout="20000"
           keepAliveTimeout="30000"
           maxKeepAliveRequests="100"
           maxThreads="400"
           minSpareThreads="25"
           acceptCount="100"
           maxConnections="10000"
           compression="on"
           compressionMinSize="2048"
           compressibleMimeType="text/html,text/xml,text/plain,
                                  application/json,application/xml"
           URIEncoding="UTF-8"
           redirectPort="8443"/>
```

| Atributo              | Descripción                                                          |
|-----------------------|----------------------------------------------------------------------|
| `maxThreads`          | Número máximo de hilos del pool de procesamiento de peticiones       |
| `minSpareThreads`     | Hilos mínimos mantenidos en espera (idle)                            |
| `acceptCount`         | Cola de peticiones pendientes cuando todos los hilos están ocupados  |
| `maxConnections`      | Conexiones simultáneas máximas aceptadas por el conector             |
| `connectionTimeout`   | Tiempo máximo (ms) para establecer la conexión inicial               |
| `keepAliveTimeout`    | Tiempo máximo (ms) que se mantiene una conexión keep-alive activa    |

---

### 1.3.4 Engine

Es el motor de procesamiento de Tomcat. Recibe las peticiones del `Connector` y las enruta al `Host` correcto. El atributo `defaultHost` indica a qué Host se envían las peticiones cuando el `Host` header no coincide con ningún Host configurado.

```xml
<Engine name="Catalina" defaultHost="localhost" jvmRoute="node01">
  <!-- jvmRoute: identificador único del nodo para sticky sessions en cluster -->
</Engine>
```

| Atributo      | Descripción                                                                 |
|---------------|-----------------------------------------------------------------------------|
| `name`        | Nombre lógico del Engine                                                    |
| `defaultHost` | Host por defecto para peticiones sin Host header coincidente                |
| `jvmRoute`    | Sufijo añadido al ID de sesión para sticky sessions en balanceador de carga |

---

### 1.3.5 Host

Representa un **Virtual Host**. Permite que una misma instancia de Tomcat sirva múltiples dominios. Mapea el `Host` header HTTP con el directorio de aplicaciones configurado.

```xml
<Host name="app1.miempresa.com"
      appBase="/opt/webapps/app1"
      unpackWARs="true"
      autoDeploy="false"
      deployOnStartup="true"
      workDir="/opt/work/app1">

  <Alias>www.app1.miempresa.com</Alias>

  <Valve className="org.apache.catalina.valves.AccessLogValve"
         directory="logs"
         prefix="app1_access"
         suffix=".log"
         pattern="%h %l %u %t &quot;%r&quot; %s %b %D"/>
</Host>
```

| Atributo        | Descripción                                                                  |
|-----------------|------------------------------------------------------------------------------|
| `name`          | Nombre del host virtual (debe coincidir con el DNS)                          |
| `appBase`       | Directorio base donde se despliegan las aplicaciones web                     |
| `unpackWARs`    | Si `true`, descomprime los WARs en el filesystem                             |
| `autoDeploy`    | Si `true`, monitoriza el `appBase` y despliega automáticamente nuevos WARs   |
| `deployOnStartup` | Si `true`, despliega todas las apps del `appBase` al arrancar             |
| `workDir`       | Directorio de trabajo para JSPs compilados y archivos temporales             |

> ⚠️ **Producción:** Se recomienda `autoDeploy="false"` y `deployOnStartup="true"` en entornos de producción para evitar despliegues no controlados durante la ejecución.

---

### 1.3.6 Context

Representa una **aplicación web** individual. Mapea un path URL con un directorio o WAR en disco. Puede definirse en:

1. `server.xml` (no recomendado en producción — requiere reinicio para cambios)
2. `$CATALINA_HOME/conf/[Engine]/[Host]/myapp.xml` (**recomendado**)
3. `WEB-INF/context.xml` dentro del propio WAR

```xml
<!-- conf/Catalina/localhost/myapp.xml -->
<Context path="/myapp"
         docBase="/opt/apps/myapp-2.1.0"
         reloadable="false"
         crossContext="false"
         privileged="false"
         sessionCookieName="MYSESSIONID"
         sessionCookiePath="/"
         sessionCookieHttpOnly="true"
         sessionCookieSecure="true"
         useHttpOnly="true">

  <!-- Resource para pool de conexiones JNDI -->
  <Resource name="jdbc/MyDB"
            auth="Container"
            type="javax.sql.DataSource"
            driverClassName="org.postgresql.Driver"
            url="jdbc:postgresql://db-host:5432/mydb"
            username="appuser"
            password="secret"
            maxTotal="50"
            maxIdle="10"
            maxWaitMillis="10000"/>

  <!-- Parámetros de inicialización -->
  <Parameter name="appVersion" value="2.1.0" override="false"/>

  <!-- Variables de entorno del contexto -->
  <Environment name="maxItems" value="500" type="java.lang.Integer" override="false"/>

</Context>
```

| Atributo              | Descripción                                                                 |
|-----------------------|-----------------------------------------------------------------------------|
| `path`                | Path URL de la aplicación (vacío `""` para ROOT)                            |
| `docBase`             | Ruta absoluta al directorio o WAR de la aplicación                          |
| `reloadable`          | Si `true`, monitoriza clases y recarga el contexto al detectar cambios      |
| `crossContext`        | Si `true`, permite acceso entre contextos vía `ServletContext.getContext()` |
| `sessionCookieHttpOnly` | Previene acceso a la cookie de sesión desde JavaScript (XSS protection) |
| `sessionCookieSecure` | Marca la cookie de sesión como Secure (solo HTTPS)                          |

> ⚠️ **`reloadable="true"`** solo debe usarse en **desarrollo**. En producción degrada el rendimiento severamente por la monitorización continua del classpath.

---

### 1.3.7 Wrapper

Es el componente interno que encapsula un **Servlet** individual. No se configura directamente en `server.xml`, sino que Tomcat lo genera internamente al procesar el `web.xml` o las anotaciones `@WebServlet`. Cada `Wrapper` gestiona el ciclo de vida del Servlet (`init()`, `service()`, `destroy()`).

---

## 1.4 Pipelines, Valves y la Cadena de Procesamiento

Tomcat implementa el patrón **Pipeline-Valve** para el procesamiento de peticiones. Cada componente contenedor (`Engine`, `Host`, `Context`) tiene su propio pipeline con una cadena de Valves.

```
Request → [Engine Pipeline]
              → AccessLog Valve
              → Error Report Valve
              → [Host Pipeline]
                    → Single Sign-On Valve
                    → [Context Pipeline]
                          → Form Authenticator Valve
                          → Basic Authenticator Valve
                          → StandardWrapper Valve → Servlet.service()
```

### Valves más importantes

| Valve                          | Descripción                                                        |
|--------------------------------|--------------------------------------------------------------------|
| `AccessLogValve`               | Registro de accesos HTTP en formato configurable                   |
| `RemoteAddrValve`              | Filtro por IP de origen (allow/deny)                               |
| `RemoteHostValve`              | Filtro por hostname de origen                                      |
| `RequestDumperValve`           | Log detallado de cabeceras (solo desarrollo)                       |
| `RewriteValve`                 | Reescritura de URLs (similar a mod_rewrite de Apache)              |
| `StuckThreadDetectionValve`    | Detecta hilos bloqueados más de N segundos                         |
| `CrawlerSessionManagerValve`   | Gestión especial de sesiones para crawlers/bots                    |
| `SingleSignOn`                 | SSO entre aplicaciones del mismo Host                              |
| `ErrorReportValve`             | Generación de páginas de error HTTP                                |

### Ejemplo: Configuración de Valves avanzada

```xml
<Host name="localhost" appBase="webapps">

  <!-- Access Log con tiempo de respuesta y bytes transferidos -->
  <Valve className="org.apache.catalina.valves.AccessLogValve"
         directory="${catalina.base}/logs"
         prefix="access"
         suffix=".log"
         rotatable="true"
         fileDateFormat="yyyy-MM-dd"
         pattern="%{X-Forwarded-For}i %l %u %t &quot;%r&quot; %s %b %D %{User-Agent}i"
         resolveHosts="false"
         buffered="false"/>

  <!-- Filtrar acceso por IP: solo permitir rango interno -->
  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="192\.168\.1\.\d+|10\.0\.0\.\d+|127\.0\.0\.1"
         denyStatus="403"/>

  <!-- Detectar hilos bloqueados más de 60 segundos -->
  <Valve className="org.apache.catalina.valves.StuckThreadDetectionValve"
         threshold="60"
         interruptThreadThreshold="120"/>

  <!-- Rewrite Valve para redirecciones -->
  <Valve className="org.apache.catalina.valves.rewrite.RewriteValve"/>

</Host>
```

### Archivo `rewrite.config` (para RewriteValve)

```
# Redirigir HTTP a HTTPS
RewriteCond %{SERVER_PORT} ^80$
RewriteRule ^/(.*)$ https://%{SERVER_NAME}/$1 [R=301,L]

# Redirigir /old-path a /new-path
RewriteRule ^/old-path/(.*)$ /new-path/$1 [R=301,L]
```

---

## 1.5 El Cargador de Clases (ClassLoader) de Tomcat

Tomcat implementa una jerarquía de ClassLoaders propia que **aísla** las aplicaciones entre sí y del propio servidor. Este mecanismo es fundamental para evitar conflictos de versiones de librerías.

```
Bootstrap ClassLoader (JVM)
└── System ClassLoader
    └── Common ClassLoader  ← $CATALINA_HOME/lib/*.jar
        ├── Catalina ClassLoader  ← Clases internas de Tomcat (no visibles para apps)
        └── Shared ClassLoader    ← Librerías compartidas entre apps
            ├── WebApp ClassLoader (App 1)  ← WEB-INF/lib/*.jar + WEB-INF/classes/
            ├── WebApp ClassLoader (App 2)
            └── WebApp ClassLoader (App N)
```

### Reglas de visibilidad

| ClassLoader        | Visible para                        | Carga desde                          |
|--------------------|-------------------------------------|--------------------------------------|
| Bootstrap          | Todo el sistema                     | JVM core (`rt.jar`, módulos Java 9+) |
| System             | Todo                                | `CLASSPATH`, `bin/bootstrap.jar`     |
| Common             | Tomcat + todas las apps             | `$CATALINA_HOME/lib/`                |
| Catalina           | Solo el servidor Tomcat             | Interno de Tomcat                    |
| Shared             | Todas las apps (no Tomcat interno)  | `shared/lib/` (si configurado)       |
| WebApp             | Solo la aplicación propia           | `WEB-INF/lib/` y `WEB-INF/classes/` |

### Configuración en `conf/catalina.properties`

```properties
# Repositorios del Common ClassLoader
common.loader="${catalina.base}/lib","${catalina.base}/lib/*.jar","${catalina.home}/lib","${catalina.home}/lib/*.jar"

# Repositorios del Server ClassLoader (Catalina)
server.loader=

# Repositorios del Shared ClassLoader
shared.loader=
```

> 💡 **Patrón Child-First:** A diferencia del modelo estándar de Java (Parent-First), el `WebAppClassLoader` usa **Child-First** por defecto: carga primero las clases de `WEB-INF/lib/` antes de delegar al padre. Esto permite que cada aplicación use su propia versión de una librería (ej: Jackson 2.13 en App1 y Jackson 2.15 en App2) sin conflictos.

---

## 1.6 Ciclo de Vida de los Componentes (Lifecycle)

Todos los componentes de Tomcat implementan la interfaz `org.apache.catalina.Lifecycle`. Esto permite una gestión ordenada de los estados de cada componente.

### Estados del ciclo de vida

```
NEW
 └──[init()]──→ INITIALIZING ──→ INITIALIZED
                                      └──[start()]──→ STARTING_PREP ──→ STARTING ──→ STARTED
                                                                                          ├──[stop()]──→ STOPPING_PREP ──→ STOPPING ──→ STOPPED
                                                                                          │                                                  └──[destroy()]──→ DESTROYING ──→ DESTROYED
                                                                                          └──[ERROR]──→ FAILED
```

### Eventos del Lifecycle

```java
// Ejemplo de LifecycleListener personalizado
public class CustomLifecycleListener implements LifecycleListener {

    @Override
    public void lifecycleEvent(LifecycleEvent event) {
        String type = event.getType();
        Lifecycle source = event.getLifecycle();

        switch (type) {
            case Lifecycle.BEFORE_START_EVENT:
                System.out.println("Componente a punto de arrancar: " + source);
                break;
            case Lifecycle.START_EVENT:
                System.out.println("Componente arrancado: " + source);
                break;
            case Lifecycle.AFTER_START_EVENT:
                System.out.println("Post-arranque completado: " + source);
                break;
            case Lifecycle.STOP_EVENT:
                System.out.println("Componente detenido: " + source);
                break;
            case Lifecycle.BEFORE_STOP_EVENT:
                System.out.println("Componente a punto de detenerse: " + source);
                break;
        }
    }
}
```

Registrar el listener en `server.xml`:

```xml
<Server port="8005" shutdown="SHUTDOWN">
  <Listener className="com.miempresa.tomcat.CustomLifecycleListener"/>
  <!-- resto de configuración -->
</Server>
```

### Listeners incluidos en Tomcat por defecto

```xml
<!-- Detecta memory leaks al redeployar aplicaciones -->
<Listener className="org.apache.catalina.core.JreMemoryLeakPreventionListener"/>

<!-- Gestiona el MBeanServer de JMX -->
<Listener className="org.apache.catalina.mbeans.GlobalResourcesLifecycleListener"/>

<!-- Evita deadlocks con ThreadLocal al redeployar -->
<Listener className="org.apache.catalina.core.ThreadLocalLeakPreventionListener"/>

<!-- APR/Native library (si está instalada) -->
<Listener className="org.apache.catalina.core.AprLifecycleListener"
          SSLEngine="on"/>
```

---

## 1.7 Componentes de Soporte: Realm, Manager y Store

### 1.7.1 Realm (Seguridad)

Define el repositorio de usuarios y roles para la autenticación de aplicaciones. Se configura a nivel de `Engine`, `Host` o `Context`.

```xml
<!-- JDBC Realm — usuarios en base de datos -->
<Realm className="org.apache.catalina.realm.JDBCRealm"
       driverName="org.postgresql.Driver"
       connectionURL="jdbc:postgresql://db:5432/security"
       connectionName="tomcat"
       connectionPassword="tomcat_pass"
       userTable="users"
       userNameCol="username"
       userCredCol="password_hash"
       userRoleTable="user_roles"
       roleNameCol="role_name"
       digest="SHA-256"/>
```

Tipos de Realm disponibles:

| Realm                    | Descripción                                           |
|--------------------------|-------------------------------------------------------|
| `MemoryRealm`            | Usuarios en `conf/tomcat-users.xml` (solo desarrollo) |
| `JDBCRealm`             | Usuarios en base de datos vía JDBC directo            |
| `DataSourceRealm`        | Usuarios en BD vía pool JNDI DataSource               |
| `JNDIRealm`             | Usuarios en directorio LDAP/Active Directory          |
| `UserDatabaseRealm`      | Usuarios en `UserDatabase` global JNDI                |
| `JAASRealm`             | Delegación al framework JAAS de Java                  |
| `CombinedRealm`          | Combinación de múltiples Realms en cadena             |
| `LockOutRealm`           | Wrapper que añade bloqueo por intentos fallidos       |

---

### 1.7.2 Manager (Gestión de Sesiones)

Gestiona las sesiones HTTP de las aplicaciones.

```xml
<Context path="/myapp" docBase="/opt/apps/myapp">

  <!-- StandardManager: sesiones en memoria (por defecto) -->
  <Manager className="org.apache.catalina.session.StandardManager"
           maxActiveSessions="5000"
           sessionIdLength="32"/>

  <!-- PersistentManager: sesiones persistidas en disco o BD -->
  <!--
  <Manager className="org.apache.catalina.session.PersistentManager"
           saveOnRestart="true"
           maxIdleBackup="30"
           maxIdleSwap="60"
           minIdleSwap="30">
    <Store className="org.apache.catalina.session.FileStore"
           directory="/opt/sessions/myapp"/>
  </Manager>
  -->

</Context>
```

---

## 1.8 Resumen Visual de la Arquitectura Completa

```
┌─────────────────────────────────────────────────────────────────┐
│                        JVM (Java Virtual Machine)               │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │                      SERVER                              │   │
│  │  ┌────────────────────────────────────────────────────┐  │   │
│  │  │                    SERVICE                         │  │   │
│  │  │                                                    │  │   │
│  │  │  [Connector:8080] ──┐                              │  │   │
│  │  │  [Connector:8443] ──┼──→ [ENGINE: Catalina]        │  │   │
│  │  │  [Connector:AJP]  ──┘         │                    │  │   │
│  │  │                               ▼                    │  │   │
│  │  │                     ┌─────────────────┐            │  │   │
│  │  │                     │   HOST          │            │  │   │
│  │  │                     │  (localhost)    │            │  │   │
│  │  │                     │   Pipeline ─────┼──→ Valves  │  │   │
│  │  │                     │      │          │            │  │   │
│  │  │                     │  ┌───▼───────┐  │            │  │   │
│  │  │                     │  │  CONTEXT  │  │            │  │   │
│  │  │                     │  │ /myapp    │  │            │  │   │
│  │  │                     │  │ Pipeline ─┼──→ Valves     │  │   │
│  │  │                     │  │    │      │  │            │  │   │
│  │  │                     │  │ Wrapper──→│  │            │  │   │
│  │  │                     │  │ Servlet   │  │            │  │   │
│  │  │                     │  └───────────┘  │            │  │   │
│  │  │                     └─────────────────┘            │  │   │
│  │  └────────────────────────────────────────────────────┘  │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 1.9 Diferencias Arquitectónicas entre Versiones

| Característica                     | Tomcat 8.0 | Tomcat 8.5 | Tomcat 9.0 | Tomcat 10.x | Tomcat 11.0 |
|------------------------------------|------------|------------|------------|-------------|-------------|
| Protocolo BIO HTTP                 | ✅          | ⚠️ Dep.   | ❌          | ❌           | ❌           |
| HTTP/2 nativo                      | ❌          | ✅          | ✅          | ✅           | ✅           |
| OpenSSL via APR                    | ✅          | ✅          | ✅          | ✅           | ✅           |
| JSSE + KeyStore TLS                | ✅          | ✅          | ✅          | ✅           | ✅           |
| Namespace `javax.*`                | ✅          | ✅          | ✅          | ❌           | ❌           |
| Namespace `jakarta.*`              | ❌          | ❌          | ❌          | ✅           | ✅           |
| Virtual Threads (Project Loom)     | ❌          | ❌          | ❌          | ❌           | ✅ (Java 21) |
| TLS 1.3                            | ❌          | ❌          | ✅ (Java 11)| ✅           | ✅           |
| Servlet Async I/O                  | ✅          | ✅          | ✅          | ✅           | ✅           |
| WebSocket 2.x                      | ❌          | ❌          | ❌          | ✅           | ✅           |

---

## Puntos Clave del Módulo 01

- Tomcat es un **contenedor jerárquico** de componentes: Server → Service → Connector + Engine → Host → Context → Wrapper.
- El **namespace de APIs** cambia de `javax.*` a `jakarta.*` en Tomcat 10+. Este es el cambio más disruptivo para aplicaciones legacy.
- El protocolo **BIO fue eliminado en Tomcat 9**. Usar siempre NIO o NIO2 en producción.
- El **ClassLoader WebApp usa Child-First** para aislar dependencias entre aplicaciones.
- El patrón **Pipeline-Valve** permite interceptar y modificar el flujo de procesamiento en cada nivel de la jerarquía.
- En producción: `autoDeploy="false"`, `reloadable="false"`, puerto shutdown deshabilitado (`port="-1"`).
- Tomcat 11 introduce soporte para **Virtual Threads** (Project Loom) con Java 21, eliminando el modelo thread-per-request para cargas de I/O intensivas.