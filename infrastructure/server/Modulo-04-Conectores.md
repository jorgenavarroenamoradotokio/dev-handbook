## Módulo 04: Conectores HTTP/1.1, HTTP/2 y AJP

## 4.1 Arquitectura Interna de los Conectores: Coyote

Todos los conectores de Tomcat están implementados sobre **Apache Coyote**, el componente de red de bajo nivel que gestiona:

- Aceptación de conexiones TCP
- Parsing de protocolos (HTTP/1.1, HTTP/2, AJP)
- Gestión del pool de hilos de I/O
- Delegación al Engine (Catalina) para el procesamiento de la petición

```
Cliente HTTP
     │
     ▼
┌─────────────────────────────────────────────────────┐
│                   COYOTE (Connector)                │
│                                                     │
│  ┌──────────────┐    ┌────────────────────────────┐ │
│  │  Endpoint    │    │   ProtocolHandler           │ │
│  │  (TCP/IP)    │───▶│   (HTTP/1.1, HTTP/2, AJP)  │ │
│  │              │    │                            │ │
│  │  - Acceptor  │    │  ┌──────────────────────┐  │ │
│  │  - Poller    │    │  │   Processor          │  │ │
│  │  - Handler   │    │  │   (parse/serialize)  │  │ │
│  └──────────────┘    │  └──────────────────────┘  │ │
│                      └────────────────────────────┘ │
│                                   │                 │
└───────────────────────────────────┼─────────────────┘
                                    ▼
                           Catalina (Engine)
```

### Componentes internos del Endpoint

| Componente  | Función                                                                 |
|-------------|-------------------------------------------------------------------------|
| `Acceptor`  | Hilo dedicado que acepta nuevas conexiones TCP del sistema operativo    |
| `Poller`    | Hilo(s) NIO que monitorizan sockets con datos disponibles (Selector)   |
| `Handler`   | Dispatcha el procesamiento al pool de hilos de trabajo                  |
| `Processor` | Parsea el protocolo HTTP y construye el objeto `Request`/`Response`    |

---

## 4.2 Implementaciones de Protocolo Disponibles

### Tabla de implementaciones por versión

| Clase del Protocolo                                    | I/O Model | HTTP/2 | Disponible      | Estado en 9+ |
|--------------------------------------------------------|-----------|--------|-----------------|--------------|
| `Http11BioProtocol`                                    | BIO       | ❌     | 8.0, 8.5        | Eliminado    |
| `Http11NioProtocol`                                    | NIO       | ❌*    | 8.0+            | ✅ Activo    |
| `Http11Nio2Protocol`                                   | NIO2      | ❌*    | 8.0+            | ✅ Activo    |
| `Http11AprProtocol`                                    | APR/OS    | ❌*    | 8.0+            | ✅ Activo    |
| `Http11NioProtocol` + `Http2Protocol` (UpgradeProtocol)| NIO       | ✅     | 8.5+            | ✅ Activo    |
| `AjpNioProtocol`                                       | NIO       | ❌     | 8.0+            | ✅ Activo    |
| `AjpNio2Protocol`                                      | NIO2      | ❌     | 8.5+            | ✅ Activo    |
| `AjpAprProtocol`                                       | APR/OS    | ❌     | 8.0+            | ✅ Activo    |

*HTTP/2 requiere el `UpgradeProtocol` anidado dentro del conector.

---

## 4.3 Modelo BIO vs NIO vs NIO2 vs APR

### 4.3.1 BIO — Blocking I/O (eliminado en Tomcat 9)

```
Petición → Hilo dedicado (bloqueado durante toda la petición)
           ├── Lee cabeceras  [BLOQUEADO]
           ├── Lee body       [BLOQUEADO]
           ├── Procesa        [BLOQUEADO]
           └── Escribe resp.  [BLOQUEADO]
```

- **1 conexión = 1 hilo bloqueado** durante toda la vida de la conexión.
- Ineficiente para keep-alive y cargas con muchas conexiones concurrentes.
- **Eliminado en Tomcat 9.0**. En Tomcat 8.5 fue deprecado.

### 4.3.2 NIO — Non-Blocking I/O (recomendado)

```
Petición → Acceptor (acepta TCP) → Poller (Selector NIO)
                                        │
                                        ▼ (datos disponibles)
                                   Pool de Hilos
                                        │
                                   Processor (parsea HTTP)
                                        │
                                   Engine.invoke()
```

- **N conexiones pueden ser gestionadas por M hilos** (N >> M).
- El Poller usa `java.nio.channels.Selector` para monitorizar múltiples sockets.
- Ideal para alto número de conexiones concurrentes con keep-alive.
- **Recomendado para la mayoría de deployments de producción.**

### 4.3.3 NIO2 — Asynchronous I/O

- Usa `java.nio.channels.AsynchronousSocketChannel` (AIO de Java 7+).
- Las operaciones de I/O son **completamente asíncronas** (callbacks).
- Menor latencia en cargas muy elevadas con I/O intensivo.
- **Diferencia práctica con NIO:** en la mayoría de casos el rendimiento es similar. NIO2 puede ser superior con cargas de conexiones muy cortas y alta tasa de nuevas conexiones.

