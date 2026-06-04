> **Estado:** 🟢 Completo
> **Última actualización:** 2026-05
> **Nivel:** Principiante — se explican los conceptos desde cero

---

- [Módulo 04: Conectores HTTP/1.1, HTTP/2 y AJP](#módulo-04-conectores-http11-http2-y-ajp)
  - [4.1 Arquitectura Interna de los Conectores: Coyote](#41-arquitectura-interna-de-los-conectores-coyote)
    - [¿Qué es Coyote y qué problema resuelve?](#qué-es-coyote-y-qué-problema-resuelve)
    - [Componentes internos del Endpoint](#componentes-internos-del-endpoint)
  - [4.2 Implementaciones de Protocolo Disponibles](#42-implementaciones-de-protocolo-disponibles)
  - [4.3 Modelo BIO vs NIO vs NIO2 vs APR](#43-modelo-bio-vs-nio-vs-nio2-vs-apr)
    - [4.3.1 BIO — Blocking I/O (eliminado en Tomcat 9)](#431-bio--blocking-io-eliminado-en-tomcat-9)
    - [4.3.2 NIO — Non-Blocking I/O (recomendado)](#432-nio--non-blocking-io-recomendado)
    - [4.3.3 NIO2 — Asynchronous I/O](#433-nio2--asynchronous-io)
    - [4.3.4 APR — Apache Portable Runtime](#434-apr--apache-portable-runtime)
  - [4.4 Configuración Detallada del Conector HTTP/1.1 NIO](#44-configuración-detallada-del-conector-http11-nio)
    - [4.4.1 Atributos de red y conexión](#441-atributos-de-red-y-conexión)
    - [4.4.2 Tabla de atributos críticos para tuning de rendimiento](#442-tabla-de-atributos-críticos-para-tuning-de-rendimiento)
  - [4.5 HTTP/2 en Tomcat 8.5+](#45-http2-en-tomcat-85)
    - [¿Qué es HTTP/2 y qué mejora respecto a HTTP/1.1?](#qué-es-http2-y-qué-mejora-respecto-a-http11)
    - [4.5.1 ¿Cómo implementa Tomcat HTTP/2?](#451-cómo-implementa-tomcat-http2)
    - [4.5.2 Configuración HTTP/2 sobre HTTPS (h2)](#452-configuración-http2-sobre-https-h2)
    - [4.5.3 Configuración HTTP/2 cleartext (h2c) — Solo redes internas](#453-configuración-http2-cleartext-h2c--solo-redes-internas)
    - [4.5.4 Server Push HTTP/2 desde un Servlet](#454-server-push-http2-desde-un-servlet)
    - [4.5.5 Atributos Http2Protocol más relevantes](#455-atributos-http2protocol-más-relevantes)
  - [4.6 Conector AJP — Apache JServ Protocol](#46-conector-ajp--apache-jserv-protocol)
    - [¿Qué es AJP y cuándo tiene sentido usarlo?](#qué-es-ajp-y-cuándo-tiene-sentido-usarlo)
    - [4.6.1 La vulnerabilidad Ghostcat (CVE-2020-1938)](#461-la-vulnerabilidad-ghostcat-cve-2020-1938)
    - [4.6.2 Configuración completa del Conector AJP (post-Ghostcat)](#462-configuración-completa-del-conector-ajp-post-ghostcat)
    - [4.6.3 Configuración de Apache httpd con mod\_proxy\_ajp](#463-configuración-de-apache-httpd-con-mod_proxy_ajp)
    - [4.6.4 Configuración de mod\_jk (alternativa legacy)](#464-configuración-de-mod_jk-alternativa-legacy)
  - [4.7 Conector HTTP con Proxy Inverso (Nginx / HAProxy)](#47-conector-http-con-proxy-inverso-nginx--haproxy)
    - [¿Por qué poner Tomcat detrás de un proxy inverso?](#por-qué-poner-tomcat-detrás-de-un-proxy-inverso)
    - [4.7.1 Configuración Tomcat detrás de Nginx (HTTP proxy)](#471-configuración-tomcat-detrás-de-nginx-http-proxy)
    - [4.7.2 RemoteIpValve — Procesar las cabeceras del proxy en Tomcat](#472-remoteipvalve--procesar-las-cabeceras-del-proxy-en-tomcat)
    - [4.7.3 Conector HTTP optimizado para funcionar detrás de proxy](#473-conector-http-optimizado-para-funcionar-detrás-de-proxy)
  - [4.8 Gestión de Timeouts: Guía Completa](#48-gestión-de-timeouts-guía-completa)
  - [4.9 Monitorización de Conectores via JMX](#49-monitorización-de-conectores-via-jmx)
    - [¿Qué es JMX y por qué es útil para los Conectores?](#qué-es-jmx-y-por-qué-es-útil-para-los-conectores)
    - [MBeans relevantes del Connector](#mbeans-relevantes-del-connector)
  - [4.10 Virtual Threads en Tomcat 11 (Project Loom)](#410-virtual-threads-en-tomcat-11-project-loom)
    - [¿Qué son los Virtual Threads y por qué son importantes?](#qué-son-los-virtual-threads-y-por-qué-son-importantes)
    - [4.10.1 Configuración de Virtual Threads en Tomcat 11](#4101-configuración-de-virtual-threads-en-tomcat-11)
    - [4.10.2 ¿Cuándo conviene usar Virtual Threads?](#4102-cuándo-conviene-usar-virtual-threads)
  - [4.11 Diagnóstico y Troubleshooting de Conectores](#411-diagnóstico-y-troubleshooting-de-conectores)
    - [4.11.1 Síntomas y soluciones comunes](#4111-síntomas-y-soluciones-comunes)
    - [4.11.2 Script de diagnóstico de conectores](#4112-script-de-diagnóstico-de-conectores)
  - [4.12 Comparativa Final de Conectores](#412-comparativa-final-de-conectores)
  - [Puntos Clave](#puntos-clave)

---

# Módulo 04: Conectores HTTP/1.1, HTTP/2 y AJP

## 4.1 Arquitectura Interna de los Conectores: Coyote

### ¿Qué es Coyote y qué problema resuelve?

Cuando un navegador se conecta a Tomcat, alguien tiene que encargarse del trabajo "sucio" de la red: abrir el socket TCP, leer los bytes que llegan, interpretarlos como una petición HTTP, y al final serializar la respuesta de vuelta en bytes para enviarla.

Ese trabajo lo hace **Apache Coyote**, el componente de red de Tomcat. Coyote es completamente independiente del resto: no sabe nada de Servlets ni de JSPs. Su único trabajo es hablar la "lengua" de la red (TCP/IP + HTTP) y pasarle al Engine los objetos `Request` y `Response` ya construidos.

Esta separación es elegante: si mañana aparece un nuevo protocolo de red, solo hay que implementar un nuevo Coyote; el resto de Tomcat (Catalina, los Servlets, los Contexts) no necesita cambiar.

```
Cliente HTTP (navegador, app móvil, otra API)
     │
     ▼
┌─────────────────────────────────────────────────────┐
│                   COYOTE (Connector)                │
│                                                     │
│  ┌──────────────┐    ┌────────────────────────────┐ │
│  │  Endpoint    │    │   ProtocolHandler          │ │
│  │  (TCP/IP)    │───▶│   (HTTP/1.1, HTTP/2, AJP) │ │
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
                    (aquí viven tus Servlets y JSPs)
```

### Componentes internos del Endpoint

Dentro de Coyote hay varios subcomponentes con roles muy específicos:

| Componente  | Qué hace                                                                                    |
|-------------|---------------------------------------------------------------------------------------------|
| `Acceptor`  | Un hilo dedicado que "escucha" el puerto TCP y acepta nuevas conexiones del sistema operativo |
| `Poller`    | Uno o más hilos que monitorizan qué sockets tienen datos listos para leer (usando NIO Selector) |
| `Handler`   | Toma un socket con datos y lo despacha a un hilo del pool para procesarlo                    |
| `Processor` | Lee los bytes del socket, los interpreta como HTTP y construye los objetos `Request`/`Response` |

El flujo completo es: **Acceptor** acepta la conexión → **Poller** detecta que hay datos → **Handler** lo asigna a un hilo del pool → **Processor** parsea HTTP → **Catalina** ejecuta tu código.

---

## 4.2 Implementaciones de Protocolo Disponibles

Tomcat ofrece varias implementaciones del protocolo HTTP. La elección afecta al modelo de I/O utilizado y a las características disponibles:

| Clase del Protocolo                                      | Modelo I/O | HTTP/2 | Disponible  | Estado hoy    |
|----------------------------------------------------------|-----------|--------|-------------|---------------|
| `Http11BioProtocol`                                      | BIO       | ❌     | 8.0, 8.5    | ❌ Eliminado  |
| `Http11NioProtocol`                                      | NIO       | ✅*    | 8.0+        | ✅ Recomendado|
| `Http11Nio2Protocol`                                     | NIO2      | ✅*    | 8.0+        | ✅ Válido     |
| `Http11AprProtocol`                                      | APR/OS    | ✅*    | 8.0+        | ✅ Para TLS   |
| `Http11NioProtocol` + `Http2Protocol` (UpgradeProtocol)  | NIO       | ✅     | 8.5+        | ✅ Activo     |
| `AjpNioProtocol`                                         | NIO       | ❌     | 8.0+        | ✅ Activo     |
| `AjpNio2Protocol`                                        | NIO2      | ❌     | 8.5+        | ✅ Activo     |
| `AjpAprProtocol`                                         | APR/OS    | ❌     | 8.0+        | ✅ Activo     |

*HTTP/2 requiere añadir un elemento `UpgradeProtocol` dentro del Connector (ver sección 4.5).

---

## 4.3 Modelo BIO vs NIO vs NIO2 vs APR

Esta es una de las preguntas más frecuentes al configurar Tomcat: "¿Qué protocolo elijo?". Para responderla hay que entender qué hace cada uno.

### 4.3.1 BIO — Blocking I/O (eliminado en Tomcat 9)

**Modelo:** un hilo de Java por cada conexión activa.

```
Petición → Hilo dedicado (bloqueado durante toda la petición)
           ├── Lee cabeceras  [BLOQUEADO: espera a que lleguen los bytes]
           ├── Lee body       [BLOQUEADO: espera a que llegue el contenido]
           ├── Procesa        [usa CPU: ejecuta tu código]
           └── Escribe resp.  [BLOQUEADO: espera a que el cliente reciba los datos]
```

**El problema:** la mayor parte del tiempo un hilo BIO está bloqueado esperando datos de red, sin hacer nada útil. Si tienes 1.000 usuarios conectados simultáneamente, necesitas 1.000 hilos Java. Cada hilo consume aproximadamente 1 MB de memoria en su stack, así que son 1 GB solo en stacks de hilos. Y si quieres 10.000 usuarios concurrentes... 10 GB. No escala.

**Estado:** deprecado en Tomcat 8.5, **eliminado en Tomcat 9**. Si tienes `Http11BioProtocol` en tu `server.xml` y actualizas a Tomcat 9, el servidor no arrancará.

### 4.3.2 NIO — Non-Blocking I/O (recomendado)

**Modelo:** un pequeño conjunto de hilos gestiona miles de conexiones usando un mecanismo de eventos.

```
Petición → Acceptor (acepta la conexión TCP)
                │
                ▼
           Poller (Selector NIO)
           [vigila miles de sockets a la vez]
                │
                │ (llegan datos en este socket)
                ▼
           Pool de Hilos (solo cuando hay trabajo real que hacer)
                │
           Processor (parsea HTTP)
                │
           Engine.invoke() → tu Servlet
```

**La clave:** el `Selector` de Java NIO permite que un solo hilo vigile miles de sockets simultáneamente. Cuando en un socket hay datos disponibles, el selector lo detecta y asigna el socket a un hilo del pool solo durante el tiempo que tarda en procesar la petición. Cuando el hilo termina, vuelve al pool disponible para otras peticiones.

Resultado: con 25 hilos puedes gestionar 10.000 conexiones keep-alive activas. Los hilos solo trabajan cuando hay datos reales que procesar.

**Recomendado para la gran mayoría de deployments de producción.**

### 4.3.3 NIO2 — Asynchronous I/O

**Modelo:** similar a NIO, pero las operaciones de I/O son completamente asíncronas con callbacks.

NIO2 usa `AsynchronousSocketChannel` de Java 7+. La diferencia con NIO "clásico" es que en NIO el thread aún necesita llamar activamente a `select()` para preguntar "¿hay sockets con datos?". En NIO2, el sistema operativo notifica proactivamente cuando hay datos disponibles.

**¿Cuándo elegirlo sobre NIO?** En la práctica el rendimiento es muy similar. NIO2 puede tener ligeras ventajas en cargas con altísima tasa de conexiones nuevas por segundo (miles por segundo), pero para la mayoría de aplicaciones web la diferencia es imperceptible. Si tienes dudas, usa NIO.

### 4.3.4 APR — Apache Portable Runtime

**Modelo:** NIO, pero usando librerías nativas del sistema operativo en lugar de Java puro.

APR (Apache Portable Runtime) es una biblioteca en C que Tomcat puede usar en lugar de las APIs de red de Java. La ventaja principal es **OpenSSL** para el cifrado TLS: OpenSSL está altamente optimizado para operaciones criptográficas y puede ser significativamente más rápido que JSSE (la implementación TLS de Java) cuando el servidor hace muchas operaciones de cifrado/descifrado por segundo.

**¿Cuándo usarlo?** Cuando el análisis de rendimiento muestra que JSSE es el cuello de botella real (es decir, la CPU está saturada haciendo operaciones TLS). Para la mayoría de aplicaciones, JSSE con Java 11+ es suficientemente rápido.

**Requisito:** hay que compilar e instalar la librería `tomcat-native` en el servidor:

```bash
# Instalar dependencias de compilación en Ubuntu/Debian
sudo apt-get install -y libapr1 libapr1-dev libssl-dev

# Descomprimir las fuentes de tomcat-native
# (están dentro de $CATALINA_HOME/bin/tomcat-native.tar.gz)
cd $CATALINA_HOME/bin
tar -xzf tomcat-native.tar.gz
cd tomcat-native-*/native

# Compilar e instalar apuntando al APR del sistema y al JDK
./configure --with-apr=/usr/bin/apr-1-config \
            --with-java-home=$JAVA_HOME \
            --with-ssl=yes \
            --prefix=$CATALINA_HOME
make && make install

# Añadir en setenv.sh: decirle a Java dónde están las librerías nativas
export LD_LIBRARY_PATH="$CATALINA_HOME/lib:$LD_LIBRARY_PATH"
```

---

## 4.4 Configuración Detallada del Conector HTTP/1.1 NIO

### 4.4.1 Atributos de red y conexión

Este es el conector más usado en producción. A continuación, todos sus atributos más relevantes agrupados por categoría, con una explicación de para qué sirve cada uno y qué impacto tiene si lo ajustas:

```xml
<Connector port="8080"
           protocol="org.apache.coyote.http11.Http11NioProtocol"

           <!-- ===== Red: cómo escucha el puerto ===== -->
           address="0.0.0.0"
           <!-- 0.0.0.0: escuchar en todas las interfaces de red del servidor.
                Para mayor seguridad, especificar la IP concreta si solo
                debe ser accesible por una interfaz. -->

           bindOnInit="true"
           <!-- true: abrir el socket al inicializar el conector (antes de que
                arranquen las aplicaciones). false: abrirlo al arrancar.
                true da un error más temprano si el puerto ya está en uso. -->

           acceptorThreadCount="1"
           <!-- Número de hilos Acceptor. 1 es suficiente para la mayoría de casos.
                Solo aumentar si el servidor recibe >10.000 conexiones nuevas/segundo. -->

           acceptorThreadPriority="5"
           <!-- Prioridad del hilo Acceptor en la JVM (1=mínima, 10=máxima, 5=normal). -->

           pollerThreadCount="1"
           <!-- Número de hilos Poller (Selector NIO). Cada Poller puede gestionar
                miles de sockets. 1 es suficiente salvo cargas extremas. -->

           pollerThreadPriority="5"
           selectorTimeout="1000"
           <!-- Cuántos ms espera el Selector antes de hacer una comprobación
                de mantenimiento aunque no haya actividad. No cambiar normalmente. -->

           <!-- ===== Conexiones: comportamiento de las conexiones TCP ===== -->
           maxConnections="10000"
           <!-- Máximo de conexiones TCP simultáneas. Con NIO, Tomcat puede
                mantener muchas conexiones abiertas con pocos hilos. Este límite
                evita que un ataque sature los recursos de red del servidor. -->

           acceptCount="200"
           <!-- Tamaño de la cola del sistema operativo para conexiones en espera
                cuando maxConnections se ha alcanzado. Si esta cola también se llena,
                nuevas conexiones reciben "connection refused". -->

           connectionTimeout="20000"
           <!-- Tiempo máximo (ms) para que el cliente envíe la primera línea HTTP
                (ej: "GET /ruta HTTP/1.1") tras conectarse. Protege contra ataques
                Slowloris que abren conexiones y nunca envían datos completos. -->

           keepAliveTimeout="30000"
           <!-- HTTP keep-alive: reutiliza la misma conexión TCP para varias peticiones.
                Este valor es cuántos ms espera Tomcat la siguiente petición antes de
                cerrar la conexión. Reduce la latencia de recursos (CSS, JS, imágenes)
                porque no hay que negociar una nueva conexión TCP por cada uno. -->

           maxKeepAliveRequests="100"
           <!-- Máximo de peticiones en una misma conexión keep-alive.
                Pasado este número, Tomcat cierra la conexión aunque el cliente
                quiera seguir usándola. Evita que una sola conexión monopolice
                recursos durante demasiado tiempo. -->

           tcpNoDelay="true"
           <!-- Deshabilita el algoritmo de Nagle: no acumular pequeños paquetes TCP
                antes de enviarlos. Reduce latencia a costa de un poco más de ancho
                de banda. Casi siempre true para aplicaciones web. -->

           soLingerOn="false"
           <!-- Si true, el cierre de socket espera a que todos los datos sean
                enviados. false = cierre inmediato. Para HTTP/1.1 false es lo normal. -->

           soLingerTime="25"
           <!-- Tiempo de espera si soLingerOn="true". -->

           soTimeout="20000"
           <!-- Timeout del socket TCP a nivel del sistema operativo. -->

           useKeepAliveResponseHeader="true"
           <!-- Incluir la cabecera "Keep-Alive" en las respuestas para informar
                al cliente del timeout y número máximo de peticiones. -->

           <!-- ===== Hilos: el pool de procesamiento ===== -->
           maxThreads="400"
           <!-- Máximo de peticiones procesándose simultáneamente.
                Cada petición activa ocupa un hilo del pool.
                Demasiado bajo → peticiones esperan en cola bajo carga.
                Demasiado alto → demasiada memoria consumida en stacks de hilo.
                Regla de partida: núcleos_CPU × 50 para cargas I/O-bound. -->

           minSpareThreads="25"
           <!-- Hilos mínimos siempre en standby. Cuando llega una ráfaga de
                tráfico repentina, estos hilos reaccionan inmediatamente sin
                esperar a que el pool cree nuevos hilos (que tarda ~ms). -->

           maxSpareThreads="75"
           <!-- Si hay más hilos ociosos que este número, Tomcat los termina
                para liberar memoria. Evita desperdicio de recursos fuera
                de horas pico. -->

           threadPriority="5"
           <!-- Prioridad de los hilos del pool en la JVM. 5 = normal. -->

           prestartminSpareThreads="true"
           <!-- true: crear los minSpareThreads al arrancar el conector, no en
                la primera petición. Las primeras peticiones tienen mejor latencia. -->

           <!-- ===== HTTP: parsing y límites del protocolo ===== -->
           URIEncoding="UTF-8"
           <!-- Codificación para decodificar caracteres especiales en la URL.
                UTF-8 es imprescindible para URLs con caracteres no ASCII (ñ, á, etc.) -->

           useBodyEncodingForURI="false"
           <!-- false: usar siempre URIEncoding para la URL, independientemente
                de la codificación del body. Comportamiento estándar. -->

           maxHttpHeaderSize="16384"
           <!-- Tamaño máximo del bloque completo de cabeceras HTTP en bytes (16 KB).
                Protege contra ataques que envían cabeceras enormes para agotar
                la memoria del servidor. Aumentar si usas JWTs muy largos. -->

           maxHttpRequestHeaderSize="8192"
           <!-- Tamaño máximo de las cabeceras de petición (8 KB). -->

           maxHttpResponseHeaderSize="8192"
           <!-- Tamaño máximo de las cabeceras de respuesta (8 KB). -->

           maxPostSize="10485760"
           <!-- Tamaño máximo del body en peticiones POST (10 MB).
                Para subida de archivos grandes, aumentar este valor.
                -1 significa sin límite (no recomendado: DoS por subidas enormes). -->

           maxParameterCount="1000"
           <!-- Número máximo de parámetros en una petición HTTP.
                Protege contra el ataque "Hash Collision DoS": un atacante puede
                enviar miles de parámetros diseñados para causar colisiones en el
                HashMap interno de Tomcat, saturando la CPU. -->

           maxTrailerSize="8192"
           <!-- Tamaño máximo de los "trailers" HTTP (cabeceras al final del body
                en peticiones chunked). Raramente necesario cambiar. -->

           maxSavePostSize="4096"
           <!-- Tamaño máximo del body que Tomcat guarda temporalmente durante
                un redirect de autenticación para no perder los datos del POST. -->

           disableUploadTimeout="true"
           <!-- true: usar siempre connectionTimeout para todos los tipos de
                petición, incluyendo subidas de archivos.
                false: usar connectionUploadTimeout para subidas (más permisivo). -->

           connectionUploadTimeout="300000"
           <!-- Solo si disableUploadTimeout="false": timeout para subidas (5 min).
                Permite que subidas de archivos grandes no sean cortadas por timeout. -->

           <!-- ===== Compresión: reducir el tamaño de las respuestas ===== -->
           compression="on"
           <!-- Activa la compresión gzip/deflate automática de respuestas.
                Puede reducir el tamaño de HTML/JSON un 60-80%.
                El cliente debe incluir "Accept-Encoding: gzip" (todos los navegadores
                modernos lo hacen). -->

           compressionMinSize="2048"
           <!-- Solo comprimir respuestas de más de 2 KB. Comprimir respuestas
                pequeñas no merece la pena: el overhead de compresión es comparable
                al tamaño del dato. -->

           compressionLevel="6"
           <!-- Nivel de compresión gzip: 1=rápido/poco, 9=lento/mucho, 6=balance.
                En la mayoría de casos, niveles altos dan poco beneficio extra
                a costa de CPU. -->

           compressibleMimeType="text/html,text/xml,text/plain,
                                  text/css,text/javascript,
                                  application/json,application/xml,
                                  application/javascript,
                                  image/svg+xml"
           <!-- Solo comprimir estos tipos de contenido. No comprimir imágenes
                JPEG, PNG, videos, o ZIPs: ya están comprimidos y comprimirlos
                de nuevo no hace nada útil y solo gasta CPU. -->

           noCompressionUserAgents=""
           <!-- Expresión regular de User-Agents que no deben recibir respuestas
                comprimidas (clientes con bugs de compresión conocidos). -->

           <!-- ===== Proxy / Balanceador ===== -->
           scheme="http"
           <!-- El esquema de la URL tal como lo ve el cliente final.
                Si hay un proxy delante que hace SSL termination, este conector
                recibe HTTP pero el cliente usa HTTPS. Sin scheme="https", la
                aplicación pensaría que el cliente usa HTTP.
                Normalmente se configura via RemoteIpValve en lugar de aquí. -->

           secure="false"
           <!-- true: la conexión se considera segura (equivale a que es HTTPS). -->

           proxyName=""
           <!-- Nombre del servidor proxy para URLs absolutas y redirecciones. -->

           proxyPort="0"
           <!-- Puerto del proxy. 0 = usar el estándar (80/443 según scheme). -->

           <!-- ===== Seguridad ===== -->
           server="Apache"
           <!-- Valor de la cabecera HTTP "Server:" en las respuestas.
                Por defecto "Apache-Coyote/1.1" revela que el servidor usa Tomcat.
                "Apache" es más genérico y oculta información. "" elimina la cabecera. -->

           rejectIllegalHeader="true"
           <!-- Rechazar peticiones con cabeceras HTTP malformadas o con caracteres
                ilegales. Protege contra ciertos ataques de inyección de cabeceras. -->

           allowHostHeaderMismatch="false"
           <!-- Rechazar peticiones cuya cabecera Host: no coincide con ningún
                Host configurado. Protege contra Host Header Injection. -->

           allowedTrailerHeaders=""
           maxExtensionSize="8192"
           maxSwallowSize="2097152"
           <!-- Tamaño máximo del body que Tomcat puede "tragar" si la aplicación
                no lo lee completamente. Evita que conexiones grandes queden colgadas. -->

           redirectPort="8443"/>
```

### 4.4.2 Tabla de atributos críticos para tuning de rendimiento

| Atributo                 | Impacto en producción                                               | Valor recomendado  |
|--------------------------|---------------------------------------------------------------------|--------------------|
| `maxThreads`             | Máximo de peticiones procesándose en paralelo                       | `200`-`500`        |
| `minSpareThreads`        | Latencia de respuesta ante ráfagas de tráfico                       | `25`-`50`          |
| `maxConnections`         | Conexiones TCP simultáneas totales (activas + keep-alive inactivas) | `8000`-`15000`     |
| `acceptCount`            | Cola del SO cuando todos los hilos están ocupados                   | `100`-`300`        |
| `connectionTimeout`      | Tiempo hasta recibir la primera línea HTTP                          | `15000`-`20000` ms |
| `keepAliveTimeout`       | Tiempo idle antes de cerrar una conexión keep-alive                 | `20000`-`60000` ms |
| `maxKeepAliveRequests`   | Peticiones máximas por conexión keep-alive                          | `100`-`500`        |
| `maxPostSize`            | Tamaño máximo del body en POST (ajustar según negocio)              | ≥`10485760` (10 MB)|
| `maxParameterCount`      | Protección contra Hash Collision DoS                                | `500`-`2000`       |
| `compressionMinSize`     | Umbral para comprimir respuestas (no comprimir las muy pequeñas)    | `1024`-`4096` bytes|

---

## 4.5 HTTP/2 en Tomcat 8.5+

### ¿Qué es HTTP/2 y qué mejora respecto a HTTP/1.1?

HTTP/1.1 tiene una limitación fundamental: por cada conexión TCP solo puede haber una petición activa a la vez. Si el navegador necesita cargar una página con 20 recursos (CSS, JS, imágenes), tiene que abrir 6-8 conexiones paralelas al servidor y turnar las peticiones entre ellas. Esto introduce latencia y complejidad.

HTTP/2 resuelve esto con **multiplexación**: múltiples peticiones y respuestas pueden viajar simultáneamente sobre una única conexión TCP, entrelazadas como "streams" independientes. Ventajas:

- **Menos conexiones TCP:** una sola conexión por dominio en lugar de 6-8
- **Sin head-of-line blocking:** una petición lenta no retrasa a las demás
- **Server Push:** el servidor puede enviar recursos al cliente antes de que los pida
- **Compresión de cabeceras HPACK:** las cabeceras se comprimen, reduciendo overhead
- **Priorización de streams:** el servidor puede dar prioridad a ciertos recursos

### 4.5.1 ¿Cómo implementa Tomcat HTTP/2?

HTTP/2 en Tomcat no es un Connector independiente. Se implementa como un **UpgradeProtocol** que se añade dentro del Connector HTTPS existente. Cuando un cliente que soporta HTTP/2 se conecta, durante el handshake TLS negocia el protocolo via **ALPN** (Application-Layer Protocol Negotiation): básicamente, el cliente le dice al servidor "puedo hablar h2 o HTTP/1.1, ¿cuál prefieres?". Tomcat responde "h2" y ambos cambian a HTTP/2. Si el cliente no soporta HTTP/2, cae a HTTP/1.1 automáticamente, sin errores.

Hay dos variantes:
- **h2 (sobre TLS):** Lo recomendado. Requiere HTTPS.
- **h2c (cleartext):** HTTP/2 sin TLS. Solo para redes internas de confianza.

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
    UpgradeProtocol: añade soporte HTTP/2 a este conector.
    Tomcat detecta automáticamente si el cliente soporta h2 via ALPN
    durante el handshake TLS. Si no lo soporta, usa HTTP/1.1 normalmente.
  -->
  <UpgradeProtocol className="org.apache.coyote.http2.Http2Protocol"
                   keepAliveTimeout="30000"
                   <!-- Tiempo idle antes de cerrar una conexión HTTP/2 -->

                   readTimeout="30000"
                   writeTimeout="30000"

                   maxConcurrentStreams="200"
                   <!-- Máximo de peticiones HTTP/2 simultáneas sobre
                        una misma conexión TCP. El cliente (navegador)
                        respeta este límite. -->

                   maxConcurrentStreamExecution="200"
                   <!-- De esos streams concurrentes, cuántos pueden estar
                        ejecutándose activamente en un hilo al mismo tiempo. -->

                   maxHeaderCount="100"
                   <!-- Máximo de cabeceras HTTP por petición. Protección DoS. -->

                   maxHeaderSize="65536"
                   <!-- Tamaño máximo del bloque de cabeceras comprimidas (HPACK). -->

                   maxTrailerCount="100"
                   maxTrailerSize="65536"

                   initialWindowSize="65535"
                   <!-- Ventana de control de flujo HTTP/2: cuántos bytes puede
                        enviar el cliente antes de esperar confirmación.
                        65535 es el valor estándar. Aumentar mejora el throughput
                        en conexiones de alta latencia (intercontinentales). -->

                   maxSessionHeaderTableSize="4096"
                   <!-- Tamaño de la tabla HPACK para compresión de cabeceras.
                        Mayor tabla = mejor compresión = más memoria. -->

                   compressibleMimeTypes="text/html,text/xml,text/plain,
                                          text/css,text/javascript,
                                          application/json,application/xml"
                   compressionLevel="6"

                   streamReadTimeout="20000"
                   streamWriteTimeout="20000"
                   <!-- Timeouts por stream individual (diferente al timeout
                        de la conexión completa). -->

                   overheadContinuationThreshold="1024"
                   overheadDataThreshold="1024"
                   overheadWindowUpdateThreshold="1024"
                   overheadResetFactor="50"
                   overheadCountFactor="10"/>
                   <!-- Atributos de protección anti-DoS: penalizan conexiones
                        que envían muchos frames RST_STREAM, frames de control
                        vacíos u otro tráfico de overhead excesivo. -->

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
<!-- h2c: HTTP/2 sin TLS.
     El cliente envía una cabecera "Upgrade: h2c" en la primera petición HTTP/1.1.
     Tomcat acepta el upgrade y cambia el protocolo.
     SOLO usar en redes internas de confianza (comunicación entre microservicios,
     backend-to-backend). NUNCA exponer h2c en Internet: sin TLS los datos
     viajan en claro. -->
<Connector port="8080"
           protocol="org.apache.coyote.http11.Http11NioProtocol"
           connectionTimeout="20000"
           redirectPort="8443">

  <UpgradeProtocol className="org.apache.coyote.http2.Http2Protocol"
                   maxConcurrentStreams="100"
                   maxHeaderSize="32768"
                   initialWindowSize="65535"/>

</Connector>
```

### 4.5.4 Server Push HTTP/2 desde un Servlet

Una de las características más potentes de HTTP/2 es el **Server Push**: el servidor puede enviar recursos al cliente antes de que éste los pida. Por ejemplo, cuando el cliente pide `/index.html`, el servidor ya sabe que esa página necesita `app.css` y `app.js`, así que los envía proactivamente antes de que el navegador procese el HTML y descubra que los necesita.

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

        // PushBuilder: la API de Servlet 4.0 para Server Push.
        // Si la conexión es HTTP/1.1 (no HTTP/2), newPushBuilder() devuelve null,
        // así que siempre hay que comprobar null antes de usarlo.
        PushBuilder pushBuilder = request.newPushBuilder();

        if (pushBuilder != null) {
            // Push del CSS principal: Tomcat lo enviará al cliente ANTES de
            // que el navegador empiece a parsear el HTML y encuentre el <link>.
            // El navegador lo cachea y cuando llega el HTML, el CSS ya está disponible.
            pushBuilder.path("/static/css/app.css")
                       .addHeader("Content-Type", "text/css")
                       .push();

            // Push del JavaScript principal
            pushBuilder.path("/static/js/app.js")
                       .addHeader("Content-Type", "application/javascript")
                       .push();

            // Push de una imagen crítica (ej: el logo above-the-fold)
            pushBuilder.path("/static/img/logo.png")
                       .addHeader("Content-Type", "image/png")
                       .push();
        }

        // Generar la respuesta HTML principal (llega después de los push)
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

> 💡 **¿Cuándo usar Server Push?** Es útil para recursos críticos "above the fold" (lo que el usuario ve sin hacer scroll). No abuses: si pushes demasiados recursos, el navegador puede rechazarlos o el cliente puede ya tenerlos en caché. Un uso excesivo de push puede empeorar el rendimiento.

### 4.5.5 Atributos Http2Protocol más relevantes

| Atributo                       | Qué controla                                                               | Valor por defecto |
|--------------------------------|----------------------------------------------------------------------------|-------------------|
| `maxConcurrentStreams`         | Máximo de peticiones simultáneas por conexión TCP                          | `200`             |
| `maxConcurrentStreamExecution` | Streams ejecutándose activamente en hilos al mismo tiempo                  | `200`             |
| `maxHeaderCount`               | Cabeceras máximas por petición (protección DoS)                            | `100`             |
| `maxHeaderSize`                | Tamaño máximo del bloque de cabeceras HPACK en bytes                       | `65536`           |
| `initialWindowSize`            | Control de flujo: bytes que puede enviar el cliente antes de confirmación  | `65535`           |
| `keepAliveTimeout`             | Tiempo idle antes de cerrar la conexión HTTP/2                             | `20000` ms        |
| `streamReadTimeout`            | Timeout de lectura de un stream individual                                 | `20000` ms        |
| `overheadResetFactor`          | Penalización por frames RST_STREAM excesivos (protección DoS)              | `50`              |

---

## 4.6 Conector AJP — Apache JServ Protocol

### ¿Qué es AJP y cuándo tiene sentido usarlo?

AJP (Apache JServ Protocol v1.3) es un protocolo de comunicación **binario** entre un servidor web frontal (Apache httpd) y Tomcat. Es la alternativa al proxy HTTP estándar.

```
Usuarios de Internet
        │ HTTPS (puerto 443)
        ▼
  Apache httpd  ← gestiona TLS, archivos estáticos, virtual hosts
        │ AJP (protocolo binario, puerto 8009, red interna)
        ▼
    Tomcat  ← ejecuta las aplicaciones Java
```

**¿Por qué AJP en lugar de un proxy HTTP normal?**

- El protocolo binario de AJP es más eficiente que HTTP en texto para la comunicación interna
- AJP reenvía de forma nativa atributos SSL del cliente (certificado del cliente, algoritmo de cifrado negociado) que en un proxy HTTP hay que pasar manualmente como cabeceras
- Es el protocolo nativo de integración Apache httpd + Tomcat, con soporte maduro y bien probado

**¿Cuándo NO usar AJP?**
- Si usas **Nginx** como proxy → usa `proxy_pass` HTTP normal, Nginx no soporta AJP
- Si Tomcat está expuesto directamente (sin proxy) → usa HTTPS directo
- Si no tienes Apache httpd en el stack → deshabilita completamente el conector AJP

### 4.6.1 La vulnerabilidad Ghostcat (CVE-2020-1938)

En febrero de 2020 se descubrió una vulnerabilidad crítica en el conector AJP llamada **Ghostcat**. El problema: el protocolo AJP, por diseño, permite al proxy frontal decirle a Tomcat que incluya archivos del servidor en las peticiones. Esto se pensó para acceder a recursos del WAR. Pero sin autenticación, cualquiera que pudiera conectarse al puerto 8009 podía aprovechar este mecanismo para leer cualquier archivo del servidor, incluyendo `WEB-INF/web.xml` con credenciales de base de datos.

La gravedad era tal (score CVSS 9.8/10) que el equipo de Tomcat la parcheó con urgencia añadiendo autenticación obligatoria con secreto compartido.

### 4.6.2 Configuración completa del Conector AJP (post-Ghostcat)

```xml
<!--
  Conector AJP — Solo activar si se usa con Apache httpd via mod_proxy_ajp.
  Si no lo necesitas, elimina completamente este elemento de server.xml.
-->
<Connector protocol="AJP/1.3"
           address="127.0.0.1"
           <!-- CRÍTICO: solo aceptar conexiones desde la misma máquina.
                El AJP nunca debe ser accesible desde redes externas.
                Si Apache httpd está en otro servidor, usar la IP interna
                específica en lugar de 127.0.0.1. -->

           port="8009"
           redirectPort="8443"

           <!-- ===== Seguridad Ghostcat: OBLIGATORIO ===== -->
           secretRequired="true"
           <!-- true: Apache httpd DEBE autenticarse con un secreto
                compartido en cada petición AJP. Sin esto, cualquiera
                que pueda conectarse al puerto 8009 puede hacer peticiones. -->

           requiredSecret="${ajp.secret}"
           <!-- El secreto compartido, leído de una propiedad del sistema
                definida en setenv.sh. Debe coincidir EXACTAMENTE con
                el valor configurado en Apache httpd (ProxyPass secret=...).
                Usar una cadena larga y aleatoria (al menos 256 bits). -->

           <!-- ===== Timeouts ===== -->
           connectionTimeout="20000"
           <!-- Timeout para establecer la conexión AJP con Apache httpd. -->

           keepAliveTimeout="60000"
           <!-- Las conexiones AJP pueden mantenerse abiertas entre peticiones
                (keep-alive). Este valor define cuánto tiempo se mantienen
                antes de cerrarse. AJP usa keep-alive agresivo porque
                el overhead de abrir una nueva conexión TCP es importante
                para el rendimiento del proxy. -->

           maxKeepAliveRequests="-1"
           <!-- -1: sin límite de peticiones por conexión AJP.
                En mod_proxy_ajp, Apache gestiona el pool de conexiones. -->

           <!-- ===== Pool de hilos ===== -->
           maxThreads="200"
           minSpareThreads="10"
           acceptCount="100"
           maxConnections="5000"

           <!-- ===== Atributos AJP ===== -->
           tomcatAuthentication="false"
           <!-- false: delegar la autenticación a Apache httpd.
                Si Apache httpd ya autenticó al usuario (via mod_auth_ldap,
                mod_auth_basic, etc.), Tomcat confía en esa autenticación.
                Los datos del usuario autenticado llegan en atributos AJP. -->

           tomcatAuthorization="false"
           <!-- false: delegar la autorización también a Apache httpd. -->

           allowedRequestAttributesPattern="^(AJP_.*|SSL_.*|REMOTE_.*)$"
           <!-- Expresión regular que define qué atributos AJP acepta Tomcat
                de Apache httpd. Los atributos son datos extra que Apache
                puede añadir a la petición (IP real del cliente, detalles SSL).
                Limitar los atributos aceptados reduce la superficie de ataque. -->

           <!-- ===== Opciones de red ===== -->
           packetSize="8192"
           <!-- Tamaño máximo de los paquetes AJP en bytes. El valor estándar
                es 8192. Aumentar si tienes cabeceras HTTP muy grandes. -->

           URIEncoding="UTF-8"/>
```

### 4.6.3 Configuración de Apache httpd con mod_proxy_ajp

Esta es la configuración de Apache httpd que habla con Tomcat via AJP:

```apache
# /etc/apache2/sites-available/myapp.conf

<VirtualHost *:443>
    ServerName app.miempresa.com
    ServerAlias www.app.miempresa.com

    # Apache httpd gestiona TLS (Tomcat no necesita certificado)
    SSLEngine on
    SSLCertificateFile    /etc/ssl/certs/miempresa.crt
    SSLCertificateKeyFile /etc/ssl/private/miempresa.key
    SSLCertificateChainFile /etc/ssl/certs/ca-chain.pem

    SSLProtocol TLSv1.2 TLSv1.3
    SSLCipherSuite ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256

    # Cabeceras de seguridad HTTP (las añade Apache antes de enviar al cliente)
    Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains"
    Header always set X-Content-Type-Options "nosniff"
    Header always set X-Frame-Options "SAMEORIGIN"

    # Proxy AJP hacia Tomcat en la misma máquina.
    # ProxyPreserveHost On: pasar la cabecera Host original al backend.
    ProxyRequests Off
    ProxyPreserveHost On

    # ProxyPass: todas las peticiones van a Tomcat via AJP.
    # secret=... debe coincidir con requiredSecret en server.xml.
    ProxyPass        / ajp://127.0.0.1:8009/ secret=mi-secreto-ajp-seguro
    ProxyPassReverse / ajp://127.0.0.1:8009/

    ProxyTimeout 120

    # Balanceo de carga con múltiples nodos Tomcat (descomentar si necesitas):
    # <Proxy balancer://tomcatcluster>
    #     BalancerMember ajp://tomcat1:8009 route=node01 secret=mi-secreto
    #     BalancerMember ajp://tomcat2:8009 route=node02 secret=mi-secreto
    #     # stickysession: el balanceador lee el sufijo .node01/.node02
    #     # del JSESSIONID para siempre enviar al mismo usuario al mismo nodo
    #     ProxySet stickysession=JSESSIONID|jsessionid
    # </Proxy>
    # ProxyPass / balancer://tomcatcluster/
    # ProxyPassReverse / balancer://tomcatcluster/

    ErrorLog ${APACHE_LOG_DIR}/myapp-error.log
    CustomLog ${APACHE_LOG_DIR}/myapp-access.log combined

</VirtualHost>

# Redirección HTTP → HTTPS: cualquier acceso por HTTP se redirige a HTTPS
<VirtualHost *:80>
    ServerName app.miempresa.com
    Redirect permanent / https://app.miempresa.com/
</VirtualHost>
```

### 4.6.4 Configuración de mod_jk (alternativa legacy)

`mod_jk` es el módulo más antiguo para conectar Apache httpd con Tomcat via AJP. Ha sido reemplazado en gran medida por `mod_proxy_ajp` (más moderno y soportado), pero todavía se encuentra en instalaciones legacy:

```apache
# Cargar el módulo mod_jk
LoadModule jk_module /usr/lib/apache2/modules/mod_jk.so

# Archivo de definición de workers (los servidores Tomcat)
JkWorkersFile /etc/apache2/workers.properties

# Log de mod_jk
JkLogFile /var/log/apache2/mod_jk.log
JkLogLevel warn

# Enviar las peticiones de /myapp a Tomcat (worker1)
JkMount /myapp/* worker1
JkMount /myapp worker1

# No enviar los archivos estáticos a Tomcat (los sirve Apache directamente)
JkMountCopy On
JkUnMount  /static/* worker1
```

```properties
# /etc/apache2/workers.properties
# Define cómo conectarse a cada instancia de Tomcat

# Lista de workers disponibles
worker.list=worker1,jkstatus

# Worker "worker1": conexión a Tomcat en localhost
worker.worker1.type=ajp13
worker.worker1.host=127.0.0.1
worker.worker1.port=8009
worker.worker1.connection_pool_size=50      # Pool de conexiones AJP
worker.worker1.connection_pool_timeout=600  # Segundos antes de cerrar conexiones inactivas
worker.worker1.socket_timeout=300
worker.worker1.socket_keepalive=true
worker.worker1.secret=mi-secreto-ajp-seguro  # Debe coincidir con requiredSecret

# Worker de estado: interfaz web para monitorizar mod_jk
worker.jkstatus.type=status
worker.jkstatus.read_only=true
```

---

## 4.7 Conector HTTP con Proxy Inverso (Nginx / HAProxy)

### ¿Por qué poner Tomcat detrás de un proxy inverso?

En muchas arquitecturas, Tomcat no está directamente expuesto a Internet. En cambio, hay un **proxy inverso** (Nginx, HAProxy, un load balancer en la nube) que recibe el tráfico público y lo reenvía a Tomcat:

```
Internet
   │ HTTPS (443)
   ▼
 Nginx
   │ HTTP (8080, red interna)
   ▼
 Tomcat
```

Ventajas de este patrón:
- **SSL termination en el proxy:** el certificado TLS se gestiona en Nginx, Tomcat recibe tráfico HTTP sin cifrar (más simple de configurar y renovar certificados)
- **Archivos estáticos en el proxy:** Nginx sirve CSS, JS, imágenes directamente sin que pasen por Tomcat (mucho más eficiente)
- **Múltiples backends:** el proxy puede distribuir tráfico entre varios Tomcats
- **Protección adicional:** el proxy puede absorber ciertos ataques antes de que lleguen a la aplicación

**El problema que esto crea:** cuando Tomcat recibe la petición del proxy, la IP de origen es la del proxy (ej: 127.0.0.1), no la del cliente real. Y el esquema es HTTP aunque el cliente usara HTTPS. Tomcat necesita saber la verdad.

### 4.7.1 Configuración Tomcat detrás de Nginx (HTTP proxy)

Primero, la configuración de Nginx que añade las cabeceras necesarias:

```nginx
# Nginx reenvía peticiones a Tomcat añadiendo cabeceras informativas

upstream tomcat_backend {
    server 127.0.0.1:8080;
    keepalive 32;  # Pool de 32 conexiones keep-alive hacia Tomcat
}

server {
    listen 443 ssl http2;
    server_name app.miempresa.com;

    ssl_certificate     /etc/ssl/certs/miempresa.crt;
    ssl_certificate_key /etc/ssl/private/miempresa.key;
    ssl_protocols       TLSv1.2 TLSv1.3;
    ssl_ciphers         ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256;

    location / {
        proxy_pass         http://tomcat_backend;
        proxy_http_version 1.1;
        proxy_set_header   Connection          "";
        # Connection "" : necesario para que funcione el keepalive del upstream

        proxy_set_header   Host                $host;
        # Pasar el nombre de dominio original que pidió el cliente

        proxy_set_header   X-Real-IP           $remote_addr;
        # La IP real del cliente (no la del proxy)

        proxy_set_header   X-Forwarded-For     $proxy_add_x_forwarded_for;
        # Lista de IPs por las que ha pasado la petición (cliente, proxies intermedios)

        proxy_set_header   X-Forwarded-Proto   $scheme;
        # El protocolo que usó el cliente: "https"
        # Sin esto, Tomcat pensaría que el cliente usa HTTP

        proxy_set_header   X-Forwarded-Port    $server_port;
        # El puerto que usó el cliente: 443

        proxy_read_timeout 120s;    # Tiempo de espera de Nginx a Tomcat
        proxy_send_timeout 120s;
        proxy_connect_timeout 10s;

        proxy_buffering    on;      # Nginx almacena la respuesta de Tomcat
        proxy_buffer_size  16k;     # antes de enviarla al cliente. Esto permite
        proxy_buffers      8 16k;   # a Tomcat liberar el hilo más rápido.
    }

    # Nginx sirve los archivos estáticos directamente, sin pasar por Tomcat.
    # Tomcat no hace nada para /static/, ahorrando hilos y tiempo de procesamiento.
    location /static/ {
        alias /opt/apps/myapp/static/;
        expires 30d;
        add_header Cache-Control "public, immutable";
    }
}
```

### 4.7.2 RemoteIpValve — Procesar las cabeceras del proxy en Tomcat

Nginx añade las cabeceras `X-Forwarded-For` y `X-Forwarded-Proto`, pero Tomcat no las lee por defecto. El **RemoteIpValve** se encarga de leerlas y actualizar los objetos `Request` internos para que `request.getRemoteAddr()` devuelva la IP real del cliente (no la del proxy) y `request.isSecure()` devuelva `true` cuando el cliente usó HTTPS:

```xml
<!--
  RemoteIpValve: extraer la IP real del cliente y el esquema real
  de las cabeceras enviadas por el proxy.

  Sin este Valve:
  - request.getRemoteAddr() → devuelve 127.0.0.1 (IP del proxy)
  - request.isSecure() → devuelve false (Tomcat ve HTTP, no HTTPS)
  - Las URLs absolutas generadas por la aplicación usan http:// en lugar de https://
  - Las cookies con Secure=true no se envían nunca (el cliente "ve" HTTP)

  Con este Valve todo funciona correctamente.
-->
<Valve className="org.apache.catalina.valves.RemoteIpValve"
       remoteIpHeader="X-Forwarded-For"
       <!-- Nombre de la cabecera que contiene la IP real del cliente -->

       protocolHeader="X-Forwarded-Proto"
       <!-- Nombre de la cabecera que contiene el protocolo real (http/https) -->

       protocolHeaderHttpsValue="https"
       <!-- El valor de protocolHeader que indica HTTPS -->

       portHeader="X-Forwarded-Port"
       <!-- Cabecera que contiene el puerto real -->

       internalProxies="127\.0\.0\.1|192\.168\.0\.\d+|10\.0\.0\.\d+"
       <!-- IMPORTANTE: solo confiar en las cabeceras X-Forwarded-* si la
            petición viene de estas IPs. Si un cliente externo enviara
            X-Forwarded-For: 1.2.3.4 y su IP no está en internalProxies,
            la cabecera es ignorada como potencialmente manipulada. -->

       trustedProxies="172\.16\.0\.\d+"
       <!-- IPs de proxies intermedios de confianza (ej: load balancers externos) -->

       proxiesHeader="X-Forwarded-By"
       httpServerPort="8080"
       httpsServerPort="8443"
       changeLocalPort="true"
       requestAttributesEnabled="true"/>
```

### 4.7.3 Conector HTTP optimizado para funcionar detrás de proxy

Cuando hay un proxy delante, el Connector de Tomcat puede simplificarse: no necesita gestionar TLS (lo hace el proxy) y conviene que solo escuche en la IP interna:

```xml
<!--
  Tomcat detrás de proxy: escuchar solo en localhost.
  El proxy en la misma máquina conecta a 127.0.0.1:8080.
  Ningún cliente externo puede llegar directamente a Tomcat.
-->
<Connector port="8080"
           protocol="org.apache.coyote.http11.Http11NioProtocol"
           address="127.0.0.1"
           <!-- Escuchar solo en localhost: no accesible desde fuera del servidor -->

           connectionTimeout="20000"
           keepAliveTimeout="30000"
           maxThreads="400"
           minSpareThreads="25"
           maxConnections="10000"
           acceptCount="200"
           compression="off"
           <!-- IMPORTANTE: desactivar compresión aquí si el proxy ya comprime.
                Si tanto Tomcat como Nginx comprimen, estarías comprimiendo dos veces:
                Tomcat comprime → Nginx recibe datos comprimidos y los comprime de nuevo
                → cliente recibe datos doblemente comprimidos que no puede decodificar. -->

           URIEncoding="UTF-8"
           server="Apache"
           rejectIllegalHeader="true"/>
```

---

## 4.8 Gestión de Timeouts: Guía Completa

Los timeouts son una de las configuraciones más delicadas en producción. Un timeout demasiado corto causa errores innecesarios para usuarios con conexiones lentas o aplicaciones que procesan datos grandes. Un timeout demasiado largo hace que hilos y conexiones se queden bloqueados indefinidamente ante fallos, agotando los recursos del servidor.

Esta tabla reúne todos los timeouts relevantes:

| Timeout                      | Nivel          | Qué controla                                                            | Valor típico en producción |
|------------------------------|----------------|-------------------------------------------------------------------------|---------------------------|
| `connectionTimeout`          | Connector      | Tiempo para recibir la primera línea HTTP tras conectarse               | `15000`-`20000` ms        |
| `keepAliveTimeout`           | Connector      | Tiempo idle de una conexión keep-alive antes de cerrarla                | `20000`-`60000` ms        |
| `asyncTimeout`               | Connector      | Timeout para peticiones asíncronas (Servlet 3.x `startAsync()`)        | `30000` ms                |
| `connectionUploadTimeout`    | Connector      | Timeout para uploads largos (si `disableUploadTimeout="false"`)         | `120000` ms               |
| `soTimeout`                  | Connector      | Timeout del socket TCP a nivel del SO                                   | = `connectionTimeout`     |
| `streamReadTimeout`          | Http2Protocol  | Timeout de lectura de un stream HTTP/2 individual                       | `20000` ms                |
| `streamWriteTimeout`         | Http2Protocol  | Timeout de escritura de un stream HTTP/2 individual                     | `20000` ms                |
| `keepAliveTimeout`           | Http2Protocol  | Timeout de idle de la conexión HTTP/2 completa                          | `30000` ms                |
| `connectionTimeout`          | AJP Connector  | Timeout de la conexión AJP con Apache httpd                             | `20000` ms                |
| `session-timeout`            | web.xml        | Tiempo de expiración de la sesión HTTP del usuario (en minutos)         | `30` min                  |
| `ProxyTimeout`               | Apache httpd   | Tiempo que Apache espera respuesta de Tomcat antes de dar error 504     | `120` s                   |

> 💡 **Regla práctica para troubleshooting de timeouts:** Si ves errores HTTP 504 (Gateway Timeout), el timeout está en el proxy (Nginx/Apache). Si ves errores en los logs de Tomcat sobre "timed out", el problema está en los timeouts del Connector o de la aplicación.

---

## 4.9 Monitorización de Conectores via JMX

### ¿Qué es JMX y por qué es útil para los Conectores?

**JMX** (Java Management Extensions) es el sistema de monitorización y gestión de Java. Tomcat expone métricas en tiempo real de sus conectores como **MBeans** (Management Beans): objetos Java accesibles remotamente con herramientas como JConsole, VisualVM o sistemas de monitorización como Prometheus (via jmx_exporter).

Las métricas más importantes de un Connector son:
- **`currentThreadsBusy`**: hilos del pool actualmente procesando peticiones
- **`maxThreads`**: el límite configurado
- Si `currentThreadsBusy ≈ maxThreads` → el pool está saturado → hay peticiones esperando en cola → latencia alta

```java
// Acceso programático a métricas del Connector via JMX
// (útil para scripts de monitorización o alertas personalizadas)
import javax.management.*;
import java.lang.management.ManagementFactory;

public class TomcatConnectorMonitor {

    public static void monitorConnector() throws Exception {
        // Obtener el MBeanServer del proceso actual
        MBeanServer mbeanServer = ManagementFactory.getPlatformMBeanServer();

        // El ObjectName identifica el MBean del pool de hilos del conector HTTP
        // El formato es: Catalina:type=ThreadPool,name="protocolo-puerto"
        ObjectName connectorName = new ObjectName(
            "Catalina:type=ThreadPool,name=\"http-nio-8080\""
        );

        // Leer las métricas del pool de hilos
        int maxThreads      = (int) mbeanServer.getAttribute(connectorName, "maxThreads");
        int currentThreads  = (int) mbeanServer.getAttribute(connectorName, "currentThreadCount");
        int busyThreads     = (int) mbeanServer.getAttribute(connectorName, "currentThreadsBusy");
        int connectionCount = (int) mbeanServer.getAttribute(connectorName, "connectionCount");
        long maxConnections = (long) mbeanServer.getAttribute(connectorName, "maxConnections");

        System.out.printf("Connector http-nio-8080:%n");
        System.out.printf("  Hilos máximos:     %d%n", maxThreads);
        System.out.printf("  Hilos activos:     %d%n", currentThreads);
        System.out.printf("  Hilos ocupados:    %d%n", busyThreads);
        System.out.printf("  Conexiones:        %d / %d%n", connectionCount, maxConnections);
        System.out.printf("  Uso del pool:      %.1f%%%n",
            (double) busyThreads / maxThreads * 100);
        // Si este porcentaje está por encima del 80-90% con frecuencia,
        // considera aumentar maxThreads o investigar por qué las peticiones tardan.

        // Métricas globales de peticiones HTTP procesadas
        ObjectName requestName = new ObjectName(
            "Catalina:type=GlobalRequestProcessor,name=\"http-nio-8080\""
        );

        long requestCount   = (long) mbeanServer.getAttribute(requestName, "requestCount");
        long errorCount     = (long) mbeanServer.getAttribute(requestName, "errorCount");
        long bytesReceived  = (long) mbeanServer.getAttribute(requestName, "bytesReceived");
        long bytesSent      = (long) mbeanServer.getAttribute(requestName, "bytesSent");
        long processingTime = (long) mbeanServer.getAttribute(requestName, "processingTime");

        System.out.printf("  Peticiones totales: %d%n", requestCount);
        System.out.printf("  Errores:            %d (%.2f%%)%n",
            errorCount, requestCount > 0 ? (double) errorCount / requestCount * 100 : 0);
        System.out.printf("  Bytes recibidos:    %d MB%n", bytesReceived / 1024 / 1024);
        System.out.printf("  Bytes enviados:     %d MB%n", bytesSent / 1024 / 1024);
        System.out.printf("  Tiempo medio proc:  %.2f ms%n",
            requestCount > 0 ? (double) processingTime / requestCount : 0);
        // Si el tiempo medio de proceso es alto, el problema puede estar en
        // consultas a BD lentas, llamadas a servicios externos, o código lento.
    }
}
```

### MBeans relevantes del Connector

| MBean ObjectName                                              | Qué métricas da                                                    |
|---------------------------------------------------------------|--------------------------------------------------------------------|
| `Catalina:type=ThreadPool,name="http-nio-8080"`               | Estado del pool de hilos: ocupados, total, conexiones activas      |
| `Catalina:type=GlobalRequestProcessor,name="http-nio-8080"`   | Estadísticas de peticiones: total, errores, tiempos, bytes         |
| `Catalina:type=Connector,port=8080,address="0.0.0.0"`         | Configuración del Connector: URIEncoding, maxPostSize, etc.        |
| `Catalina:type=ThreadPool,name="http-nio-8443"`               | Igual para el conector HTTPS                                       |
| `Catalina:type=ThreadPool,name="ajp-nio-8009"`                | Igual para el conector AJP (si está activo)                        |

---

## 4.10 Virtual Threads en Tomcat 11 (Project Loom)

### ¿Qué son los Virtual Threads y por qué son importantes?

Para entenderlo, hay que entender primero el problema:

El modelo de Tomcat (NIO incluido) es **thread-per-request** para el procesamiento: cada petición, mientras se está ejecutando el código Java, ocupa un hilo del pool. Si ese código hace una consulta a la base de datos que tarda 50ms, el hilo del pool está bloqueado durante esos 50ms sin hacer nada útil.

Con `maxThreads=400`, si hay 400 peticiones simultáneas que están esperando respuesta de la BD, los 400 hilos están bloqueados. La petición 401 tiene que esperar aunque la CPU esté al 0% de uso.

**Los Virtual Threads** (Project Loom, Java 21) resuelven esto a nivel de JVM: cuando un Virtual Thread se bloquea esperando I/O (red, disco, BD), la JVM lo suspende automáticamente y libera el hilo del sistema operativo subyacente para que lo use otro Virtual Thread. Los Virtual Threads son millones de "hilos" gestionados por la JVM, muy baratos de crear y muy eficientes en memoria (kilobytes en lugar de megabytes por hilo).

```
Modelo tradicional (Platform Threads):
  400 peticiones simultáneas esperando BD
  → 400 OS threads bloqueados
  → Petición 401 espera en cola
  → Servidor "saturado" aunque la CPU esté al 5%

Modelo Virtual Threads (Tomcat 11 + Java 21):
  400.000 peticiones simultáneas esperando BD
  → 400.000 Virtual Threads suspendidos (no bloquean OS threads)
  → La petición 400.001 se atiende inmediatamente
  → Concurrencia masiva sin cambiar el código de la aplicación
```

La parte más importante: **el código de tu aplicación no necesita cambiar**. Sigues escribiendo código Java síncrono normal. La JVM se encarga de la magia debajo.

### 4.10.1 Configuración de Virtual Threads en Tomcat 11

```xml
<!--
  Executor con Virtual Threads — Tomcat 11 + Java 21+
  StandardVirtualThreadExecutor crea un nuevo Virtual Thread por cada petición.
  No tiene sentido configurar maxThreads: los VT son prácticamente ilimitados.
-->
<Executor name="virtualThreadPool"
          className="org.apache.catalina.core.StandardVirtualThreadExecutor"
          namePrefix="virtual-exec-"/>
          <!-- namePrefix: nombre visible en herramientas de monitorización -->

<Connector port="8080"
           protocol="org.apache.coyote.http11.Http11NioProtocol"
           executor="virtualThreadPool"
           connectionTimeout="20000"
           keepAliveTimeout="30000"
           maxConnections="100000"
           <!-- Con Virtual Threads puedes aumentar maxConnections drásticamente
                porque cada conexión consume muy pocos recursos. -->
           acceptCount="500"
           URIEncoding="UTF-8"
           compression="on"
           compressionMinSize="2048"/>
```

```bash
# En setenv.sh para Tomcat 11 con Java 21:
# Los Virtual Threads son estables en Java 21 y no requieren flags especiales.
# Solo necesitas Java 21+ y Tomcat 11+.
export CATALINA_OPTS="$CATALINA_OPTS \
  -Xms1g \
  -Xmx4g"
  # No se necesita --enable-preview: los VT son estables en Java 21
```

### 4.10.2 ¿Cuándo conviene usar Virtual Threads?

| Escenario                                      | Platform Threads             | Virtual Threads               |
|------------------------------------------------|------------------------------|-------------------------------|
| **CPU-bound** (cálculo matemático puro)        | ✅ Igual rendimiento          | ✅ Igual rendimiento           |
| **I/O-bound** (consultas BD, llamadas a APIs)  | ⚠️ Limitado por maxThreads   | ✅ Escala masivamente          |
| Uso de memoria por "hilo"                      | ~1 MB por OS thread          | ~few KB por VT                |
| Creación de un nuevo "hilo"                    | Costosa (syscall del SO)     | Barata (gestionada por JVM)   |
| Código legado (aplicaciones ya existentes)     | ✅ Compatible                 | ✅ Compatible sin cambios      |
| Herramientas de monitorización (stack traces)  | ✅ Completos                  | ✅ Completos en Java 21        |

> 💡 **En resumen:** si tu aplicación hace muchas operaciones de I/O (que es el caso típico: consultas a BD, llamadas a microservicios, lecturas de disco), los Virtual Threads son un cambio de paradigma. Si tu aplicación es CPU-bound (procesamiento de video, cálculo científico), los VT no aportan nada.

---

## 4.11 Diagnóstico y Troubleshooting de Conectores

### 4.11.1 Síntomas y soluciones comunes

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SÍNTOMA: "Connection refused" en el puerto 8080
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CAUSAS POSIBLES:
  a) Tomcat no arrancó correctamente
  b) El conector falló al abrir el puerto (puerto ya en uso)
  c) Tomcat escucha en una IP diferente (address="127.0.0.1" y conectas desde fuera)

DIAGNÓSTICO:
  1. Ver logs de arranque:       tail -f $CATALINA_BASE/logs/catalina.out
     Buscar "SEVERE" o "ERROR" cerca del arranque.
  2. Ver qué está en el puerto:  ss -tlnp | grep 8080
     Si hay otro proceso en el puerto, ese es el problema.
  3. Si el puerto está vacío, Tomcat no arrancó.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SÍNTOMA: Respuestas muy lentas bajo carga
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CAUSAS POSIBLES:
  a) Pool de hilos saturado (todos los hilos procesando peticiones)
  b) Consultas a BD lentas que bloquean los hilos
  c) Llamadas a servicios externos lentos o caídos

DIAGNÓSTICO:
  1. Monitorizar via JMX: comparar currentThreadsBusy vs maxThreads
     Si currentThreadsBusy ≈ maxThreads → pool saturado.
  2. Ver peticiones lentas en el log: StuckThreadDetectionValve muestra
     hilos que llevan >60s procesando.
  3. Activar SlowQueryReport en el DataSource para detectar queries lentas.

SOLUCIONES:
  - Si el pool está saturado: investigar por qué las peticiones son lentas
    (NO simplemente aumentar maxThreads sin entender la causa).
  - Aumentar maxThreads solo si las peticiones son genuinamente paralelas
    y tienen suficiente memoria disponible.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SÍNTOMA: "Too many open files" o "Cannot assign requested address"
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CAUSA: El sistema operativo limita el número de descriptores de archivo
(ficheros + sockets) que puede abrir un proceso. El límite por defecto en
Linux suele ser 1024, insuficiente para un servidor web con muchas conexiones.

DIAGNÓSTICO:
  ulimit -n    → muestra el límite actual del proceso

SOLUCIÓN:
  1. En /etc/security/limits.conf añadir:
     tomcat soft nofile 65536
     tomcat hard nofile 65536
  2. En el service de systemd añadir:
     LimitNOFILE=65536

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SÍNTOMA: javax.net.ssl.SSLHandshakeException en HTTPS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CAUSAS POSIBLES:
  a) Certificado caducado
  b) El cliente no soporta TLS 1.2/1.3 (cliente muy antiguo)
  c) Incompatibilidad de cipher suites entre cliente y servidor

DIAGNÓSTICO:
  # Ver el certificado del servidor y su fecha de caducidad:
  echo | openssl s_client -connect localhost:8443 2>/dev/null | \
    openssl x509 -noout -dates

  # Ver qué protocolos y ciphers negocia el servidor:
  openssl s_client -connect localhost:8443 -tls1_2
  openssl s_client -connect localhost:8443 -tls1_3

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SÍNTOMA: "AJP: Connection refused" desde Apache httpd
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CAUSAS POSIBLES:
  a) El secreto en Apache httpd no coincide con requiredSecret en Tomcat
  b) El conector AJP escucha en 127.0.0.1 pero Apache está en otro servidor
  c) Firewall bloqueando el puerto 8009

DIAGNÓSTICO:
  1. Verificar que el secreto es idéntico en ambos lados.
  2. Verificar el address del conector AJP:
     Si Apache y Tomcat están en máquinas diferentes, el address
     debe ser la IP de la interfaz interna, no 127.0.0.1.
  3. Verificar conectividad: nc -zv tomcat-host 8009
```

### 4.11.2 Script de diagnóstico de conectores

```bash
#!/bin/bash
# diagnose-connectors.sh — Diagnóstico rápido de conectores Tomcat
# Uso: ./diagnose-connectors.sh [host] [http_port] [https_port]

TOMCAT_HOST="${1:-localhost}"
HTTP_PORT="${2:-8080}"
HTTPS_PORT="${3:-8443}"

echo "=== Diagnóstico de Conectores Tomcat ==="
echo "Host: $TOMCAT_HOST | HTTP: $HTTP_PORT | HTTPS: $HTTPS_PORT"
echo ""

# 1. Verificar qué puertos están en escucha
echo "--- Puertos en escucha ---"
ss -tlnp | grep -E "$HTTP_PORT|$HTTPS_PORT|8009|8005"

echo ""

# 2. Test HTTP básico
echo "--- Test HTTP ($HTTP_PORT) ---"
HTTP_CODE=$(curl -o /dev/null -s -w "%{http_code}" \
  --connect-timeout 5 \
  --max-time 10 \
  http://$TOMCAT_HOST:$HTTP_PORT/)
echo "Código de respuesta HTTP: $HTTP_CODE"
# 200 = OK, 302/301 = redirección (normal), 000 = sin respuesta (Tomcat caído)

# 3. Test HTTPS
echo ""
echo "--- Test HTTPS ($HTTPS_PORT) ---"
HTTPS_CODE=$(curl -k -o /dev/null -s -w "%{http_code}" \
  --connect-timeout 5 \
  --max-time 10 \
  https://$TOMCAT_HOST:$HTTPS_PORT/)
echo "Código de respuesta HTTPS: $HTTPS_CODE"

# 4. Información del certificado TLS
echo ""
echo "--- Certificado TLS ---"
echo | openssl s_client \
  -connect $TOMCAT_HOST:$HTTPS_PORT \
  -servername $TOMCAT_HOST \
  2>/dev/null | openssl x509 -noout \
  -subject -issuer -dates 2>/dev/null || echo "No se pudo conectar o leer el certificado"

# 5. Verificar si HTTP/2 está activo
echo ""
echo "--- Soporte HTTP/2 ---"
HTTP_VERSION=$(curl -k -s --http2 -o /dev/null \
  -w "%{http_version}" \
  https://$TOMCAT_HOST:$HTTPS_PORT/ 2>/dev/null)
echo "Versión HTTP negociada: $HTTP_VERSION"
# "2" = HTTP/2 activo, "1.1" = HTTP/1.1

# 6. Cabeceras del servidor (comprobar que no revela la versión de Tomcat)
echo ""
echo "--- Cabeceras del servidor ---"
curl -k -s -I https://$TOMCAT_HOST:$HTTPS_PORT/ 2>/dev/null | \
  grep -E "^(Server|X-Powered-By|Strict-Transport|Content-Type)" || \
  echo "(No se pudo obtener cabeceras)"

echo ""
echo "=== Fin del diagnóstico ==="
```

---

## 4.12 Comparativa Final de Conectores

| Característica               | HTTP NIO          | HTTP NIO2         | HTTP APR          | AJP NIO            |
|------------------------------|-------------------|-------------------|-------------------|--------------------|
| Rendimiento general          | ✅ Alto            | ✅ Alto            | ✅✅ Máximo (TLS)  | ✅ Alto             |
| TLS/HTTPS nativo             | ✅ JSSE            | ✅ JSSE            | ✅ OpenSSL         | ❌ No aplica        |
| HTTP/2                       | ✅ (via ALPN)      | ✅ (via ALPN)      | ✅ (via ALPN)      | ❌ No soportado     |
| Librerías nativas requeridas | ❌ No              | ❌ No              | ✅ Sí (APR)        | ❌ No               |
| Complejidad de configuración | 🟢 Baja            | 🟢 Baja            | 🔴 Alta            | 🟡 Media            |
| Virtual Threads (Tomcat 11)  | ✅                 | ✅                 | ❌                 | ✅                  |
| Caso de uso recomendado      | Producción estándar| Alternativa a NIO | TLS de alto volumen| httpd proxy        |
| Disponible en Tomcat 9+      | ✅                 | ✅                 | ✅                 | ✅                  |

**Guía de elección rápida:**
- **La gran mayoría de casos:** HTTP NIO
- **Si necesitas máximo rendimiento TLS y puedes gestionar dependencias nativas:** HTTP APR
- **Si integras con Apache httpd como proxy frontal:** AJP NIO
- **Si usas Tomcat 11 con Java 21 y tienes carga I/O-bound:** Virtual Threads + HTTP NIO
- **Si ya tienes NIO y no tienes problemas:** no cambies nada

---

## Puntos Clave

- **NIO es el protocolo recomendado** para la inmensa mayoría de deployments de producción. NIO2 como alternativa prácticamente equivalente. APR solo si el análisis de rendimiento confirma que JSSE es el cuello de botella.

- El protocolo **BIO fue eliminado en Tomcat 9**. Cualquier migración desde Tomcat 8.0 con `Http11BioProtocol` debe cambiar a NIO o NIO2 antes de actualizar.

- **HTTP/2** no es un Connector independiente: se activa añadiendo un elemento `<UpgradeProtocol>` dentro del Connector HTTPS. Tomcat negocia h2 vs HTTP/1.1 automáticamente via ALPN según lo que soporte el cliente.

- El **Server Push HTTP/2** se implementa en el Servlet usando `request.newPushBuilder()`. Antes de usarlo, comprobar siempre que no es `null` (el cliente puede no soportar HTTP/2).

- El conector **AJP requiere** `secretRequired="true"` y `address="127.0.0.1"` tras la vulnerabilidad Ghostcat (CVE-2020-1938). Si no se usa Apache httpd como proxy, eliminar completamente el Connector AJP de `server.xml`.

- La **RemoteIpValve** es imprescindible cuando Tomcat está detrás de un proxy inverso. Sin ella, `request.getRemoteAddr()` devuelve la IP del proxy y `request.isSecure()` devuelve `false` aunque el cliente use HTTPS, rompiendo cookies seguras y redirecciones.

- **Tomcat 11 + Java 21** permite usar `StandardVirtualThreadExecutor` para concurrencia masiva en workloads I/O-bound (que es el caso más común en aplicaciones web) sin necesidad de cambiar el código de las aplicaciones.

- Monitorizar siempre **`currentThreadsBusy` vs `maxThreads`** via JMX. Si el ratio supera el 80-90% frecuentemente, el pool está cerca de saturarse e impactará la latencia de los usuarios. El umbral crítico no es el 100% sino el momento en que las peticiones empiezan a esperar en la cola (`acceptCount`).