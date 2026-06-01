> **Estado:** 🟢 Completo
> **Última actualización:** 2026-05
> **Nivel:** Principiante — se explican los conceptos desde cero

---

- [Módulo 03: Configuración de server.xml en Profundidad](#módulo-03-configuración-de-serverxml-en-profundidad)
  - [3.1 Visión General del Archivo server.xml](#31-visión-general-del-archivo-serverxml)
    - [¿Qué es server.xml y por qué es tan importante?](#qué-es-serverxml-y-por-qué-es-tan-importante)
    - [Estructura esquemática completa](#estructura-esquemática-completa)
  - [3.2 Elemento `<Server>`](#32-elemento-server)
    - [Atributos detallados](#atributos-detallados)
    - [Configuración de producción recomendada](#configuración-de-producción-recomendada)
  - [3.3 Listeners del Ciclo de Vida](#33-listeners-del-ciclo-de-vida)
    - [¿Qué es un Listener?](#qué-es-un-listener)
  - [3.4 GlobalNamingResources](#34-globalnamingresources)
    - [¿Qué es JNDI y para qué sirve aquí?](#qué-es-jndi-y-para-qué-sirve-aquí)
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
    - [Atributos críticos del Host — Resumen](#atributos-críticos-del-host--resumen)
  - [3.9 Elemento `<Context>` en server.xml vs Archivos Externos](#39-elemento-context-en-serverxml-vs-archivos-externos)
    - [¿Por qué NO definir el Context en server.xml?](#por-qué-no-definir-el-context-en-serverxml)
    - [Jerarquía de búsqueda de configuración del Context](#jerarquía-de-búsqueda-de-configuración-del-context)
    - [Archivo de Context descriptor externo — Producción](#archivo-de-context-descriptor-externo--producción)
    - [context.xml global (aplica a TODOS los contextos)](#contextxml-global-aplica-a-todos-los-contextos)
  - [3.10 Configuración del Engine con Realm Encadenado](#310-configuración-del-engine-con-realm-encadenado)
    - [¿Qué es un Realm encadenado y por qué usarlo?](#qué-es-un-realm-encadenado-y-por-qué-usarlo)
  - [3.11 Configuración de ErrorReportValve](#311-configuración-de-errorreportvalve)
    - [El problema que resuelve](#el-problema-que-resuelve)
  - [3.12 server.xml Completo de Referencia para Producción](#312-serverxml-completo-de-referencia-para-producción)
  - [3.13 Variables del Sistema en server.xml](#313-variables-del-sistema-en-serverxml)
    - [¿Por qué externalizar valores de server.xml?](#por-qué-externalizar-valores-de-serverxml)
  - [3.14 Diferencias en server.xml por Versión de Tomcat](#314-diferencias-en-serverxml-por-versión-de-tomcat)
  - [Puntos Clave](#puntos-clave)

---

# Módulo 03: Configuración de server.xml en Profundidad

## 3.1 Visión General del Archivo server.xml

### ¿Qué es server.xml y por qué es tan importante?

`server.xml` es el **archivo de configuración central** de Apache Tomcat. Si Tomcat fuera una empresa, `server.xml` sería el organigrama: define quién existe, qué hace cada uno y cómo se relacionan entre sí.

Concretamente, en él se define:
- Por qué puertos escucha el servidor y con qué protocolo
- Qué dominios (sitios web) atiende
- Qué aplicaciones están desplegadas en cada dominio
- Cómo se autentican los usuarios
- Qué filtros procesa cada petición antes de llegar a tu aplicación
- Qué recursos externos (bases de datos, etc.) están disponibles

El archivo se encuentra en `$CATALINA_BASE/conf/server.xml`.

> ⚠️ **Regla fundamental:** Cualquier cambio en `server.xml` requiere **reiniciar completamente Tomcat** para que tenga efecto. No hay forma de recargar solo este archivo en caliente.

### Estructura esquemática completa

Es útil entender primero la "foto de familia" de todos los elementos que pueden aparecer en `server.xml`, antes de estudiar cada uno en detalle:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Server>
  <!-- Listeners: código que reacciona a eventos del ciclo de vida del servidor -->
  <Listener .../>

  <!-- Recursos JNDI globales: bases de datos y otros recursos compartidos -->
  <GlobalNamingResources>
    <Resource .../>
  </GlobalNamingResources>

  <!-- Service: agrupa conectores con un motor de procesamiento -->
  <Service>
    <!-- Connector: abre un puerto y recibe peticiones de red -->
    <Connector .../>

    <!-- Engine: enruta cada petición al Host correcto -->
    <Engine>
      <!-- Realm: define de dónde se obtienen usuarios y contraseñas -->
      <Realm .../>

      <!-- Host: representa un dominio o sitio web -->
      <Host>
        <!-- Valve: filtro que intercepta peticiones en este Host -->
        <Valve .../>

        <!-- Context: representa una aplicación web concreta -->
        <Context>
          <!-- Resource: base de datos u otro recurso de esta aplicación -->
          <Resource .../>
          <!-- Valve: filtro que intercepta peticiones en este Context -->
          <Valve .../>
        </Context>

      </Host>
    </Engine>
  </Service>
</Server>
```

---

## 3.2 Elemento `<Server>`

El elemento `<Server>` es la **raíz del documento** XML: contiene a todos los demás. Solo puede haber uno por instancia de Tomcat.

Su función principal en el archivo es configurar el **socket de shutdown**: el mecanismo por el que se puede decirle a Tomcat que se apague limpiamente enviando una cadena de texto a un puerto TCP.

```xml
<Server port="8005"
        shutdown="SHUTDOWN"
        address="127.0.0.1"
        className="org.apache.catalina.core.StandardServer">
```

### Atributos detallados

| Atributo    | Tipo    | Qué hace                                                              | Valor recomendado en producción |
|-------------|---------|-----------------------------------------------------------------------|---------------------------------|
| `port`      | entero  | Puerto TCP donde escucha el comando de apagado                        | `-1` (desactivado)              |
| `shutdown`  | texto   | La cadena que Tomcat espera recibir para apagarse                     | Valor aleatorio largo           |
| `address`   | texto   | Desde qué IP acepta el comando de apagado                             | `127.0.0.1` (solo localhost)    |
| `className` | texto   | Clase Java que implementa el Server (raramente se cambia)             | Dejar el valor por defecto      |

### Configuración de producción recomendada

```xml
<!-- En producción, desactivamos el puerto de shutdown por socket.
     Así no hay ningún puerto abierto que un atacante pueda usar para
     apagar el servidor enviando la cadena "SHUTDOWN".
     El control del proceso se delega a systemd (ver Módulo 02). -->
<Server port="-1" shutdown="SHUTDOWN">
```

> ⚠️ **¿Qué pasa cuando desactivas el puerto con `port="-1"`?**
> El comando `shutdown.sh` que viene con Tomcat dejará de funcionar, porque usa internamente ese socket para comunicarse con el servidor. En cambio, systemd (o el gestor de servicios del sistema operativo) sigue pudiendo parar el proceso normalmente. Es el precio a pagar por la seguridad: usas una herramienta más robusta para gestionar el proceso.

---

## 3.3 Listeners del Ciclo de Vida

### ¿Qué es un Listener?

Un **Listener** es un componente que "escucha" los eventos del ciclo de vida de Tomcat (arranque, parada, etc.) y ejecuta código cuando ocurren. Es el equivalente a los "event handlers" de JavaScript, pero para el propio servidor.

Se declaran como elementos hijos directos de `<Server>` y Tomcat los llama automáticamente en los momentos apropiados.

```xml
<Server port="-1" shutdown="SHUTDOWN">

  <!--
    AprLifecycleListener:
    Intenta cargar las librerías nativas APR (Apache Portable Runtime)
    al arrancar. APR es código C que puede mejorar el rendimiento de las
    conexiones TLS/SSL usando OpenSSL directamente.
    Si APR no está instalado, Tomcat lo ignora y usa la implementación
    Java pura (JSSE). No es un error.
    SSLEngine="on": si APR está disponible, usarlo para SSL/TLS.
  -->
  <Listener className="org.apache.catalina.core.AprLifecycleListener"
            SSLEngine="on"
            SSLRandomSeed="builtin"/>

  <!--
    JreMemoryLeakPreventionListener:
    ¿Por qué existe? Cuando redespliegas una aplicación (undeploy + deploy),
    Tomcat carga un nuevo ClassLoader con las nuevas clases. El ClassLoader
    antiguo debería ser recolectado por el GC y liberarse de memoria.
    Pero hay bugs conocidos en la JVM donde ciertas clases del sistema
    (drivers de BD, parsers XML, etc.) guardan referencias al ClassLoader
    antiguo, impidiendo que la memoria se libere. Esto se llama "memory leak".
    Este Listener fuerza la inicialización de esas clases problemáticas en el
    ClassLoader correcto (el del sistema) antes de que las aplicaciones carguen,
    evitando así el problema.
    Es esencial en entornos donde se redesplegan aplicaciones frecuentemente
    sin reiniciar Tomcat.
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
    Gestiona el ciclo de vida de los recursos JNDI globales
    (los definidos en GlobalNamingResources, más abajo).
    Por ejemplo, si defines una UserDatabase global, este Listener se
    encarga de inicializarla al arrancar y liberarla al parar.
    Es imprescindible si usas UserDatabase para la autenticación del Manager.
  -->
  <Listener className="org.apache.catalina.mbeans.GlobalResourcesLifecycleListener"/>

  <!--
    ThreadLocalLeakPreventionListener:
    Un ThreadLocal es una variable Java donde cada hilo tiene su propia
    copia independiente del valor. Si una aplicación usa ThreadLocal y el
    hilo que la creó sigue vivo en el pool después de que la aplicación se
    redespliegue, el ClassLoader antiguo no puede liberarse.
    Este Listener lo evita "renovando" los hilos del pool cuando un Context
    se detiene, forzando que los viejos ThreadLocals queden sin referencia.
  -->
  <Listener className="org.apache.catalina.core.ThreadLocalLeakPreventionListener"/>

  <!--
    VersionLoggerListener:
    Al arrancar, escribe en el log la versión exacta de Tomcat, de la JVM,
    el sistema operativo y los argumentos de arranque.
    Muy útil para auditorías ("¿qué versión está corriendo en producción?")
    y para depurar problemas ("¿con qué parámetros JVM arrancó?").
    logArgs="true": incluye los argumentos de la JVM en el log.
    logEnv="false": NO incluir variables de entorno (pueden contener contraseñas).
    logProps="false": NO incluir propiedades del sistema (pueden contener contraseñas).
  -->
  <Listener className="org.apache.catalina.startup.VersionLoggerListener"
            logArgs="true"
            logEnv="false"
            logProps="false"/>

</Server>
```

---

## 3.4 GlobalNamingResources

### ¿Qué es JNDI y para qué sirve aquí?

**JNDI** (Java Naming and Directory Interface) es un sistema de "directorio de recursos" de Java. Funciona como una agenda: en lugar de que cada aplicación guarde la dirección y credenciales de la base de datos en su propio código, la aplicación pregunta al directorio JNDI por nombre y JNDI le devuelve la conexión ya configurada.

**Ventajas:**
- La aplicación no necesita saber la IP de la base de datos, ni el usuario, ni la contraseña
- Si cambia la base de datos, solo cambias la configuración de Tomcat, no el código de la aplicación
- Varias aplicaciones pueden compartir el mismo pool de conexiones

`GlobalNamingResources` define los recursos JNDI disponibles a nivel global para todo el servidor.

```xml
<GlobalNamingResources>

  <!--
    UserDatabase: almacén de usuarios y contraseñas.
    Es el recurso que usa la aplicación Manager de Tomcat para autenticarse.
    Lee los datos de conf/tomcat-users.xml.
    readonly="false": permite modificar usuarios en caliente desde el Manager.
    readonly="true": más seguro para producción.
  -->
  <Resource name="UserDatabase"
            auth="Container"
            type="org.apache.catalina.UserDatabase"
            description="User database that can be updated and saved"
            factory="org.apache.catalina.users.MemoryUserDatabaseFactory"
            pathname="conf/tomcat-users.xml"
            readonly="false"/>

  <!--
    DataSource global: un pool de conexiones a base de datos
    compartido entre todas las aplicaciones.

    Un "pool de conexiones" mantiene un conjunto de conexiones ya abiertas
    y listas para usar. Cuando tu aplicación necesita hablar con la BD,
    toma una del pool, la usa, y la devuelve. Abrir una conexión nueva
    puede tardar cientos de milisegundos; tomar una del pool es instantáneo.

    Los atributos de validación (testOnBorrow, testWhileIdle, etc.) detectan
    conexiones rotas o caducadas y las renuevan antes de dárselas a la
    aplicación, evitando errores en producción.
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

Los recursos globales no son accesibles directamente desde las aplicaciones: hay que "publicarlos" en el contexto de cada aplicación con un `ResourceLink`. Esto permite que la aplicación use un nombre local diferente al nombre global:

```xml
<!-- conf/Catalina/localhost/myapp.xml -->
<Context path="/myapp" docBase="/opt/apps/myapp">

  <!--
    ResourceLink: "conecta" un nombre local de la aplicación con el recurso global.
    name="jdbc/MyDB"       → el nombre con el que la aplicación lo pide por JNDI
    global="jdbc/GlobalDB" → el nombre en GlobalNamingResources

    La aplicación hace: context.lookup("java:comp/env/jdbc/MyDB")
    y obtiene la conexión, sin saber nada del nombre real del recurso global.
  -->
  <ResourceLink name="jdbc/MyDB"
                global="jdbc/GlobalDB"
                auth="Container"
                type="javax.sql.DataSource"/>

</Context>
```

---

## 3.5 Elemento `<Service>`

El `<Service>` es un contenedor organizativo que agrupa uno o más `<Connector>` con un único `<Engine>`. En la mayoría de instalaciones solo hay uno, llamado `Catalina` por tradición histórica.

```xml
<Service name="Catalina"
         className="org.apache.catalina.core.StandardService">
```

### Caso de uso con múltiples Services

El escenario más común que justifica múltiples Services es tener **tráfico público y tráfico interno separados** en el mismo servidor Tomcat, con pools de hilos independientes para que el tráfico interno nunca se vea afectado por la carga del tráfico público:

```xml
<Server port="-1" shutdown="SHUTDOWN">

  <!-- Service 1: tráfico público -->
  <Service name="Catalina">
    <Connector port="8080" protocol="org.apache.coyote.http11.Http11NioProtocol" .../>
    <Engine name="Catalina" defaultHost="public.miempresa.com">
      <Host name="public.miempresa.com" appBase="/opt/webapps/public"/>
    </Engine>
  </Service>

  <!-- Service 2: tráfico interno/admin.
       address="10.0.0.1" hace que el conector solo escuche en la IP interna,
       nunca en la IP pública. Un cliente externo no puede conectarse
       aunque el puerto estuviera abierto en el firewall. -->
  <Service name="Admin">
    <Connector port="9080"
               protocol="org.apache.coyote.http11.Http11NioProtocol"
               address="10.0.0.1"/>
    <Engine name="Admin" defaultHost="admin.miempresa.internal">
      <Host name="admin.miempresa.internal" appBase="/opt/webapps/admin"/>
    </Engine>
  </Service>

</Server>
```

---

## 3.6 Elemento `<Connector>` — Configuración Exhaustiva

El `<Connector>` es el componente que abre un puerto de red y gestiona las conexiones entrantes. Es el punto de contacto entre el mundo exterior (los navegadores, las apps móviles, las APIs) y el interior de Tomcat.

### 3.6.1 Conector HTTP/1.1 NIO — Producción estándar

Este es el conector más habitual: escucha en el puerto 8080 y acepta tráfico HTTP sin cifrar. En producción suele haber un proxy delante (Nginx, Apache httpd, un load balancer) que gestiona TLS externamente, y este conector recibe el tráfico ya descifrado desde el proxy.

```xml
<Connector
  port="8080"
  protocol="org.apache.coyote.http11.Http11NioProtocol"

  connectionTimeout="20000"
  <!-- Tiempo máximo (ms) para que el cliente envíe la petición completa
       tras conectarse. 20s es razonable. Protege contra ataques Slowloris
       (conexiones deliberadamente lentas para agotar hilos del servidor). -->

  keepAliveTimeout="30000"
  <!-- HTTP keep-alive permite reutilizar la misma conexión TCP para varias
       peticiones, evitando el coste de abrir una nueva por cada recurso
       (CSS, JS, imágenes...). Este valor define cuántos ms se mantiene
       la conexión abierta esperando la siguiente petición. -->

  maxKeepAliveRequests="100"
  <!-- Máximo de peticiones que puede hacer un cliente en una misma
       conexión keep-alive antes de forzar que abra una nueva. -->

  asyncTimeout="30000"
  <!-- Para Servlets asíncronos: tiempo máximo que puede estar procesando
       una operación asíncrona antes de que Tomcat la cancele. -->

  disableUploadTimeout="true"
  <!-- true: usar siempre connectionTimeout, incluso durante subidas de archivos. -->

  maxThreads="400"
  <!-- Número máximo de peticiones que se pueden procesar simultáneamente.
       Cada petición ocupa un hilo. Si llegan 401 peticiones simultáneas,
       la 401 espera en la cola (acceptCount). Aumentar este valor aumenta
       el consumo de memoria. Regla de partida: núcleos x 50. -->

  minSpareThreads="25"
  <!-- Hilos mínimos siempre en standby, listos para reaccionar al instante.
       Evita la latencia de crear hilos nuevos bajo una ráfaga de tráfico. -->

  maxSpareThreads="75"
  <!-- Si hay más de 75 hilos en espera sin trabajo, Tomcat los termina
       para liberar memoria. -->

  prestartminSpareThreads="true"
  <!-- Crear los minSpareThreads al arrancar el conector, no en la primera
       petición. Mejora el tiempo de respuesta de las primeras peticiones. -->

  acceptCount="200"
  <!-- Tamaño de la cola del SO para conexiones cuando todos los hilos están
       ocupados. Si la cola se llena, nuevas conexiones reciben error.
       Es la "sala de espera" cuando el servidor está al límite. -->

  maxConnections="10000"
  <!-- Conexiones TCP simultáneas máximas. Con NIO, un hilo puede vigilar
       miles de conexiones inactivas, por eso este valor puede ser mucho
       mayor que maxThreads. -->

  acceptorThreadCount="2"
  <!-- Hilos dedicados a aceptar nuevas conexiones TCP. 2 es suficiente
       en la mayoría de casos. -->

  URIEncoding="UTF-8"
  <!-- Codificación de los caracteres especiales en la URL. Siempre UTF-8. -->

  maxHttpHeaderSize="16384"
  <!-- Tamaño máximo en bytes de las cabeceras HTTP (16 KB). Protege contra
       ataques que intentan agotar memoria con cabeceras enormes.
       Aumentar si usas tokens JWT muy largos en la cabecera Authorization. -->

  maxPostSize="10485760"
  <!-- Tamaño máximo del cuerpo de peticiones POST (10 MB).
       Para subida de archivos grandes, aumentar este valor. -1 sin límite. -->

  maxParameterCount="1000"
  <!-- Número máximo de parámetros en una petición. Protege contra el ataque
       "Hash Collision DoS" donde miles de parámetros saturan la CPU. -->

  compression="on"
  <!-- Activa la compresión gzip/deflate de respuestas automáticamente.
       Puede reducir el tamaño de respuestas HTML/JSON un 60-80%. -->

  compressionMinSize="2048"
  <!-- Solo comprimir respuestas de más de 2 KB. Comprimir respuestas
       muy pequeñas no vale la pena: el overhead supera el ahorro. -->

  noCompressionUserAgents="gozilla, traviata"
  <!-- Agentes con bugs de compresión conocidos que no deben recibir
       respuestas comprimidas. Lista de clientes obsoletos. -->

  compressibleMimeType="text/html,text/xml,text/plain,text/css,
                         text/javascript,application/javascript,
                         application/json,application/xml"
  <!-- Solo comprimir estos tipos de contenido. No comprimir imágenes JPEG
       o ZIPs que ya están comprimidos (empeoraría el rendimiento). -->

  scheme="http"
  <!-- El esquema de la URL tal como lo ve el cliente (http o https).
       Cuando hay un proxy delante con SSL termination, el proxy habla HTTPS
       con el cliente pero HTTP con Tomcat. Sin este atributo, la aplicación
       pensaría que el cliente usa HTTP. -->

  secure="false"
  <!-- true cuando el proxy delante hace SSL y Tomcat recibe HTTP. -->

  redirectPort="8443"
  <!-- Cuando una aplicación marca un recurso como "solo HTTPS" en su web.xml,
       Tomcat redirige al cliente a este puerto. -->

  server="Apache"
  <!-- Valor de la cabecera HTTP "Server:" en las respuestas.
       Por defecto sería "Apache-Coyote/1.1", revelando que es Tomcat.
       Cambiarlo a "Apache" oculta información a posibles atacantes.
       En versiones recientes, server="" elimina la cabecera completamente. -->

  rejectIllegalHeader="true"
  <!-- Rechazar peticiones con cabeceras HTTP malformadas. Protege contra
       ciertos ataques de inyección de cabeceras. -->

  allowHostHeaderMismatch="false"
  <!-- Rechazar peticiones donde el Host header no coincide con ningún
       Host configurado. Protege contra Host header injection. -->
/>
```

### 3.6.2 Conector HTTPS/TLS con JSSE — Tomcat 8.5+

Este conector maneja el cifrado TLS directamente en Tomcat, sin necesidad de un proxy externo. Es el apropiado cuando Tomcat es el servidor web final (sin Nginx ni Apache httpd delante).

**¿Qué es TLS/SSL?** Es el protocolo que cifra la comunicación entre el navegador y el servidor. Cuando ves el candado en la barra del navegador, hay TLS activo. Requiere un **certificado digital** que demuestra la identidad del servidor.

**¿Qué es SNI?** (Server Name Indication) Es una extensión de TLS que permite que un servidor presente diferentes certificados según el dominio que pide el cliente. Sin SNI, un servidor solo puede tener un certificado por IP. Con SNI, puede tener uno por dominio, todos compartiendo la misma IP y puerto.

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
    SSLHostConfig: configuración TLS para un dominio concreto.
    hostName="_default_" es la configuración por defecto para todos
    los dominios que no tengan su propio SSLHostConfig.
  -->
  <SSLHostConfig
    hostName="_default_"
    protocols="TLSv1.2,TLSv1.3"
    <!-- Solo TLS 1.2 y 1.3. TLS 1.0 y 1.1 están obsoletos y son inseguros. -->

    ciphers="TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:
             TLS_AES_128_GCM_SHA256:ECDHE-RSA-AES256-GCM-SHA384:
             ECDHE-RSA-AES128-GCM-SHA256"
    <!-- Lista de algoritmos de cifrado permitidos. Los que empiezan por TLS_
         son de TLS 1.3. ECDHE proporciona "Perfect Forward Secrecy": si la
         clave privada del servidor se compromete en el futuro, las
         comunicaciones pasadas no pueden ser descifradas retroactivamente. -->

    honorCipherOrder="false"
    <!-- false: el cliente elige el cifrado (de la lista de permitidos).
         Comportamiento moderno recomendado para TLS 1.3. -->

    disableSessionTickets="false"
    sessionTimeout="86400"
    certificateVerification="none"
    <!-- "none": no se pide certificado al cliente (lo normal en webs públicas).
         "required": obligar al cliente a presentar un certificado (mTLS). -->
    >

    <!-- Certificado RSA: el tipo más común y compatible -->
    <Certificate
      type="RSA"
      certificateKeystoreFile="${catalina.base}/conf/ssl/keystore.jks"
      <!-- El "keystore" es un archivo que contiene el certificado del servidor
           y su clave privada. Usar ${catalina.base} en vez de rutas absolutas
           hace la configuración más portable entre servidores. -->
      certificateKeystorePassword="changeit"
      <!-- En producción, externalizar con variable del sistema (ver sección 3.13).
           Nunca en texto plano en un archivo versionado en Git. -->
      certificateKeyAlias="tomcat"
      certificateKeystoreType="JKS"/>
      <!-- JKS (Java KeyStore) o PKCS12. PKCS12 es el estándar moderno. -->

    <!-- Certificado ECDSA: más moderno y eficiente que RSA.
         Con "dual-cert" (RSA + ECDSA), el cliente negocia automáticamente
         el mejor que soporte. -->
    <Certificate
      type="EC"
      certificateKeystoreFile="${catalina.base}/conf/ssl/keystore-ec.jks"
      certificateKeystorePassword="changeit"
      certificateKeyAlias="tomcat-ec"
      certificateKeystoreType="JKS"/>

  </SSLHostConfig>

  <!-- SSLHostConfig adicional para un dominio específico (SNI).
       Si el cliente pide "api.miempresa.com", Tomcat usa este certificado
       en lugar del _default_. Gestiona múltiples dominios con diferentes
       certificados en el mismo puerto 8443. -->
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

El TLS estándar solo autentica al servidor. El **mTLS** (mutual TLS) añade autenticación en ambos sentidos: el servidor también verifica la identidad del cliente mediante un certificado digital. Se usa en comunicaciones máquina a máquina (microservicios, APIs internas) donde quieres garantizar criptográficamente que el cliente es quien dice ser.

```xml
<!-- Puerto diferente (8444) para mTLS, separado del HTTPS normal (8443) -->
<Connector port="8444"
           protocol="org.apache.coyote.http11.Http11NioProtocol"
           SSLEnabled="true"
           scheme="https"
           secure="true">

  <SSLHostConfig
    protocols="TLSv1.2,TLSv1.3"
    certificateVerification="required"
    <!-- "required": el cliente DEBE presentar un certificado.
         Si no lo tiene, la conexión TLS se rechaza antes de llegar
         siquiera a ningún Servlet. -->

    truststoreFile="${catalina.base}/conf/ssl/truststore.jks"
    <!-- El "truststore" es el almacén de certificados en los que Tomcat CONFÍA.
         Solo los clientes con certificados firmados por las CAs de este
         truststore podrán conectarse. Es una lista blanca de clientes
         autorizados a nivel de certificado. -->

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

Por defecto, cada `<Connector>` tiene su propio pool de hilos. Con dos conectores (HTTP y HTTPS), tienes dos pools separados, lo que puede llevar a un uso ineficiente: uno saturado y el otro casi vacío.

Un `<Executor>` define un **pool de hilos compartido** que ambos conectores usan, distribuyendo la carga total sobre el mismo conjunto de hilos:

```xml
<!-- El Executor se declara ANTES de los Connectors que lo usan.
     El atributo "name" es el identificador que referenciarán. -->
<Executor
  name="tomcatThreadPool"
  namePrefix="catalina-exec-"
  <!-- Prefijo del nombre de cada hilo. Útil para identificarlos en
       herramientas de monitorización y en thread dumps de diagnóstico. -->

  maxThreads="500"
  minSpareThreads="25"
  maxSpareThreads="100"

  maxQueueSize="100"
  <!-- Si todos los hilos están ocupados, nuevas peticiones entran en esta
       cola. Si la cola también se llena, la petición se rechaza. -->

  prestartminSpareThreads="true"
  maxIdleTime="60000"

  className="org.apache.catalina.core.StandardThreadExecutor"
  threadPriority="5"
  daemon="true"/>

<!-- Los Connectors referencian el Executor por su nombre.
     Al especificar "executor", se ignoran los atributos maxThreads/minSpareThreads
     propios del Connector. -->
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

**AJP** (Apache JServ Protocol) es un protocolo binario que permite que Apache httpd actúe como proxy frente a Tomcat. Se usa cuando Apache httpd recibe el tráfico externo (gestionando TLS, sirviendo archivos estáticos) y reenvía las peticiones dinámicas a Tomcat.

**Ghostcat (CVE-2020-1938):** En 2020 se descubrió que el conector AJP permitía a cualquiera que pudiera conectarse al puerto 8009 leer archivos arbitrarios del servidor sin autenticarse. Desde entonces, AJP está deshabilitado por defecto en Tomcat y requiere configuración explícita de seguridad:

```xml
<!-- Solo activar si realmente se usa con Apache httpd via mod_proxy_ajp.
     Si no lo necesitas, no pongas este elemento. -->
<Connector protocol="AJP/1.3"
           address="127.0.0.1"
           <!-- CRÍTICO: solo aceptar conexiones desde la misma máquina.
                Así aunque alguien escaneara el puerto 8009 desde fuera,
                no podría conectarse. -->
           port="8009"
           redirectPort="8443"
           maxThreads="200"
           connectionTimeout="20000"
           keepAliveTimeout="60000"
           maxKeepAliveRequests="100"
           secretRequired="true"
           requiredSecret="clave-secreta-ajp-aleatoria-256bits"
           <!-- Apache httpd debe incluir esta clave en cada petición AJP.
                Actúa como pre-autenticación entre Apache y Tomcat.
                Debe ser la misma que en la directiva ProxyPass de Apache httpd:
                ProxyPass / ajp://localhost:8009/ secret=clave-secreta-ajp... -->
           tomcatAuthentication="false"
           <!-- false: si Apache httpd ya autenticó al usuario, Tomcat confía. -->
           tomcatAuthorization="false"
           allowedRequestAttributesPattern=".*"/>
```

---

## 3.7 Elemento `<Engine>`

El `<Engine>` es el motor de enrutamiento de Tomcat. Recibe las peticiones del Connector y decide a qué `<Host>` enviárselas, basándose en el encabezado `Host:` de la petición HTTP.

```xml
<Engine
  name="Catalina"
  defaultHost="localhost"
  <!-- Si la cabecera Host: de la petición no coincide con ningún Host
       configurado, la petición va a este Host por defecto. -->

  jvmRoute="node01"
  <!-- Identificador único de este nodo en un clúster.
       Se añade al final del ID de sesión: JSESSIONID=ABC123.node01
       Un balanceador de carga puede leer este sufijo para enviar siempre
       al mismo usuario al mismo nodo (sticky sessions), evitando que
       el usuario pierda su sesión al ser enviado a otro servidor. -->

  className="org.apache.catalina.core.StandardEngine"

  backgroundProcessorDelay="10"
  <!-- Cada 10 segundos Tomcat ejecuta tareas de mantenimiento en background:
       verificar WARs nuevos (si autoDeploy está activo), limpiar sesiones
       expiradas, etc. -1 desactiva el hilo de background. -->

  startStopThreads="0">
  <!-- Hilos para arrancar o parar los Hosts en paralelo.
       0 = usar tantos hilos como núcleos de CPU tenga el servidor. -->

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

| Atributo                    | Qué hace                                                                              |
|-----------------------------|---------------------------------------------------------------------------------------|
| `name`                      | Nombre lógico del Engine (normalmente "Catalina")                                     |
| `defaultHost`               | Host receptor de peticiones sin Host header coincidente                               |
| `jvmRoute`                  | Sufijo al JSESSIONID para sticky sessions en clúster                                  |
| `backgroundProcessorDelay`  | Segundos entre ejecuciones del hilo de mantenimiento en background                    |
| `startStopThreads`          | Hilos para arrancar/parar Hosts en paralelo. `0` = número de CPUs                    |

---

## 3.8 Elemento `<Host>` — Hosts Virtuales

Un `<Host>` representa un **sitio web o dominio virtual**. Gracias a los hosts virtuales, un único servidor Tomcat puede alojar múltiples sitios web con dominios diferentes.

El mecanismo es sencillo: cuando llega una petición, Tomcat lee la cabecera `Host:` (que el navegador envía automáticamente) y la compara con los nombres de los `<Host>` configurados para saber cuál debe atenderla.

### Configuración completa de un Host virtual

```xml
<Host
  name="app.miempresa.com"
  <!-- El nombre del dominio. DEBE coincidir exactamente con lo que el
       navegador envía en la cabecera "Host:". -->

  appBase="/opt/webapps/app"
  <!-- Directorio donde Tomcat busca las aplicaciones (WARs o carpetas).
       Puede ser ruta absoluta o relativa a CATALINA_BASE. -->

  unpackWARs="true"
  <!-- Si true, Tomcat descomprime el archivo .war en una carpeta.
       Las aplicaciones descomprimidas arrancan más rápido. -->

  autoDeploy="false"
  <!-- PRODUCCIÓN: siempre false.
       Si true, Tomcat vigila continuamente appBase y despliega cualquier
       WAR nuevo o modificado que detecte. Un archivo copiado por error
       podría desplegarse involuntariamente. -->

  deployOnStartup="true"
  <!-- Al arrancar Tomcat, desplegar todas las aplicaciones en appBase. -->

  deployXML="true"
  <!-- Permite que los WARs incluyan META-INF/context.xml con su propia
       configuración de Context. false en entornos estrictos donde solo
       el administrador del servidor puede configurar los Contexts. -->

  copyXML="false"

  workDir="${catalina.base}/work/Catalina/app.miempresa.com"
  <!-- Directorio para JSPs compilados y archivos temporales de este Host. -->

  startStopThreads="0"
  backgroundProcessorDelay="-1"
  <!-- -1: hereda el valor del Engine padre. -->

  className="org.apache.catalina.core.StandardHost">

  <!-- Alias: otros nombres de dominio que también apuntan a este Host. -->
  <Alias>www.miempresa.com</Alias>
  <Alias>miempresa.com</Alias>

  <!-- Access Log: registra cada petición HTTP en un archivo.
       %D es el tiempo de respuesta en milisegundos: imprescindible para
       detectar peticiones lentas en producción. -->
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

  <!-- Detección de hilos "atascados": cuando una petición lleva procesándose
       demasiado tiempo, probablemente hay un problema (consulta SQL bloqueada,
       deadlock, llamada a servicio externo que no responde). -->
  <Valve className="org.apache.catalina.valves.StuckThreadDetectionValve"
         threshold="60"
         <!-- Después de 60s procesando, registrar advertencia en el log -->
         interruptThreadThreshold="180"/>
         <!-- Después de 180s, interrumpir el hilo forzosamente -->

  <!-- Rate Limiting (solo Tomcat 11+): limita peticiones por cliente.
       Descomentar si usas Tomcat 11:
  <Valve className="org.apache.catalina.valves.RateLimitFilter"
         duration="60"
         requests="1000"
         enforce="true"/>
  -->

</Host>
```

### Atributos críticos del Host — Resumen

| Atributo           | Qué hace                                                                        | Recomendación en producción  |
|--------------------|---------------------------------------------------------------------------------|------------------------------|
| `autoDeploy`       | Vigila el directorio y despliega cambios automáticamente mientras corre Tomcat  | `false`                      |
| `deployOnStartup`  | Despliega todo lo que haya en `appBase` al arrancar                             | `true`                       |
| `deployXML`        | Permite que los WARs configuren su propio Context via META-INF/context.xml      | `false` en entornos estrictos|
| `copyXML`          | Copia el context.xml del WAR al directorio conf/                                | `false`                      |
| `unpackWARs`       | Descomprime los WARs en disco (mejor rendimiento de arranque)                   | `true`                       |

---

## 3.9 Elemento `<Context>` en server.xml vs Archivos Externos

Un `<Context>` representa una **aplicación web concreta**. Aunque se puede definir dentro de `server.xml`, hay razones importantes para hacerlo en un archivo separado.

### ¿Por qué NO definir el Context en server.xml?

Cuando defines un Context en `server.xml`, cualquier cambio (añadir un parámetro de configuración, cambiar la URL de la base de datos) requiere **reiniciar todo Tomcat**, con el consiguiente corte de servicio para todas las aplicaciones.

Si el Context está en un archivo separado (`conf/Catalina/localhost/myapp.xml`), Tomcat puede recargar ese contexto individual sin afectar a las demás aplicaciones.

### Jerarquía de búsqueda de configuración del Context

Tomcat busca la configuración de cada aplicación en este orden, dando prioridad a la más específica:

```
1. conf/[EngineName]/[HostName]/[AppName].xml   ← Mayor prioridad (recomendado en producción)
2. conf/context.xml                             ← Aplica a TODAS las aplicaciones
3. WAR/META-INF/context.xml                     ← Configuración dentro del propio WAR
4. <Context> en server.xml                      ← Menor prioridad, evitar en producción
```

### Archivo de Context descriptor externo — Producción

```xml
<!-- conf/Catalina/localhost/myapp.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<Context
  path="/myapp"
  <!-- path="/myapp" → accesible en http://servidor:8080/myapp
       path="" → aplicación ROOT, accesible en http://servidor:8080/ -->

  docBase="/opt/apps/myapp-2.3.1"
  <!-- Ruta absoluta al directorio descomprimido o al archivo .war.
       Al actualizar la aplicación, basta con cambiar este path
       para apuntar a la nueva versión y reiniciar el contexto. -->

  reloadable="false"
  <!-- false: Tomcat NO vigila cambios en WEB-INF/classes/ y WEB-INF/lib/.
       En producción siempre false. Si pones true, Tomcat gasta CPU
       monitorizando archivos y puede causar memory leaks al recargar
       el ClassLoader. Solo true en desarrollo. -->

  crossContext="false"
  <!-- false: esta app no puede acceder al contexto de otras aplicaciones.
       Mantiene el aislamiento entre aplicaciones. -->

  privileged="false"
  <!-- false: usa el ClassLoader estándar de aplicaciones.
       Nunca true en aplicaciones normales. -->

  antiResourceLocking="false"
  <!-- En Windows, Tomcat puede bloquear archivos del WAR impidiendo
       actualizaciones. true evita esto en Windows. En Linux no es necesario. -->

  sessionCookieName="MYAPP_SESSION"
  <!-- Cambiar el nombre de la cookie de sesión (por defecto "JSESSIONID")
       oculta que el servidor usa Java/Tomcat. -->

  sessionCookiePath="/"
  sessionCookieHttpOnly="true"
  <!-- IMPORTANTE: impide que JavaScript pueda leer la cookie de sesión.
       Protege contra ataques XSS que intentan robar la cookie del usuario.
       Siempre true en producción. -->

  sessionCookieSecure="true"
  <!-- IMPORTANTE: la cookie de sesión solo se envía por HTTPS, nunca por HTTP.
       Siempre true en producción si usas HTTPS. -->

  sessionCookieSameSite="Strict"
  <!-- Protección CSRF: la cookie solo se envía cuando la petición viene
       del mismo dominio. "Strict" = máxima protección. -->

  useHttpOnly="true"
  clearReferencesObjectStreamClassCaches="true"
  clearReferencesRmiTargets="true"
  clearReferencesThreadLocals="true">

  <!-- Pool de conexiones local a esta aplicación.
       Diferencia con GlobalNamingResources: solo existe para esta app. -->
  <Resource
    name="jdbc/AppDB"
    auth="Container"
    type="javax.sql.DataSource"
    factory="org.apache.tomcat.jdbc.pool.DataSourceFactory"
    driverClassName="org.postgresql.Driver"
    url="jdbc:postgresql://db-host:5432/appdb?ssl=true&amp;sslmode=require"
    <!-- &amp; es la forma de escribir & en XML. En una URL JDBC los
         parámetros se separan con &. -->
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
                      SlowQueryReport(threshold=1000)"
    <!-- SlowQueryReport(threshold=1000): registra queries que tardan
         más de 1000ms. Esencial para detectar cuellos de botella en BD. -->
    />

  <!-- Referencia a un recurso definido en GlobalNamingResources -->
  <ResourceLink
    name="jdbc/SharedDB"
    global="jdbc/GlobalDB"
    type="javax.sql.DataSource"/>

  <!-- Environment: variables de configuración accesibles via JNDI.
       La aplicación las lee con:
       context.lookup("java:comp/env/maxCacheSize") → devuelve 1000
       override="false": la aplicación no puede sobreescribir este valor. -->
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

  <!-- Parameter: parámetros de inicialización del contexto.
       Accesibles con: getServletContext().getInitParameter("...") -->
  <Parameter
    name="com.miempresa.config.path"
    value="/opt/config/myapp/production.properties"
    override="false"/>

  <!-- Manager: configuración de la gestión de sesiones -->
  <Manager
    className="org.apache.catalina.session.StandardManager"
    maxActiveSessions="10000"
    <!-- Si se alcanzan 10000 sesiones activas, las nuevas peticiones que
         intentan crear sesión reciben un error. Protege contra DoS
         por creación masiva de sesiones. -1 significa sin límite. -->
    sessionIdLength="32"
    secureRandomAlgorithm="SHA1PRNG"
    secureRandomProvider="SUN"/>

  <!-- WatchedResource: Tomcat recarga el Context si alguno de estos archivos
       cambia. Solo actúa si reloadable="true". -->
  <WatchedResource>WEB-INF/web.xml</WatchedResource>
  <WatchedResource>WEB-INF/tomcat-web.xml</WatchedResource>
  <WatchedResource>${catalina.base}/conf/web.xml</WatchedResource>

</Context>
```

### context.xml global (aplica a TODOS los contextos)

Este archivo define configuración que se aplica por defecto a **todas las aplicaciones** del servidor. Es el lugar correcto para configuraciones de seguridad universales:

```xml
<!-- conf/context.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<Context>

  <!-- CookieProcessor moderno (más estricto y seguro que el antiguo
       LegacyCookieProcessor).
       sameSiteCookies="strict": todas las cookies del servidor tendrán
       SameSite=Strict por defecto, protegiendo contra CSRF en todas las apps. -->
  <CookieProcessor
    className="org.apache.tomcat.util.http.Rfc6265CookieProcessor"
    sameSiteCookies="strict"/>

  <WatchedResource>WEB-INF/web.xml</WatchedResource>
  <WatchedResource>${catalina.base}/conf/web.xml</WatchedResource>

  <!-- JarScanner: al arrancar cada aplicación, Tomcat escanea los JARs
       buscando TLDs y otros recursos de configuración. Con muchas dependencias
       este escaneo puede tardar bastante. JarScanFilter optimiza qué se escanea.
       tldSkip="*.jar": no escanear ningún JAR buscando TLDs (inicio más rápido).
       tldScan="taglib-*.jar": excepto los que empiezan por "taglib-".
       Ajustar según las librerías de tu aplicación. -->
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

## 3.10 Configuración del Engine con Realm Encadenado

### ¿Qué es un Realm encadenado y por qué usarlo?

Un Realm simple responde a "¿quién puede autenticarse?". Un Realm encadenado combina múltiples Realms para estrategias de autenticación más sofisticadas.

La combinación más habitual en empresas es:
1. **LockOutRealm** — añade bloqueo de cuentas tras N intentos fallidos (envuelve a cualquier otro Realm)
2. **CombinedRealm** — intenta autenticar en varios Realms en orden (LDAP corporativo primero, base de datos local como fallback)

```xml
<Engine name="Catalina" defaultHost="localhost">

  <!--
    LockOutRealm: la primera capa de seguridad.
    No autentica por sí mismo: envuelve a otro Realm y añade bloqueo de cuentas.

    failureCount="5": después de 5 intentos fallidos consecutivos...
    lockOutTime="300": ...la cuenta se bloquea 300 segundos (5 minutos).

    Protege contra ataques de fuerza bruta (probar contraseñas hasta
    dar con la correcta). Sin este mecanismo, un atacante podría probar
    millones de contraseñas sin restricción.

    cacheSize="1000": cuántas cuentas fallidas recuerda en memoria.
    cacheRemovalWarningTime="3600": avisa en el log si una cuenta lleva
    más de 1 hora en el caché de bloqueos (puede indicar un ataque sostenido).
  -->
  <Realm className="org.apache.catalina.realm.LockOutRealm"
         failureCount="5"
         lockOutTime="300"
         cacheSize="1000"
         cacheRemovalWarningTime="3600">

    <!--
      CombinedRealm: intenta autenticar en cada Realm hijo en orden.
      Si el primero falla (usuario no existe o contraseña errónea),
      intenta el siguiente. El usuario queda autenticado en cuanto uno
      tenga éxito.
    -->
    <Realm className="org.apache.catalina.realm.CombinedRealm">

      <!--
        Primer intento: LDAP / Active Directory corporativo.
        JNDIRealm conecta Tomcat con un servidor LDAP para verificar usuarios.
        Permite que los empleados usen sus credenciales corporativas
        para acceder a las aplicaciones web internas.

        connectionURL: URL del servidor LDAP
        userBase: en qué rama del directorio buscar usuarios
        userSearch: cómo buscar al usuario ({0} se reemplaza por el username)
        roleBase: en qué rama buscar los grupos/roles
        roleSearch: cómo encontrar los grupos de un usuario
      -->
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

      <!--
        Segundo intento (fallback): si el usuario no está en LDAP
        (por ejemplo, cuentas de servicio que no son empleados), buscar
        en una base de datos local.
        DataSourceRealm usa un pool JNDI ya configurado, más eficiente
        que JDBCRealm que abre sus propias conexiones.
      -->
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

### El problema que resuelve

Cuando ocurre un error en una aplicación (un 404, un 500, etc.), Tomcat genera una página HTML de error. Por defecto, esa página incluye en el pie:

```
Apache Tomcat/10.1.20
```

Esto le dice al mundo exactamente qué versión de Tomcat estás usando. Si esa versión tiene vulnerabilidades conocidas, un atacante lo sabe. Es el equivalente a poner un cartel en tu puerta diciendo "aquí vive alguien que usa la cerradura modelo X con el bug conocido Y".

```xml
<Host name="localhost" appBase="webapps">

  <!--
    showReport="false": no mostrar el stack trace de Java en la página de error.
    Un stack trace revela la estructura interna del código, las librerías
    usadas y sus versiones, lo que facilita ataques dirigidos.

    showServerInfo="false": no mostrar "Apache Tomcat/X.X.X" en el footer.
    Ocultar la versión exacta del servidor es una medida de seguridad básica.

    Ambos deben ser false en cualquier entorno de producción.
    En desarrollo puedes ponerlos a true para ver más información.
  -->
  <Valve className="org.apache.catalina.valves.ErrorReportValve"
         showReport="false"
         showServerInfo="false"/>

</Host>
```

> 💡 **¿Ocultar la versión hace el sistema más seguro?** Por sí solo no: si hay una vulnerabilidad, sigue existiendo aunque la ocultes. Pero forma parte de una estrategia de defensa en profundidad: cuanta menos información das al atacante, más difícil lo haces. La medida principal sigue siendo mantener Tomcat actualizado.

---

## 3.12 server.xml Completo de Referencia para Producción

Este es un `server.xml` completo para Tomcat 10.1.x, que combina todas las configuraciones recomendadas de las secciones anteriores:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!--
  Apache Tomcat 10.1.x — server.xml Producción
-->
<Server port="-1" shutdown="SHUTDOWN">
<!-- puerto -1: socket de shutdown desactivado. El proceso se gestiona con systemd. -->

  <!-- === LISTENERS === -->

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

  <!-- === RECURSOS JNDI GLOBALES === -->
  <GlobalNamingResources>
    <Resource name="UserDatabase"
              auth="Container"
              type="org.apache.catalina.UserDatabase"
              description="User database that can be updated and saved"
              factory="org.apache.catalina.users.MemoryUserDatabaseFactory"
              pathname="conf/tomcat-users.xml"
              readonly="true"/>
              <!-- readonly="true" en producción: nadie puede cambiar usuarios
                   sin reiniciar Tomcat. -->
  </GlobalNamingResources>

  <!-- === SERVICE === -->
  <Service name="Catalina">

    <!-- Pool de hilos compartido entre los conectores HTTP y HTTPS.
         Mejor aprovechamiento: la carga de ambos puertos se distribuye
         sobre el mismo conjunto de hilos. -->
    <Executor name="tomcatThreadPool"
              namePrefix="catalina-exec-"
              maxThreads="400"
              minSpareThreads="25"
              maxSpareThreads="75"
              maxQueueSize="200"
              prestartminSpareThreads="true"
              maxIdleTime="60000"
              daemon="true"/>

    <!-- Conector HTTP/1.1 en puerto 8080 -->
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

    <!-- Conector HTTPS en puerto 8443 -->
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

        <!-- La contraseña del keystore se lee de una propiedad del sistema
             definida en setenv.sh. No está en texto plano en este archivo. -->
        <Certificate type="RSA"
                     certificateKeystoreFile="${catalina.base}/conf/ssl/keystore.jks"
                     certificateKeystorePassword="${ssl.keystore.password}"
                     certificateKeyAlias="tomcat"/>

      </SSLHostConfig>
    </Connector>

    <!-- === ENGINE === -->
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

      <!-- === HOST === -->
      <Host name="localhost"
            appBase="webapps"
            unpackWARs="true"
            autoDeploy="false"
            deployOnStartup="true"
            deployXML="true"
            startStopThreads="0">

        <!-- Ocultar versión de Tomcat en páginas de error -->
        <Valve className="org.apache.catalina.valves.ErrorReportValve"
               showReport="false"
               showServerInfo="false"/>

        <!-- Registro de accesos HTTP -->
        <Valve className="org.apache.catalina.valves.AccessLogValve"
               directory="${catalina.base}/logs"
               prefix="access"
               suffix=".log"
               rotatable="true"
               fileDateFormat="yyyy-MM-dd"
               pattern="%{X-Forwarded-For}i %l %u %t &quot;%r&quot; %s %b %D"
               resolveHosts="false"
               buffered="true"/>

        <!-- Detectar peticiones que tardan más de 60s -->
        <Valve className="org.apache.catalina.valves.StuckThreadDetectionValve"
               threshold="60"
               interruptThreadThreshold="180"/>

        <!-- Motor de reescritura de URLs -->
        <Valve className="org.apache.catalina.valves.rewrite.RewriteValve"/>

      </Host>

    </Engine>
  </Service>
</Server>
```

---

## 3.13 Variables del Sistema en server.xml

### ¿Por qué externalizar valores de server.xml?

Hay valores en `server.xml` que no deberían estar escritos directamente en el archivo:

1. **Contraseñas** (del keystore SSL, de la base de datos): si versionas `server.xml` en Git, la contraseña quedaría en el historial para siempre, accesible para cualquiera con acceso al repositorio.
2. **Valores que cambian entre entornos** (desarrollo, staging, producción): número de hilos, puerto, identificador del nodo en clúster.

La solución es usar la sintaxis `${nombre.variable}` en `server.xml`, y definir los valores reales en `setenv.sh`:

```xml
<!-- En server.xml, referencias a propiedades del sistema.
     Tomcat las sustituye automáticamente al leer el archivo. -->
<Connector port="${http.port}"
           protocol="org.apache.coyote.http11.Http11NioProtocol"
           maxThreads="${connector.maxThreads}"
           .../>

<Engine name="Catalina"
        defaultHost="localhost"
        jvmRoute="${jvmRoute}">
        <!-- jvmRoute diferente por nodo: node01, node02, etc. -->
```

```bash
# En setenv.sh, los valores reales.
# Este archivo puede tener permisos restrictivos (chmod 600 → solo
# el propietario puede leerlo) y no necesita estar en Git.
export CATALINA_OPTS="$CATALINA_OPTS \
  -Dhttp.port=8080 \
  -Dhttps.port=8443 \
  -Dconnector.maxThreads=400 \
  -Dssl.keystore.password=mi_password_muy_seguro \
  -DjvmRoute=node01 \
  -Ddb.url=jdbc:postgresql://prod-db:5432/appdb \
  -Ddb.username=appuser \
  -Ddb.password=secreto_de_bd"
```

> 💡 **En entornos con Docker o Kubernetes**, estos valores suelen inyectarse como variables de entorno del contenedor o como secretos de Kubernetes, no en `setenv.sh`. El resultado es el mismo: los valores sensibles no viven en los archivos de configuración versionados, sino en un sistema de gestión de secretos separado.

---

## 3.14 Diferencias en server.xml por Versión de Tomcat

Esta tabla resume qué características están disponibles en cada versión, para que puedas saber si puedes usar una configuración concreta en tu instalación:

| Característica                               | 8.0   | 8.5          | 9.0          | 10.x  | 11.0  |
|----------------------------------------------|-------|--------------|--------------|-------|-------|
| `SSLHostConfig` + `Certificate` (TLS moderno)| ❌    | ✅           | ✅           | ✅    | ✅    |
| Protocolo BIO en `<Connector>`               | ✅    | ⚠️ Dep.     | ❌ Elim.     | ❌    | ❌     |
| HTTP/2 via `UpgradeProtocol`                 | ❌    | ✅           | ✅           | ✅    | ✅    |
| `requiredSecret` en AJP (fix Ghostcat)       | ❌    | ✅ (8.5.51+) | ✅ (9.0.31+) | ✅    | ✅    |
| `sessionCookieSameSite` en Context           | ❌    | ✅           | ✅           | ✅    | ✅    |
| `RateLimitFilter` Valve                      | ❌    | ❌           | ❌           | ❌    | ✅    |
| `server=""` para eliminar cabecera Server    | ❌    | ✅ (reciente)| ✅ (reciente)| ✅    | ✅    |
| Virtual Threads con `executor` (Loom)        | ❌    | ❌           | ❌           | ❌    | ✅    |
| `maxParameterCount` en Connector             | ❌    | ✅           | ✅           | ✅    | ✅    |

> 💡 **Sobre el `RateLimitFilter` de Tomcat 11:** Antes de Tomcat 11, el rate limiting se implementaba en el proxy (Nginx, Apache httpd) o en un filtro de la aplicación. Tomcat 11 introduce un Valve nativo que puede limitar peticiones por IP directamente en el servidor, sin necesidad de un proxy externo.

---

## Puntos Clave

- `server.xml` es el **fichero de configuración central** de Tomcat. Todo cambio en él requiere reinicio completo del servidor.

- Las tres reglas de producción que siempre se aplican juntas: `port="-1"` en `<Server>` (apagado seguro sin socket expuesto), `autoDeploy="false"` en `<Host>` (despliegues controlados) y `reloadable="false"` en `<Context>` (sin monitorización innecesaria de clases).

- El **`<Executor>` compartido** evita el sobreaprovisionamiento de hilos cuando hay múltiples conectores: en lugar de que cada uno tenga su propio pool, comparten uno solo que se ajusta a la carga total.

- **`SSLHostConfig` con SNI** permite certificados diferentes por dominio en el mismo puerto HTTPS. Sin SNI necesitarías una IP diferente por dominio.

- **`ErrorReportValve`** con `showReport="false"` y `showServerInfo="false"` es obligatoria en producción. Sin ella, las páginas de error muestran la versión exacta de Tomcat, facilitando ataques dirigidos.

- **Nunca escribir contraseñas en texto plano en `server.xml`**. Usar `${propiedad}` y definir el valor en `setenv.sh` con los permisos adecuados. En Docker/Kubernetes, usar secretos del orquestador.

- El conector **AJP necesita `secretRequired="true"` y `address="127.0.0.1"`** si se activa, o debe eliminarse completamente si no se usa. Ghostcat (CVE-2020-1938) demostró el riesgo de dejarlo expuesto.

- Los **`<Context>` no deben definirse en `server.xml`** en producción. El lugar correcto es `conf/Catalina/localhost/[app].xml`, lo que permite recargar configuraciones de aplicaciones individuales sin reiniciar todo el servidor.