### 4.3.4 APR — Apache Portable Runtime

- Usa librerías nativas del sistema operativo (`libtcnative`).
- OpenSSL para TLS (mejor rendimiento que JSSE para cifrado/descifrado).
- Requiere compilar e instalar `tomcat-native` en el sistema.
- Necesario para entornos con **muy alto throughput TLS** donde JSSE es el cuello de botella.

```bash
# Instalación de Tomcat Native (APR) en Linux
sudo apt-get install -y libapr1 libapr1-dev libssl-dev

# Compilar tomcat-native desde fuentes
cd $CATALINA_HOME/bin
tar -xzf tomcat-native.tar.gz
cd tomcat-native-*/native
./configure --with-apr=/usr/bin/apr-1-config \
            --with-java-home=$JAVA_HOME \
            --with-ssl=yes \
            --prefix=$CATALINA_HOME
make && make install

# Configurar LD_LIBRARY_PATH en setenv.sh
export LD_LIBRARY_PATH="$CATALINA_HOME/lib:$LD_LIBRARY_PATH"
```

---

## 4.4 Configuración Detallada del Conector HTTP/1.1 NIO

### 4.4.1 Atributos de red y conexión

```xml
<Connector port="8080"
           protocol="org.apache.coyote.http11.Http11NioProtocol"

           <!-- ===== Red ===== -->
           address="0.0.0.0"
           bindOnInit="true"
           acceptorThreadCount="1"
           acceptorThreadPriority="5"
           pollerThreadCount="1"
           pollerThreadPriority="5"
           selectorTimeout="1000"

           <!-- ===== Conexiones ===== -->
           maxConnections="10000"
           acceptCount="200"
           connectionTimeout="20000"
           keepAliveTimeout="30000"
           maxKeepAliveRequests="100"
           tcpNoDelay="true"
           soLingerOn="false"
           soLingerTime="25"
           soTimeout="20000"
           useKeepAliveResponseHeader="true"

           <!-- ===== Hilos ===== -->
           maxThreads="400"
           minSpareThreads="25"
           maxSpareThreads="75"
           threadPriority="5"
           prestartminSpareThreads="true"

           <!-- ===== HTTP ===== -->
           URIEncoding="UTF-8"
           useBodyEncodingForURI="false"
           maxHttpHeaderSize="16384"
           maxHttpRequestHeaderSize="8192"
           maxHttpResponseHeaderSize="8192"
           maxPostSize="10485760"
           maxParameterCount="1000"
           maxTrailerSize="8192"
           maxSavePostSize="4096"
           disableUploadTimeout="true"
           connectionUploadTimeout="300000"

           <!-- ===== Compresión ===== -->
           compression="on"
           compressionMinSize="2048"
           compressionLevel="6"
           compressibleMimeType="text/html,text/xml,text/plain,
                                  text/css,text/javascript,
                                  application/json,application/xml,
                                  application/javascript,
                                  image/svg+xml"
           noCompressionUserAgents=""

           <!-- ===== Proxy / Balanceador ===== -->
           scheme="http"
           secure="false"
           proxyName=""
           proxyPort="0"

           <!-- ===== Seguridad ===== -->
           server="Apache"
           rejectIllegalHeader="true"
           allowHostHeaderMismatch="false"
           allowedTrailerHeaders=""
           maxExtensionSize="8192"
           maxSwallowSize="2097152"

           redirectPort="8443"/>
```

### 4.4.2 Tabla de atributos críticos para tuning

| Atributo                 | Impacto                                                  | Valor recomendado prod  |
|--------------------------|----------------------------------------------------------|-------------------------|
| `maxThreads`             | Máximo paralelismo de procesamiento                      | `200`-`500`             |
| `minSpareThreads`        | Hilos siempre disponibles (evita latencia de creación)   | `25`-`50`               |
| `maxConnections`         | Conexiones TCP simultáneas totales                       | `8000`-`15000`          |
| `acceptCount`            | Cola SO cuando todos los hilos están ocupados            | `100`-`300`             |
| `connectionTimeout`      | Tiempo hasta recibir la primera línea HTTP               | `15000`-`20000` ms      |
| `keepAliveTimeout`       | Tiempo idle de conexión keep-alive                       | `20000`-`60000` ms      |
| `maxKeepAliveRequests`   | Peticiones máximas por conexión keep-alive               | `100`-`500`             |
| `maxPostSize`            | Tamaño máximo del body en POST                           | Según negocio (bytes)   |
| `maxParameterCount`      | Protección contra ataques de denegación de servicio      | `500`-`2000`            |
| `compressionMinSize`     | Umbral mínimo para comprimir respuestas                  | `1024`-`4096` bytes     |

---

## 4.5 HTTP/2 en Tomcat 8.5+

### 4.5.1 Funcionamiento de HTTP/2 en Tomcat

HTTP/2 en Tomcat se implementa como un **UpgradeProtocol** sobre el conector HTTP/1.1. Soporta:

- **Multiplexación de streams:** múltiples peticiones/respuestas sobre una única conexión TCP.
- **Server Push:** envío proactivo de recursos al cliente.
- **Compresión de cabeceras HPACK.**
- **Priorización de streams.**

