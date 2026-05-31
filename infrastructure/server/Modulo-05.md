## Módulo 05: Gestión de Aplicaciones Web y web.xml

## 5.1 Estructura de una Aplicación Web Java EE / Jakarta EE

Una aplicación web desplegada en Tomcat sigue la especificación **WAR (Web Application Archive)**. Su estructura interna es estándar y Tomcat la interpreta de forma determinista.

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

> ⚠️ **WEB-INF es inaccesible desde el navegador.** Cualquier petición HTTP a `/WEB-INF/` retorna 404. Esto es una garantía de seguridad de la especificación Servlet. Los archivos de configuración, clases y librerías son seguros dentro de este directorio.

---

## 5.2 El Descriptor de Despliegue web.xml

El `web.xml` es el **descriptor de despliegue** de la aplicación. Define Servlets, Filtros, Listeners, mappings URL, seguridad, sesiones y configuración de recursos.

### Versiones del descriptor por especificación

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

---

## 5.3 web.xml Completo de Referencia

### 5.3.1 Para Tomcat 8.x y 9.x (namespace javax.*)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
                             http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0"
         metadata-complete="false">

  <!-- ============================================================ -->
  <!-- SECCIÓN 1: INFORMACIÓN GENERAL DE LA APLICACIÓN             -->
  <!-- ============================================================ -->

  <display-name>Mi Aplicación Empresarial</display-name>
  <description>Aplicación de gestión empresarial v2.3.1</description>

  <!-- Parámetros de inicialización del contexto -->
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
    Los Listeners se inicializan ANTES que los Filtros y Servlets.
    Orden de inicialización:
    1. ServletContextListener.contextInitialized()
    2. HttpSessionListener (cuando se crean sesiones)
    3. ServletRequestListener (por cada petición)
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
    Los Filtros se ejecutan en el ORDEN EN QUE SE MAPEAN en web.xml.
    La declaración (<filter>) y el mapping (<filter-mapping>)
    son elementos separados.
  -->

  <!-- Filtro 1: Encoding UTF-8 (debe ser el primero) -->
  <filter>
    <filter-name>encodingFilter</filter-name>
    <filter-class>com.miempresa.filter.EncodingFilter</filter-class>
    <init-param>
      <param-name>encoding</param-name>
      <param-value>UTF-8</param-value>
    </init-param>
    <init-param>
      <param-name>forceEncoding</param-name>
      <param-value>true</param-value>
    </init-param>
  </filter>

  <!-- Filtro 2: Autenticación / JWT -->
  <filter>
    <filter-name>authFilter</filter-name>
    <filter-class>com.miempresa.filter.JwtAuthFilter</filter-class>
    <init-param>
      <param-name>excludedPaths</param-name>
      <param-value>/api/auth/login,/api/auth/register,/health</param-value>
    </init-param>
    <init-param>
      <param-name>tokenHeader</param-name>
      <param-value>Authorization</param-value>
    </init-param>
  </filter>

  <!-- Filtro 3: Cabeceras de seguridad HTTP -->
  <filter>
    <filter-name>securityHeadersFilter</filter-name>
    <filter-class>com.miempresa.filter.SecurityHeadersFilter</filter-class>
  </filter>

  <!-- Filtro 4: CORS -->
  <filter>
    <filter-name>corsFilter</filter-name>
    <filter-class>com.miempresa.filter.CorsFilter</filter-class>
    <init-param>
      <param-name>allowedOrigins</param-name>
      <param-value>https://app.miempresa.com,https://admin.miempresa.com</param-value>
    </init-param>
    <init-param>
      <param-name>allowedMethods</param-name>
      <param-value>GET,POST,PUT,DELETE,OPTIONS,PATCH</param-value>
    </init-param>
    <init-param>
      <param-name>allowedHeaders</param-name>
      <param-value>Authorization,Content-Type,X-Requested-With,Accept</param-value>
    </init-param>
    <init-param>
      <param-name>allowCredentials</param-name>
      <param-value>true</param-value>
    </init-param>
    <init-param>
      <param-name>maxAge</param-name>
      <param-value>3600</param-value>
    </init-param>
  </filter>

  <!-- Filtro 5: Logging / MDC de Slf4j -->
  <filter>
    <filter-name>mdcFilter</filter-name>
    <filter-class>com.miempresa.filter.MdcLoggingFilter</filter-class>
  </filter>

  <!-- Filtro 6: Rate Limiting -->
  <filter>
    <filter-name>rateLimitFilter</filter-name>
    <filter-class>com.miempresa.filter.RateLimitFilter</filter-class>
    <init-param>
      <param-name>requestsPerMinute</param-name>
      <param-value>1000</param-value>
    </init-param>
  </filter>

  <!-- Mappings de Filtros — El orden aquí determina el orden de ejecución -->
  <filter-mapping>
    <filter-name>encodingFilter</filter-name>
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

  <!-- Filtro aplicado a Dispatcher types específicos -->
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

  <!-- Servlet 1: Dispatcher principal (patrón Front Controller) -->
  <servlet>
    <servlet-name>appServlet</servlet-name>
    <servlet-class>com.miempresa.servlet.AppDispatcherServlet</servlet-class>
    <init-param>
      <param-name>configLocation</param-name>
      <param-value>/WEB-INF/app-config.xml</param-value>
    </init-param>
    <init-param>
      <param-name>throwExceptionIfNoHandlerFound</param-name>
      <param-value>true</param-value>
    </init-param>
    <!--
      load-on-startup: orden de inicialización al arrancar Tomcat.
      Valores positivos: inicializado en orden ascendente al arrancar.
      -1 o negativo: inicializado en la primera petición (lazy).
      0: implementación decide (normalmente al arrancar).
    -->
    <load-on-startup>1</load-on-startup>
    <enabled>true</enabled>
    <async-supported>true</async-supported>
  </servlet>

  <!-- Servlet 2: API REST -->
  <servlet>
    <servlet-name>apiServlet</servlet-name>
    <servlet-class>com.miempresa.servlet.ApiServlet</servlet-class>
    <load-on-startup>2</load-on-startup>
    <async-supported>true</async-supported>
    <multipart-config>
      <location>/tmp/uploads</location>
      <max-file-size>52428800</max-file-size>       <!-- 50 MB -->
      <max-request-size>104857600</max-request-size> <!-- 100 MB -->
      <file-size-threshold>1048576</file-size-threshold> <!-- 1 MB -->
    </multipart-config>
  </servlet>

  <!-- Servlet 3: Health Check -->
  <servlet>
    <servlet-name>healthServlet</servlet-name>
    <servlet-class>com.miempresa.servlet.HealthCheckServlet</servlet-class>
    <load-on-startup>1</load-on-startup>
    <async-supported>false</async-supported>
  </servlet>

  <!-- Servlet 4: WebSocket Endpoint -->
  <servlet>
    <servlet-name>websocketServlet</servlet-name>
    <servlet-class>com.miempresa.websocket.NotificationEndpoint</servlet-class>
    <load-on-startup>3</load-on-startup>
    <async-supported>true</async-supported>
  </servlet>

  <!-- Mappings de Servlets -->
  <servlet-mapping>
    <servlet-name>appServlet</servlet-name>
    <url-pattern>/</url-pattern>
  </servlet-mapping>

  <servlet-mapping>
    <servlet-name>apiServlet</servlet-name>
    <url-pattern>/api/*</url-pattern>
  </servlet-mapping>

  <servlet-mapping>
    <servlet-name>healthServlet</servlet-name>
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

  <session-config>
    <!-- Timeout en minutos. 0 = nunca expira (no recomendado) -->
    <session-timeout>30</session-timeout>

    <cookie-config>
      <!-- Nombre de la cookie de sesión -->
      <name>MYAPP_SESSIONID</name>
      <!-- Dominio de la cookie -->
      <domain>miempresa.com</domain>
      <!-- Path de la cookie -->
      <path>/</path>
      <!-- HttpOnly: previene acceso desde JavaScript (XSS) -->
      <http-only>true</http-only>
      <!-- Secure: solo enviada sobre HTTPS -->
      <secure>true</secure>
      <!-- Max age en segundos. -1 = cookie de sesión (se elimina al cerrar browser) -->
      <max-age>-1</max-age>
    </cookie-config>

    <!--
      Tracking modes:
      COOKIE: usa cookie (por defecto)
      URL: añade jsessionid a la URL (inseguro, no recomendado)
      SSL: usa el ID de sesión SSL
    -->
    <tracking-mode>COOKIE</tracking-mode>
  </session-config>

  <!-- ============================================================ -->
  <!-- SECCIÓN 6: PÁGINAS DE BIENVENIDA                           -->
  <!-- ============================================================ -->

  <welcome-file-list>
    <welcome-file>index.html</welcome-file>
    <welcome-file>index.jsp</welcome-file>
    <welcome-file>index.htm</welcome-file>
  </welcome-file-list>

  <!-- ============================================================ -->
  <!-- SECCIÓN 7: MANEJO DE ERRORES                               -->
  <!-- ============================================================ -->

  <!-- Manejo por código HTTP -->
  <error-page>
    <error-code>400</error-code>
    <location>/error/400.html</location>
  </error-page>

  <error-page>
    <error-code>401</error-code>
    <location>/error/401.html</location>
  </error-page>

  <error-page>
    <error-code>403</error-code>
    <location>/error/403.html</location>
  </error-page>

  <error-page>
    <error-code>404</error-code>
    <location>/error/404.html</location>
  </error-page>

  <error-page>
    <error-code>405</error-code>
    <location>/error/405.html</location>
  </error-page>

  <error-page>
    <error-code>500</error-code>
    <location>/error/500.html</location>
  </error-page>

  <error-page>
    <error-code>503</error-code>
    <location>/error/503.html</location>
  </error-page>

  <!-- Manejo por tipo de excepción Java -->
  <error-page>
    <exception-type>java.lang.Exception</exception-type>
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

  <mime-mapping>
    <extension>json</extension>
    <mime-type>application/json; charset=UTF-8</mime-type>
  </mime-mapping>

  <mime-mapping>
    <extension>woff2</extension>
    <mime-type>font/woff2</mime-type>
  </mime-mapping>

  <mime-mapping>
    <extension>woff</extension>
    <mime-type>font/woff</mime-type>
  </mime-mapping>

  <mime-mapping>
    <extension>webp</extension>
    <mime-type>image/webp</mime-type>
  </mime-mapping>

  <mime-mapping>
    <extension>avif</extension>
    <mime-type>image/avif</mime-type>
  </mime-mapping>

  <mime-mapping>
    <extension>map</extension>
    <mime-type>application/json</mime-type>
  </mime-mapping>

  <!-- ============================================================ -->
  <!-- SECCIÓN 9: RECURSOS JNDI                                    -->
  <!-- ============================================================ -->

  <!-- Referencia al DataSource JNDI -->
  <resource-ref>
    <description>Base de datos principal de la aplicación</description>
    <res-ref-name>jdbc/AppDB</res-ref-name>
    <res-type>javax.sql.DataSource</res-type>
    <res-auth>Container</res-auth>
    <res-sharing-scope>Shareable</res-sharing-scope>
  </resource-ref>

  <resource-ref>
    <description>Base de datos de auditoría</description>
    <res-ref-name>jdbc/AuditDB</res-ref-name>
    <res-type>javax.sql.DataSource</res-type>
    <res-auth>Container</res-auth>
    <res-sharing-scope>Unshareable</res-sharing-scope>
  </resource-ref>

  <!-- ============================================================ -->
  <!-- SECCIÓN 10: SEGURIDAD DECLARATIVA                           -->
  <!-- ============================================================ -->

  <!-- Definición de roles de seguridad -->
  <security-role>
    <role-name>admin</role-name>
  </security-role>

  <security-role>
    <role-name>manager</role-name>
  </security-role>

  <security-role>
    <role-name>user</role-name>
  </security-role>

  <!-- Restricción de seguridad para área de administración -->
  <security-constraint>
    <display-name>Admin Area</display-name>
    <web-resource-collection>
      <web-resource-name>Admin Resources</web-resource-name>
      <url-pattern>/admin/*</url-pattern>
      <http-method>GET</http-method>
      <http-method>POST</http-method>
      <http-method>PUT</http-method>
      <http-method>DELETE</http-method>
    </web-resource-collection>
    <auth-constraint>
      <role-name>admin</role-name>
    </auth-constraint>
    <user-data-constraint>
      <!-- CONFIDENTIAL: requiere HTTPS -->
      <transport-guarantee>CONFIDENTIAL</transport-guarantee>
    </user-data-constraint>
  </security-constraint>

  <!-- Restricción para API (usuarios autenticados) -->
  <security-constraint>
    <display-name>API Resources</display-name>
    <web-resource-collection>
      <web-resource-name>API Protected</web-resource-name>
      <url-pattern>/api/protected/*</url-pattern>
    </web-resource-collection>
    <auth-constraint>
      <role-name>admin</role-name>
      <role-name>manager</role-name>
      <role-name>user</role-name>
    </auth-constraint>
    <user-data-constraint>
      <transport-guarantee>CONFIDENTIAL</transport-guarantee>
    </user-data-constraint>
  </security-constraint>

  <!-- Método de autenticación -->
  <login-config>
    <!--
      Métodos disponibles:
      BASIC      — HTTP Basic Auth (Base64, no cifrado)
      DIGEST     — HTTP Digest Auth (MD5 hash)
      FORM       — Formulario HTML personalizado
      CLIENT-CERT— Certificado de cliente (mTLS)
      NONE       — Sin autenticación
    -->
    <auth-method>FORM</auth-method>
    <realm-name>Mi Aplicación Empresarial</realm-name>
    <form-login-config>
      <form-login-page>/login.html</form-login-page>
      <form-error-page>/login-error.html</form-error-page>
    </form-login-config>
  </login-config>

</web-app>
```

### 5.3.2 Para Tomcat 10.x y 11.x (namespace jakarta.*)

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

---

## 5.4 Implementación de Componentes Web

### 5.4.1 Servlet con anotaciones — Tomcat 8+ / 9

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
    name        = "apiServlet",
    urlPatterns = { "/api/*", "/api/v1/*" },
    loadOnStartup = 1,
    asyncSupported = true,
    initParams  = {
        @WebInitParam(name = "maxResults",   value = "100"),
        @WebInitParam(name = "cacheTimeout", value = "300"),
        @WebInitParam(name = "apiVersion",   value = "v1")
    }
)
public class ApiServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private int maxResults;
    private int cacheTimeout;
    private String apiVersion;
    private ServletContext context;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        this.context      = config.getServletContext();
        this.maxResults   = Integer.parseInt(config.getInitParameter("maxResults"));
        this.cacheTimeout = Integer.parseInt(config.getInitParameter("cacheTimeout"));
        this.apiVersion   = config.getInitParameter("apiVersion");

        // Acceder a parámetros del contexto (context-param de web.xml)
        String env = context.getInitParameter("app.environment");

        context.log("ApiServlet inicializado. Env: " + env
            + ", maxResults: " + maxResults);
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        String queryString = request.getQueryString();

        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Cabeceras de caché
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        try (PrintWriter out = response.getWriter()) {
            out.println("{\"status\":\"ok\",\"version\":\"" + apiVersion + "\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String contentType = request.getContentType();

        if (contentType == null || !contentType.contains("application/json")) {
            response.sendError(HttpServletResponse.SC_UNSUPPORTED_MEDIA_TYPE,
                "Content-Type debe ser application/json");
            return;
        }

        // Leer body de la petición
        StringBuilder body = new StringBuilder();
        try (var reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                body.append(line);
            }
        }

        response.setContentType("application/json; charset=UTF-8");
        response.setStatus(HttpServletResponse.SC_CREATED);
        try (PrintWriter out = response.getWriter()) {
            out.println("{\"status\":\"created\",\"received\":" + body.length() + "}");
        }
    }

    @Override
    public void destroy() {
        context.log("ApiServlet destruido. Liberando recursos...");
        // Liberar recursos: cerrar conexiones, cancelar tareas programadas, etc.
    }
}
```

### 5.4.2 Servlet Asíncrono — Servlet 3.x / 4.0 / 5.0+

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
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Servlet Asíncrono: libera el hilo del pool de Tomcat inmediatamente
 * y procesa la petición en un pool de hilos independiente.
 * Útil para operaciones I/O-bound (llamadas a servicios externos, BD, etc.)
 */
