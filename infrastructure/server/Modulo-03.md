> **Estado:** 🟢 Completo
> **Última actualización:** 2026-05


- [Módulo 03: Configuración de server.xml en Profundidad](#módulo-03-configuración-de-serverxml-en-profundidad)
- [3.1 Visión General del Archivo server.xml](#31-visión-general-del-archivo-serverxml)
  - [Estructura esquemática completa](#estructura-esquemática-completa)
- [3.2 Elemento `<Server>`](#32-elemento-server)
  - [Atributos detallados](#atributos-detallados)
  - [Configuración de producción recomendada](#configuración-de-producción-recomendada)
- [3.3 Listeners del Ciclo de Vida](#33-listeners-del-ciclo-de-vida)
- [3.4 GlobalNamingResources](#34-globalnamingresources)
  - [Referenciar un recurso global desde un Context](#referenciar-un-recurso-global-desde-un-context)
- [3.5 Elemento `<Service>`](#35-elemento-service)
  - [Caso de uso con múltiples Services](#caso-de-uso-con-múltiples-services)
- [3.6 Elemento `<Connector>` — Configuración Exhaustiva](#36-elemento-connector--configuración-exhaustiva)
  - [3.6.1 Conector HTTP/1.1 NIO — Producción estándar](#361-conector-http11-nio--producción-estándar)
  - [3.6.2 Conector HTTPS/TLS con JSSE — Tomcat 8.5+](#362-conector-httpstls-con-jsse--tomcat-85)
  - [3.6.3 Conector HTTPS con mTLS (mutual TLS / certificados de cliente)](#363-conector-https-con-mtls-mutual-tls--certificados-de-cliente)
  - [3.6.4 Conector con Executor compartido](#364-conector-con-executor-compartido)
  - [3.6.5 Conector AJP (post Ghostcat)](#365-conector-ajp-post-ghostcat)
- [3.7 Elemento `<Engine>`](#37-elemento-engine)
- [3.8 Elemento `<Host>` — Hosts Virtuales](#38-elemento-host--hosts-virtuales)
  - [Configuración completa de un Host virtual](#configuración-completa-de-un-host-virtual)
  - [Atributos críticos del Host](#atributos-críticos-del-host)
- [3.9 Elemento `<Context>` en server.xml vs Archivos Externos](#39-elemento-context-en-serverxml-vs-archivos-externos)
  - [Jerarquía de búsqueda de configuración del Context (por prioridad)](#jerarquía-de-búsqueda-de-configuración-del-context-por-prioridad)
  - [Archivo de Context descriptor externo — Producción](#archivo-de-context-descriptor-externo--producción)
  - [context.xml global (aplica a TODOS los contextos)](#contextxml-global-aplica-a-todos-los-contextos)
- [3.10 Configuración del `<Engine>` con Realm Encadenado](#310-configuración-del-engine-con-realm-encadenado)
- [3.11 Configuración de ErrorReportValve](#311-configuración-de-errorreportvalve)
- [3.12 server.xml Completo de Referencia para Producción](#312-serverxml-completo-de-referencia-para-producción)
- [3.13 Variables del Sistema en server.xml](#313-variables-del-sistema-en-serverxml)
- [3.14 Diferencias en server.xml por Versión de Tomcat](#314-diferencias-en-serverxml-por-versión-de-tomcat)
- [Puntos Clave del Módulo 03](#puntos-clave-del-módulo-03)

---

## Módulo 03: Configuración de server.xml en Profundidad

## 3.1 Visión General del Archivo server.xml

El archivo `server.xml` ubicado en `$CATALINA_BASE/conf/server.xml` es el **archivo de configuración central** de Apache Tomcat. Define la estructura completa del servidor: conectores de red, hosts virtuales, motores de procesamiento, listeners del ciclo de vida y recursos globales.

Cualquier cambio en `server.xml` requiere **reinicio completo** de Tomcat para surtir efecto.

### Estructura esquemática completa

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Server>
  <!-- Listeners globales del ciclo de vida -->
  <Listener .../>

  <!-- Recursos JNDI globales -->
  <GlobalNamingResources>
    <Resource .../>
  </GlobalNamingResources>

  <Service>
    <!-- Conectores de red -->
    <Connector .../>

    <Engine>
      <!-- Realm de autenticación -->
      <Realm .../>

      <Host>
        <!-- Valves del Host -->
        <Valve .../>

        <Context>
          <!-- Recursos del contexto -->
          <Resource .../>
          <!-- Valves del contexto -->
          <Valve .../>
        </Context>

      </Host>
    </Engine>
  </Service>
</Server>
```

---

## 3.2 Elemento `<Server>`

Elemento raíz del fichero. Solo puede haber uno por instancia.

```xml
<Server port="8005"
        shutdown="SHUTDOWN"
        address="127.0.0.1"
        className="org.apache.catalina.core.StandardServer">
```

### Atributos detallados

| Atributo    | Tipo    | Descripción                                                                 | Producción         |
|-------------|---------|-----------------------------------------------------------------------------|--------------------|
| `port`      | int     | Puerto TCP donde escucha el comando de shutdown                             | `-1` (desactivado) |
| `shutdown`  | String  | Cadena esperada para ejecutar el shutdown                                   | Aleatorio          |
| `address`   | String  | IP de escucha del socket de shutdown                                        | `127.0.0.1`        |
| `className` | String  | Implementación del Server (raramente se cambia)                             | Por defecto        |

### Configuración de producción recomendada

```xml
<!-- Producción: shutdown socket desactivado, controlado por systemd -->
<Server port="-1" shutdown="SHUTDOWN">
```

> ⚠️ Con `port="-1"`, el comando `shutdown.sh` no funcionará via socket. El control del proceso se delega a **systemd** o al sistema operativo. Es la configuración más segura ya que elimina el vector de ataque del puerto de shutdown.

---

## 3.3 Listeners del Ciclo de Vida

Se declaran como hijos directos de `<Server>`. Se ejecutan en los eventos del ciclo de vida del servidor.

```xml
<Server port="-1" shutdown="SHUTDOWN">

  <!--
    AprLifecycleListener:
    Carga la librería nativa APR/OpenSSL si está disponible.
    SSLEngine="on" activa OpenSSL para TLS (mejor rendimiento que JSSE).
    Disponible en todas las versiones. En Tomcat 10.1+ se usa Tomcat Native 2.x
  -->
  <Listener className="org.apache.catalina.core.AprLifecycleListener"
            SSLEngine="on"
            SSLRandomSeed="builtin"/>

  <!--
    JreMemoryLeakPreventionListener:
    Previene memory leaks conocidos de la JVM al redeployar aplicaciones.
    Fuerza la inicialización de ciertas clases en el ClassLoader correcto.
    Esencial en entornos con redeploy frecuente.
  -->
  <Listener className="org.apache.catalina.core.JreMemoryLeakPreventionListener"
            gcDaemonProtection="true"
            tokenPollerProtection="true"
            urlCacheProtection="true"
            ldapPoolProtection="true"
            driverManagerProtection="true"
            forkJoinCommonPoolProtection="true"/>

  <!--
    GlobalResourcesLifecycleListener:
    Gestiona el ciclo de vida de los recursos JNDI globales definidos
    en GlobalNamingResources. Imprescindible si usas UserDatabase global.
  -->
  <Listener className="org.apache.catalina.mbeans.GlobalResourcesLifecycleListener"/>

  <!--
    ThreadLocalLeakPreventionListener:
    Previene leaks de ThreadLocal al detener contextos de aplicación.
    Renueva los hilos del pool de conectores cuando un contexto se para.
  -->
  <Listener className="org.apache.catalina.core.ThreadLocalLeakPreventionListener"/>

  <!--
    VersionLoggerListener:
    Registra en el log la versión de Tomcat, Java y OS al arrancar.
    Muy útil para auditoría y debugging.
    logArgs: loguea los argumentos de línea de comandos de la JVM.
    logEnv: loguea las variables de entorno del sistema.
    logProps: loguea las propiedades del sistema Java.
  -->
  <Listener className="org.apache.catalina.startup.VersionLoggerListener"
            logArgs="true"
            logEnv="false"
            logProps="false"/>

</Server>
```

---

## 3.4 GlobalNamingResources

Define recursos JNDI globales accesibles desde cualquier aplicación mediante `ResourceLink` en sus contextos.

```xml
<GlobalNamingResources>

  <!--
    UserDatabase: base de datos de usuarios para MemoryRealm y Manager.
    readonly="false" permite modificaciones en caliente via Manager.
  -->
  <Resource name="UserDatabase"
            auth="Container"
            type="org.apache.catalina.UserDatabase"
            description="User database that can be updated and saved"
            factory="org.apache.catalina.users.MemoryUserDatabaseFactory"
            pathname="conf/tomcat-users.xml"
            readonly="false"/>

  <!--
    DataSource global: pool de conexiones compartido entre aplicaciones.
    Se referencia desde los Context con ResourceLink.
  -->
  <Resource name="jdbc/GlobalDB"
            auth="Container"
            type="javax.sql.DataSource"
            driverClassName="org.postgresql.Driver"
            url="jdbc:postgresql://db-host:5432/globaldb"
            username="global_user"
            password="global_pass"
            maxTotal="100"
            maxIdle="20"
            minIdle="5"
            maxWaitMillis="30000"
            validationQuery="SELECT 1"
            testOnBorrow="true"
            testWhileIdle="true"
            timeBetweenEvictionRunsMillis="30000"
            minEvictableIdleTimeMillis="60000"
            removeAbandonedOnBorrow="true"
            removeAbandonedTimeout="60"
            logAbandoned="true"/>

</GlobalNamingResources>
```

### Referenciar un recurso global desde un Context

```xml
<!-- conf/Catalina/localhost/myapp.xml -->
<Context path="/myapp" docBase="/opt/apps/myapp">

  <!-- ResourceLink conecta el nombre local de la app con el recurso global -->
  <ResourceLink name="jdbc/MyDB"
                global="jdbc/GlobalDB"
                auth="Container"
                type="javax.sql.DataSource"/>

</Context>
```

---

## 3.5 Elemento `<Service>`

Agrupa conectores con un Engine. En configuraciones estándar existe solo un Service llamado `Catalina`.

```xml
<Service name="Catalina"
         className="org.apache.catalina.core.StandardService">
```

### Caso de uso con múltiples Services

```xml
<Server port="-1" shutdown="SHUTDOWN">

  <!-- Service principal: tráfico público -->
  <Service name="Catalina">
    <Connector port="8080" protocol="org.apache.coyote.http11.Http11NioProtocol" .../>
    <Engine name="Catalina" defaultHost="public.miempresa.com">
      <Host name="public.miempresa.com" appBase="/opt/webapps/public"/>
    </Engine>
  </Service>

  <!-- Service secundario: tráfico interno/admin -->
  <Service name="Admin">
    <Connector port="9080" protocol="org.apache.coyote.http11.Http11NioProtocol"
               address="10.0.0.1"/>
    <Engine name="Admin" defaultHost="admin.miempresa.internal">
      <Host name="admin.miempresa.internal" appBase="/opt/webapps/admin"/>
    </Engine>
  </Service>

</Server>
```

---

## 3.6 Elemento `<Connector>` — Configuración Exhaustiva

### 3.6.1 Conector HTTP/1.1 NIO — Producción estándar

```xml
<Connector
  port="8080"
  protocol="org.apache.coyote.http11.Http11NioProtocol"

  <!-- === Timeouts === -->
  connectionTimeout="20000"
  keepAliveTimeout="30000"
  maxKeepAliveRequests="100"
  asyncTimeout="30000"
  disableUploadTimeout="true"

  <!-- === Pool de hilos === -->
  maxThreads="400"
  minSpareThreads="25"
  maxSpareThreads="75"
  prestartminSpareThreads="true"

  <!-- === Conexiones === -->
  acceptCount="200"
  maxConnections="10000"
  acceptorThreadCount="2"

  <!-- === HTTP === -->
  URIEncoding="UTF-8"
  useBodyEncodingForURI="false"
  maxHttpHeaderSize="16384"
  maxPostSize="10485760"
  maxParameterCount="1000"

  <!-- === Compresión === -->
  compression="on"
  compressionMinSize="2048"
  noCompressionUserAgents="gozilla, traviata"
  compressibleMimeType="text/html,text/xml,text/plain,text/css,
                         text/javascript,application/javascript,
                         application/json,application/xml"

  <!-- === Proxy / Load Balancer === -->
  scheme="http"
  secure="false"
  proxyName=""
  proxyPort="0"

  <!-- === Redirección HTTPS === -->
  redirectPort="8443"

  <!-- === Seguridad === -->
  server="Apache"
  allowedTrailerHeaders=""
  rejectIllegalHeader="true"
  allowHostHeaderMismatch="false"
/>
```

> 💡 **`server="Apache"`:** Oculta la versión exacta de Tomcat en la cabecera HTTP `Server:`. En lugar de `Apache-Coyote/1.1` mostrará `Apache`. Para eliminar completamente la cabecera, usar el atributo `server=""` (Tomcat 8.5.88+ / 9.0.74+).

### 3.6.2 Conector HTTPS/TLS con JSSE — Tomcat 8.5+

```xml
<Connector
  port="8443"
  protocol="org.apache.coyote.http11.Http11NioProtocol"
  SSLEnabled="true"
  maxThreads="200"
  scheme="https"
  secure="true"
  redirectPort="8443"
  clientAuth="false"
  sslProtocol="TLS">

  <!--
    SSLHostConfig: configuración TLS por SNI (Server Name Indication).
    Se pueden definir múltiples SSLHostConfig para diferentes dominios.
  -->
  <SSLHostConfig
    hostName="_default_"
    protocols="TLSv1.2,TLSv1.3"
    ciphers="TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:
             TLS_AES_128_GCM_SHA256:ECDHE-RSA-AES256-GCM-SHA384:
             ECDHE-RSA-AES128-GCM-SHA256"
    honorCipherOrder="false"
    disableSessionTickets="false"
    sessionCacheSize="0"
    sessionTimeout="86400"
    certificateVerification="none"
    truststoreFile=""
    truststorePassword=""
    truststoreType="JKS">

    <!-- Certificado RSA -->
    <Certificate
      type="RSA"
      certificateKeystoreFile="${catalina.base}/conf/ssl/keystore.jks"
      certificateKeystorePassword="changeit"
      certificateKeyAlias="tomcat"
      certificateKeystoreType="JKS"/>

    <!-- Certificado ECDSA (dual-cert: el cliente negocia el mejor) -->
    <Certificate
      type="EC"
      certificateKeystoreFile="${catalina.base}/conf/ssl/keystore-ec.jks"
      certificateKeystorePassword="changeit"
      certificateKeyAlias="tomcat-ec"
      certificateKeystoreType="JKS"/>

  </SSLHostConfig>

  <!-- SNI: dominio específico con su propio certificado -->
  <SSLHostConfig hostName="api.miempresa.com"
                 protocols="TLSv1.3"
                 ciphers="TLS_AES_256_GCM_SHA384:TLS_AES_128_GCM_SHA256">
    <Certificate
      type="RSA"
      certificateKeystoreFile="${catalina.base}/conf/ssl/api-keystore.jks"
      certificateKeystorePassword="api-secret"
      certificateKeyAlias="api-cert"/>
  </SSLHostConfig>

</Connector>
```

### 3.6.3 Conector HTTPS con mTLS (mutual TLS / certificados de cliente)

```xml
<Connector port="8444"
           protocol="org.apache.coyote.http11.Http11NioProtocol"
           SSLEnabled="true"
           scheme="https"
           secure="true">

  <SSLHostConfig
    protocols="TLSv1.2,TLSv1.3"
    certificateVerification="required"
    truststoreFile="${catalina.base}/conf/ssl/truststore.jks"
    truststorePassword="trustpass"
    truststoreType="JKS"
    caCertificateFile="${catalina.base}/conf/ssl/ca-chain.pem">

    <Certificate
      type="RSA"
      certificateKeystoreFile="${catalina.base}/conf/ssl/server-keystore.jks"
      certificateKeystorePassword="serverpass"/>

  </SSLHostConfig>

</Connector>
```

### 3.6.4 Conector con Executor compartido

Permite compartir un pool de hilos entre múltiples conectores.

```xml
<!-- Definir el Executor (pool de hilos compartido) -->
<Executor
  name="tomcatThreadPool"
  namePrefix="catalina-exec-"
  maxThreads="500"
  minSpareThreads="25"
  maxSpareThreads="100"
  maxQueueSize="100"
  prestartminSpareThreads="true"
  maxIdleTime="60000"
  className="org.apache.catalina.core.StandardThreadExecutor"
  threadPriority="5"
  daemon="true"/>

<!-- Conectores que usan el Executor compartido -->
<Connector port="8080"
           protocol="org.apache.coyote.http11.Http11NioProtocol"
           executor="tomcatThreadPool"
           connectionTimeout="20000"
           redirectPort="8443"/>

<Connector port="8443"
           protocol="org.apache.coyote.http11.Http11NioProtocol"
           executor="tomcatThreadPool"
           SSLEnabled="true"
           scheme="https"
           secure="true">
  <SSLHostConfig protocols="TLSv1.2,TLSv1.3">
    <Certificate certificateKeystoreFile="${catalina.base}/conf/ssl/keystore.jks"
                 certificateKeystorePassword="changeit"/>
  </SSLHostConfig>
</Connector>
```

### 3.6.5 Conector AJP (post Ghostcat)

```xml
<!--
  AJP Connector — Solo si se usa con Apache httpd via mod_proxy_ajp.
  Ghostcat (CVE-2020-1938): activado por defecto hasta:
    - Tomcat 9.0.30, 8.5.50 (VULNERABLE)
  Mitigado en:
    - Tomcat 9.0.31+, 8.5.51+, 10.0.0-M4+
  Requiere secretRequired="true" y requiredSecret definido.
-->
<Connector protocol="AJP/1.3"
           address="127.0.0.1"
           port="8009"
           redirectPort="8443"
           maxThreads="200"
           connectionTimeout="20000"
           keepAliveTimeout="60000"
           maxKeepAliveRequests="100"
           secretRequired="true"
           requiredSecret="clave-secreta-ajp-aleatoria-256bits"
           tomcatAuthentication="false"
           tomcatAuthorization="false"
           allowedRequestAttributesPattern=".*"/>
```

---

## 3.7 Elemento `<Engine>`

```xml
<Engine
  name="Catalina"
  defaultHost="localhost"
  jvmRoute="node01"
  className="org.apache.catalina.core.StandardEngine"
  backgroundProcessorDelay="10"
  startStopThreads="0">

  <!--
    Realm a nivel de Engine: se aplica a todos los Hosts.
    Se puede sobrescribir a nivel de Host o Context.
  -->
  <Realm className="org.apache.catalina.realm.LockOutRealm"
         failureCount="5"
         lockOutTime="300"
         cacheSize="1000"
         cacheRemovalWarningTime="3600">

    <Realm className="org.apache.catalina.realm.UserDatabaseRealm"
           resourceName="UserDatabase"
           digest="SHA-256"/>

  </Realm>

</Engine>
```

| Atributo                    | Descripción                                                                 |
|-----------------------------|-----------------------------------------------------------------------------|
| `name`                      | Nombre lógico del Engine                                                    |
| `defaultHost`               | Host que gestiona peticiones sin Host header coincidente                    |
| `jvmRoute`                  | Sufijo al JSESSIONID para sticky sessions en cluster (`node01`)             |
| `backgroundProcessorDelay`  | Segundos entre ejecuciones del hilo de background (redeployos, sesiones)   |
| `startStopThreads`          | Hilos para arrancar/parar Hosts en paralelo. `0` = número de CPUs          |

---

## 3.8 Elemento `<Host>` — Hosts Virtuales

### Configuración completa de un Host virtual

```xml
<Host
  name="app.miempresa.com"
  appBase="/opt/webapps/app"
  unpackWARs="true"
  autoDeploy="false"
  deployOnStartup="true"
  deployXML="true"
  copyXML="false"
  workDir="${catalina.base}/work/Catalina/app.miempresa.com"
  errorReportValveClass="org.apache.catalina.valves.ErrorReportValve"
  startStopThreads="0"
  backgroundProcessorDelay="-1"
  className="org.apache.catalina.core.StandardHost">

  <!-- Alias: nombres adicionales para este Host -->
  <Alias>www.miempresa.com</Alias>
  <Alias>miempresa.com</Alias>

  <!-- Access Log detallado -->
  <Valve className="org.apache.catalina.valves.AccessLogValve"
         directory="${catalina.base}/logs"
         prefix="app_access"
         suffix=".log"
         rotatable="true"
         fileDateFormat="yyyy-MM-dd"
         pattern="%{X-Forwarded-For}i %l %u %t &quot;%r&quot; %s %b %D %{Referer}i %{User-Agent}i"
         resolveHosts="false"
         buffered="true"
         maxLogMessageBufferSize="4096"
         checkExists="false"
         requestAttributesEnabled="true"
         ipv6Canonical="false"/>

  <!-- Detección de hilos bloqueados -->
  <Valve className="org.apache.catalina.valves.StuckThreadDetectionValve"
         threshold="60"
         interruptThreadThreshold="180"/>

  <!-- Control de velocidad de peticiones (Rate Limiting — Tomcat 11) -->
  <!-- Disponible desde Tomcat 11.0 -->
  <!--
  <Valve className="org.apache.catalina.valves.RateLimitFilter"
         duration="60"
         requests="1000"
         enforce="true"/>
  -->

</Host>
```

### Atributos críticos del Host

| Atributo           | Descripción                                                                       | Producción     |
|--------------------|-----------------------------------------------------------------------------------|----------------|
| `autoDeploy`       | Monitoriza `appBase` y despliega automáticamente cambios durante ejecución        | `false`        |
| `deployOnStartup`  | Despliega todo lo que haya en `appBase` al arrancar                               | `true`         |
| `deployXML`        | Permite desplegar descriptores de contexto XML desde WEB-INF/                     | `false` (prod) |
| `copyXML`          | Copia el descriptor de contexto a `conf/[Engine]/[Host]/` al desplegar           | `false`        |
| `unpackWARs`       | Descomprime los WARs en el filesystem                                             | `true`         |
| `workDir`          | Directorio para JSPs compilados y trabajo temporal                                | Personalizado  |

---

## 3.9 Elemento `<Context>` en server.xml vs Archivos Externos

### Jerarquía de búsqueda de configuración del Context (por prioridad)

```
1. conf/[EngineName]/[HostName]/[AppName].xml   ← Mayor prioridad
2. conf/context.xml                             ← Configuración global (todas las apps)
3. WAR/META-INF/context.xml                     ← Dentro del propio WAR
4. <Context> en server.xml                      ← Menor prioridad, evitar en prod
```

### Archivo de Context descriptor externo — Producción

```xml
<!-- conf/Catalina/localhost/myapp.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<Context
  path="/myapp"
  docBase="/opt/apps/myapp-2.3.1"
  reloadable="false"
  crossContext="false"
  privileged="false"
  antiResourceLocking="false"
  swallowOutput="false"
  logEffectiveWebXml="false"
  backgroundProcessorDelay="-1"
  sessionCookieName="MYAPP_SESSION"
  sessionCookiePath="/"
  sessionCookieHttpOnly="true"
  sessionCookieSecure="true"
  sessionCookieSameSite="Strict"
  useHttpOnly="true"
  clearReferencesObjectStreamClassCaches="true"
  clearReferencesRmiTargets="true"
  clearReferencesThreadLocals="true">

  <!-- Pool de conexiones local al contexto -->
  <Resource
    name="jdbc/AppDB"
    auth="Container"
    type="javax.sql.DataSource"
    factory="org.apache.tomcat.jdbc.pool.DataSourceFactory"
    driverClassName="org.postgresql.Driver"
    url="jdbc:postgresql://db-host:5432/appdb?ssl=true&amp;sslmode=require"
    username="app_user"
    password="app_password"
    initialSize="5"
    maxActive="50"
    maxIdle="10"
    minIdle="5"
    maxWait="30000"
    validationQuery="SELECT 1"
    validationInterval="30000"
    testOnBorrow="true"
    testOnReturn="false"
    testWhileIdle="true"
    timeBetweenEvictionRunsMillis="30000"
    minEvictableIdleTimeMillis="60000"
    removeAbandoned="true"
    removeAbandonedTimeout="60"
    logAbandoned="true"
    jdbcInterceptors="ResetAbandonedTimer;StatementFinalizer;
                      SlowQueryReport(threshold=1000)"/>

  <!-- Referencia a recurso JNDI global -->
  <ResourceLink
    name="jdbc/SharedDB"
    global="jdbc/GlobalDB"
    type="javax.sql.DataSource"/>

  <!-- Variables de entorno del contexto -->
  <Environment
    name="maxCacheSize"
    value="1000"
    type="java.lang.Integer"
    override="false"/>

  <Environment
    name="app.environment"
    value="production"
    type="java.lang.String"
    override="false"/>

  <!-- Parámetros de inicialización del contexto -->
  <Parameter
    name="com.miempresa.config.path"
    value="/opt/config/myapp/production.properties"
    override="false"/>

  <!-- Manager de sesiones personalizado -->
  <Manager
    className="org.apache.catalina.session.StandardManager"
    maxActiveSessions="10000"
    sessionIdLength="32"
    secureRandomAlgorithm="SHA1PRNG"
    secureRandomProvider="SUN"/>

  <!-- Valve de autenticación a nivel de contexto -->
  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         addConnectorPort="false"
         allow=""/>

  <!-- WatchedResource: recargar contexto si cambia web.xml -->
  <WatchedResource>WEB-INF/web.xml</WatchedResource>
  <WatchedResource>WEB-INF/tomcat-web.xml</WatchedResource>
  <WatchedResource>${catalina.base}/conf/web.xml</WatchedResource>

</Context>
```

### context.xml global (aplica a TODOS los contextos)

```xml
<!-- conf/context.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<Context>

  <!-- Configuración global de cookies de sesión -->
  <CookieProcessor
    className="org.apache.tomcat.util.http.Rfc6265CookieProcessor"
    sameSiteCookies="strict"/>

  <!-- WatchedResource global -->
  <WatchedResource>WEB-INF/web.xml</WatchedResource>
  <WatchedResource>${catalina.base}/conf/web.xml</WatchedResource>

  <!-- JarScanner: optimizar arranque ignorando JARs que no necesitan escaneo -->
  <JarScanner>
    <JarScanFilter
      tldSkip="*.jar"
      tldScan="taglib-*.jar"
      pluggabilitySkip="*.jar"
      pluggabilityScan=""/>
  </JarScanner>

</Context>
```

---

## 3.10 Configuración del `<Engine>` con Realm Encadenado

```xml
<Engine name="Catalina" defaultHost="localhost">

  <!--
    LockOutRealm: envuelve cualquier Realm para añadir bloqueo
    por intentos fallidos de autenticación.
    failureCount: intentos fallidos antes de bloqueo
    lockOutTime: segundos de bloqueo (300 = 5 minutos)
  -->
  <Realm className="org.apache.catalina.realm.LockOutRealm"
         failureCount="5"
         lockOutTime="300"
         cacheSize="1000">

    <!--
      CombinedRealm: intenta autenticación en múltiples Realms en orden.
      Si uno falla, intenta el siguiente.
    -->
    <Realm className="org.apache.catalina.realm.CombinedRealm">

      <!-- Primero: LDAP/Active Directory -->
      <Realm className="org.apache.catalina.realm.JNDIRealm"
             connectionURL="ldap://ldap.miempresa.com:389"
             connectionName="cn=tomcat,dc=miempresa,dc=com"
             connectionPassword="ldap-password"
             userBase="ou=users,dc=miempresa,dc=com"
             userSearch="(uid={0})"
             userSubtree="true"
             roleBase="ou=groups,dc=miempresa,dc=com"
             roleName="cn"
             roleSearch="(member={0})"
             roleSubtree="true"
             referrals="follow"
             userPassword="userPassword"
             digest="SHA"/>

      <!-- Fallback: usuarios locales en BD -->
      <Realm className="org.apache.catalina.realm.DataSourceRealm"
             dataSourceName="jdbc/SecurityDB"
             userTable="app_users"
             userNameCol="username"
             userCredCol="password_hash"
             userRoleTable="app_user_roles"
             roleNameCol="role_name"
             digest="SHA-256"
             digestEncoding="UTF-8"/>

    </Realm>
  </Realm>

</Engine>
```

---

## 3.11 Configuración de ErrorReportValve

Controla la generación de páginas de error HTTP. Imprescindible en producción para no exponer información de la versión de Tomcat.

```xml
<Host name="localhost" appBase="webapps">

  <!--
    ErrorReportValve personalizado:
    showReport="false": no muestra el stack trace en páginas de error
    showServerInfo="false": no muestra la versión de Tomcat en el footer
  -->
  <Valve className="org.apache.catalina.valves.ErrorReportValve"
         showReport="false"
         showServerInfo="false"/>

</Host>
```

> ⚠️ Sin esta configuración, las páginas de error por defecto de Tomcat muestran la versión exacta del servidor, lo que facilita ataques dirigidos a vulnerabilidades conocidas de esa versión.

---

## 3.12 server.xml Completo de Referencia para Producción

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!--
  ============================================================
  Apache Tomcat 10.1.x — server.xml Producción
  Generado: 2024 | Nivel: Avanzado
  ============================================================
-->
<Server port="-1" shutdown="SHUTDOWN">

  <!-- ========== LISTENERS ========== -->
  <Listener className="org.apache.catalina.startup.VersionLoggerListener"
            logArgs="false"
            logEnv="false"
            logProps="false"/>

  <Listener className="org.apache.catalina.core.AprLifecycleListener"
            SSLEngine="on"/>

  <Listener className="org.apache.catalina.core.JreMemoryLeakPreventionListener"
            gcDaemonProtection="true"
            tokenPollerProtection="true"
            driverManagerProtection="true"
            forkJoinCommonPoolProtection="true"/>

  <Listener className="org.apache.catalina.mbeans.GlobalResourcesLifecycleListener"/>

  <Listener className="org.apache.catalina.core.ThreadLocalLeakPreventionListener"/>

  <!-- ========== GLOBAL NAMING RESOURCES ========== -->
  <GlobalNamingResources>
    <Resource name="UserDatabase"
              auth="Container"
              type="org.apache.catalina.UserDatabase"
              description="User database that can be updated and saved"
              factory="org.apache.catalina.users.MemoryUserDatabaseFactory"
              pathname="conf/tomcat-users.xml"
              readonly="true"/>
  </GlobalNamingResources>

  <!-- ========== SERVICE ========== -->
  <Service name="Catalina">

    <!-- Thread Pool compartido -->
    <Executor name="tomcatThreadPool"
              namePrefix="catalina-exec-"
              maxThreads="400"
              minSpareThreads="25"
              maxSpareThreads="75"
              maxQueueSize="200"
              prestartminSpareThreads="true"
              maxIdleTime="60000"
              daemon="true"/>

    <!-- Conector HTTP/1.1 -->
    <Connector port="8080"
               protocol="org.apache.coyote.http11.Http11NioProtocol"
               executor="tomcatThreadPool"
               connectionTimeout="20000"
               keepAliveTimeout="30000"
               maxKeepAliveRequests="100"
               acceptCount="200"
               maxConnections="10000"
               compression="on"
               compressionMinSize="2048"
               compressibleMimeType="text/html,text/xml,text/plain,
                                      text/css,application/json,
                                      application/javascript"
               URIEncoding="UTF-8"
               maxHttpHeaderSize="16384"
               maxPostSize="10485760"
               server="Apache"
               rejectIllegalHeader="true"
               redirectPort="8443"
               scheme="http"
               secure="false"/>

    <!-- Conector HTTPS -->
    <Connector port="8443"
               protocol="org.apache.coyote.http11.Http11NioProtocol"
               executor="tomcatThreadPool"
               SSLEnabled="true"
               connectionTimeout="20000"
               keepAliveTimeout="30000"
               maxConnections="10000"
               acceptCount="200"
               server="Apache"
               scheme="https"
               secure="true">

      <SSLHostConfig hostName="_default_"
                     protocols="TLSv1.2,TLSv1.3"
                     ciphers="TLS_AES_256_GCM_SHA384:TLS_AES_128_GCM_SHA256:
                              ECDHE-RSA-AES256-GCM-SHA384:
                              ECDHE-RSA-AES128-GCM-SHA256"
                     honorCipherOrder="false"
                     disableSessionTickets="false">

        <Certificate type="RSA"
                     certificateKeystoreFile="${catalina.base}/conf/ssl/keystore.jks"
                     certificateKeystorePassword="${ssl.keystore.password}"
                     certificateKeyAlias="tomcat"/>

      </SSLHostConfig>
    </Connector>

    <!-- ========== ENGINE ========== -->
    <Engine name="Catalina"
            defaultHost="localhost"
            jvmRoute="${jvmRoute}"
            startStopThreads="0">

      <Realm className="org.apache.catalina.realm.LockOutRealm"
             failureCount="5"
             lockOutTime="300">
        <Realm className="org.apache.catalina.realm.UserDatabaseRealm"
               resourceName="UserDatabase"/>
      </Realm>

      <!-- ========== HOST ========== -->
      <Host name="localhost"
            appBase="webapps"
            unpackWARs="true"
            autoDeploy="false"
            deployOnStartup="true"
            deployXML="true"
            startStopThreads="0">

        <!-- Ocultar información del servidor en páginas de error -->
        <Valve className="org.apache.catalina.valves.ErrorReportValve"
               showReport="false"
               showServerInfo="false"/>

        <!-- Access Log -->
        <Valve className="org.apache.catalina.valves.AccessLogValve"
               directory="${catalina.base}/logs"
               prefix="access"
               suffix=".log"
               rotatable="true"
               fileDateFormat="yyyy-MM-dd"
               pattern="%{X-Forwarded-For}i %l %u %t &quot;%r&quot; %s %b %D"
               resolveHosts="false"
               buffered="true"/>

        <!-- Detección de hilos bloqueados -->
        <Valve className="org.apache.catalina.valves.StuckThreadDetectionValve"
               threshold="60"
               interruptThreadThreshold="180"/>

        <!-- Rewrite Valve -->
        <Valve className="org.apache.catalina.valves.rewrite.RewriteValve"/>

      </Host>

    </Engine>
  </Service>
</Server>
```

---

## 3.13 Variables del Sistema en server.xml

Tomcat permite usar variables del sistema `${variable}` en `server.xml`, lo que facilita la externalización de valores sensibles.

```xml
<!-- Uso de variables del sistema en server.xml -->
<Connector port="${http.port}"
           protocol="org.apache.coyote.http11.Http11NioProtocol"
           .../>
```

```bash
# Definir variables en setenv.sh
export CATALINA_OPTS="$CATALINA_OPTS \
  -Dhttp.port=8080 \
  -Dhttps.port=8443 \
  -Dssl.keystore.password=mi_password_seguro \
  -DjvmRoute=node01 \
  -Ddb.url=jdbc:postgresql://prod-db:5432/appdb \
  -Ddb.username=appuser \
  -Ddb.password=dbpassword"
```

> 💡 **Buena práctica:** Externalizar todos los valores sensibles (passwords, URLs de BD, rutas) como propiedades del sistema pasadas via `setenv.sh`. Esto evita almacenar credenciales en ficheros de configuración versionados en Git.

---

## 3.14 Diferencias en server.xml por Versión de Tomcat

| Característica                          | 8.0   | 8.5   | 9.0   | 10.x  | 11.0  |
|-----------------------------------------|-------|-------|-------|-------|-------|
| `SSLHostConfig` / `Certificate`         | ❌    | ✅    | ✅    | ✅    | ✅    |
| Protocolo BIO en `<Connector>`          | ✅    | ⚠️   | ❌    | ❌    | ❌    |
| HTTP/2 via `UpgradeProtocol`            | ❌    | ✅    | ✅    | ✅    | ✅    |
| `requiredSecret` en AJP (Ghostcat fix)  | ❌    | ✅*   | ✅*   | ✅    | ✅    |
| `sessionCookieSameSite` en Context      | ❌    | ✅    | ✅    | ✅    | ✅    |
| `RateLimitFilter` Valve                 | ❌    | ❌    | ❌    | ❌    | ✅    |
| `server=""` para ocultar cabecera       | ❌    | ✅*   | ✅*   | ✅    | ✅    |
| Virtual Threads (`executor`)            | ❌    | ❌    | ❌    | ❌    | ✅    |
| `maxParameterCount` en Connector        | ❌    | ✅    | ✅    | ✅    | ✅    |

*Disponible a partir de cierta versión menor del branch.

---

## Puntos Clave del Módulo 03

- `server.xml` es el fichero de configuración central. Cualquier cambio requiere **reinicio completo**.
- En producción siempre: `port="-1"` en `<Server>`, `autoDeploy="false"` en `<Host>` y `reloadable="false"` en `<Context>`.
- Usar **`<Executor>`** compartido para gestionar un único pool de hilos entre múltiples conectores y evitar sobreprovisioning.
- El elemento **`<SSLHostConfig>`** con SNI permite servir múltiples dominios con distintos certificados desde un único puerto HTTPS.
- La **`ErrorReportValve`** con `showReport="false"` y `showServerInfo="false"` es obligatoria en producción para no exponer la versión de Tomcat.
- Externalizar credenciales y valores sensibles como **propiedades del sistema** pasadas en `setenv.sh`, nunca hardcodeadas en `server.xml`.
- El conector **AJP debe configurarse** con `secretRequired="true"` y `address="127.0.0.1"` si se utiliza, o desactivarse completamente si no es necesario.
- El elemento `<Context>` **no debe definirse en `server.xml`** en producción; usar archivos descriptores en `conf/Catalina/localhost/`.

---