HTTP/2 puede negociarse de dos formas:
1. **h2 (TLS):** Negociación via ALPN durante el handshake TLS. **Recomendado.**
2. **h2c (cleartext):** HTTP/2 sin TLS via `Upgrade` header. Solo para redes internas.

### 4.5.2 Configuración HTTP/2 sobre HTTPS (h2)

```xml
<Connector port="8443"
           protocol="org.apache.coyote.http11.Http11NioProtocol"
           SSLEnabled="true"
           maxThreads="400"
           scheme="https"
           secure="true"
           connectionTimeout="20000"
           keepAliveTimeout="30000"
           maxConnections="10000">

  <!--
    Http2Protocol: habilita HTTP/2 sobre este conector.
    Tomcat negocia h2 via ALPN durante el handshake TLS.
    Si el cliente no soporta HTTP/2, cae a HTTP/1.1 automáticamente.
  -->
  <UpgradeProtocol className="org.apache.coyote.http2.Http2Protocol"
                   keepAliveTimeout="30000"
                   readTimeout="30000"
                   writeTimeout="30000"
                   maxConcurrentStreams="200"
                   maxConcurrentStreamExecution="200"
                   maxHeaderCount="100"
                   maxHeaderSize="65536"
                   maxTrailerCount="100"
                   maxTrailerSize="65536"
                   initialWindowSize="65535"
                   maxSessionHeaderTableSize="4096"
                   compressibleMimeTypes="text/html,text/xml,text/plain,
                                          text/css,text/javascript,
                                          application/json,application/xml"
                   compressionLevel="6"
                   noCompressionUserAgents=""
                   allowedTrailerHeaders=""
                   streamReadTimeout="20000"
                   streamWriteTimeout="20000"
                   overheadContinuationThreshold="1024"
                   overheadDataThreshold="1024"
                   overheadWindowUpdateThreshold="1024"
                   overheadResetFactor="50"
                   overheadCountFactor="10"/>

  <SSLHostConfig hostName="_default_"
                 protocols="TLSv1.2,TLSv1.3"
                 ciphers="TLS_AES_256_GCM_SHA384:TLS_AES_128_GCM_SHA256:
                          ECDHE-RSA-AES256-GCM-SHA384:
                          ECDHE-RSA-AES128-GCM-SHA256"
                 honorCipherOrder="false">
    <Certificate type="RSA"
                 certificateKeystoreFile="${catalina.base}/conf/ssl/keystore.jks"
                 certificateKeystorePassword="${ssl.keystore.password}"/>
  </SSLHostConfig>

</Connector>
```

### 4.5.3 Configuración HTTP/2 cleartext (h2c) — Solo redes internas

```xml
<Connector port="8080"
           protocol="org.apache.coyote.http11.Http11NioProtocol"
           connectionTimeout="20000"
           redirectPort="8443">

  <!--
    h2c: HTTP/2 sin TLS.
    El cliente envía una cabecera "Upgrade: h2c" en la primera petición HTTP/1.1.
    Tomcat acepta el upgrade y cambia el protocolo.
    SOLO usar en redes internas de confianza (microservicios, backend-to-backend).
  -->
  <UpgradeProtocol className="org.apache.coyote.http2.Http2Protocol"
                   maxConcurrentStreams="100"
                   maxHeaderSize="32768"
                   initialWindowSize="65535"/>

</Connector>
```

### 4.5.4 Server Push HTTP/2 desde un Servlet

```java
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.PushBuilder;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/index")
public class IndexServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws IOException {

        // Server Push: enviar CSS y JS antes de que el cliente los pida
        PushBuilder pushBuilder = request.newPushBuilder();

        if (pushBuilder != null) {
            // Push del CSS principal
            pushBuilder.path("/static/css/app.css")
                       .addHeader("Content-Type", "text/css")
                       .push();

            // Push del JavaScript principal
            pushBuilder.path("/static/js/app.js")
                       .addHeader("Content-Type", "application/javascript")
                       .push();

            // Push de una imagen crítica
            pushBuilder.path("/static/img/logo.png")
                       .addHeader("Content-Type", "image/png")
                       .push();
        }

        // Generar la respuesta HTML principal
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().println("""
            <!DOCTYPE html>
            <html>
            <head>
                <link rel="stylesheet" href="/static/css/app.css">
                <script src="/static/js/app.js"></script>
            </head>
            <body><img src="/static/img/logo.png"><h1>Hello HTTP/2!</h1></body>
            </html>
            """);
    }
}
```

### 4.5.5 Atributos Http2Protocol más relevantes

