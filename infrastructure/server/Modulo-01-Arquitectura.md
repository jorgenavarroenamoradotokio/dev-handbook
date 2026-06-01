> **Estado:** 🟢 Completo
> **Última actualización:** 2026-05
> **Nivel:** Principiante — se explican los conceptos desde cero

---

# Módulo 01: Arquitectura Interna y Componentes de Apache Tomcat

## Índice

- [Módulo 01: Arquitectura Interna y Componentes de Apache Tomcat](#módulo-01-arquitectura-interna-y-componentes-de-apache-tomcat)
  - [Índice](#índice)
  - [1.1 ¿Qué es Tomcat y para qué sirve?](#11-qué-es-tomcat-y-para-qué-sirve)
    - [La analogía del restaurante](#la-analogía-del-restaurante)
    - [¿Qué es un "contenedor de Servlets"?](#qué-es-un-contenedor-de-servlets)
    - [¿En qué se diferencia de otros servidores?](#en-qué-se-diferencia-de-otros-servidores)
    - [Evolución de versiones: ¿cuál debo usar?](#evolución-de-versiones-cuál-debo-usar)
  - [1.2 Modelo Jerárquico de Componentes](#12-modelo-jerárquico-de-componentes)
    - [¿Qué es una arquitectura jerárquica?](#qué-es-una-arquitectura-jerárquica)
    - [El árbol de componentes](#el-árbol-de-componentes)
    - [El archivo `server.xml`: el cerebro de la configuración](#el-archivo-serverxml-el-cerebro-de-la-configuración)
  - [1.3 Descripción Detallada de Cada Componente](#13-descripción-detallada-de-cada-componente)
    - [1.3.1 Server](#131-server)
    - [1.3.2 Service](#132-service)
    - [1.3.3 Connector](#133-connector)
      - [¿Qué significa NIO, NIO2 y APR?](#qué-significa-nio-nio2-y-apr)
      - [Atributos de rendimiento del Connector](#atributos-de-rendimiento-del-connector)
    - [1.3.4 Engine](#134-engine)
    - [1.3.5 Host](#135-host)
    - [1.3.6 Context](#136-context)
      - [¿Dónde se puede definir un Context?](#dónde-se-puede-definir-un-context)
    - [1.3.7 Wrapper](#137-wrapper)
  - [1.4 Pipelines, Valves y la Cadena de Procesamiento](#14-pipelines-valves-y-la-cadena-de-procesamiento)
    - [El patrón Pipeline (cadena de responsabilidad)](#el-patrón-pipeline-cadena-de-responsabilidad)
    - [Valves más importantes](#valves-más-importantes)
    - [Ejemplo: Configuración de Valves avanzada](#ejemplo-configuración-de-valves-avanzada)
    - [Archivo `rewrite.config` (para RewriteValve)](#archivo-rewriteconfig-para-rewritevalve)
  - [1.5 El Cargador de Clases (ClassLoader) de Tomcat](#15-el-cargador-de-clases-classloader-de-tomcat)
    - [El problema que resuelve](#el-problema-que-resuelve)
    - [La jerarquía de ClassLoaders](#la-jerarquía-de-classloaders)
    - [¿Qué ve cada nivel?](#qué-ve-cada-nivel)
    - [El patrón Child-First: la clave del aislamiento](#el-patrón-child-first-la-clave-del-aislamiento)
    - [Configuración en `conf/catalina.properties`](#configuración-en-confcatalinaproperties)
  - [1.6 Ciclo de Vida de los Componentes (Lifecycle)](#16-ciclo-de-vida-de-los-componentes-lifecycle)
    - [¿Por qué es importante conocer esto?](#por-qué-es-importante-conocer-esto)
    - [Los estados del ciclo de vida](#los-estados-del-ciclo-de-vida)
    - [LifecycleListeners: reaccionar a los cambios de estado](#lifecyclelisteners-reaccionar-a-los-cambios-de-estado)
    - [Listeners que vienen incluidos en Tomcat por defecto](#listeners-que-vienen-incluidos-en-tomcat-por-defecto)
  - [1.7 Componentes de Soporte: Realm, Manager y Store](#17-componentes-de-soporte-realm-manager-y-store)
    - [1.7.1 Realm (Seguridad y Autenticación)](#171-realm-seguridad-y-autenticación)
    - [1.7.2 Manager (Gestión de Sesiones HTTP)](#172-manager-gestión-de-sesiones-http)
  - [1.8 Resumen Visual de la Arquitectura Completa](#18-resumen-visual-de-la-arquitectura-completa)
  - [1.9 Diferencias Arquitectónicas entre Versiones](#19-diferencias-arquitectónicas-entre-versiones)
  - [Puntos Clave](#puntos-clave)

---

## 1.1 ¿Qué es Tomcat y para qué sirve?

### La analogía del restaurante

Imagina que tienes una aplicación web escrita en Java. Esa aplicación es como un chef que sabe cocinar platos exquisitos, pero que no puede atender a los clientes directamente: no sabe cómo recibir pedidos, gestionar las mesas ni cobrar. Necesita un restaurante que lo envuelva y le dé la infraestructura para funcionar.

**Apache Tomcat es ese restaurante.** Es el software que recibe las peticiones de los usuarios desde el navegador (los clientes), las traduce a un formato que tu aplicación Java entiende, se las entrega, recibe la respuesta y la devuelve al navegador.

### ¿Qué es un "contenedor de Servlets"?

Un **Servlet** es una clase Java que puede recibir una petición HTTP (como cuando un usuario hace clic en un botón de una web) y devolver una respuesta (como una página HTML o datos JSON). Por sí solo, un Servlet no puede ejecutarse: necesita un entorno que lo gestione. Ese entorno es el **contenedor de Servlets**, y Tomcat es el más popular de ellos.

### ¿En qué se diferencia de otros servidores?

Existen servidores más completos como WildFly o WebLogic que implementan toda la especificación de Jakarta EE (bases de datos en cola, mensajería, transacciones distribuidas, etc.). Tomcat es más **ligero y enfocado**: implementa solo las partes más usadas:

- **Servlet** — para procesar peticiones HTTP
- **JSP** (JavaServer Pages) — para generar HTML dinámico con código Java
- **EL** (Expression Language) — un lenguaje simplificado para usar dentro de JSPs
- **WebSocket** — para conexiones bidireccionales en tiempo real (chats, notificaciones, etc.)

Si no necesitas mensajería ni EJB, Tomcat es suficiente y mucho más sencillo de operar.

### Evolución de versiones: ¿cuál debo usar?

A lo largo del tiempo, las especificaciones de Servlet, JSP, etc. han ido evolucionando, y cada versión de Tomcat implementa una versión diferente. La tabla siguiente resume qué versión de Tomcat implementa qué estándares y qué versión mínima de Java necesita:

| Tomcat | Servlet | JSP | EL  | WebSocket | Java mínimo | Namespace de clases   |
|--------|---------|-----|-----|-----------|-------------|-----------------------|
| 8.0    | 3.1     | 2.3 | 3.0 | 1.0       | Java 7      | `javax.*`             |
| 8.5    | 3.1     | 2.3 | 3.0 | 1.1       | Java 7      | `javax.*`             |
| 9.0    | 4.0     | 2.3 | 3.0 | 1.1       | Java 8      | `javax.*`             |
| 10.0   | 5.0     | 3.0 | 4.0 | 2.0       | Java 8      | `jakarta.*`           |
| 10.1   | 6.0     | 3.1 | 5.0 | 2.1       | Java 11     | `jakarta.*`           |
| 11.0   | 6.1     | 4.0 | 6.0 | 2.2       | Java 17     | `jakarta.*`           |

> ⚠️ **El cambio más importante que debes conocer:** A partir de Tomcat 10.0, todas las clases de las APIs cambian su "paquete" (namespace) de `javax.*` a `jakarta.*`. Esto significa que si tienes una aplicación antigua que importa `javax.servlet.HttpServlet`, esa aplicación **no funcionará en Tomcat 10+** sin modificarla. Es el cambio más disruptivo de la historia reciente de Tomcat.
>
> Por ejemplo, este código funciona en Tomcat 9 pero falla en Tomcat 10:
> ```java
> import javax.servlet.http.HttpServlet;  // ❌ Falla en Tomcat 10+
> ```
> Y este otro funciona en Tomcat 10+:
> ```java
> import jakarta.servlet.http.HttpServlet;  // ✅ Correcto en Tomcat 10+
> ```
> Existe una herramienta llamada **Migration Tool for Jakarta EE** que puede hacer esta conversión automáticamente en tus archivos `.war` compilados.

---

## 1.2 Modelo Jerárquico de Componentes

### ¿Qué es una arquitectura jerárquica?

Tomcat no es un bloque monolítico de código. Está construido como un conjunto de **piezas encajadas unas dentro de otras**, como las muñecas rusas matrioska. Cada pieza tiene una responsabilidad concreta, y las piezas se organizan de mayor a menor hasta llegar a los Servlets individuales de tu aplicación.

Esta organización facilita:
- **Configuración modular**: puedes cambiar una parte sin tocar el resto
- **Reutilización**: varios sitios web pueden compartir el mismo servidor
- **Mantenimiento**: cuando algo falla, sabes exactamente en qué nivel buscar

### El árbol de componentes

```
Server                          ← La instancia completa de Tomcat
└── Service                     ← Agrupa conectores con un motor
    ├── Connector (HTTP/1.1)    ← Recibe peticiones por el puerto 8080
    ├── Connector (HTTPS)       ← Recibe peticiones por el puerto 8443
    └── Engine                  ← Motor que enruta peticiones al host correcto
        └── Host                ← Representa un dominio o sitio web
            ├── Context         ← Una aplicación web concreta (/miapp)
            │   ├── Wrapper     ← Un Servlet individual dentro de la app
            │   └── Wrapper     ← Otro Servlet de la misma app
            └── Context         ← Otra aplicación web (/otraapp)
                └── Wrapper     ← Sus Servlets
```

### El archivo `server.xml`: el cerebro de la configuración

Todo lo anterior se define en un único archivo llamado `server.xml`, ubicado en la carpeta `conf/` de Tomcat. Es el punto de partida para entender cualquier instalación de Tomcat. Aquí un ejemplo comentado:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!-- El Server es el componente raíz. El puerto 8005 sirve para enviar
     el comando de apagado ("SHUTDOWN") a Tomcat desde la misma máquina. -->
<Server port="8005" shutdown="SHUTDOWN">

  <!-- Un Service agrupa los conectores con el motor.
       "Catalina" es el nombre histórico del motor de Tomcat. -->
  <Service name="Catalina">

    <!-- Connector HTTP: escucha en el puerto 8080.
         NioProtocol significa que usa I/O no bloqueante (más eficiente). -->
    <Connector port="8080"
               protocol="org.apache.coyote.http11.Http11NioProtocol"
               connectionTimeout="20000"
               redirectPort="8443"
               maxThreads="200"
               minSpareThreads="10"/>

    <!-- Connector HTTPS: escucha en el puerto 8443.
         SSLEnabled="true" activa el cifrado TLS. -->
    <Connector port="8443"
               protocol="org.apache.coyote.http11.Http11NioProtocol"
               SSLEnabled="true"
               maxThreads="150"
               scheme="https"
               secure="true">
      <!-- Aquí se configura el certificado digital para HTTPS -->
      <SSLHostConfig>
        <Certificate certificateKeystoreFile="conf/keystore.jks"
                     certificateKeystorePassword="changeit"
                     type="RSA"/>
      </SSLHostConfig>
    </Connector>

    <!-- El Engine recibe las peticiones de todos los Connectors
         y las manda al Host correcto según el dominio de la URL. -->
    <Engine name="Catalina" defaultHost="localhost">

      <!-- Un Host representa un dominio (como "localhost" en desarrollo
           o "www.miempresa.com" en producción).
           appBase es el directorio donde viven las aplicaciones. -->
      <Host name="localhost"
            appBase="webapps"
            unpackWARs="true"
            autoDeploy="true">

        <!-- Un Context representa una aplicación web específica.
             path="/myapp" → se accede en http://localhost:8080/myapp
             docBase → dónde están los archivos de la aplicación -->
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

El `Server` es el **componente más externo**, el que representa toda la instancia de Tomcat. Solo puede haber uno por instalación.

Su función principal en `server.xml` es habilitar el **puerto de apagado**: cuando ejecutas el script `shutdown.sh`, lo que hace internamente es conectarse al puerto 8005 y enviar la cadena "SHUTDOWN". Tomcat la recibe y se detiene ordenadamente.

**Atributos clave:**

| Atributo   | Qué hace                                                              | Valor por defecto |
|------------|-----------------------------------------------------------------------|-------------------|
| `port`     | Puerto donde escucha el comando de apagado                            | `8005`            |
| `shutdown`  | La contraseña/cadena que activa el apagado                           | `SHUTDOWN`        |
| `address`  | Dirección IP desde la que se acepta el comando de apagado            | `localhost`       |

> ⚠️ **Seguridad en producción:** Si alguien puede conectarse al puerto 8005 desde fuera del servidor, podría apagar tu Tomcat enviando la cadena "SHUTDOWN". Para evitarlo, en producción se recomienda desactivar este puerto completamente con `port="-1"` y gestionar el arranque/parada con las herramientas del sistema operativo (como `systemd` en Linux).

```xml
<!-- En producción: desactiva el puerto de shutdown por socket -->
<Server port="-1" shutdown="SHUTDOWN">
```

---

### 1.3.2 Service

El `Service` es un **contenedor organizativo**: agrupa uno o más `Connector`s con un único `Engine`. No hace mucho por sí mismo, pero es necesario en la jerarquía.

La razón de su existencia es permitir que en un mismo Tomcat haya **múltiples grupos independientes** de conectores y motores, cada uno sirviendo aplicaciones completamente diferentes. En la práctica, la mayoría de instalaciones tienen un solo `Service` llamado `Catalina`.

```xml
<Service name="Catalina">
  <!-- Aquí van los Connectors y el Engine -->
</Service>
```

---

### 1.3.3 Connector

El `Connector` es la **puerta de entrada**. Es el componente que:

1. Abre un puerto de red (como el 8080)
2. Espera conexiones entrantes de los navegadores
3. Lee la petición HTTP
4. La transforma en un objeto Java que el Engine puede procesar
5. Recibe la respuesta y la devuelve al cliente

Piensa en el Connector como el **recepcionista** del restaurante: su trabajo es recibir a los clientes (peticiones HTTP), anotar el pedido en una ficha estándar (el objeto `HttpServletRequest`) y pasárselo a la cocina (el Engine).

#### ¿Qué significa NIO, NIO2 y APR?

Cuando hay muchos usuarios conectados al mismo tiempo, la forma en que Tomcat gestiona esas conexiones importa mucho:

- **BIO (Blocking I/O):** El método más antiguo. Por cada conexión activa, Tomcat asigna un hilo de Java dedicado. Si tienes 1.000 usuarios conectados, necesitas 1.000 hilos. Los hilos consumen mucha memoria, así que escala mal. **Eliminado en Tomcat 9.**

- **NIO (Non-blocking I/O):** Un número reducido de hilos gestiona muchas conexiones mediante un sistema de eventos. Un hilo puede "vigilar" miles de conexiones y actuar solo cuando hay datos que procesar. **Es el recomendado actualmente.**

- **NIO2:** Una variante asíncrona de NIO, disponible desde Tomcat 8.0. Ofrece mejoras adicionales en sistemas con muchas operaciones de I/O simultáneas.

- **APR (Apache Portable Runtime):** Usa librerías nativas del sistema operativo (en C) en lugar de Java puro. Ofrece el mejor rendimiento para SSL/TLS usando OpenSSL directamente, pero requiere instalar librerías nativas adicionales.

| Implementación                                          | Descripción                                     | ¿Usar hoy?         |
|---------------------------------------------------------|-------------------------------------------------|--------------------|
| `org.apache.coyote.http11.Http11NioProtocol`            | NIO — no bloqueante                             | ✅ Sí, recomendado  |
| `org.apache.coyote.http11.Http11Nio2Protocol`           | NIO2 — asíncrono                                | ✅ Válido           |
| `org.apache.coyote.http11.Http11AprProtocol`            | APR/Native — usa OpenSSL nativo                 | ✅ Para alto TLS    |
| `org.apache.coyote.http11.Http11BioProtocol`            | BIO — bloqueante, un hilo por conexión          | ❌ Eliminado en T9  |

> ⚠️ **Si estás migrando desde Tomcat 8.0:** Si tu `server.xml` tiene `Http11BioProtocol`, cámbialo por `Http11NioProtocol` antes de actualizar a Tomcat 9+. De lo contrario Tomcat no arrancará.

#### Atributos de rendimiento del Connector

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

Estos son los atributos más importantes y qué significan en términos prácticos:

| Atributo              | Qué hace                                                                          | Consejo práctico                              |
|-----------------------|-----------------------------------------------------------------------------------|-----------------------------------------------|
| `maxThreads`          | Máximo de peticiones procesándose simultáneamente                                 | Empieza con 200, ajusta según carga           |
| `minSpareThreads`     | Hilos "de guardia" listos para reaccionar al instante                             | Al menos 10-25 para evitar latencia inicial   |
| `acceptCount`         | Cola de peticiones en espera cuando todos los hilos están ocupados                | Si se llena, nuevas peticiones dan error      |
| `maxConnections`      | Conexiones de red simultáneas totales (incluye keep-alive inactivas)              | Diferente a maxThreads                        |
| `connectionTimeout`   | Cuántos ms espera Tomcat a que el cliente envíe la petición                       | 20000ms (20s) es razonable                   |
| `keepAliveTimeout`    | Cuántos ms mantiene abierta una conexión HTTP keep-alive entre peticiones         | Reduce la sobrecarga de abrir nuevas conexiones|
| `compression`         | Si `on`, comprime las respuestas con gzip automáticamente                         | Reduce el ancho de banda un 60-80% en HTML   |
| `URIEncoding`         | Codificación de los caracteres especiales en la URL                               | Siempre `UTF-8`                               |

---

### 1.3.4 Engine

El `Engine` es el **motor central de enrutamiento**. Recibe las peticiones del Connector y decide a qué `Host` enviárselas, basándose en el encabezado `Host` de la petición HTTP.

¿Por qué hace falta esto? Porque una misma IP puede tener múltiples dominios apuntando a ella. Cuando un navegador hace una petición, incluye en la cabecera `Host: www.miempresa.com`. El Engine lee ese valor y lo compara con los Hosts configurados para saber a cuál enviársela.

```xml
<Engine name="Catalina" defaultHost="localhost" jvmRoute="node01">
</Engine>
```

| Atributo      | Qué hace                                                                                     |
|---------------|----------------------------------------------------------------------------------------------|
| `name`        | Nombre lógico del Engine (normalmente "Catalina")                                            |
| `defaultHost` | Si la cabecera `Host` no coincide con ningún Host configurado, se usa este por defecto       |
| `jvmRoute`    | Identificador único de este nodo en un clúster; se añade al ID de sesión para sticky sessions|

> 💡 **¿Qué son las sticky sessions?** En un clúster con varios servidores Tomcat, un balanceador de carga distribuye peticiones entre ellos. El `jvmRoute` permite que el balanceador siempre dirija al mismo usuario al mismo nodo (donde tiene su sesión activa), evitando que pierda la sesión al cambiar de servidor.

---

### 1.3.5 Host

El `Host` representa un **sitio web o dominio virtual**. Permite que una misma instancia de Tomcat sirva múltiples dominios diferentes, cada uno con sus propias aplicaciones.

Es el equivalente a los "Virtual Hosts" de Apache HTTP Server o los "Server Blocks" de Nginx.

```xml
<Host name="app1.miempresa.com"
      appBase="/opt/webapps/app1"
      unpackWARs="true"
      autoDeploy="false"
      deployOnStartup="true"
      workDir="/opt/work/app1">

  <!-- Alias: otros nombres de dominio que apuntan al mismo Host -->
  <Alias>www.app1.miempresa.com</Alias>

  <!-- Un Valve de log de accesos específico para este host -->
  <Valve className="org.apache.catalina.valves.AccessLogValve"
         directory="logs"
         prefix="app1_access"
         suffix=".log"
         pattern="%h %l %u %t &quot;%r&quot; %s %b %D"/>
</Host>
```

| Atributo          | Qué hace                                                                                      | Recomendación              |
|-------------------|-----------------------------------------------------------------------------------------------|----------------------------|
| `name`            | Nombre del dominio que este Host atiende                                                      | Debe coincidir con el DNS  |
| `appBase`         | Directorio donde Tomcat buscará las aplicaciones (archivos `.war` o carpetas)                 |                            |
| `unpackWARs`      | Si `true`, descomprime el archivo `.war` en disco antes de ejecutarlo                         | `true` en producción       |
| `autoDeploy`      | Si `true`, detecta nuevos `.war` en `appBase` y los despliega automáticamente mientras corre  | `false` en producción      |
| `deployOnStartup` | Si `true`, despliega todas las aplicaciones de `appBase` cuando Tomcat arranca                | `true` en producción       |
| `workDir`         | Carpeta temporal donde se guardan los JSPs compilados y archivos de trabajo                   |                            |

> ⚠️ **¿Por qué `autoDeploy="false"` en producción?** Si `autoDeploy` está activado, cualquier archivo `.war` que se copie al directorio (aunque sea por error o de forma no controlada) se desplegará automáticamente. En producción quieres que los despliegues sean controlados y deliberados, no automáticos.

---

### 1.3.6 Context

El `Context` representa **una aplicación web individual**. Es el componente que mapea una ruta URL con los archivos físicos de tu aplicación.

Por ejemplo: si tienes un archivo `tienda.war` y configuras un Context con `path="/tienda"`, tu aplicación estará disponible en `http://localhost:8080/tienda`.

Un `Context` con `path=""` (vacío) es la **aplicación ROOT**, que responde a `http://localhost:8080/` directamente.

#### ¿Dónde se puede definir un Context?

Hay tres formas, de menos a más recomendable:

1. **En `server.xml`** — Funciona, pero cualquier cambio requiere reiniciar Tomcat. No recomendado para producción.
2. **En un archivo XML en `conf/[Engine]/[Host]/miapp.xml`** — La forma recomendada. Tomcat lo detecta y puede recargar solo el contexto sin reiniciar todo.
3. **En `WEB-INF/context.xml` dentro del propio WAR** — La aplicación se autodefine. Cómodo para desarrollo, pero da menos control al administrador del servidor.

```xml
<!-- Archivo: conf/Catalina/localhost/myapp.xml -->
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

  <!-- Resource: configura un pool de conexiones a base de datos.
       Las aplicaciones acceden a él por su nombre JNDI "jdbc/MyDB".
       Así la aplicación no necesita saber la contraseña de la BD,
       solo pedir la conexión por nombre. -->
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

  <!-- Parameter: valor de configuración accesible desde la aplicación
       como si fuera un parámetro de inicialización del contexto. -->
  <Parameter name="appVersion" value="2.1.0" override="false"/>

  <!-- Environment: variable de entorno tipada accesible vía JNDI -->
  <Environment name="maxItems" value="500" type="java.lang.Integer" override="false"/>

</Context>
```

Atributos más importantes del Context:

| Atributo                  | Qué hace                                                                                  | Recomendación        |
|---------------------------|-------------------------------------------------------------------------------------------|----------------------|
| `path`                    | Ruta URL de la aplicación. `""` para ROOT                                                 |                      |
| `docBase`                 | Ruta en disco al directorio o archivo `.war` de la aplicación                             |                      |
| `reloadable`              | Si `true`, vigila los `.class` y recarga la app si detecta cambios                        | `false` en producción|
| `crossContext`            | Si `true`, permite que esta app acceda al contexto de otras apps del mismo servidor       | `false` (seguridad)  |
| `sessionCookieHttpOnly`   | Impide que JavaScript pueda leer la cookie de sesión (protección contra XSS)             | Siempre `true`       |
| `sessionCookieSecure`     | La cookie de sesión solo se envía por HTTPS, nunca por HTTP                               | `true` si usas HTTPS |

> ⚠️ **`reloadable="true"` en producción es un error común.** Aunque suena útil, lo que hace internamente es arrancar un hilo que vigila constantemente el sistema de archivos buscando cambios en clases. Esto consume CPU y memoria, y puede causar problemas de memoria (memory leaks) cuando Tomcat descarga y recarga el ClassLoader de la aplicación. Úsalo solo en desarrollo.

---

### 1.3.7 Wrapper

El `Wrapper` es el componente más pequeño de la jerarquía. Encapsula un **Servlet individual** dentro de una aplicación.

A diferencia del resto de componentes, el `Wrapper` no se configura manualmente en `server.xml`. Tomcat lo crea automáticamente cuando procesa el archivo `web.xml` de tu aplicación o cuando encuentra anotaciones `@WebServlet` en el código.

El `Wrapper` es el responsable del ciclo de vida del Servlet:
- Llama a `init()` cuando se instancia el Servlet por primera vez
- Llama a `service()` (que a su vez llama a `doGet()`, `doPost()`, etc.) en cada petición
- Llama a `destroy()` cuando la aplicación se detiene

---

## 1.4 Pipelines, Valves y la Cadena de Procesamiento

### El patrón Pipeline (cadena de responsabilidad)

Cuando llega una petición HTTP, no va directamente al Servlet. Pasa antes por una **cadena de filtros** llamados **Valves**. Esto es el patrón **Pipeline-Valve**.

Piénsalo como una cadena de montaje: la petición va pasando por cada estación (Valve), que puede inspeccionarla, modificarla, rechazarla o simplemente dejarla pasar. Al final de la cadena llega al Servlet.

Cada nivel de la jerarquía (Engine, Host, Context) tiene su propia cadena de Valves:

```
Petición → [Pipeline del Engine]
                → Valve de Log de Accesos
                → Valve de Reporte de Errores
                → [Pipeline del Host]
                      → Valve de Single Sign-On
                      → [Pipeline del Context]
                            → Valve de Autenticación (Basic/Form)
                            → Valve del Wrapper → Servlet.service()
                                                        ↓
                                                   Tu código Java
```

### Valves más importantes

| Valve                          | Para qué sirve                                                                  |
|--------------------------------|---------------------------------------------------------------------------------|
| `AccessLogValve`               | Registra cada petición HTTP en un archivo de log (como los logs de Apache)      |
| `RemoteAddrValve`              | Bloquea o permite peticiones según la IP de origen                              |
| `RemoteHostValve`              | Igual que el anterior, pero filtra por nombre de host en lugar de IP            |
| `RequestDumperValve`           | Vuelca todas las cabeceras de cada petición al log (solo para depuración)       |
| `RewriteValve`                 | Redirige o reescribe URLs (como `mod_rewrite` en Apache HTTP Server)            |
| `StuckThreadDetectionValve`    | Detecta y alerta sobre hilos que llevan demasiado tiempo procesando una petición|
| `CrawlerSessionManagerValve`   | Trata a los bots y crawlers de forma especial para no generar sesiones por cada uno|
| `SingleSignOn`                 | Permite que el login en una aplicación valga para otras del mismo Host          |
| `ErrorReportValve`             | Genera las páginas de error (el "Error 404", "Error 500", etc.)                 |

### Ejemplo: Configuración de Valves avanzada

```xml
<Host name="localhost" appBase="webapps">

  <!-- Access Log con tiempo de respuesta y User-Agent del cliente.
       %D es el tiempo de respuesta en milisegundos — muy útil para detectar
       peticiones lentas en producción. -->
  <Valve className="org.apache.catalina.valves.AccessLogValve"
         directory="${catalina.base}/logs"
         prefix="access"
         suffix=".log"
         rotatable="true"
         fileDateFormat="yyyy-MM-dd"
         pattern="%{X-Forwarded-For}i %l %u %t &quot;%r&quot; %s %b %D %{User-Agent}i"
         resolveHosts="false"
         buffered="false"/>

  <!-- Seguridad: solo IPs internas pueden acceder.
       Las expresiones son regex: \d+ significa "uno o más dígitos".
       Cualquier IP que no coincida recibe un error 403 (Forbidden). -->
  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="192\.168\.1\.\d+|10\.0\.0\.\d+|127\.0\.0\.1"
         denyStatus="403"/>

  <!-- Detectar hilos "atascados": si un hilo tarda más de 60s en procesar
       una petición, lo registra como warning. Si supera 120s, lo interrumpe.
       Muy útil para detectar bloqueos por consultas SQL lentas o deadlocks. -->
  <Valve className="org.apache.catalina.valves.StuckThreadDetectionValve"
         threshold="60"
         interruptThreadThreshold="120"/>

  <!-- Activa el motor de reescritura de URLs.
       La configuración real de las reglas va en un archivo separado:
       conf/Catalina/localhost/rewrite.config -->
  <Valve className="org.apache.catalina.valves.rewrite.RewriteValve"/>

</Host>
```

### Archivo `rewrite.config` (para RewriteValve)

```
# Redirigir automáticamente HTTP a HTTPS.
# Si el puerto es 80 (HTTP), redirige al mismo path pero en HTTPS.
# [R=301] significa "redirección permanente", [L] significa "última regla".
RewriteCond %{SERVER_PORT} ^80$
RewriteRule ^/(.*)$ https://%{SERVER_NAME}/$1 [R=301,L]

# Redirigir una URL antigua a una nueva
RewriteRule ^/old-path/(.*)$ /new-path/$1 [R=301,L]
```

---

## 1.5 El Cargador de Clases (ClassLoader) de Tomcat

### El problema que resuelve

Imagina que tienes dos aplicaciones desplegadas en el mismo Tomcat:
- **App A** necesita la librería Jackson versión 2.13
- **App B** necesita Jackson versión 2.15

Si Tomcat cargara las clases de Jackson en un solo lugar común, solo podría haber una versión. Una de las dos aplicaciones fallaría.

Para resolver esto, Tomcat implementa una **jerarquía de ClassLoaders** (cargadores de clases) que aísla las dependencias de cada aplicación.

### La jerarquía de ClassLoaders

Un ClassLoader es un componente de Java responsable de encontrar y cargar los archivos `.class` (el bytecode de tus clases Java) en memoria. Cuando en tu código escribes `new MiClase()`, Java delega en el ClassLoader para encontrar ese `.class`.

```
Bootstrap ClassLoader          ← Lo provee la JVM. Carga las clases base de Java (java.lang, etc.)
└── System ClassLoader         ← Carga las clases del CLASSPATH del sistema
    └── Common ClassLoader     ← Carga las librerías de $CATALINA_HOME/lib/ (visibles para todo)
        ├── Catalina ClassLoader  ← Clases internas de Tomcat (las apps NO pueden verlas)
        └── Shared ClassLoader    ← Librerías compartidas entre apps (si se configura)
            ├── WebApp ClassLoader (App 1)  ← WEB-INF/lib/ y WEB-INF/classes/ de la App 1
            ├── WebApp ClassLoader (App 2)  ← Ídem para App 2
            └── WebApp ClassLoader (App N)  ← Cada app tiene el suyo, aislado
```

### ¿Qué ve cada nivel?

| ClassLoader         | ¿Quién lo usa?                       | ¿De dónde carga clases?              |
|---------------------|--------------------------------------|--------------------------------------|
| Bootstrap           | Toda la JVM                          | Clases base de Java (`java.lang`, etc.)|
| System              | Todo el sistema                      | `CLASSPATH` del entorno              |
| Common              | Tomcat y todas las aplicaciones      | `$CATALINA_HOME/lib/*.jar`           |
| Catalina            | Solo el propio Tomcat internamente   | Clases internas del servidor         |
| Shared              | Todas las apps (no el servidor)      | `shared/lib/` si se configura        |
| WebApp              | Solo la aplicación propia            | `WEB-INF/lib/` y `WEB-INF/classes/` |

### El patrón Child-First: la clave del aislamiento

El modelo estándar de Java dice que un ClassLoader debe primero preguntar a su padre si conoce una clase (Parent-First). Pero el `WebAppClassLoader` de Tomcat hace lo contrario: **primero busca en su propio `WEB-INF/lib/`** y solo si no encuentra la clase, pregunta al padre (Child-First).

Esto es lo que permite que la App A use Jackson 2.13 y la App B use Jackson 2.15 al mismo tiempo: cada una tiene su propia copia de Jackson en su `WEB-INF/lib/`, y sus respectivos `WebAppClassLoader` la encuentran ahí antes de que ningún ClassLoader padre interfiera.

### Configuración en `conf/catalina.properties`

```properties
# Librerías visibles para Tomcat Y para todas las apps (Common ClassLoader)
# Normalmente solo necesitas añadir algo aquí si quieres un driver JDBC
# accesible desde todas las apps a la vez.
common.loader="${catalina.base}/lib","${catalina.base}/lib/*.jar","${catalina.home}/lib","${catalina.home}/lib/*.jar"

# Librerías solo para Tomcat (Catalina ClassLoader) — raramente se toca
server.loader=

# Librerías compartidas entre apps pero no para Tomcat (Shared ClassLoader) — raramente se toca
shared.loader=
```

---

## 1.6 Ciclo de Vida de los Componentes (Lifecycle)

### ¿Por qué es importante conocer esto?

Todos los componentes de Tomcat (Server, Service, Connector, Engine, Host, Context…) siguen el mismo protocolo de estados. Conocer estos estados te ayuda a:

- Entender en qué punto falla un arranque
- Escribir código que se ejecute en momentos específicos (ej: conectar a una BD justo antes de que arranquen las apps)
- Depurar problemas de inicialización o parada

### Los estados del ciclo de vida

```
NUEVO (recién creado)
  │
  └─[init()]──→ INITIALIZING ──→ INITIALIZED
                                      │
                                      └─[start()]──→ STARTING_PREP ──→ STARTING ──→ STARTED
                                                                                        │
                                                                   ┌────────────────────┤
                                                                   │                    │
                                                              [stop()]               [ERROR]
                                                                   │                    │
                                                         STOPPING_PREP             FAILED
                                                                   │
                                                              STOPPING ──→ STOPPED
                                                                               │
                                                                         [destroy()]
                                                                               │
                                                                         DESTROYING ──→ DESTROYED
```

Cada transición dispara uno o más **eventos** que otros componentes pueden escuchar.

### LifecycleListeners: reaccionar a los cambios de estado

Un `LifecycleListener` es código que se ejecuta cuando un componente cambia de estado. Es el mecanismo con el que Tomcat permite extender su comportamiento sin modificar su código fuente.

```java
// Ejemplo: un Listener que hace algo cuando Tomcat arranca o se detiene
public class CustomLifecycleListener implements LifecycleListener {

    @Override
    public void lifecycleEvent(LifecycleEvent event) {
        // event.getType() indica qué tipo de evento ocurrió
        // event.getLifecycle() es el componente que cambió de estado
        String type = event.getType();

        switch (type) {
            case Lifecycle.BEFORE_START_EVENT:
                // Esto se ejecuta ANTES de que el componente arranque.
                // Útil para preparar recursos (conexiones, caches, etc.)
                System.out.println("Preparando arranque: " + event.getLifecycle());
                break;
            case Lifecycle.START_EVENT:
                // El componente acaba de arrancar
                System.out.println("Arrancado: " + event.getLifecycle());
                break;
            case Lifecycle.AFTER_START_EVENT:
                // Todo el proceso de arranque ha terminado
                System.out.println("Arranque completado: " + event.getLifecycle());
                break;
            case Lifecycle.STOP_EVENT:
                // El componente se está deteniendo.
                // Útil para liberar recursos (cerrar conexiones, etc.)
                System.out.println("Detenido: " + event.getLifecycle());
                break;
        }
    }
}
```

Para registrar ese listener en `server.xml`:

```xml
<Server port="8005" shutdown="SHUTDOWN">
  <!-- Tomcat instanciará esta clase y la llamará en cada evento de ciclo de vida -->
  <Listener className="com.miempresa.tomcat.CustomLifecycleListener"/>
</Server>
```

### Listeners que vienen incluidos en Tomcat por defecto

Estos Listeners ya están en `server.xml` de fábrica. Dejarlos activados es una buena práctica:

```xml
<!-- Previene fugas de memoria en la JVM cuando se redesplegan aplicaciones.
     Sin este listener, hacer undeploy+deploy de una app puede ir acumulando
     memoria que nunca se libera completamente. -->
<Listener className="org.apache.catalina.core.JreMemoryLeakPreventionListener"/>

<!-- Gestiona los beans de JMX para monitorización con herramientas como
     JConsole o VisualVM. -->
<Listener className="org.apache.catalina.mbeans.GlobalResourcesLifecycleListener"/>

<!-- Evita deadlocks relacionados con ThreadLocal cuando se redesplega una app.
     ThreadLocal mal usado es una causa frecuente de memory leaks en Tomcat. -->
<Listener className="org.apache.catalina.core.ThreadLocalLeakPreventionListener"/>

<!-- Intenta cargar las librerías nativas de APR (si están instaladas).
     Si no están, simplemente no hace nada. -->
<Listener className="org.apache.catalina.core.AprLifecycleListener"
          SSLEngine="on"/>
```

---

## 1.7 Componentes de Soporte: Realm, Manager y Store

### 1.7.1 Realm (Seguridad y Autenticación)

Un `Realm` es el componente que le dice a Tomcat **dónde están guardados los usuarios, contraseñas y roles** de las aplicaciones que requieren autenticación.

Cuando una aplicación web está configurada para requerir login (mediante la configuración de seguridad en `web.xml`), Tomcat consulta al Realm para verificar si las credenciales del usuario son correctas.

El Realm se puede configurar a nivel de `Engine` (válido para todos los hosts y apps), `Host` (válido para todas las apps de ese host) o `Context` (solo para esa app).

```xml
<!-- Ejemplo: Los usuarios y sus contraseñas están en una base de datos PostgreSQL.
     Tomcat hará queries a esa BD para verificar credenciales. -->
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
<!-- digest="SHA-256": las contraseñas en la BD están hasheadas con SHA-256,
     no en texto plano. Tomcat hashea la contraseña introducida y la compara. -->
```

Tipos de Realm disponibles, de menos a más robusto:

| Realm                    | Descripción                                                                         | ¿Cuándo usarlo?           |
|--------------------------|-------------------------------------------------------------------------------------|---------------------------|
| `MemoryRealm`            | Usuarios definidos directamente en `conf/tomcat-users.xml`                          | Solo en desarrollo local  |
| `JDBCRealm`             | Usuarios en base de datos mediante JDBC directo (Tomcat abre la conexión)           | Aplicaciones pequeñas     |
| `DataSourceRealm`        | Igual que JDBCRealm pero usa un pool JNDI ya configurado (más eficiente)            | Producción con BD         |
| `JNDIRealm`             | Usuarios en un directorio LDAP o Active Directory corporativo                       | Empresas con AD/LDAP      |
| `UserDatabaseRealm`      | Usuarios en un `UserDatabase` global accesible vía JNDI                             | Configuraciones complejas |
| `JAASRealm`             | Delega la autenticación al framework estándar JAAS de Java                          | Integración con JAAS      |
| `CombinedRealm`          | Combina varios Realms: prueba uno, y si falla, prueba el siguiente                  | Múltiples fuentes de usuarios|
| `LockOutRealm`           | Envuelve otro Realm y añade bloqueo de cuenta tras N intentos fallidos              | Producción (seguridad)    |

---

### 1.7.2 Manager (Gestión de Sesiones HTTP)

El `Manager` es el componente responsable de **crear, guardar, encontrar e invalidar las sesiones HTTP** de los usuarios de una aplicación.

Cuando un usuario inicia sesión en tu aplicación, Java crea un objeto `HttpSession` que almacena su información (quién es, qué tiene en el carrito, etc.). El Manager decide **dónde guardar** ese objeto:

```xml
<Context path="/myapp" docBase="/opt/apps/myapp">

  <!-- StandardManager (por defecto): las sesiones se guardan en memoria RAM.
       Si Tomcat se cae o se reinicia, se pierden todas las sesiones
       (los usuarios tendrán que volver a iniciar sesión).
       maxActiveSessions="-1" significa "sin límite". -->
  <Manager className="org.apache.catalina.session.StandardManager"
           maxActiveSessions="5000"
           sessionIdLength="32"/>

  <!-- PersistentManager: las sesiones se guardan en disco o en una BD.
       Ventaja: las sesiones sobreviven a un reinicio de Tomcat.
       saveOnRestart="true": guarda sesiones al apagar y las restaura al arrancar.
       maxIdleSwap="60": mueve al disco sesiones inactivas > 60 minutos (swap out).
       minIdleSwap="30": no mueve al disco sesiones activas en los últimos 30 min. -->
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

> 💡 **Consejo:** En entornos de producción con alta disponibilidad o clústeres, la gestión de sesiones se suele delegar a un sistema externo como Redis o una base de datos, usando librerías específicas (como `tomcat-redis-session-manager`). Esto permite que cualquier nodo del clúster atienda a cualquier usuario sin perder su sesión.

---

## 1.8 Resumen Visual de la Arquitectura Completa

El diagrama siguiente muestra cómo encajan todos los componentes dentro de la JVM:

```
┌─────────────────────────────────────────────────────────────────┐
│                        JVM (Java Virtual Machine)               │
│   (El proceso Java que ejecuta todo Tomcat)                     │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │                      SERVER                              │   │
│  │  (La instancia completa de Tomcat)                       │   │
│  │  ┌────────────────────────────────────────────────────┐  │   │
│  │  │                    SERVICE                         │  │   │
│  │  │  (Agrupa conectores con un motor)                  │  │   │
│  │  │                                                    │  │   │
│  │  │  [Connector:8080] ──┐                              │  │   │
│  │  │  [Connector:8443] ──┼──→ [ENGINE: Catalina]        │  │   │
│  │  │  [Connector:AJP]  ──┘    (Enruta al Host correcto) │  │   │
│  │  │                               │                    │  │   │
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

Esta tabla resume las características más importantes según la versión de Tomcat, para que puedas evaluar una migración o elegir la versión correcta para un proyecto nuevo:

| Característica                          | Tomcat 8.0 | Tomcat 8.5   | Tomcat 9.0       | Tomcat 10.x | Tomcat 11.0      |
|-----------------------------------------|------------|--------------|------------------|-------------|------------------|
| Protocolo BIO (bloqueante, legacy)      | ✅ Sí       | ⚠️ Deprecado | ❌ Eliminado      | ❌ Eliminado | ❌ Eliminado      |
| HTTP/2 nativo                           | ❌ No       | ✅ Sí         | ✅ Sí             | ✅ Sí        | ✅ Sí             |
| OpenSSL vía APR                         | ✅ Sí       | ✅ Sí         | ✅ Sí             | ✅ Sí        | ✅ Sí             |
| TLS 1.3                                 | ❌ No       | ❌ No         | ✅ (con Java 11+) | ✅ Sí        | ✅ Sí             |
| Namespace de APIs `javax.*`             | ✅ Sí       | ✅ Sí         | ✅ Sí             | ❌ No        | ❌ No             |
| Namespace de APIs `jakarta.*`           | ❌ No       | ❌ No         | ❌ No             | ✅ Sí        | ✅ Sí             |
| Virtual Threads (Project Loom)          | ❌ No       | ❌ No         | ❌ No             | ❌ No        | ✅ (con Java 21+) |
| WebSocket 2.x                           | ❌ No       | ❌ No         | ❌ No             | ✅ Sí        | ✅ Sí             |
| Servlet Async I/O                       | ✅ Sí       | ✅ Sí         | ✅ Sí             | ✅ Sí        | ✅ Sí             |

> 💡 **Virtual Threads en Tomcat 11:** Project Loom es una característica de Java 21 que permite tener millones de hilos virtuales muy ligeros, gestionados por la JVM en lugar del sistema operativo. Tomcat 11 puede usar Virtual Threads para procesar peticiones, lo que elimina prácticamente el cuello de botella del modelo "un hilo por petición" sin necesidad de programar con callbacks o código asíncrono complejo.

---

## Puntos Clave

- **Tomcat es un contenedor ligero**, no un servidor de aplicaciones completo. Implementa Servlet, JSP, EL y WebSocket, pero no EJB ni JMS.

- **La jerarquía de componentes** es: Server → Service → (Connector + Engine) → Host → Context → Wrapper. Esta estructura se define en `server.xml`.

- **El cambio de namespace** de `javax.*` a `jakarta.*` en Tomcat 10+ es el mayor obstáculo para migrar aplicaciones legacy. Requiere recompilar o usar la Migration Tool.

- **El protocolo BIO fue eliminado en Tomcat 9.** Siempre usa NIO o NIO2 en instalaciones modernas.

- **El WebAppClassLoader usa Child-First**: busca las clases primero en `WEB-INF/lib/` antes que en el padre. Esto aísla las dependencias entre aplicaciones del mismo servidor.

- **El patrón Pipeline-Valve** permite interceptar y transformar las peticiones en cada nivel de la jerarquía, sin tocar el código del Servlet ni el core de Tomcat.

- **Configuración recomendada para producción:**
  - `autoDeploy="false"` — evita despliegues no controlados
  - `reloadable="false"` — evita monitorización innecesaria y memory leaks
  - `port="-1"` en el Server — deshabilita el puerto de shutdown por socket
  - `sessionCookieHttpOnly="true"` y `sessionCookieSecure="true"` — seguridad de sesiones

- **Tomcat 11 introduce Virtual Threads** con Java 21, eliminando el modelo thread-per-request para cargas de I/O intensivas sin necesidad de cambiar el código de las aplicaciones.