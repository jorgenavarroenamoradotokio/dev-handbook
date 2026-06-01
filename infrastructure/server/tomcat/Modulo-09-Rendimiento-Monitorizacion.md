> **Estado:** 🟢 Completo
> **Última actualización:** 2026-05
> **Nivel:** Principiante — se explican los conceptos desde cero

---

- [Módulo 09: Rendimiento, Tuning y Monitorización con JMX](#módulo-09-rendimiento-tuning-y-monitorización-con-jmx)
  - [9.1 Metodología de Tuning: Enfoque Sistemático](#91-metodología-de-tuning-enfoque-sistemático)
    - [Jerarquía de cuellos de botella (en orden de frecuencia)](#jerarquía-de-cuellos-de-botella-en-orden-de-frecuencia)
  - [9.2 Tuning de la JVM](#92-tuning-de-la-jvm)
    - [9.2.1 Configuración de Heap y Garbage Collector](#921-configuración-de-heap-y-garbage-collector)
    - [9.2.2 Comparativa de Garbage Collectors para Tomcat](#922-comparativa-de-garbage-collectors-para-tomcat)
  - [9.3 Tuning del Conector HTTP](#93-tuning-del-conector-http)
    - [9.3.1 Dimensionamiento del pool de hilos](#931-dimensionamiento-del-pool-de-hilos)
    - [9.3.2 Análisis de keep-alive vs nuevas conexiones](#932-análisis-de-keep-alive-vs-nuevas-conexiones)
  - [9.4 Tuning de JSP y Recursos Estáticos](#94-tuning-de-jsp-y-recursos-estáticos)
    - [9.4.1 Pre-compilación de JSPs](#941-pre-compilación-de-jsps)
    - [9.4.2 Caché de recursos estáticos del DefaultServlet](#942-caché-de-recursos-estáticos-del-defaultservlet)
  - [9.5 Monitorización con JMX](#95-monitorización-con-jmx)
    - [9.5.1 Configuración de JMX Remoto](#951-configuración-de-jmx-remoto)
    - [9.5.2 Catálogo completo de MBeans de Tomcat](#952-catálogo-completo-de-mbeans-de-tomcat)
  - [9.6 Profiling con Java Flight Recorder (JFR)](#96-profiling-con-java-flight-recorder-jfr)
    - [9.6.1 Uso de JFR](#961-uso-de-jfr)
    - [9.6.2 Análisis de JFR con jfr CLI](#962-análisis-de-jfr-con-jfr-cli)
  - [9.7 Herramientas de Load Testing](#97-herramientas-de-load-testing)
    - [9.7.1 Apache JMeter — Plan de prueba para Tomcat](#971-apache-jmeter--plan-de-prueba-para-tomcat)
    - [9.7.2 wrk — Load testing de alto rendimiento](#972-wrk--load-testing-de-alto-rendimiento)
  - [9.8 Integración con Prometheus y Grafana](#98-integración-con-prometheus-y-grafana)
    - [9.8.1 Exposición de métricas con JMX Exporter](#981-exposición-de-métricas-con-jmx-exporter)
    - [9.8.2 Dashboard Grafana — Métricas clave](#982-dashboard-grafana--métricas-clave)
  - [9.9 Script de Diagnóstico de Rendimiento Completo](#99-script-de-diagnóstico-de-rendimiento-completo)
  - [9.10 Tabla de Referencia Rápida de Tuning](#910-tabla-de-referencia-rápida-de-tuning)
    - [Valores recomendados según carga](#valores-recomendados-según-carga)
  - [9.11 Diferencias de Rendimiento y Monitorización entre Versiones](#911-diferencias-de-rendimiento-y-monitorización-entre-versiones)
  - [Puntos Clave](#puntos-clave)

---

# Módulo 09: Rendimiento, Tuning y Monitorización con JMX

## 9.1 Metodología de Tuning: Enfoque Sistemático

El tuning de Tomcat no es un conjunto de valores mágicos aplicables universalmente. Es un proceso iterativo de medición, análisis, ajuste y validación. Aplicar configuraciones de rendimiento sin medición previa es contraproducente.

```
┌─────────────────────────────────────────────────────────────────┐
│              Ciclo de Tuning de Tomcat                          │
│                                                                 │
│  1. MEDIR    → Establecer baseline con carga real               │
│       ↓                                                         │
│  2. ANALIZAR → Identificar el cuello de botella real            │
│       ↓                                                         │
│  3. AJUSTAR  → Modificar UN parámetro a la vez                  │
│       ↓                                                         │
│  4. VALIDAR  → Medir de nuevo con la misma carga                │
│       ↓                                                         │
│  5. DOCUMENTAR → Registrar cambios y resultados                 │
│       └──────────────────────────────────────────┐              │
│                                                  ▼              │
│                                         ¿Mejora suficiente?     │
│                                         Sí → Producción         │
│                                         No → Paso 2             │
└─────────────────────────────────────────────────────────────────┘
```

### Jerarquía de cuellos de botella (en orden de frecuencia)

```
1. Base de datos          → Queries lentas, pool exhausto, locks
2. JVM Heap / GC          → GC pauses largas, memory leaks
3. Pool de hilos          → maxThreads saturado, queue llena
4. I/O de red             → Latencia, buffers inadecuados
5. CPU                    → Código ineficiente, serialización
6. Configuración Tomcat   → Timeouts, compresión, keep-alive
```

---

## 9.2 Tuning de la JVM

### 9.2.1 Configuración de Heap y Garbage Collector

```bash
#!/bin/bash
# $CATALINA_BASE/bin/setenv.sh — Tuning JVM Producción

# ============================================================
# HEAP SIZING
# Regla general: Xms = Xmx para evitar expansión dinámica
# Máximo recomendado: 75-80% de la RAM disponible del servidor
# Dejar margen para: OS, Metaspace, Direct Memory, Stack threads
# ============================================================

# Servidor con 8 GB RAM → Heap 6 GB
CATALINA_OPTS="$CATALINA_OPTS -Xms6g"
CATALINA_OPTS="$CATALINA_OPTS -Xmx6g"

# Metaspace (clases cargadas, reflections, proxies)
CATALINA_OPTS="$CATALINA_OPTS -XX:MetaspaceSize=256m"
CATALINA_OPTS="$CATALINA_OPTS -XX:MaxMetaspaceSize=512m"

# Direct Memory (NIO buffers, off-heap)
CATALINA_OPTS="$CATALINA_OPTS -XX:MaxDirectMemorySize=1g"

# Stack size por hilo (reducir si se tienen muchos hilos)
CATALINA_OPTS="$CATALINA_OPTS -Xss512k"

# ============================================================
# GARBAGE COLLECTOR
# ============================================================

# --- G1GC (Java 9+ default, recomendado para la mayoría) ---
CATALINA_OPTS="$CATALINA_OPTS -XX:+UseG1GC"

# Objetivo de pausa máxima GC (ms) — NOT a hard guarantee
CATALINA_OPTS="$CATALINA_OPTS -XX:MaxGCPauseMillis=200"

# Tamaño de región G1 (auto si no se configura, o potencia de 2: 1-32 MB)
CATALINA_OPTS="$CATALINA_OPTS -XX:G1HeapRegionSize=16m"

# % del heap que activa GC concurrente
CATALINA_OPTS="$CATALINA_OPTS -XX:InitiatingHeapOccupancyPercent=45"

# % de nuevo espacio en el heap G1
CATALINA_OPTS="$CATALINA_OPTS -XX:G1NewSizePercent=20"
CATALINA_OPTS="$CATALINA_OPTS -XX:G1MaxNewSizePercent=40"

# Reserva de heap para manejo de objetos grandes
CATALINA_OPTS="$CATALINA_OPTS -XX:G1ReservePercent=10"

# Deduplicación de Strings (ahorra memoria en apps con muchos Strings repetidos)
CATALINA_OPTS="$CATALINA_OPTS -XX:+UseStringDeduplication"

# --- ZGC (Java 15+ estable — ultra-low latency, pauses < 1ms) ---
# CATALINA_OPTS="$CATALINA_OPTS -XX:+UseZGC"
# CATALINA_OPTS="$CATALINA_OPTS -XX:+ZGenerational"  # Java 21+

# --- Shenandoah GC (OpenJDK — low latency alternative) ---
# CATALINA_OPTS="$CATALINA_OPTS -XX:+UseShenandoahGC"

# ============================================================
# GC LOGGING (Java 9+ Unified Logging)
# ============================================================
CATALINA_OPTS="$CATALINA_OPTS -Xlog:gc*,gc+heap=debug,gc+phases=debug\
:file=${CATALINA_BASE}/logs/gc.log\
:time,uptime,level,tags\
:filecount=10,filesize=50m"

# ============================================================
# JIT COMPILER
# ============================================================
CATALINA_OPTS="$CATALINA_OPTS -server"
CATALINA_OPTS="$CATALINA_OPTS -XX:+OptimizeStringConcat"
CATALINA_OPTS="$CATALINA_OPTS -XX:+UseCompressedOops"
CATALINA_OPTS="$CATALINA_OPTS -XX:+UseCompressedClassPointers"

# Número de hilos del compilador JIT (C2)
CATALINA_OPTS="$CATALINA_OPTS -XX:CICompilerCount=4"

# ============================================================
# DIAGNÓSTICO Y SAFETY NETS
# ============================================================

# Heap dump automático en OutOfMemoryError
CATALINA_OPTS="$CATALINA_OPTS -XX:+HeapDumpOnOutOfMemoryError"
CATALINA_OPTS="$CATALINA_OPTS -XX:HeapDumpPath=${CATALINA_BASE}/logs/"

# Acción en OOM: matar el proceso para que el supervisor lo reinicie
CATALINA_OPTS="$CATALINA_OPTS -XX:OnOutOfMemoryError='kill -9 %p'"

# NMT (Native Memory Tracking) — para diagnosticar uso de memoria nativa
# CATALINA_OPTS="$CATALINA_OPTS -XX:NativeMemoryTracking=summary"

# Flight Recorder (JFR) — perfilado continuo con overhead mínimo
CATALINA_OPTS="$CATALINA_OPTS -XX:+FlightRecorder"
CATALINA_OPTS="$CATALINA_OPTS -XX:StartFlightRecording=\
duration=0,\
filename=${CATALINA_BASE}/logs/tomcat.jfr,\
settings=profile,\
maxsize=256m,\
maxage=24h"

# ============================================================
# ENCODING Y TIMEZONE
# ============================================================
CATALINA_OPTS="$CATALINA_OPTS -Dfile.encoding=UTF-8"
CATALINA_OPTS="$CATALINA_OPTS -Dsun.jnu.encoding=UTF-8"
CATALINA_OPTS="$CATALINA_OPTS -Duser.timezone=Europe/Madrid"

# Generador de números aleatorios no bloqueante (Linux)
CATALINA_OPTS="$CATALINA_OPTS -Djava.security.egd=file:/dev/./urandom"

# DNS TTL
CATALINA_OPTS="$CATALINA_OPTS -Dsun.net.inetaddr.ttl=60"

export CATALINA_OPTS
```

### 9.2.2 Comparativa de Garbage Collectors para Tomcat

| GC         | Latencia | Throughput | Pausa máx | Java min | Uso recomendado                    |
|------------|----------|------------|-----------|----------|------------------------------------|
| G1GC       | Media    | Alto       | ~200ms    | Java 9   | Producción general (default)       |
| ZGC        | Muy baja | Medio-alto | <1ms      | Java 15  | APIs de baja latencia              |
| Shenandoah | Muy baja | Medio      | <1ms      | Java 12  | Alternativa a ZGC (OpenJDK)        |
| ParallelGC | Alta     | Muy alto   | Variable  | Java 8   | Batch processing, sin UI           |
| SerialGC   | Variable | Bajo       | Variable  | Java 8   | Solo para JVMs con 1 CPU           |

---

## 9.3 Tuning del Conector HTTP

### 9.3.1 Dimensionamiento del pool de hilos

```
Fórmula para maxThreads:
─────────────────────────────────────────────────────────
maxThreads = (TPS_objetivo × T_medio_respuesta_segundos)
             + margen_seguridad (20-30%)

Ejemplo:
  TPS objetivo:          500 req/s
  Tiempo medio resp:     0.2 s (200ms)
  Hilos necesarios:      500 × 0.2 = 100 hilos activos
  Con 25% margen:        125 hilos
  maxThreads recomendado: 150-200

IMPORTANTE:
  - Aumentar maxThreads NO mejora el throughput si el cuello
    de botella es la BD o el CPU
  - Más hilos = más memoria (Xss por hilo)
  - 200-400 hilos: rango típico de producción
  - >500 hilos: revisar si el problema es otro
─────────────────────────────────────────────────────────
```

```xml
<!-- Conector HTTP optimizado para producción -->
<Executor name="tomcatThreadPool"
          namePrefix="catalina-exec-"
          maxThreads="300"
          minSpareThreads="30"
          maxSpareThreads="100"
          maxQueueSize="200"
          prestartminSpareThreads="true"
          maxIdleTime="60000"
          threadPriority="5"
          daemon="true"
          className="org.apache.catalina.core.StandardThreadExecutor"/>

<Connector port="8080"
           protocol="org.apache.coyote.http11.Http11NioProtocol"
           executor="tomcatThreadPool"

           <!-- Conexiones -->
           maxConnections="10000"
           acceptCount="300"
           connectionTimeout="15000"
           keepAliveTimeout="20000"
           maxKeepAliveRequests="200"

           <!-- HTTP -->
           URIEncoding="UTF-8"
           maxHttpHeaderSize="16384"
           maxPostSize="10485760"
           maxParameterCount="1000"

           <!-- Compresión (solo si no hay proxy que comprima) -->
           compression="on"
           compressionMinSize="1024"
           compressibleMimeType="text/html,text/xml,text/plain,
                                  text/css,text/javascript,
                                  application/json,application/xml,
                                  application/javascript"

           <!-- Seguridad -->
           server="Apache"
           rejectIllegalHeader="true"

           <!-- NIO específico -->
           acceptorThreadCount="2"
           pollerThreadCount="2"
           selectorTimeout="1000"

           redirectPort="8443"/>
```

### 9.3.2 Análisis de keep-alive vs nuevas conexiones

```bash
# Monitorizar el estado de las conexiones TCP
# Para entender si keep-alive está funcionando correctamente

# Ver conexiones al puerto 8080
ss -tn state established '( dport = :8080 or sport = :8080 )'

# Estadísticas de estado TCP
ss -s

# Ver conexiones TIME_WAIT acumuladas (indica keep-alive no efectivo)
ss -tn | grep TIME-WAIT | wc -l

# Si hay muchas TIME_WAIT, considerar aumentar keepAliveTimeout
# o configurar en el OS:
echo 1    > /proc/sys/net/ipv4/tcp_tw_reuse
echo 30   > /proc/sys/net/ipv4/tcp_fin_timeout
echo 2    > /proc/sys/net/ipv4/tcp_keepalive_time
```

---

## 9.4 Tuning de JSP y Recursos Estáticos

### 9.4.1 Pre-compilación de JSPs

```xml
<!-- Evitar compilación en caliente de JSPs en producción -->
<!-- En conf/web.xml global de Tomcat -->
<servlet>
    <servlet-name>jsp</servlet-name>
    <servlet-class>org.apache.jasper.servlet.JspServlet</servlet-class>
    <init-param>
        <!-- FALSO en producción: no recompilar si cambia la JSP -->
        <param-name>development</param-name>
        <param-value>false</param-value>
    </init-param>
    <init-param>
        <!-- Eliminar espacios en blanco de la salida -->
        <param-name>trimSpaces</param-name>
        <param-value>true</param-value>
    </init-param>
    <init-param>
        <!-- Pool de expresiones EL -->
        <param-name>enablePooling</param-name>
        <param-value>true</param-value>
    </init-param>
    <init-param>
        <!-- Generar métodos separados para fragmentos grandes -->
        <param-name>genStrAsCharArray</param-name>
        <param-value>false</param-value>
    </init-param>
    <init-param>
        <!-- Target JVM -->
        <param-name>compilerTargetVM</param-name>
        <param-value>17</param-value>
    </init-param>
    <init-param>
        <param-name>compilerSourceVM</param-name>
        <param-value>17</param-value>
    </init-param>
    <load-on-startup>3</load-on-startup>
</servlet>
```

```bash
# Pre-compilar JSPs con JspC durante el build (Maven/Gradle)
# Esto elimina la latencia de la primera petición a cada JSP

# Con Maven usando el plugin de Tomcat
mvn tomcat7:deploy

# Manualmente con JspC
$JAVA_HOME/bin/java \
  -classpath "$CATALINA_HOME/lib/jasper.jar:\
              $CATALINA_HOME/lib/jsp-api.jar:\
              $CATALINA_HOME/lib/el-api.jar:\
              $CATALINA_HOME/lib/servlet-api.jar" \
  org.apache.jasper.JspC \
  -webapp /opt/apps/myapp \
  -d /tmp/jspc-output \
  -p com.miempresa.jsp \
  -compile \
  -source 17 \
  -target 17
```

### 9.4.2 Caché de recursos estáticos del DefaultServlet

```xml
<!-- conf/web.xml global — DefaultServlet con caché optimizado -->
<servlet>
    <servlet-name>default</servlet-name>
    <servlet-class>org.apache.catalina.servlets.DefaultServlet</servlet-class>
    <init-param>
        <param-name>listings</param-name>
        <param-value>false</param-value>
    </init-param>
    <!-- Caché de metadatos de archivos (5 segundos) -->
    <init-param>
        <param-name>cacheTtl</param-name>
        <param-value>5000</param-value>
    </init-param>
    <!-- Tamaño máximo del caché de recursos en KB (100 MB) -->
    <init-param>
        <param-name>cacheMaxSize</param-name>
        <param-value>102400</param-value>
    </init-param>
    <!-- Tamaño máximo por objeto en KB (512 KB) -->
    <init-param>
        <param-name>cacheObjectMaxSize</param-name>
        <param-value>512</param-value>
    </init-param>
    <!-- Buffer de lectura en KB -->
    <init-param>
        <param-name>input</param-name>
        <param-value>4096</param-value>
    </init-param>
    <!-- Buffer de escritura en KB -->
    <init-param>
        <param-name>output</param-name>
        <param-value>4096</param-value>
    </init-param>
    <!-- Soporte Range requests para descargas parciales -->
    <init-param>
        <param-name>useAcceptRanges</param-name>
        <param-value>true</param-value>
    </init-param>
    <!-- Compresión de recursos estáticos -->
    <init-param>
        <param-name>gzip</param-name>
        <param-value>true</param-value>
    </init-param>
    <load-on-startup>1</load-on-startup>
</servlet>
```

---

## 9.5 Monitorización con JMX

### 9.5.1 Configuración de JMX Remoto

```bash
# setenv.sh — Configuración JMX remoto seguro
# ============================================================
# OPCIÓN A: JMX sin autenticación (solo red interna / localhost)
# ============================================================
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote"
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.port=9090"
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.rmi.port=9090"
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.ssl=false"
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.authenticate=false"
CATALINA_OPTS="$CATALINA_OPTS -Djava.rmi.server.hostname=127.0.0.1"

# ============================================================
# OPCIÓN B: JMX con autenticación (recomendado para producción)
# ============================================================
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote"
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.port=9090"
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.rmi.port=9090"
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.ssl=true"
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.authenticate=true"
CATALINA_OPTS="$CATALINA_OPTS \
  -Dcom.sun.management.jmxremote.password.file=${CATALINA_BASE}/conf/jmxremote.password"
CATALINA_OPTS="$CATALINA_OPTS \
  -Dcom.sun.management.jmxremote.access.file=${CATALINA_BASE}/conf/jmxremote.access"
CATALINA_OPTS="$CATALINA_OPTS -Djava.rmi.server.hostname=192.168.1.101"
```

```properties
# conf/jmxremote.password (permisos 600, propietario tomcat)
monitor  monitorpass123
admin    adminpass456
```

```properties
# conf/jmxremote.access
monitor  readonly
admin    readwrite
```

```bash
# Permisos obligatorios para jmxremote.password
chmod 600 $CATALINA_BASE/conf/jmxremote.password
chown tomcat:tomcat $CATALINA_BASE/conf/jmxremote.password
```

### 9.5.2 Catálogo completo de MBeans de Tomcat

```java
package com.miempresa.monitoring;

import javax.management.*;
import javax.management.remote.*;
import java.lang.management.*;
import java.util.*;
import java.util.logging.Logger;

/**
 * Cliente JMX completo para monitorización de Tomcat.
 * Puede conectarse localmente (mismo proceso) o remotamente.
 */
public class TomcatJmxMonitor {

    private static final Logger log =
        Logger.getLogger(TomcatJmxMonitor.class.getName());

    private final MBeanServerConnection mbsc;

    // Constructor para conexión local (mismo proceso)
    public TomcatJmxMonitor() {
        this.mbsc = ManagementFactory.getPlatformMBeanServer();
    }

    // Constructor para conexión remota
    public TomcatJmxMonitor(String host, int port,
                             String user, String password)
            throws Exception {
        JMXServiceURL url = new JMXServiceURL(
            "service:jmx:rmi:///jndi/rmi://" + host + ":" + port + "/jmxrmi"
        );

        Map<String, Object> env = new HashMap<>();
        if (user != null) {
            env.put(JMXConnector.CREDENTIALS,
                new String[]{user, password});
        }

        JMXConnector connector = JMXConnectorFactory.connect(url, env);
        this.mbsc = connector.getMBeanServerConnection();
    }

    // =========================================================
    // MÉTRICAS DEL CONECTOR HTTP
    // =========================================================

    public void printConnectorMetrics(String connectorName) throws Exception {
        // Thread Pool
        ObjectName threadPool = new ObjectName(
            "Catalina:type=ThreadPool,name=\"" + connectorName + "\""
        );

        int maxThreads      = (int)  mbsc.getAttribute(threadPool, "maxThreads");
        int currentThreads  = (int)  mbsc.getAttribute(threadPool, "currentThreadCount");
        int busyThreads     = (int)  mbsc.getAttribute(threadPool, "currentThreadsBusy");
        int connectionCount = (int)  mbsc.getAttribute(threadPool, "connectionCount");
        long maxConnections = (long) mbsc.getAttribute(threadPool, "maxConnections");

        // Request Processor
        ObjectName reqProc = new ObjectName(
            "Catalina:type=GlobalRequestProcessor,name=\"" + connectorName + "\""
        );

        long requestCount   = (long) mbsc.getAttribute(reqProc, "requestCount");
        long errorCount     = (long) mbsc.getAttribute(reqProc, "errorCount");
        long processingTime = (long) mbsc.getAttribute(reqProc, "processingTime");
        long maxTime        = (long) mbsc.getAttribute(reqProc, "maxTime");
        long bytesReceived  = (long) mbsc.getAttribute(reqProc, "bytesReceived");
        long bytesSent      = (long) mbsc.getAttribute(reqProc, "bytesSent");

        double avgResponseMs = requestCount > 0
            ? (double) processingTime / requestCount : 0;
        double errorRate     = requestCount > 0
            ? (double) errorCount / requestCount * 100 : 0;
        double threadUsage   = maxThreads > 0
            ? (double) busyThreads / maxThreads * 100 : 0;

        log.info(String.format("""
            ═══════════════════════════════════════
             Conector: %s
            ═══════════════════════════════════════
             Hilos:
               Máximo:       %d
               Total:        %d
               Ocupados:     %d (%.1f%%)
             Conexiones:
               Activas:      %d / %d
             Peticiones:
               Total:        %d
               Errores:      %d (%.2f%%)
               Avg resp:     %.2f ms
               Max resp:     %d ms
             Tráfico:
               Recibido:     %.2f MB
               Enviado:      %.2f MB
            ═══════════════════════════════════════
            """,
            connectorName,
            maxThreads, currentThreads, busyThreads, threadUsage,
            connectionCount, maxConnections,
            requestCount, errorCount, errorRate,
            avgResponseMs, maxTime,
            bytesReceived  / 1024.0 / 1024.0,
            bytesSent      / 1024.0 / 1024.0
        ));
    }

    // =========================================================
    // MÉTRICAS DE SESIONES
    // =========================================================

    public void printSessionMetrics() throws Exception {
        Set<ObjectName> managers = mbsc.queryNames(
            new ObjectName("Catalina:type=Manager,*"), null
        );

        for (ObjectName name : managers) {
            String context       = name.getKeyProperty("context");
            String host          = name.getKeyProperty("host");
            int activeSessions   = (int)  mbsc.getAttribute(name, "activeSessions");
            int expiredSessions  = (int)  mbsc.getAttribute(name, "expiredSessions");
            int maxActive        = (int)  mbsc.getAttribute(name, "maxActive");
            long sessionCounter  = (long) mbsc.getAttribute(name, "sessionCounter");
            int rejectedSessions = (int)  mbsc.getAttribute(name, "rejectedSessions");

            log.info(String.format("""
                Sesiones [%s%s]:
                  Activas:    %d (max histórico: %d)
                  Expiradas:  %d
                  Rechazadas: %d
                  Total:      %d
                """,
                host, context,
                activeSessions, maxActive,
                expiredSessions, rejectedSessions,
                sessionCounter));
        }
    }

    // =========================================================
    // MÉTRICAS DE JVM
    // =========================================================

    public void printJvmMetrics() throws Exception {
        // Heap Memory
        MemoryMXBean memBean = ManagementFactory.getMemoryMXBean();
        MemoryUsage heap    = memBean.getHeapMemoryUsage();
        MemoryUsage nonHeap = memBean.getNonHeapMemoryUsage();

        // GC
        List<GarbageCollectorMXBean> gcBeans =
            ManagementFactory.getGarbageCollectorMXBeans();

        // Threads
        ThreadMXBean threadBean = ManagementFactory.getThreadMXBean();

        // Runtime
        RuntimeMXBean runtimeBean = ManagementFactory.getRuntimeMXBean();

        long uptime = runtimeBean.getUptime();

        log.info(String.format("""
            ═══════════════════════════════════════
             JVM Metrics
            ═══════════════════════════════════════
             Uptime: %d h %d m %d s

             Heap Memory:
               Used:       %.2f MB
               Committed:  %.2f MB
               Max:        %.2f MB
               Usage:      %.1f%%

             Non-Heap (Metaspace):
               Used:       %.2f MB
               Committed:  %.2f MB

             Threads:
               Total:      %d
               Daemon:     %d
               Peak:       %d
               Deadlocked: %s
            ═══════════════════════════════════════
            """,
            uptime / 3600000,
            (uptime % 3600000) / 60000,
            (uptime % 60000) / 1000,

            heap.getUsed()      / 1024.0 / 1024.0,
            heap.getCommitted() / 1024.0 / 1024.0,
            heap.getMax()       / 1024.0 / 1024.0,
            (double) heap.getUsed() / heap.getMax() * 100,

            nonHeap.getUsed()      / 1024.0 / 1024.0,
            nonHeap.getCommitted() / 1024.0 / 1024.0,

            threadBean.getThreadCount(),
            threadBean.getDaemonThreadCount(),
            threadBean.getPeakThreadCount(),
            threadBean.findDeadlockedThreads() != null
                ? "⚠️ DETECTADO" : "Ninguno"
        ));

        // GC detalle
        for (GarbageCollectorMXBean gc : gcBeans) {
            log.info(String.format(
                "GC [%s]: colecciones=%d, tiempo=%d ms",
                gc.getName(),
                gc.getCollectionCount(),
                gc.getCollectionTime()
            ));
        }
    }

    // =========================================================
    // MÉTRICAS DE APLICACIONES (Contexts)
    // =========================================================

    public void printApplicationMetrics() throws Exception {
        Set<ObjectName> contexts = mbsc.queryNames(
            new ObjectName("Catalina:type=Context,*"), null
        );

        for (ObjectName name : contexts) {
            String path    = (String)  mbsc.getAttribute(name, "path");
            String docBase = (String)  mbsc.getAttribute(name, "docBase");
            String state   = (String)  mbsc.getAttribute(name, "stateName");
            boolean available = (boolean) mbsc.getAttribute(name, "available");

            log.info(String.format(
                "Aplicación: path=%-20s state=%-10s available=%b docBase=%s",
                path, state, available, docBase
            ));
        }
    }

    // =========================================================
    // DETECCIÓN DE HILOS BLOQUEADOS
    // =========================================================

    public void detectStuckThreads() throws Exception {
        Set<ObjectName> stuckValves = mbsc.queryNames(
            new ObjectName("Catalina:type=Valve,*StuckThreadDetection*"),
            null
        );

        for (ObjectName name : stuckValves) {
            String[] stuckThreads = (String[])
                mbsc.getAttribute(name, "stuckThreadNames");

            if (stuckThreads != null && stuckThreads.length > 0) {
                log.warning("⚠️ HILOS BLOQUEADOS DETECTADOS:");
                for (String thread : stuckThreads) {
                    log.warning("  → " + thread);
                }
            } else {
                log.info("✅ No hay hilos bloqueados");
            }
        }
    }

    // =========================================================
    // OPERACIONES JMX (invocar métodos)
    // =========================================================

    public void reloadApplication(String contextPath) throws Exception {
        Set<ObjectName> contexts = mbsc.queryNames(
            new ObjectName("Catalina:type=Manager,context=" + contextPath + ",*"),
            null
        );

        for (ObjectName name : contexts) {
            // Obtener el Host y Context para la operación
            ObjectName contextObj = new ObjectName(
                "Catalina:type=Context,context=" + contextPath
                    + ",host=localhost"
            );

            // Ejecutar reload via JMX
            mbsc.invoke(contextObj, "reload", null, null);
            log.info("Aplicación recargada: " + contextPath);
        }
    }

    public void expireSessions(String host,
                               String context,
                               int idleMinutes) throws Exception {
        ObjectName managerName = new ObjectName(
            "Catalina:type=Manager,context=" + context
                + ",host=" + host
        );

        mbsc.invoke(
            managerName,
            "expireSession",
            new Object[]{idleMinutes},
            new String[]{"int"}
        );

        log.info("Sesiones expiradas (idle > " + idleMinutes + " min) en: "
            + host + context);
    }
}
```

---

## 9.6 Profiling con Java Flight Recorder (JFR)

Java Flight Recorder es la herramienta de profiling de producción incluida en el JDK desde Java 11 (libre). Tiene un overhead < 1% en producción.

### 9.6.1 Uso de JFR

```bash
# ============================================================
# MÉTODO 1: Activar JFR al arrancar Tomcat (en setenv.sh)
# ============================================================
CATALINA_OPTS="$CATALINA_OPTS \
  -XX:+FlightRecorder \
  -XX:StartFlightRecording=\
    duration=0,\
    filename=${CATALINA_BASE}/logs/tomcat-$(date +%Y%m%d).jfr,\
    settings=profile,\
    maxsize=500m,\
    maxage=24h,\
    name=TomcatRecording"

# ============================================================
# MÉTODO 2: Iniciar/detener grabación en caliente via jcmd
# ============================================================

# Encontrar el PID de Tomcat
TOMCAT_PID=$(pgrep -f catalina)
echo "Tomcat PID: $TOMCAT_PID"

# Ver grabaciones activas
jcmd $TOMCAT_PID JFR.check

# Iniciar grabación de 5 minutos
jcmd $TOMCAT_PID JFR.start \
  name=ProfilingSession \
  duration=5m \
  filename=/tmp/tomcat-profile.jfr \
  settings=profile

# Volcar grabación en cualquier momento
jcmd $TOMCAT_PID JFR.dump \
  name=ProfilingSession \
  filename=/tmp/tomcat-dump.jfr

# Detener grabación
jcmd $TOMCAT_PID JFR.stop \
  name=ProfilingSession \
  filename=/tmp/tomcat-final.jfr

# ============================================================
# MÉTODO 3: JFR vía JMX (programático)
# ============================================================
# Usar FlightRecorderMXBean para control programático
```

### 9.6.2 Análisis de JFR con jfr CLI

```bash
# Ver resumen del archivo JFR
jfr summary /tmp/tomcat-profile.jfr

# Ver eventos específicos (top métodos por CPU)
jfr print --events jdk.ExecutionSample \
  --stack-depth 5 \
  /tmp/tomcat-profile.jfr | head -100

# Ver eventos de GC
jfr print --events jdk.GarbageCollection \
  /tmp/tomcat-profile.jfr

# Ver eventos de bloqueo de hilos
jfr print --events jdk.ThreadPark,jdk.JavaMonitorWait \
  /tmp/tomcat-profile.jfr

# Exportar a formato legible
jfr print --json /tmp/tomcat-profile.jfr > /tmp/tomcat-profile.json

# Abrir en JDK Mission Control (JMC)
# jmc &
# File → Open → tomcat-profile.jfr
```

---

## 9.7 Herramientas de Load Testing

### 9.7.1 Apache JMeter — Plan de prueba para Tomcat

```xml
<?xml version="1.0" encoding="UTF-8"?>
<jmeterTestPlan version="1.2" properties="5.0">
  <hashTree>
    <TestPlan guiclass="TestPlanGui"
              testclass="TestPlan"
              testname="Tomcat Load Test Plan">

      <elementProp name="TestPlan.user_defined_variables"
                   elementType="Arguments">
        <collectionProp name="Arguments.arguments">
          <elementProp name="HOST" elementType="Argument">
            <stringProp name="Argument.name">HOST</stringProp>
            <stringProp name="Argument.value">app.miempresa.com</stringProp>
          </elementProp>
          <elementProp name="PORT" elementType="Argument">
            <stringProp name="Argument.name">PORT</stringProp>
            <stringProp name="Argument.value">8443</stringProp>
          </elementProp>
          <elementProp name="THREADS" elementType="Argument">
            <stringProp name="Argument.name">THREADS</stringProp>
            <stringProp name="Argument.value">200</stringProp>
          </elementProp>
          <elementProp name="RAMP_UP" elementType="Argument">
            <stringProp name="Argument.name">RAMP_UP</stringProp>
            <stringProp name="Argument.value">60</stringProp>
          </elementProp>
          <elementProp name="DURATION" elementType="Argument">
            <stringProp name="Argument.name">DURATION</stringProp>
            <stringProp name="Argument.value">300</stringProp>
          </elementProp>
        </collectionProp>
      </elementProp>

    </TestPlan>
    <hashTree>

      <!-- Grupo de hilos principal -->
      <ThreadGroup guiclass="ThreadGroupGui"
                   testname="Usuarios Concurrentes"
                   enabled="true">
        <intProp name="ThreadGroup.num_threads">${THREADS}</intProp>
        <intProp name="ThreadGroup.ramp_time">${RAMP_UP}</intProp>
        <boolProp name="ThreadGroup.scheduler">true</boolProp>
        <stringProp name="ThreadGroup.duration">${DURATION}</stringProp>
      </ThreadGroup>

      <hashTree>
        <!-- Petición HTTP GET -->
        <HTTPSamplerProxy testname="GET /api/users">
          <stringProp name="HTTPSampler.domain">${HOST}</stringProp>
          <stringProp name="HTTPSampler.port">${PORT}</stringProp>
          <stringProp name="HTTPSampler.protocol">https</stringProp>
          <stringProp name="HTTPSampler.path">/myapp/api/users</stringProp>
          <stringProp name="HTTPSampler.method">GET</stringProp>
          <boolProp name="HTTPSampler.use_keepalive">true</boolProp>
        </HTTPSamplerProxy>

        <!-- Assertions -->
        <ResponseAssertion testname="Verificar HTTP 200">
          <collectionProp name="Asserion.test_strings">
            <stringProp>200</stringProp>
          </collectionProp>
          <intProp name="Assertion.test_type">8</intProp>
          <stringProp name="Assertion.test_field">
            Assertion.response_code
          </stringProp>
        </ResponseAssertion>

        <DurationAssertion testname="Verificar tiempo < 2s">
          <stringProp name="DurationAssertion.duration">2000</stringProp>
        </DurationAssertion>

      </hashTree>
    </hashTree>
  </hashTree>
</jmeterTestPlan>
```

```bash
# Ejecutar JMeter en modo non-GUI (producción)
jmeter -n \
  -t tomcat-load-test.jmx \
  -l /tmp/results-$(date +%Y%m%d-%H%M%S).jtl \
  -e \
  -o /tmp/jmeter-report-$(date +%Y%m%d-%H%M%S) \
  -Jthreads=200 \
  -Jramp_up=60 \
  -Jduration=300 \
  -JHOST=app.miempresa.com \
  -JPORT=8443

# Ver resultados en tiempo real
tail -f /tmp/results-*.jtl
```

### 9.7.2 wrk — Load testing de alto rendimiento

```bash
# Instalación
sudo apt-get install -y wrk

# Test básico: 200 conexiones, 12 hilos, 60 segundos
wrk -t12 -c200 -d60s \
  --latency \
  https://app.miempresa.com/myapp/api/health

# Test con script Lua personalizado (con headers)
cat > test-api.lua << 'LUA'
wrk.method  = "GET"
wrk.headers["Authorization"] = "Bearer mi-token-jwt"
wrk.headers["Content-Type"]  = "application/json"
wrk.headers["Accept"]        = "application/json"

function response(status, headers, body)
    if status ~= 200 then
        io.write("Error HTTP " .. status .. ": " .. body .. "\n")
    end
end
LUA

wrk -t12 -c200 -d60s \
  --latency \
  --script test-api.lua \
  https://app.miempresa.com/myapp/api/users

# Salida esperada:
# Running 1m test @ https://app.miempresa.com/myapp/api/users
#   12 threads and 200 connections
#   Thread Stats   Avg      Stdev     Max    +/- Stdev
#     Latency    45.23ms   12.34ms 234.56ms   89.12%
#     Req/Sec   456.78     34.56   512.00     78.34%
#   Latency Distribution
#      50%   42.12ms
#      75%   51.23ms
#      90%   62.34ms
#      99%  123.45ms
#   164,456 requests in 1.00m, 234.56MB read
# Requests/sec: 2,740.93
# Transfer/sec:  3.91MB
```

---

## 9.8 Integración con Prometheus y Grafana

### 9.8.1 Exposición de métricas con JMX Exporter

```yaml
# jmx-exporter-config.yaml
# Configuración del JMX Prometheus Exporter para Tomcat

---
startDelaySeconds: 0
hostPort: 127.0.0.1:9090
ssl: false

rules:
  # ===== Thread Pool del Conector =====
  - pattern: 'Catalina<type=ThreadPool, name="(\w+-\w+-\d+)"><>(currentThreadCount|currentThreadsBusy|maxThreads|connectionCount|maxConnections)'
    name: tomcat_threadpool_$2
    labels:
      connector: $1
    type: GAUGE

  # ===== Request Processor =====
  - pattern: 'Catalina<type=GlobalRequestProcessor, name="(\w+-\w+-\d+)"><>(requestCount|errorCount|processingTime|bytesSent|bytesReceived|maxTime)'
    name: tomcat_request_$2_total
    labels:
      connector: $1
    type: COUNTER

  # ===== Session Manager =====
  - pattern: 'Catalina<type=Manager, host=(\w+), context=(.+)><>(activeSessions|expiredSessions|sessionCounter|rejectedSessions|maxActive)'
    name: tomcat_session_$3
    labels:
      host: $1
      context: $2
    type: GAUGE

  # ===== JVM Heap =====
  - pattern: 'java.lang<type=Memory><HeapMemoryUsage>(used|committed|max)'
    name: jvm_heap_memory_$1_bytes
    type: GAUGE

  # ===== JVM GC =====
  - pattern: 'java.lang<type=GarbageCollector, name=(.+)><>(CollectionCount|CollectionTime)'
    name: jvm_gc_$2_total
    labels:
      gc: $1
    type: COUNTER

  # ===== JVM Threads =====
  - pattern: 'java.lang<type=Threading><>(ThreadCount|DaemonThreadCount|PeakThreadCount)'
    name: jvm_threads_$1
    type: GAUGE

  # ===== DataSource Pool =====
  - pattern: 'Catalina<type=DataSource, class=javax.sql.DataSource, name="(.+)".*><>(numActive|numIdle|maxTotal|minIdle|maxIdle)'
    name: tomcat_datasource_$2
    labels:
      pool: $1
    type: GAUGE
```

```bash
# setenv.sh — Añadir JMX Exporter como Java Agent
JAVA_AGENT_JAR="/opt/jmx-exporter/jmx_prometheus_javaagent-0.20.0.jar"
JAVA_AGENT_CONFIG="/opt/jmx-exporter/jmx-exporter-config.yaml"
JAVA_AGENT_PORT="9100"

CATALINA_OPTS="$CATALINA_OPTS \
  -javaagent:${JAVA_AGENT_JAR}=${JAVA_AGENT_PORT}:${JAVA_AGENT_CONFIG}"
```

### 9.8.2 Dashboard Grafana — Métricas clave

```json
{
  "title": "Tomcat Performance Dashboard",
  "panels": [
    {
      "title": "Thread Pool Usage",
      "type": "graph",
      "targets": [
        {
          "expr": "tomcat_threadpool_currentThreadsBusy{job='tomcat'}",
          "legendFormat": "Busy Threads - {{connector}}"
        },
        {
          "expr": "tomcat_threadpool_maxThreads{job='tomcat'}",
          "legendFormat": "Max Threads - {{connector}}"
        }
      ]
    },
    {
      "title": "Request Rate (RPS)",
      "type": "graph",
      "targets": [
        {
          "expr": "rate(tomcat_request_requestCount_total{job='tomcat'}[1m])",
          "legendFormat": "Requests/sec - {{connector}}"
        }
      ]
    },
    {
      "title": "Error Rate (%)",
      "type": "gauge",
      "targets": [
        {
          "expr": "rate(tomcat_request_errorCount_total[1m]) / rate(tomcat_request_requestCount_total[1m]) * 100",
          "legendFormat": "Error %"
        }
      ]
    },
    {
      "title": "Average Response Time (ms)",
      "type": "graph",
      "targets": [
        {
          "expr": "rate(tomcat_request_processingTime_total[1m]) / rate(tomcat_request_requestCount_total[1m])",
          "legendFormat": "Avg Response ms"
        }
      ]
    },
    {
      "title": "Active Sessions",
      "type": "graph",
      "targets": [
        {
          "expr": "tomcat_session_activeSessions{job='tomcat'}",
          "legendFormat": "Active Sessions - {{context}}"
        }
      ]
    },
    {
      "title": "JVM Heap Usage",
      "type": "graph",
      "targets": [
        {
          "expr": "jvm_heap_memory_used_bytes / jvm_heap_memory_max_bytes * 100",
          "legendFormat": "Heap Usage %"
        }
      ]
    },
    {
      "title": "GC Pause Time (ms/min)",
      "type": "graph",
      "targets": [
        {
          "expr": "rate(jvm_gc_CollectionTime_total[1m]) * 1000",
          "legendFormat": "GC Time ms/min - {{gc}}"
        }
      ]
    },
    {
      "title": "Connection Pool Active",
      "type": "graph",
      "targets": [
        {
          "expr": "tomcat_datasource_numActive{job='tomcat'}",
          "legendFormat": "Active Connections - {{pool}}"
        }
      ]
    }
  ]
}
```

---

## 9.9 Script de Diagnóstico de Rendimiento Completo

```bash
#!/bin/bash
# tomcat-perf-check.sh
# Diagnóstico completo de rendimiento de una instancia Tomcat

set -euo pipefail

TOMCAT_HOST="${1:-localhost}"
TOMCAT_PORT="${2:-8080}"
MANAGER_USER="${MANAGER_USER:-admin}"
MANAGER_PASS="${MANAGER_PASS:-password}"
APP_PATH="${3:-/myapp}"
CATALINA_BASE="${CATALINA_BASE:-/opt/tomcat}"

echo "╔══════════════════════════════════════════════════════╗"
echo "║     Diagnóstico de Rendimiento — Apache Tomcat       ║"
echo "║     Host: $TOMCAT_HOST:$TOMCAT_PORT                  "
echo "║     $(date)                                          "
echo "╚══════════════════════════════════════════════════════╝"
echo ""

# ===== 1. ESTADO DEL PROCESO =====
echo "━━━ 1. Proceso Tomcat ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
TOMCAT_PID=$(pgrep -f catalina.jar || pgrep -f bootstrap.jar || echo "")

if [ -z "$TOMCAT_PID" ]; then
    echo "  ❌ Tomcat NO está corriendo"
    exit 1
fi

echo "  PID: $TOMCAT_PID"
echo "  Uptime: $(ps -p $TOMCAT_PID -o etime= 2>/dev/null || echo 'N/A')"
echo "  CPU: $(ps -p $TOMCAT_PID -o %cpu= 2>/dev/null || echo 'N/A')%"
echo "  MEM: $(ps -p $TOMCAT_PID -o %mem= 2>/dev/null || echo 'N/A')%"
echo "  RSS: $(ps -p $TOMCAT_PID -o rss= 2>/dev/null \
             | awk '{printf "%.1f MB\n", $1/1024}' || echo 'N/A')"

echo ""

# ===== 2. PUERTOS =====
echo "━━━ 2. Puertos en Escucha ━━━━━━━━━━━━━━━━━━━━━━━━━━━"
ss -tlnp | grep java | awk '{print "  " $4}' || echo "  (ss no disponible)"

echo ""

# ===== 3. TIEMPO DE RESPUESTA =====
echo "━━━ 3. Tiempo de Respuesta ━━━━━━━━━━━━━━━━━━━━━━━━━━"

for endpoint in "/health" "$APP_PATH/health" "/manager/text/serverinfo"; do
    RESULT=$(curl -s -o /dev/null -w "%{http_code}|%{time_total}|%{time_connect}" \
        -u "$MANAGER_USER:$MANAGER_PASS" \
        --connect-timeout 5 --max-time 10 \
        "http://$TOMCAT_HOST:$TOMCAT_PORT$endpoint" 2>/dev/null \
        || echo "000|99.999|99.999")

    HTTP_CODE=$(echo $RESULT | cut -d'|' -f1)
    TIME_TOTAL=$(echo $RESULT | cut -d'|' -f2)
    TIME_CONN=$(echo $RESULT | cut -d'|' -f3)

    STATUS_ICON="✅"
    [ "$HTTP_CODE" != "200" ] && STATUS_ICON="⚠️"
    [ "$HTTP_CODE" = "000" ] && STATUS_ICON="❌"

    echo "  $STATUS_ICON $endpoint → HTTP $HTTP_CODE | Total: ${TIME_TOTAL}s | Connect: ${TIME_CONN}s"
done

echo ""

# ===== 4. MEMORIA JVM =====
echo "━━━ 4. Memoria JVM ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if command -v jcmd &>/dev/null; then
    jcmd $TOMCAT_PID VM.native_memory summary 2>/dev/null | head -20 \
        || echo "  NMT no habilitado (añadir -XX:NativeMemoryTracking=summary)"

    echo ""
    echo "  GC Summary:"
    jcmd $TOMCAT_PID GC.heap_info 2>/dev/null \
        | awk '{print "  " $0}' \
        || echo "  (jcmd GC.heap_info no disponible)"
fi

echo ""

# ===== 5. HILOS =====
echo "━━━ 5. Hilos del Proceso ━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if command -v jstack &>/dev/null; then
    TOTAL_THREADS=$(jstack $TOMCAT_PID 2>/dev/null \
        | grep "^\"" | wc -l || echo "N/A")
    BLOCKED_THREADS=$(jstack $TOMCAT_PID 2>/dev/null \
        | grep "BLOCKED" | wc -l || echo "0")
    WAITING_THREADS=$(jstack $TOMCAT_PID 2>/dev/null \
        | grep "WAITING" | wc -l || echo "0")
    RUNNABLE_THREADS=$(jstack $TOMCAT_PID 2>/dev/null \
        | grep "RUNNABLE" | wc -l || echo "0")

    echo "  Total:     $TOTAL_THREADS"
    echo "  Runnable:  $RUNNABLE_THREADS"
    echo "  Waiting:   $WAITING_THREADS"
    if [ "$BLOCKED_THREADS" -gt 0 ] 2>/dev/null; then
        echo "  ⚠️  Bloqueados: $BLOCKED_THREADS (investigar)"
    else
        echo "  Bloqueados: $BLOCKED_THREADS"
    fi
fi

echo ""

# ===== 6. LOGS RECIENTES =====
echo "━━━ 6. Errores Recientes en Logs (últimas 2h) ━━━━━━━"
if [ -f "$CATALINA_BASE/logs/catalina.out" ]; then
    ERROR_COUNT=$(find "$CATALINA_BASE/logs" -name "catalina.out" \
        -newer /tmp/.2h_ago_marker 2>/dev/null \
        | xargs grep -c "SEVERE\|Exception\|OutOfMemory" 2>/dev/null \
        | awk -F: '{sum+=$2} END {print sum}' || echo "0")

    echo "  Errores SEVERE/Exception (2h): $ERROR_COUNT"

    # Últimas líneas de error
    echo "  Últimos errores:"
    grep -i "SEVERE\|OutOfMemory\|Exception" \
        "$CATALINA_BASE/logs/catalina.out" \
        2>/dev/null | tail -5 \
        | awk '{print "    " $0}' \
        || echo "    (No se pueden leer los logs)"
fi

echo ""

# ===== 7. MÉTRICAS VIA MANAGER =====
echo "━━━ 7. Aplicaciones Desplegadas ━━━━━━━━━━━━━━━━━━━━"
MANAGER_LIST=$(curl -s \
    -u "$MANAGER_USER:$MANAGER_PASS" \
    --connect-timeout 5 --max-time 10 \
    "http://$TOMCAT_HOST:$TOMCAT_PORT/manager/text/list" 2>/dev/null \
    || echo "ERROR")

if echo "$MANAGER_LIST" | grep -q "^OK"; then
    echo "$MANAGER_LIST" | grep -v "^OK" | grep -v "^$" \
        | awk -F: '{printf "  %-30s %-10s sessions=%-6s\n", $1, $2, $3}'
else
    echo "  Manager no accesible (verificar credenciales o permisos IP)"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Diagnóstico completado: $(date)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
```

---

## 9.10 Tabla de Referencia Rápida de Tuning

### Valores recomendados según carga

| Parámetro                       | Baja carga     | Carga media      | Alta carga        |
|---------------------------------|----------------|------------------|-------------------|
| `maxThreads`                    | 100            | 200-300          | 400-500           |
| `minSpareThreads`               | 10             | 25               | 50                |
| `maxConnections`                | 5000           | 10000            | 15000-20000       |
| `acceptCount`                   | 100            | 200              | 300-500           |
| `connectionTimeout` (ms)        | 30000          | 20000            | 10000-15000       |
| `keepAliveTimeout` (ms)         | 60000          | 30000            | 15000-20000       |
| `maxKeepAliveRequests`          | 100            | 200              | 500               |
| Heap `-Xmx`                     | 512m-1g        | 2g-4g            | 4g-8g             |
| `MaxGCPauseMillis` (G1GC)       | 500            | 200              | 100               |
| Pool BD `maxTotal`              | 10             | 30-50            | 50-100            |
| Pool BD `testOnBorrow`          | true           | true             | true              |
| `compressionMinSize` (bytes)    | 4096           | 2048             | 1024              |
| `cacheTtl` DefaultServlet (ms)  | 0 (dev)        | 5000             | 30000             |
| `cacheMaxSize` (KB)             | 10240          | 51200            | 102400            |

---

## 9.11 Diferencias de Rendimiento y Monitorización entre Versiones

| Característica                          | 8.0   | 8.5   | 9.0   | 10.x  | 11.0  |
|-----------------------------------------|-------|-------|-------|-------|-------|
| NIO2 Connector                          | ✅    | ✅    | ✅    | ✅    | ✅    |
| HTTP/2 (UpgradeProtocol)                | ❌    | ✅    | ✅    | ✅    | ✅    |
| JFR integrado (JDK 11+)                 | ❌    | ❌    | ✅*   | ✅    | ✅    |
| ZGC soporte                             | ❌    | ❌    | ✅*   | ✅    | ✅    |
| Virtual Threads Executor                | ❌    | ❌    | ❌    | ❌    | ✅    |
| OpenSSL via FFM (rendimiento TLS)       | ❌    | ❌    | ❌    | ❌    | ✅    |
| StuckThreadDetectionValve               | ✅    | ✅    | ✅    | ✅    | ✅    |
| JMX MBeans completos                    | ✅    | ✅    | ✅    | ✅    | ✅    |
| AsyncFileHandler (JULI)                 | ❌    | ✅    | ✅    | ✅    | ✅    |
| SSL reload sin reinicio                 | ❌    | ✅    | ✅    | ✅    | ✅    |
| `maxParameterCount` Conector            | ❌    | ✅    | ✅    | ✅    | ✅    |
| G1GC default JVM                        | ❌    | ❌    | ✅*   | ✅    | ✅    |
| Generational ZGC                        | ❌    | ❌    | ❌    | ❌    | ✅**  |

*Requiere JDK específico  
**Requiere JDK 21+

---

## Puntos Clave

- El tuning efectivo requiere **medir primero**. El cuello de botella más frecuente es la base de datos, no Tomcat.
- **`Xms = Xmx`** en producción para eliminar la expansión dinámica del heap que causa pausas GC adicionales.
- **G1GC** es el GC recomendado para la mayoría de deployments. **ZGC** para aplicaciones con requisitos de latencia sub-milisegundo.
- El **`maxThreads`** óptimo se calcula como: `TPS_objetivo × tiempo_respuesta_segundos + margen`. No aumentarlo indiscriminadamente.
- **Java Flight Recorder** es la herramienta de profiling de producción con overhead < 1%. Activar en todos los entornos de producción.
- Los **MBeans JMX** de Tomcat exponen todas las métricas operativas. Integrar con Prometheus + Grafana para monitorización continua.
- El **JMX Exporter** de Prometheus como Java Agent es la forma más sencilla de exponer métricas JMX en formato Prometheus sin modificar el código.
- **`StuckThreadDetectionValve`** es obligatorio en producción para detectar hilos bloqueados en operaciones externas (BD, servicios, filesystem).
- El **AsyncFileHandler** de JULI reduce el overhead de logging al escribir en un buffer asíncrono. Usar en producción con `buffered=true`.
- Los **Virtual Threads de Tomcat 11** (Java 21+) eliminan el límite práctico de `maxThreads` para cargas I/O-bound, siendo la evolución natural del modelo thread-per-request.