| Atributo                       | Descripción                                                           | Valor por defecto |
|--------------------------------|-----------------------------------------------------------------------|-------------------|
| `maxConcurrentStreams`         | Máximo de streams HTTP/2 simultáneos por conexión                    | `200`             |
| `maxConcurrentStreamExecution` | Streams en ejecución activa simultánea por conexión                  | `200`             |
| `maxHeaderCount`               | Cabeceras máximas por petición (protección DoS)                      | `100`             |
| `maxHeaderSize`                | Tamaño máximo del bloque de cabeceras en bytes                       | `65536`           |
| `initialWindowSize`            | Ventana de control de flujo inicial (bytes)                          | `65535`           |
| `keepAliveTimeout`             | Tiempo de idle antes de cerrar la conexión HTTP/2                    | `20000` ms        |
| `streamReadTimeout`            | Timeout para leer datos de un stream individual                      | `20000` ms        |
| `overheadResetFactor`          | Factor de penalización por frames RST_STREAM (protección DoS)        | `50`              |

---

## 4.6 Conector AJP — Apache JServ Protocol

### 4.6.1 ¿Qué es AJP y cuándo usarlo?

AJP (Apache JServ Protocol v1.3) es un protocolo binario optimizado para la comunicación entre un servidor web frontal (**Apache httpd** con `mod_proxy_ajp` o `mod_jk`) y Tomcat como backend.

```
Internet → [Apache httpd :80/:443]
                    │ AJP/1.3 (binario, puerto 8009)
                    ▼
            [Tomcat :8009]
```

**Ventajas de AJP sobre HTTP proxy:**
- Protocolo binario más eficiente que HTTP en texto.
- Reenvío nativo de atributos SSL del cliente (certificados, cifrado).
- Soporte nativo de atributos de request extendidos.

**Cuándo NO usar AJP:**
- Si usas Nginx como proxy frontal → usar `proxy_pass` HTTP.
- Si Tomcat está expuesto directamente → usar HTTPS directo.
- Si no hay Apache httpd en el stack → deshabilitar completamente.

### 4.6.2 Configuración completa del Conector AJP (post-Ghostcat)

```xml
<!--
  ============================================================
  Conector AJP — Configuración segura post CVE-2020-1938
  ============================================================
  CAMBIOS OBLIGATORIOS desde Tomcat:
    - 9.0.31+ / 8.5.51+ / 10.0.0-M4+:
      * secretRequired="true" por defecto
      * requiredSecret DEBE configurarse
      * address="127.0.0.1" para limitar escucha a loopback
  ============================================================
-->
<Connector protocol="AJP/1.3"
           address="127.0.0.1"
           port="8009"
           redirectPort="8443"

           <!-- ===== Seguridad Ghostcat ===== -->
           secretRequired="true"
           requiredSecret="${ajp.secret}"

           <!-- ===== Timeouts ===== -->
           connectionTimeout="20000"
           keepAliveTimeout="60000"
           maxKeepAliveRequests="-1"

           <!-- ===== Pool de hilos ===== -->
           maxThreads="200"
           minSpareThreads="10"
           acceptCount="100"
           maxConnections="5000"

           <!-- ===== Atributos AJP ===== -->
           tomcatAuthentication="false"
           tomcatAuthorization="false"
           allowedRequestAttributesPattern="^(AJP_.*|SSL_.*|REMOTE_.*)$"

           <!-- ===== Opciones de red ===== -->
           packetSize="8192"
           URIEncoding="UTF-8"/>
```

### 4.6.3 Configuración de Apache httpd con mod_proxy_ajp

```apache
# /etc/apache2/sites-available/myapp.conf

<VirtualHost *:443>
    ServerName app.miempresa.com
    ServerAlias www.app.miempresa.com

    # SSL en Apache httpd
    SSLEngine on
    SSLCertificateFile    /etc/ssl/certs/miempresa.crt
    SSLCertificateKeyFile /etc/ssl/private/miempresa.key
    SSLCertificateChainFile /etc/ssl/certs/ca-chain.pem

    SSLProtocol TLSv1.2 TLSv1.3
    SSLCipherSuite ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256

    # Cabeceras de seguridad
    Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains"
    Header always set X-Content-Type-Options "nosniff"
    Header always set X-Frame-Options "SAMEORIGIN"

    # Proxy AJP hacia Tomcat
    ProxyRequests Off
    ProxyPreserveHost On

    # Worker AJP con secret (debe coincidir con requiredSecret de Tomcat)
    ProxyPass        / ajp://127.0.0.1:8009/ secret=mi-secreto-ajp-seguro
    ProxyPassReverse / ajp://127.0.0.1:8009/

    # Timeouts del proxy
    ProxyTimeout 120

    # Balanceo de carga entre múltiples Tomcats
    # <Proxy balancer://tomcatcluster>
    #     BalancerMember ajp://tomcat1:8009 route=node01 secret=mi-secreto
    #     BalancerMember ajp://tomcat2:8009 route=node02 secret=mi-secreto
    #     ProxySet stickysession=JSESSIONID|jsessionid
    # </Proxy>
    # ProxyPass / balancer://tomcatcluster/
    # ProxyPassReverse / balancer://tomcatcluster/

    ErrorLog ${APACHE_LOG_DIR}/myapp-error.log
    CustomLog ${APACHE_LOG_DIR}/myapp-access.log combined

</VirtualHost>

# Redirección HTTP → HTTPS
<VirtualHost *:80>
    ServerName app.miempresa.com
    Redirect permanent / https://app.miempresa.com/
</VirtualHost>
```

### 4.6.4 Configuración de mod_jk (alternativa legacy)