@WebServlet(urlPatterns = "/api/async/*", asyncSupported = true)
public class AsyncApiServlet extends HttpServlet {

    private ExecutorService asyncExecutor;

    @Override
    public void init() {
        // Pool de hilos dedicado para procesamiento asíncrono
        asyncExecutor = Executors.newFixedThreadPool(
            Runtime.getRuntime().availableProcessors() * 2
        );
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response) {

        // 1. Iniciar modo asíncrono — libera el hilo de Tomcat
        AsyncContext asyncContext = request.startAsync();

        // 2. Configurar timeout (debe ser menor que asyncTimeout del Connector)
        asyncContext.setTimeout(25000);

        // 3. Añadir listener para manejo de eventos async
        asyncContext.addListener(new AsyncListener() {
            @Override
            public void onComplete(AsyncEvent event) {
                // Petición completada normalmente
            }

            @Override
            public void onTimeout(AsyncEvent event) throws IOException {
                HttpServletResponse resp =
                    (HttpServletResponse) event.getAsyncContext().getResponse();
                resp.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
                resp.getWriter().println("{\"error\":\"Request timeout\"}");
                event.getAsyncContext().complete();
            }

            @Override
            public void onError(AsyncEvent event) throws IOException {
                HttpServletResponse resp =
                    (HttpServletResponse) event.getAsyncContext().getResponse();
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                resp.getWriter().println("{\"error\":\"Internal error\"}");
                event.getAsyncContext().complete();
            }

            @Override
            public void onStartAsync(AsyncEvent event) {
                // Re-iniciado en modo async
            }
        });

        // 4. Procesar en el pool de hilos asíncrono
        asyncExecutor.submit(() -> {
            try {
                // Simular operación lenta (llamada a servicio externo, BD, etc.)
                String result = processLongRunningOperation(request);

                // 5. Escribir respuesta cuando esté lista
                HttpServletResponse asyncResponse =
                    (HttpServletResponse) asyncContext.getResponse();
                asyncResponse.setContentType("application/json; charset=UTF-8");
                asyncResponse.setStatus(HttpServletResponse.SC_OK);

                try (PrintWriter writer = asyncResponse.getWriter()) {
                    writer.println(result);
                }

            } catch (Exception e) {
                asyncContext.getRequest().setAttribute(
                    "javax.servlet.error.exception", e
                );
            } finally {
                // 6. SIEMPRE completar el contexto async
                asyncContext.complete();
            }
        });
    }

