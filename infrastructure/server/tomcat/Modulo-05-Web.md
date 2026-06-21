> **Estado:** 🟢 Completo
> **Última actualización:** 2026-05
> **Nivel:** Principiante — se explican los conceptos desde cero

---

- [1. Estructura de una Aplicación Web Java EE / Jakarta EE](#1-estructura-de-una-aplicación-web-java-ee--jakarta-ee)
  - [¿Qué es una aplicación web Java y cómo se empaqueta?](#qué-es-una-aplicación-web-java-y-cómo-se-empaqueta)
  - [¿Por qué una estructura estándar?](#por-qué-una-estructura-estándar)
  - [La estructura completa](#la-estructura-completa)
  - [Explicación directorio por directorio](#explicación-directorio-por-directorio)
- [2. El Descriptor de Despliegue web.xml](#2-el-descriptor-de-despliegue-webxml)
  - [¿Qué es y para qué sirve?](#qué-es-y-para-qué-sirve)
  - [Alternativa a web.xml: anotaciones](#alternativa-a-webxml-anotaciones)
  - [Versiones del descriptor por especificación](#versiones-del-descriptor-por-especificación)
- [3. web.xml Completo de Referencia](#3-webxml-completo-de-referencia)
  - [Para Tomcat 8.x y 9.x (namespace javax.\*)](#para-tomcat-8x-y-9x-namespace-javax)
  - [Para Tomcat 10.x y 11.x (namespace jakarta.\*)](#para-tomcat-10x-y-11x-namespace-jakarta)
- [4 Implementación de Componentes Web](#4-implementación-de-componentes-web)
  - [Servlet con anotaciones — Tomcat 8+ / 9](#servlet-con-anotaciones--tomcat-8--9)
  - [Servlet Asíncrono — Servlet 3.x / 4.0 / 5.0+](#servlet-asíncrono--servlet-3x--40--50)
    - [¿Por qué procesamiento asíncrono?](#por-qué-procesamiento-asíncrono)
  - [Filtro HTTP completo](#filtro-http-completo)
  - [Listener de Contexto](#listener-de-contexto)
- [5. Despliegue de Aplicaciones: Métodos y Estrategias](#5-despliegue-de-aplicaciones-métodos-y-estrategias)
  - [Métodos de despliegue](#métodos-de-despliegue)
  - [Despliegue Zero-Downtime con Context Descriptor](#despliegue-zero-downtime-con-context-descriptor)
- [6. El DefaultServlet de Tomcat](#6-el-defaultservlet-de-tomcat)
- [7. El JspServlet y Configuración de Jasper](#7-el-jspservlet-y-configuración-de-jasper)
- [8. metadata-complete y Orden de Procesamiento](#8-metadata-complete-y-orden-de-procesamiento)
  - [El impacto de metadata-complete en el arranque](#el-impacto-de-metadata-complete-en-el-arranque)
  - [Optimización del escaneo de JARs](#optimización-del-escaneo-de-jars)
- [9. Diferencias de web.xml y APIs entre Versiones de Tomcat](#9-diferencias-de-webxml-y-apis-entre-versiones-de-tomcat)
- [10. Herramienta de Migración Jakarta EE (Tomcat 9 → 10+)](#10-herramienta-de-migración-jakarta-ee-tomcat-9--10)
  - [Integración en el pipeline de build con Maven](#integración-en-el-pipeline-de-build-con-maven)
- [11. Puntos Clave](#11-puntos-clave)

---

# 1. Estructura de una Aplicación Web Java EE / Jakarta EE

## ¿Qué es una aplicación web Java y cómo se empaqueta?

Cuando desarrollas una aplicación web en Java, el resultado final no es un simple archivo `.jar` (como ocurre con las aplicaciones de escritorio). En su lugar, la especificación Java EE/Jakarta EE define un formato de empaquetado específico llamado **WAR** (*Web Application Archive*).

Un archivo WAR es, en esencia, un archivo ZIP con extensión `.war` que contiene toda tu aplicación: el código compilado, las librerías de las que depende, los archivos de configuración y los recursos estáticos (HTML, CSS, imágenes). Cuando despliegas un WAR en Tomcat, este sabe exactamente dónde buscar cada tipo de componente porque la estructura de directorios es **estándar y obligatoria**, definida por la especificación Servlet.

## ¿Por qué una estructura estándar?

La estandarización permite que cualquier servidor de aplicaciones compatible (Tomcat, JBoss/WildFly, Jetty, etc.) pueda desplegar el mismo WAR sin modificaciones. Es la misma idea que un formato de archivo ZIP: todos los programas que saben abrir ZIPs pueden abrir el tuyo.

## La estructura completa

```
myapp.war (o directorio myapp/)
│
├── index.html                        ← Recursos estáticos raíz
├── static/
│   ├── css/app.css
│   ├── js/app.js
│   └── img/logo.png
│
├── META-INF/
│   ├── MANIFEST.MF                   ← Metadatos del JAR/WAR
│   └── context.xml                   ← Context descriptor embebido (opcional)
│
└── WEB-INF/                          ← Directorio protegido (no accesible desde HTTP)
    ├── web.xml                       ← Descriptor de despliegue principal
    ├── tomcat-web.xml                ← Extensiones específicas de Tomcat
    ├── classes/                      ← Clases Java compiladas
    │   ├── com/miempresa/
    │   │   ├── servlet/
    │   │   │   ├── AppServlet.class
    │   │   │   └── ApiServlet.class
    │   │   ├── filter/
    │   │   │   └── AuthFilter.class
    │   │   └── listener/
    │   │       └── AppContextListener.class
    │   └── META-INF/
    │       └── persistence.xml       ← JPA persistence unit
    └── lib/                          ← Librerías JAR de la aplicación
        ├── jackson-databind-2.15.jar
        ├── postgresql-42.6.jar
        └── slf4j-api-2.0.jar
```

## Explicación directorio por directorio

**Raíz del WAR (archivos en la raíz):**
Son los recursos accesibles directamente desde el navegador. Si tienes `index.html` en la raíz, un usuario puede acceder a él con `http://servidor/miapp/index.html`. Lo mismo aplica a cualquier archivo CSS, JS o imagen que pongas aquí o en subdirectorios (como `static/`). Todo lo que está **fuera** de `WEB-INF/` y `META-INF/` es potencialmente accesible desde el navegador.

**`META-INF/`:**
Contiene metadatos del propio archivo WAR. `MANIFEST.MF` es obligatorio en todo JAR/WAR e incluye información como la versión del Manifest y atributos opcionales. El archivo `context.xml` aquí es el *context descriptor embebido*: permite configurar el contexto de la aplicación (nombre, DataSources, etc.) dentro del propio WAR, sin necesidad de modificar los archivos de configuración globales de Tomcat. Tomcat lo lee durante el despliegue.

**`WEB-INF/`:**
Este es el directorio más importante. Tomcat **garantiza** que ninguna petición HTTP puede acceder a su contenido directamente. Si un usuario intenta acceder a `http://servidor/miapp/WEB-INF/web.xml`, Tomcat retorna un `404`. Este comportamiento está definido en la especificación Servlet y todos los servidores compatibles deben respetarlo.

Dentro de `WEB-INF/`:
- `web.xml`: El descriptor de despliegue. Define cómo se comporta la aplicación (se explica en detalle en la sección 5.2).
- `classes/`: Aquí van tus `.class` compilados. La estructura de subdirectorios debe replicar los paquetes Java. Si tienes la clase `com.miempresa.servlet.AppServlet`, el archivo debe estar en `WEB-INF/classes/com/miempresa/servlet/AppServlet.class`.
- `lib/`: Las librerías JAR de las que depende tu aplicación (Jackson para JSON, el driver JDBC de PostgreSQL, SLF4J para logging, etc.). Tomcat las carga automáticamente en el classpath de la aplicación al desplegarla.

> ⚠️ **WEB-INF es inaccesible desde el navegador.** Cualquier petición HTTP a `/WEB-INF/` retorna 404. Esto es una garantía de seguridad de la especificación Servlet. Los archivos de configuración, clases y librerías son seguros dentro de este directorio.

# 2. El Descriptor de Despliegue web.xml

## ¿Qué es y para qué sirve?

El `web.xml` es el archivo de configuración central de tu aplicación web. Su nombre oficial es *deployment descriptor* (descriptor de despliegue). Es un archivo XML que le dice a Tomcat todo lo que necesita saber para ejecutar tu aplicación:

- Qué Servlets existen y a qué URLs responden.
- Qué Filtros se aplican y en qué orden.
- Qué Listeners deben ejecutarse al arrancar o parar la aplicación.
- Cómo gestionar las sesiones de usuario.
- Qué páginas mostrar cuando ocurre un error (404, 500, etc.).
- Cómo proteger ciertas URLs (seguridad declarativa).
- Qué recursos externos usa la aplicación (bases de datos via JNDI).

## Alternativa a web.xml: anotaciones

A partir de Servlet 3.0 (Tomcat 7+), puedes configurar Servlets, Filtros y Listeners directamente en el código Java usando **anotaciones** (`@WebServlet`, `@WebFilter`, `@WebListener`). Esto evita tener que modificar el `web.xml` para registrar un nuevo componente. Sin embargo, `web.xml` sigue siendo necesario para la configuración global de la aplicación (sesiones, errores, seguridad, etc.) y en muchos equipos se prefiere tener toda la configuración centralizada en un solo lugar.

## Versiones del descriptor por especificación

Cada versión de Tomcat implementa una versión de la especificación Servlet, y cada versión de la especificación usa un formato y namespace XML diferente. Es importante usar el namespace correcto, porque si usas el de Tomcat 9 en Tomcat 10, la aplicación fallará al arrancar con errores de validación XML.

| Versión web.xml | Servlet Spec | Tomcat    | Namespace                      |
|-----------------|--------------|-----------|--------------------------------|
| 2.4             | 2.4          | 5.x       | `http://java.sun.com/xml/ns/j2ee` |
| 2.5             | 2.5          | 6.x       | `http://java.sun.com/xml/ns/javaee` |
| 3.0             | 3.0          | 7.x       | `http://java.sun.com/xml/ns/javaee` |
| 3.1             | 3.1          | 8.x, 8.5  | `http://xmlns.jcp.org/xml/ns/javaee` |
| 4.0             | 4.0          | 9.x       | `http://xmlns.jcp.org/xml/ns/javaee` |
| 5.0             | 5.0          | 10.0      | `https://jakarta.ee/xml/ns/jakartaee` |
| 6.0             | 6.0          | 10.1      | `https://jakarta.ee/xml/ns/jakartaee` |
| 6.1             | 6.1          | 11.0      | `https://jakarta.ee/xml/ns/jakartaee` |

**Nota crítica sobre Tomcat 10+:** En 2019, Oracle transfirió Java EE a la Fundación Eclipse, que lo renombró a **Jakarta EE**. Como consecuencia, todos los paquetes Java que antes empezaban por `javax.*` (p.ej. `javax.servlet.http.HttpServlet`) pasaron a llamarse `jakarta.*` (p.ej. `jakarta.servlet.http.HttpServlet`). Este cambio afecta a **todo el código fuente** de tu aplicación, no solo al `web.xml`. Tomcat 10+ solo acepta aplicaciones compiladas contra el namespace `jakarta.*`. Una aplicación compilada para Tomcat 9 no funcionará en Tomcat 10 sin migración.

# 3. web.xml Completo de Referencia

## Para Tomcat 8.x y 9.x (namespace javax.*)

A continuación se muestra un `web.xml` completo con todas las secciones posibles, comentadas en detalle. No todos los proyectos necesitan todas las secciones; incluye solo las que tu aplicación requiera.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
                             http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0"
         metadata-complete="false">
  <!--
    El atributo "version" debe coincidir con la versión de la spec que uses.
    
    "metadata-complete":
      - false (por defecto): Tomcat escanea los JARs buscando anotaciones
        @WebServlet, @WebFilter, @WebListener. Más flexible pero más lento al arrancar.
      - true: Tomcat ignora anotaciones. SOLO usa este web.xml.
        Más rápido al arrancar, pero debes declarar todo aquí explícitamente.
  -->

  <!-- ============================================================ -->
  <!-- SECCIÓN 1: INFORMACIÓN GENERAL DE LA APLICACIÓN             -->
  <!-- ============================================================ -->

  <!-- Nombre descriptivo de la aplicación (aparece en la consola de Tomcat Manager) -->
  <display-name>Mi Aplicación Empresarial</display-name>
  <description>Aplicación de gestión empresarial v2.3.1</description>

  <!--
    context-param: Parámetros de inicialización del contexto (la aplicación completa).
    Son accesibles desde cualquier Servlet o Listener mediante:
      servletContext.getInitParameter("app.environment")
    
    Úsalos para configuración global que necesita ser leída por varios componentes.
    Son de solo lectura una vez que la aplicación arranca.
  -->
  <context-param>
    <param-name>app.environment</param-name>
    <param-value>production</param-value>
  </context-param>

  <context-param>
    <param-name>app.config.path</param-name>
    <param-value>/opt/config/myapp/production.properties</param-value>
  </context-param>

  <context-param>
    <param-name>app.version</param-name>
    <param-value>2.3.1</param-value>
  </context-param>

  <!-- ============================================================ -->
  <!-- SECCIÓN 2: LISTENERS                                        -->
  <!-- ============================================================ -->

  <!--
    ¿Qué es un Listener?
    Un Listener es una clase Java que "escucha" eventos del ciclo de vida de
    la aplicación. Hay tres tipos principales:

    1. ServletContextListener: Se ejecuta cuando la aplicación arranca
       (contextInitialized) y cuando se para (contextDestroyed).
       Es el lugar correcto para inicializar recursos compartidos:
       pools de conexiones, cachés, tareas programadas, etc.

    2. HttpSessionListener: Se ejecuta cuando se crea o destruye una sesión
       de usuario. Útil para contar sesiones activas o limpiar recursos
       asociados a una sesión.

    3. ServletRequestListener: Se ejecuta al inicio y al final de cada
       petición HTTP. Útil para logging o para añadir datos al contexto
       de la petición.

    ORDEN DE INICIALIZACIÓN (fijo por la especificación):
    1. ServletContextListener.contextInitialized() — al arrancar la app
    2. HttpSessionListener — cuando se crea la primera sesión
    3. ServletRequestListener — por cada petición entrante
    
    Los Listeners se inicializan ANTES que los Filtros y los Servlets.
  -->

  <!-- Listener de inicialización de la aplicación -->
  <listener>
    <listener-class>com.miempresa.listener.AppContextListener</listener-class>
  </listener>

  <!-- Listener de sesiones -->
  <listener>
    <listener-class>com.miempresa.listener.SessionListener</listener-class>
  </listener>

  <!-- Listener de peticiones -->
  <listener>
    <listener-class>com.miempresa.listener.RequestListener</listener-class>
  </listener>

  <!-- ============================================================ -->
  <!-- SECCIÓN 3: FILTROS                                          -->
  <!-- ============================================================ -->

  <!--
    ¿Qué es un Filtro?
    Un Filtro es una clase Java que intercepta las peticiones HTTP ANTES de
    que lleguen al Servlet de destino, y también intercepta las respuestas
    ANTES de que sean enviadas al cliente. Forman una "cadena" (Filter Chain).

    Casos de uso típicos:
    - Establecer el encoding de caracteres (UTF-8) en todas las peticiones.
    - Verificar que el usuario está autenticado antes de acceder a recursos protegidos.
    - Añadir cabeceras de seguridad HTTP a todas las respuestas.
    - Gestionar CORS (Cross-Origin Resource Sharing) para APIs.
    - Registrar en logs todas las peticiones entrantes.
    - Limitar la tasa de peticiones (rate limiting).

    IMPORTANTE SOBRE EL ORDEN:
    El orden de ejecución de los filtros está determinado por el orden de los
    elementos <filter-mapping> en este archivo, NO por el orden de los
    elementos <filter>. Los <filter> solo declaran el filtro y sus parámetros;
    los <filter-mapping> determinan cuándo y en qué orden se ejecutan.

    La declaración (<filter>) y el mapping (<filter-mapping>)
    son elementos separados e independientes.
  -->

  <!-- Filtro 1: Encoding UTF-8
       Este debe ser el PRIMERO en ejecutarse. Si el encoding no se establece
       antes de leer los parámetros de la petición, los caracteres especiales
       (tildes, ñ, etc.) se leerán incorrectamente. -->
  <filter>
    <filter-name>encodingFilter</filter-name>
    <filter-class>com.miempresa.filter.EncodingFilter</filter-class>
    <!--
      init-param: Parámetros de inicialización ESPECÍFICOS de este filtro.
      Solo son accesibles por este filtro, no por el resto de la aplicación.
      Se leen una vez al inicializar el filtro mediante:
        filterConfig.getInitParameter("encoding")
    -->
    <init-param>
      <param-name>encoding</param-name>
      <param-value>UTF-8</param-value>
    </init-param>
    <init-param>
      <!-- Si true, sobreescribe el encoding incluso si ya estaba establecido -->
      <param-name>forceEncoding</param-name>
      <param-value>true</param-value>
    </init-param>
  </filter>

  <!-- Filtro 2: Autenticación / JWT
       Verifica que el token JWT en la cabecera Authorization sea válido.
       Las rutas listadas en "excludedPaths" quedan exentas de autenticación
       (necesario para el endpoint de login, ya que el usuario aún no tiene token). -->
  <filter>
    <filter-name>authFilter</filter-name>
    <filter-class>com.miempresa.filter.JwtAuthFilter</filter-class>
    <init-param>
      <param-name>excludedPaths</param-name>
      <param-value>/api/auth/login,/api/auth/register,/health</param-value>
    </init-param>
    <init-param>
      <!-- Nombre de la cabecera HTTP donde se envía el token -->
      <param-name>tokenHeader</param-name>
      <param-value>Authorization</param-value>
    </init-param>
  </filter>

  <!-- Filtro 3: Cabeceras de seguridad HTTP
       Añade cabeceras de seguridad recomendadas por OWASP a todas las respuestas.
       Ejemplos: X-Frame-Options (previene clickjacking), 
       Content-Security-Policy (previene XSS), HSTS (fuerza HTTPS). -->
  <filter>
    <filter-name>securityHeadersFilter</filter-name>
    <filter-class>com.miempresa.filter.SecurityHeadersFilter</filter-class>
  </filter>

  <!-- Filtro 4: CORS (Cross-Origin Resource Sharing)
       Cuando un navegador hace una petición AJAX a un dominio diferente al de
       la página actual (cross-origin), el navegador bloquea la petición por
       seguridad (Same-Origin Policy). CORS es el mecanismo estándar que permite
       al servidor indicar qué orígenes externos están permitidos. -->
  <filter>
    <filter-name>corsFilter</filter-name>
    <filter-class>com.miempresa.filter.CorsFilter</filter-class>
    <init-param>
      <!-- Lista de dominios permitidos para hacer peticiones cross-origin -->
      <param-name>allowedOrigins</param-name>
      <param-value>https://app.miempresa.com,https://admin.miempresa.com</param-value>
    </init-param>
    <init-param>
      <!-- Métodos HTTP permitidos -->
      <param-name>allowedMethods</param-name>
      <param-value>GET,POST,PUT,DELETE,OPTIONS,PATCH</param-value>
    </init-param>
    <init-param>
      <!-- Cabeceras HTTP que el cliente puede enviar -->
      <param-name>allowedHeaders</param-name>
      <param-value>Authorization,Content-Type,X-Requested-With,Accept</param-value>
    </init-param>
    <init-param>
      <!-- Permite enviar cookies en peticiones cross-origin -->
      <param-name>allowCredentials</param-name>
      <param-value>true</param-value>
    </init-param>
    <init-param>
      <!-- Tiempo en segundos que el navegador puede cachear la respuesta preflight OPTIONS -->
      <param-name>maxAge</param-name>
      <param-value>3600</param-value>
    </init-param>
  </filter>

  <!-- Filtro 5: Logging / MDC de Slf4j
       MDC (Mapped Diagnostic Context) permite asociar datos contextuales
       (como el ID de usuario o el ID de petición) a los mensajes de log,
       facilitando la correlación de logs en sistemas distribuidos. -->
  <filter>
    <filter-name>mdcFilter</filter-name>
    <filter-class>com.miempresa.filter.MdcLoggingFilter</filter-class>
  </filter>

  <!-- Filtro 6: Rate Limiting
       Limita el número de peticiones que un cliente puede hacer por unidad
       de tiempo. Previene ataques de fuerza bruta y abuso de la API. -->
  <filter>
    <filter-name>rateLimitFilter</filter-name>
    <filter-class>com.miempresa.filter.RateLimitFilter</filter-class>
    <init-param>
      <param-name>requestsPerMinute</param-name>
      <param-value>1000</param-value>
    </init-param>
  </filter>

  <!--
    FILTER MAPPINGS: Aquí es donde se define el ORDEN real de ejecución.
    
    El orden de los <filter-mapping> determina el orden en que los filtros
    se aplican a cada petición. En este ejemplo:
    
    Para una petición a /api/usuarios:
      1. encodingFilter (/*) — Establece UTF-8
      2. mdcFilter (/*) — Añade contexto al log
      3. securityHeadersFilter (/*) — Añade cabeceras de seguridad
      4. corsFilter (/api/*) — Gestiona CORS
      5. authFilter (/api/*) — Verifica autenticación
      6. rateLimitFilter (/api/*) — Comprueba límite de peticiones
      → Si todo pasa, llega al Servlet
    
    Para una petición a /pagina.html:
      1. encodingFilter (/*) — Establece UTF-8
      2. mdcFilter (/*) — Añade contexto al log
      3. securityHeadersFilter (/*) — Añade cabeceras de seguridad
      → Los filtros de /api/* no se aplican
  -->
  <filter-mapping>
    <filter-name>encodingFilter</filter-name>
    <!-- /* significa "aplícate a TODAS las URLs" -->
    <url-pattern>/*</url-pattern>
  </filter-mapping>

  <filter-mapping>
    <filter-name>mdcFilter</filter-name>
    <url-pattern>/*</url-pattern>
  </filter-mapping>

  <filter-mapping>
    <filter-name>securityHeadersFilter</filter-name>
    <url-pattern>/*</url-pattern>
  </filter-mapping>

  <filter-mapping>
    <filter-name>corsFilter</filter-name>
    <!-- Solo para URLs que empiecen por /api/ -->
    <url-pattern>/api/*</url-pattern>
  </filter-mapping>

  <filter-mapping>
    <filter-name>authFilter</filter-name>
    <url-pattern>/api/*</url-pattern>
    <url-pattern>/admin/*</url-pattern>
  </filter-mapping>

  <filter-mapping>
    <filter-name>rateLimitFilter</filter-name>
    <url-pattern>/api/*</url-pattern>
  </filter-mapping>

  <!--
    dispatcher: Controla en qué tipos de "dispatch" se ejecuta el filtro.
    
    REQUEST (por defecto): Peticiones HTTP normales del cliente externo.
    FORWARD: Cuando un Servlet hace un RequestDispatcher.forward() a otro recurso.
    INCLUDE: Cuando un Servlet incluye otro recurso con RequestDispatcher.include().
    ERROR: Cuando Tomcat redirige a una página de error (configurada en <error-page>).
    ASYNC: Para peticiones procesadas asincrónicamente.
    
    Si no se especifica <dispatcher>, solo se aplica en REQUEST.
    Para aplicar el filtro en todos los casos:
  -->
  <filter-mapping>
    <filter-name>encodingFilter</filter-name>
    <url-pattern>/*</url-pattern>
    <dispatcher>REQUEST</dispatcher>
    <dispatcher>FORWARD</dispatcher>
    <dispatcher>INCLUDE</dispatcher>
    <dispatcher>ERROR</dispatcher>
    <dispatcher>ASYNC</dispatcher>
  </filter-mapping>

  <!-- ============================================================ -->
  <!-- SECCIÓN 4: SERVLETS                                         -->
  <!-- ============================================================ -->

  <!--
    ¿Qué es un Servlet?
    Un Servlet es una clase Java que procesa peticiones HTTP y genera respuestas.
    Es el componente central de las aplicaciones web Java. Cuando un cliente
    hace una petición a una URL determinada, Tomcat busca qué Servlet está
    mapeado a esa URL y lo invoca.

    Un Servlet típico extiende HttpServlet y sobreescribe métodos como:
    - doGet(): Procesa peticiones GET (normalmente lecturas/consultas)
    - doPost(): Procesa peticiones POST (normalmente creación/envío de datos)
    - doPut(): Procesa peticiones PUT (normalmente actualizaciones completas)
    - doDelete(): Procesa peticiones DELETE (normalmente eliminaciones)

    Ciclo de vida de un Servlet:
    1. init(): Se llama UNA SOLA VEZ cuando Tomcat crea la instancia del Servlet.
       Aquí se inicializan recursos: conexiones, cachés, etc.
    2. service(): Se llama POR CADA PETICIÓN. Internamente delega a doGet/doPost/etc.
    3. destroy(): Se llama UNA SOLA VEZ cuando Tomcat destruye el Servlet
       (al parar la aplicación). Aquí se liberan los recursos del init().
    
    IMPORTANTE: Tomcat crea UNA SOLA instancia de cada Servlet y la reutiliza
    para todas las peticiones concurrentes. Por eso los Servlets deben ser
    thread-safe: no puedes usar variables de instancia para almacenar datos
    de una petición específica.
  -->

  <!-- Servlet 1: Dispatcher principal (patrón Front Controller)
       El patrón Front Controller usa un único Servlet como punto de entrada
       que luego redirige a los handlers específicos. Es el patrón que usa
       Spring MVC (DispatcherServlet). -->
  <servlet>
    <servlet-name>appServlet</servlet-name>
    <servlet-class>com.miempresa.servlet.AppDispatcherServlet</servlet-class>
    <init-param>
      <!-- Parámetros de inicialización específicos de este Servlet.
           Solo accesibles mediante: config.getInitParameter("configLocation") -->
      <param-name>configLocation</param-name>
      <param-value>/WEB-INF/app-config.xml</param-value>
    </init-param>
    <init-param>
      <param-name>throwExceptionIfNoHandlerFound</param-name>
      <param-value>true</param-value>
    </init-param>
    <!--
      load-on-startup: Controla CUÁNDO Tomcat crea la instancia del Servlet.
      
      Valor POSITIVO (1, 2, 3...): Tomcat crea la instancia DURANTE EL ARRANQUE
        de la aplicación, en orden ascendente. Si dos Servlets tienen valor 1,
        Tomcat elige el orden. Esto garantiza que el Servlet está listo antes
        de la primera petición real, pero aumenta el tiempo de arranque.
      
      Valor NEGATIVO o ausente: Tomcat crea la instancia LAZY, es decir,
        solo cuando llega la PRIMERA petición que lo necesita. Reduce el tiempo
        de arranque pero la primera petición será más lenta (paga el coste del init()).
      
      Valor 0: Comportamiento no especificado, depende del servidor.
      
      En producción, los Servlets críticos deben tener load-on-startup positivo
      para que los errores de inicialización se detecten al arrancar, no
      cuando un usuario real hace la primera petición.
    -->
    <load-on-startup>1</load-on-startup>
    <enabled>true</enabled>
    <!--
      async-supported: Habilita el procesamiento asíncrono para este Servlet.
      Si es true, el Servlet puede llamar a request.startAsync() para liberar
      el hilo de Tomcat y continuar el procesamiento en otro hilo.
      Explicado en detalle en la sección 5.4.2.
    -->
    <async-supported>true</async-supported>
  </servlet>

  <!-- Servlet 2: API REST
       Gestiona todas las peticiones a /api/*.
       Incluye configuración multipart para subida de archivos. -->
  <servlet>
    <servlet-name>apiServlet</servlet-name>
    <servlet-class>com.miempresa.servlet.ApiServlet</servlet-class>
    <load-on-startup>2</load-on-startup>
    <async-supported>true</async-supported>
    <!--
      multipart-config: Necesario para que el Servlet pueda recibir
      archivos subidos (file uploads, peticiones multipart/form-data).
      Sin esta configuración, intentar acceder a request.getPart() lanzará
      una excepción IllegalStateException.
    -->
    <multipart-config>
      <!-- Directorio temporal donde Tomcat escribe los archivos subidos
           mientras los procesa. Debe existir y tener permisos de escritura. -->
      <location>/tmp/uploads</location>
      <!-- Tamaño máximo de UN SOLO archivo: 50 MB = 50 * 1024 * 1024 bytes -->
      <max-file-size>52428800</max-file-size>
      <!-- Tamaño máximo de TODA LA PETICIÓN (suma de todos los archivos): 100 MB -->
      <max-request-size>104857600</max-request-size>
      <!--
        Umbral a partir del cual el archivo se escribe en disco en lugar
        de mantenerse en memoria. Archivos menores a 1 MB (1048576 bytes)
        se procesan en RAM; los más grandes se escriben en <location>.
        Ajustar según la RAM disponible y el tamaño típico de los uploads.
      -->
      <file-size-threshold>1048576</file-size-threshold>
    </multipart-config>
  </servlet>

  <!-- Servlet 3: Health Check
       Endpoint de monitorización. Los balanceadores de carga y orquestadores
       (Kubernetes, AWS ELB, etc.) hacen peticiones periódicas a este endpoint
       para verificar que la aplicación está viva y puede servir tráfico.
       load-on-startup=1 garantiza que está disponible inmediatamente. -->
  <servlet>
    <servlet-name>healthServlet</servlet-name>
    <servlet-class>com.miempresa.servlet.HealthCheckServlet</servlet-class>
    <load-on-startup>1</load-on-startup>
    <!-- async-supported=false: El health check debe ser sincrónico y rápido.
         No tiene sentido hacerlo asíncrono. -->
    <async-supported>false</async-supported>
  </servlet>

  <!-- Servlet 4: WebSocket Endpoint
       WebSocket es un protocolo de comunicación bidireccional y persistente
       sobre HTTP. A diferencia de HTTP (donde el cliente siempre inicia
       la comunicación), con WebSocket el servidor puede enviar datos
       al cliente en cualquier momento. Útil para notificaciones en tiempo real,
       chats, dashboards en vivo, etc. -->
  <servlet>
    <servlet-name>websocketServlet</servlet-name>
    <servlet-class>com.miempresa.websocket.NotificationEndpoint</servlet-class>
    <load-on-startup>3</load-on-startup>
    <async-supported>true</async-supported>
  </servlet>

  <!--
    SERVLET MAPPINGS: Asocian cada Servlet con las URLs que debe gestionar.
    
    Tipos de patrones URL:
    - Exacto: "/login" — solo para esa URL exacta
    - Prefijo: "/api/*" — para cualquier URL que empiece por /api/
    - Extensión: "*.jsp" — para cualquier URL que termine en .jsp
    - Default: "/" — captura todo lo que no coincide con otro servlet
    
    PRIORIDAD (de mayor a menor): exacto > prefijo (más largo primero) > extensión > default
  -->
  <servlet-mapping>
    <servlet-name>appServlet</servlet-name>
    <!-- "/" captura todas las URLs que no coincidan con ningún otro mapping.
         Es el "catch-all" o dispatcher por defecto. -->
    <url-pattern>/</url-pattern>
  </servlet-mapping>

  <servlet-mapping>
    <servlet-name>apiServlet</servlet-name>
    <url-pattern>/api/*</url-pattern>
  </servlet-mapping>

  <servlet-mapping>
    <servlet-name>healthServlet</servlet-name>
    <!-- Un Servlet puede responder a múltiples URLs -->
    <url-pattern>/health</url-pattern>
    <url-pattern>/health/live</url-pattern>
    <url-pattern>/health/ready</url-pattern>
  </servlet-mapping>

  <servlet-mapping>
    <servlet-name>websocketServlet</servlet-name>
    <url-pattern>/ws/*</url-pattern>
  </servlet-mapping>

  <!-- ============================================================ -->
  <!-- SECCIÓN 5: GESTIÓN DE SESIONES                              -->
  <!-- ============================================================ -->

  <!--
    ¿Qué es una sesión?
    HTTP es un protocolo sin estado (stateless): cada petición es independiente
    y el servidor no recuerda peticiones anteriores. Las sesiones son el
    mecanismo que permite "recordar" a un usuario entre peticiones.
    
    Cuando un usuario hace login, el servidor crea una sesión (un objeto
    HttpSession en Java) que almacena datos de ese usuario (su ID, sus
    preferencias, etc.). El servidor asigna un ID único a esa sesión y lo
    envía al cliente en una cookie. En las peticiones siguientes, el cliente
    envía esa cookie y el servidor puede recuperar la sesión con todos los
    datos del usuario.
  -->
  <session-config>
    <!-- Tiempo de inactividad en MINUTOS tras el cual la sesión expira.
         0 significa que nunca expira (peligroso: acumula sesiones en memoria).
         30 minutos es un valor razonable para aplicaciones empresariales.
         Ajustar según el caso de uso: un banco puede querer 5 minutos;
         una red social puede querer 30 días. -->
    <session-timeout>30</session-timeout>

    <cookie-config>
      <!-- Nombre personalizado para la cookie de sesión.
           Por defecto Tomcat usa "JSESSIONID". Cambiarlo dificulta la
           identificación del servidor por parte de atacantes. -->
      <name>MYAPP_SESSIONID</name>
      <!-- Dominio al que pertenece la cookie. El navegador solo envía
           la cookie a peticiones dirigidas a este dominio. -->
      <domain>miempresa.com</domain>
      <!-- Path: el navegador solo envía la cookie en peticiones a URLs
           que comiencen por este path. "/" significa toda la aplicación. -->
      <path>/</path>
      <!--
        HttpOnly: Si es true, la cookie NO es accesible desde JavaScript.
        document.cookie no la muestra. Esto previene ataques XSS (Cross-Site
        Scripting) que intentan robar la cookie de sesión mediante JS malicioso.
        SIEMPRE debe ser true en producción.
      -->
      <http-only>true</http-only>
      <!--
        Secure: Si es true, la cookie SOLO se envía en conexiones HTTPS.
        Nunca se envía en HTTP plano (sin cifrar). Esto previene que un
        atacante en la red intercepte la cookie (ataque man-in-the-middle).
        SIEMPRE debe ser true en producción si usas HTTPS (que deberías).
      -->
      <secure>true</secure>
      <!--
        Max-age: Duración máxima de la cookie en segundos.
        -1 = cookie de sesión: se elimina cuando el usuario cierra el navegador.
        0 = eliminación inmediata.
        Valor positivo = persiste ese número de segundos aunque se cierre el navegador.
        Para sesiones de login con "recordarme", usarías un valor positivo alto.
      -->
      <max-age>-1</max-age>
    </cookie-config>

    <!--
      tracking-mode: Cómo se propaga el ID de sesión entre peticiones.
      
      COOKIE (recomendado): El ID de sesión va en una cookie HTTP.
        Transparente para el usuario, funciona en todos los navegadores modernos.
      
      URL (NO recomendado): El ID de sesión se añade a la URL como parámetro:
        /myapp/pagina;jsessionid=ABC123. Problemas: el ID queda expuesto en
        los logs del servidor, en el historial del navegador, y en el Referer
        header. Además, los usuarios pueden copiar y compartir la URL.
      
      SSL: Usa el identificador de la sesión SSL/TLS. Solo funciona con HTTPS
        y es poco habitual.
    -->
    <tracking-mode>COOKIE</tracking-mode>
  </session-config>

  <!-- ============================================================ -->
  <!-- SECCIÓN 6: PÁGINAS DE BIENVENIDA                           -->
  <!-- ============================================================ -->

  <!--
    Cuando un usuario accede a un directorio sin especificar un archivo
    (p.ej. http://servidor/miapp/), Tomcat busca en orden los archivos
    listados aquí. Sirve el primero que encuentre.
  -->
  <welcome-file-list>
    <welcome-file>index.html</welcome-file>
    <welcome-file>index.jsp</welcome-file>
    <welcome-file>index.htm</welcome-file>
  </welcome-file-list>

  <!-- ============================================================ -->
  <!-- SECCIÓN 7: MANEJO DE ERRORES                               -->
  <!-- ============================================================ -->

  <!--
    Define qué página mostrar cuando ocurre un error. Sin esta configuración,
    Tomcat mostraría su página de error por defecto, que puede exponer
    información sensible (stack traces, versión de Tomcat, estructura interna).
    
    Hay dos formas de especificar el error:
    1. Por código HTTP (400, 401, 403, 404, 500, etc.)
    2. Por tipo de excepción Java (java.lang.Exception, etc.)
    
    Cuando ocurre un error, Tomcat añade atributos especiales a la petición
    que la página de error puede usar:
    - javax.servlet.error.status_code: Código HTTP del error
    - javax.servlet.error.exception: La excepción que causó el error
    - javax.servlet.error.message: Mensaje del error
    - javax.servlet.error.request_uri: URL original que falló
  -->

  <!-- Manejo por código HTTP -->
  <error-page>
    <!-- 400 Bad Request: La petición está mal formada -->
    <error-code>400</error-code>
    <location>/error/400.html</location>
  </error-page>

  <error-page>
    <!-- 401 Unauthorized: Requiere autenticación -->
    <error-code>401</error-code>
    <location>/error/401.html</location>
  </error-page>

  <error-page>
    <!-- 403 Forbidden: Autenticado pero sin permisos suficientes -->
    <error-code>403</error-code>
    <location>/error/403.html</location>
  </error-page>

  <error-page>
    <!-- 404 Not Found: El recurso solicitado no existe -->
    <error-code>404</error-code>
    <location>/error/404.html</location>
  </error-page>

  <error-page>
    <!-- 405 Method Not Allowed: El método HTTP (GET, POST, etc.) no está permitido -->
    <error-code>405</error-code>
    <location>/error/405.html</location>
  </error-page>

  <error-page>
    <!-- 500 Internal Server Error: Error no controlado en el servidor -->
    <error-code>500</error-code>
    <location>/error/500.html</location>
  </error-page>

  <error-page>
    <!-- 503 Service Unavailable: El servidor está sobrecargado o en mantenimiento -->
    <error-code>503</error-code>
    <location>/error/503.html</location>
  </error-page>

  <!-- Manejo por tipo de excepción Java
       Si una excepción no controlada llega hasta Tomcat, este puede
       redirigir a una página de error específica según el tipo. -->
  <error-page>
    <!-- Captura cualquier excepción Java (es la más genérica) -->
    <exception-type>java.lang.Exception</exception-type>
    <!-- Puede ser una URL dinámica (Servlet) para personalizar la respuesta -->
    <location>/error/general-error</location>
  </error-page>

  <error-page>
    <exception-type>java.lang.RuntimeException</exception-type>
    <location>/error/runtime-error</location>
  </error-page>

  <error-page>
    <exception-type>javax.servlet.ServletException</exception-type>
    <location>/error/servlet-error</location>
  </error-page>

  <!-- ============================================================ -->
  <!-- SECCIÓN 8: MIME TYPES                                       -->
  <!-- ============================================================ -->

  <!--
    MIME Types (Multipurpose Internet Mail Extensions): Indican el tipo de
    contenido de un archivo. El servidor los incluye en la cabecera
    Content-Type de la respuesta HTTP para que el navegador sepa cómo
    interpretar el archivo recibido.
    
    Tomcat tiene una lista predefinida de MIME types (en su web.xml global).
    Aquí puedes añadir tipos que Tomcat no reconoce por defecto, o sobrescribir
    los existentes. Muy importante para formatos modernos que Tomcat antiguo
    puede no conocer.
  -->
  <mime-mapping>
    <!-- .json → application/json (necesario para que el navegador no
         descargue los archivos JSON sino que los procese correctamente) -->
    <extension>json</extension>
    <mime-type>application/json; charset=UTF-8</mime-type>
  </mime-mapping>

  <mime-mapping>
    <!-- Fuentes web modernas -->
    <extension>woff2</extension>
    <mime-type>font/woff2</mime-type>
  </mime-mapping>

  <mime-mapping>
    <extension>woff</extension>
    <mime-type>font/woff</mime-type>
  </mime-mapping>

  <mime-mapping>
    <!-- Formato de imagen WebP (mejor compresión que JPEG/PNG) -->
    <extension>webp</extension>
    <mime-type>image/webp</mime-type>
  </mime-mapping>

  <mime-mapping>
    <!-- Formato AVIF (aún mejor compresión que WebP) -->
    <extension>avif</extension>
    <mime-type>image/avif</mime-type>
  </mime-mapping>

  <mime-mapping>
    <!-- Source maps para depuración de JS minificado -->
    <extension>map</extension>
    <mime-type>application/json</mime-type>
  </mime-mapping>

  <!-- ============================================================ -->
  <!-- SECCIÓN 9: RECURSOS JNDI                                    -->
  <!-- ============================================================ -->

  <!--
    JNDI (Java Naming and Directory Interface): Es un servicio de nombres
    que permite a las aplicaciones Java buscar recursos por nombre en lugar
    de crearlos directamente. Es como una "guía telefónica" de objetos Java.

    ¿Por qué usar JNDI para bases de datos?
    Sin JNDI, cada aplicación crearía su propio pool de conexiones a la BD,
    con sus propias credenciales en el código o en archivos de configuración
    dentro del WAR. Con JNDI:
    
    1. El administrador de Tomcat configura el DataSource (pool de conexiones
       + credenciales) en los archivos de configuración de Tomcat
       (context.xml o server.xml), fuera del WAR.
    2. La aplicación solo conoce el nombre JNDI (p.ej. "jdbc/AppDB").
    3. Tomcat proporciona el DataSource ya configurado cuando la aplicación
       lo solicita por ese nombre.
    
    Beneficios:
    - Las credenciales de BD no están en el WAR (mejor seguridad).
    - El mismo WAR puede desplegarse en diferentes entornos (dev, staging, prod)
      con diferentes BDs sin recompilar.
    - El pool de conexiones está gestionado por Tomcat, no por la aplicación.
    
    resource-ref: Declara que la aplicación NECESITA este recurso JNDI.
    Es una declaración de dependencia. El recurso real se define en
    context.xml o server.xml de Tomcat.
  -->
  <resource-ref>
    <description>Base de datos principal de la aplicación</description>
    <!-- Nombre JNDI relativo. El nombre completo será "java:comp/env/jdbc/AppDB" -->
    <res-ref-name>jdbc/AppDB</res-ref-name>
    <!-- Tipo Java del recurso -->
    <res-type>javax.sql.DataSource</res-type>
    <!-- Container: Tomcat gestiona la autenticación con la BD.
         Application: La aplicación gestiona la autenticación. -->
    <res-auth>Container</res-auth>
    <!-- Shareable: Múltiples componentes pueden compartir la misma referencia.
         Unshareable: Cada componente obtiene su propia referencia exclusiva. -->
    <res-sharing-scope>Shareable</res-sharing-scope>
  </resource-ref>

  <resource-ref>
    <description>Base de datos de auditoría</description>
    <res-ref-name>jdbc/AuditDB</res-ref-name>
    <res-type>javax.sql.DataSource</res-type>
    <res-auth>Container</res-auth>
    <!-- Unshareable para la BD de auditoría: cada componente tiene
         su propia conexión para evitar mezcla de transacciones de auditoría. -->
    <res-sharing-scope>Unshareable</res-sharing-scope>
  </resource-ref>

  <!-- ============================================================ -->
  <!-- SECCIÓN 10: SEGURIDAD DECLARATIVA                           -->
  <!-- ============================================================ -->

  <!--
    La seguridad declarativa permite proteger URLs mediante configuración
    en web.xml, sin necesidad de código Java. Tomcat gestiona la
    autenticación y autorización automáticamente basándose en esta
    configuración y en el Realm configurado (base de datos de usuarios,
    LDAP, archivo de texto, etc.).
    
    Es una alternativa a la seguridad programática (código Java que comprueba
    manualmente si el usuario tiene permisos). La seguridad declarativa es
    más fácil de gestionar y auditar, pero menos flexible.
  -->

  <!-- Roles de seguridad: Deben declararse aquí los roles que se usan
       en los <auth-constraint>. El mapeo real de roles a usuarios se
       hace en el Realm de Tomcat (tomcat-users.xml, BD, LDAP, etc.). -->
  <security-role>
    <role-name>admin</role-name>
  </security-role>

  <security-role>
    <role-name>manager</role-name>
  </security-role>

  <security-role>
    <role-name>user</role-name>
  </security-role>

  <!-- Restricción de seguridad para área de administración:
       Solo usuarios con el rol "admin" pueden acceder a /admin/* -->
  <security-constraint>
    <display-name>Admin Area</display-name>
    <web-resource-collection>
      <web-resource-name>Admin Resources</web-resource-name>
      <url-pattern>/admin/*</url-pattern>
      <!-- Si no se especifican http-method, la restricción aplica a TODOS
           los métodos. Si se especifican, aplica SOLO a esos métodos;
           los demás quedan sin restricción (cuidado con esto). -->
      <http-method>GET</http-method>
      <http-method>POST</http-method>
      <http-method>PUT</http-method>
      <http-method>DELETE</http-method>
    </web-resource-collection>
    <auth-constraint>
      <!-- Solo el rol admin puede acceder -->
      <role-name>admin</role-name>
    </auth-constraint>
    <user-data-constraint>
      <!--
        transport-guarantee: Nivel de seguridad del transporte requerido.
        NONE: No se requiere cifrado (HTTP plano permitido).
        INTEGRAL: Los datos no pueden ser modificados en tránsito (HTTPS).
        CONFIDENTIAL: Los datos no pueden ser leídos ni modificados (HTTPS).
        
        En la práctica, INTEGRAL y CONFIDENTIAL se comportan igual en Tomcat:
        ambos redirigen automáticamente de HTTP a HTTPS si el conector HTTPS
        está configurado.
      -->
      <transport-guarantee>CONFIDENTIAL</transport-guarantee>
    </user-data-constraint>
  </security-constraint>

  <!-- Restricción para API (cualquier usuario autenticado) -->
  <security-constraint>
    <display-name>API Resources</display-name>
    <web-resource-collection>
      <web-resource-name>API Protected</web-resource-name>
      <url-pattern>/api/protected/*</url-pattern>
    </web-resource-collection>
    <auth-constraint>
      <!-- Cualquiera de estos roles puede acceder -->
      <role-name>admin</role-name>
      <role-name>manager</role-name>
      <role-name>user</role-name>
    </auth-constraint>
    <user-data-constraint>
      <transport-guarantee>CONFIDENTIAL</transport-guarantee>
    </user-data-constraint>
  </security-constraint>

  <!-- Método de autenticación: Cómo Tomcat solicita las credenciales al usuario -->
  <login-config>
    <!--
      BASIC: Muestra un diálogo nativo del navegador. Las credenciales van
        en Base64 en cada petición (NO cifradas, solo codificadas). Requiere HTTPS.
      
      DIGEST: Las credenciales van hasheadas (MD5). Más seguro que BASIC
        pero obsoleto; MD5 no es seguro para este uso.
      
      FORM: Formulario HTML personalizado. Las credenciales van en el
        cuerpo de una petición POST. Requiere HTTPS.
      
      CLIENT-CERT: Autenticación mutua TLS (mTLS). El cliente presenta
        un certificado digital. Muy seguro, pero complejo de gestionar.
      
      NONE: Sin autenticación declarativa (se gestiona programáticamente).
    -->
    <auth-method>FORM</auth-method>
    <realm-name>Mi Aplicación Empresarial</realm-name>
    <form-login-config>
      <!-- Página de login personalizada. DEBE tener un formulario con
           action="j_security_check", campo j_username y campo j_password. -->
      <form-login-page>/login.html</form-login-page>
      <!-- Página que se muestra si el login falla -->
      <form-error-page>/login-error.html</form-error-page>
    </form-login-config>
  </login-config>

</web-app>
```

## Para Tomcat 10.x y 11.x (namespace jakarta.*)

El contenido del descriptor es idéntico en estructura, pero cambian dos cosas fundamentales:

1. **El namespace XML del propio `web.xml`** pasa de `http://xmlns.jcp.org/xml/ns/javaee` a `https://jakarta.ee/xml/ns/jakartaee`.
2. **Las clases Java** referenciadas en `<filter-class>`, `<servlet-class>`, etc., deben estar compiladas contra el paquete `jakarta.*` en lugar de `javax.*`. El `web.xml` no referencia paquetes directamente en el XML, pero las clases que declares deben usar los imports correctos.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="https://jakarta.ee/xml/ns/jakartaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="https://jakarta.ee/xml/ns/jakartaee
                             https://jakarta.ee/xml/ns/jakartaee/web-app_6_0.xsd"
         version="6.0"
         metadata-complete="false">

  <!--
    El contenido interno es idéntico al de la versión javax.*
    EXCEPTO que las clases Java referenciadas usan el paquete jakarta.*:
      - javax.servlet.* → jakarta.servlet.*
      - javax.sql.*     → Sigue siendo javax.sql.* (Java SE, no cambia)
    
    El namespace XML del descriptor SÍ cambia (líneas de arriba).
    
    Nota: javax.sql.DataSource NO cambia porque pertenece a Java SE (JDBC),
    no a Jakarta EE. Solo cambian las APIs propias de Jakarta EE.
  -->

  <display-name>Mi Aplicación Jakarta EE</display-name>

  <session-config>
    <session-timeout>30</session-timeout>
    <cookie-config>
      <name>MYAPP_SESSIONID</name>
      <http-only>true</http-only>
      <secure>true</secure>
    </cookie-config>
    <tracking-mode>COOKIE</tracking-mode>
  </session-config>

  <!-- El resto del contenido es igual cambiando los namespaces de clases -->

</web-app>
```

# 4 Implementación de Componentes Web

## Servlet con anotaciones — Tomcat 8+ / 9

A partir de Servlet 3.0, puedes registrar un Servlet directamente con la anotación `@WebServlet` en el código Java, sin necesidad de declararlo en `web.xml`. Las anotaciones son equivalentes a la configuración XML: Tomcat las lee en el arranque y registra el Servlet automáticamente.

**Cuándo usar anotaciones vs web.xml:**
- Anotaciones: más cómodo para proyectos pequeños o cuando cada desarrollador gestiona su propio Servlet.
- web.xml: preferible en equipos donde quieres tener toda la configuración centralizada y visible, o cuando usas `metadata-complete="true"` para acelerar el arranque.

**Limitación importante:** Si `metadata-complete="true"` en tu `web.xml`, las anotaciones son **completamente ignoradas** por Tomcat. Debes registrar todos los componentes en el XML.

```java
package com.miempresa.servlet;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.annotation.WebInitParam;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Servlet con configuración vía anotaciones.
 * Las anotaciones son equivalentes a la configuración en web.xml.
 * Si metadata-complete="true" en web.xml, las anotaciones son IGNORADAS.
 */
@WebServlet(
    name        = "apiServlet",         // Equivalente a <servlet-name>
    urlPatterns = { "/api/*", "/api/v1/*" }, // Equivalente a <url-pattern>
    loadOnStartup = 1,                  // Equivalente a <load-on-startup>
    asyncSupported = true,              // Equivalente a <async-supported>
    initParams  = {
        // Equivalente a <init-param> — parámetros de inicialización del Servlet
        @WebInitParam(name = "maxResults",   value = "100"),
        @WebInitParam(name = "cacheTimeout", value = "300"),
        @WebInitParam(name = "apiVersion",   value = "v1")
    }
)
public class ApiServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // Variables de instancia: se inicializan en init() y son de solo lectura.
    // NUNCA guardes datos de una petición específica aquí porque el Servlet
    // es compartido entre todos los threads concurrentes.
    private int maxResults;
    private int cacheTimeout;
    private String apiVersion;
    private ServletContext context;

    /**
     * init(): Se llama UNA SOLA VEZ cuando Tomcat crea el Servlet.
     * Lugar correcto para leer parámetros de configuración e inicializar
     * recursos reutilizables.
     * 
     * IMPORTANTE: Si este método lanza UnavailableException, Tomcat
     * marca el Servlet como no disponible y retorna 503.
     */
    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config); // SIEMPRE llamar al super.init() primero
        this.context      = config.getServletContext();
        
        // Leer los init-param declarados en la anotación o web.xml
        this.maxResults   = Integer.parseInt(config.getInitParameter("maxResults"));
        this.cacheTimeout = Integer.parseInt(config.getInitParameter("cacheTimeout"));
        this.apiVersion   = config.getInitParameter("apiVersion");

        // Los context-param de web.xml son accesibles desde el ServletContext,
        // que es el objeto que representa toda la aplicación (compartido entre
        // todos los Servlets y Filtros de la misma app).
        String env = context.getInitParameter("app.environment");

        context.log("ApiServlet inicializado. Env: " + env
            + ", maxResults: " + maxResults);
    }

    /**
     * doGet(): Se llama para cada petición HTTP GET a las URLs mapeadas.
     * En una API REST, GET se usa para consultas y lecturas (no modifica estado).
     */
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // pathInfo: La parte de la URL después del patrón de mapeo.
        // Si el Servlet está mapeado a "/api/*" y la petición es "/api/usuarios/123",
        // pathInfo = "/usuarios/123"
        String pathInfo = request.getPathInfo();
        String queryString = request.getQueryString();

        // SIEMPRE establecer ContentType y charset ANTES de obtener el Writer.
        // Si se obtiene el Writer primero, el ContentType puede no propagarse
        // correctamente a la cabecera HTTP.
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Cabeceras de caché: Indican al cliente y a los proxies que no
        // cacheen esta respuesta. Crítico para datos dinámicos que cambian
        // entre peticiones.
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        // try-with-resources: Garantiza que el PrintWriter se cierra aunque
        // ocurra una excepción. Tomcat necesita que el Writer esté cerrado
        // para poder enviar la respuesta al cliente.
        try (PrintWriter out = response.getWriter()) {
            out.println("{\"status\":\"ok\",\"version\":\"" + apiVersion + "\"}");
        }
    }

    /**
     * doPost(): Se llama para cada petición HTTP POST.
     * En una API REST, POST se usa para crear nuevos recursos.
     */
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // SIEMPRE establecer el encoding de la petición ANTES de leer
        // ningún parámetro o el body. Una vez leído el primer byte,
        // el encoding no puede cambiarse.
        request.setCharacterEncoding("UTF-8");
        String contentType = request.getContentType();

        // Validar que el cliente envía JSON. En una API REST es buena práctica
        // verificar el Content-Type y rechazar peticiones con formato incorrecto.
        if (contentType == null || !contentType.contains("application/json")) {
            // 415 Unsupported Media Type: el servidor no acepta ese Content-Type
            response.sendError(HttpServletResponse.SC_UNSUPPORTED_MEDIA_TYPE,
                "Content-Type debe ser application/json");
            return; // IMPORTANTE: return después de sendError para detener el procesamiento
        }

        // Leer el body completo de la petición.
        // request.getReader() devuelve el body como texto usando el charset
        // establecido por setCharacterEncoding().
        StringBuilder body = new StringBuilder();
        try (var reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                body.append(line);
            }
        }

        // 201 Created: código HTTP estándar para indicar que un recurso
        // fue creado exitosamente.
        response.setContentType("application/json; charset=UTF-8");
        response.setStatus(HttpServletResponse.SC_CREATED);
        try (PrintWriter out = response.getWriter()) {
            out.println("{\"status\":\"created\",\"received\":" + body.length() + "}");
        }
    }

    /**
     * destroy(): Se llama UNA SOLA VEZ cuando Tomcat va a destruir el Servlet
     * (al parar la aplicación o redesplegarla).
     * Liberar aquí todos los recursos inicializados en init():
     * conexiones de BD, threads, sockets, etc.
     * Si no se liberan, se producen fugas de recursos (resource leaks).
     */
    @Override
    public void destroy() {
        context.log("ApiServlet destruido. Liberando recursos...");
        // Liberar recursos: cerrar conexiones, cancelar tareas programadas, etc.
    }
}
```

## Servlet Asíncrono — Servlet 3.x / 4.0 / 5.0+

### ¿Por qué procesamiento asíncrono?

Tomcat tiene un pool de hilos limitado (configurable, típicamente 200). Cada petición HTTP ocupa un hilo del pool durante toda su duración. Si tu Servlet hace operaciones lentas (consultas a BD que tardan 2 segundos, llamadas a servicios externos, etc.) mientras espera la respuesta, ese hilo está bloqueado sin hacer nada útil.

Con 200 peticiones concurrentes lentas, el pool se agota y las peticiones siguientes quedan en cola o reciben un error 503. Esto limita gravemente la escalabilidad.

**El procesamiento asíncrono** (introducido en Servlet 3.0) permite que el Servlet "suspenda" la petición, libere el hilo de Tomcat al pool, y complete la petición desde otro hilo (gestionado por la aplicación) cuando la operación lenta termine. Esto permite que el mismo pool de 200 hilos gestione miles de peticiones concurrentes que están esperando operaciones I/O.

```java
package com.miempresa.servlet;

import javax.servlet.AsyncContext;
import javax.servlet.AsyncEvent;
import javax.servlet.AsyncListener;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Servlet Asíncrono: libera el hilo del pool de Tomcat inmediatamente
 * y procesa la petición en un pool de hilos independiente.
 * Útil para operaciones I/O-bound (llamadas a servicios externos, BD, etc.)
 */
@WebServlet(urlPatterns = "/api/async/*", asyncSupported = true)
// CRÍTICO: asyncSupported = true es OBLIGATORIO para usar startAsync().
// Si el Servlet no lo declara, request.startAsync() lanzará IllegalStateException.
// Lo mismo aplica si hay Filtros en la cadena que no tengan asyncSupported=true.
public class AsyncApiServlet extends HttpServlet {

    private ExecutorService asyncExecutor;

    @Override
    public void init() {
        // Pool de hilos dedicado para el procesamiento asíncrono.
        // Este pool es INDEPENDIENTE del pool de Tomcat.
        // availableProcessors() * 2 es un punto de partida razonable para
        // operaciones I/O-bound (que pasan la mayor parte del tiempo esperando).
        // Para operaciones CPU-bound, availableProcessors() sin multiplicar.
        asyncExecutor = Executors.newFixedThreadPool(
            Runtime.getRuntime().availableProcessors() * 2
        );
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response) {

        // PASO 1: Iniciar modo asíncrono.
        // request.startAsync() hace tres cosas:
        //   a) Crea un AsyncContext que "envuelve" la petición.
        //   b) Marca la petición como asíncrona.
        //   c) Indica a Tomcat que NO cierre la respuesta cuando doGet() retorne.
        // A partir de aquí, el método doGet() puede retornar y Tomcat
        // devuelve el hilo al pool. La petición permanece "suspendida".
        AsyncContext asyncContext = request.startAsync();

        // PASO 2: Establecer timeout.
        // Si asyncContext.complete() no se llama antes de este timeout,
        // Tomcat dispara el evento onTimeout del listener.
        // IMPORTANTE: Este timeout debe ser menor que el asyncTimeout
        // del Connector en server.xml (por defecto 30 segundos en Tomcat 10+).
        asyncContext.setTimeout(25000); // 25 segundos

        // PASO 3: Registrar listener para manejar eventos del ciclo de vida async.
        // Es fundamental manejar timeout y error para no dejar peticiones "colgadas".
        asyncContext.addListener(new AsyncListener() {
            @Override
            public void onComplete(AsyncEvent event) {
                // Se llama cuando asyncContext.complete() es invocado correctamente.
                // Lugar para registrar métricas de duración de la petición, etc.
            }

            @Override
            public void onTimeout(AsyncEvent event) throws IOException {
                // La operación tardó más que el timeout configurado.
                // OBLIGATORIO: establecer la respuesta de error y llamar a complete().
                HttpServletResponse resp =
                    (HttpServletResponse) event.getAsyncContext().getResponse();
                resp.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE); // 503
                resp.getWriter().println("{\"error\":\"Request timeout\"}");
                event.getAsyncContext().complete(); // Liberar recursos
            }

            @Override
            public void onError(AsyncEvent event) throws IOException {
                // Ocurrió una excepción no controlada durante el procesamiento async.
                HttpServletResponse resp =
                    (HttpServletResponse) event.getAsyncContext().getResponse();
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500
                resp.getWriter().println("{\"error\":\"Internal error\"}");
                event.getAsyncContext().complete();
            }

            @Override
            public void onStartAsync(AsyncEvent event) {
                // Se llama si se reinicia el modo async (raro). No suele necesitar acción.
            }
        });

        // PASO 4: Encolar el trabajo real en el pool de hilos asíncrono.
        // asyncExecutor.submit() retorna inmediatamente. La lambda se ejecutará
        // en otro hilo del asyncExecutor, no en el hilo de Tomcat.
        // Aquí doGet() retorna → el hilo de Tomcat vuelve al pool.
        asyncExecutor.submit(() -> {
            try {
                // Aquí va la operación lenta: consulta a BD, llamada a API externa, etc.
                String result = processLongRunningOperation(request);

                // PASO 5: Escribir la respuesta cuando la operación termina.
                // asyncContext.getResponse() devuelve el objeto response original,
                // que Tomcat mantiene abierto mientras el AsyncContext no se complete.
                HttpServletResponse asyncResponse =
                    (HttpServletResponse) asyncContext.getResponse();
                asyncResponse.setContentType("application/json; charset=UTF-8");
                asyncResponse.setStatus(HttpServletResponse.SC_OK);

                try (PrintWriter writer = asyncResponse.getWriter()) {
                    writer.println(result);
                }

            } catch (Exception e) {
                // Propagar la excepción al mecanismo de error de Tomcat
                asyncContext.getRequest().setAttribute(
                    "javax.servlet.error.exception", e
                );
            } finally {
                // PASO 6: CRÍTICO — SIEMPRE llamar a complete() en el bloque finally.
                // complete() le dice a Tomcat que la respuesta está lista y puede
                // ser enviada al cliente. Si no se llama, la petición queda
                // suspendida hasta que se dispara el timeout.
                asyncContext.complete();
            }
        });
        // doGet() retorna aquí. El hilo de Tomcat está libre.
        // La petición se completará desde el asyncExecutor.
    }

    private String processLongRunningOperation(HttpServletRequest request)
            throws InterruptedException {
        // Simular latencia de operación real (consulta BD, llamada a API, etc.)
        Thread.sleep(2000);
        return "{\"status\":\"ok\",\"data\":\"resultado procesado\"}";
    }

    @Override
    public void destroy() {
        // IMPORTANTE: apagar el ExecutorService al destruir el Servlet.
        // Si no se hace, los hilos del asyncExecutor son no-daemon y
        // pueden impedir que la JVM se apague correctamente.
        asyncExecutor.shutdown();
    }
}
```

## Filtro HTTP completo

El siguiente ejemplo implementa un filtro de cabeceras de seguridad. Aplica las recomendaciones OWASP para proteger contra los ataques web más comunes.

```java
package com.miempresa.filter;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

/**
 * Filtro de cabeceras de seguridad HTTP.
 * Se ejecuta en TODAS las peticiones.
 * Añade las cabeceras de seguridad recomendadas por OWASP.
 */
@WebFilter(
    filterName   = "securityHeadersFilter",
    urlPatterns  = { "/*" },
    asyncSupported = true
    // asyncSupported = true es OBLIGATORIO si algún Servlet en la cadena
    // usa procesamiento asíncrono. Si un Filtro no lo declara,
    // la petición asíncrona falla con IllegalStateException.
)
public class SecurityHeadersFilter implements Filter {

    private Set<String> excludedPaths;
    private boolean enforceHttps;

    @Override
    public void init(FilterConfig filterConfig) {
        // Leer rutas excluidas de los init-param (desde web.xml o la anotación)
        String excluded = filterConfig.getInitParameter("excludedPaths");
        if (excluded != null) {
            excludedPaths = new HashSet<>(Arrays.asList(excluded.split(",")));
        } else {
            excludedPaths = new HashSet<>();
        }

        String https = filterConfig.getInitParameter("enforceHttps");
        this.enforceHttps = Boolean.parseBoolean(https != null ? https : "true");
    }

    /**
     * doFilter(): Se invoca por CADA petición que coincida con el mapping del filtro.
     * 
     * El patrón es siempre:
     * 1. Pre-procesamiento (antes de la petición llega al Servlet)
     * 2. chain.doFilter(request, response) → pasa al siguiente eslabón de la cadena
     * 3. Post-procesamiento (después de que el Servlet ha escrito la respuesta)
     * 
     * Si NO se llama a chain.doFilter(), la petición no llega al Servlet.
     * Esto se usa para bloquear peticiones no autorizadas (el filtro retorna
     * directamente un error sin pasar la petición al Servlet).
     */
    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        // Los parámetros son ServletRequest/Response (genéricos) pero en
        // la práctica siempre son HTTP. El cast es seguro en este contexto.
        HttpServletRequest  httpRequest  = (HttpServletRequest)  request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String path = httpRequest.getRequestURI();

        // Añadir ID único a la petición para correlación en logs.
        // Todos los logs de esta petición (en diferentes componentes) pueden
        // incluir este ID para rastrear el flujo completo de una petición.
        String requestId = UUID.randomUUID().toString();
        httpRequest.setAttribute("requestId", requestId);
        httpResponse.setHeader("X-Request-ID", requestId);

        if (!excludedPaths.contains(path)) {

            // ===== Cabeceras de Seguridad OWASP =====

            // X-Frame-Options: Previene que la página sea incrustada en un <iframe>
            // por otros sitios, evitando ataques de clickjacking.
            // SAMEORIGIN: Solo permite iframes del mismo dominio.
            // DENY: No permite iframes en ningún caso.
            httpResponse.setHeader("X-Frame-Options", "SAMEORIGIN");

            // X-Content-Type-Options: Previene que el navegador "adivine" el
            // Content-Type de una respuesta (MIME sniffing). Sin esta cabecera,
            // si un atacante logra subir un archivo HTML renombrado como .jpg,
            // algunos navegadores lo ejecutarían como HTML. Con "nosniff", el
            // navegador confía solo en el Content-Type declarado.
            httpResponse.setHeader("X-Content-Type-Options", "nosniff");

            // X-XSS-Protection: Activa el filtro XSS de navegadores legacy (IE, Chrome antiguo).
            // "1; mode=block" activa el filtro y bloquea la página si detecta XSS.
            // Los navegadores modernos ya no usan esta cabecera (usan CSP en su lugar),
            // pero se mantiene por compatibilidad con navegadores antiguos.
            httpResponse.setHeader("X-XSS-Protection", "1; mode=block");

            // Strict-Transport-Security (HSTS): Indica al navegador que SOLO
            // acceda a este dominio via HTTPS durante el tiempo especificado.
            // Una vez que el navegador ve esta cabecera, ignora cualquier intento
            // de conectar por HTTP (incluso si el usuario escribe http://).
            // max-age=31536000: 1 año
            // includeSubDomains: aplica también a todos los subdominios
            // preload: permite incluir el dominio en la lista HSTS precargada de navegadores
            if (enforceHttps || httpRequest.isSecure()) {
                httpResponse.setHeader("Strict-Transport-Security",
                    "max-age=31536000; includeSubDomains; preload");
            }

            // Content-Security-Policy (CSP): Define qué recursos puede cargar la página.
            // Es la defensa más potente contra ataques XSS.
            // default-src 'self': Por defecto, solo se permiten recursos del mismo origen.
            // script-src: Define de dónde pueden cargarse scripts JS.
            // style-src: Define de dónde pueden cargarse CSS.
            // font-src: Define de dónde pueden cargarse fuentes.
            // img-src: Define de dónde pueden cargarse imágenes.
            // connect-src: Define a qué URLs puede conectarse (fetch, XHR, WebSocket).
            // frame-ancestors 'self': Solo permite ser enmarcado por el mismo origen
            //   (equivalente a X-Frame-Options SAMEORIGIN, pero en CSP).
            // base-uri 'self': Restringe el elemento <base> al mismo origen.
            // form-action 'self': Los formularios solo pueden enviarse al mismo origen.
            httpResponse.setHeader("Content-Security-Policy",
                "default-src 'self'; " +
                "script-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net; " +
                "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; " +
                "font-src 'self' https://fonts.gstatic.com; " +
                "img-src 'self' data: https:; " +
                "connect-src 'self' https://api.miempresa.com; " +
                "frame-ancestors 'self'; " +
                "base-uri 'self'; " +
                "form-action 'self'");

            // Referrer-Policy: Controla qué información de URL se incluye en la
            // cabecera Referer cuando el usuario navega a otro sitio desde tu página.
            // "strict-origin-when-cross-origin": En peticiones cross-origin, solo
            // envía el origen (sin path/query). En same-origin, envía la URL completa.
            httpResponse.setHeader("Referrer-Policy",
                "strict-origin-when-cross-origin");

            // Permissions-Policy (antes Feature-Policy): Controla qué APIs del
            // navegador puede usar la página. Aquí se deshabilitan explícitamente
            // las más sensibles: geolocalización, micrófono, cámara, pagos, USB.
            httpResponse.setHeader("Permissions-Policy",
                "geolocation=(), " +
                "microphone=(), " +
                "camera=(), " +
                "payment=(), " +
                "usb=()");

            // Eliminar cabeceras que revelan información del servidor.
            // "Server: Apache-Coyote/1.1" o "X-Powered-By: JSP/2.3" le dicen
            // a un atacante qué servidor y versión estás usando, facilitando
            // la búsqueda de vulnerabilidades conocidas.
            httpResponse.setHeader("X-Powered-By", "");
            httpResponse.setHeader("Server", "");
        }

        // CRÍTICO: Pasar la petición al siguiente eslabón de la cadena de filtros.
        // Si no se llama a chain.doFilter(), la petición no llega al Servlet.
        chain.doFilter(request, response);
        
        // Aquí iría el post-procesamiento (ejecutado DESPUÉS de que el Servlet
        // ha escrito la respuesta). Para cabeceras de seguridad, todo va antes,
        // pero este es el lugar para, por ejemplo, medir el tiempo de respuesta.
    }

    @Override
    public void destroy() {
        // Liberar recursos si los hay (conexiones abiertas en init(), etc.)
    }
}
```

## Listener de Contexto

El `ServletContextListener` es el lugar correcto para inicializar y destruir los recursos compartidos de la aplicación. Se ejecuta una sola vez al arrancar y al parar.

```java
package com.miempresa.listener;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import javax.sql.DataSource;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.logging.Logger;

/**
 * Listener principal de la aplicación.
 * Se ejecuta al arrancar y parar el contexto de la aplicación.
 * Lugar correcto para:
 *   - Inicializar recursos compartidos (pools, caches, schedulers)
 *   - Verificar conectividad a servicios externos
 *   - Registrar métricas y monitorización
 *   - Limpiar recursos al apagar
 */
@WebListener
// @WebListener registra la clase como listener sin necesidad de declaración en web.xml.
// Tomcat la detecta automáticamente (si metadata-complete="false").
public class AppContextListener implements ServletContextListener {

    private static final Logger log =
        Logger.getLogger(AppContextListener.class.getName());

    // Variables de instancia: al contrario que en un Servlet, aquí SÍ es seguro
    // guardar estado porque solo existe UNA instancia de este listener y
    // contextInitialized/contextDestroyed se llaman secuencialmente, no en paralelo.
    private ScheduledExecutorService scheduler;
    private DataSource dataSource;

    /**
     * contextInitialized(): Se llama cuando Tomcat finaliza el despliegue
     * de la aplicación y ANTES de procesar cualquier petición HTTP.
     * 
     * Si este método lanza una excepción RuntimeException, Tomcat
     * cancela el despliegue de la aplicación y la marca como fallida.
     * Esto es correcto: si no podemos conectar a la BD, no tiene sentido
     * arrancar la aplicación.
     */
    @Override
    public void contextInitialized(ServletContextEvent event) {
        // ServletContext representa la aplicación completa. Permite:
        // - Leer context-param de web.xml
        // - Compartir objetos entre Servlets (setAttribute/getAttribute)
        // - Registrar logs
        ServletContext context = event.getServletContext();

        log.info("=== Iniciando aplicación: "
            + context.getServletContextName() + " ===");

        // PASO 1: Leer configuración de los context-param del web.xml
        String configPath = context.getInitParameter("app.config.path");
        log.info("Cargando configuración desde: " + configPath);

        // PASO 2: Obtener el DataSource JNDI y verificar conectividad.
        // "java:comp/env/" es el prefijo estándar JNDI para recursos del contexto.
        // El nombre completo "java:comp/env/jdbc/AppDB" corresponde a
        // <res-ref-name>jdbc/AppDB</res-ref-name> en web.xml.
        try {
            InitialContext ic = new InitialContext();
            dataSource = (DataSource) ic.lookup("java:comp/env/jdbc/AppDB");

            // Verificar que realmente podemos conectar a la BD.
            // Si la BD no está disponible al arrancar, mejor fallar rápido
            // (fail-fast) que descubrirlo cuando llegue la primera petición real.
            try (Connection conn = dataSource.getConnection()) {
                log.info("Conexión a BD verificada: "
                    + conn.getMetaData().getDatabaseProductName()
                    + " v" + conn.getMetaData().getDatabaseProductVersion());
            }
        } catch (NamingException e) {
            // NamingException: El DataSource JNDI no está configurado en Tomcat.
            // Fallo fatal: lanzar RuntimeException cancela el despliegue.
            log.severe("ERROR: DataSource JNDI no encontrado: " + e.getMessage());
            throw new RuntimeException("DataSource no disponible", e);
        } catch (SQLException e) {
            // SQLException: DataSource encontrado pero no puede conectar a la BD.
            log.severe("ERROR: No se puede conectar a la BD: " + e.getMessage());
            throw new RuntimeException("BD no disponible", e);
        }

        // PASO 3: Inicializar scheduler de tareas periódicas.
        // newScheduledThreadPool(4): Pool de 4 hilos para tareas programadas.
        // La lambda es el ThreadFactory: personaliza el nombre de los hilos
        // (ayuda en el diagnóstico de deadlocks y en thread dumps).
        // setDaemon(true): Hilos daemon se detienen automáticamente si la JVM
        // se apaga sin que hayan terminado sus tareas.
        scheduler = Executors.newScheduledThreadPool(4,
            r -> {
                Thread t = new Thread(r, "app-scheduler-thread");
                t.setDaemon(true);
                return t;
            }
        );

        // scheduleAtFixedRate(tarea, initialDelay, period, TimeUnit):
        // Ejecuta la tarea cada "period" unidades de tiempo, comenzando
        // "initialDelay" unidades después del arranque.
        // NOTA: Si la tarea tarda más que el period, la siguiente ejecución
        // se retrasa (no se acumulan ejecuciones solapadas).
        scheduler.scheduleAtFixedRate(
            this::cleanupCache, 5, 5, TimeUnit.MINUTES
        );

        scheduler.scheduleAtFixedRate(
            this::heartbeat, 30, 30, TimeUnit.SECONDS
        );

        // PASO 4: Publicar recursos en el ServletContext para que sean
        // accesibles desde cualquier Servlet de la aplicación.
        // Equivale a variables globales de la aplicación, pero accesibles
        // de forma segura a través del objeto context compartido.
        context.setAttribute("dataSource", dataSource);
        context.setAttribute("appVersion",
            context.getInitParameter("app.version"));
        context.setAttribute("scheduler", scheduler);

        log.info("=== Aplicación iniciada correctamente ===");
    }

    /**
     * contextDestroyed(): Se llama cuando Tomcat va a parar la aplicación.
     * SIEMPRE liberar aquí todos los recursos creados en contextInitialized().
     * 
     * El orden importa: parar primero lo que depende de otros recursos
     * (scheduler antes que dataSource, porque el heartbeat usa dataSource).
     */
    @Override
    public void contextDestroyed(ServletContextEvent event) {
        log.info("=== Deteniendo aplicación ===");

        // shutdown(): Indica al scheduler que no acepte nuevas tareas,
        //             pero espera a que las tareas en curso terminen.
        // awaitTermination(): Espera hasta 30 segundos a que terminen.
        // shutdownNow(): Fuerza la parada si no terminan en 30 segundos,
        //               interrumpiendo los hilos en ejecución.
        if (scheduler != null && !scheduler.isShutdown()) {
            scheduler.shutdown();
            try {
                if (!scheduler.awaitTermination(30, TimeUnit.SECONDS)) {
                    scheduler.shutdownNow();
                    log.warning("Scheduler forzado a parar tras timeout");
                }
            } catch (InterruptedException e) {
                scheduler.shutdownNow();
                // Restablecer el flag de interrupción del hilo.
                // Importante en entornos multihilo para no suprimir
                // la señal de interrupción.
                Thread.currentThread().interrupt();
            }
        }

        log.info("=== Aplicación detenida correctamente ===");
    }

    private void cleanupCache() {
        log.fine("Ejecutando limpieza de caché...");
        // Implementar limpieza de caché
    }

    private void heartbeat() {
        // Verificar periódicamente que la conexión a la BD sigue viva.
        // isValid(5): Envía una consulta de prueba con timeout de 5 segundos.
        // Útil para detectar desconexiones silenciosas (por ejemplo, si el
        // servidor de BD se reinicia sin cerrar las conexiones del pool).
        try (Connection conn = dataSource.getConnection()) {
            conn.isValid(5);
        } catch (SQLException e) {
            log.warning("Heartbeat BD fallido: " + e.getMessage());
        }
    }
}
```

# 5. Despliegue de Aplicaciones: Métodos y Estrategias

## Métodos de despliegue

Hay tres formas principales de desplegar una aplicación en Tomcat:

```bash
# ======================================================
# MÉTODO 1: Copia manual del WAR (más simple)
# ======================================================
# Simplemente copia el WAR al directorio webapps/ de Tomcat.
# Si autoDeploy="true" en server.xml (configuración por defecto),
# Tomcat detecta el nuevo archivo en segundos y lo despliega automáticamente.
# Si autoDeploy="false" (recomendado en producción para mayor control):
# requiere reinicio o usar el Manager API (método 2).
cp myapp-2.3.1.war $CATALINA_BASE/webapps/myapp.war

# ======================================================
# MÉTODO 2: Manager API REST (sin reinicio de Tomcat)
# ======================================================
# El Tomcat Manager es una aplicación web incluida con Tomcat que expone
# una API REST para gestionar despliegues. Permite desplegar, parar,
# recargar y eliminar aplicaciones SIN reiniciar Tomcat.
# 
# Requiere configurar en conf/tomcat-users.xml un usuario con rol "manager-script":
# <user username="deployer" password="password" roles="manager-script"/>

# Desplegar un WAR nuevo (o actualizar uno existente con update=true)
# -T myapp-2.3.1.war: Sube el archivo WAR
# path=/myapp: La aplicación estará disponible en http://servidor/myapp
# update=true: Si ya existe una versión, la reemplaza sin error
curl -u deployer:password \
  -T myapp-2.3.1.war \
  "http://localhost:8080/manager/text/deploy?path=/myapp&update=true"

# Listar todas las aplicaciones desplegadas y su estado (running/stopped)
curl -u deployer:password \
  http://localhost:8080/manager/text/list

# Recargar una aplicación: reinicia el ClassLoader y recarga las clases.
# Útil si has modificado clases en WEB-INF/classes/ sin cambiar el WAR.
# NO recarga el WAR desde disco.
curl -u deployer:password \
  "http://localhost:8080/manager/text/reload?path=/myapp"

# Iniciar una aplicación que está parada
curl -u deployer:password \
  "http://localhost:8080/manager/text/start?path=/myapp"

# Parar una aplicación (deja de aceptar peticiones pero permanece en memoria)
curl -u deployer:password \
  "http://localhost:8080/manager/text/stop?path=/myapp"

# Desplegar desde una URL remota (útil en pipelines CI/CD)
curl -u deployer:password \
  "http://localhost:8080/manager/text/deploy?path=/myapp&war=http://repo.miempresa.com/myapp-2.3.1.war"

# Undeploy: eliminar completamente la aplicación de Tomcat
# (borra también el directorio expandido en webapps/)
curl -u deployer:password \
  "http://localhost:8080/manager/text/undeploy?path=/myapp"

# Ver información de sesiones activas de una aplicación
curl -u deployer:password \
  "http://localhost:8080/manager/text/sessions?path=/myapp"

# Expirar forzosamente sesiones que llevan más de 60 minutos inactivas.
# Útil antes de un redeploy para minimizar sesiones perdidas.
curl -u deployer:password \
  "http://localhost:8080/manager/text/expire?path=/myapp&idle=60"

# ======================================================
# MÉTODO 3: Tarea Ant (integración CI/CD legacy)
# ======================================================
# Para proyectos que usan Apache Ant como sistema de build.
# Añadir en build.xml:
# <taskdef name="deploy" classname="org.apache.catalina.ant.DeployTask"
#          classpath="${catalina.home}/lib/catalina-ant.jar"/>
# <deploy url="http://localhost:8080/manager/text"
#         username="deployer" password="password"
#         path="/myapp" war="file:${dist}/myapp.war" update="true"/>
```

## Despliegue Zero-Downtime con Context Descriptor

El *zero-downtime deployment* (despliegue sin tiempo de inactividad) es una estrategia que permite actualizar una aplicación sin interrumpir el servicio a los usuarios. La estrategia descrita aquí despliega la nueva versión en paralelo, verifica que funciona correctamente, y solo entonces elimina la versión antigua.

**Flujo de la estrategia:**
1. Desplegar nueva versión en una ruta temporal (`/myapp-new`).
2. Esperar a que el health check confirme que está operativa.
3. Expirar sesiones activas de la versión antigua.
4. Eliminar la versión antigua.
5. Desplegar la nueva versión en la ruta definitiva (`/myapp`).
6. Eliminar la ruta temporal.

> **Limitación:** Esta estrategia minimiza el downtime pero no lo elimina completamente. Durante el paso 4-5 hay un breve período en que `/myapp` no existe. Para zero-downtime real se necesita un balanceador de carga que dirija tráfico entre múltiples instancias de Tomcat.

```bash
#!/bin/bash
# deploy-zero-downtime.sh
# Estrategia: desplegar nueva versión en path temporal,
# verificar health, y redireccionar el tráfico.

# set -euo pipefail: Hace el script robusto:
#   -e: Sale si cualquier comando falla (exit code != 0)
#   -u: Error si se usa una variable no definida
#   -o pipefail: Un pipe falla si cualquier comando en él falla
set -euo pipefail

APP_NAME="myapp"
NEW_WAR="myapp-2.3.1.war"
TOMCAT_MANAGER="http://localhost:8080/manager/text"
MANAGER_USER="deployer"
MANAGER_PASS="password"
HEALTH_URL="http://localhost:8080/${APP_NAME}/health"

echo "=== Inicio del despliegue zero-downtime ==="

# PASO 1: Desplegar nueva versión en path temporal (/myapp-new).
# Mientras se despliega aquí, /myapp sigue sirviendo tráfico.
echo "Desplegando nueva versión en /myapp-new..."
curl -s -u "$MANAGER_USER:$MANAGER_PASS" \
  -T "$NEW_WAR" \
  "$TOMCAT_MANAGER/deploy?path=/myapp-new&update=true"

# PASO 2: Esperar a que la nueva versión esté lista y saludable.
# Se hace polling al health check hasta que responde correctamente.
echo "Esperando disponibilidad..."
MAX_RETRIES=30   # 30 reintentos × 2 segundos = 60 segundos máximo
RETRY=0
until curl -sf "$HEALTH_URL" > /dev/null 2>&1; do
    RETRY=$((RETRY+1))
    if [ $RETRY -ge $MAX_RETRIES ]; then
        echo "ERROR: La nueva versión no está disponible tras $MAX_RETRIES intentos"
        # Rollback: eliminar la versión fallida
        curl -s -u "$MANAGER_USER:$MANAGER_PASS" \
          "$TOMCAT_MANAGER/undeploy?path=/myapp-new"
        exit 1
    fi
    echo "Intento $RETRY/$MAX_RETRIES..."
    sleep 2
done

echo "Nueva versión disponible en /myapp-new"

# PASO 3: Expirar sesiones activas de la versión anterior.
# idle=0 expira TODAS las sesiones independientemente de su actividad.
# En producción se puede usar un valor mayor (p.ej. idle=5) para dar
# algo de tiempo a los usuarios activos.
echo "Expirando sesiones antiguas..."
curl -s -u "$MANAGER_USER:$MANAGER_PASS" \
  "$TOMCAT_MANAGER/expire?path=/myapp&idle=0"

# PASO 4: Eliminar la versión anterior del path definitivo.
# Breve ventana de interrupción aquí.
echo "Parando versión anterior..."
curl -s -u "$MANAGER_USER:$MANAGER_PASS" \
  "$TOMCAT_MANAGER/undeploy?path=/myapp"

# PASO 5: Desplegar la nueva versión en el path definitivo.
echo "Desplegando en path definitivo /myapp..."
curl -s -u "$MANAGER_USER:$MANAGER_PASS" \
  -T "$NEW_WAR" \
  "$TOMCAT_MANAGER/deploy?path=/myapp&update=true"

# PASO 6: Limpiar la ruta temporal.
curl -s -u "$MANAGER_USER:$MANAGER_PASS" \
  "$TOMCAT_MANAGER/undeploy?path=/myapp-new"

echo "=== Despliegue completado ==="
```

# 6. El DefaultServlet de Tomcat

Tomcat incluye un Servlet especial llamado `DefaultServlet` que se encarga de servir los archivos estáticos (HTML, CSS, JS, imágenes, etc.) directamente desde el sistema de archivos. Está configurado en el `web.xml` **global** de Tomcat (`$CATALINA_HOME/conf/web.xml`), no en el `web.xml` de tu aplicación.

¿Cómo funciona? El `DefaultServlet` está mapeado a `"/"` en la configuración global. Cuando una petición llega a una URL que no coincide con ningún Servlet de tu aplicación, el mapping `"/"` de tu `AppDispatcherServlet` la captura. Pero si en el `web.xml` global de Tomcat el `DefaultServlet` está mapeado a `"/"` y no hay un Servlet de aplicación que lo sobreescriba, Tomcat busca el archivo en el directorio de la aplicación y lo sirve directamente.

```xml
<!-- Configuración del DefaultServlet en conf/web.xml global de Tomcat -->
<servlet>
    <servlet-name>default</servlet-name>
    <servlet-class>org.apache.catalina.servlets.DefaultServlet</servlet-class>
    <init-param>
        <!--
          listings: Si es true, cuando se accede a un directorio sin un
          archivo índice, muestra una lista de todos los archivos.
          NUNCA debe ser true en producción: expone la estructura del
          sistema de archivos de la aplicación a cualquier usuario.
        -->
        <param-name>listings</param-name>
        <param-value>false</param-value>
    </init-param>
    <init-param>
        <!-- Tamaño del buffer de lectura de archivos en KB (2 MB) -->
        <param-name>input</param-name>
        <param-value>2048</param-value>
    </init-param>
    <init-param>
        <!-- Tamaño del buffer de escritura de la respuesta en KB (2 MB) -->
        <param-name>output</param-name>
        <param-value>2048</param-value>
    </init-param>
    <init-param>
        <!--
          useAcceptRanges: Habilita soporte para peticiones HTTP Range.
          Permite que los clientes descarguen archivos grandes en partes,
          o que reanuden descargas interrumpidas. Importante para servir
          archivos multimedia grandes.
        -->
        <param-name>useAcceptRanges</param-name>
        <param-value>true</param-value>
    </init-param>
    <init-param>
        <!--
          cacheTtl: Tiempo en milisegundos que Tomcat cachea la información
          de metadatos de los archivos (tamaño, fecha de modificación).
          0 = sin caché (comprueba el filesystem en cada petición).
          5000 = 5 segundos (equilibrio entre rendimiento y frescura).
          En producción con archivos que raramente cambian, puede subirse.
        -->
        <param-name>cacheTtl</param-name>
        <param-value>5000</param-value>
    </init-param>
    <init-param>
        <!-- Tamaño máximo del caché de recursos estáticos en KB (100 MB).
             Tomcat guarda en memoria los recursos accedidos frecuentemente
             para evitar acceso al filesystem en cada petición. -->
        <param-name>cacheMaxSize</param-name>
        <param-value>102400</param-value>
    </init-param>
    <init-param>
        <!-- Tamaño máximo de un objeto individual en la caché en KB (512 KB).
             Archivos más grandes no se cachean en memoria. -->
        <param-name>cacheObjectMaxSize</param-name>
        <param-value>512</param-value>
    </init-param>
    <init-param>
        <!-- Servir recursos con compresión gzip cuando el cliente lo soporta.
             Reduce significativamente el ancho de banda para texto, CSS y JS. -->
        <param-name>gzip</param-name>
        <param-value>true</param-value>
    </init-param>
    <load-on-startup>1</load-on-startup>
</servlet>
```

# 7. El JspServlet y Configuración de Jasper

**¿Qué son las JSP?**
JSP (JavaServer Pages) son archivos de texto con extensión `.jsp` que mezclan HTML estático con código Java dinámico. Cuando un cliente solicita una JSP, Tomcat (mediante su motor Jasper) la compila a un Servlet Java la primera vez, y desde entonces ejecuta el Servlet compilado. Esta compilación solo ocurre una vez (o cuando el archivo JSP cambia).

El `JspServlet` (componente de Jasper) gestiona este proceso. Como el `DefaultServlet`, está configurado en el `web.xml` global de Tomcat.

```xml
<!-- Configuración del JspServlet en conf/web.xml global de Tomcat -->
<servlet>
    <servlet-name>jsp</servlet-name>
    <servlet-class>org.apache.jasper.servlet.JspServlet</servlet-class>
    <init-param>
        <!--
          fork: Si es true, la compilación de JSPs se hace en un proceso JVM
          separado (usando un fork del proceso Tomcat). Permite usar una JDK
          diferente para compilar, pero añade overhead significativo.
          En la práctica, siempre debe ser false.
        -->
        <param-name>fork</param-name>
        <param-value>false</param-value>
    </init-param>
    <init-param>
        <!--
          development: Si es true, Jasper comprueba si la JSP ha cambiado
          EN CADA PETICIÓN y la recompila si es necesario. Muy útil en
          desarrollo (los cambios se ven inmediatamente sin reiniciar).
          
          SIEMPRE debe ser false en producción: comprueba el filesystem
          en cada petición, lo que degrada gravemente el rendimiento.
          En producción, las JSPs se precompilan durante el build.
        -->
        <param-name>development</param-name>
        <param-value>false</param-value>
    </init-param>
    <init-param>
        <!--
          enablePooling: Si es true, Jasper reutiliza instancias de los
          evaluadores de expresiones EL (Expression Language) mediante
          un pool de objetos, en lugar de crearlos en cada evaluación.
          Reduce la presión del GC en aplicaciones con muchas expresiones EL.
        -->
        <param-name>enablePooling</param-name>
        <param-value>true</param-value>
    </init-param>
    <init-param>
        <!--
          genStrAsCharArray: Si es true, genera el código Java de las JSPs
          usando arrays de char en lugar de String para las cadenas estáticas.
          Puede mejorar el rendimiento en algunos casos, pero hace el código
          generado menos legible. Solo útil para debugging avanzado.
        -->
        <param-name>genStrAsCharArray</param-name>
        <param-value>false</param-value>
    </init-param>
    <init-param>
        <!--
          mappedFile: Si es true, el código Java generado incluye referencias
          a las líneas del archivo JSP original. Cuando ocurre una excepción,
          el stack trace muestra el número de línea en la JSP original en lugar
          del número de línea en el Java generado. Muy útil para debugging.
        -->
        <param-name>mappedFile</param-name>
        <param-value>true</param-value>
    </init-param>
    <init-param>
        <!--
          compilerTargetVM y compilerSourceVM: Versión de Java para la que
          se compilan las JSPs. Deben coincidir con la JVM que ejecuta Tomcat.
          Si ejecutas Java 17, estas deben ser "17". Si usas Java 21, "21".
          Un mismatch puede generar errores de compilación o UnsupportedClassVersionError.
        -->
        <param-name>compilerTargetVM</param-name>
        <param-value>17</param-value>
    </init-param>
    <init-param>
        <param-name>compilerSourceVM</param-name>
        <param-value>17</param-value>
    </init-param>
    <init-param>
        <!--
          trimSpaces: Si es true, elimina espacios en blanco innecesarios
          de la salida HTML generada por las JSPs. Reduce el tamaño de la
          respuesta enviada al cliente (ahorra ancho de banda).
        -->
        <param-name>trimSpaces</param-name>
        <param-value>true</param-value>
    </init-param>
    <load-on-startup>3</load-on-startup>
</servlet>
```

# 8. metadata-complete y Orden de Procesamiento

## El impacto de metadata-complete en el arranque

Cuando Tomcat despliega una aplicación, necesita descubrir todos los Servlets, Filtros y Listeners que la componen. Si `metadata-complete="false"` (el valor por defecto), Tomcat realiza un **escaneo completo** de todos los JARs en `WEB-INF/lib/` buscando:
- Anotaciones `@WebServlet`, `@WebFilter`, `@WebListener` en las clases.
- Archivos `web-fragment.xml` dentro de los JARs (descriptores de despliegue parciales que los frameworks incluyen en sus JARs).

Este escaneo puede ser muy lento cuando hay muchos JARs (50-100+ JARs es habitual en aplicaciones empresariales con muchas dependencias). Una aplicación que tarda 30 segundos en arrancar puede reducirse a 5-10 segundos desactivando el escaneo.

```xml
<!--
  metadata-complete="false" (por defecto):
  Tomcat escanea TODOS los JARs de WEB-INF/lib/ buscando:
    - Anotaciones @WebServlet, @WebFilter, @WebListener
    - Archivos web-fragment.xml en los JARs
  Esto puede ralentizar significativamente el arranque con muchos JARs.

  metadata-complete="true":
  Tomcat ignora anotaciones y web-fragment.xml.
  SOLO usa la configuración de web.xml.
  MUCHO más rápido en arranque, pero requiere configurar todo en web.xml.
  
  ADVERTENCIA: Si usas frameworks que dependen de web-fragment.xml
  (como algunos frameworks de seguridad o persistencia), deshabilitar
  el escaneo puede romper su funcionalidad. Verifica en la documentación
  del framework si es seguro usar metadata-complete="true".
-->
<web-app ... metadata-complete="true">
```

## Optimización del escaneo de JARs

Si no puedes usar `metadata-complete="true"` (porque algunos JARs necesitan sus `web-fragment.xml`), puedes configurar Tomcat para escanear solo los JARs necesarios, ignorando el resto:

```xml
<!-- conf/context.xml — Configuración global -->
<Context>
  <!--
    JarScanner: Controla qué se escanea durante el despliegue.
    Desactivar todos los escaneos por defecto y habilitar solo lo necesario
    reduce drásticamente el tiempo de arranque.
  -->
  <JarScanner scanBootstrapClassPath="false"
              scanAllDirectories="false"
              scanAllFiles="false"
              scanClassPath="false">

    <!--
      JarScanFilter: Define qué JARs escanear para TLDs (Tag Libraries)
      y web-fragments.
      
      defaultTldScan="false": No escanear ningún JAR buscando TLDs por defecto.
      defaultPluggabilityScan="false": No escanear ningún JAR buscando web-fragment.xml.
      
      tldScan: Lista explícita de JARs que SÍ deben escanearse buscando TLDs.
      pluggabilityScan: Lista explícita de JARs que SÍ deben escanearse
                        buscando web-fragment.xml.
      
      Esto permite escanear exactamente los JARs que lo necesitan,
      ignorando el resto (como los drivers de BD, librerías de utilidades, etc.).
    -->
    <JarScanFilter
      defaultTldScan="false"
      defaultPluggabilityScan="false"
      tldScan="taglib-*.jar,jsp-api.jar"
      pluggabilityScan="myapp-fragments.jar">
    </JarScanFilter>

  </JarScanner>
</Context>
```

# 9. Diferencias de web.xml y APIs entre Versiones de Tomcat

Esta tabla resume las diferencias más relevantes entre versiones para tomar decisiones de actualización o compatibilidad:

| Característica                         | Tomcat 8.0/8.5 | Tomcat 9.0 | Tomcat 10.x | Tomcat 11.0 |
|----------------------------------------|----------------|------------|-------------|-------------|
| Namespace `javax.servlet.*`            | ✅             | ✅          | ❌           | ❌           |
| Namespace `jakarta.servlet.*`          | ❌             | ❌          | ✅           | ✅           |
| Servlet spec versión máxima            | 3.1            | 4.0        | 6.0         | 6.1         |
| `@WebServlet` annotation               | ✅             | ✅          | ✅           | ✅           |
| `AsyncContext` / async processing      | ✅             | ✅          | ✅           | ✅           |
| `PushBuilder` (HTTP/2 Server Push)     | ❌             | ✅          | ✅           | ✅           |
| `multipart-config` en web.xml          | ✅             | ✅          | ✅           | ✅           |
| `<cookie-config><same-site>`           | ❌             | ❌          | ✅           | ✅           |
| Non-blocking I/O (ReadListener)        | ✅             | ✅          | ✅           | ✅           |
| `web-fragment.xml` en JARs             | ✅             | ✅          | ✅           | ✅           |
| `HttpServlet.doTrace()` por defecto    | Habilitado     | Habilitado | Habilitado  | Deshabilitado|
| `SameSite` en cookie-config            | ❌             | ❌          | ✅           | ✅           |

**Notas importantes:**
- **`SameSite` en cookies:** El atributo `SameSite` de las cookies controla si se envían en peticiones cross-site. `Strict` solo las envía en peticiones del mismo sitio; `Lax` las envía en navegaciones normales pero no en peticiones iniciadas por terceros; `None` siempre las envía (requiere `Secure=true`). Su ausencia no declara `SameSite`, y los navegadores modernos aplican `Lax` por defecto.
- **`PushBuilder` (HTTP/2 Server Push):** Permite que el servidor envíe recursos (CSS, JS) al cliente antes de que los solicite, anticipando que los necesitará. Mejora el rendimiento de la primera carga. Requiere HTTP/2.
- **`doTrace()` deshabilitado en Tomcat 11:** El método HTTP TRACE puede usarse para ataques XST (Cross-Site Tracing). Deshabilitar `doTrace()` por defecto es una mejora de seguridad.

# 10. Herramienta de Migración Jakarta EE (Tomcat 9 → 10+)

El cambio de `javax.*` a `jakarta.*` afecta a **todo el código fuente** de la aplicación: todos los imports de clases Servlet, Filter, Listener, etc. Hacer este cambio manualmente en un proyecto grande es propenso a errores y muy tedioso.

Apache proporciona la **Jakarta EE Migration Tool**: una herramienta oficial que automatiza este proceso. Escanea el WAR (o directorio de fuentes) y renombra automáticamente todos los paquetes `javax.*` a `jakarta.*` en el bytecode compilado (archivos `.class`) y en los descriptores XML.

> **Importante:** La herramienta opera sobre el **bytecode compilado** (los `.class` dentro del WAR), no sobre el código fuente `.java`. El WAR resultante funciona en Tomcat 10+, pero si necesitas el código fuente actualizado, debes hacer los cambios de imports en el código Java también.

```bash
# Descargar la Migration Tool
wget https://github.com/apache/tomcat-jakartaee-migration/releases/download/1.0.6/jakartaee-migration-1.0.6-shaded.jar

# Migrar un WAR completo (javax.* → jakarta.*)
# Primer argumento: WAR original (entrada)
# Segundo argumento: WAR migrado (salida, se crea nuevo)
java -jar jakartaee-migration-1.0.6-shaded.jar \
  myapp-javax.war \
  myapp-jakarta.war

# Migrar un directorio de clases (útil en pipelines de build)
java -jar jakartaee-migration-1.0.6-shaded.jar \
  src/main/webapp/ \
  src/main/webapp-jakarta/

# Opciones avanzadas
java -jar jakartaee-migration-1.0.6-shaded.jar \
  --profile EE  \    # EE: migra todas las APIs Jakarta EE
                     # WEB: solo migra las APIs web (Servlet, JSP, EL, WebSocket)
  --verbose \        # Muestra en detalle qué archivos y qué cambios se hacen
  myapp.war \
  myapp-jakarta.war
```

## Integración en el pipeline de build con Maven

En lugar de ejecutar la herramienta manualmente, puedes integrarla en tu proceso de build Maven para que se ejecute automáticamente en cada compilación:

```xml
<!-- Plugin Maven para migración automática en el build -->
<plugin>
    <groupId>org.apache.tomcat</groupId>
    <artifactId>jakartaee-migration-maven-plugin</artifactId>
    <version>1.0.6</version>
    <executions>
        <execution>
            <id>migrate-to-jakarta</id>
            <goals>
                <!-- La fase "migrate" se ejecuta después de que Maven ha
                     generado el WAR con el namespace javax.* -->
                <goal>migrate</goal>
            </goals>
            <configuration>
                <!-- WAR original generado por Maven -->
                <source>${project.build.directory}/${project.build.finalName}.war</source>
                <!-- WAR migrado generado por el plugin -->
                <destination>${project.build.directory}/${project.build.finalName}-jakarta.war</destination>
                <!-- Perfil de migración: EE para migración completa -->
                <profile>EE</profile>
            </configuration>
        </execution>
    </executions>
</plugin>
```

Con esta configuración, cada `mvn package` genera dos WARs: el original (`-javax`) y el migrado (`-jakarta`). Esto permite mantener un único repositorio de código que produce WARs compatibles con Tomcat 9 y Tomcat 10+ simultáneamente, útil durante procesos de migración graduales.

# 11. Puntos Clave

- La estructura WAR es estándar y obligatoria: `WEB-INF/` es inaccesible desde HTTP, protegiendo clases, librerías y configuración. Todo lo que esté fuera de `WEB-INF/` y `META-INF/` es potencialmente accesible por el navegador.

- El namespace del descriptor `web.xml` cambia en **Tomcat 10+**: `https://jakarta.ee/xml/ns/jakartaee` reemplaza a `http://xmlns.jcp.org/xml/ns/javaee`. Este cambio va acompañado del renombrado de todos los paquetes `javax.servlet.*` a `jakarta.servlet.*` en el código Java.

- El **orden de los `<filter-mapping>`** en `web.xml` determina el orden de ejecución de la cadena de filtros. Es secuencial y predecible. El orden de los `<filter>` (declaraciones) no importa.

- `load-on-startup` con valor positivo inicializa Servlets **al arrancar Tomcat**, en orden ascendente. Valores negativos o ausentes → inicialización lazy en la primera petición. En producción, los Servlets críticos siempre deben tener `load-on-startup` positivo para detectar errores de inicialización temprano.

- `metadata-complete="true"` deshabilita el escaneo de anotaciones y `web-fragment.xml`, **reduciendo significativamente** el tiempo de arranque en aplicaciones con muchos JARs. Solo es seguro si todos los componentes están declarados explícitamente en `web.xml`.

- El **DefaultServlet** no debe tener `listings=true` nunca en producción: expone el sistema de archivos de la aplicación a cualquier usuario.

- El **JspServlet** debe tener `development=false` en producción para evitar recompilaciones en cada petición, que degradan el rendimiento.

- Para migrar de Tomcat 9 a 10+, usar la **Jakarta EE Migration Tool** oficial. El cambio de namespace afecta a todas las clases que implementan interfaces Servlet, Filter o Listener, y a los descriptores XML.

- La **gestión de sesiones** debe configurarse con `HttpOnly=true`, `Secure=true` y `tracking-mode=COOKIE` siempre en producción. El seguimiento por URL (`jsessionid` en la URL) es un riesgo de seguridad.

- El **Manager API REST** permite despliegues sin reinicio de Tomcat, habilitando estrategias de despliegue continuo en entornos de producción.

- El procesamiento **asíncrono** (`AsyncContext`) libera hilos del pool de Tomcat durante operaciones I/O-bound, permitiendo gestionar más peticiones concurrentes con el mismo número de hilos. Requiere `asyncSupported=true` en todos los Filtros y Servlets de la cadena.