```apache
# /etc/apache2/conf-available/mod_jk.conf

# Cargar el módulo
LoadModule jk_module /usr/lib/apache2/modules/mod_jk.so

# Archivo de workers
JkWorkersFile /etc/apache2/workers.properties

# Log de mod_jk
JkLogFile /var/log/apache2/mod_jk.log
JkLogLevel warn

# Montar path en worker
JkMount /myapp/* worker1
JkMount /myapp worker1

# Montar todo excepto archivos estáticos
JkMountCopy On
JkUnMount  /static/* worker1
```

```properties
# /etc/apache2/workers.properties

# Lista de workers
worker.list=worker1,jkstatus

# Worker Tomcat 1
worker.worker1.type=ajp13
worker.worker1.host=127.0.0.1
worker.worker1.port=8009
worker.worker1.connection_pool_size=50
worker.worker1.connection_pool_timeout=600
worker.worker1.socket_timeout=300
worker.worker1.socket_keepalive=true
worker.worker1.secret=mi-secreto-ajp-seguro

# Worker de estado (monitorización)
worker.jkstatus.type=status
worker.jkstatus.read_only=true
```

---

## 4.7 Conector HTTP con Proxy Inverso (Nginx / HAProxy)

Cuando Tomcat está detrás de un proxy inverso, es necesario configurar correctamente los atributos del conector para que Tomcat reciba la IP real del cliente y el esquema correcto (http/https).

### 4.7.1 Configuración Tomcat detrás de Nginx (HTTP proxy)

```nginx
# /etc/nginx/sites-available/myapp.conf

upstream tomcat_backend {
    server 127.0.0.1:8080;
    keepalive 32;
}

server {
    listen 443 ssl http2;
    server_name app.miempresa.com;

    ssl_certificate     /etc/ssl/certs/miempresa.crt;
    ssl_certificate_key /etc/ssl/private/miempresa.key;
    ssl_protocols       TLSv1.2 TLSv1.3;
    ssl_ciphers         ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256;

    # Cabeceras que Tomcat necesita para conocer el cliente real
    location / {
        proxy_pass         http://tomcat_backend;
        proxy_http_version 1.1;
        proxy_set_header   Connection          "";
        proxy_set_header   Host                $host;
        proxy_set_header   X-Real-IP           $remote_addr;
        proxy_set_header   X-Forwarded-For     $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto   $scheme;
        proxy_set_header   X-Forwarded-Port    $server_port;
        proxy_read_timeout 120s;
        proxy_send_timeout 120s;
        proxy_connect_timeout 10s;
        proxy_buffering    on;
        proxy_buffer_size  16k;
        proxy_buffers      8 16k;
    }

    # Servir estáticos directamente desde Nginx (sin pasar por Tomcat)
    location /static/ {
        alias /opt/apps/myapp/static/;
        expires 30d;
        add_header Cache-Control "public, immutable";
    }
}
```

### 4.7.2 RemoteIpValve — Procesar X-Forwarded-For en Tomcat

```xml
<!--
  RemoteIpValve: extrae la IP real del cliente de las cabeceras
  X-Forwarded-For y X-Forwarded-Proto enviadas por el proxy.

  Sin este Valve, request.getRemoteAddr() devuelve la IP del proxy,
  no la del cliente real. Igualmente, request.isSecure() devuelve
  false aunque el cliente esté usando HTTPS.
-->
<Valve className="org.apache.catalina.valves.RemoteIpValve"
       remoteIpHeader="X-Forwarded-For"
       protocolHeader="X-Forwarded-Proto"
       protocolHeaderHttpsValue="https"
       portHeader="X-Forwarded-Port"
       internalProxies="127\.0\.0\.1|192\.168\.0\.\d+|10\.0\.0\.\d+"
       trustedProxies="172\.16\.0\.\d+"
       proxiesHeader="X-Forwarded-By"
       httpServerPort="8080"
       httpsServerPort="8443"
       changeLocalPort="true"
       requestAttributesEnabled="true"/>
```

> ⚠️ **Seguridad:** El atributo `internalProxies` define qué IPs son consideradas proxies de confianza. Solo las IPs listadas aquí pueden establecer la cabecera `X-Forwarded-For`. Si un cliente externo envía esa cabecera y su IP no está en `internalProxies`, la cabecera es ignorada.

### 4.7.3 Conector HTTP optimizado para funcionar detrás de proxy

```xml
<!--
  Cuando Tomcat está detrás de un proxy que gestiona TLS:
  - scheme y secure se configuran en RemoteIpValve, no en el Connector
  - proxyName y proxyPort solo si el proxy no envía X-Forwarded-For
  - El Connector escucha solo en loopback (127.0.0.1)
-->
<Connector port="8080"
           protocol="org.apache.coyote.http11.Http11NioProtocol"
           address="127.0.0.1"
           connectionTimeout="20000"
           keepAliveTimeout="30000"
           maxThreads="400"
           minSpareThreads="25"
           maxConnections="10000"
           acceptCount="200"
           compression="off"
           URIEncoding="UTF-8"
           server="Apache"
           rejectIllegalHeader="true"/>
```