    private String processLongRunningOperation(HttpServletRequest request)
            throws InterruptedException {
        // Simular latencia de operación real
        Thread.sleep(2000);
        return "{\"status\":\"ok\",\"data\":\"resultado procesado\"}";
    }

    @Override
    public void destroy() {
        asyncExecutor.shutdown();
    }
}
```

### 5.4.3 Filtro HTTP completo

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
)
public class SecurityHeadersFilter implements Filter {

    private Set<String> excludedPaths;
    private boolean enforceHttps;

    @Override
    public void init(FilterConfig filterConfig) {
        String excluded = filterConfig.getInitParameter("excludedPaths");
        if (excluded != null) {
            excludedPaths = new HashSet<>(Arrays.asList(excluded.split(",")));
        } else {
            excludedPaths = new HashSet<>();
        }

        String https = filterConfig.getInitParameter("enforceHttps");
        this.enforceHttps = Boolean.parseBoolean(https != null ? https : "true");
    }

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  httpRequest  = (HttpServletRequest)  request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String path = httpRequest.getRequestURI();

        // Añadir ID de correlación para trazabilidad
        String requestId = UUID.randomUUID().toString();
        httpRequest.setAttribute("requestId", requestId);
        httpResponse.setHeader("X-Request-ID", requestId);

        if (!excludedPaths.contains(path)) {

            // ===== Cabeceras de Seguridad OWASP =====

            // Previene clickjacking
            httpResponse.setHeader("X-Frame-Options", "SAMEORIGIN");

            // Previene MIME type sniffing
            httpResponse.setHeader("X-Content-Type-Options", "nosniff");

            // Activa XSS filter del navegador (legacy, para IE)
            httpResponse.setHeader("X-XSS-Protection", "1; mode=block");

            // HSTS: forzar HTTPS durante 1 año
            if (enforceHttps || httpRequest.isSecure()) {
                httpResponse.setHeader("Strict-Transport-Security",
                    "max-age=31536000; includeSubDomains; preload");
            }

            // Content Security Policy
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

            // Referrer Policy
            httpResponse.setHeader("Referrer-Policy",
                "strict-origin-when-cross-origin");

            // Permissions Policy (antes Feature-Policy)
            httpResponse.setHeader("Permissions-Policy",
                "geolocation=(), " +
                "microphone=(), " +
                "camera=(), " +
                "payment=(), " +
                "usb=()");

            // Eliminar cabeceras que exponen información del servidor
            httpResponse.setHeader("X-Powered-By", "");
            httpResponse.setHeader("Server", "");
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Liberar recursos si los hay
    }
}
```