> 💡 Con proxy inverso desactivar `compression="off"` en Tomcat si el proxy ya comprime las respuestas para evitar doble compresión.

---

## 4.8 Gestión de Timeouts: Guía Completa

Los timeouts mal configurados son una causa frecuente de problemas en producción. Esta tabla recoge todos los timeouts relevantes y su impacto.

| Timeout                   | Nivel      | Descripción                                                         | Valor típico prod |
|---------------------------|------------|---------------------------------------------------------------------|-------------------|
| `connectionTimeout`       | Connector  | Tiempo para recibir la primera línea de la petición HTTP            | `15000`-`20000` ms|
| `keepAliveTimeout`        | Connector  | Tiempo idle de una conexión keep-alive                              | `20000`-`60000` ms|
| `asyncTimeout`            | Connector  | Timeout para peticiones asíncronas (Servlet 3.x async)             | `30000` ms        |
| `connectionUploadTimeout` | Connector  | Timeout para uploads largos (si `disableUploadTimeout="false"`)     | `120000` ms       |
| `soTimeout`               | Connector  | Timeout de socket TCP a nivel de OS                                 | = `connectionTimeout`|
| `streamReadTimeout`       | Http2Protocol | Timeout de lectura de un stream HTTP/2                          | `20000` ms        |
| `streamWriteTimeout`      | Http2Protocol | Timeout de escritura de un stream HTTP/2                        | `20000` ms        |
| `keepAliveTimeout`        | Http2Protocol | Timeout de idle de conexión HTTP/2                              | `30000` ms        |
| `connectionTimeout`       | AJP        | Timeout de conexión AJP con Apache httpd                           | `20000` ms        |
| `session-timeout`         | web.xml    | Tiempo de expiración de la sesión HTTP (minutos)                    | `30` min          |
| `ProxyTimeout`            | Apache httpd| Timeout del proxy AJP/HTTP esperando respuesta de Tomcat           | `120` s           |

---

## 4.9 Monitorización de Conectores via JMX

Tomcat expone los conectores como MBeans JMX, lo que permite monitorizar en tiempo real métricas como el número de hilos activos, conexiones activas y peticiones por segundo.

```java
// Acceso programático a métricas del Connector via JMX
import javax.management.*;
import java.lang.management.ManagementFactory;

public class TomcatConnectorMonitor {

    public static void monitorConnector() throws Exception {
        MBeanServer mbeanServer = ManagementFactory.getPlatformMBeanServer();

        // ObjectName del Connector HTTP NIO
        ObjectName connectorName = new ObjectName(
            "Catalina:type=ThreadPool,name=\"http-nio-8080\""
        );

        // Métricas del pool de hilos
        int maxThreads       = (int) mbeanServer.getAttribute(connectorName, "maxThreads");
        int currentThreads   = (int) mbeanServer.getAttribute(connectorName, "currentThreadCount");
        int busyThreads      = (int) mbeanServer.getAttribute(connectorName, "currentThreadsBusy");
        int connectionCount  = (int) mbeanServer.getAttribute(connectorName, "connectionCount");
        long maxConnections  = (long) mbeanServer.getAttribute(connectorName, "maxConnections");

        System.out.printf("Connector http-nio-8080:%n");
        System.out.printf("  Max Threads:      %d%n", maxThreads);
        System.out.printf("  Current Threads:  %d%n", currentThreads);
        System.out.printf("  Busy Threads:     %d%n", busyThreads);
        System.out.printf("  Connections:      %d / %d%n", connectionCount, maxConnections);
        System.out.printf("  Thread Usage:     %.1f%%%n",
            (double) busyThreads / maxThreads * 100);

        // Métricas del GlobalRequestProcessor
        ObjectName requestName = new ObjectName(
            "Catalina:type=GlobalRequestProcessor,name=\"http-nio-8080\""
        );

        long requestCount    = (long) mbeanServer.getAttribute(requestName, "requestCount");
        long errorCount      = (long) mbeanServer.getAttribute(requestName, "errorCount");
        long bytesReceived   = (long) mbeanServer.getAttribute(requestName, "bytesReceived");
        long bytesSent       = (long) mbeanServer.getAttribute(requestName, "bytesSent");
        long processingTime  = (long) mbeanServer.getAttribute(requestName, "processingTime");

        System.out.printf("  Total Requests:   %d%n", requestCount);
        System.out.printf("  Error Count:      %d%n", errorCount);
        System.out.printf("  Bytes Received:   %d MB%n", bytesReceived / 1024 / 1024);
        System.out.printf("  Bytes Sent:       %d MB%n", bytesSent / 1024 / 1024);
        System.out.printf("  Avg Proc Time:    %.2f ms%n",
            requestCount > 0 ? (double) processingTime / requestCount : 0);
    }
}
```

### MBeans relevantes del Connector

| MBean ObjectName                                              | Atributos clave                                         |
|---------------------------------------------------------------|---------------------------------------------------------|
| `Catalina:type=ThreadPool,name="http-nio-8080"`               | `maxThreads`, `currentThreadsBusy`, `connectionCount`   |
| `Catalina:type=GlobalRequestProcessor,name="http-nio-8080"`   | `requestCount`, `errorCount`, `processingTime`          |
| `Catalina:type=Connector,port=8080,address="0.0.0.0"`         | `enableLookups`, `maxPostSize`, `URIEncoding`            |
| `Catalina:type=ThreadPool,name="http-nio-8443"`               | Mismos atributos para el conector HTTPS                 |
| `Catalina:type=ThreadPool,name="ajp-nio-8009"`                | Mismos atributos para el conector AJP                   |

---

## 4.10 Virtual Threads en Tomcat 11 (Project Loom)

Tomcat 11 con Java 21 introduce soporte para **Virtual Threads** (Project Loom), que permite un modelo de concurrencia masivo sin el overhead de los hilos del OS.

### 4.10.1 ¿Qué cambia con Virtual Threads?

```
Modelo tradicional (Platform Threads):
  Petición → Hilo OS (1 MB stack) → Bloqueado en I/O → Esperando
  Con 400 maxThreads: máximo 400 peticiones concurrentes

Modelo Virtual Threads (Tomcat 11 + Java 21):
  Petición → Virtual Thread (KB stack) → Suspendido en I/O (no bloquea OS thread)
  Con millones de Virtual Threads: concurrencia masiva sin overhead de OS
```

### 4.10.2 Configuración de Virtual Threads en Tomcat 11

```xml
<!--
  Executor con Virtual Threads — Tomcat 11 + Java 21+
  El atributo className apunta al executor de Virtual Threads.
  No tiene sentido configurar maxThreads ya que los VT son ilimitados.
-->
<Executor name="virtualThreadPool"
          className="org.apache.catalina.core.StandardVirtualThreadExecutor"
          namePrefix="virtual-exec-"/>

<Connector port="8080"
           protocol="org.apache.coyote.http11.Http11NioProtocol"
           executor="virtualThreadPool"
           connectionTimeout="20000"
           keepAliveTimeout="30000"
           maxConnections="100000"
           acceptCount="500"
           URIEncoding="UTF-8"
           compression="on"
           compressionMinSize="2048"/>
```

```bash
# setenv.sh: habilitar Virtual Threads en Java 21
# (no requiere flags especiales en Java 21, ya son estables)
export CATALINA_OPTS="$CATALINA_OPTS \
  -Xms1g \
  -Xmx4g \
  --enable-preview"
  # --enable-preview solo necesario en Java 19-20 (preview)
  # En Java 21 los Virtual Threads son estables, no requieren flag
```

### 4.10.3 Comparativa de rendimiento: Platform vs Virtual Threads

| Escenario                          | Platform Threads   | Virtual Threads      |
|------------------------------------|--------------------|----------------------|
| CPU-bound (cálculo puro)           | ✅ Igual rendimiento| ✅ Igual rendimiento |
| I/O-bound (BD, servicios externos) | ⚠️ Limitado por maxThreads | ✅ Escala masivamente |
| Uso de memoria por hilo            | ~1 MB por OS thread | ~few KB por VT       |
| Creación de hilos                  | Costosa (OS syscall)| Barata (JVM managed) |
| Debugging / Stack traces           | ✅ Completos        | ✅ Completos (Java 21)|
| Compatibilidad con código legacy   | ✅ Total            | ✅ Total (transparente)|

---

## 4.11 Diagnóstico y Troubleshooting de Conectores

### 4.11.1 Síntomas y soluciones comunes

```
SÍNTOMA: "Connection refused" en el puerto 8080
CAUSA:   Tomcat no arrancó correctamente o el conector falló al bindear el puerto
SOLUCIÓN:
  1. Verificar logs: tail -f $CATALINA_BASE/logs/catalina.out
  2. Verificar puerto ocupado: ss -tlnp | grep 8080
  3. Verificar permisos si port < 1024: necesita root o capabilities

SÍNTOMA: Respuestas muy lentas bajo carga
CAUSA:   Pool de hilos saturado (todos los hilos ocupados, queue llena)
SOLUCIÓN:
  1. Monitorizar via JMX: currentThreadsBusy vs maxThreads
  2. Aumentar maxThreads (con cuidado, no es la solución definitiva)
  3. Identificar requests lentas: StuckThreadDetectionValve
  4. Revisar tiempos de respuesta de BD/servicios externos

SÍNTOMA: "Too many open files" o "Cannot assign requested address"
CAUSA:   Límite de file descriptors del OS alcanzado
SOLUCIÓN:
  1. Verificar límite actual: ulimit -n
  2. Aumentar en /etc/security/limits.conf:
     tomcat soft nofile 65536
     tomcat hard nofile 65536
  3. En systemd: LimitNOFILE=65536

SÍNTOMA: javax.net.ssl.SSLHandshakeException en HTTPS
CAUSA:   Certificado caducado, protocolo TLS no soportado o cipher incompatible
SOLUCIÓN:
  1. Verificar certificado: openssl s_client -connect host:8443
  2. Verificar protocolos: comprobar SSLHostConfig protocols
  3. Verificar cipher suites del cliente vs servidor

SÍNTOMA: "AJP: Connection refused" desde Apache httpd
CAUSA:   Secret no coincide o dirección AJP no accesible
SOLUCIÓN:
  1. Verificar que el secret en mod_proxy_ajp coincide con requiredSecret
  2. Verificar address del conector AJP (127.0.0.1 vs 0.0.0.0)
  3. Verificar firewall/iptables entre Apache y Tomcat
```