### 5.4.4 Listener de Contexto

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
public class AppContextListener implements ServletContextListener {

    private static final Logger log =
        Logger.getLogger(AppContextListener.class.getName());

    private ScheduledExecutorService scheduler;
    private DataSource dataSource;

    @Override
    public void contextInitialized(ServletContextEvent event) {
        ServletContext context = event.getServletContext();

        log.info("=== Iniciando aplicación: "
            + context.getServletContextName() + " ===");

        // 1. Cargar configuración
        String configPath = context.getInitParameter("app.config.path");
        log.info("Cargando configuración desde: " + configPath);

        // 2. Obtener DataSource JNDI y verificar conectividad
        try {
            InitialContext ic = new InitialContext();
            dataSource = (DataSource) ic.lookup("java:comp/env/jdbc/AppDB");

            try (Connection conn = dataSource.getConnection()) {
                log.info("Conexión a BD verificada: "
                    + conn.getMetaData().getDatabaseProductName()
                    + " v" + conn.getMetaData().getDatabaseProductVersion());
            }
        } catch (NamingException e) {
            log.severe("ERROR: DataSource JNDI no encontrado: " + e.getMessage());
            throw new RuntimeException("DataSource no disponible", e);
        } catch (SQLException e) {
            log.severe("ERROR: No se puede conectar a la BD: " + e.getMessage());
            throw new RuntimeException("BD no disponible", e);
        }

        // 3. Inicializar scheduler de tareas
        scheduler = Executors.newScheduledThreadPool(4,
            r -> {
                Thread t = new Thread(r, "app-scheduler-thread");
                t.setDaemon(true);
                return t;
            }
        );

        // Tarea periódica: limpieza de caché cada 5 minutos
        scheduler.scheduleAtFixedRate(
            this::cleanupCache, 5, 5, TimeUnit.MINUTES
        );

        // Tarea periódica: heartbeat cada 30 segundos
        scheduler.scheduleAtFixedRate(
            this::heartbeat, 30, 30, TimeUnit.SECONDS
        );

        // 4. Publicar objetos compartidos en el contexto
        context.setAttribute("dataSource", dataSource);
        context.setAttribute("appVersion",
            context.getInitParameter("app.version"));
        context.setAttribute("scheduler", scheduler);

        log.info("=== Aplicación iniciada correctamente ===");
    }