### 4.11.2 Script de diagnóstico de conectores

```bash
#!/bin/bash
# diagnose-connectors.sh — Diagnóstico rápido de conectores Tomcat

TOMCAT_HOST="localhost"
HTTP_PORT=8080
HTTPS_PORT=8443
AJP_PORT=8009

echo "=== Diagnóstico de Conectores Tomcat ==="
echo ""

# 1. Verificar puertos en escucha
echo "--- Puertos en escucha ---"
ss -tlnp | grep -E "$HTTP_PORT|$HTTPS_PORT|$AJP_PORT|8005"

echo ""

# 2. Test HTTP básico
echo "--- Test HTTP ($HTTP_PORT) ---"
HTTP_CODE=$(curl -o /dev/null -s -w "%{http_code}" \
  --connect-timeout 5 \
  --max-time 10 \
  http://$TOMCAT_HOST:$HTTP_PORT/)
echo "HTTP Response Code: $HTTP_CODE"

# 3. Test HTTPS
echo ""
echo "--- Test HTTPS ($HTTPS_PORT) ---"
HTTPS_CODE=$(curl -k -o /dev/null -s -w "%{http_code}" \
  --connect-timeout 5 \
  --max-time 10 \
  https://$TOMCAT_HOST:$HTTPS_PORT/)
echo "HTTPS Response Code: $HTTPS_CODE"

# 4. Verificar certificado TLS
echo ""
echo "--- Certificado TLS ---"
echo | openssl s_client \
  -connect $TOMCAT_HOST:$HTTPS_PORT \
  -servername $TOMCAT_HOST \
  2>/dev/null | openssl x509 -noout \
  -subject -issuer -dates 2>/dev/null || echo "No se pudo conectar"

# 5. Verificar protocolo HTTP/2
echo ""
echo "--- Soporte HTTP/2 ---"
curl -k -s --http2 -o /dev/null \
  -w "HTTP version: %{http_version}\n" \
  https://$TOMCAT_HOST:$HTTPS_PORT/ 2>/dev/null || echo "HTTP/2 no disponible"

# 6. Cabeceras del servidor
echo ""
echo "--- Cabeceras del servidor ---"
curl -k -s -I https://$TOMCAT_HOST:$HTTPS_PORT/ 2>/dev/null | \
  grep -E "^(Server|X-Powered-By|Strict-Transport|Content-Type)"

echo ""
echo "=== Fin del diagnóstico ==="
```

---

## 4.12 Comparativa Final de Conectores

| Característica               | HTTP NIO   | HTTP NIO2  | HTTP APR   | AJP NIO    |
|------------------------------|------------|------------|------------|------------|
| Rendimiento general          | ✅ Alto     | ✅ Alto     | ✅✅ Máximo | ✅ Alto     |
| TLS/HTTPS                    | JSSE       | JSSE       | OpenSSL    | ❌          |
| HTTP/2                       | ✅ (ALPN)  | ✅ (ALPN)  | ✅ (ALPN)  | ❌          |
| Librerías nativas requeridas | ❌          | ❌          | ✅ APR     | ❌          |
| Complejidad de configuración | Baja       | Baja       | Alta       | Media      |
| Virtual Threads (T11)        | ✅          | ✅          | ❌          | ✅          |
| Uso recomendado              | Producción | Alternativa| TLS masivo | httpd proxy|
| Disponible en Tomcat 9+      | ✅          | ✅          | ✅          | ✅          |

---

## Puntos Clave del Módulo 04

- **NIO es el protocolo recomendado** para la inmensa mayoría de deployments de producción. NIO2 como alternativa. APR solo cuando el rendimiento TLS es el cuello de botella real.
- El protocolo **BIO fue eliminado en Tomcat 9**. Cualquier migración desde 8.0 debe actualizar la clase de protocolo del Connector.
- **HTTP/2** se activa via `UpgradeProtocol` anidado en el conector HTTPS. No es un protocolo independiente sino un upgrade sobre HTTP/1.1 + TLS.
- El **Server Push HTTP/2** se implementa via `PushBuilder` en la API de Servlet 4.0 (`jakarta.servlet.http.PushBuilder`).
- El conector **AJP requiere** `secretRequired="true"` y `address="127.0.0.1"` tras Ghostcat (CVE-2020-1938). Si no se usa, desactivarlo.
- La **RemoteIpValve** es imprescindible cuando Tomcat está detrás de un proxy inverso para obtener la IP real del cliente y el esquema HTTPS correcto.
- **Tomcat 11 + Java 21** permite usar `StandardVirtualThreadExecutor` para concurrencia masiva en workloads I/O-bound sin overhead de OS threads.
- Monitorizar siempre `currentThreadsBusy` vs `maxThreads` via JMX para detectar saturación del pool antes de que afecte a los usuarios.