    @Override
    public void contextDestroyed(ServletContextEvent event) {
        log.info("=== Deteniendo aplicación ===");

        // Detener scheduler limpiamente
        if (scheduler != null && !scheduler.isShutdown()) {
            scheduler.shutdown();
            try {
                if (!scheduler.awaitTermination(30, TimeUnit.SECONDS)) {
                    scheduler.shutdownNow();
                    log.warning("Scheduler forzado a parar tras timeout");
                }
            } catch (InterruptedException e) {
                scheduler.shutdownNow();
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
        try (Connection conn = dataSource.getConnection()) {
            conn.isValid(5);
        } catch (SQLException e) {
            log.warning("Heartbeat BD fallido: " + e.getMessage());
        }
    }
}
```

---

## 5.5 Despliegue de Aplicaciones: Métodos y Estrategias

### 5.5.1 Métodos de despliegue

```bash
# ======================================================
# MÉTODO 1: Copia manual del WAR (más simple)
# ======================================================
cp myapp-2.3.1.war $CATALINA_BASE/webapps/myapp.war
# Tomcat detecta el nuevo WAR automáticamente si autoDeploy="true"
# En producción con autoDeploy="false": requiere reinicio

# ======================================================
# MÉTODO 2: Manager API REST (sin reinicio de Tomcat)
# ======================================================

# Desplegar un WAR nuevo
curl -u deployer:password \
  -T myapp-2.3.1.war \
  "http://localhost:8080/manager/text/deploy?path=/myapp&update=true"

# Listar aplicaciones desplegadas
curl -u deployer:password \
  http://localhost:8080/manager/text/list

# Recargar una aplicación (sin redesplegar el WAR)
curl -u deployer:password \
  "http://localhost:8080/manager/text/reload?path=/myapp"

# Iniciar una aplicación parada
curl -u deployer:password \
  "http://localhost:8080/manager/text/start?path=/myapp"

# Parar una aplicación
curl -u deployer:password \
  "http://localhost:8080/manager/text/stop?path=/myapp"

# Desplegar desde una URL remota
curl -u deployer:password \
  "http://localhost:8080/manager/text/deploy?path=/myapp&war=http://repo.miempresa.com/myapp-2.3.1.war"

# Undeploy: eliminar la aplicación
curl -u deployer:password \
  "http://localhost:8080/manager/text/undeploy?path=/myapp"

# Ver estado detallado de una app
curl -u deployer:password \
  "http://localhost:8080/manager/text/sessions?path=/myapp"

# Expirar sesiones de más de 60 minutos
curl -u deployer:password \
  "http://localhost:8080/manager/text/expire?path=/myapp&idle=60"

# ======================================================
# MÉTODO 3: Tarea Ant (integración CI/CD legacy)
# ======================================================
# Añadir en build.xml:
# <taskdef name="deploy" classname="org.apache.catalina.ant.DeployTask"
#          classpath="${catalina.home}/lib/catalina-ant.jar"/>
# <deploy url="http://localhost:8080/manager/text"
#         username="deployer" password="password"
#         path="/myapp" war="file:${dist}/myapp.war" update="true"/>
```

### 5.5.2 Despliegue Zero-Downtime con Context Descriptor

```bash
#!/bin/bash
# deploy-zero-downtime.sh
# Estrategia: desplegar nueva versión en path temporal,
# verificar health, y redireccionar el tráfico.

set -euo pipefail

APP_NAME="myapp"
NEW_WAR="myapp-2.3.1.war"
TOMCAT_MANAGER="http://localhost:8080/manager/text"
MANAGER_USER="deployer"
MANAGER_PASS="password"
HEALTH_URL="http://localhost:8080/${APP_NAME}/health"

echo "=== Inicio del despliegue zero-downtime ==="

# 1. Desplegar nueva versión en path temporal
echo "Desplegando nueva versión en /myapp-new..."
curl -s -u "$MANAGER_USER:$MANAGER_PASS" \
  -T "$NEW_WAR" \
  "$TOMCAT_MANAGER/deploy?path=/myapp-new&update=true"

# 2. Esperar a que la aplicación esté lista
echo "Esperando disponibilidad..."
MAX_RETRIES=30
RETRY=0
until curl -sf "$HEALTH_URL" > /dev/null 2>&1; do
    RETRY=$((RETRY+1))
    if [ $RETRY -ge $MAX_RETRIES ]; then
        echo "ERROR: La nueva versión no está disponible tras $MAX_RETRIES intentos"
        curl -s -u "$MANAGER_USER:$MANAGER_PASS" \
          "$TOMCAT_MANAGER/undeploy?path=/myapp-new"
        exit 1
    fi
    echo "Intento $RETRY/$MAX_RETRIES..."
    sleep 2
done

echo "Nueva versión disponible en /myapp-new"

# 3. Expirar sesiones de la versión anterior
echo "Expirando sesiones antiguas..."
curl -s -u "$MANAGER_USER:$MANAGER_PASS" \
  "$TOMCAT_MANAGER/expire?path=/myapp&idle=0"

# 4. Parar la versión anterior
echo "Parando versión anterior..."
curl -s -u "$MANAGER_USER:$MANAGER_PASS" \
  "$TOMCAT_MANAGER/undeploy?path=/myapp"

# 5. Redesplegar en path definitivo
echo "Desplegando en path definitivo /myapp..."
curl -s -u "$MANAGER_USER:$MANAGER_PASS" \
  -T "$NEW_WAR" \
  "$TOMCAT_MANAGER/deploy?path=/myapp&update=true"

# 6. Limpiar temporal
curl -s -u "$MANAGER_USER:$MANAGER_PASS" \
  "$TOMCAT_MANAGER/undeploy?path=/myapp-new"

echo "=== Despliegue completado ==="
```

---

## 5.6 El DefaultServlet de Tomcat

Tomcat incluye un `DefaultServlet` que sirve recursos estáticos. Se configura en el `web.xml` global de Tomcat (`$CATALINA_HOME/conf/web.xml`).

```xml
<!-- Configuración del DefaultServlet en conf/web.xml global de Tomcat -->
<servlet>
    <servlet-name>default</servlet-name>
    <servlet-class>org.apache.catalina.servlets.DefaultServlet</servlet-class>
    <init-param>
        <!-- Habilitar listado de directorios: NUNCA en producción -->
        <param-name>listings</param-name>
        <param-value>false</param-value>
    </init-param>
    <init-param>
        <!-- Tamaño del buffer de lectura en KB -->
        <param-name>input</param-name>
        <param-value>2048</param-value>
    </init-param>
    <init-param>
        <!-- Tamaño del buffer de escritura en KB -->
        <param-name>output</param-name>
        <param-value>2048</param-value>
    </init-param>
    <init-param>
        <!-- Habilitar soporte de Range requests (para descargas parciales) -->
        <param-name>useAcceptRanges</param-name>
        <param-value>true</param-value>
    </init-param>
    <init-param>
        <!-- Tiempo de caché de file info en milisegundos. 0 = sin caché -->
        <param-name>cacheTtl</param-name>
        <param-value>5000</param-value>
    </init-param>
    <init-param>
        <!-- Tamaño máximo del caché de recursos estáticos en KB -->
        <param-name>cacheMaxSize</param-name>
        <param-value>102400</param-value>
    </init-param>
    <init-param>
        <!-- Tamaño máximo de objeto individual en caché en KB -->
        <param-name>cacheObjectMaxSize</param-name>
        <param-value>512</param-value>
    </init-param>
    <init-param>
        <!-- Enviar ETag para caché HTTP -->
        <param-name>gzip</param-name>
        <param-value>true</param-value>
    </init-param>
    <load-on-startup>1</load-on-startup>
</servlet>
```

---

## 5.7 El JspServlet y Configuración de Jasper

```xml
<!-- Configuración del JspServlet en conf/web.xml global de Tomcat -->
<servlet>
    <servlet-name>jsp</servlet-name>
    <servlet-class>org.apache.jasper.servlet.JspServlet</servlet-class>
    <init-param>
        <!-- Modo fork: compilar JSPs en proceso separado -->
        <param-name>fork</param-name>
        <param-value>false</param-value>
    </init-param>
    <init-param>
        <!-- Modo desarrollo: recompila JSP en cada petición si ha cambiado -->
        <!-- SIEMPRE false en producción -->
        <param-name>development</param-name>
        <param-value>false</param-value>
    </init-param>
    <init-param>
        <!-- Habilitar pool de instancias de expresiones EL -->
        <param-name>enablePooling</param-name>
        <param-value>true</param-value>
    </init-param>
    <init-param>
        <!-- Generar código Java legible (para debugging) -->
        <param-name>genStrAsCharArray</param-name>
        <param-value>false</param-value>
    </init-param>
    <init-param>
        <!-- Mostrar errores en el código fuente JSP generado -->
        <param-name>mappedFile</param-name>
        <param-value>true</param-value>
    </init-param>
    <init-param>
        <!-- Nivel de optimización del compilador ECJ -->
        <param-name>compilerTargetVM</param-name>
        <param-value>17</param-value>
    </init-param>
    <init-param>
        <param-name>compilerSourceVM</param-name>
        <param-value>17</param-value>
    </init-param>
    <init-param>
        <!-- Trim espacios en blanco de la salida JSP -->
        <param-name>trimSpaces</param-name>
        <param-value>true</param-value>
    </init-param>
    <load-on-startup>3</load-on-startup>
</servlet>
```

---

## 5.8 metadata-complete y Orden de Procesamiento

El atributo `metadata-complete="true"` en el elemento `<web-app>` del `web.xml` tiene un impacto significativo en el arranque de la aplicación.

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
-->
<web-app ... metadata-complete="true">
```

### Optimización del escaneo de JARs

```xml
<!-- conf/context.xml — Configuración global -->
<Context>
  <JarScanner scanBootstrapClassPath="false"
              scanAllDirectories="false"
              scanAllFiles="false"
              scanClassPath="false">

    <!-- Excluir JARs del escaneo de TLDs y web-fragments -->
    <JarScanFilter
      defaultTldScan="false"
      defaultPluggabilityScan="false"
      tldScan="taglib-*.jar,jsp-api.jar"
      pluggabilityScan="myapp-fragments.jar">
    </JarScanFilter>

  </JarScanner>
</Context>
```

---

## 5.9 Diferencias de web.xml y APIs entre Versiones de Tomcat

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

---

## 5.10 Herramienta de Migración Jakarta EE (Tomcat 9 → 10+)

Al migrar aplicaciones de Tomcat 9 a Tomcat 10+, el cambio de namespace es el principal obstáculo. Apache proporciona una herramienta oficial de migración.

```bash
# Descargar la Migration Tool
wget https://github.com/apache/tomcat-jakartaee-migration/releases/download/1.0.6/jakartaee-migration-1.0.6-shaded.jar

# Migrar un WAR completo (javax.* → jakarta.*)
java -jar jakartaee-migration-1.0.6-shaded.jar \
  myapp-javax.war \
  myapp-jakarta.war

# Migrar un directorio de clases
java -jar jakartaee-migration-1.0.6-shaded.jar \
  src/main/webapp/ \
  src/main/webapp-jakarta/

# Opciones avanzadas
java -jar jakartaee-migration-1.0.6-shaded.jar \
  --profile EE  \    # Perfil: EE (completo) o WEB (solo web APIs)
  --verbose \
  myapp.war \
  myapp-jakarta.war
```

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
                <goal>migrate</goal>
            </goals>
            <configuration>
                <source>${project.build.directory}/${project.build.finalName}.war</source>
                <destination>${project.build.directory}/${project.build.finalName}-jakarta.war</destination>
                <profile>EE</profile>
            </configuration>
        </execution>
    </executions>
</plugin>
```

---

## Puntos Clave del Módulo 05

- La estructura WAR es estándar: `WEB-INF/` es inaccesible desde HTTP, protegiendo clases, librerías y configuración.
- El namespace del descriptor `web.xml` cambia en **Tomcat 10+**: `https://jakarta.ee/xml/ns/jakartaee` reemplaza a `http://xmlns.jcp.org/xml/ns/javaee`.
- El **orden de los `<filter-mapping>`** en `web.xml` determina el orden de ejecución de la cadena de filtros. Es secuencial y predecible.
- `load-on-startup` con valor positivo inicializa Servlets **al arrancar Tomcat**, en orden ascendente. Valores negativos → inicialización lazy en la primera petición.
- `metadata-complete="true"` deshabilita el escaneo de anotaciones y `web-fragment.xml`, **reduciendo significativamente** el tiempo de arranque en aplicaciones con muchos JARs.
- El **DefaultServlet** no debe tener `listings=true` nunca en producción (expone el sistema de archivos).
- El **JspServlet** debe tener `development=false` en producción para evitar recompilaciones en cada petición.
- Para migrar de Tomcat 9 a 10+, usar la **Jakarta EE Migration Tool** oficial. El cambio de namespace afecta a todas las clases que implementan interfaces Servlet, Filter o Listener.
- La **gestión de sesiones** debe configurarse con `HttpOnly=true`, `Secure=true` y `tracking-mode=COOKIE` siempre en producción.
- El **Manager API REST** permite despliegues sin reinicio de Tomcat, habilitando estrategias de despliegue continuo en entornos de producción.